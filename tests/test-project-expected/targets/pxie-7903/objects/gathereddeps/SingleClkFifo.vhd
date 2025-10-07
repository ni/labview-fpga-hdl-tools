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

















































library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity SingleClkFifo is
  generic (
    kAddressWidth : positive;
    kWidth : positive;
    kRamReadLatency : natural;
    kFifoAdditiveLatency : natural := 1
  );
  port (
    aReset : in boolean;
    Clk : in std_logic;

    cReset : in boolean := false;
    cClkEn : in boolean := true;

    
    cWrite : in boolean;
    cDataIn : in std_logic_vector ( kWidth - 1 downto 0 );

    cRead : in boolean;
    cDataOut : out std_logic_vector ( kWidth - 1 downto 0 );

    cFullCount,
    cEmptyCount : out unsigned(kAddressWidth downto 0);

    cDataValid : out boolean

  );
end entity SingleClkFifo;

architecture rtl of SingleClkFifo is

  
  signal cMemRdAddr: unsigned(kAddressWidth-1 downto 0);
  signal cMemWtAddr: unsigned(kAddressWidth-1 downto 0);
  
begin

  
  
  
  SingleClkFifoFlagsx: entity work.SingleClkFifoFlags (rtl)
    generic map (
      kAddressWidth          => kAddressWidth,         
      kWidth                 => kWidth,                
      kRamReadLatency        => kRamReadLatency,       
      kFifoAdditiveLatency   => kFifoAdditiveLatency,  
      kEnableErrorAssertions => true)                  
    port map (
      aReset      => aReset,       
      Clk         => Clk,          
      cReset      => cReset,       
      cWrite      => cWrite,       
      cRead       => cRead,        
      cClkEn      => cClkEn,       
      cFullCount  => cFullCount,   
      cEmptyCount => cEmptyCount,  
      cDataValid  => cDataValid,   
      cMemWtAddr  => cMemWtAddr,   
      cMemRdAddr  => cMemRdAddr,   
      aError      => open);        

  
  
  
  
  
  
  DualPortRAMx: entity work.DualPortRAM (rtl)
    generic map (
      kAddressWidth   => kAddressWidth,    
      kWidth          => kWidth,           
      kRamReadLatency => kRamReadLatency)  
    port map (
      IClk     => Clk,         
      iClkEn   => cClkEn,      
      iWrite   => cWrite,      
      iAddr    => cMemWtAddr,  
      iDataIn  => cDataIn,     
      OClk     => Clk,         
      oClkEn   => cClkEn,      
      oReset   => cReset,      
      oAddr    => cMemRdAddr,  
      oDataOut => cDataOut);   

end rtl;