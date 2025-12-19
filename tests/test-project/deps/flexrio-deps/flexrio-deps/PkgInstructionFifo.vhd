------------------------------------------------------------------------------------------
--
-- File: PkgInstructionFifo.vhd
-- Author: Rolando Ortega
-- Original Project: Instruction FIFO for SDIs
-- Date: 15 May 2015
--
------------------------------------------------------------------------------------------
-- (c) 2015 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
------------------------------------------------------------------------------------------
--
-- Purpose: Types, definitions, and type-changing functions for the InstructionFifo. A
-- user implementing an InstructionFifo is *not* expected to modify the contents of this
-- package. PkgInstructionFifoConfig should be branched and modified instead.
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgNiUtilities.all;
use work.PkgInstructionFifoConfig.all;
use work.PkgNiDmaConfig.all;

package PkgInstructionFifo is

  ---------------------------------------------------------------------------------------
  -- Write Side
  ---------------------------------------------------------------------------------------
  constant kIFifoWriteDataWidth : positive := kIFifoWriteDataWidthBytes * 8;

  subtype IFifoWriteData_t is std_logic_vector(kIFifoWriteDataWidth-1 downto 0);
  constant kIFifoWriteDataZero : IFifoWriteData_t := (others => '0');
  type IFifoWriteDataAry_t is array (natural range <>) of IFifoWriteData_t;

  ---------------------------------------------------------------------------------------
  -- Read Side
  ---------------------------------------------------------------------------------------
  -- Main Data Type
  constant kIFifoReadDataWidth : positive        := kIFifoReadDataWidthBytes * 8;
  subtype IFifoReadData_t is std_logic_vector(kIFifoReadDataWidth-1 downto 0);
  constant kIFifoReadDataZero  : IFifoReadData_t := (others => '0');
  type IFifoReadDataAry_t is array (natural range <>) of IFifoReadData_t;

  constant kIFifoSentinelWidth : positive             := kIFifoSentinelWidthBytes * 8;
  subtype IFifoSentinel_t is unsigned(kIFifoSentinelWidth-1 downto 0);
  constant kIFifoSentinelZero  : IFifoSentinel_t := (others => '0');
  type IFifoSentinelAry_t is array (natural range <>) of IFifoSentinel_t;

  -- Status is currently defined as a single byte, which we will optionally return or
  -- not.
  constant kIFifoReturnsStatus : boolean := kIFIfoReadStatusWidthBytes > 0;
  --But within that byte we actually only use a couple bits.
  type IFifoReadStatus_t is record
    IsError : boolean;
    Last    : boolean;
  end record IFifoReadStatus_t;

  constant kIFifoReadStatusZero : IFifoReadStatus_t :=
    (IsError => false, Last => false);

  type IFifoReadStatusAry_t is array (natural range <>) of IFifoReadStatus_t;

  -- Note that in the case of kIFIfoReadStatusWidthBytes being set to 0, the flattened
  -- version of the status will be a null vector. That's ok.
  --vhook_nowarn id=CP7
  constant kIFifoReadStatusWidth : natural := kIFifoReadStatusWidthBytes * 8;
  subtype FlatIFifoReadStatus_t is std_logic_vector(kIFifoReadStatusWidth-1 downto 0);
  constant kFlatIFifoReadStatusZero : FlatIFifoReadStatus_t := (others => '0');

  -- Bit indexes within the vector.
  constant kIFifoReadStatusErrorIndex : natural := 0;
  constant kIFifoReadStatusLastIndex : natural := 1;

  function Unflatten (
    slv : FlatIFifoReadStatus_t)
    return IFifoReadStatus_t;

  function Flatten (
    val : IFifoReadStatus_t)
    return FlatIFifoReadStatus_t;

  -- A "read" includes the actual read data, status, and sentinel.
  type IFifoRead_t is record
    Data     : IFifoReadData_t;
    Status   : IFifoReadStatus_t;
    Sentinel : IFifoSentinel_t;
  end record IFifoRead_t;

  constant kIFifoReadZero : IFifoRead_t :=
    (Data => kIFifoReadDataZero,
     Status => kIFifoReadStatusZero,
     Sentinel => kIFifoSentinelZero);

  constant kIFifoReadWidthBytes : positive := kIFifoReadDataWidthBytes +
                                              kIFifoReadStatusWidthBytes +
                                              kIFifoSentinelWidthBytes;
  constant kIFifoReadWidth : positive := kIFifoReadWidthBytes * 8;

  subtype FlatIFifoRead_t is std_logic_vector(kIFifoReadWidth-1 downto 0);
  type FlatIFifoReadAry_t is array (natural range <>) of FlatIFifoRead_t;

  function Unflatten (
    slv : FlatIFifoRead_t)
    return IFifoRead_t;

  function Flatten (
    val : IFifoRead_t)
    return FlatIFifoRead_t;

  ---------------------------------------------------------------------------------------
  -- Configuration
  ---------------------------------------------------------------------------------------
  -- Type used to add or remove credits
  subtype IFifoCredits_t is signed(kIFifoElementsLog2 downto 0);
  constant kIFifoCreditsZero : IFifoCredits_t := (others => '0');

  type IFifoCreditsAry_t is array (natural range <>) of IFifoCredits_t;

  ---------------------------------------------------------------------------------------
  -- Other
  ---------------------------------------------------------------------------------------
  -- One of the internal fifos is sized in terms of bus (Dma) words (which can be 64, 128,
  -- or 256 bits) rather than Instructions. This implies an increase (if the Dma words are
  -- smaller than the instructions) or reduction (if the instructions are smaller than the
  -- Dma words) in the size of the Fifo relative to the number of Instructions. This
  -- function returns the number of bits that must be added to the Instruction Fifo Width
  -- to create the DmaWord Fifo Width. Note that the returned value can be negative.
  function GetAddressWidthModifier (
    constant kDmaWidth         :    natural;
    constant kInstructionWidth : in natural)
    return integer;

  -- This probably shouldn't go here, but we'll put it in until there's a better place.
  -- We just need to have a way to create an array of (something close to) NiDmaAddress_t.
  type NiDmaAddressAry_t is array (natural range <>) of
    unsigned(kNiDmaAddressWidth-1 downto 0);

  ---------------------------------------------------------------------------------------
  -- Ranges
  ---------------------------------------------------------------------------------------

  -- I've never quite understood why these range things work, but they do:
  subtype AxiStreamRange_t is natural range 0 to kNumAxiStreamFifos-1;
  subtype LvFpgaRange_t is natural range kNumAxiStreamFifos to kNumAxiStreamFifos + kNumLvFpgaFifos -1;
  subtype IFifoRange_t is natural range 0 to kIFifoNrFifos-1;

