-------------------------------------------------------------------------------
--
-- File: PkgDmaPortDmaFifosFlatTypes.vhd
-- Author: Florin Hurgoi
-- Original Project: LabVIEW Fpga Communication Interface
-- Date: 07 December 2011
--
-------------------------------------------------------------------------------
-- (c) 2008 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
-- This package contains functions for flattening and unflattening the records and
-- arrays of records into std_logic_vector's.
--

-- Harmish - 08/04/2014 - Added support for Flush Method.
-- + Flatten and Unflatten functions are updated for InputStreamInterfaceFromFifo_t record.
-- + To reflect this change in modegen, the following VI is modified.
--   \\lvfpga\fpga\main\trunk\8.0\source\LabVIEW\resource\RVI\CommunicationInterface\PlugIns\DmaPortModGen.llb\Utilities\niFpgaGetDmaStreamPortSignalWidth.vi
-------------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

  use work.PkgDmaPortDmaFifos.all;

Package PkgDmaPortDmaFifosFlatTypes is

  subtype InputStreamInterfaceToFifoFlat_t is 
    std_logic_vector(SizeOf(kInputStreamInterfaceToFifoZero)-1 downto 0);
  subtype InputStreamInterfaceFromFifoFlat_t is
    std_logic_vector(SizeOf(kInputStreamInterfaceFromFifoZero)-1 downto 0);
  subtype OutputStreamInterfaceToFifoFlat_t is
    std_logic_vector(SizeOf(kOutputStreamInterfaceToFifoZero)-1 downto 0);
  subtype OutputStreamInterfaceFromFifoFlat_t is
    std_logic_vector(SizeOf(kOutputStreamInterfaceFromFifoZero)-1 downto 0);

  -- Arrays of flattened stream interface types
  type InputStreamInterfaceFromFifoFlatArray_t is array (natural range <>) of
    InputStreamInterfaceFromFifoFlat_t;
  type InputStreamInterfaceToFifoFlatArray_t is array (natural range <>) of
    InputStreamInterfaceToFifoFlat_t;
  type OutputStreamInterfaceFromFifoFlatArray_t is array (natural range <>) of
    OutputStreamInterfaceFromFifoFlat_t;
  type OutputStreamInterfaceToFifoFlatArray_t is array (natural range <>) of
    OutputStreamInterfaceToFifoFlat_t;


  -- Functions to flatten the stream interface types
  function FlattenStreamInterface(arg : InputStreamInterfaceFromFifo_t) return
    InputStreamInterfaceFromFifoFlat_t;
  function FlattenStreamInterface(arg : InputStreamInterfaceToFifo_t) return
    InputStreamInterfaceToFifoFlat_t;
  function FlattenStreamInterface(arg : OutputStreamInterfaceFromFifo_t) return
    OutputStreamInterfaceFromFifoFlat_t;
  function FlattenStreamInterface(arg : OutputStreamInterfaceToFifo_t) return
    OutputStreamInterfaceToFifoFlat_t;

  function FlattenStreamInterface(arg : InputStreamInterfaceFromFifoArray_t) return
    std_logic_vector;
  function FlattenStreamInterface(arg : InputStreamInterfaceToFifoArray_t) return
    std_logic_vector;
  function FlattenStreamInterface(arg : OutputStreamInterfaceFromFifoArray_t) return
    std_logic_vector;
  function FlattenStreamInterface(arg : OutputStreamInterfaceToFifoArray_t) return
    std_logic_vector;

  -- Functions to unflatten the stream interface types
  function UnflattenStreamInterface(arg : InputStreamInterfaceFromFifoFlat_t) return
    InputStreamInterfaceFromFifo_t;
  function UnflattenStreamInterface(arg : InputStreamInterfaceToFifoFlat_t) return
    InputStreamInterfaceToFifo_t;
  function UnflattenStreamInterface(arg : OutputStreamInterfaceFromFifoFlat_t) return
    OutputStreamInterfaceFromFifo_t;
  function UnflattenStreamInterface(arg : OutputStreamInterfaceToFifoFlat_t) return
    OutputStreamInterfaceToFifo_t;
  function UnflattenStreamInterface(Vector : std_logic_vector) return
    InputStreamInterfaceFromFifoArray_t;
  function UnflattenStreamInterface(Vector : std_logic_vector) return
    InputStreamInterfaceToFifoArray_t;
  function UnflattenStreamInterface(Vector : std_logic_vector) return
    OutputStreamInterfaceFromFifoArray_t;
  function UnflattenStreamInterface(Vector : std_logic_vector) return
    OutputStreamInterfaceToFifoArray_t;

  -- Functions to flatten arrays of stream interface types
  function FlattenStreamInterface(arg : InputStreamInterfaceFromFifoArray_t) return
    InputStreamInterfaceFromFifoFlatArray_t;
  function FlattenStreamInterface(arg : InputStreamInterfaceToFifoArray_t) return
    InputStreamInterfaceToFifoFlatArray_t;
  function FlattenStreamInterface(arg : OutputStreamInterfaceFromFifoArray_t) return
    OutputStreamInterfaceFromFifoFlatArray_t;
  function FlattenStreamInterface(arg : OutputStreamInterfaceToFifoArray_t) return
    OutputStreamInterfaceToFifoFlatArray_t;

  -- Functions to unflatten arrays of stream interface types
  function UnflattenStreamInterface(arg : InputStreamInterfaceFromFifoFlatArray_t) return
    InputStreamInterfaceFromFifoArray_t;
  function UnflattenStreamInterface(arg : InputStreamInterfaceToFifoFlatArray_t) return
    InputStreamInterfaceToFifoArray_t;
  function UnflattenStreamInterface(arg : OutputStreamInterfaceFromFifoFlatArray_t)
    return OutputStreamInterfaceFromFifoArray_t;
  function UnflattenStreamInterface(arg : OutputStreamInterfaceToFifoFlatArray_t) return
    OutputStreamInterfaceToFifoArray_t;

  -- Functions to convert the stream interface array types to std logic vectors.
  function StreamInterfaceArrayToVector(
    arg : InputStreamInterfaceFromFifoFlatArray_t) return std_logic_vector;
  function StreamInterfaceArrayToVector(
    arg : InputStreamInterfaceToFifoFlatArray_t) return std_logic_vector;
  function StreamInterfaceArrayToVector(
    arg : OutputStreamInterfaceFromFifoFlatArray_t) return std_logic_vector;
  function StreamInterfaceArrayToVector(
    arg : OutputStreamInterfaceToFifoFlatArray_t) return std_logic_vector;

  -- Functions to convert the stream interface array types from std logic vectors.
  function StreamInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return InputStreamInterfaceFromFifoFlatArray_t;
  function StreamInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return InputStreamInterfaceToFifoFlatArray_t;
  function StreamInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return OutputStreamInterfaceFromFifoFlatArray_t;
  function StreamInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return OutputStreamInterfaceToFifoFlatArray_t;

