-------------------------------------------------------------------------------
-- File: AxiLiteToMgtDrp.vhd
-- Author: Minghui Zhang
-- Workspace: Sasquatch
-- Date: 25 August 2022
-------------------------------------------------------------------------------
-- (c) 2025 Copyright National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
-------------------------------------------------------------------------------
-- Purpose: This component wraps AXI Lite interface to MGT's DRP interface
-- with AXI cross clock domain.
-------------------------------------------------------------------------------
--
-- githubvisibledep=true
--

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity AxiLiteToMgtDrp is
  generic (
    kNumLanes         : integer := 4;
    kAddrSize         : integer := 10
  );
  port (
    aResetSl          : in std_logic;
    -------------------------------------------------------------------------------------
    -- AXI Lite Interface
    -------------------------------------------------------------------------------------
    SAxiAClk          : in std_logic;
    sAxiAWaddr        : in std_logic_vector(31 downto 0);
    sAxiAWValid       : in std_logic;
    sAxiAWReady       : out std_logic;
    sAxiWData         : in std_logic_vector(31 downto 0);
    sAxiWStrb         : in std_logic_vector(3 downto 0);
    sAxiWValid        : in std_logic;
    sAxiWReady        : out std_logic;
    sAxiBResp         : out std_logic_vector(1 downto 0);
    sAxiBValid        : out std_logic;
    sAxiBReady        : in std_logic;
    sAxiARAddr        : in std_logic_vector(31 downto 0);
    sAxiARValid       : in std_logic;
    sAxiARReady       : out std_logic;
    sAxiRData         : out std_logic_vector(31 downto 0);
    sAxiRResp         : out std_logic_vector(1 downto 0);
    sAxiRValid        : out std_logic;
    sAxiRReady        : in std_logic;
    -------------------------------------------------------------------------------------
    -- DRP interface to GT core
    -------------------------------------------------------------------------------------
    InitClk           : in  std_logic;
    iGtwizDrpClk      : out std_logic_vector(kNumLanes-1 downto 0);
    iGtwizDrpAddrIn   : out std_logic_vector(kNumLanes*kAddrSize-1 downto 0);
    iGtwizDrpDiIn     : out std_logic_vector(kNumLanes*16-1 downto 0);
    iGtwizDrpDoOut    : in  std_logic_vector(kNumLanes*16-1 downto 0);
    iGtwizDrpEnIn     : out std_logic_vector(kNumLanes-1 downto 0);
    iGtwizDrpWeIn     : out std_logic_vector(kNumLanes-1 downto 0);
    iGtwizDrpRdyOut   : in  std_logic_vector(kNumLanes-1 downto 0)
  );
end AxiLiteToMgtDrp;

