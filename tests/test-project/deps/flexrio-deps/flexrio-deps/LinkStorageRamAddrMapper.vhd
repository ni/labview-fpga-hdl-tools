-------------------------------------------------------------------------------
--
-- File: LinkStorageRamAddrMapper.vhd
-- Author: Rolando Ortega
-- Original Project: NI Cores NiDmaIp
-- Date: 19 Jun 2019
--
-------------------------------------------------------------------------------
-- (c) 2019 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
-- This module single-sources all the logic needed to properly map a Link Storage address
-- from the set of all the Dma Channels to the sub-set of the Dma Channels whose Link
-- Storage is actually implemented.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgNiUtilities.all;
use work.PkgNiDma.all;
use work.PkgLinkStorageRam.all;

entity LinkStorageRamAddrMapper is

  generic (
    kEnabledChannels   : NiDmaDmaChannelOneHot_t;
    kMemoryWtAddrWidth : natural;
    kMemoryRdAddrWidth : natural
  );

  port (
    -- Incoming addresses
    dLinkStorageRamWriteAddr : in unsigned(kLinkStorageRamAddrWidth-1 downto 0);
    dLinkStorageRamReadAddr  : in unsigned(kLinkStorageRamRdAddrWidth-1 downto 0);
    -- Mapped (outgoing) addresses
    dNewRamWtAddr : out unsigned(kMemoryWtAddrWidth-1 downto 0);
    dNewRamRdAddr : out unsigned(kMemoryRdAddrWidth-1 downto 0)
  );

end entity LinkStorageRamAddrMapper;

architecture rtl of LinkStorageRamAddrMapper is

  ------------------------------------------------------------------------------
  -- Address Mapping
  ------------------------------------------------------------------------------

  -- We will modify the incoming address vector to match the address space of our
  -- reduced-size BRAM. The top Log2(kNiDmaDmaChannels) bits of the address correspond to
  -- the "Fetch Channel", i.e. the DMA channel being used. But we only instantiate memory
  -- for the DMA channels that are actually enabled. So we'll make a mapping from "All the
  -- DMA channels" to "Enabled DMA Channels".
  subtype EnabledDmaChannel_t is
  unsigned (Log2(Larger(NumEnabledChannels(kEnabledChannels),1)) -1 downto 0);

  -- These signals carry the DmaChannel, which is part of the address. We will map an
  -- address from the set of all possible Dma Channels to the set of Dma channels that are
  -- enabled.
  signal dIncomingWtDmaChannel, dIncomingRdDmaChannel : NiDmaDmaChannel_t;
  signal dNewWtDmaChannel, dNewRdDmaChannel           : EnabledDmaChannel_t;

  function MapDmaChannel (
      constant Channel : in NiDmaDmaChannel_t)
    return EnabledDmaChannel_t is
    variable EnabledCount : natural;
  begin -- function MapDmaChannel

    EnabledCount := 0;

    if not kEnabledChannels(to_integer(Channel)) then
      -- If the channel isn't enabled, then we just return 0 as the address. This
      -- shouldn't happen, because we shouldn't be asked to request addresses for channels
      -- that don't have DMA. But the synthesizer doesn't know that, so we need to
      -- consider what happens for all the cases that the synthesizer thinks could occur,
      -- but can't.
      -- We originally planned to add a simulation for this case. It's just a warning,
      -- because it's perfectly possible (and valid) for the input to this function to
      -- ocasionally (like during reset) have a value that matches an unused address, as
      -- long as no writes or reads are executed. But this happens way too often in tests
      -- where Channel 0 is disabled. So we're disabling the warning.
      --synopsys translate_off
      --report "LinkStorageRam is addressing DmaChannel " & DecImage(Channel)
      --       & " which is not an enabled channel."
      --severity warning;
      --synopsys translate_on
      return (others => '0');

    end if;

    -- If the channel *is* enabled, then we want to map its address to a gap-less
    -- memory space. To do this, we count how many enabled channels there are _before_
    -- the one that we're interested in.
    for i in kEnabledChannels'range loop

      -- If we've reached our channel of interest, we can stop. Our gapless address is
      -- the number of enabled channels that came before this one.
      if i = Channel then
        return to_unsigned(EnabledCount, EnabledDmaChannel_t'length);
      end if;

      if kEnabledChannels(i) then
        EnabledCount := EnabledCount + 1;
      end if;

    end loop; -- i

    -- We should never land here. But HDLMake can't figure that out, so we'll add this
    -- return clause just to make it happy.
    return (others => '0');

  end function MapDmaChannel;

begin

  ------------------------------------------------------------------------------
  -- Address Re-location
  ------------------------------------------------------------------------------

  -- First we pull out the addressed DMA channel, which is at the top end of the DMA
  -- address, and separate it from the rest of the address.
  dIncomingWtDmaChannel <= dLinkStorageRamWriteAddr(dLinkStorageRamWriteAddr'high downto dLinkStorageRamWriteAddr'length - dIncomingWtDmaChannel'length);
  dIncomingRdDmaChannel <= dLinkStorageRamReadAddr(dLinkStorageRamReadAddr'high downto dLinkStorageRamReadAddr'length - dIncomingRdDmaChannel'length);

  -- Then we apply our mapping formula to come up with the equivalent DmaChannel in our
  -- enabled subset.
  dNewWtDmaChannel <= MapDmaChannel(dIncomingWtDmaChannel);
  dNewRdDmaChannel <= MapDmaChannel(dIncomingRdDmaChannel);

  -- Thus we create a new address that indexes into our new, likely smaller memory.
  dNewRamWtAddr <= dNewWtDmaChannel & dLinkStorageRamWriteAddr(dLinkStorageRamWriteAddr'high - dIncomingWtDmaChannel'length downto 0);
  dNewRamRdAddr <= dNewRdDmaChannel & dLinkStorageRamReadAddr(dLinkStorageRamReadAddr'high - dIncomingRdDmaChannel'length downto 0);

end architecture rtl;
