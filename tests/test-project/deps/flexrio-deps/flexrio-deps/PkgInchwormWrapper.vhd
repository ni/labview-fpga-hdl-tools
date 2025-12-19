-------------------------------------------------------------------------------
--
-- File: PkgInchwormWrapper.vhd
-- Author: Rolando Ortega
-- Original Project: NI Cores NiDmaIp
-- Date: 18 Jun 2019
--
-------------------------------------------------------------------------------
-- (c) 2019 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
-- This tiny package holds a single function that is intended to determine which channels
-- require Link Storage memory. If any Inchworm target has a need for this function to be
-- defined in any other way than how it is below, the package should be branched and the
-- function redefined.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgNiUtilities.all;
use work.PkgCommIntConfiguration.all;
use work.PkgNiDma.all;

package PkgInchwormWrapper is

  -- This function gives us the channels that are enabled in the Chunky Link Storage RAM.
  -- Channels that are totally disabled (unused) by the client application, as well as
  -- channels that are P2P readers, don't need Chunky Links. A client application can
  -- force a given channel to have Chunky Link storage by setting the corresponding
  -- channel to true in the kForceChannelEnable generic.
  function kGetEnabledChannels (
      constant kForceChannelEnable : NiDmaDmaChannelOneHot_t := (others => false)
    ) return NiDmaDmaChannelOneHot_t;

end package PkgInchwormWrapper;

package body PkgInchwormWrapper is

  function kGetEnabledChannels (
    constant kForceChannelEnable : NiDmaDmaChannelOneHot_t := (others => false)
  ) return NiDmaDmaChannelOneHot_t is
    variable retval : NiDmaDmaChannelOneHot_t := (others => false);
  begin
    for i in NiDmaDmaChannelOneHot_t'range loop
      -- The only channels that don't need link storage are channels that are not used at
      -- all (Disabled) or P2P readers. Technically, P2P Writers shouldn't need link
      -- storage either, but they're implemented in such a way that does use that storage.
      -- Any channel that is marked as true in kForceChannelEnable will be enabled
      -- regardless its configuration.
      retval(i) := (kDmaFifoConfArray(i).Mode /= NiFpgaPeerToPeerReader
                   and kDmaFifoConfArray(i).Mode /= Disabled)
                   or kForceChannelEnable(i);

    end loop;

    return retval;
  end function kGetEnabledChannels;

end package body PkgInchwormWrapper;
