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

entity AxiLiteToMgtDrp is
  generic (
    kNumLanes         : integer := 4;
    kAddrSize         : integer := 10
  );
  port (
    aResetSl          : in std_logic;
    
    
    
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
  

begin

  
  
  
  
  AxiLiteClockConverterWrapperx: AxiLiteClockConverterWrapper
    port map (
      aReset      => aResetSl,     
      SAxiAClk    => SAxiAClk,     
      sAxiAWaddr  => sAxiAWaddr,   
      sAxiAWValid => sAxiAWValid,  
      sAxiAWReady => sAxiAWReady,  
      sAxiWData   => sAxiWData,    
      sAxiWStrb   => sAxiWStrb,    
      sAxiWValid  => sAxiWValid,   
      sAxiWReady  => sAxiWReady,   
      sAxiBResp   => sAxiBResp,    
      sAxiBValid  => sAxiBValid,   
      sAxiBReady  => sAxiBReady,   
      sAxiARAddr  => sAxiARAddr,   
      sAxiARValid => sAxiARValid,  
      sAxiARReady => sAxiARReady,  
      sAxiRData   => sAxiRData,    
      sAxiRResp   => sAxiRResp,    
      sAxiRValid  => sAxiRValid,   
      sAxiRReady  => sAxiRReady,   
      MAxiAClk    => InitClk,      
      mAxiAWaddr  => iAxiAWaddr,   
      mAxiAWvalid => iAxiAWvalid,  
      mAxiAWready => iAxiAWready,  
      mAxiWData   => iAxiWData,    
      mAxiWStrb   => iAxiWStrb,    
      mAxiWValid  => iAxiWValid,   
      mAxiWReady  => iAxiWReady,   
      mAxiBResp   => iAxiBResp,    
      mAxiBValid  => iAxiBValid,   
      mAxiBReady  => iAxiBReady,   
      mAxiARaddr  => iAxiARaddr,   
      mAxiARvalid => iAxiARvalid,  
      mAxiARready => iAxiARready,  
      mAxiRData   => iAxiRData,    
      mAxiRResp   => iAxiRResp,    
      mAxiRValid  => iAxiRValid,   
      mAxiRReady  => iAxiRReady);  

  
  
  
  
  
  
  
  
  
  
  
  
  MgtTest_DRP_bridgex: MgtTest_DRP_bridge
    generic map (
      kNUM_LANES => kNumLanes,  
      kADDR_SIZE => kAddrSize)  
    port map (
      aResetSl          => aResetSl,                                                               
      gtwiz_drpclk      => iGtwizDrpClk (1*kNumLanes-1 downto 0*kNumLanes),                        
      gtwiz_drpaddr_in  => iGtwizDrpAddrIn(1*kNumLanes*kAddrSize-1 downto 0*kNumLanes*kAddrSize),  
      gtwiz_drpdi_in    => iGtwizDrpDiIn (1*kNumLanes*16-1 downto 0*kNumLanes*16),                 
      gtwiz_drpdo_out   => iGtwizDrpDoOut (1*kNumLanes*16-1 downto 0*kNumLanes*16),                
      gtwiz_drpen_in    => iGtwizDrpEnIn (1*kNumLanes-1 downto 0*kNumLanes),                       
      gtwiz_drpwe_in    => iGtwizDrpWeIn (1*kNumLanes-1 downto 0*kNumLanes),                       
      gtwiz_drprdy_out  => iGtwizDrpRdyOut(1*kNumLanes-1 downto 0*kNumLanes),                      
      s_aclk            => InitClk,                                                                
      drp_s_axi_awaddr  => iAxiawaddr,                                                             
      drp_s_axi_awvalid => iAxiawvalid,                                                            
      drp_s_axi_awready => iAxiawready,                                                            
      drp_s_axi_wdata   => iAxiwdata,                                                              
      drp_s_axi_wstrb   => iAxiwstrb,                                                              
      drp_s_axi_wvalid  => iAxiwvalid,                                                             
      drp_s_axi_wready  => iAxiwready,                                                             
      drp_s_axi_bresp   => iAxibresp,                                                              
      drp_s_axi_bvalid  => iAxibvalid,                                                             
      drp_s_axi_bready  => iAxibready,                                                             
      drp_s_axi_araddr  => iAxiaraddr,                                                             
      drp_s_axi_arvalid => iAxiarvalid,                                                            
      drp_s_axi_arready => iAxiarready,                                                            
      drp_s_axi_rdata   => iAxirdata,                                                              
      drp_s_axi_rresp   => iAxirresp,                                                              
      drp_s_axi_rvalid  => iAxirvalid,                                                             
      drp_s_axi_rready  => iAxirready);                                                            

end rtl;