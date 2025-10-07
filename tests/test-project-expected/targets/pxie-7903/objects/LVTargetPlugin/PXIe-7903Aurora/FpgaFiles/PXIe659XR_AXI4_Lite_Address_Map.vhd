-- 
-- This file was automatically processed for release on GitHub
-- All comments were removed and this header was added
-- 
-- 
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- All rights reserved.
-- 
-- 



























library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;

entity PXIe659XR_AXI4_Lite_Address_Map is
  generic (
    kNumEndpoints  : positive := 8;
    kAddrSelectLsb : positive := 9
  );
  port(
    
    s_aclk            : in  std_logic;

    
    aReset_n          : in  std_logic;

    
    s_axi_awaddr      : in  std_logic_vector(31 downto 0);
    s_axi_awvalid     : in  std_logic;
    s_axi_awready     : out std_logic;

    s_axi_wvalid      : in  std_logic;
    s_axi_wready      : out std_logic;

    s_axi_bvalid      : out std_logic;
    s_axi_bready      : in  std_logic;

    s_axi_araddr      : in  std_logic_vector(31 downto 0);
    s_axi_arvalid     : in  std_logic;
    s_axi_arready     : out std_logic;

    s_axi_rdata       : out std_logic_vector(31 downto 0);
    s_axi_rvalid      : out std_logic;
    s_axi_rready      : in  std_logic;

    
    s_axi_awvalid_slv : out std_logic_vector(kNumEndpoints-1 downto 0);
    s_axi_awready_slv : in  std_logic_vector(kNumEndpoints-1 downto 0);

    s_axi_wvalid_slv  : out std_logic_vector(kNumEndpoints-1 downto 0);
    s_axi_wready_slv  : in  std_logic_vector(kNumEndpoints-1 downto 0);

    s_axi_bvalid_slv  : in  std_logic_vector(kNumEndpoints-1 downto 0);
    s_axi_bready_slv  : out std_logic_vector(kNumEndpoints-1 downto 0);

    s_axi_arvalid_slv : out std_logic_vector(kNumEndpoints-1 downto 0);
    s_axi_arready_slv : in  std_logic_vector(kNumEndpoints-1 downto 0);

    s_axi_rdata_in    : in  std_logic_vector(31 downto 0);
    s_axi_rvalid_slv  : in  std_logic_vector(kNumEndpoints-1 downto 0);
    s_axi_rready_slv  : out std_logic_vector(kNumEndpoints-1 downto 0)
  );
end PXIe659XR_AXI4_Lite_Address_Map;

architecture rtl of PXIe659XR_AXI4_Lite_Address_Map is

  constant kSelectWidth : integer := integer(ceil(log2(real(kNumEndpoints))));
  constant kAddrSelectMsb : positive := kAddrSelectLsb + kSelectWidth - 1;
  signal sSelectedEndpoint : unsigned(kSelectWidth-1 downto 0);

  type AccessState_t is (Idle, ProcessRequest, IssueResponse);
  signal sReadState, sWriteState : AccessState_t;

  signal s_axi_bvalid_i, s_axi_rvalid_i, s_axi_awready_i, s_axi_wready_i,
         s_axi_arready_i : std_logic;

  signal s_axi_bready_slv_i, s_axi_awvalid_slv_i, s_axi_wvalid_slv_i,
         s_axi_arvalid_slv_i, s_axi_rready_slv_i : std_logic_vector(kNumEndpoints - 1 downto 0);