end PkgDmaPortDmaFifosFlatTypes;


package body PkgDmaPortDmaFifosFlatTypes is

  ---------------------------------------------------------------------------------------
  -- Flattening functions for Stream Interface types.
  ---------------------------------------------------------------------------------------

  function FlattenStreamInterface(arg : InputStreamInterfaceFromFifo_t) return
    InputStreamInterfaceFromFifoFlat_t is

    variable ReturnVal : InputStreamInterfaceFromFifoFlat_t;
    variable index: natural := 0;

  begin

    ReturnVal(index) := to_StdLogic(arg.ResetDone);
    index := index + 1;
    ReturnVal(index + arg.FifoDataOut'length-1 downto index) := arg.FifoDataOut;
    index := index + arg.FifoDataOut'length;
    ReturnVal(index + arg.FifoFullCount'length-1 downto index) :=
      std_logic_vector(arg.FifoFullCount);
    index := index + arg.FifoFullCount'length;
    ReturnVal(index) := to_StdLogic(arg.FifoOverflow);
    index := index + 1;
    ReturnVal(index + arg.ByteLanePtr'length-1 downto index) :=
      std_logic_vector(arg.ByteLanePtr);
    index := index + arg.ByteLanePtr'length;
    ReturnVal(index) := to_StdLogic(arg.StartStreamRequest);
    index := index + 1;
    ReturnVal(index) := to_StdLogic(arg.StopStreamRequest);
    index := index + 1;
    ReturnVal(index) := to_StdLogic(arg.StopStreamWithFlushRequest);
    index := index + 1;
	ReturnVal(index) := to_StdLogic(arg.FlushRequest);
    index := index + 1;
    ReturnVal(index) := to_StdLogic(arg.WritesDisabled);
    index := index + 1;
    ReturnVal(index) := to_StdLogic(arg.WriteDetected);
    index := index + 1;
    ReturnVal(index + arg.StateInDefaultClkDomain'length-1 downto index) :=
      arg.StateInDefaultClkDomain;

    return ReturnVal;

  end FlattenStreamInterface;


  function FlattenStreamInterface(arg : InputStreamInterfaceToFifo_t) return
    InputStreamInterfaceToFifoFlat_t is

    variable ReturnVal : InputStreamInterfaceToFifoFlat_t;
    variable index: natural := 0;

  begin

    ReturnVal(index) := to_StdLogic(arg.DmaReset);
    index := index + 1;
    ReturnVal(index) := to_StdLogic(arg.Pop);
    index := index + 1;
    ReturnVal(index) := to_StdLogic(arg.TransferEnd);
    index := index + 1;
    ReturnVal(index + arg.ByteCount'length-1 downto index) :=
      std_logic_vector(arg.ByteCount);
    index := index + arg.ByteCount'length;
    ReturnVal(index + arg.ByteEnable'length-1 downto index) :=
      to_StdLogicVector(arg.ByteEnable);
    index := index + arg.ByteEnable'length;
    ReturnVal(index + arg.NumReadSamples'length-1 downto index) :=
      std_logic_vector(arg.NumReadSamples);
    index := index + arg.NumReadSamples'length;
    ReturnVal(index) := to_StdLogic(arg.RsrvReadSpaces);
    index := index + 1;
    ReturnVal(index + arg.StreamState'length-1 downto index) := arg.StreamState;

    return ReturnVal;

  end FlattenStreamInterface;


  function FlattenStreamInterface(arg : OutputStreamInterfaceFromFifo_t) return
    OutputStreamInterfaceFromFifoFlat_t is

    variable ReturnVal : OutputStreamInterfaceFromFifoFlat_t;
    variable index: natural := 0;

  begin

    ReturnVal(index) := to_StdLogic(arg.ResetDone);
    index := index + 1;
    ReturnVal(index + arg.EmptyCount'length-1 downto index) :=
      std_logic_vector(arg.EmptyCount);
    index := index + arg.EmptyCount'length;
    ReturnVal(index) := to_StdLogic(arg.RsrvdSpacesFilled);
    index := index + 1;
    ReturnVal(index) := to_StdLogic(arg.FifoUnderflow);
    index := index + 1;
    ReturnVal(index) := to_StdLogic(arg.StartStreamRequest);
    index := index + 1;
    ReturnVal(index) := to_StdLogic(arg.StopStreamRequest);
    index := index + 1;
    ReturnVal(index + arg.HostReadableFullCount'length-1 downto index) :=
      std_logic_vector(arg.HostReadableFullCount);
    index := index + arg.HostReadableFullCount'length;
    ReturnVal(index + arg.StateInDefaultClkDomain'length-1 downto index) :=
      arg.StateInDefaultClkDomain;

    return ReturnVal;

  end FlattenStreamInterface;


  function FlattenStreamInterface(arg : OutputStreamInterfaceToFifo_t) return
    OutputStreamInterfaceToFifoFlat_t is

    variable ReturnVal : OutputStreamInterfaceToFifoFlat_t;
    variable index: natural := 0;

  begin

    ReturnVal(index) := to_StdLogic(arg.DmaReset);
    index := index + 1;
    ReturnVal(index) := to_StdLogic(arg.FifoWrite);
    index := index + 1;
    ReturnVal(index + arg.WriteLengthInBytes'length-1 downto index) :=
      std_logic_vector(arg.WriteLengthInBytes);
    index := index + arg.WriteLengthInBytes'length;
    ReturnVal(index + arg.FifoData'length-1 downto index) := arg.FifoData;
    index := index + arg.FifoData'length;
    ReturnVal(index + arg.ByteEnable'length-1 downto index) :=
      to_StdLogicVector(arg.ByteEnable);
    index := index + arg.ByteEnable'length;
    ReturnVal(index) := to_StdLogic(arg.RsrvWriteSpaces);
    index := index + 1;
    ReturnVal(index + arg.NumWriteSpaces'length-1 downto index) :=
      std_logic_vector(arg.NumWriteSpaces);
    index := index + arg.NumWriteSpaces'length;
    ReturnVal(index + arg.StreamState'length-1 downto index) := arg.StreamState;
    index := index + arg.StreamState'length;
    ReturnVal(index) := to_StdLogic(arg.ReportDisabledToDiagram);

    return ReturnVal;

  end FlattenStreamInterface;


  ---------------------------------------------------------------------------------------
  -- Unflattening functions for Stream Interface types.
  ---------------------------------------------------------------------------------------

  function UnflattenStreamInterface(arg : InputStreamInterfaceFromFifoFlat_t) return
    InputStreamInterfaceFromFifo_t is

    variable ReturnVal : InputStreamInterfaceFromFifo_t;
    variable index : natural := 0;

  begin

    ReturnVal.ResetDone := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.FifoDataOut := arg(index + ReturnVal.FifoDataOut'length-1 downto index);
    index := index + ReturnVal.FifoDataOut'length;
    ReturnVal.FifoFullCount :=
      unsigned(arg(index + ReturnVal.FifoFullCount'length-1 downto index));
    index := index + ReturnVal.FifoFullCount'length;
    ReturnVal.FifoOverflow := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.ByteLanePtr := unsigned(arg(index + ReturnVal.ByteLanePtr'length-1 downto index));
    index := index + ReturnVal.ByteLanePtr'length;
    ReturnVal.StartStreamRequest := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.StopStreamRequest := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.StopStreamWithFlushRequest := to_Boolean(arg(index));
    index := index + 1;
	ReturnVal.FlushRequest := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.WritesDisabled := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.WriteDetected := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.StateInDefaultClkDomain :=
      arg(index + ReturnVal.StateInDefaultClkDomain'length-1 downto index);

    return ReturnVal;

  end UnflattenStreamInterface;



  function UnflattenStreamInterface(arg : InputStreamInterfaceToFifoFlat_t) return
    InputStreamInterfaceToFifo_t is

    variable ReturnVal : InputStreamInterfaceToFifo_t;
    variable index : natural := 0;

  begin

    ReturnVal.DmaReset := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.Pop := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.TransferEnd := to_Boolean(arg(2));
    index := index + 1;
    ReturnVal.ByteCount :=
      unsigned(arg(index + ReturnVal.ByteCount'length-1 downto index));
    index := index + ReturnVal.ByteCount'length;
    ReturnVal.ByteEnable := 
      to_BooleanVector(arg(index + ReturnVal.ByteEnable'length-1 downto index));
    index := index + ReturnVal.ByteEnable'length;
    ReturnVal.NumReadSamples :=
      unsigned(arg(index + ReturnVal.NumReadSamples'length-1 downto index));
    index := index + ReturnVal.NumReadSamples'length;
    ReturnVal.RsrvReadSpaces := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.StreamState := arg(index + ReturnVal.StreamState'length-1 downto index);

    return ReturnVal;

  end UnflattenStreamInterface;



  function UnflattenStreamInterface(arg : OutputStreamInterfaceFromFifoFlat_t) return
    OutputStreamInterfaceFromFifo_t is

    variable ReturnVal : OutputStreamInterfaceFromFifo_t;
    variable index : natural := 0;

  begin

    ReturnVal.ResetDone := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.EmptyCount := 
      unsigned(arg(index + ReturnVal.EmptyCount'length-1 downto index));
    index := index + ReturnVal.EmptyCount'length;
    ReturnVal.RsrvdSpacesFilled := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.FifoUnderflow := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.StartStreamRequest := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.StopStreamRequest := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.HostReadableFullCount :=
      unsigned(arg(index + ReturnVal.HostReadableFullCount'length-1 downto index));
    index := index + ReturnVal.HostReadableFullCount'length;
    ReturnVal.StateInDefaultClkDomain :=
      arg(index + ReturnVal.StateInDefaultClkDomain'length-1 downto index);

    return ReturnVal;

  end UnflattenStreamInterface;


  function UnflattenStreamInterface(arg : OutputStreamInterfaceToFifoFlat_t) return
    OutputStreamInterfaceToFifo_t is

    variable ReturnVal : OutputStreamInterfaceToFifo_t;
    variable index : natural := 0;

  begin

    ReturnVal.DmaReset := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.FifoWrite := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.WriteLengthInBytes :=
      unsigned(arg(index + ReturnVal.WriteLengthInBytes'length-1 downto index));
    index := index + ReturnVal.WriteLengthInBytes'length;
    ReturnVal.FifoData := arg(index + ReturnVal.FifoData'length-1 downto index);
    index := index + ReturnVal.FifoData'length;
    ReturnVal.ByteEnable :=
      to_BooleanVector(arg(index + ReturnVal.ByteEnable'length-1 downto index));
    index := index + ReturnVal.ByteEnable'length;
    ReturnVal.RsrvWriteSpaces := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.NumWriteSpaces :=
      unsigned(arg(index + ReturnVal.NumWriteSpaces'length-1 downto index));
    index := index + ReturnVal.NumWriteSpaces'length;
    ReturnVal.StreamState := arg(index + ReturnVal.StreamState'length-1 downto index);
    index := index + ReturnVal.StreamState'length;
    ReturnVal.ReportDisabledToDiagram := to_Boolean(arg(index));

    return ReturnVal;

  end UnflattenStreamInterface;


  ---------------------------------------------------------------------------------------
  -- Flattening functions for Stream Interface array types.
  ---------------------------------------------------------------------------------------

  function FlattenStreamInterface(arg : InputStreamInterfaceFromFifoArray_t) return
    InputStreamInterfaceFromFifoFlatArray_t is

    variable ReturnVal : InputStreamInterfaceFromFifoFlatArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := FlattenStreamInterface(arg(i));
    end loop;

    return ReturnVal;

  end FlattenStreamInterface;


  function FlattenStreamInterface(arg : InputStreamInterfaceToFifoArray_t) return
    InputStreamInterfaceToFifoFlatArray_t is

    variable ReturnVal : InputStreamInterfaceToFifoFlatArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := FlattenStreamInterface(arg(i));
    end loop;

    return ReturnVal;

  end FlattenStreamInterface;


  function FlattenStreamInterface(arg : OutputStreamInterfaceFromFifoArray_t) return
    OutputStreamInterfaceFromFifoFlatArray_t is

    variable ReturnVal : OutputStreamInterfaceFromFifoFlatArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := FlattenStreamInterface(arg(i));
    end loop;

    return ReturnVal;

  end FlattenStreamInterface;


  function FlattenStreamInterface(arg : OutputStreamInterfaceToFifoArray_t) return
    OutputStreamInterfaceToFifoFlatArray_t is

    variable ReturnVal : OutputStreamInterfaceToFifoFlatArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := FlattenStreamInterface(arg(i));
    end loop;

    return ReturnVal;

  end FlattenStreamInterface;


  ---------------------------------------------------------------------------------------
  -- Unflattening functions for Stream Interface array types.
  ---------------------------------------------------------------------------------------

  function UnflattenStreamInterface(arg : InputStreamInterfaceFromFifoFlatArray_t) return
    InputStreamInterfaceFromFifoArray_t is

    variable ReturnVal : InputStreamInterfaceFromFifoArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := UnflattenStreamInterface(arg(i));
    end loop;

    return ReturnVal;

  end UnflattenStreamInterface;


  function UnflattenStreamInterface(arg : InputStreamInterfaceToFifoFlatArray_t) return
    InputStreamInterfaceToFifoArray_t is

    variable ReturnVal : InputStreamInterfaceToFifoArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := UnflattenStreamInterface(arg(i));
    end loop;

    return ReturnVal;

  end UnflattenStreamInterface;


  function UnflattenStreamInterface(arg : OutputStreamInterfaceFromFifoFlatArray_t)
    return OutputStreamInterfaceFromFifoArray_t is

    variable ReturnVal : OutputStreamInterfaceFromFifoArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := UnflattenStreamInterface(arg(i));
    end loop;

    return ReturnVal;

  end UnflattenStreamInterface;


  function UnflattenStreamInterface(arg : OutputStreamInterfaceToFifoFlatArray_t) return
    OutputStreamInterfaceToFifoArray_t is

    variable ReturnVal : OutputStreamInterfaceToFifoArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := UnflattenStreamInterface(arg(i));
    end loop;

    return ReturnVal;

  end UnflattenStreamInterface;


  function StreamInterfaceArrayToVector(
    arg : InputStreamInterfaceFromFifoFlatArray_t) return std_logic_vector
  is

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*InputStreamInterfaceFromFifoFlat_t'length-1 downto 0);

  begin

    for i in ArraySize-1 downto 0 loop
      ReturnVal(((i+1)*InputStreamInterfaceFromFifoFlat_t'length)-1 downto
                i*InputStreamInterfaceFromFifoFlat_t'length) := arg(i);
    end loop;

    return ReturnVal;

  end StreamInterfaceArrayToVector;


  function StreamInterfaceArrayToVector(
    arg : InputStreamInterfaceToFifoFlatArray_t) return std_logic_vector
  is

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*InputStreamInterfaceToFifoFlat_t'length-1 downto 0);

  begin

    for i in ArraySize-1 downto 0 loop
      ReturnVal(((i+1)*InputStreamInterfaceToFifoFlat_t'length)-1 downto
                i*InputStreamInterfaceToFifoFlat_t'length) := arg(i);
    end loop;

    return ReturnVal;

  end StreamInterfaceArrayToVector;


  function StreamInterfaceArrayToVector(
    arg : OutputStreamInterfaceFromFifoFlatArray_t) return std_logic_vector
  is

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*OutputStreamInterfaceFromFifoFlat_t'length-1 downto 0);

  begin

    for i in ArraySize-1 downto 0 loop
      ReturnVal(((i+1)*OutputStreamInterfaceFromFifoFlat_t'length)-1 downto
                i*OutputStreamInterfaceFromFifoFlat_t'length) := arg(i);
    end loop;

    return ReturnVal;

  end StreamInterfaceArrayToVector;


  function StreamInterfaceArrayToVector(
    arg : OutputStreamInterfaceToFifoFlatArray_t) return std_logic_vector
  is

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*OutputStreamInterfaceToFifoFlat_t'length-1 downto 0);

  begin

    for i in ArraySize-1 downto 0 loop
      ReturnVal(((i+1)*OutputStreamInterfaceToFifoFlat_t'length)-1 downto
                i*OutputStreamInterfaceToFifoFlat_t'length) := arg(i);
    end loop;

    return ReturnVal;

  end StreamInterfaceArrayToVector;


  -- Functions to convert the stream interface array types from std logic vectors.
  function StreamInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return InputStreamInterfaceFromFifoFlatArray_t
  is

    variable ReturnVal : InputStreamInterfaceFromFifoFlatArray_t(ArraySize-1 downto 0);

  begin

    for i in ReturnVal'length-1 downto 0 loop
      ReturnVal(i) := Vector((i+1)*InputStreamInterfaceFromFifoFlat_t'length-1
        downto i*InputStreamInterfaceFromFifoFlat_t'length);
    end loop;

    return ReturnVal;

  end StreamInterfaceVectorToArray;


  function StreamInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return InputStreamInterfaceToFifoFlatArray_t
  is

    variable ReturnVal : InputStreamInterfaceToFifoFlatArray_t(ArraySize-1 downto 0);

  begin

    for i in ReturnVal'length-1 downto 0 loop
      ReturnVal(i) := Vector((i+1)*InputStreamInterfaceToFifoFlat_t'length-1
        downto i*InputStreamInterfaceToFifoFlat_t'length);
    end loop;

    return ReturnVal;

  end StreamInterfaceVectorToArray;


  function StreamInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return OutputStreamInterfaceFromFifoFlatArray_t
  is

    variable ReturnVal : OutputStreamInterfaceFromFifoFlatArray_t(ArraySize-1 downto 0);

  begin

    for i in ReturnVal'length-1 downto 0 loop
      ReturnVal(i) := Vector((i+1)*OutputStreamInterfaceFromFifoFlat_t'length-1
        downto i*OutputStreamInterfaceFromFifoFlat_t'length);
    end loop;

    return ReturnVal;

  end StreamInterfaceVectorToArray;


  function StreamInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return OutputStreamInterfaceToFifoFlatArray_t
  is

    variable ReturnVal : OutputStreamInterfaceToFifoFlatArray_t(ArraySize-1 downto 0);

  begin

    for i in ReturnVal'length-1 downto 0 loop
      ReturnVal(i) := Vector((i+1)*OutputStreamInterfaceToFifoFlat_t'length-1
        downto i*OutputStreamInterfaceToFifoFlat_t'length);
    end loop;

    return ReturnVal;

  end StreamInterfaceVectorToArray;


  function FlattenStreamInterface(
    arg : InputStreamInterfaceFromFifoArray_t) return std_logic_vector
  is

    variable TempArray : InputStreamInterfaceFromFifoFlatArray_t(arg'range);

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*InputStreamInterfaceFromFifoFlat_t'length-1 downto 0);

  begin

    TempArray := FlattenStreamInterface(arg);
    ReturnVal := StreamInterfaceArrayToVector(TempArray);

    return ReturnVal;

  end FlattenStreamInterface;


  function FlattenStreamInterface(
    arg : InputStreamInterfaceToFifoArray_t) return std_logic_vector
  is

    variable TempArray : InputStreamInterfaceToFifoFlatArray_t(arg'range);

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*InputStreamInterfaceToFifoFlat_t'length-1 downto 0);

  begin

    TempArray := FlattenStreamInterface(arg);
    ReturnVal := StreamInterfaceArrayToVector(TempArray);

    return ReturnVal;

  end FlattenStreamInterface;

  function FlattenStreamInterface(
    arg : OutputStreamInterfaceFromFifoArray_t) return std_logic_vector
  is

    variable TempArray : OutputStreamInterfaceFromFifoFlatArray_t(arg'range);

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*OutputStreamInterfaceFromFifoFlat_t'length-1 downto 0);

  begin

    TempArray := FlattenStreamInterface(arg);
    ReturnVal := StreamInterfaceArrayToVector(TempArray);

    return ReturnVal;

  end FlattenStreamInterface;


  function FlattenStreamInterface(
    arg : OutputStreamInterfaceToFifoArray_t) return std_logic_vector
  is

    variable TempArray : OutputStreamInterfaceToFifoFlatArray_t(arg'range);

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*OutputStreamInterfaceToFifoFlat_t'length-1 downto 0);

  begin

    TempArray := FlattenStreamInterface(arg);
    ReturnVal := StreamInterfaceArrayToVector(TempArray);

    return ReturnVal;

  end FlattenStreamInterface;


  -- Functions to unflatten the stream interface types
  function UnflattenStreamInterface(
    Vector    : std_logic_vector) return InputStreamInterfaceFromFifoArray_t
  is

    constant ArraySize : natural := Vector'length /
      InputStreamInterfaceFromFifoFlat_t'length;
    variable TempArray : InputStreamInterfaceFromFifoFlatArray_t(ArraySize-1 downto 0);
    variable ReturnVal : InputStreamInterfaceFromFifoArray_t(ArraySize-1 downto 0);

  begin

    TempArray := StreamInterfaceVectorToArray(ArraySize, Vector);
    ReturnVal := UnflattenStreamInterface(TempArray);

    return ReturnVal;

  end UnflattenStreamInterface;


  function UnflattenStreamInterface(
    Vector    : std_logic_vector) return InputStreamInterfaceToFifoArray_t
  is

    constant ArraySize : natural := Vector'length /
      InputStreamInterfaceToFifoFlat_t'length;
    variable TempArray : InputStreamInterfaceToFifoFlatArray_t(ArraySize-1 downto 0);
    variable ReturnVal : InputStreamInterfaceToFifoArray_t(ArraySize-1 downto 0);

  begin

    TempArray := StreamInterfaceVectorToArray(ArraySize, Vector);
    ReturnVal := UnflattenStreamInterface(TempArray);

    return ReturnVal;

  end UnflattenStreamInterface;


  function UnflattenStreamInterface(
    Vector    : std_logic_vector) return OutputStreamInterfaceFromFifoArray_t
  is

    constant ArraySize : natural := Vector'length /
      OutputStreamInterfaceFromFifoFlat_t'length;
    variable TempArray : OutputStreamInterfaceFromFifoFlatArray_t(ArraySize-1 downto 0);
    variable ReturnVal : OutputStreamInterfaceFromFifoArray_t(ArraySize-1 downto 0);

  begin

    TempArray := StreamInterfaceVectorToArray(ArraySize, Vector);
    ReturnVal := UnflattenStreamInterface(TempArray);

    return ReturnVal;

  end UnflattenStreamInterface;


  function UnflattenStreamInterface(
    Vector    : std_logic_vector) return OutputStreamInterfaceToFifoArray_t
  is

    constant ArraySize : natural := Vector'length /
      OutputStreamInterfaceToFifoFlat_t'length;
    variable TempArray : OutputStreamInterfaceToFifoFlatArray_t(ArraySize-1 downto 0);
    variable ReturnVal : OutputStreamInterfaceToFifoArray_t(ArraySize-1 downto 0);

  begin

    TempArray := StreamInterfaceVectorToArray(ArraySize, Vector);
    ReturnVal := UnflattenStreamInterface(TempArray);

    return ReturnVal;

  end UnflattenStreamInterface;

end PkgDmaPortDmaFifosFlatTypes;