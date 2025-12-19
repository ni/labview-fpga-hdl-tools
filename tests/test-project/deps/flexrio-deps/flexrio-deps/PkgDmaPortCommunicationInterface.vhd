-------------------------------------------------------------------------------
--
-- File: PkgDmaPortCommunicationInterface.vhd
-- Author: Matthew Koenn
-- Original Project: LV FPGA Communication Interface
-- Date: 04 August 2008
--
-------------------------------------------------------------------------------
-- (c) 2008 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
-- This package provides type definitions and functions used by the components
-- of the LabVIEW FPGA Dma Port communication interface.  It defines types that
-- are needed by the communication interface but not defined in 
-- PkgCommunicationInterface.  Originally, the new signals for the Dma Port were
-- going to just be added to PkgCommunicationInterface, but it was decided
-- that a new package would be made so that PkgCommunicationInterface did not
-- have to be changed, potentially affecting Mite designs.
--
-------------------------------------------------------------------------------

library ieee, work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PkgNiUtilities.all;
use work.PkgCommIntConfiguration.all;
use work.PkgCommunicationInterface.all;
use work.PkgNiDma.all;
use work.PkgDmaPortCommIfcMasterPort.all;

package PkgDmaPortCommunicationInterface is

  --===========================================================================
  -- NiDmaIp Interface Array
  -----------------------------------------------------------------------------

  type NiDmaInputRequestToDmaArray_t is array (natural range <>)
    of NiDmaInputRequestToDma_t;

  type NiDmaInputDataFromDmaArray_t is array (natural range <>)
    of NiDmaInputDataFromDma_t;

  type NiDmaInputDataToDmaArray_t is array (natural range <>)
    of NiDmaInputDataToDma_t;

  type NiDmaOutputRequestToDmaArray_t is array (natural range <>)
    of NiDmaOutputRequestToDma_t;

  type NiDmaOutputDataFromDmaArray_t is array (natural range <>)
    of NiDmaOutputDataFromDma_t;

  type NiDmaGeneralChannelArray_t is array (natural range <>)
    of NiDmaGeneralChannel_t;
    
  type NiDmaDmaChannelArray_t is array (natural range <>)
    of NiDmaDmaChannel_t;

  type NiDmaHighSpeedSinkFromDmaArray_t is array (natural range <>)
    of NiDmaHighSpeedSinkFromDma_t;

  type NiDmaInputRequestFromDmaArray_t is array (natural range<>)
    of NiDmaInputRequestFromDma_t;

  type NiDmaOutputRequestFromDmaArray_t is array (natural range<>)
    of NiDmaOutputRequestFromDma_t;

  type NiDmaInputStatusFromDmaArray_t is array (natural range<>)
    of NiDmaInputStatusFromDma_t;
  -----------------------------------------------------------------------------

  -- The type of signal used to communicate from the Interface within rvi_foo
  -- to the top level communication interface.
  type IrqStatusToInterface_t is record
  
    -- NOTE: If you change the size of this record, you must also change the
    --       size of the signal requested from within the GetModInfo
    --       VI of the module generator.
  
    Status : std_logic;
    Clear  : std_logic;
    
  end record;
  
  -- Use this constant if the signal is not used.
  constant kIrqStatusToInterfaceZero : IrqStatusToInterface_t := (
    Status => '0',
    Clear  => '0'
  );
  
  constant kIrqStatusToInterfaceSize : natural := 2;
  
  
  -- This is the number of virtual IRQs that are exported to the top level for the
  -- communication interface.  This is currently hardcoded as the number of LV FPGA
  -- IRQs (32) plus one extra for the IP IRQ.
  
  -- NOTE: If you change the size of this record, you must also change the
  --       size of the signal requested from within the GetModInfo
  --       VI of the module generator.
  constant kIrqToInterfaceSize : natural := 33;
  
  -- These types are used to communicate the status of each virtual IRQ from the 
  -- interface in TheWindow to the top level communication interface.
  
  type IrqStatusArray_t is array (natural range<>) of IrqStatusToInterface_t;
  subtype IrqToInterface_t is IrqStatusArray_t(kIrqToInterfaceSize-1 downto 0);
    
  type IrqToInterfaceArray_t is array(natural range<>) of IrqToInterface_t;
    
  subtype AccDoneStrbArray_t is std_logic_vector;

  type StrmIndex_t is array (natural range <>) of natural;
  
  -- Functions to flatten/unflatten the IRQ signals to the top level so that they ports
  -- for these signals can be requested within the LV FPGA modules.
  function BuildIrqToInterface(arg : std_logic_vector) return IrqToInterface_t;
  function BuildIrqToInterfaceArray(arg : std_logic_vector) return IrqToInterfaceArray_t;
  function to_StdLogicVector(arg: IrqToInterface_t) return std_logic_vector;
  function to_StdLogicVector(arg: IrqToInterfaceArray_t) return std_logic_vector;
  
  function OrArray ( val : NiDmaInputDataToDmaArray_t ) return NiDmaInputDataToDma_t;
  function OrArray ( val : NiDmaInputRequestToDmaArray_t ) return NiDmaInputRequestToDma_t;
  function OrArray ( val : NiDmaOutputRequestToDmaArray_t ) return NiDmaOutputRequestToDma_t;

end PkgDmaPortCommunicationInterface;