begin

  s_axi_bvalid <= s_axi_bvalid_i;
  s_axi_rvalid <= s_axi_rvalid_i;
  s_axi_awready <= s_axi_awready_i;
  s_axi_wready <= s_axi_wready_i;
  s_axi_arready <= s_axi_arready_i;
  s_axi_bready_slv <= s_axi_bready_slv_i;
  s_axi_awvalid_slv <= s_axi_awvalid_slv_i;
  s_axi_wvalid_slv <= s_axi_wvalid_slv_i;
  s_axi_arvalid_slv <= s_axi_arvalid_slv_i;
  s_axi_rready_slv <= s_axi_rready_slv_i;

  SelectReg: process(aReset_n, s_aclk) is
  begin
    if aReset_n = '0' then
      sSelectedEndpoint <= (others => '0');
    elsif rising_edge(s_aclk) then
      
      if s_axi_arvalid = '1' then
        sSelectedEndpoint <= unsigned(s_axi_araddr(kAddrSelectMsb downto kAddrSelectLsb));
      elsif s_axi_awvalid = '1' then
        sSelectedEndpoint <= unsigned(s_axi_awaddr(kAddrSelectMsb downto kAddrSelectLsb));
      end if;
    end if;
  end process SelectReg;

  
  
  WriteAccessFsm: process(aReset_n, s_aclk) is
  begin
    if aReset_n = '0' then
      sWriteState         <= Idle;
      s_axi_awready_i     <= '0';
      s_axi_wready_i      <= '0';
      s_axi_bvalid_i      <= '0';
      s_axi_bready_slv_i  <= (others => '0');
      s_axi_awvalid_slv_i <= (others => '0');
      s_axi_wvalid_slv_i  <= (others => '0');
    elsif rising_edge(s_aclk) then
      s_axi_awready_i     <= '0';
      s_axi_wready_i      <= '0';
      s_axi_bvalid_i      <= '0';
      s_axi_bready_slv_i  <= (others => '0');
      s_axi_awvalid_slv_i <= (others => '0');
      s_axi_wvalid_slv_i  <= (others => '0');

      case sWriteState is
        when Idle =>
          if s_axi_awvalid = '1' and s_axi_wvalid = '1' then
            sWriteState <= ProcessRequest;
          end if;

        when ProcessRequest =>
          s_axi_awready_i <= s_axi_awready_slv(to_integer(sSelectedEndpoint));
          s_axi_wready_i  <= s_axi_wready_slv(to_integer(sSelectedEndpoint));
          s_axi_awvalid_slv_i(to_integer(sSelectedEndpoint)) <= s_axi_awvalid;
          s_axi_wvalid_slv_i(to_integer(sSelectedEndpoint))  <= s_axi_wvalid;
          if s_axi_awready_slv(to_integer(sSelectedEndpoint)) = '1' and s_axi_awvalid = '1' and
             s_axi_wready_slv(to_integer(sSelectedEndpoint)) = '1' and s_axi_wvalid = '1'then
            sWriteState <= IssueResponse;
            if s_axi_awvalid_slv_i(to_integer(sSelectedEndpoint)) = '1' then
              s_axi_awvalid_slv_i(to_integer(sSelectedEndpoint)) <= '0';
            end if;
            if s_axi_wvalid_slv_i(to_integer(sSelectedEndpoint)) = '1' then
              s_axi_wvalid_slv_i(to_integer(sSelectedEndpoint))  <= '0';
            end if;
            if s_axi_awready_i = '1' then
              s_axi_awready_i <= '0';
            end if;
            if s_axi_wready_i = '1' then
              s_axi_wready_i <= '0';
            end if;
          end if;

        when IssueResponse =>
          s_axi_bvalid_i <= s_axi_bvalid_slv(to_integer(sSelectedEndpoint));
          s_axi_bready_slv_i(to_integer(sSelectedEndpoint)) <= s_axi_bready;
          if s_axi_bvalid_slv(to_integer(sSelectedEndpoint)) = '1' and s_axi_bready = '1' then
            sWriteState  <= Idle;
            if s_axi_bvalid_i = '1' then
              s_axi_bvalid_i <= '0';
            end if;
            if s_axi_bready_slv_i(to_integer(sSelectedEndpoint)) = '1' then
              s_axi_bready_slv_i(to_integer(sSelectedEndpoint)) <= '0';
            end if;
          end if;
      end case;
    end if;
  end process WriteAccessFsm;

  
  
  ReadAccessFsm: process(aReset_n, s_aclk) is
  begin
    if aReset_n = '0' then
      sReadState <= Idle;
      s_axi_arready_i     <= '0';
      s_axi_rvalid_i      <= '0';
      s_axi_arvalid_slv_i <= (others => '0');
      s_axi_rready_slv_i  <= (others => '0');
      s_axi_rdata         <= (others => '0');
    elsif rising_edge(s_aclk) then
      s_axi_arready_i     <= '0';
      s_axi_rvalid_i      <= '0';
      s_axi_arvalid_slv_i <= (others => '0');
      s_axi_rready_slv_i  <= (others => '0');
      s_axi_rdata         <= s_axi_rdata_in;

      case sReadState is
        when Idle =>
          if s_axi_arvalid = '1' then
            sReadState <= ProcessRequest;
          end if;

        when ProcessRequest =>
          s_axi_arready_i <= s_axi_arready_slv(to_integer(sSelectedEndpoint));
          s_axi_arvalid_slv_i(to_integer(sSelectedEndpoint)) <= s_axi_arvalid;
          if s_axi_arready_slv(to_integer(sSelectedEndpoint)) = '1' and s_axi_arvalid = '1' then
            sReadState <= IssueResponse;
            if s_axi_arvalid_slv_i(to_integer(sSelectedEndpoint)) = '1' then
              s_axi_arvalid_slv_i(to_integer(sSelectedEndpoint)) <= '0';
            end if;
            if s_axi_arready_i = '1' then
              s_axi_arready_i <= '0';
            end if;
          end if;

        when IssueResponse =>
          s_axi_rvalid_i <= s_axi_rvalid_slv(to_integer(sSelectedEndpoint));
          s_axi_rready_slv_i(to_integer(sSelectedEndpoint)) <= s_axi_rready;
          if s_axi_rvalid_slv(to_integer(sSelectedEndpoint)) = '1' and s_axi_rready = '1' then
            sReadState   <= Idle;
            if s_axi_rvalid_i = '1' then
              s_axi_rvalid_i <= '0';
            end if;
            if s_axi_rready_slv_i(to_integer(sSelectedEndpoint)) = '1' then
              s_axi_rready_slv_i(to_integer(sSelectedEndpoint)) <= '0';
            end if;
          end if;
      end case;
    end if;
  end process ReadAccessFsm;
end rtl;