-------------------------------------------------------------------------------
--
-- File: PkgDmaPortCommIfcStreamStates.vhd
-- Author: Matthew Koenn
-- Original Project: CHInCh Interface
-- Date: 24 September 2008
--
-------------------------------------------------------------------------------
-- (c) 2008 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose: 
--
--   Holds utilities relating to stream state.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

Package PkgDmaPortCommIfcStreamStates is

  ---------------------------------------------------------------------------------------
  -- Stream States
  --
  -- Unlinked : A channel is in the unlinked state before the driver has linked it to a
  --            peer.
  --
  -- Stopped  : A channel is in the stopped state when it has been linked to a peer but
  --            the driver has not yet enabled the stream.
  --
  -- Started  : A channel is started once the driver has activated the stream.  Data will
  --            only be transmitted to or from this peer while it is in the started
  --            state.
  --
  -- Flushing : A source channel is in the flushing state when it has received a request
  --            to stop but is still transmitting data before it can actually stop.
  --
  ---------------------------------------------------------------------------------------
  
  
  -- The stream states need to be linked to specific values so that it matches the values
  -- expected by the driver.
  subtype StreamStateValue_t is std_logic_vector(1 downto 0);
  type StreamStateValueArray_t is array (natural range <>) of StreamStateValue_t;
  
  constant kStreamStateUnlinked  : StreamStateValue_t := "00";
  constant kStreamStateDisabled  : StreamStateValue_t := "01";
  constant kStreamStateEnabled   : StreamStateValue_t := "10";
  constant kStreamStateFlushing  : StreamStateValue_t := "11";

  type StreamState_t is (Unlinked, Disabled, Enabled, Flushing);
  
  -- Functions to convert between StreamState and StreamStateValue.
  function to_StreamState(arg : StreamStateValue_t) return StreamState_t;
  function to_StreamStateValue(arg : StreamState_t) return StreamStateValue_t;
  
end Package PkgDmaPortCommIfcStreamStates;

Package body PkgDmaPortCommIfcStreamStates is
  
  -- Convert a StreamStateValue type to a StreamState type.
  function to_StreamState(arg : StreamStateValue_t) return StreamState_t is
    variable ReturnVal : StreamState_t;
  begin
    
    if arg = kStreamStateUnlinked then
      ReturnVal := Unlinked;
    elsif arg = kStreamStateDisabled then
      ReturnVal := Disabled;
    elsif arg = kStreamStateEnabled then
      ReturnVal := Enabled;
    elsif arg = kStreamStateFlushing then
      ReturnVal := Flushing;
    else
      ReturnVal := Unlinked;
    end if;
    
    return ReturnVal;
    
  end to_StreamState;
  
  -- Convert a StreamState type to a StreamStateValue type.
  function to_StreamStateValue(arg : StreamState_t) return StreamStateValue_t is
    variable ReturnVal : StreamStateValue_t;
  begin
    
    if arg = Unlinked then
      ReturnVal := kStreamStateUnlinked;
    elsif arg = Disabled then
      ReturnVal := kStreamStateDisabled;
    elsif arg = Enabled then
      ReturnVal := kStreamStateEnabled;
    elsif arg = Flushing then
      ReturnVal := kStreamStateFlushing;
    else
      ReturnVal := kStreamStateUnlinked;
    end if;
    
    return ReturnVal;
    
  end to_StreamStateValue;
    
end Package body PkgDmaPortCommIfcStreamStates;

