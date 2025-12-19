------------------------------------------------------------------------------------------
--
-- File: PkgInstructionFifoConfig.vhd
-- Author: Rolando Ortega
-- Original Project: The Macallan (Next FlexRIO)
-- Date: 16 September 2016
--
------------------------------------------------------------------------------------------
-- (c) 2016 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
------------------------------------------------------------------------------------------
--
-- Purpose: This package, in the same spirit as packages such as PkgNiDmaConfig, defines
-- some basic sizes and configurations for a given instantiation of the Instruction Fifo.
-- It's expected to be branched to your own target and modified as appropriate to match
-- your design.
--
-- Read carefully through all the options and make sure they've been configured correctly,
-- since you're in for many troubles otherwise.
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgNiUtilities.all;

package PkgInstructionFifoConfig is

  ---------------------------------------------------------------------------------------
  -- IFifo Window Sizes and Offsets
  ---------------------------------------------------------------------------------------
  -- This aligns with the bottom address for the High-Speed Sink. This is because
  -- High-Speed-Sink addresses are assigned "top-to-bottom", i.e. P2P channel 0 gets the
  -- last addresses of the HighSpeedSink Window. Since we're using the very last P2P
  -- channel, we sit at the bottom of the address space.
  constant kIFifoWindowGlobalOffset : natural :=16#80000#;

  -- This is the size, in bytes, of the write window assigned to each IFifo. It must
  -- always be a power of 2. All write windows are contiguous. Note that if there are `n`
  -- IFifos, then kIFifoHssWindowSize*n >= IFifoGlobalHssWindowSize, where
  -- IFifoGlobalHssWindowSize is the Window assigned to each HighSpeedSink (P2P channel),
  -- which is conventionally 4kB.
  --
  -- There's no good reason to change this value. It's currently sized so that the
  -- standard 4kB window will fit our maximum of 8 IFifos. There's no point in making it
  -- bigger.
  constant kIFifoWindowSize : natural := 16#200#;

  -- This is the offset for the IFifo Register Window, i.e. the offset at which the IFifo
  -- RegMap will be based (relative to BAR0) in this particular instantiation. This is
  -- expected to be modified for every target.
  constant kIFifoRegMapOffset : natural := 16#11000#;
  ---------------------------------------------------------------------------------------
  -- Number of Fifos and their Sizes
  ---------------------------------------------------------------------------------------
  -- Modifying this value involves a lot of work. This is the max amount of total IFifos
  -- (of all kinds combined) that are supported (not necessarily implemented, see below).
  constant kIFifoMaxNrFifos : positive := 8;

  -- Number of Instruction Fifos of each type to be instantiated.
  constant kNumAxiStreamFifos : natural := 2;
  constant kNumLvFpgaFifos    : natural := 1;

  -- This number you don't really need to calculate yourself.
  constant kIFifoNrFifos : positive range 1 to kIFifoMaxNrFifos :=
    kNumAxiStreamFifos + kNumLvFpgaFifos;

  -- Log2 of the number of elements in the FIFO. Default is 7, implying 128 Instructions
  -- inside the FIFO.
  constant kIFifoElementsLog2 : positive range 1 to 10 := 7;

  -- !NOT YET IMPLEMENTED! Number of "Mailboxes" (read destinations) that each Instruction
  -- Fifo's read path can have.
  --constant kIFifoNrMailboxes : positive range 1 to 4 := 1;

  -- Number of credits that will be requested by reading the RequestCredits register
  constant kIFifoCreditsToReq : positive range 1 to 2**kIFifoElementsLog2-1 := 127;

  -- Number of Mailboxes supported per IFifo. Note that, at this time, the only valid
  -- value is "1".
  constant kIFifoNrMailboxes : positive range 1 to 1 := 1;

  ---------------------------------------------------------------------------------------
  -- DMA Channel used
  ---------------------------------------------------------------------------------------
  -- We need to reserve Master Port IDs and DMA Channels to use with the IFifo. Reserved
  -- channels are taken from the "end" of the available range. That is, if there are 64
  -- DMA channels and we reserve 2, then we get #63 and #62. But in Inchworm-based
  -- designs, the last Master Port ID is used up by the Status Pushing functionality.
  -- Additionally, in designs that use the Link Interface Bridge for streaming, the
  -- second-to-last Master Port ID (and associated DMA Channel) is assigned to the LIB.
  -- Because Macallan doesn't use the Link Interface Bridge for streaming, we can use this
  -- second-to-last DmaChannel (#62) for the IFifo.
  constant kIFifoDmaChannel : natural := 62;

  ---------------------------------------------------------------------------------------
  -- Size of Instructions and Reads
  ---------------------------------------------------------------------------------------
  -- !WARNING! It's technically valid to change these sizes. But you probably don't want
  -- to, as bad things will probably happen.
  --
  -- Also, there's an !ASSUMPTION! built into how we size the LVFPGA FIFOs that underly
  -- the InstructionFifo, and it's in effect a requirement that kIFifoWriteDataWidth and
  -- kIFifoReadDataWidth must be a multiple of 8 bits. Therefore the sizes can only be
  -- modified in multiples of bytes.
  constant kIFifoWriteDataWidthBytes : positive := 8;
  constant kIFifoReadDataWidthBytes  : positive := 8;
  -- We optionally return a 1 byte "status" word alongside the ReadData and Sentinel. A
  -- value of 0 means there's no status word.
  constant kIFifoReadStatusWidthBytes : natural range 0 to 1 := 1;
  -- We will use a counter as a sentinel in the read path. It is also expected to be an
  -- integer number of bytes long.
  constant kIFifoSentinelWidthBytes  : positive := 1;

end package PkgInstructionFifoConfig;