end package PkgInstructionFifo;

package body PkgInstructionFifo is

  ---------------------------------------------------------------------------------------
  -- Status
  ---------------------------------------------------------------------------------------

  function Unflatten (
    slv : FlatIFifoReadStatus_t)
    return IFifoReadStatus_t is
    alias slvLcl : std_logic_vector(slv'length-1 downto 0) is slv;
    variable retVal : IFifoReadStatus_t;
  begin  -- function Unflatten

    -- Default empty assignment. Will override as appropriate.
    retVal := kIFifoReadStatusZero;

    if kIFifoReturnsStatus then
      retVal.IsError := to_Boolean(slvLcl(kIFifoReadStatusErrorIndex));
      retVal.Last := to_Boolean(slvLcl(kIFifoReadStatusLastIndex));
    end if;

    return retVal;

  end function Unflatten;

  function Flatten (
    val : IFifoReadStatus_t)
    return FlatIFifoReadStatus_t is
    variable retVal : FlatIFifoReadStatus_t;
  begin  -- function Flatten
    retval := (others => '0');
    if kIFifoReturnsStatus then
      retVal(kIFifoReadStatusErrorIndex) := to_StdLogic(val.IsError);
      retVal(kIFifoReadStatusLastIndex) := to_StdLogic(val.Last);
    end if;

    return retVal;
  end function Flatten;

  ---------------------------------------------------------------------------------------
  -- Read
  ---------------------------------------------------------------------------------------

  function Unflatten (
    slv : FlatIFifoRead_t)
    return IFifoRead_t is
    alias slvLcl        : std_logic_vector(slv'length-1 downto 0) is slv;
    variable retVal     : IFifoRead_t;
    variable goingIndex : natural := 0;
  begin  -- function Unflatten

    -- Data
    retVal.Data := slvLcl(kIFifoReadDataWidth-1 downto 0);
    goingIndex  := kIFifoReadDataWidth;

    -- Status. This default assignment and the following conditional avoids awkward
    -- assignment of stuff that may not be there.
    retVal.Status := kIFifoReadStatusZero;
    if kIFifoReturnsStatus then
      retVal.Status := Unflatten(slvLcl(goingIndex + kIFifoReadStatusWidth -1 downto
                                        goingIndex));
      goingIndex := goingIndex + kIFifoReadStatusWidth;
    end if;

    -- Sentinel
    retVal.Sentinel := unsigned(slvLcl(goingIndex + kIFifoSentinelWidth- 1
                                       downto goingIndex));

    return retVal;
  end function Unflatten;

  function Flatten (
    val : IFifoRead_t)
    return FlatIFifoRead_t is
    variable retVal : FlatIFifoRead_t;
  begin  -- function Flatten

    -- This conditional prevents awkward null assignments.
    if kIFifoReturnsStatus then
      retVal := std_logic_vector(val.Sentinel) & Flatten(val.Status) & std_logic_vector(val.Data);
    else
      retVal := std_logic_vector(val.Sentinel) & std_logic_vector(val.Data);
    end if;
    return retVal;
  end function Flatten;

  ---------------------------------------------------------------------------------------
  -- Other
  ---------------------------------------------------------------------------------------

  function GetAddressWidthModifier (
    constant kDmaWidth         :    natural;
    constant kInstructionWidth : in natural)
    return integer is
  begin  -- function GetAddressWidthModifier

    -- We get around the fact that we are using integer division and logarithms by
    -- distinguishing between the cases where DmaWidth is bigger and the case where
    -- kInstructionWidth is larger.
    --
    -- GetAddressWidthModifier may not work correctly if kDmaWidth and
    -- kInstructionWidth are relative primes, so we add in checks for that.
    if kDmaWidth > kInstructionWidth then

      --synthesis translate_off
      assert kDmaWidth mod kInstructionWidth = 0
        report "kInstructionWidth is not a divisor of kDmaWidth."
        severity error;
      --synthesis translate_on

      return 0 - Log2(kDmaWidth / kInstructionWidth);

    else

      --synthesis translate_off
      assert kInstructionWidth mod kDmaWidth = 0
        report "kDmaWidth is not a divisor of kInstructionWidth."
        severity error;
      --synthesis translate_on

      return Log2(kInstructionWidth / kDmaWidth);

    end if;
  end function GetAddressWidthModifier;

end package body PkgInstructionFifo;
