-------------------------------------------------------------------------------
--
-- File: PkgDmaPortDmaFifos.vhd
-- Author: Matthew Koenn
-- Original Project: LabVIEW Fpga Communication Interface
-- Date: 11 June 2008
--
-------------------------------------------------------------------------------
-- (c) 2008 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
-- This package contains record definitions for the signals used to carry the
-- DMA FIFO information between the FIFOs and the communication interface.
--

-- Harmish - 08/04/2014 - Added support for the Flush method.
-- + New element "FlushReq" is added to the record InputStreamInterfaceFromFifo_t.
-- + Flatten and UnFlatten functions for the record are updated accordingly in PkgDmaPortDmaFifosFlatTypes.vhd
-------------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;
  use work.PkgCommIntConfiguration.all;
  use work.PkgDmaPortCommIfcStreamStates.all;
  use work.PkgDmaPortDataPackingFifo.all;
  use work.PkgNiDma.all;
  use work.PkgNiDmaConfig.all;

Package PkgDmaPortDmaFifos is

  function FifoDepthInDataBusWidthWords(FifoDepthInSamples : integer;
                                        SampleSizeInBits : integer)
    return natural;

  function GetFifoDepths(ChannelConfig: DmaChannelConfArray_t)
    return DmaChannelConfArray_t;

  type FifoDataWidthArray_t is array (natural range <>) of integer;

  function GetFifoDataWidth(FifoConfig: DmaChannelConfArray_t)
    return FifoDataWidthArray_t;

  -- These are the interface signals going from the communication interface to the FIFO
  -- for an input stream.
  type InputStreamInterfaceToFifo_t is record

    -- NOTE: If you change this record, the functions used to flatten/unflatten this
    --       record must be modified accordingly.  Also, the VI
    --       nirviGetTopLevelPort_chinchDma.vi must also change such that it reflects the
    --       correct size of the record.

    -- DmaReset : This signal is used to reset the DMA channel.  It must be held until
    --            the ResetDone signal is asserted.
    DmaReset : boolean;

    -- Pop : This is strobed for one clock cycle to perform a pop from the FIFO.
    Pop : boolean;

    -- TransferEnd : Asserted by the NI DMA IP to signal the last data phase of the
    --               transfer.
    TransferEnd : boolean;

    --ByteCount : The number of bytes to be transferred.
    ByteCount : NiDmaBusByteCount_t;

    -- ByteEnable : Indicates the valid bytes on the data bus that will transfer during
    --              each data phase;
    ByteEnable : NiDmaByteEnable_t;

    -- NumReadSamples : This signal represents the number of bytes for which
    --                  a data request was sent;
    NumReadSamples : NiDmaInputByteCount_t;

    -- RsrvReadSpaces : This signal is true for one clock cycle to update the
    --                  FIFO's FifoFullCount. The amount to update the FifoFullCount
    --                  is specified in bNumReadSamples.
    RsrvReadSpaces : boolean;

    -- StreamState : The current value of the stream state.
    StreamState : StreamStateValue_t;
    
    -- ByteLane : The value sent by the InChWORM on which the data should be returned
    ByteLane : NiDmaByteLane_t;

  end record;

  constant kInputStreamInterfaceToFifoZero : InputStreamInterfaceToFifo_t :=
   (DmaReset => false,
    Pop => false,
    TransferEnd => false,
    ByteCount => (others=>'0'),
    ByteEnable => (others=>false),
    NumReadSamples => (others=>'0'),
    RsrvReadSpaces => false,
    StreamState => kStreamStateUnlinked,
    ByteLane => (others => '0'));

  function SizeOf(Var : InputStreamInterfaceToFifo_t) return integer;


  -- These are the interface signals going from the FIFO to the communication interface
  -- for an input stream.
  type InputStreamInterfaceFromFifo_t is record

    -- NOTE: If you change this record, the functions used to flatten/unflatten this
    --       record must be modified accordingly.  Also, the VI
    --       nirviGetTopLevelPort_chinchDma.vi must also change such that it reflects the
    --       correct size of the record.

    -- ResetDone : This is the acknowledgement that the FIFO has reset.  This should
    --             be checked while asserting DmaReset.
    ResetDone : boolean;

    -- FifoDataOut : This is the data from the FIFO.
    FifoDataOut : NiDmaData_t;

    -- FifoFullCount : The FIFO full count in units of samples.  This is sized to 32 bits
    --                 to accomodate any size FIFO but can be resized to the minimum
    --                 length required to represent the actual FIFO size.
    FifoFullCount : unsigned(31 downto 0);

    -- FifoOverflow : This bit strobes for one clock cycle when a FIFO overflow occurs.
    FifoOverflow : boolean;

    -- ByteLanePtr : This is the starting byte lane of the next data word.
    ByteLanePtr : NiDmaByteLane_t;

    -- StartStreamRequest : This bit strobes for one clock cycle whenever there is a
    --                       request from the diagram to start the DMA channel.
    StartStreamRequest : boolean;

    -- StopStreamRequest : This bit strobes for one clock cycle whenever there is a
    --                      request from the diagram to stop the DMA channel.
    StopStreamRequest : boolean;

    -- StopStreamWithFlushRequest : This bit strobes for one clock cycle whenever
    --                               there is a request from the diagram to stop
    --                               the DMA channel with a flush.
    StopStreamWithFlushRequest : boolean;

    -- WritesDisabled : This status bit indicates when writes from the VI diagram
    --                  are disabled.  This is used when flushing to know that
    --                  there is no more data that has been pushed in the FIFO but
    --                  has not yet crossed the clock domain.  When WritesDisabled is
    --                  true, the FIFO count can no longer change as the result of
    --                  a write.
    
    FlushRequest : boolean;
    
    WritesDisabled : boolean;

    -- WriteDetected : Indicates whenever a write to fifo happens.
    WriteDetected : boolean;

    -- StateInDefaultClkDomain : This is the value of the state as seen by the
    --                           default clock domain.
    StateInDefaultClkDomain : StreamStateValue_t;

  end record;

  constant kInputStreamInterfaceFromFifoZero : InputStreamInterfaceFromFifo_t :=
   (ResetDone => false,
    FifoDataOut => (others=>'0'),
    FifoFullCount => (others=>'0'),
    FifoOverflow => false,
    ByteLanePtr => (others=>'0'),
    StartStreamRequest => false,
    StopStreamRequest => false,
    StopStreamWithFlushRequest => false,
    FlushRequest => false,
    WritesDisabled => true,
    WriteDetected => false,
    StateInDefaultClkDomain => to_StreamStateValue(Unlinked));

  function SizeOf(Var : InputStreamInterfaceFromFifo_t) return integer;

  -- These are the interface signals going from the communication interface to the FIFO
  -- for an output stream.
  type OutputStreamInterfaceToFifo_t is record

    -- NOTE: If you change this record, the functions used to flatten/unflatten this
    --       record must be modified accordingly.  Also, the VI
    --       nirviGetTopLevelPort_chinchDma.vi must also change such that it reflects the
    --       correct size of the record.

    -- DmaReset : This signal is used to reset the DMA channel.  It must be held until
    --            the ResetDone signal is asserted.
    DmaReset : boolean;

    -- FifoWrite : This is strobed for one clock cycle to perform a write to the DMA
    --             FIFO.
    FifoWrite : boolean;

    -- WriteLengthInBytes : The number of bytes that are written in the current FIFO
    --                      write.  This is only used when FifoWrite is true.
    WriteLengthInBytes : NiDmaBusByteCount_t;

    -- FifoData : The data that is written to the FIFO when FifoWrite is strobed.
    FifoData : NiDmaData_t;

    -- ByteEnable : Indicates the valid bytes on the data bus that will transfer during
    --              each data phase;
    ByteEnable : NiDmaByteEnable_t;

    -- RsrvWriteSpaces : This strobe is used to reserve sample spaces in the FIFO.
    RsrvWriteSpaces : boolean;

    -- NumWriteSpaces : This is the number of sample spaces that are reserved when
    --                  RsrvWriteSpaces is strobed.
    NumWriteSpaces : unsigned(31 downto 0);

    -- StreamState : The current value of the stream state.
    StreamState : StreamStateValue_t;

    -- ReportDisabledToDiagram : This signal indicates that the diagram clock domain
    --                           should latch the disabled state while the actual
    --                           state remains enabled.
    ReportDisabledToDiagram : boolean;

  end record;

  constant kOutputStreamInterfaceToFifoZero : OutputStreamInterfaceToFifo_t :=
   (DmaReset => false,
    FifoWrite => false,
    WriteLengthInBytes => (others=>'0'),
    FifoData => (others=>'0'),
    ByteEnable => (others=> false),
    RsrvWriteSpaces => false,
    NumWriteSpaces => (others=>'0'),
    StreamState => to_StreamStateValue(Unlinked),
    ReportDisabledToDiagram => false);

  function SizeOf(Var : OutputStreamInterfaceToFifo_t) return integer;


  -- These are the interface signals going from the FIFO to the communication interface
  -- for an output stream.
  type OutputStreamInterfaceFromFifo_t is record

    -- NOTE: If you change this record, the functions used to flatten/unflatten this
    --       record must be modified accordingly.  Also, the VI
    --       nirviGetTopLevelPort_chinchDma.vi must also change such that it reflects the
    --       correct size of the record.

    -- ResetDone : This is the acknowledgement that the FIFO has reset.  This should
    --             be checked while asserting DmaReset.
    ResetDone : boolean;

    -- EmptyCount : The number of empty sample spaces in the FIFO.  This is a length
    --              of 32 to accomodate any FIFO size, but this can be resized such
    --              that it only represents the number of spaces available in the FIFO.
    EmptyCount : unsigned(31 downto 0);

    -- RsrvdSpacesFilled : This signal is true when all reserved spaces in the FIFO have
    --                     been filled.  This should be used to determine when it is safe
    --                     to reset the FIFO.  For an output stream, the FIFO should not
    --                     be reset while there are spaces waiting to fill.
    RsrvdSpacesFilled : boolean;

    -- FifoUnderflow : This bit strobes for one clock cycle when a FIFO underflow occurs.
    FifoUnderflow : boolean;

    -- StartStreamRequest : This bit strobes for one clock cycle whenever there is a
    --                       request from the diagram to start the DMA channel.
    StartStreamRequest : boolean;

    -- StopStreamRequest : This bit strobes for one clock cycle whenever there is a
    --                     request from the diagram to stop the DMA channel.
    StopStreamRequest : boolean;

    -- HostReadableFullCount : This is the full count as readable by the host.  The
    --                         normal empty count is unsuitable to be read because
    --                         it does not take into account the pop buffer on the
    --                         output of the FIFO.
    HostReadableFullCount : unsigned(31 downto 0);

    -- StateInDefaultClkDomain : This is the value of the state as seen by the
    --                           default clock domain.
    StateInDefaultClkDomain : StreamStateValue_t;

  end record;


  constant kOutputStreamInterfaceFromFifoZero : OutputStreamInterfaceFromFifo_t :=
   (ResetDone => false,
    EmptyCount => (others=>'0'),
    RsrvdSpacesFilled => false,
    FifoUnderflow => false,
    StartStreamRequest => false,
    StopStreamRequest => false,
    HostReadableFullCount => (others=>'0'),
    StateInDefaultClkDomain => to_StreamStateValue(Unlinked));

  function SizeOf(Var : OutputStreamInterfaceFromFifo_t) return integer;


  -- Arrays of stream interface records
  type InputStreamInterfaceFromFifoArray_t is array (natural range <>) of
    InputStreamInterfaceFromFifo_t;
  type InputStreamInterfaceToFifoArray_t is array (natural range <>) of
    InputStreamInterfaceToFifo_t;
  type OutputStreamInterfaceFromFifoArray_t is array (natural range <>) of
    OutputStreamInterfaceFromFifo_t;
  type OutputStreamInterfaceToFifoArray_t is array (natural range <>) of
    OutputStreamInterfaceToFifo_t;

