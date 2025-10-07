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

entity DualPortRAM is
  generic (
    kAddressWidth : integer := 8;
    kWidth : integer := 32;
    kRamReadLatency : integer := 2
  );
  port (
    IClk : in std_logic;
    iClkEn : in boolean := true;
    iWrite : in boolean;
    iAddr : in unsigned(kAddressWidth-1 downto 0);
    iDataIn : in std_logic_vector(kWidth-1 downto 0);

    OClk : in std_logic;
    oClkEn : in boolean := true;
    oReset : in boolean := false;
    oAddr : in unsigned(kAddressWidth-1 downto 0);
    oDataOut : out std_logic_vector(kWidth-1 downto 0)
  );
end DualPortRAM;

architecture rtl of DualPortRAM is

begin

  
  InferredRamx: entity work.DualPortRAM_Vivado (rtl)
    generic map (
      kAddressWidth   => kAddressWidth,    
      kWidth          => kWidth,           
      kRamReadLatency => kRamReadLatency)  
    port map (
      IClk     => IClk,      
      iClkEn   => iClkEn,    
      iWrite   => iWrite,    
      iAddr    => iAddr,     
      iDataIn  => iDataIn,   
      OClk     => OClk,      
      oReset   => oReset,    
      oClkEn   => oClkEn,    
      oAddr    => oAddr,     
      oDataOut => oDataOut); 

end rtl;