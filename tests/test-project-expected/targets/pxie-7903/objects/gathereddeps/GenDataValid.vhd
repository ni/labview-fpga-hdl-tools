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

library work;
  use work.PkgNiUtilities.all;

entity GenDataValid is
  generic (
    kRamReadLatency,
    kFifoAdditiveLatency : natural
  );
  port(
    aReset : in boolean;
    Clk : in std_logic;
    cRead,
    cReset,
    cClkEn : in boolean;
    cDataValid : out boolean
  );
end GenDataValid;

architecture rtl of GenDataValid is

  constant kFifoReadLatency : positive := kRamReadLatency + kFifoAdditiveLatency;
  signal cD, cQ : BooleanVector(kFifoReadLatency+2 downto 1);
  constant kResetVal : BooleanVector(kFifoReadLatency+2 downto 1) := (others => false);

begin

  assert kFifoReadLatency>0
    report "The sum of kRamReadLatency and kFifoAdditiveLatency must be > 0"
    severity error;

  cD(1) <= cRead and not cReset;
  cD(cD'high downto 2) <= (others => false) when cReset else cQ(cD'high-1 downto 1);

  
  
  DFlopBoolVecx: entity work.DFlopBoolVec (rtl)
    generic map (
      kResetVal => kResetVal)  
    port map (
      aReset => aReset,  
      cEn    => cClkEn,  
      Clk    => Clk,     
      cD     => cD,      
      cQ     => cQ);     

  cDataValid <= cD(kFifoReadLatency);

end rtl;