end PkgDmaPortDmaFifos;


package body PkgDmaPortDmaFifos is

  -- Find the actual FIFO depth in Data Bus width words from the FIFO depth in samples
  -- and the sample size.  The actual FIFO is asymmetric having the data width
  -- configurable in words that are multiple of 8 starting from 32 bit on the bus side
  -- and a possibly smaller port on the VI side.  The FIFO depth passed in should be
  -- 2^n-1, since these are the standard sizes allowed by LabVIEW FPGA.
  function FifoDepthInDataBusWidthWords(FifoDepthInSamples : integer;
                                        SampleSizeInBits : integer)
    return natural is

  begin

    -- Check that the sample size is one of the supported sizes if the FIFO is used.
    -- An unused FIFO will report the FIFO depth as zero, so ignore the sample size
    -- for an unused FIFO.
    assert(SampleSizeInBits = 8 or SampleSizeInBits = 16 or SampleSizeInBits = 32 or
      SampleSizeInBits = 64 or FifoDepthInSamples = 0)
      report "Sample size reported as " & integer'image(SampleSizeInBits) & LF &
             " which is not one of the restricted values of 8, 16, 32, or 64."
      severity error;

    if FifoDepthInSamples <= 0 then
      return 0;
    else
      return (FifoDepthInSamples+1)*SampleSizeInBits/kNiDmaDataWidth;
    end if;
  end FifoDepthInDataBusWidthWords;


  -- This function returns an array of the FIFO depths in Data Bus width words.
  -- The actual FIFO is asymmetric having the data width configurable in words that are
  -- multiple of 8 starting from 32 bit on the bus side and a possibly smaller port on
  -- the VI side.  The values passed in should come directly from PkgCommIntConfiguration.
  -- Input stream FIFO depths that are passed in should be 2^n-1, and output stream
  -- depths should be 2^n+5 (since they have a flip flop FIFO of depth 6).
  function GetFifoDepths(ChannelConfig: DmaChannelConfArray_t)
    return DmaChannelConfArray_t is

    variable ReturnVal : DmaChannelConfArray_t(ChannelConfig'range);
    variable SampleSize : integer;
    variable PeerToPeer : boolean;

  begin

    -- Set the configuration output equal to the configuration input.
    ReturnVal := ChannelConfig;

    -- Find the depth for each channel.  Take into account the depth of the flip flop
    -- FIFO for output streams.
    for i in ChannelConfig'range loop

      PeerToPeer := ChannelConfig(i).Mode = NiFpgaPeerToPeerWriter or
                    ChannelConfig(i).Mode = NiFpgaPeerToPeerReader;

      -- Determine the actual FIFO width from the sample width.
      SampleSize := ActualSampleSize(
        SampleSizeInBits => ChannelConfig(i).FifoWidth,
        PeerToPeer       => PeerToPeer,
        FxpType          => ChannelConfig(i).FxpType);

      -- An output channel needs to subtract 6 from the FIFO depth since it has a
      -- small 6 element deep FIFO on the output to overcome RAM read latency.
      if ChannelConfig(i).Mode = NiFpgaPeerToPeerWriter or
         ChannelConfig(i).Mode = NiFpgaMemoryBufferWriter or      
         ChannelConfig(i).Mode = NiFpgaTargetToHost then
        ReturnVal(i).FifoDepth :=
          FifoDepthInDataBusWidthWords(ChannelConfig(i).FifoDepth, SampleSize);
      else
        ReturnVal(i).FifoDepth :=
          FifoDepthInDataBusWidthWords(ChannelConfig(i).FifoDepth -
                ChannelConfig(i).ElementsPerClockCycle * 6, SampleSize);
      end if;
    end loop;

    return ReturnVal;

  end GetFifoDepths;

  -- This function computes the FIFO data width as it is defined by the user.
  function GetFifoDataWidth(FifoConfig: DmaChannelConfArray_t)
    return FifoDataWidthArray_t is

    variable ReturnVal : FifoDataWidthArray_t(FifoConfig'range);

  begin

    for i in FifoConfig'range loop
      ReturnVal(i) := FifoConfig(i).FifoWidth*FifoConfig(i).ElementsPerClockCycle;
    end loop;

    return ReturnVal;

  end function;


  function SizeOf(Var : InputStreamInterfaceToFifo_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                           -- DmaReset
    RetVal := RetVal + 1;                           -- Pop
    RetVal := RetVal + 1;                           -- TransferEnd
    RetVal := RetVal + Var.ByteCount'length;        -- ByteCount
    RetVal := RetVal + Var.ByteEnable'length;       -- ByteEnable
    RetVal := RetVal + Var.NumReadSamples'length;   -- NumReadSamples
    RetVal := RetVal + Var.ByteLane'length;         -- ByteLane
    RetVal := RetVal + 1;                           -- RsrvReadSpaces
    RetVal := RetVal + Var.StreamState'length;      -- StreamState
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : InputStreamInterfaceFromFifo_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                                   -- ResetDone
    RetVal := RetVal + var.FifoDataOut'length;              -- FifoDataOut
    RetVal := RetVal + var.FifoFullCount'length;            -- FifoFullCount
    RetVal := RetVal + 1;                                   -- FifoOverflow
    RetVal := RetVal + Var.ByteLanePtr'length;              -- ByteLanePtr
    RetVal := RetVal + 1;                                   -- StartStreamRequest
    RetVal := RetVal + 1;                                   -- StopStreamRequest
    RetVal := RetVal + 1;                                   -- StopStreamWithFlushRequest
    RetVal := RetVal + 1;                                   -- FlushReq
    RetVal := RetVal + 1;                                   -- WritesDisabled
    RetVal := RetVal + 1;                                   -- WritesDetected
    RetVal := RetVal + var.StateInDefaultClkDomain'length;  -- StateInDefaultClkDomain
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : OutputStreamInterfaceToFifo_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                                   -- DmaReset
    RetVal := RetVal + 1;                                   -- FifoWrite
    RetVal := RetVal + Var.WriteLengthInBytes'length;       -- WriteLengthInBytes
    RetVal := RetVal + Var.FifoData'length;                 -- FifoData
    RetVal := RetVal + Var.ByteEnable'length;               -- ByteEnable
    RetVal := RetVal + 1;                                   -- RsrvWriteSpaces
    RetVal := RetVal + Var.NumWriteSpaces'length;           -- NumWriteSpaces
    RetVal := RetVal + Var.StreamState'length;              -- StreamState
    RetVal := RetVal + 1;                                   -- ReportDisabledToDiagram
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : OutputStreamInterfaceFromFifo_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                                   -- ResetDone
    RetVal := RetVal + var.EmptyCount'length;               -- EmptyCount
    RetVal := RetVal + 1;                                   -- RsrvdSpacesFilled
    RetVal := RetVal + 1;                                   -- FifoUnderflow
    RetVal := RetVal + 1;                                   -- StartStreamRequest
    RetVal := RetVal + 1;                                   -- StopStreamRequest
    RetVal := RetVal + var.HostReadableFullCount'length;    -- HostReadableFullCount
    RetVal := RetVal + var.StateInDefaultClkDomain'length;  -- StateInDefaultClkDomain
    return RetVal;
  end function SizeOf;
  
end PkgDmaPortDmaFifos;