architecture rtl of AxiLiteToMgtDrp is

  component MgtTest_DRP_bridge
    generic (
      kNUM_LANES : integer := 4;
      kADDR_SIZE : integer := 9);
    port (
      aResetSl          : in  std_logic;
      gtwiz_drpclk      : out std_logic_vector(kNUM_LANES-1 downto 0);
      gtwiz_drpaddr_in  : out std_logic_vector(kNUM_LANES*kADDR_SIZE-1 downto 0);
      gtwiz_drpdi_in    : out std_logic_vector(kNUM_LANES*16-1 downto 0);
      gtwiz_drpdo_out   : in  std_logic_vector(kNUM_LANES*16-1 downto 0);
      gtwiz_drpen_in    : out std_logic_vector(kNUM_LANES-1 downto 0);
      gtwiz_drpwe_in    : out std_logic_vector(kNUM_LANES-1 downto 0);
      gtwiz_drprdy_out  : in  std_logic_vector(kNUM_LANES-1 downto 0);
      s_aclk            : in  std_logic;
      drp_s_axi_awaddr  : in  std_logic_vector(31 downto 0);
      drp_s_axi_awvalid : in  std_logic;
      drp_s_axi_awready : out std_logic;
      drp_s_axi_wdata   : in  std_logic_vector(31 downto 0);
      drp_s_axi_wstrb   : in  std_logic_vector(3 downto 0);
      drp_s_axi_wvalid  : in  std_logic;
      drp_s_axi_wready  : out std_logic;
      drp_s_axi_bresp   : out std_logic_vector(1 downto 0);
      drp_s_axi_bvalid  : out std_logic;
      drp_s_axi_bready  : in  std_logic;
      drp_s_axi_araddr  : in  std_logic_vector(31 downto 0);
      drp_s_axi_arvalid : in  std_logic;
      drp_s_axi_arready : out std_logic;
      drp_s_axi_rdata   : out std_logic_vector(31 downto 0);
      drp_s_axi_rresp   : out std_logic_vector(1 downto 0);
      drp_s_axi_rvalid  : out std_logic;
      drp_s_axi_rready  : in  std_logic);
  end component;
  component AxiLiteClockConverterWrapper
    port (
      aReset      : in  STD_LOGIC;
      SAxiAClk    : in  STD_LOGIC;
      sAxiAWaddr  : in  STD_LOGIC_VECTOR(31 downto 0);
      sAxiAWValid : in  STD_LOGIC;
      sAxiAWReady : out STD_LOGIC;
      sAxiWData   : in  STD_LOGIC_VECTOR(31 downto 0);
      sAxiWStrb   : in  STD_LOGIC_VECTOR(3 downto 0);
      sAxiWValid  : in  STD_LOGIC;
      sAxiWReady  : out STD_LOGIC;
      sAxiBResp   : out STD_LOGIC_VECTOR(1 downto 0);
      sAxiBValid  : out STD_LOGIC;
      sAxiBReady  : in  STD_LOGIC;
      sAxiARAddr  : in  STD_LOGIC_VECTOR(31 downto 0);
      sAxiARValid : in  STD_LOGIC;
      sAxiARReady : out STD_LOGIC;
      sAxiRData   : out STD_LOGIC_VECTOR(31 downto 0);
      sAxiRResp   : out STD_LOGIC_VECTOR(1 downto 0);
      sAxiRValid  : out STD_LOGIC;
      sAxiRReady  : in  STD_LOGIC;
      MAxiAClk    : in  STD_LOGIC;
      mAxiAWaddr  : out STD_LOGIC_VECTOR(31 downto 0);
      mAxiAWvalid : out STD_LOGIC;
      mAxiAWready : in  STD_LOGIC;
      mAxiWData   : out STD_LOGIC_VECTOR(31 downto 0);
      mAxiWStrb   : out STD_LOGIC_VECTOR(3 downto 0);
      mAxiWValid  : out STD_LOGIC;
      mAxiWReady  : in  STD_LOGIC;
      mAxiBResp   : in  STD_LOGIC_VECTOR(1 downto 0);
      mAxiBValid  : in  STD_LOGIC;
      mAxiBReady  : out STD_LOGIC;
      mAxiARaddr  : out STD_LOGIC_VECTOR(31 downto 0);
      mAxiARvalid : out STD_LOGIC;
      mAxiARready : in  STD_LOGIC;
      mAxiRData   : in  STD_LOGIC_VECTOR(31 downto 0);
      mAxiRResp   : in  STD_LOGIC_VECTOR(1 downto 0);
      mAxiRValid  : in  STD_LOGIC;
      mAxiRReady  : out STD_LOGIC);
  end component;

  --vhook_sigstart
  signal iAxiaraddr: std_logic_vector(31 downto 0);
  signal iAxiarready: std_logic;
  signal iAxiarvalid: std_logic;
  signal iAxiawaddr: std_logic_vector(31 downto 0);
  signal iAxiawready: std_logic;
  signal iAxiawvalid: std_logic;
  signal iAxibready: std_logic;
  signal iAxibresp: std_logic_vector(1 downto 0);
  signal iAxibvalid: std_logic;
  signal iAxirdata: std_logic_vector(31 downto 0);
  signal iAxirready: std_logic;
  signal iAxirresp: std_logic_vector(1 downto 0);
  signal iAxirvalid: std_logic;
  signal iAxiwdata: std_logic_vector(31 downto 0);
  signal iAxiwready: std_logic;
  signal iAxiwstrb: std_logic_vector(3 downto 0);
  signal iAxiwvalid: std_logic;
  --vhook_sigend

