-------------------------------------------------------------------------------
--
-- File: PkgDmaPortCommIfcInputDataControl.vhd
-- Author: Claudiu CHIRAP
-- Original Project: LV FPGA Chinch Interface
-- Date: 15 September 2011
--
-------------------------------------------------------------------------------
-- (c) 2011 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   This package file implements utilities used by the Dma Port interface 
-- data control components.
--
-------------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
 
library work;
  use work.PkgNiDmaConfig.all;
  use work.PkgCommIntConfiguration.all;

Package PkgDmaPortCommIfcInputDataControl is

  type NiDmaMuxCountArray_t is array (natural range <>) of natural;

  -- DmaPortCommIfcSinkDataControl uses an elaborate calculation to 
  -- determine the amount of pipelining required for the data 
  -- multiplexor. The number of channels passed to these functions must 
  -- be chosen so that the number of pipeline stages adds the amount of 
  -- delay expected by the DMA IP.
  function GetNumberOfMuxLevels(NumOfChannels : natural;
                                ExtraLastStage : boolean := false) return natural;
  function GetNumberOfMuxes(NumOfChannels : natural) return natural;
  function GetNumberOfMuxesForLevel(NumOfChannels : natural) return NiDmaMuxCountArray_t;
  function GetOffsetForLevel(NumOfChannels : natural) return NiDmaMuxCountArray_t;

  -- kInputDataDelay is the amount of delay to be added to the data path 
  -- in DmaPortCommIfcInputDataControl. The multiplexor in that 
  -- component can be pipelined to any extent that delays the data no 
  -- more than this amount, but the total delay on the data path in that 
  -- component must be exactly kInputDataDelay stages. The DMA IP (the 
  -- Chinch or Inchworm) must be configured to expect a corresponding 
  -- data delay.
  constant kInputDataDelay : natural := 1;

end Package PkgDmaPortCommIfcInputDataControl;

Package body PkgDmaPortCommIfcInputDataControl is

  -- The function computes the number of levels needed for multiplexing the
  -- NumOfChannels by using a tree of kNiDmaMaxMuxWidth:1 MUXs. Each level
  -- denotes a pipeline stage. In case the output of the last stage needs to 
  -- be registered ExtraLastStage must be asserted.
  function GetNumberOfMuxLevels (NumOfChannels : natural;
                                 ExtraLastStage : boolean := false) return natural is
  variable rval, remainder, quotient : natural;
  begin
    rval := 0;
    quotient := NumOfChannels;
    while quotient > kNiDmaMaxMuxWidth loop
      rval := rval + 1;
      remainder := quotient mod kNiDmaMaxMuxWidth;
      if remainder = 0 then
        quotient := quotient / kNiDmaMaxMuxWidth;
      else
        quotient := quotient / kNiDmaMaxMuxWidth + 1;
      end if;
    end loop;
    if ExtraLastStage then
      rval := rval + 1; --Extra Register after last MUX
    end if;
    return rval;
  end function GetNumberOfMuxLevels;
  
  -- The function computes the number of kNiDmaMaxMuxWidth:1 MUXs necessary 
  -- for building the larger component.
  function GetNumberOfMuxes (NumOfChannels : natural) return natural is
  variable rval, remainder, quotient : natural;
  begin
    rval := 0;
    quotient := NumOfChannels;
    while quotient > kNiDmaMaxMuxWidth loop
      remainder := quotient mod kNiDmaMaxMuxWidth;
      if remainder = 0 then
        quotient := quotient / kNiDmaMaxMuxWidth;
      else
        quotient := quotient / kNiDmaMaxMuxWidth + 1;
      end if;
      rval := rval + quotient;
    end loop;
    rval := rval + 1; --For the last MUX
    return rval;
  end function GetNumberOfMuxes;
  
  -- The function returns an array of natural numbers which represent the
  -- number of MUXs needed on each level. This will be used when constructing
  -- the data flow in InputDataControl.
  function GetNumberOfMuxesForLevel (NumOfChannels : natural) return NiDmaMuxCountArray_t is
  variable rval : NiDmaMuxCountArray_t(GetNumberOfMuxLevels(NumOfChannels) downto 0);
  variable remainder, quotient, pointer : natural;
  begin
    pointer := 0;
    quotient := NumOfChannels;
    while quotient > kNiDmaMaxMuxWidth loop
      remainder := quotient mod kNiDmaMaxMuxWidth;
      if remainder = 0 then
        quotient := quotient / kNiDmaMaxMuxWidth;
      else
        quotient := quotient / kNiDmaMaxMuxWidth + 1;
      end if;
      rval(pointer) := quotient;
      pointer := pointer + 1;
    end loop;
    rval(pointer) := 1;
    return rval;
  end function GetNumberOfMuxesForLevel;
  
  -- The value computes the offsets for iterating through the MUXs based on
  -- the number of MUXs previously used.
  function GetOffsetForLevel (NumOfChannels : natural) return NiDmaMuxCountArray_t is
  variable rval : NiDmaMuxCountArray_t(GetNumberOfMuxLevels(NumOfChannels) downto 0);
  variable remainder, quotient, pointer, acc : natural;
  begin
    pointer := 0;
    acc := 0;
    quotient := NumOfChannels;
    while quotient > kNiDmaMaxMuxWidth loop
      rval(pointer) := acc;
      remainder := quotient mod kNiDmaMaxMuxWidth;
      if remainder = 0 then
        quotient := quotient / kNiDmaMaxMuxWidth;
      else
        quotient := quotient / kNiDmaMaxMuxWidth + 1;
      end if;
      acc := acc + quotient;
      pointer := pointer + 1;
    end loop;
    rval(pointer) := acc;
    return rval;
  end function GetOffsetForLevel;

end Package body PkgDmaPortCommIfcInputDataControl;

