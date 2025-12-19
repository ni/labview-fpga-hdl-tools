-------------------------------------------------------------------------------
--
-- File: DoubleSyncBase.vhd
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
--    This module transfers a std_logic signal from one clock domain to
--  another using a double synchronizer.  It also uses clock enables.
--    It takes the signal in using a single flip-flop from the original clock
--  domain and then transfers it to the new clock domain with two flip-flops.
--    It also includes two asynchronous resets, allowing VScan to consider
--  this a safe reset crossing as well as a safe clock crossing.
--    The first flip-flop isn't strictly necessary, but it confines the
--  clock boundary crossing to be completely within this module, making it
--  easier to prove correctness.
--    This module can be conveniently used for registers writes.  Connect
--  the register write signal to iClkEn and the data line to iSigIn.  iSigOut
--  is the readable bit for the register.  oSig is that same signal transferred
--  to OClk's clock domain.
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity DoubleSyncBase is
  generic (
    kResetVal : std_logic := '0'
  );
  port (
    aIReset: in  boolean;
    IClk:    in  std_logic;
    iClkEn:  in  boolean;
    iSigIn:  in  std_logic;
    iSigOut: out std_logic;

    aOReset: in  boolean;
    OClk:    in  std_logic;
    oClkEn:  in  boolean;
    oSig:    out std_logic
  );
end DoubleSyncBase;

architecture behavior of DoubleSyncBase is

  signal iDlySig : std_logic;

  -- The keep is designed to prevent the signal renaming of iDlySig that would
  -- invalidate timing constraints.
  attribute keep : string;
  attribute keep of iDlySig : signal is "true";

begin

  -- Bring in iSig into this module and reclock it to its
  -- original clock domain.  This accomplishes two things:
  -- First, it ensures that the clock boundary crossing remains
  -- completely within this module.  Second, it keeps the
  -- user from having to worry about whether iSig is a
  -- a glitchy signal or not.

  --vhook_e DFlop iDlySigx
  --vhook_a kAsyncReg "false"
  --vhook_a aReset aIReset
  --vhook_a Clk IClk
  --vhook_a cEn iClkEn
  --vhook_a cD iSigIn
  --vhook_a cQ iDlySig
  iDlySigx: entity work.DFlop (rtl)
    generic map (
      kResetVal => kResetVal,  --std_logic:='0'
      kAsyncReg => "false")    --string:="false"
    port map (
      aReset => aIReset,  --in  boolean
      cEn    => iClkEn,   --in  boolean
      Clk    => IClk,     --in  std_logic
      cD     => iSigIn,   --in  std_logic
      cQ     => iDlySig); --out std_logic:=kResetVal

  iSigOut <= iDlySig;

  --!CLOCK BOUNDARY CROSSING!  iDlySig is being double synchronized here

  --vhook_e DoubleSyncAsyncInBase
  --vhook_a aSig iDlySig
  DoubleSyncAsyncInBasex: entity work.DoubleSyncAsyncInBase (rtl)
    generic map (kResetVal => kResetVal)  --std_logic:='0'
    port map (
      aSig    => iDlySig,  --in  std_logic
      aOReset => aOReset,  --in  boolean
      OClk    => OClk,     --in  std_logic
      oClkEn  => oClkEn,   --in  boolean:=true
      oSig    => oSig);    --out std_logic:=kResetVal


end behavior;

-- The following comment is a checksum VScan uses to determine whether this
-- file has been modified.  Please don't try to get around it.  It's there
-- for a reason.
--VScan_CS 490124
