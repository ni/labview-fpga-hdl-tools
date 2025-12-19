-------------------------------------------------------------------------------
--
-- File: PkgDmaPortDataPackingFifo.vhd
-- Author: Haider Khan
-- Original Project: CHInCh Interface
-- Date: 11 January 2008
--
-------------------------------------------------------------------------------
-- (c) 2008 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose: Hold functions used by the data packing FIFOs.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;
  use work.PkgNiDmaConfig.all;
  use work.PkgNiDma.all;

Package PkgDmaPortDataPackingFifo is

  -- This function returns the actual sample size that should be used for the DMA FIFO
  -- based on the size in bits of one sample.
  function ActualSampleSize(
    SampleSizeInBits : natural;
    PeerToPeer       : boolean;
    FxpType          : boolean
  ) return natural;

  -- This function returns the FIFO port width based on the port data width
  -- on the VI side.
  function ActualFifoPortWidth(ViFifoPortWidth : natural) return natural;

  -- This function determines the number of bits that should be used to
  -- represent the number of samples that fit in the FIFO based on the sample size and
  -- the address width needed to reprezent the FIFO space in data bus words.  For example,
  -- if the sample size is 16 bits and the size of the FIFO in data bus words is 1K
  -- (10 address bits), then the actual number of bits used for the addressing
  -- the the FIFO in terms of samples is 12.
  function FifoCountWidth(
    SampleSize   : natural;
    AddressWidth : natural
  ) return natural;

  -- This function returns the byte enables used for controlling the byte-wide
  -- write enable to the FIFO. This function will be only used for Input Streams because
  -- the Output Streams receive the write enables together with the data comming on the
  -- data bus.
  function GetWriteEnables(
    WriteSampleAddress : unsigned;
    WrPortWidth        : natural
  ) return BooleanVector;


end Package PkgDmaPortDataPackingFifo;

Package body PkgDmaPortDataPackingFifo is

  --Round up the sample size in bits to either 8, 16, 32, or 64-bits. These
  --are the only configurations for the FIFO that are supported and all data
  --coming in needs to fit in one of these data in port widths.
  function ActualSampleSize (SampleSizeInBits : natural;
                             PeerToPeer       : boolean;
                             FxpType          : boolean)
  return natural is

    variable rval : natural;
    variable AllowedWordSize : natural;

  begin

    -- Always use 64 bits for a FXP type, unless it's a P2P stream.
    if FxpType and not PeerToPeer then
      return 64;

    -- Otherwise, round up to the nearest 8, 16, 32, or 64 bits.
    else

      -- This loop iterates through the smallest 9 bus sizes from 
      -- largest to smallest. An allowed bus size must be a power of 2 
      -- number of bytes, which means 8, 16, 32, etc. up to 1024 bits. 
      -- As of now, it's not clear what the largest allowed word size 
      -- should be. For now I've chosen 1024 arbitrarily.
      -- It is important to start with the largest bus size and work 
      -- down so that the returned value is the smallest bus size that 
      -- can contain the required number of bits in SampleSizeInBits.
      BusSizeLoop:
      for i in 8 downto 0 loop
        AllowedWordSize := 8 * (2**i);
        if SampleSizeInBits <= AllowedWordSize then
          rval := AllowedWordSize;
        end if;
      end loop BusSizeLoop;
      
      return rval;

    end if;
  end function;

  -- The function computes the FIFO's data port width. When the data bus is wider
  -- than the data width on the VI side the FIFO port width will be given by the data
  -- bus width. When the data bus is narrower than the data width on the VI side
  -- the FIFO port width will be given by the width of the data on the VI side.
  function ActualFifoPortWidth(ViFifoPortWidth : natural) return natural is

  begin

    if kNiDmaDataWidth >= ViFifoPortWidth then
      -- Wider bus case
      return kNiDmaDataWidth;
    else
      -- Narrower bus case
      return ViFifoPortWidth;
    end if;

  end function;

  -- Return the width required for counting the number of samples in the FIFO.
  function FifoCountWidth(SampleSize : natural;
                          AddressWidth : natural
  ) return natural is

  begin

    if kNiDmaDataWidth >= SampleSize then
      return AddressWidth + Log2(kNiDmaDataWidth/SampleSize);
    else
      return AddressWidth - Log2(SampleSize/kNiDmaDataWidth);
    end if;

  end function;

  -- This function computes which bytes need to be written to the FIFO based on the
  -- sample addresss and the width of the write port width.
  -- The WriteSampleAddress represents the sample address within a write port word.
  -- The WrPortWidth represents the data port width in bits.
  -- For the case when the data bus is wider than the data width on the VI side
  -- the FIFO's data width match the data bus width and the number of byte enables
  -- is the number of bytes that fits in one data bus word. The bytes corresponding
  -- to the sample that match the location of the sample address are enabled
  -- to be written to the FIFO.
  function GetWriteEnables(
    WriteSampleAddress : unsigned;
    WrPortWidth        : natural
  ) return BooleanVector is

    variable WriteEnables : BooleanVector(kNiDmaDataWidthInBytes-1 downto 0);

  begin

    if WrPortWidth < kNiDmaDataWidth then
    -- Handles the case when the data bus is wider than the data width on the VI side
    -- case when the FIFO's data width match the bus data width. The data written
    -- to the FIFO is smaller than the FIFO's data width.

      for i in kNiDmaDataWidthInBytes-1 downto 0 loop
        WriteEnables(i) := i/(WrPortWidth/8) = WriteSampleAddress;
      end loop;

    else --WrPortWidth >= kNiDmaDataWidth
    -- When the data written to the FIFO is as wide as the FIFO's data width matching the
    -- data bus width, all lanes are enabled.
      WriteEnables := (others => true);

    end if;

    return WriteEnables;

  end function;


end Package body PkgDmaPortDataPackingFifo;