begin

  --vhook AxiLiteClockConverterWrapper
  --vhook_a aReset aResetSl
  --vhook_a {mAxi(.*)} iAxi$1
  --vhook_a MAxiAClk InitClk
  AxiLiteClockConverterWrapperx: AxiLiteClockConverterWrapper
    port map (
      aReset      => aResetSl,     --in  STD_LOGIC
      SAxiAClk    => SAxiAClk,     --in  STD_LOGIC
      sAxiAWaddr  => sAxiAWaddr,   --in  STD_LOGIC_VECTOR(31:0)
      sAxiAWValid => sAxiAWValid,  --in  STD_LOGIC
      sAxiAWReady => sAxiAWReady,  --out STD_LOGIC
      sAxiWData   => sAxiWData,    --in  STD_LOGIC_VECTOR(31:0)
      sAxiWStrb   => sAxiWStrb,    --in  STD_LOGIC_VECTOR(3:0)
      sAxiWValid  => sAxiWValid,   --in  STD_LOGIC
      sAxiWReady  => sAxiWReady,   --out STD_LOGIC
      sAxiBResp   => sAxiBResp,    --out STD_LOGIC_VECTOR(1:0)
      sAxiBValid  => sAxiBValid,   --out STD_LOGIC
      sAxiBReady  => sAxiBReady,   --in  STD_LOGIC
      sAxiARAddr  => sAxiARAddr,   --in  STD_LOGIC_VECTOR(31:0)
      sAxiARValid => sAxiARValid,  --in  STD_LOGIC
      sAxiARReady => sAxiARReady,  --out STD_LOGIC
      sAxiRData   => sAxiRData,    --out STD_LOGIC_VECTOR(31:0)
      sAxiRResp   => sAxiRResp,    --out STD_LOGIC_VECTOR(1:0)
      sAxiRValid  => sAxiRValid,   --out STD_LOGIC
      sAxiRReady  => sAxiRReady,   --in  STD_LOGIC
      MAxiAClk    => InitClk,      --in  STD_LOGIC
      mAxiAWaddr  => iAxiAWaddr,   --out STD_LOGIC_VECTOR(31:0)
      mAxiAWvalid => iAxiAWvalid,  --out STD_LOGIC
      mAxiAWready => iAxiAWready,  --in  STD_LOGIC
      mAxiWData   => iAxiWData,    --out STD_LOGIC_VECTOR(31:0)
      mAxiWStrb   => iAxiWStrb,    --out STD_LOGIC_VECTOR(3:0)
      mAxiWValid  => iAxiWValid,   --out STD_LOGIC
      mAxiWReady  => iAxiWReady,   --in  STD_LOGIC
      mAxiBResp   => iAxiBResp,    --in  STD_LOGIC_VECTOR(1:0)
      mAxiBValid  => iAxiBValid,   --in  STD_LOGIC
      mAxiBReady  => iAxiBReady,   --out STD_LOGIC
      mAxiARaddr  => iAxiARaddr,   --out STD_LOGIC_VECTOR(31:0)
      mAxiARvalid => iAxiARvalid,  --out STD_LOGIC
      mAxiARready => iAxiARready,  --in  STD_LOGIC
      mAxiRData   => iAxiRData,    --in  STD_LOGIC_VECTOR(31:0)
      mAxiRResp   => iAxiRResp,    --in  STD_LOGIC_VECTOR(1:0)
      mAxiRValid  => iAxiRValid,   --in  STD_LOGIC
      mAxiRReady  => iAxiRReady);  --out STD_LOGIC

  --vhook MgtTest_DRP_bridge
  --vhook_a kNUM_LANES kNumLanes
  --vhook_a kADDR_SIZE kAddrSize
  --vhook_a s_aclk     InitClk
  --vhook_a {drp_s_axi_(.*)} iAxi$1
  --vhook_a gtwiz_drpclk       iGtwizDrpClk   (1*kNumLanes-1    downto 0*kNumLanes)
  --vhook_a gtwiz_drpaddr_in   iGtwizDrpAddrIn(1*kNumLanes*kAddrSize-1 downto 0*kNumLanes*kAddrSize)
  --vhook_a gtwiz_drpdi_in     iGtwizDrpDiIn  (1*kNumLanes*16-1 downto 0*kNumLanes*16)
  --vhook_a gtwiz_drpdo_out    iGtwizDrpDoOut (1*kNumLanes*16-1 downto 0*kNumLanes*16)
  --vhook_a gtwiz_drpen_in     iGtwizDrpEnIn  (1*kNumLanes-1    downto 0*kNumLanes)
  --vhook_a gtwiz_drpwe_in     iGtwizDrpWeIn  (1*kNumLanes-1    downto 0*kNumLanes)
  --vhook_a gtwiz_drprdy_out   iGtwizDrpRdyOut(1*kNumLanes-1    downto 0*kNumLanes)
  MgtTest_DRP_bridgex: MgtTest_DRP_bridge
    generic map (
      kNUM_LANES => kNumLanes,  --integer:=4
      kADDR_SIZE => kAddrSize)  --integer:=9
    port map (
      aResetSl          => aResetSl,                                                               --in  std_logic
      gtwiz_drpclk      => iGtwizDrpClk (1*kNumLanes-1 downto 0*kNumLanes),                        --out std_logic_vector(kNUM_LANES-1:0)
      gtwiz_drpaddr_in  => iGtwizDrpAddrIn(1*kNumLanes*kAddrSize-1 downto 0*kNumLanes*kAddrSize),  --out std_logic_vector(kNUM_LANES*kADDR_SIZE-1:0)
      gtwiz_drpdi_in    => iGtwizDrpDiIn (1*kNumLanes*16-1 downto 0*kNumLanes*16),                 --out std_logic_vector(kNUM_LANES*16-1:0)
      gtwiz_drpdo_out   => iGtwizDrpDoOut (1*kNumLanes*16-1 downto 0*kNumLanes*16),                --in  std_logic_vector(kNUM_LANES*16-1:0)
      gtwiz_drpen_in    => iGtwizDrpEnIn (1*kNumLanes-1 downto 0*kNumLanes),                       --out std_logic_vector(kNUM_LANES-1:0)
      gtwiz_drpwe_in    => iGtwizDrpWeIn (1*kNumLanes-1 downto 0*kNumLanes),                       --out std_logic_vector(kNUM_LANES-1:0)
      gtwiz_drprdy_out  => iGtwizDrpRdyOut(1*kNumLanes-1 downto 0*kNumLanes),                      --in  std_logic_vector(kNUM_LANES-1:0)
      s_aclk            => InitClk,                                                                --in  std_logic
      drp_s_axi_awaddr  => iAxiawaddr,                                                             --in  std_logic_vector(31:0)
      drp_s_axi_awvalid => iAxiawvalid,                                                            --in  std_logic
      drp_s_axi_awready => iAxiawready,                                                            --out std_logic
      drp_s_axi_wdata   => iAxiwdata,                                                              --in  std_logic_vector(31:0)
      drp_s_axi_wstrb   => iAxiwstrb,                                                              --in  std_logic_vector(3:0)
      drp_s_axi_wvalid  => iAxiwvalid,                                                             --in  std_logic
      drp_s_axi_wready  => iAxiwready,                                                             --out std_logic
      drp_s_axi_bresp   => iAxibresp,                                                              --out std_logic_vector(1:0)
      drp_s_axi_bvalid  => iAxibvalid,                                                             --out std_logic
      drp_s_axi_bready  => iAxibready,                                                             --in  std_logic
      drp_s_axi_araddr  => iAxiaraddr,                                                             --in  std_logic_vector(31:0)
      drp_s_axi_arvalid => iAxiarvalid,                                                            --in  std_logic
      drp_s_axi_arready => iAxiarready,                                                            --out std_logic
      drp_s_axi_rdata   => iAxirdata,                                                              --out std_logic_vector(31:0)
      drp_s_axi_rresp   => iAxirresp,                                                              --out std_logic_vector(1:0)
      drp_s_axi_rvalid  => iAxirvalid,                                                             --out std_logic
      drp_s_axi_rready  => iAxirready);                                                            --in  std_logic

end rtl;
