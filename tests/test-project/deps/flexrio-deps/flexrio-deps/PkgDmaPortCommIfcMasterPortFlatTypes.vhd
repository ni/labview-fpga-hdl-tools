-------------------------------------------------------------------------------
--
-- File: PkgDmaPortCommIfcMasterPortFlatTypes.vhd
-- Author: Florin Hurgoi
-- Original Project: LabVIEW Fpga Communication Interface
-- Date: 13 February 2012
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
-------------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;
  use work.PkgDmaPortCommIfcMasterPort.all;

Package PkgDmaPortCommIfcMasterPortFlatTypes is

  subtype NiFpgaMasterWriteRequestFromMasterFlat_t is 
    std_logic_vector(SizeOf(kNiFpgaMasterWriteRequestFromMasterZero)-1 downto 0);
  subtype NiFpgaMasterWriteRequestToMasterFlat_t is
    std_logic_vector(SizeOf(kNiFpgaMasterWriteRequestToMasterZero)-1 downto 0);
  subtype NiFpgaMasterWriteDataFromMasterFlat_t is
    std_logic_vector(SizeOf(kNiFpgaMasterWriteDataFromMasterZero)-1 downto 0);
  subtype NiFpgaMasterWriteDataToMasterFlat_t is
    std_logic_vector(SizeOf(kNiFpgaMasterWriteDataToMasterZero)-1 downto 0);
  subtype NiFpgaMasterWriteStatusToMasterFlat_t is
    std_logic_vector(SizeOf(kNiFpgaMasterWriteStatusToMasterZero)-1 downto 0);
  subtype NiFpgaMasterReadRequestFromMasterFlat_t is
    std_logic_vector(SizeOf(kNiFpgaMasterReadRequestFromMasterZero)-1 downto 0);
  subtype NiFpgaMasterReadRequestToMasterFlat_t is
    std_logic_vector(SizeOf(kNiFpgaMasterReadRequestToMasterZero)-1 downto 0);
  subtype NiFpgaMasterReadDataToMasterFlat_t is
    std_logic_vector(SizeOf(kNiFpgaMasterReadDataToMasterZero)-1 downto 0);

  -- Arrays of flattened MasterPort interface types
  type NiFpgaMasterWriteRequestFromMasterFlatArray_t is array (natural range <>) of
    NiFpgaMasterWriteRequestFromMasterFlat_t;
  type NiFpgaMasterWriteRequestToMasterFlatArray_t is array (natural range <>) of
    NiFpgaMasterWriteRequestToMasterFlat_t;
  type NiFpgaMasterWriteDataFromMasterFlatArray_t is array (natural range <>) of
    NiFpgaMasterWriteDataFromMasterFlat_t;
  type NiFpgaMasterWriteDataToMasterFlatArray_t is array (natural range <>) of
    NiFpgaMasterWriteDataToMasterFlat_t;
  type NiFpgaMasterWriteStatusToMasterFlatArray_t is array (natural range <>) of
    NiFpgaMasterWriteStatusToMasterFlat_t;
  type NiFpgaMasterReadRequestFromMasterFlatArray_t is array (natural range <>) of
    NiFpgaMasterReadRequestFromMasterFlat_t;
  type NiFpgaMasterReadRequestToMasterFlatArray_t is array (natural range <>) of
    NiFpgaMasterReadRequestToMasterFlat_t;
  type NiFpgaMasterReadDataToMasterFlatArray_t is array (natural range <>) of
    NiFpgaMasterReadDataToMasterFlat_t;

  -- Functions to flatten the Master Port interface types

  -- MasterPort Write flatten functions
  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteRequestFromMaster_t) return
    NiFpgaMasterWriteRequestFromMasterFlat_t;
  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteRequestToMaster_t) return
    NiFpgaMasterWriteRequestToMasterFlat_t;
  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteDataFromMaster_t) return
    NiFpgaMasterWriteDataFromMasterFlat_t;
  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteDataToMaster_t) return
    NiFpgaMasterWriteDataToMasterFlat_t;
  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteStatusToMaster_t) return
    NiFpgaMasterWriteStatusToMasterFlat_t;

  -- MasterPort Read flatten functions
  function FlattenMasterPortInterface(arg : NiFpgaMasterReadRequestFromMaster_t) return
    NiFpgaMasterReadRequestFromMasterFlat_t;
  function FlattenMasterPortInterface(arg : NiFpgaMasterReadRequestToMaster_t) return
    NiFpgaMasterReadRequestToMasterFlat_t;
  function FlattenMasterPortInterface(arg : NiFpgaMasterReadDataToMaster_t) return
    NiFpgaMasterReadDataToMasterFlat_t;

  -- MasterPort Array Write flatten function
  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteRequestFromMasterArray_t)
    return std_logic_vector;
  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteRequestToMasterArray_t)
    return std_logic_vector;
  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteDataFromMasterArray_t)
    return std_logic_vector;
  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteDataToMasterArray_t)
    return std_logic_vector;
  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteStatusToMasterArray_t)
    return std_logic_vector;

  -- MasterPort Array Read flatten function
  function FlattenMasterPortInterface(arg : NiFpgaMasterReadRequestFromMasterArray_t)
    return std_logic_vector;
  function FlattenMasterPortInterface(arg : NiFpgaMasterReadRequestToMasterArray_t)
    return std_logic_vector;
  function FlattenMasterPortInterface(arg : NiFpgaMasterReadDataToMasterArray_t)
    return std_logic_vector;

    -- Functions to convert the MasterPort array types to std logic vectors.
  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterWriteRequestFromMasterFlatArray_t) return std_logic_vector;
  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterWriteRequestToMasterFlatArray_t) return std_logic_vector;
  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterWriteDataFromMasterFlatArray_t) return std_logic_vector;
  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterWriteDataToMasterFlatArray_t) return std_logic_vector;
  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterWriteStatusToMasterFlatArray_t) return std_logic_vector;
  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterReadRequestFromMasterFlatArray_t) return std_logic_vector;
  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterReadRequestToMasterFlatArray_t) return std_logic_vector;
  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterReadDataToMasterFlatArray_t) return std_logic_vector;


  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteRequestFromMasterArray_t)
    return NiFpgaMasterWriteRequestFromMasterFlatArray_t;
  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteRequestToMasterArray_t)
    return NiFpgaMasterWriteRequestToMasterFlatArray_t;
  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteDataFromMasterArray_t)
    return NiFpgaMasterWriteDataFromMasterFlatArray_t;
  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteDataToMasterArray_t)
    return NiFpgaMasterWriteDataToMasterFlatArray_t;
  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteStatusToMasterArray_t)
    return NiFpgaMasterWriteStatusToMasterFlatArray_t;
  function FlattenMasterPortInterface(arg : NiFpgaMasterReadRequestFromMasterArray_t)
    return NiFpgaMasterReadRequestFromMasterFlatArray_t;
  function FlattenMasterPortInterface(arg : NiFpgaMasterReadRequestToMasterArray_t)
    return NiFpgaMasterReadRequestToMasterFlatArray_t;
  function FlattenMasterPortInterface(arg : NiFpgaMasterReadDataToMasterArray_t)
    return NiFpgaMasterReadDataToMasterFlatArray_t;


  -- Functions to unflatten the MasterPort interface types

  -- MasterPort Write unflatten functions
  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteRequestFromMasterFlat_t)
    return NiFpgaMasterWriteRequestFromMaster_t;
  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteRequestToMasterFlat_t)
    return NiFpgaMasterWriteRequestToMaster_t;
  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteDataFromMasterFlat_t)
    return NiFpgaMasterWriteDataFromMaster_t;
  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteDataToMasterFlat_t)
    return NiFpgaMasterWriteDataToMaster_t;
  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteStatusToMasterFlat_t)
    return NiFpgaMasterWriteStatusToMaster_t;

  -- MasterPort Read unflatten functions
  function UnflattenMasterPortInterface(arg : NiFpgaMasterReadRequestFromMasterFlat_t)
    return NiFpgaMasterReadRequestFromMaster_t;
  function UnflattenMasterPortInterface(arg : NiFpgaMasterReadRequestToMasterFlat_t)
    return NiFpgaMasterReadRequestToMaster_t;
  function UnflattenMasterPortInterface(arg : NiFpgaMasterReadDataToMasterFlat_t)
    return NiFpgaMasterReadDataToMaster_t;

  -- Functions to unflatten arrays of stream interface types

  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteRequestFromMasterFlatArray_t)
    return NiFpgaMasterWriteRequestFromMasterArray_t;
  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteRequestToMasterFlatArray_t)
    return NiFpgaMasterWriteRequestToMasterArray_t;
  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteDataFromMasterFlatArray_t)
    return NiFpgaMasterWriteDataFromMasterArray_t;
  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteDataToMasterFlatArray_t)
    return NiFpgaMasterWriteDataToMasterArray_t;
  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteStatusToMasterFlatArray_t)
    return NiFpgaMasterWriteStatusToMasterArray_t;

  function UnflattenMasterPortInterface(arg : NiFpgaMasterReadRequestFromMasterFlatArray_t)
    return NiFpgaMasterReadRequestFromMasterArray_t;
  function UnflattenMasterPortInterface(arg : NiFpgaMasterReadRequestToMasterFlatArray_t)
    return NiFpgaMasterReadRequestToMasterArray_t;
  function UnflattenMasterPortInterface(arg : NiFpgaMasterReadDataToMasterFlatArray_t)
    return NiFpgaMasterReadDataToMasterArray_t;


    -- Functions to convert std logic vectors to MasterPort array types.
  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterWriteRequestFromMasterArray_t;
  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterWriteRequestToMasterArray_t;
  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterWriteDataFromMasterArray_t;
  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterWriteDataToMasterArray_t;
  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterWriteStatusToMasterArray_t;


  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterReadRequestFromMasterArray_t;
  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterReadRequestToMasterArray_t;
  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterReadDataToMasterArray_t;


  -- Functions to convert the stream interface array types from std logic vectors.
  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterWriteRequestFromMasterFlatArray_t;
  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterWriteRequestToMasterFlatArray_t;
  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterWriteDataFromMasterFlatArray_t;
  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterWriteDataToMasterFlatArray_t;
  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterWriteStatusToMasterFlatArray_t;

  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterReadRequestFromMasterFlatArray_t;
  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterReadRequestToMasterFlatArray_t;
  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterReadDataToMasterFlatArray_t;


