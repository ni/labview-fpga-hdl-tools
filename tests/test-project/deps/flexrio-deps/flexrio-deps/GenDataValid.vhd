-------------------------------------------------------------------------------
--
-- File: GenDataValid.vhd
-- Author: Craig Conway
-- Original Project: NI Cores
-- Date: 25 February 2009
--
-------------------------------------------------------------------------------
-- (c) 2009 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--   This module creates a delay of the oDataValid signal so that it
-- asserts when data should be captured from the RAM
--
-------------------------------------------------------------------------------

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

  --vhook_e DFlopBoolVec
  --vhook_a cEn cClkEn
  DFlopBoolVecx: entity work.DFlopBoolVec (rtl)
    generic map (
      kResetVal => kResetVal)  -- in  BooleanVector
    port map (
      aReset => aReset,  -- in  boolean
      cEn    => cClkEn,  -- in  boolean
      Clk    => Clk,     -- in  std_logic
      cD     => cD,      -- in  BooleanVector(kResetVal'length-1 downto 0)
      cQ     => cQ);     -- out BooleanVector(kResetVal'length-1 downto 0) := kResetVal

  cDataValid <= cD(kFifoReadLatency);

end rtl;
