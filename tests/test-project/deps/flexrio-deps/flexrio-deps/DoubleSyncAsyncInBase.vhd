-------------------------------------------------------------------------------
--
-- File: DoubleSyncAsyncInBase.vhd
-- Author: Craig Conway
-- Original Project: NICores
-- Date: 7 April 2010
--
-------------------------------------------------------------------------------
-- (c) 2010 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--    This is a simple double synchronizer for an asynchronous
--  std_logic input.
--    This module does not automatically cause VScan to suppress
--  clock crossing warnings, although if aSig is driven from
--  a glitch-free source (such as a top-level glitch-free input
--  or a flip-flop), VScan may not require an explanation.
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

entity DoubleSyncAsyncInBase is
  generic (
    kResetVal : std_logic := '0'
  );
  port (
    aSig:    in  std_logic;     -- must be a glitch-free input

    aOReset: in  boolean;     -- can drive this with false if needed
    OClk:    in  std_logic;
    oClkEn:  in  boolean := true;
    oSig:    out std_logic := kResetVal
  );
end DoubleSyncAsyncInBase;

architecture rtl of DoubleSyncAsyncInBase is

  signal oSig_ms : std_logic := kResetVal;  -- metastable signal

begin
 
  -- Set the 'async_reg' attribute to "true" through kAsyncReg generic 
  -- in order to preventreplication of the metastable flop and place the metastable 
  -- and stable flop as close as possible

  --vhook_e DFlop oSig_msx
  --vhook_a kAsyncReg "true"
  --vhook_a aReset aOReset
  --vhook_a Clk OClk
  --vhook_a cEn oClkEn
  --vhook_a cD aSig
  --vhook_a cQ oSig_ms
  oSig_msx: entity work.DFlop (rtl)
    generic map (
      kResetVal => kResetVal,  -- in  std_logic := '0'
      kAsyncReg => "true")     -- in  string := "false"
    port map (
      aReset => aOReset,  -- in  boolean
      cEn    => oClkEn,   -- in  boolean
      Clk    => OClk,     -- in  std_logic
      cD     => aSig,     -- in  std_logic
      cQ     => oSig_ms); -- out std_logic := kResetVal

  --vhook_e DFlop oSigx
  --vhook_a kAsyncReg "true"
  --vhook_a aReset aOReset
  --vhook_a Clk OClk
  --vhook_a cEn oClkEn
  --vhook_a cD oSig_ms
  --vhook_a cQ oSig
  oSigx: entity work.DFlop (rtl)
    generic map (
      kResetVal => kResetVal,  -- in  std_logic := '0'
      kAsyncReg => "true")     -- in  string := "false"
    port map (
      aReset => aOReset,  -- in  boolean
      cEn    => oClkEn,   -- in  boolean
      Clk    => OClk,     -- in  std_logic
      cD     => oSig_ms,  -- in  std_logic
      cQ     => oSig);    -- out std_logic := kResetVal

end rtl;

-- The following comment is a checksum VScan uses to determine whether this
-- file has been modified.  Please don't try to get around it.  It's there
-- for a reason.
--VScan_CS 5537718
