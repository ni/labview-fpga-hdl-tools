-------------------------------------------------------------------------------
--
-- File: PkgLinkStorageRam.vhd
-- Author: Rolando Ortega
-- Original Project: NI Cores NiDmaIp
-- Date: 10 May 2019
--
-------------------------------------------------------------------------------
-- (c) 2019 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
-- This package provides constants and functions that are shared between different
-- target-specific implementations of LinkStorageRam, to avoid double-sourcing them. As
-- such, the purpose statement for those modules is also single-sourced here.
--
-- Link-Chaning DMA is only required by some channels. When talking about a LVFPGA design,
-- for example, it's only required by Output DMA, Input DMA, and P2P Writers. Unused
-- channels, and those used as P2P readers, have no need to instantiate expensive memory
-- for Chunky Links that they'll never fetch nor use.
--
-- The LinkStorageRam module used to exist as part of NiDmaLinkProcessor. It's been moved
-- to its own module (actually, to a plurality of target-specific modules), which is
-- expected to be instantiated outside the Inchworm netlist, if there is one, based on the
-- following observations:
--
-- 1. It's inefficient to treat the Link Storage memory as _n_ individual memories, where
--    _n_ is the total number of channels supported by a given Inchworm instantiation.
--    This is because RAM primitives usually come in fixed sizes, and combining all the
--    memories together yields better resource utilization. We can combine all memories
--    together because there is only one NiDmaLinkProcessor, and it only requires one read
--    and one write port into the memory.
--
-- 2. There is no way for the synthesizer to automatically know at synthesis time whether
--    a given channel will require its allotment of Link Storage memory. From the
--    synthesizer's perspective, all channels could be requested to load up chunky links,
--    and all channels could very well use them.
--
-- 3. Because of (2), we need to tell the synthesizer which channels require instantiating
--    memory and which do not.
--
-- 4. Even if we do (3), the block containing the memory needs to live outside the
--    Inchworm Netlist, because knowledge of which channels require Link Storage is only
--    available when we synthesize the final application, not when we synthesize the
--    Inchworm Netlist.
--
-- 5. Because of (1), each channel's memory space is simply a subset of a bigger memory.
--    So even if we tell the synthesizer which channels require Link Storage and which do
--    not in satisfaction of (3), we risk arriving at a fragmented memory, which will take
--    up no fewer resources than the full memory.
--
-- 5. Because of (5), we need to "defragment" the memory. Namely, we need to create a
--    contiguous block of memory which contains only the memory for those channels which
--    require Link Storage.
--
-- 6. To achieve (6), we implement a simple address translation which will map the
--    addresses that are expected by the NiDmaLinkProcessor into addresses in our
--    reduced-size memory.
--
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgNiDma.all;
use work.PkgNiDmaConfig.all;
use work.PkgNiUtilities.all;
--synopsys translate_off
use work.PkgNiSim.all;
--synopsys translate_on
use work.PkgLinkStorageRamConfig.all;

package PkgLinkStorageRam is

  ------------------------------------------------------------------------------
  -- LinkStorageRam as seen by Inchworm
  ------------------------------------------------------------------------------
  -- Because the Inchworm doesn't know (at compile time) how many DMA channels will
  -- actually get used (and therefore need chunky links), we size the memory for the
  -- maximum number of allowed DMA Channels.

  -- # of channels * # of links per channel (2) * Max Link Size
  constant kLinkStorageSizeInBytes : natural := kNiDmaDmaChannels * 2 * kChunkyLinkSize;

  --The RAM needs to be written at kNiDmaDataWidth and read 8 bytes wide.  There is an assertion
  --preventing kNiDmaDataWidth less than 8 bytes wide, therefore the ram can always be
  --kNiDmaDataWidth wide.
  constant kLinkStorageRamDataWidth : natural := kNiDmaDataWidth;
  constant kLinkStorageRamAddrWidth : natural := Log2(kLinkStorageSizeInBytes*8/kLinkStorageRamDataWidth);

  --constants for the processing state machine which works on 8 byte words.  This constant
  --cannot be changed without significant modification to the ProcessSm
  constant kLinkOffsetByteCount : integer := 8;
  constant kLinkOffsetMaxValue  : integer := kChunkyLinkSize / kLinkOffsetByteCount;

  --sizes for the ProcessSm to access the LinkStorage
  constant kLinkStorageRamRdDataWidth : integer := kLinkOffsetByteCount*8;
  constant kLinkStorageRamRdAddrWidth : natural := Log2(kLinkStorageSizeInBytes/kLinkOffsetByteCount);

  constant kLinkStorageRamWidthRatio : natural := kLinkStorageRamDataWidth/kLinkStorageRamRdDataWidth;

  ------------------------------------------------------------------------------
  -- Memory Sizing
  ------------------------------------------------------------------------------
  -- The size of the actual RAM we implement will depend on how many channels are enabled,
  -- not what the max number of possible channels would be. We'll count the enabled ones
  -- here.
  function NumEnabledChannels (
      constant kEnabledChannels : NiDmaDmaChannelOneHot_t
    ) return natural;

  ------------------------------------------------------------------------------
  -- RAM Configuration
  ------------------------------------------------------------------------------
  -- The NiDmaLinkProcessor expects a read latency of 2.
  constant kLinkStorageRamReadLatency : natural := 2;

end package PkgLinkStorageRam;

package body PkgLinkStorageRam is

  function NumEnabledChannels (
      constant kEnabledChannels : NiDmaDmaChannelOneHot_t)
    return natural is
    variable ChannelCount : natural := 0;
  begin -- NumEnabledChannels

    -- Just go through the vector, and add one for every value that is true.
    for i in kEnabledChannels'range loop
      if kEnabledChannels(i) then
        ChannelCount := ChannelCount + 1;
      end if;
    end loop;

    return ChannelCount;

  end function NumEnabledChannels;

end package body PkgLinkStorageRam;
