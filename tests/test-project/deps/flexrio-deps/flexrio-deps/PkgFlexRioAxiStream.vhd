-------------------------------------------------------------------------------
--
-- File: PkgFlexRioAxiStream.vhd
-- Author: Daniel Hearn
-- Original Project: Macallan
-- Date: 26 July 2016
--
-------------------------------------------------------------------------------
-- (c) 2016 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--  Define constants and types to be use for the Axi Stream
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgNiUtilities.all;

package PkgFlexRioAxiStream is

  ---------------------------------------------------------------------------------------
  -- Master to Slave
  ---------------------------------------------------------------------------------------
  --We are going to keep data width at 32 since we will use stream mainly for microblaze
  --interfaces, but if you weren't you could branch a copy of this and set it to a
  --different value.
  constant kAxiStreamTDataWidth : positive := 32;
  subtype AxiStreamTData_t is std_logic_vector(kAxiStreamTDataWidth - 1 downto 0);

  -- This type defines the Master To Slave (M2S) data interface.
  type AxiStreamData_t is record
    TData  : AxiStreamTData_t;
    TLast  : boolean;
    TValid : boolean;
  end record;

  -- Default reset/disabled value
  constant kAxiStreamDataZero : AxiStreamData_t := (
    TData  => (others => '0'),
    TLast  => false,
    TValid => false
    );

  -- Array
  type AxiStreamDataAry_t is array (natural range <>) of AxiStreamData_t;

  -- "Flattened" Version
  constant kFlatAxiStreamDataWidth : positive := kAxiStreamTDataWidth + 2;
  subtype FlatAxiStreamData_t is std_logic_vector(kFlatAxiStreamDataWidth - 1 downto 0);

  -- Flatten/Unflatten
  function Flatten(
    Channel : AxiStreamData_t)
    return FlatAxiStreamData_t;

  function UnFlatten(
    FlatChannel : FlatAxiStreamData_t)
    return AxiStreamData_t;

  ---------------------------------------------------------------------------------------
  -- Slave To Master
  ---------------------------------------------------------------------------------------
  -- The Slave To Master (S2M) return for a channel is just a single signal (Ready), so we
  -- use a single boolean for it. But we will define a "zero value" for it:
  constant kAxiStreamReadyZero : boolean := false;

end PkgFlexRioAxiStream;


package body PkgFlexRioAxiStream is

  ---------------------------------------------------------------------------------------
  -- Master to Slave
  ---------------------------------------------------------------------------------------
  -- Private constants
  constant kTDataIndex  : natural := 0;
  constant kTLastIndex  : natural := kTDataIndex + kAxiStreamTDataWidth;
  constant kTValidIndex : natural := kTLastIndex + 1;

  function Flatten (
    Channel : AxiStreamData_t)
    return FlatAxiStreamData_t is
    variable retVal : FlatAxiStreamData_t;
  begin  -- function Flatten

    retVal := SetField(kTDataIndex, Channel.TData, kFlatAxiStreamDataWidth) or
              SetBit(kTLastIndex, Channel.TLast, kFlatAxiStreamDataWidth) or
              SetBit(kTValidIndex, Channel.TValid, kFlatAxiStreamDataWidth);
    return retVal;

  end function Flatten;

  function UnFlatten (
    FlatChannel : FlatAxiStreamData_t)
    return AxiStreamData_t is
    variable retVal : AxiStreamData_t;
  begin  -- function UnFlatten

    retVal.TValid := to_Boolean(FlatChannel(kTValidIndex));
    retVal.TLast  := to_Boolean(FlatChannel(kTLastIndex));
    retVal.TData  := FlatChannel(kTDataIndex + kAxiStreamTDataWidth-1 downto kTDataIndex);

    return retVal;

  end function UnFlatten;

  ---------------------------------------------------------------------------------------
  -- Xilinx Conversion
  ---------------------------------------------------------------------------------------



end PkgFlexRioAxiStream;