package body PkgDmaPortCommunicationInterface is
  
  -- This function builds an IrqToInterface_t from its flattened std_logic_vector form.
  function BuildIrqToInterface(arg : std_logic_vector) return IrqToInterface_t is
    variable ReturnVal : IrqToInterface_t;
  begin
    
    for i in kIrqToInterfaceSize-1 downto 0 loop
      ReturnVal(i).Status := arg(i*kIrqStatusToInterfaceSize);
      ReturnVal(i).Clear := arg((i*kIrqStatusToInterfaceSize)+1);
    end loop;
    
    return ReturnVal;
    
  end BuildIrqToInterface;
  
  -- This function builds an IrqToInterfaceArray from its flattened std_logic_vector
  -- form.
  function BuildIrqToInterfaceArray(arg : std_logic_vector) return IrqToInterfaceArray_t
  is
    variable ReturnVal : IrqToInterfaceArray_t(kNumberOfIrqs-1 downto 0);
  begin
  
    for i in kNumberOfIrqs-1 downto 0 loop
      ReturnVal(i) := BuildIrqToInterface(arg((i+1)*kIrqToInterfaceSize*
        kIrqStatusToInterfaceSize-1 downto i*kIrqToInterfaceSize*
        kIrqStatusToInterfaceSize));
    end loop;
  
    return ReturnVal;
  
  end BuildIrqToInterfaceArray;
  
  -- This function takes an IrqToInterface and flattens it to a std_logic_vector.
  function to_StdLogicVector(arg: IrqToInterface_t) return std_logic_vector is
    variable ReturnVal : 
      std_logic_vector(kIrqToInterfaceSize*kIrqStatusToInterfaceSize-1 downto 0);
  begin
    
    for i in kIrqToInterfaceSize-1 downto 0 loop
      ReturnVal(i*kIrqStatusToInterfaceSize) := arg(i).Status;
      ReturnVal((i*kIrqStatusToInterfaceSize)+1) := arg(i).Clear;
    end loop;
    
    return ReturnVal;
    
  end to_StdLogicVector;
  
  -- This function takes an IrqToInterfaceArray and flattens it to a 
  -- std_logic_vector.
  function to_StdLogicVector(arg: IrqToInterfaceArray_t) return std_logic_vector is
    variable ReturnVal : std_logic_vector(kNumberOfIrqs*kIrqToInterfaceSize*
      kIrqStatusToInterfaceSize-1 downto 0);
  begin
    
    for i in kNumberOfIrqs-1 downto 0 loop
      ReturnVal((i+1)*kIrqToInterfaceSize*kIrqStatusToInterfaceSize-1 downto
        i*kIrqToInterfaceSize*kIrqStatusToInterfaceSize) := to_StdLogicVector(arg(i));
    end loop;
    
    return ReturnVal;
    
  end to_StdLogicVector;

  function "or" (l, r : NiDmaInputDataToDma_t) return NiDmaInputDataToDma_t is
  begin
    return 
      (
      Data => l.Data or r.Data
      );
  end function "or";

  function OrArray ( val : NiDmaInputDataToDmaArray_t ) return NiDmaInputDataToDma_t is
    variable rval : NiDmaInputDataToDma_t := kNiDmaInputDataToDmaZero;
  begin
    for i in val'range loop
      rval := rval or val(i);
    end loop;
    return rval;
  end function OrArray;

  function "or" (l, r : NiDmaInputRequestToDma_t) return NiDmaInputRequestToDma_t is
  begin
    return
      (Request     => l.Request     or r.Request,
       Space       => l.Space       or r.Space,
       Channel     => l.Channel     or r.Channel,
       Address     => l.Address     or r.Address,
       Baggage     => l.Baggage     or r.Baggage,
       ByteSwap    => l.ByteSwap    or r.ByteSwap,
       ByteLane    => l.ByteLane    or r.ByteLane,
       ByteCount   => l.ByteCount   or r.ByteCount,
       Done        => l.Done        or r.Done,
       EndOfRecord => l.EndOfRecord or r.EndOfRecord);
  end function "or";

  function OrArray ( val : NiDmaInputRequestToDmaArray_t ) return NiDmaInputRequestToDma_t is
    variable rval : NiDmaInputRequestToDma_t := kNiDmaInputRequestToDmaZero;
  begin
    for i in val'range loop
      rval := rval or val(i);
    end loop;
    return rval;
  end function OrArray;

  function "or" (l, r : NiDmaOutputRequestToDma_t) return NiDmaOutputRequestToDma_t is
  begin
    return
      (Request     => l.Request     or r.Request,
       Space       => l.Space       or r.Space,
       Channel     => l.Channel     or r.Channel,
       Address     => l.Address     or r.Address,
       Baggage     => l.Baggage     or r.Baggage,
       ByteSwap    => l.ByteSwap    or r.ByteSwap,
       ByteLane    => l.ByteLane    or r.ByteLane,
       ByteCount   => l.ByteCount   or r.ByteCount,
       Done        => l.Done        or r.Done,
       EndOfRecord => l.EndOfRecord or r.EndOfRecord);
  end function "or";

  function OrArray ( val : NiDmaOutputRequestToDmaArray_t ) return NiDmaOutputRequestToDma_t is
    variable rval : NiDmaOutputRequestToDma_t := kNiDmaOutputRequestToDmaZero;
  begin
    for i in val'range loop
      rval := rval or val(i);
    end loop;
    return rval;
  end function OrArray;

end PkgDmaPortCommunicationInterface;

