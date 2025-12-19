-------------------------------------------------------------------------------
--
-- File: DFlopBoolVec.vhd
-- Author: Craig Conway
-- Original Project: SMC4
-- Date: 28 November 2006
--
-------------------------------------------------------------------------------
-- (c) 2006 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--    Instantiates an array of DFlop components.  These components
-- have a "hard" syn_hier attribute so that the enable logic won't
-- get merged with the D logic.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

library work;
  use work.PkgNiUtilities.all;

entity DFlopBoolVec is
  generic (kResetVal : BooleanVector);
  port (
    aReset, cEn  : in boolean;
    Clk : in std_logic;
    cD   : in BooleanVector(kResetVal'length-1 downto 0);
    cQ   : out BooleanVector(kResetVal'length-1 downto 0) := kResetVal
  );
end DFlopBoolVec;

architecture rtl of DFlopBoolVec is

  signal cQ_SLV: std_logic_vector(kResetVal'length-1 downto 0);

begin

  --vhook_e DFlopSLV
  --vhook_a kResetVal To_StdLogicVector(kResetVal)
  --vhook_a cD To_StdLogicVector(cD)
  --vhook_a cQ cQ_SLV
  DFlopSLVx: entity work.DFlopSLV (rtl)
    generic map (
      kResetVal => To_StdLogicVector(kResetVal))  -- in  std_logic_vector
    port map (
      aReset => aReset,                 -- in  boolean
      cEn    => cEn,                    -- in  boolean
      Clk    => Clk,                    -- in  std_logic
      cD     => To_StdLogicVector(cD),  -- in  std_logic_vector(kResetVal'length-1 downto
      cQ     => cQ_SLV);                -- out std_logic_vector(kResetVal'length-1 downto

  cQ <= to_BooleanVector(cQ_SLV);

end rtl;

-- The following comment is a checksum VScan uses to determine whether this
-- file has been modified.  Please don't try to get around it.  It's there
-- for a reason.
--VScan_CS 5679021
