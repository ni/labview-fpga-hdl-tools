-- ? 2012 National Instruments Corporation.
-------------------------------------------------------------------------------
--
-- File: AXI4_Lite_to_DRP.vhd
-- Author: National Instruments
-- Original Project:
-- Date: 16 December 2015
--
-------------------------------------------------------------------------------
-- (c) 2015 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose: This component does a simple translation from the AXI4-Lite bus
--          to the Xilinx DRP bus. It holds all of the read and write 'ready'
--          signals high constantly. The DRP address and data lines are only
--          updated when the corresponding valid bits are asserted. The
--          DRP read data is only updated when DRPRDY is asserted. The
--          AXI4-Lite read data valid and write response valid signals are both
--          driven by DRPRDY. This component simply translates between the two
--          buses and assumes that the AXI4-Lite master is always ready in
--          response to an issued read or write.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity AXI4_Lite_to_DRP is
generic(
    kADDR_SIZE : integer := 9
);
port(
    -- AXI4-Lite Clock
    s_aclk            : in  std_logic;

    -- AXI Reset, active-Low
    aReset_n          : in  std_logic;

    -- AXI4-Lite Interface for DRP access
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

    -- DRP Interface
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

  -- Mux in the appropriate address and data signals
  drpaddr_in <= s_axi_awaddr(kADDR_SIZE-1 downto 0) when sDrpWriteEn = '1' else
                s_axi_araddr(kADDR_SIZE-1 downto 0) when sDrpReadEn = '1' else
                (others => '0');

  drpdi_in <= s_axi_wdata(15 downto 0) when sDrpWriteEn = '1' else
              (others => '0');

  drpen_in <= sDrpWriteEn or sDrpReadEn;
  drpwe_in <= sDrpWriteEn;

  s_axi_rvalid <= s_axi_rvalid_i;
  s_axi_bvalid <= s_axi_bvalid_i;

  -- Write Access FSM
  -- This FSM is responsible for processing AXI4-Lite write accesses.
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

  -- Read Access FSM
  -- This FSM is responsible for processing AXI4-Lite read accesses.
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
