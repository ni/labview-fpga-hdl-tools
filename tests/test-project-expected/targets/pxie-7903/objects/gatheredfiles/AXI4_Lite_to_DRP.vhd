-- 
-- This file was automatically processed for release on GitHub
-- All comments were removed and this header was added
-- 
-- 
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
-- 
-- 



























library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity AXI4_Lite_to_DRP is
generic(
    kADDR_SIZE : integer := 9
);
port(
    
    s_aclk            : in  std_logic;

    
    aReset_n          : in  std_logic;

    
    s_axi_awaddr  : in  std_logic_vector(31 downto 0);
    s_axi_awvalid : in  std_logic;
    s_axi_awready : out std_logic;
    s_axi_wdata   : in  std_logic_vector(31 downto 0);
    s_axi_wvalid  : in  std_logic;
    s_axi_wready  : out std_logic;
    s_axi_bready  : in  std_logic;
    s_axi_bvalid  : out std_logic;
    s_axi_araddr  : in  std_logic_vector(31 downto 0);
    s_axi_arvalid : in  std_logic;
    s_axi_arready : out std_logic;
    s_axi_rdata   : out std_logic_vector(31 downto 0) := (others => '0');
    s_axi_rready  : in  std_logic;
    s_axi_rvalid  : out std_logic;

    
    drpaddr_in    : out std_logic_vector(kADDR_SIZE-1 downto 0);
    drpdi_in      : out std_logic_vector(15 downto 0);
    drpdo_out     : in  std_logic_vector(15 downto 0);
    drprdy_out    : in  std_logic;
    drpen_in      : out std_logic;
    drpwe_in      : out std_logic
  );
end AXI4_Lite_to_DRP;

architecture rtl of AXI4_Lite_to_DRP is

  type AccessState_t is (Idle, IssueResponse);
  signal sReadState, sWriteState : AccessState_t;

  signal s_axi_rvalid_i, s_axi_bvalid_i : std_logic;
  signal sDrpWriteEn, sDrpReadEn : std_logic;

begin

  
  drpaddr_in <= s_axi_awaddr(kADDR_SIZE-1 downto 0) when sDrpWriteEn = '1' else
                s_axi_araddr(kADDR_SIZE-1 downto 0) when sDrpReadEn = '1' else
                (others => '0');

  drpdi_in <= s_axi_wdata(15 downto 0) when sDrpWriteEn = '1' else
              (others => '0');

  drpen_in <= sDrpWriteEn or sDrpReadEn;
  drpwe_in <= sDrpWriteEn;

  s_axi_rvalid <= s_axi_rvalid_i;
  s_axi_bvalid <= s_axi_bvalid_i;

  
  
  WriteAccessFsm: process(aReset_n, s_aclk) is
  begin
    if aReset_n = '0' then
      sWriteState    <= Idle;
      s_axi_awready  <= '0';
      s_axi_wready   <= '0';
      s_axi_bvalid_i <= '0';
      sDrpWriteEn    <= '0';
    elsif rising_edge(s_aclk) then
      s_axi_awready  <= '0';
      s_axi_wready   <= '0';
      sDrpWriteEn    <= '0';

      case sWriteState is
        when Idle =>
          s_axi_bvalid_i <= '0';
          if s_axi_awvalid = '1' and s_axi_wvalid = '1' then
            sWriteState   <= IssueResponse;
            s_axi_awready <= '1';
            s_axi_wready  <= '1';
            sDrpWriteEn   <= '1';
          end if;

        when IssueResponse =>
          if drprdy_out = '1' then
            s_axi_bvalid_i <= '1';
          end if;
          if s_axi_bready = '1' and s_axi_bvalid_i = '1' then
            sWriteState    <= Idle;
            s_axi_bvalid_i <= '0';
          end if;
      end case;
    end if;
  end process WriteAccessFsm;

  
  
  ReadAccessFsm: process(aReset_n, s_aclk) is
  begin
    if aReset_n = '0' then
      sReadState <= Idle;
      s_axi_arready  <= '0';
      s_axi_rvalid_i <= '0';
      s_axi_rdata    <= (others => '0');
      sDrpReadEn     <= '0';
    elsif rising_edge(s_aclk) then
      s_axi_arready     <= '0';
      sDrpReadEn     <= '0';

      case sReadState is
        when Idle =>
          s_axi_rvalid_i <= '0';
          s_axi_rdata    <= (others => '0');
          if s_axi_arvalid = '1' then
            sReadState    <= IssueResponse;
            s_axi_arready <= '1';
            sDrpReadEn    <= '1';
          end if;

        when IssueResponse =>
          if drprdy_out = '1' then
            s_axi_rvalid_i <= '1';
            s_axi_rdata(15 downto 0) <= drpdo_out;
          end if;
          if s_axi_rready = '1' and s_axi_rvalid_i = '1' then
            sReadState     <= Idle;
            s_axi_rdata    <= (others => '0');
            s_axi_rvalid_i <= '0';
          end if;
      end case;
    end if;
  end process ReadAccessFsm;
end rtl;