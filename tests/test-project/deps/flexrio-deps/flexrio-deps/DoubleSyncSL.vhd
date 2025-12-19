-------------------------------------------------------------------------------
--
-- File: DoubleSyncSL.vhd
-- Author: Craig Conway
-- Original Project: NICores
-- Date: 13 September 2002
--
-------------------------------------------------------------------------------
-- (c) 2002 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--      This module transfers a std_logic signal
--  from one clock domain to another using a
--  double synchronizer.
--      It uses a single flip-flop in the IClk domain
--  to resynchronize the signal so that the entire
--  clock boundary crossing is within this module.
--
--      Refer to DoubleSyncBase for more information.
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity DoubleSyncSL is
  port (
    aReset: in  boolean;

    IClk:   in  std_logic;
    iSig:   in  std_logic;

    OClk:   in  std_logic;
    oSig:   out std_logic
  );
end DoubleSyncSL;

architecture behavior of DoubleSyncSL is

begin

  --vhook_e DoubleSyncBase
  --vhook_a kResetVal '0'
  --vhook_a {a[IO]Reset} aReset
  --vhook_a iSigIn iSig
  --vhook_a iSigOut open
  --vhook_a iClkEn true
  --vhook_a oClkEn true
  DoubleSyncBasex: entity work.DoubleSyncBase (behavior)
    generic map (
      kResetVal => '0')  -- in  std_logic := '0'
    port map (
      aIReset => aReset,  -- in  boolean
      IClk    => IClk,    -- in  std_logic
      iClkEn  => true,    -- in  boolean
      iSigIn  => iSig,    -- in  std_logic
      iSigOut => open,    -- out std_logic
      aOReset => aReset,  -- in  boolean
      OClk    => OClk,    -- in  std_logic
      oClkEn  => true,    -- in  boolean
      oSig    => oSig);   -- out std_logic

end behavior;