end PkgDmaPortCommIfcMasterPortFlatTypes;

package body PkgDmaPortCommIfcMasterPortFlatTypes is

  ---------------------------------------------------------------------------------------
  -- Flattening functions for Master Port Interface types.
  ---------------------------------------------------------------------------------------

  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteRequestFromMaster_t) return
    NiFpgaMasterWriteRequestFromMasterFlat_t is

    variable ReturnVal : NiFpgaMasterWriteRequestFromMasterFlat_t;
    variable index: natural := 0;

  begin

    ReturnVal(index) := to_StdLogic(arg.Request);
    index := index + 1;
    ReturnVal(index + arg.Space'length-1 downto index) := arg.Space;
    index := index + arg.Space'length;
    ReturnVal(index + arg.Address'length-1 downto index) :=
      std_logic_vector(arg.Address);
    index := index + arg.Address'length;
    ReturnVal(index + arg.Baggage'length-1 downto index) := arg.Baggage;
    index := index + arg.Baggage'length;
    ReturnVal(index + arg.ByteSwap'length-1 downto index) :=
      std_logic_vector(arg.ByteSwap);
    index := index + arg.ByteSwap'length;
    ReturnVal(index + arg.ByteLane'length-1 downto index) :=
      std_logic_vector(arg.ByteLane);
    index := index + arg.ByteLane'length;
    ReturnVal(index + arg.ByteCount'length-1 downto index) :=
      std_logic_vector(arg.ByteCount);

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteRequestToMaster_t) return
    NiFpgaMasterWriteRequestToMasterFlat_t is

    variable ReturnVal : NiFpgaMasterWriteRequestToMasterFlat_t;
    variable index: natural := 0;

  begin

    ReturnVal(index) := to_StdLogic(arg.Acknowledge);
    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteDataFromMaster_t) return
    NiFpgaMasterWriteDataFromMasterFlat_t is

    variable ReturnVal : NiFpgaMasterWriteDataFromMasterFlat_t;
    variable index: natural := 0;

  begin

    ReturnVal(index + arg.Data'length-1 downto index) := arg.Data;

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteDataToMaster_t) return
    NiFpgaMasterWriteDataToMasterFlat_t is

    variable ReturnVal : NiFpgaMasterWriteDataToMasterFlat_t;
    variable index: natural := 0;

  begin

    ReturnVal(index) := to_StdLogic(arg.TransferStart);
    index := index + 1;
    ReturnVal(index) := to_StdLogic(arg.TransferEnd);
    index := index + 1;
    ReturnVal(index + arg.Space'length-1 downto index) := arg.Space;
    index := index + arg.Space'length;
    ReturnVal(index + arg.ByteLane'length-1 downto index) :=
      std_logic_vector(arg.ByteLane);
    index := index + arg.ByteLane'length;
    ReturnVal(index + arg.ByteCount'length-1 downto index) :=
      std_logic_vector(arg.ByteCount);
    index := index + arg.ByteCount'length;
    ReturnVal(index + arg.ByteEnable'length-1 downto index) :=
      to_StdLogicVector(arg.ByteEnable);
    index := index + arg.ByteEnable'length;
    ReturnVal(index) := to_StdLogic(arg.Pop);

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteStatusToMaster_t) return
    NiFpgaMasterWriteStatusToMasterFlat_t is

    variable ReturnVal : NiFpgaMasterWriteStatusToMasterFlat_t;
    variable index: natural := 0;

  begin

    ReturnVal(index) := to_StdLogic(arg.Ready);
    index := index + 1;
    ReturnVal(index + arg.Space'length-1 downto index) := arg.Space;
    index := index + arg.Space'length;
    ReturnVal(index + arg.ByteCount'length-1 downto index) :=
      std_logic_vector(arg.ByteCount);
    index := index + arg.ByteCount'length;
    ReturnVal(index) := to_StdLogic(arg.ErrorStatus);

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterReadRequestFromMaster_t) return
    NiFpgaMasterReadRequestFromMasterFlat_t is

    variable ReturnVal : NiFpgaMasterReadRequestFromMasterFlat_t;
    variable index: natural := 0;

  begin

    ReturnVal(index) := to_StdLogic(arg.Request);
    index := index + 1;
    ReturnVal(index + arg.Space'length-1 downto index) := arg.Space;
    index := index + arg.Space'length;
    ReturnVal(index + arg.Address'length-1 downto index) :=
      std_logic_vector(arg.Address);
    index := index + arg.Address'length;
    ReturnVal(index + arg.Baggage'length-1 downto index) := arg.Baggage;
    index := index + arg.Baggage'length;
    ReturnVal(index + arg.ByteSwap'length-1 downto index) :=
      std_logic_vector(arg.ByteSwap);
    index := index + arg.ByteSwap'length;
    ReturnVal(index + arg.ByteLane'length-1 downto index) :=
      std_logic_vector(arg.ByteLane);
    index := index + arg.ByteLane'length;
    ReturnVal(index + arg.ByteCount'length-1 downto index) :=
      std_logic_vector(arg.ByteCount);

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterReadRequestToMaster_t) return
    NiFpgaMasterReadRequestToMasterFlat_t is

    variable ReturnVal : NiFpgaMasterReadRequestToMasterFlat_t;
    variable index: natural := 0;

  begin

    ReturnVal(index) := to_StdLogic(arg.Acknowledge);
    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterReadDataToMaster_t) return
    NiFpgaMasterReadDataToMasterFlat_t is

    variable ReturnVal : NiFpgaMasterReadDataToMasterFlat_t;
    variable index: natural := 0;

  begin

    ReturnVal(index) := to_StdLogic(arg.TransferStart);
    index := index + 1;
    ReturnVal(index) := to_StdLogic(arg.TransferEnd);
    index := index + 1;
    ReturnVal(index + arg.Space'length-1 downto index) := arg.Space;
    index := index + arg.Space'length;
    ReturnVal(index + arg.ByteLane'length-1 downto index) :=
      std_logic_vector(arg.ByteLane);
    index := index + arg.ByteLane'length;
    ReturnVal(index + arg.ByteCount'length-1 downto index) :=
      std_logic_vector(arg.ByteCount);
    index := index + arg.ByteCount'length;
    ReturnVal(index) := to_StdLogic(arg.ErrorStatus);
    index := index + 1;
    ReturnVal(index + arg.ByteEnable'length-1 downto index) :=
      to_StdLogicVector(arg.ByteEnable);
    index := index + arg.ByteEnable'length;
    ReturnVal(index) := to_StdLogic(arg.Push);
    index := index + 1;
    ReturnVal(index + arg.Data'length-1 downto index) := arg.Data;

    return ReturnVal;

  end FlattenMasterPortInterface;


  ---------------------------------------------------------------------------------------
  -- Flattening functions for Master Port array types.
  ---------------------------------------------------------------------------------------

  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteRequestFromMasterArray_t)
    return NiFpgaMasterWriteRequestFromMasterFlatArray_t is

    variable ReturnVal : NiFpgaMasterWriteRequestFromMasterFlatArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := FlattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteRequestToMasterArray_t)
    return NiFpgaMasterWriteRequestToMasterFlatArray_t is

    variable ReturnVal : NiFpgaMasterWriteRequestToMasterFlatArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := FlattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteDataFromMasterArray_t)
    return NiFpgaMasterWriteDataFromMasterFlatArray_t is

    variable ReturnVal : NiFpgaMasterWriteDataFromMasterFlatArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := FlattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteDataToMasterArray_t)
    return NiFpgaMasterWriteDataToMasterFlatArray_t is

    variable ReturnVal : NiFpgaMasterWriteDataToMasterFlatArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := FlattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteStatusToMasterArray_t)
    return NiFpgaMasterWriteStatusToMasterFlatArray_t is

    variable ReturnVal : NiFpgaMasterWriteStatusToMasterFlatArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := FlattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterReadRequestFromMasterArray_t)
    return NiFpgaMasterReadRequestFromMasterFlatArray_t is

    variable ReturnVal : NiFpgaMasterReadRequestFromMasterFlatArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := FlattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterReadRequestToMasterArray_t)
    return NiFpgaMasterReadRequestToMasterFlatArray_t is

    variable ReturnVal : NiFpgaMasterReadRequestToMasterFlatArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := FlattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterReadDataToMasterArray_t)
    return NiFpgaMasterReadDataToMasterFlatArray_t is

    variable ReturnVal : NiFpgaMasterReadDataToMasterFlatArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := FlattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end FlattenMasterPortInterface;

  --------------------------------------------------------------------------------------
  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterWriteRequestFromMasterFlatArray_t) return std_logic_vector is

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterWriteRequestFromMasterFlat_t'length-1 downto 0);

  begin

    for i in ArraySize-1 downto 0 loop
      ReturnVal(((i+1)*NiFpgaMasterWriteRequestFromMasterFlat_t'length)-1 downto
                i*NiFpgaMasterWriteRequestFromMasterFlat_t'length) := arg(i);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceArrayToVector;


  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterWriteRequestToMasterFlatArray_t) return std_logic_vector is

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterWriteRequestToMasterFlat_t'length-1 downto 0);

  begin

    for i in ArraySize-1 downto 0 loop
      ReturnVal(((i+1)*NiFpgaMasterWriteRequestToMasterFlat_t'length)-1 downto
                i*NiFpgaMasterWriteRequestToMasterFlat_t'length) := arg(i);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceArrayToVector;


  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterWriteDataFromMasterFlatArray_t) return std_logic_vector is

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterWriteDataFromMasterFlat_t'length-1 downto 0);

  begin

    for i in ArraySize-1 downto 0 loop
      ReturnVal(((i+1)*NiFpgaMasterWriteDataFromMasterFlat_t'length)-1 downto
                i*NiFpgaMasterWriteDataFromMasterFlat_t'length) := arg(i);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceArrayToVector;


  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterWriteDataToMasterFlatArray_t) return std_logic_vector
  is

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterWriteDataToMasterFlat_t'length-1 downto 0);

  begin

    for i in ArraySize-1 downto 0 loop
      ReturnVal(((i+1)*NiFpgaMasterWriteDataToMasterFlat_t'length)-1 downto
                i*NiFpgaMasterWriteDataToMasterFlat_t'length) := arg(i);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceArrayToVector;


  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterWriteStatusToMasterFlatArray_t) return std_logic_vector is

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterWriteStatusToMasterFlat_t'length-1 downto 0);

  begin

    for i in ArraySize-1 downto 0 loop
      ReturnVal(((i+1)*NiFpgaMasterWriteStatusToMasterFlat_t'length)-1 downto
                i*NiFpgaMasterWriteStatusToMasterFlat_t'length) := arg(i);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceArrayToVector;


  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterReadRequestFromMasterFlatArray_t) return std_logic_vector is

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterReadRequestFromMasterFlat_t'length-1 downto 0);

  begin

    for i in ArraySize-1 downto 0 loop
      ReturnVal(((i+1)*NiFpgaMasterReadRequestFromMasterFlat_t'length)-1 downto
                i*NiFpgaMasterReadRequestFromMasterFlat_t'length) := arg(i);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceArrayToVector;


  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterReadRequestToMasterFlatArray_t) return std_logic_vector is

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterReadRequestToMasterFlat_t'length-1 downto 0);

  begin

    for i in ArraySize-1 downto 0 loop
      ReturnVal(((i+1)*NiFpgaMasterReadRequestToMasterFlat_t'length)-1 downto
                i*NiFpgaMasterReadRequestToMasterFlat_t'length) := arg(i);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceArrayToVector;


  function MasterPortInterfaceArrayToVector(
    arg : NiFpgaMasterReadDataToMasterFlatArray_t) return std_logic_vector is

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterReadDataToMasterFlat_t'length-1 downto 0);

  begin

    for i in ArraySize-1 downto 0 loop
      ReturnVal(((i+1)*NiFpgaMasterReadDataToMasterFlat_t'length)-1 downto
                i*NiFpgaMasterReadDataToMasterFlat_t'length) := arg(i);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceArrayToVector;


  ---------------------------------------------------------------------------------------

  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteRequestFromMasterArray_t)
    return std_logic_vector is

    variable TempArray : NiFpgaMasterWriteRequestFromMasterFlatArray_t(arg'range);

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterWriteRequestFromMasterFlat_t'length-1 downto 0);

  begin

    TempArray := FlattenMasterPortInterface(arg);
    ReturnVal := MasterPortInterfaceArrayToVector(TempArray);

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteRequestToMasterArray_t)
    return std_logic_vector
  is

    variable TempArray : NiFpgaMasterWriteRequestToMasterFlatArray_t(arg'range);

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterWriteRequestToMasterFlat_t'length-1 downto 0);

  begin

    TempArray := FlattenMasterPortInterface(arg);
    ReturnVal := MasterPortInterfaceArrayToVector(TempArray);

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteDataFromMasterArray_t)
    return std_logic_vector
  is

    variable TempArray : NiFpgaMasterWriteDataFromMasterFlatArray_t(arg'range);

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterWriteDataFromMasterFlat_t'length-1 downto 0);

  begin

    TempArray := FlattenMasterPortInterface(arg);
    ReturnVal := MasterPortInterfaceArrayToVector(TempArray);

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteDataToMasterArray_t)
    return std_logic_vector is

    variable TempArray : NiFpgaMasterWriteDataToMasterFlatArray_t(arg'range);

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterWriteDataToMasterFlat_t'length-1 downto 0);

  begin

    TempArray := FlattenMasterPortInterface(arg);
    ReturnVal := MasterPortInterfaceArrayToVector(TempArray);

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterWriteStatusToMasterArray_t)
    return std_logic_vector is

    variable TempArray : NiFpgaMasterWriteStatusToMasterFlatArray_t(arg'range);

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterWriteStatusToMasterFlat_t'length-1 downto 0);

  begin

    TempArray := FlattenMasterPortInterface(arg);
    ReturnVal := MasterPortInterfaceArrayToVector(TempArray);

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterReadRequestFromMasterArray_t)
    return std_logic_vector is

    variable TempArray : NiFpgaMasterReadRequestFromMasterFlatArray_t(arg'range);

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterReadRequestFromMasterFlat_t'length-1 downto 0);

  begin

    TempArray := FlattenMasterPortInterface(arg);
    ReturnVal := MasterPortInterfaceArrayToVector(TempArray);

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterReadRequestToMasterArray_t)
    return std_logic_vector
  is

    variable TempArray : NiFpgaMasterReadRequestToMasterFlatArray_t(arg'range);

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterReadRequestToMasterFlat_t'length-1 downto 0);

  begin

    TempArray := FlattenMasterPortInterface(arg);
    ReturnVal := MasterPortInterfaceArrayToVector(TempArray);

    return ReturnVal;

  end FlattenMasterPortInterface;


  function FlattenMasterPortInterface(arg : NiFpgaMasterReadDataToMasterArray_t)
    return std_logic_vector is

    variable TempArray : NiFpgaMasterReadDataToMasterFlatArray_t(arg'range);

    constant ArraySize : natural := arg'length;
    variable ReturnVal : std_logic_vector(
      ArraySize*NiFpgaMasterReadDataToMasterFlat_t'length-1 downto 0);

  begin

    TempArray := FlattenMasterPortInterface(arg);
    ReturnVal := MasterPortInterfaceArrayToVector(TempArray);

    return ReturnVal;

  end FlattenMasterPortInterface;

  ---------------------------------------------------------------------------------------
  -- Unflattening functions for Master Port Interface types.
  ---------------------------------------------------------------------------------------

  -- MasterPort Write unflatten functions
  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteRequestFromMasterFlat_t)
    return NiFpgaMasterWriteRequestFromMaster_t is

    variable ReturnVal : NiFpgaMasterWriteRequestFromMaster_t;
    variable index : natural := 0;

  begin

    ReturnVal.Request := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.Space := arg(index + ReturnVal.Space'length-1 downto index);
    index := index + ReturnVal.Space'length;
    ReturnVal.Address :=
      unsigned(arg(index + ReturnVal.Address'length-1 downto index));
    index := index + ReturnVal.Address'length;
    ReturnVal.Baggage := arg(index + ReturnVal.Baggage'length-1 downto index);
    index := index + ReturnVal.Baggage'length;
    ReturnVal.ByteSwap :=
      unsigned(arg(index + ReturnVal.ByteSwap'length-1 downto index));
    index := index + ReturnVal.ByteSwap'length;
    ReturnVal.ByteLane :=
      unsigned(arg(index + ReturnVal.ByteLane'length-1 downto index));
    index := index + ReturnVal.ByteLane'length;
    ReturnVal.ByteCount :=
      unsigned(arg(index + ReturnVal.ByteCount'length-1 downto index));

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteRequestToMasterFlat_t)
    return NiFpgaMasterWriteRequestToMaster_t is

    variable ReturnVal : NiFpgaMasterWriteRequestToMaster_t;
    variable index : natural := 0;

  begin

    ReturnVal.Acknowledge := to_Boolean(arg(index));

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteDataFromMasterFlat_t)
    return NiFpgaMasterWriteDataFromMaster_t is

    variable ReturnVal : NiFpgaMasterWriteDataFromMaster_t;
    variable index : natural := 0;

  begin

    ReturnVal.Data := arg(index + ReturnVal.Data'length-1 downto index);

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteDataToMasterFlat_t)
    return NiFpgaMasterWriteDataToMaster_t is

    variable ReturnVal : NiFpgaMasterWriteDataToMaster_t;
    variable index : natural := 0;

  begin

    ReturnVal.TransferStart := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.TransferEnd := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.Space := arg(index + ReturnVal.Space'length-1 downto index);
    index := index + ReturnVal.Space'length;
    ReturnVal.ByteLane :=
      unsigned(arg(index + ReturnVal.ByteLane'length-1 downto index));
    index := index + ReturnVal.ByteLane'length;
    ReturnVal.ByteCount :=
      unsigned(arg(index + ReturnVal.ByteCount'length-1 downto index));
    index := index + ReturnVal.ByteCount'length;
    ReturnVal.ByteEnable :=
      to_BooleanVector(arg(index + ReturnVal.ByteEnable'length-1 downto index));
    index := index + ReturnVal.ByteEnable'length;
    ReturnVal.Pop := to_Boolean(arg(index));

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteStatusToMasterFlat_t)
    return NiFpgaMasterWriteStatusToMaster_t is
    
    variable ReturnVal : NiFpgaMasterWriteStatusToMaster_t;
    variable index : natural := 0;

  begin

    ReturnVal.Ready := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.Space := arg(index + ReturnVal.Space'length-1 downto index);
    index := index + ReturnVal.Space'length;
    ReturnVal.ByteCount :=
      unsigned(arg(index + ReturnVal.ByteCount'length-1 downto index));
    index := index + ReturnVal.ByteCount'length;
    ReturnVal.ErrorStatus := to_Boolean(arg(index));

    return ReturnVal;

  end UnflattenMasterPortInterface;


  -- MasterPort Read unflatten functions
  function UnflattenMasterPortInterface(arg : NiFpgaMasterReadRequestFromMasterFlat_t)
    return NiFpgaMasterReadRequestFromMaster_t is

    variable ReturnVal : NiFpgaMasterReadRequestFromMaster_t;
    variable index : natural := 0;

  begin

    ReturnVal.Request := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.Space := arg(index + ReturnVal.Space'length-1 downto index);
    index := index + ReturnVal.Space'length;
    ReturnVal.Address :=
      unsigned(arg(index + ReturnVal.Address'length-1 downto index));
    index := index + ReturnVal.Address'length;
    ReturnVal.Baggage := arg(index + ReturnVal.Baggage'length-1 downto index);
    index := index + ReturnVal.Baggage'length;
    ReturnVal.ByteSwap :=
      unsigned(arg(index + ReturnVal.ByteSwap'length-1 downto index));
    index := index + ReturnVal.ByteSwap'length;
    ReturnVal.ByteLane :=
      unsigned(arg(index + ReturnVal.ByteLane'length-1 downto index));
    index := index + ReturnVal.ByteLane'length;
    ReturnVal.ByteCount :=
      unsigned(arg(index + ReturnVal.ByteCount'length-1 downto index));

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(arg : NiFpgaMasterReadRequestToMasterFlat_t)
    return NiFpgaMasterReadRequestToMaster_t is

    variable ReturnVal : NiFpgaMasterReadRequestToMaster_t;
    variable index : natural := 0;

  begin

    ReturnVal.Acknowledge := to_Boolean(arg(index));

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(arg : NiFpgaMasterReadDataToMasterFlat_t)
    return NiFpgaMasterReadDataToMaster_t is

    variable ReturnVal : NiFpgaMasterReadDataToMaster_t;
    variable index : natural := 0;

  begin

    ReturnVal.TransferStart := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.TransferEnd := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.Space := arg(index + ReturnVal.Space'length-1 downto index);
    index := index + ReturnVal.Space'length;
    ReturnVal.ByteLane :=
      unsigned(arg(index + ReturnVal.ByteLane'length-1 downto index));
    index := index + ReturnVal.ByteLane'length;
    ReturnVal.ByteCount :=
      unsigned(arg(index + ReturnVal.ByteCount'length-1 downto index));
    index := index + ReturnVal.ByteCount'length;
    ReturnVal.ErrorStatus := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.ByteEnable :=
      to_BooleanVector(arg(index + ReturnVal.ByteEnable'length-1 downto index));
    index := index + ReturnVal.ByteEnable'length;
    ReturnVal.Push := to_Boolean(arg(index));
    index := index + 1;
    ReturnVal.Data := arg(index + ReturnVal.Data'length-1 downto index);

    return ReturnVal;

  end UnflattenMasterPortInterface;


  -- Functions to convert the MasterPort interface array types from std logic vectors.
  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterWriteRequestFromMasterFlatArray_t is

    variable ReturnVal : NiFpgaMasterWriteRequestFromMasterFlatArray_t(ArraySize-1 downto 0);

  begin

    for i in ReturnVal'length-1 downto 0 loop
      ReturnVal(i) := Vector((i+1)*NiFpgaMasterWriteRequestFromMasterFlat_t'length-1
        downto i*NiFpgaMasterWriteRequestFromMasterFlat_t'length);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceVectorToArray;


  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterWriteRequestToMasterFlatArray_t
  is

    variable ReturnVal : NiFpgaMasterWriteRequestToMasterFlatArray_t(ArraySize-1 downto 0);

  begin

    for i in ReturnVal'length-1 downto 0 loop
      ReturnVal(i) := Vector((i+1)*NiFpgaMasterWriteRequestToMasterFlat_t'length-1
        downto i*NiFpgaMasterWriteRequestToMasterFlat_t'length);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceVectorToArray;


  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterWriteDataFromMasterFlatArray_t
  is

    variable ReturnVal : NiFpgaMasterWriteDataFromMasterFlatArray_t(ArraySize-1 downto 0);

  begin

    for i in ReturnVal'length-1 downto 0 loop
      ReturnVal(i) := Vector((i+1)*NiFpgaMasterWriteDataFromMasterFlat_t'length-1
        downto i*NiFpgaMasterWriteDataFromMasterFlat_t'length);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceVectorToArray;


  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterWriteDataToMasterFlatArray_t
  is

    variable ReturnVal : NiFpgaMasterWriteDataToMasterFlatArray_t(ArraySize-1 downto 0);

  begin

    for i in ReturnVal'length-1 downto 0 loop
      ReturnVal(i) := Vector((i+1)*NiFpgaMasterWriteDataToMasterFlat_t'length-1
        downto i*NiFpgaMasterWriteDataToMasterFlat_t'length);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceVectorToArray;


  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterWriteStatusToMasterFlatArray_t
  is

    variable ReturnVal : NiFpgaMasterWriteStatusToMasterFlatArray_t(ArraySize-1 downto 0);

  begin

    for i in ReturnVal'length-1 downto 0 loop
      ReturnVal(i) := Vector((i+1)*NiFpgaMasterWriteStatusToMasterFlat_t'length-1
        downto i*NiFpgaMasterWriteStatusToMasterFlat_t'length);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceVectorToArray;


  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterReadRequestFromMasterFlatArray_t
  is

    variable ReturnVal : NiFpgaMasterReadRequestFromMasterFlatArray_t(ArraySize-1 downto 0);

  begin

    for i in ReturnVal'length-1 downto 0 loop
      ReturnVal(i) := Vector((i+1)*NiFpgaMasterReadRequestFromMasterFlat_t'length-1
        downto i*NiFpgaMasterReadRequestFromMasterFlat_t'length);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceVectorToArray;


  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterReadRequestToMasterFlatArray_t
  is

    variable ReturnVal : NiFpgaMasterReadRequestToMasterFlatArray_t(ArraySize-1 downto 0);

  begin

    for i in ReturnVal'length-1 downto 0 loop
      ReturnVal(i) := Vector((i+1)*NiFpgaMasterReadRequestToMasterFlat_t'length-1
        downto i*NiFpgaMasterReadRequestToMasterFlat_t'length);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceVectorToArray;


  function MasterPortInterfaceVectorToArray(
    ArraySize : natural;
    Vector : std_logic_vector) return NiFpgaMasterReadDataToMasterFlatArray_t
  is

    variable ReturnVal : NiFpgaMasterReadDataToMasterFlatArray_t(ArraySize-1 downto 0);

  begin

    for i in ReturnVal'length-1 downto 0 loop
      ReturnVal(i) := Vector((i+1)*NiFpgaMasterReadDataToMasterFlat_t'length-1
        downto i*NiFpgaMasterReadDataToMasterFlat_t'length);
    end loop;

    return ReturnVal;

  end MasterPortInterfaceVectorToArray;


  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteRequestFromMasterFlatArray_t)
    return NiFpgaMasterWriteRequestFromMasterArray_t
  is

    variable ReturnVal : NiFpgaMasterWriteRequestFromMasterArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := UnflattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteRequestToMasterFlatArray_t)
    return NiFpgaMasterWriteRequestToMasterArray_t
  is

    variable ReturnVal : NiFpgaMasterWriteRequestToMasterArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := UnflattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteDataFromMasterFlatArray_t)
    return NiFpgaMasterWriteDataFromMasterArray_t
  is

    variable ReturnVal : NiFpgaMasterWriteDataFromMasterArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := UnflattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteDataToMasterFlatArray_t)
    return NiFpgaMasterWriteDataToMasterArray_t
  is

    variable ReturnVal : NiFpgaMasterWriteDataToMasterArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := UnflattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(arg : NiFpgaMasterWriteStatusToMasterFlatArray_t)
    return NiFpgaMasterWriteStatusToMasterArray_t
  is

    variable ReturnVal : NiFpgaMasterWriteStatusToMasterArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := UnflattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(arg : NiFpgaMasterReadRequestFromMasterFlatArray_t)
    return NiFpgaMasterReadRequestFromMasterArray_t
  is

    variable ReturnVal : NiFpgaMasterReadRequestFromMasterArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := UnflattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end UnflattenMasterPortInterface;




  function UnflattenMasterPortInterface(arg : NiFpgaMasterReadRequestToMasterFlatArray_t)
    return NiFpgaMasterReadRequestToMasterArray_t
  is

    variable ReturnVal : NiFpgaMasterReadRequestToMasterArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := UnflattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(arg : NiFpgaMasterReadDataToMasterFlatArray_t)
    return NiFpgaMasterReadDataToMasterArray_t
  is

    variable ReturnVal : NiFpgaMasterReadDataToMasterArray_t(arg'range);

  begin

    for i in 0 to arg'length-1 loop
      ReturnVal(i) := UnflattenMasterPortInterface(arg(i));
    end loop;

    return ReturnVal;

  end UnflattenMasterPortInterface;


  -- Functions to convert std logic vectors to MasterPort array types.
  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterWriteRequestFromMasterArray_t is

    constant ArraySize : natural := Vector'length /
      NiFpgaMasterWriteRequestFromMasterFlat_t'length;
    variable TempArray : NiFpgaMasterWriteRequestFromMasterFlatArray_t(ArraySize-1 downto 0);
    variable ReturnVal : NiFpgaMasterWriteRequestFromMasterArray_t(ArraySize-1 downto 0);

  begin

    TempArray := MasterPortInterfaceVectorToArray(ArraySize, Vector);
    ReturnVal := UnflattenMasterPortInterface(TempArray);

    return ReturnVal;

  end UnflattenMasterPortInterface;



  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterWriteRequestToMasterArray_t is

    constant ArraySize : natural := Vector'length /
      NiFpgaMasterWriteRequestToMasterFlat_t'length;
    variable TempArray : NiFpgaMasterWriteRequestToMasterFlatArray_t(ArraySize-1 downto 0);
    variable ReturnVal : NiFpgaMasterWriteRequestToMasterArray_t(ArraySize-1 downto 0);

  begin

    TempArray := MasterPortInterfaceVectorToArray(ArraySize, Vector);
    ReturnVal := UnflattenMasterPortInterface(TempArray);

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterWriteDataFromMasterArray_t is

    constant ArraySize : natural := Vector'length /
      NiFpgaMasterWriteDataFromMasterFlat_t'length;
    variable TempArray : NiFpgaMasterWriteDataFromMasterFlatArray_t(ArraySize-1 downto 0);
    variable ReturnVal : NiFpgaMasterWriteDataFromMasterArray_t(ArraySize-1 downto 0);

  begin

    TempArray := MasterPortInterfaceVectorToArray(ArraySize, Vector);
    ReturnVal := UnflattenMasterPortInterface(TempArray);

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterWriteDataToMasterArray_t is

    constant ArraySize : natural := Vector'length /
      NiFpgaMasterWriteDataToMasterFlat_t'length;
    variable TempArray : NiFpgaMasterWriteDataToMasterFlatArray_t(ArraySize-1 downto 0);
    variable ReturnVal : NiFpgaMasterWriteDataToMasterArray_t(ArraySize-1 downto 0);

  begin

    TempArray := MasterPortInterfaceVectorToArray(ArraySize, Vector);
    ReturnVal := UnflattenMasterPortInterface(TempArray);

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterWriteStatusToMasterArray_t is

    constant ArraySize : natural := Vector'length /
      NiFpgaMasterWriteStatusToMasterFlat_t'length;
    variable TempArray : NiFpgaMasterWriteStatusToMasterFlatArray_t(ArraySize-1 downto 0);
    variable ReturnVal : NiFpgaMasterWriteStatusToMasterArray_t(ArraySize-1 downto 0);

  begin

    TempArray := MasterPortInterfaceVectorToArray(ArraySize, Vector);
    ReturnVal := UnflattenMasterPortInterface(TempArray);

    return ReturnVal;

  end UnflattenMasterPortInterface;



  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterReadRequestFromMasterArray_t is

    constant ArraySize : natural := Vector'length /
      NiFpgaMasterReadRequestFromMasterFlat_t'length;
    variable TempArray : NiFpgaMasterReadRequestFromMasterFlatArray_t(ArraySize-1 downto 0);
    variable ReturnVal : NiFpgaMasterReadRequestFromMasterArray_t(ArraySize-1 downto 0);

  begin

    TempArray := MasterPortInterfaceVectorToArray(ArraySize, Vector);
    ReturnVal := UnflattenMasterPortInterface(TempArray);

    return ReturnVal;

  end UnflattenMasterPortInterface;



  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterReadRequestToMasterArray_t is

    constant ArraySize : natural := Vector'length /
      NiFpgaMasterReadRequestToMasterFlat_t'length;
    variable TempArray : NiFpgaMasterReadRequestToMasterFlatArray_t(ArraySize-1 downto 0);
    variable ReturnVal : NiFpgaMasterReadRequestToMasterArray_t(ArraySize-1 downto 0);

  begin

    TempArray := MasterPortInterfaceVectorToArray(ArraySize, Vector);
    ReturnVal := UnflattenMasterPortInterface(TempArray);

    return ReturnVal;

  end UnflattenMasterPortInterface;


  function UnflattenMasterPortInterface(Vector : std_logic_vector)
    return NiFpgaMasterReadDataToMasterArray_t is

    constant ArraySize : natural := Vector'length /
      NiFpgaMasterReadDataToMasterFlat_t'length;
    variable TempArray : NiFpgaMasterReadDataToMasterFlatArray_t(ArraySize-1 downto 0);
    variable ReturnVal : NiFpgaMasterReadDataToMasterArray_t(ArraySize-1 downto 0);

  begin

    TempArray := MasterPortInterfaceVectorToArray(ArraySize, Vector);
    ReturnVal := UnflattenMasterPortInterface(TempArray);

    return ReturnVal;

  end UnflattenMasterPortInterface;

end PkgDmaPortCommIfcMasterPortFlatTypes;