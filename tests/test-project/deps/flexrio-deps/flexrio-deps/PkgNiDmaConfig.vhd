-------------------------------------------------------------------------------
--
-- File: PkgNiDmaConfig.vhd
-- Author: Glen Sescila
-- Original Project: NI DMA IP
-- Date: 27 May 2010
--
-------------------------------------------------------------------------------
-- (c) 2010 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
-- Configures the NI DMA IP.  Each design will modify this package based on the
-- bus technology and application requirements.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package PkgNiDmaConfig is

  -------------------------- Data Path Configuration --------------------------

  -- Width of the bus address.  Note that this can be configured based on the
  -- total address space that needs to be accessible, not necessarily the width
  -- of address that the bus protocol supports.  For example, an application
  -- might set this based on the amount of memory actually installed in the
  -- system.  Care should be taken to consider peer-to-peer use cases since
  -- that may require accessing address ranges at higher locations than the
  -- memory.
  constant kNiDmaAddressWidth : natural := 64;

  -- Width of the bus data.  This must be a power-of-two mutliple of 8.
  constant kNiDmaDataWidth : natural := 256;

  -- Baggage is used for any bus-specific purpose.  PCIe example uses would be
  -- Traffic Classes and TLP Steering Tags.  On AXI the Baggage could be used
  -- to select which master interface the transaction should route to (SAM or
  -- ACP for example).  Each DMA channel or Direct Master can provide a
  -- programmable Baggage value but to the NI DMA IP and application hardware
  -- it serves no purpose.  The design of bus-specific logic determines how the
  -- Baggage value should be used.
  constant kNiDmaBaggageWidth : natural := 6;

  -- The maximum transfer size in bytes for Input and Output transactions.
  -- These must each be a power-of-two multiple of (kNiDmaDataWidth / 8).  The
  -- multiple must be four or greater.
  constant kNiDmaInputMaxTransfer  : natural := 1024;
  constant kNiDmaOutputMaxTransfer : natural := 1024;

  -- The number of Input and Output transactions that can be pending at once in
  -- the NI DMA IP.  Multiple transactions must be issued simultaneously in
  -- order to overcome pipeline and processing delays and sustain high
  -- streaming throughput.  For Output the number of simultaneous transactions
  -- needs to be set high enough to overcome the entire system round-trip
  -- latency.  If system round-trip latency is 5 us, then the design needs to
  -- simultaneously issue at least the number of transactions required to
  -- transfer 5 us worth of data at the desired bandwidth.  For Input the
  -- number of transactions necessary depends on characteristics of the bus
  -- technology.  If the NI DMA IP must wait to receive a response from the
  -- final destination of write transactions then the situation is no different
  -- than Output.  In this case Input needs to be configured for the number of
  -- simultaneous transactions required for the entire system round-trip
  -- latency.  If the bus technology posts writes and has appropriate ordering
  -- guarantees then Input can be configured for fewer simultaneous
  -- transactions.  In this case you only need enough transactions to overcome
  -- the latency through the NI DMA IP itself because transfers will be
  -- considered complete as soon as they post to the bus-speciifc logic.
  constant kNiDmaInputMaxRequests : natural := 16;
  constant kNiDmaOutputMaxRequests : natural := 64;

  -- The number of max transfer data payloads that can be stored in the NI DMA
  -- IP Input data path at once.  The NI DMA IP has been designed to provide
  -- maximum bus streaming throughput even with very little data buffering in
  -- the NI DMA IP itself.  The key to this concept is that the NI DMA IP is in
  -- control over when data transfers from the application hardware so there is
  -- no need for deep buffering in the NI DMA IP.  The minimum allowed value
  -- for this field is 2 and it shouldn't be necessary to increase it.  This is
  -- just being made configurable in case testing determines that more data
  -- buffering is necessary.  No buffering is required in the Output data path
  -- since the NI DMA IP can transfer received data to application-specic logic
  -- at will.
  constant kNiDmaInputDataBuffer : natural := 2;

  -- The number of DMA channels implemented.
  constant kNiDmaDmaChannels : natural := 64;

  -- The number of Direct Masters that needs to be supported.
  -- Max 64 DMA Channels + 64 Master Ports (to be split between LabVIEW and Fixed Logic)
  constant kNiDmaDirectMasters : natural := 128;

  -- This constant specifies the latency between Pop and data on the Input Data
  -- Interface.  The minimum value is 1 which means data is valid the state
  -- after Pop.
  constant kNiDmaInputDataReadLatency : natural := 5;

  -------------------------- RegPort Configuration ----------------------------

  --These set the base address of the dma companion
  constant kNiDmaIpBaseAddress         : natural := 16#00#;
  constant kNiDmaIpCompanionWindowSize : natural := 16#4000#;
  --The entire range between kNiDmaIpBaseAddress and kNiDmaDmaRegBase will be decoded
  --by the companion, except for the config port and link interface bridge ranges.

  --   The two constants below specify the address range allocated for the DMA
  -- context memory on RegPort.  InChWORM will respond to this entire range on
  -- RegPort even if there is more address space than necessary for the number
  -- of DMA channels implemented.  The unused space will return 0s on reads.
  -- This allows a fixed address range to be mapped to InChWORM without concern
  -- that software accesses to unused space in the range will hang or timeout.
  --   kNiDmaDmaRegBase must be naturally aligned to a boundary of
  -- kNiDmaDmaRegSize.  The total space should be a power-of-two that is at
  -- least 256 bytes * (kNiDmaDmaChannels rounded up to the next power-of-two).
  -- For example, with 5 DMA channels the total address space needed by NI DMA
  -- IP is 256 * 8 = 2048 bytes even though the register set for 5 channels
  -- fits in 256 * 5 = 1280 bytes.
  constant kNiDmaDmaRegBase : natural := 16#4000#;
  constant kNiDmaDmaRegSize : positive := 16#4000#;  -- 16K supports up to 64 chans

  --These constants specify the address range allocated for HBBIM Registers. The
  -- NI DMA Companion will not respond to these addresses and the Host Bus BIM logic
  -- is expected to acknowledge any access in the specified window. These constants
  -- are only used internally to the InChWORM netlist so it is OK if the version of
  -- this package used at the TopLevel FPGA does not print these constants.
  constant kNiDmaHbBimRegBase : natural := 16#1000#;
  constant kNiDmaHbBimRegSize : natural := 16#200#;

  ---------------------- High Speed Sink Configuration ------------------------

  -- For LvFPGA the high speed sink address width should be the same as the
  -- RegPort address width + 1. This is a requirement from CHInCh 2. However,
  -- this requirement may change for a future interface ASIC/IP. In order
  -- for this package file to support other interfaces in the future, log2
  -- of the max address of Sink Stream's write window could be used to define
  -- this constant. Doing so will also maintain backwards compatibility with
  -- the requirement from CHInCh 2.
  -- For PCIe InChWORM, AddressWidth just needs to accommodate the largest address
  --  (i.e. Base + Size - 1).
  constant kNiDmaHighSpeedSinkAddressWidth : positive := 20;

  -- The two constants below define the address range allocated for writing
  -- HighSpeedSink FIFOs.  kNiDmaHighSpeedSinkSize needs to be a power-of-two
  -- and kNiDmaHighSpeedSinkBase needs to be naturally aligned to a boundary of
  -- kNiDmaHighSpeedSinkSize.
  constant kNiDmaHighSpeedSinkBase : natural := 16#80000#;
  constant kNiDmaHighSpeedSinkSize : positive := 16#40000#;  -- 256K = 4K * 64 chans

  -------------------------- Feature Configuration ----------------------------

  constant kNiDmaEnableInput : boolean := true;
  constant kNiDmaEnableOutput : boolean := true;

  constant kNiDmaEnableByteSwapper : boolean := false;

  constant kNiDmaTtcWidth : natural := 64;
  constant kNiDmaEnableLatchingTtc : boolean := true;

  constant kNiDmaEnableFullScatterGather : boolean := true;

  -- These constants are only used when kNiDmaEnableFullScatterGather = true.
  constant kNiDmaMaxChunkyLinkSize : natural := 2048;
  constant kNiDmaLinkFetchMaxRequests : natural := 1;

  constant kNiDmaEnableDmaInterrupts : boolean := true;
  constant kNiDmaEnableMessageAndStatusPusher : boolean := true;
  --This sets the DirectMaster number that is used for the status pusher
  --Need to use a DmaChannel ID for LabVIEW targets since that is the only way
  -- to make sure it won't collide with a LabVIEW application as of LabVIEW 2016
  --Target developer must always reserve this ID from LabVIEW but can use it in
  -- Fixed Logic for stream requests
  constant kNiDmaStatusPusherChannel : natural := kNiDmaDmaChannels - 1;

  -------------------------- Optimization Settings ----------------------------

  -- The NI DMA IP needs to do a lot of alignment work on its data paths.  The
  -- byte lanes on which the user wants data are unrelated to the byte lanes
  -- where the host bus needs the data.  So the NI DMA IP needs the capability
  -- to mux every byte lane from the user to every byte lane of the host bus.
  -- Without pipelining this mux would get slower the wider the bus gets.  The
  -- kNiDmaMaxMuxWidth constant specifies the maximum width allowed for a
  -- combinatorial mux in the NI DMA IP.  The design adds pipeline stages such
  -- that we never have muxes wider than kNiDmaMaxMuxWidth-to-1.  Of course,
  -- wider buses will have more states of latency.  But that is because there
  -- is more processing to do and we want the NI DMA IP to support high clock
  -- rates.
  --
  -- The value of this constant must be a power-of-two.  8-to-1 muxes seem to
  -- be a sweet spot between speed and area in today's FPGAs.  Any wider would
  -- significantly reduce speed because the mux would not fit within a single
  -- SLICE.  Muxes narrower than 8-to-1 would not take full advantage of the
  -- resources available in a SLICE.  For Xilinx families Spartan-6, Virtex-5,
  -- and later; an 8-to-1 mux can be implemented using two 6-input LUTs and an
  -- FMUX.  This is one level of LUTs plus the FMUX all within a SLICE.
  constant kNiDmaMaxMuxWidth : natural := 8;

  -- The two constants below control the selection between LutRAM and BlockRAM.
  -- These specify thresholds for LutRAM address and data width.  Any RAM
  -- instance in NiDmaIp will use LutRAM when the address and data width are
  -- less than or equal to the maximums specified below.  Otherwise the RAM
  -- instance will use BlockRAM.
  constant kNiDmaMaxLutRamAddressWidth : natural := 8;
  constant kNiDmaMaxLutRamDataWidth : natural := 512;

end PkgNiDmaConfig;

package body PkgNiDmaConfig is

end package body PkgNiDmaConfig;
