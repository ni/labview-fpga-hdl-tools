-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcInputStream.vhd
-- Author: Florin Hurgoi
-- Original Project: LabVIEW FPGA
-- Date: 25 September 2007
--
-------------------------------------------------------------------------------
-- (c) 2007 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   This block implements an entire LvFpga input DMA channel.  There are
--   several interfaces to this device.  There is an interface from the user
--   VI FIFO.  There is an interface to the arbiter to request access
--   to transmit data to the NI DMA IP.  There is the NI DMA IP interface to
--   send the DMA packets.  Lastly, the register port interface that can be use
--   to access DMA channel registers directly.
--

-- Harmish: 08/04/2014 -- Added support for the Flush method.
-- + Propagate the bInputDataInterfaceFromFifo.FlushRequest to Controller logic.
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

  -- This package contains the definitions for the LabVIEW FPGA register
  -- framework signals
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;

  -- This package contains some useful functions for determining the width of
  -- the empty count from the data packing FIFO.
  use work.PkgDmaPortDataPackingFifo.all;

  -- The pkg containing the definitions for the FIFO interface signals.
  use work.PkgDmaPortDmaFifos.all;

  -- This pkg contains stream state definitions.
  use work.PkgDmaPortCommIfcStreamStates.all;

  -- This package contains the definitions for the interface between the NI DMA IP and
  -- the application specific logic
  use work.PkgNiDma.all;
  
  use work.PkgCommIntConfiguration.all;

entity DmaPortCommIfcInputStream is
    generic(

      -- kFifoDepth        : This is the size of the DMA FIFO in samples.
      kFifoDepth           : natural  := 1024;

      -- kSampleWidth       : This is the width of one sample coming from the
      --                     user VI.
      kSampleWidth          : positive := 32;

      -- kBaseOffset       : This is the base offset for addressing the DMA
      --                     channel.  The full address for the DMA channel is
      --                     DmaPortBaseAddress + DMAChannelBaseOffset.
      kBaseOffset          : natural  := 0;

      -- kStreamNumber     : This is the stream number associated with the DMA
      --                     channel.
      kStreamNumber        : natural  := 0;

      -- kEvictionTimeout  : This is the number of BusClk cycles to wait before
      --                     asserting an emergency transmission request to the
      --                     arbiter.
      kEvictionTimeout     : natural  := 512;

      -- kPeerToPeerStream : This indicates whether the input stream is a normal
      --                     host input stream or a peer-to-peer source stream.
      kPeerToPeerStream    : boolean := false;

      -- kFxpType          : This boolean indicates whether the data type is a
      --                     FXP type.
      kFxpType             : boolean  := false

    );
    port(

      -- The asynchronous reset for the stream circuit
      aReset : in boolean;

      -- This is a synchronous reset for the stream circuit.  The intention
      -- is for this signal to come from the PCI-e reset signal, so that the
      -- communication interface resets when the bus resets.  However, the user
      -- VI continues to run when the bus resets.  Using the reset as a
      -- synchronous reset makes it easier to cross reset boundaries.
      bReset : in boolean;

      -------------------------------------------------------------------------
      -- Clocks
      -------------------------------------------------------------------------

      -- The communication interface Bus clock.
      BusClk : in std_logic;

      -------------------------------------------------------------------------
      -- NI DMA IP interface
      -------------------------------------------------------------------------

      -- The DMA IN send request access to the DMA channel. This bus carry the
      -- information details about the requested transaction.
      bNiDmaInputRequestToDma : out NiDmaInputRequestToDma_t;

      -- The Acknowledge from the NI DMA IP indicating that the request was received.
      bNiDmaInputRequestFromDma : in NiDmaInputRequestFromDma_t;

      -- The DMA controller responds on the Status Interface to the requests sent
      -- on the Input Request interface.
      bNiDmaInputStatusFromDma : in NiDmaInputStatusFromDma_t;

      -------------------------------------------------------------------------
      -- Input Data Control interface
      -------------------------------------------------------------------------
      -- The FIFO's output data is connected to the Input Data Control.
      bInputDataInterfaceFromFifo: out NiDmaInputDataToDma_t;
      bInputDataInterfaceToFifo: in NiDmaInputDataFromDma_t;

      -------------------------------------------------------------------------
      -- Arbiter signals
      -------------------------------------------------------------------------

      -- bArbiterNormalReq   : This is the signal to the arbiter indicating
      --                       that normal access is requested to the NI DMA IP.
      bArbiterNormalReq      : out std_logic;

      -- bArbiterEmergencyReq: This is the signal to the arbiter indicating
      --                       that emergency access is requested to the
      --                       NI DMA IP.
      bArbiterEmergencyReq   : out std_logic;

      -- bArbiterDone        : This is the signal to the arbiter indicating
      --                       that the current access to Input Request Interface
      --                       has completed on this clock cycle. This is a strobe bit.
      bArbiterDone           : out std_logic;

      -- bArbiterGrant       : This is the signal from the arbiter indicating
      --                       the DMA channel has access to Input Request Interface.
      --                       This stays asserted while the channel has access.
      bArbiterGrant          : in  std_logic;

      -------------------------------------------------------------------------
      -- Register access signals from register access component
      -------------------------------------------------------------------------

      -- bRegPortIn          : These are the register signals coming
      --                       from the Host to issue write requests.
      bRegPortIn             : in  RegPortIn_t;

      -- bRegPortOut         : These are the register signals going back
      --                       to the Host to provide write responses.
      bRegPortOut            : out RegPortOut_t;

      -------------------------------------------------------------------------
      -- FIFO interface
      -------------------------------------------------------------------------

      -- bInputStreamInterfaceToFifo   : These are the signals going from the
      --                                 DMA component to the FIFO.
      bInputStreamInterfaceToFifo   : out InputStreamInterfaceToFifo_t;

      -- bInputStreamInterfaceFromFifo : These are the signals going from the
      --                                 FIFO to the DMA component.
      bInputStreamInterfaceFromFifo : in InputStreamInterfaceFromFifo_t;

      -------------------------------------------------------------------------
      -- IRQ signals
      -------------------------------------------------------------------------

      bIrq : out IrqStatusToInterface_t

    );
end DmaPortCommIfcInputStream;


architecture structure of DmaPortCommIfcInputStream is

  -- The constant represents the sample width rounded up to the closer standard data type.
  constant kSampleSize : integer := ActualSampleSize (SampleSizeInBits => kSampleWidth,
                                                      PeerToPeer => kPeerToPeerStream,
                                                      FxpType => kFxpType);

  -- The FIFO count width in samples.
  constant kFifoCountWidth : integer := Log2(kFifoDepth);

  signal bFifoFullCount: unsigned(kFifoCountWidth-1 downto 0);

  signal bStopChannelRequest : boolean;
  signal bInputStatusReceived : boolean;
  signal bInputStreamErrorStatus : boolean;

  --vhook_sigstart
  signal bByteLanePtr: NiDmaByteLane_t;
  signal bClearEnableIrq: boolean;
  signal bClearFlushingFailedStatus: boolean;
  signal bClearFlushingIrq: boolean;
  signal bClearFlushingStatus: boolean;
  signal bClearSatcr: boolean;
  signal bDisableController: boolean;
  signal bDisabled: boolean;
  signal bDmaReset: boolean;
  signal bFifoOverflow: boolean;
  signal bFlushIrqStrobe: boolean;
  signal bFlushReq: boolean;
  signal bHostDisable: boolean;
  signal bHostEnable: boolean;
  signal bHostFlush: boolean;
  signal bLinked: boolean;
  signal bMaxPktSize: unsigned(Log2(kInputMaxTransfer)downto 0);
  signal bNumReadSamples: NiDmaInputByteCount_t;
  signal bReqWriteSpaces: unsigned(Log2(kInputMaxTransfer)downto 0);
  signal bResetDmaChannel: boolean;
  signal bResetDone: boolean;
  signal bResetFifo: boolean;
  signal bRsrvReadSpaces: boolean;
  signal bSatcrWriteEvent: boolean;
  signal bSatcrWriteStrobe: boolean;
  signal bSetEnableIrq: boolean;
  signal bSetFlushingFailedStatus: boolean;
  signal bSetFlushingStatus: boolean;
  signal bStartChannelRequest: boolean;
  signal bState: StreamStateValue_t;
  signal bStateInDefaultClkDomain: StreamStateValue_t;
  signal bStopChannelWithFlushRequest: boolean;
  signal bWriteDetected: boolean;
  signal bWritesDisabled: boolean;
  --vhook_sigend


begin

  bInputStreamInterfaceToFifo.DmaReset <= bDmaReset or bResetFifo;
  bInputStreamInterfaceToFifo.NumReadSamples <= bNumReadSamples;
  bInputStreamInterfaceToFifo.RsrvReadSpaces <= bRsrvReadSpaces;
  bInputStreamInterfaceToFifo.StreamState <= bState;

  -- Previously, this logic would pop the FIFO whenever the DMA 
  -- controller popped this channel. By adding a reference to bDisabled, 
  -- we can connect two stream circuits to a single DMA channel as long 
  -- as we know that only one stream will be enabled at a time. Mostly, 
  -- this simplified modifications to the testbench, which contained 32 
  -- LV DMA channels and thus had no room left for fixed-logic channels. 
  -- We may need to reconsider this change if it leads to timing closure 
  -- problems, but it looks pretty safe: bDisabled is a FF output, so 
  -- this adds a single input to a LUT that previously seemed to have 
  -- only two inputs. I haven't verified this with a post-synthesis view 
  -- of the design, but the critical path for this logic appears to 
  -- contain a single LUT.
  bInputStreamInterfaceToFifo.Pop <= 
    bInputDataInterfaceToFifo.Pop when
                       bInputDataInterfaceToFifo.DmaChannel(kStreamNumber)
                   and not bDisabled
    else false;
  bInputStreamInterfaceToFifo.TransferEnd <= bInputDataInterfaceToFifo.TransferEnd;
  bInputStreamInterfaceToFifo.ByteCount <= bInputDataInterfaceToFifo.ByteCount;
  bInputStreamInterfaceToFifo.ByteEnable <= bInputDataInterfaceToFifo.ByteEnable;
  bInputStreamInterfaceToFifo.ByteLane <= bInputDataInterfaceToFifo.ByteLane;


  bResetDone <= bInputStreamInterfaceFromFifo.ResetDone;
  bFifoFullCount <= resize(bInputStreamInterfaceFromFifo.FifoFullCount,
    bFifoFullCount'length);
  bFifoOverflow <= bInputStreamInterfaceFromFifo.FifoOverflow;
  bByteLanePtr <= bInputStreamInterfaceFromFifo.ByteLanePtr;
  bStartChannelRequest <= bInputStreamInterfaceFromFifo.StartStreamRequest;
  bStopChannelRequest <= bInputStreamInterfaceFromFifo.StopStreamRequest;
  bStopChannelWithFlushRequest <=
    bInputStreamInterfaceFromFifo.StopStreamWithFlushRequest;
  bFlushReq <= bInputStreamInterfaceFromFifo.FlushRequest;
  bWritesDisabled <= bInputStreamInterfaceFromFifo.WritesDisabled;
  bStateInDefaultClkDomain <= bInputStreamInterfaceFromFifo.StateInDefaultClkDomain;
  bInputDataInterfaceFromFifo.Data <= (others => '0') when bDisabled
                                 else bInputStreamInterfaceFromFifo.FifoDataOut;
  bWriteDetected <= bInputStreamInterfaceFromFifo.WriteDetected;

  bInputStatusReceived <= bNiDmaInputStatusFromDma.Ready when
                            bNiDmaInputStatusFromDma.DmaChannel(kStreamNumber)
                          else false;

  bInputStreamErrorStatus <= bNiDmaInputStatusFromDma.ErrorStatus when
                               bNiDmaInputStatusFromDma.Ready and
                               bNiDmaInputStatusFromDma.DmaChannel(kStreamNumber)
                             else false;

  -- Synchronously reset the DMA channel with the reset bit or the synchronous reset
  -- for the communication interface.
  bResetDmaChannel <= bReset or bDmaReset;

  --vhook_e DmaPortCommIfcInputController
  --vhook_a bInputRequest bNiDmaInputRequestToDma
  --vhook_a bRequestAcknowledge bNiDmaInputRequestFromDma
  --vhook_a kSampleSizeInBits kSampleSize
  --vhook_a kEvictionTimeout
  --vhook_a bReset bResetDmaChannel
  --vhook_a bFlushReq bFlushReq
  --vhook_a bDisable bDisableController
  DmaPortCommIfcInputControllerx: entity work.DmaPortCommIfcInputController (rtl)
    generic map (
      kStreamNumber     => kStreamNumber,      -- in  natural := 0
      kSampleSizeInBits => kSampleSize,        -- in  positive := 64
      kFifoCountWidth   => kFifoCountWidth,    -- in  natural
      kEvictionTimeout  => kEvictionTimeout,   -- in  natural := 128
      kPeerToPeerStream => kPeerToPeerStream)  -- in  boolean := false
    port map (
      aReset               => aReset,                     -- in  boolean
      bReset               => bResetDmaChannel,           -- in  boolean
      BusClk               => BusClk,                     -- in  std_logic
      bInputRequest        => bNiDmaInputRequestToDma,    -- out NiDmaInputRequestToDma_t
      bRequestAcknowledge  => bNiDmaInputRequestFromDma,  -- in  NiDmaInputRequestFromDma
      bInputStatusReceived => bInputStatusReceived,       -- in  boolean
      bArbiterNormalReq    => bArbiterNormalReq,          -- out std_logic
      bArbiterEmergencyReq => bArbiterEmergencyReq,       -- out std_logic
      bArbiterDone         => bArbiterDone,               -- out std_logic
      bArbiterGrant        => bArbiterGrant,              -- in  std_logic
      bMaxPktSize          => bMaxPktSize,                -- in  NiDmaInputByteCount_t
      bWriteDetected       => bWriteDetected,             -- in  boolean
      bFifoFullCount       => bFifoFullCount,             -- in  unsigned(kFifoCountWidth
      bNumReadSamples      => bNumReadSamples,            -- out NiDmaInputByteCount_t
      bByteLanePtr         => bByteLanePtr,               -- in  NiDmaByteLane_t
      bRsrvReadSpaces      => bRsrvReadSpaces,            -- out boolean
      bFlushReq            => bFlushReq,                  -- in  boolean
      bResetFifo           => bResetFifo,                 -- out boolean
      bResetDone           => bResetDone,                 -- in  boolean
      bSatcrWriteStrobe    => bSatcrWriteStrobe,          -- out boolean
      bReqWriteSpaces      => bReqWriteSpaces,            -- out NiDmaInputByteCount_t
      bDisable             => bDisableController,         -- in  boolean
      bDisabled            => bDisabled,                  -- out boolean
      bClearSatcr          => bClearSatcr);               -- out boolean



  --vhook_e DmaPortCommIfcRegisters
  --vhook_a kInputStream true
  --vhook_a kMaxTransfer kInputMaxTransfer
  --vhook_a bFifoCount bFifoFullCount
  --vhook_a bPeerAddress open
  --vhook_a bFifoUnderflow false
  --vhook_a bStartChannelRequest bSetEnableIrq
  --vhook_a bStopChannelRequest false
  --vhook_a bClearDisableIrq false
  --vhook_a bStreamError bInputStreamErrorStatus
  --vhook_a bSatcrUpdatesEnabled open
  DmaPortCommIfcRegistersx: entity work.DmaPortCommIfcRegisters (behavior)
    generic map (
      kBaseOffset       => kBaseOffset,        -- in  natural := 16#50#
      kInputStream      => true,               -- in  boolean := false
      kPeerToPeerStream => kPeerToPeerStream,  -- in  boolean := false
      kMaxTransfer      => kInputMaxTransfer)  -- in  natural
    port map (
      aReset                     => aReset,                      -- in  boolean
      bReset                     => bReset,                      -- in  boolean
      BusClk                     => BusClk,                      -- in  std_logic
      bRegPortIn                 => bRegPortIn,                  -- in  RegPortIn_t
      bRegPortOut                => bRegPortOut,                 -- out RegPortOut_t
      bHostEnable                => bHostEnable,                 -- out boolean
      bHostDisable               => bHostDisable,                -- out boolean
      bHostFlush                 => bHostFlush,                  -- out boolean
      bDisabled                  => bDisabled,                   -- in  boolean
      bDmaReset                  => bDmaReset,                   -- out boolean
      bResetDone                 => bResetDone,                  -- in  boolean
      bFifoOverflow              => bFifoOverflow,               -- in  boolean
      bFifoUnderflow             => false,                       -- in  boolean
      bStartChannelRequest       => bSetEnableIrq,               -- in  boolean
      bStopChannelRequest        => false,                       -- in  boolean
      bFlushIrqStrobe            => bFlushIrqStrobe,             -- in  boolean
      bClearEnableIrq            => bClearEnableIrq,             -- in  boolean
      bClearDisableIrq           => false,                       -- in  boolean
      bClearFlushingIrq          => bClearFlushingIrq,           -- in  boolean
      bSetFlushingStatus         => bSetFlushingStatus,          -- in  boolean
      bClearFlushingStatus       => bClearFlushingStatus,        -- in  boolean
      bSetFlushingFailedStatus   => bSetFlushingFailedStatus,    -- in  boolean
      bClearFlushingFailedStatus => bClearFlushingFailedStatus,  -- in  boolean
      bSatcrWriteEvent           => bSatcrWriteEvent,            -- out boolean
      bClearSatcr                => bClearSatcr,                 -- in  boolean
      bStreamError               => bInputStreamErrorStatus,     -- in  boolean
      bMaxPktSize                => bMaxPktSize,                 -- out unsigned(Log2(kMa
      bSatcrWriteStrobe          => bSatcrWriteStrobe,           -- in  boolean
      bReqWriteSpaces            => bReqWriteSpaces,             -- in  unsigned(Log2(kMa
      bFifoCount                 => bFifoFullCount,              -- in  unsigned
      bPeerAddress               => open,                        -- out NiDmaAddress_t
      bState                     => bState,                      -- in  StreamStateValue_
      bLinked                    => bLinked,                     -- out boolean
      bSatcrUpdatesEnabled       => open,                        -- out boolean
      bIrq                       => bIrq);                       -- out IrqStatusToInterf



  --vhook_e DmaPortCommIfcSourceStreamStateController
  --vhook_a bDisable open
  --vhook_a bStopChannelRequest bStopChannelRequest
  DmaPortCommIfcSourceStreamStateControllerx: entity work.DmaPortCommIfcSourceStreamStateController (behavior)
    port map (
      aReset                       => aReset,                        -- in  boolean
      bReset                       => bReset,                        -- in  boolean
      BusClk                       => BusClk,                        -- in  std_logic
      bState                       => bState,                        -- out StreamStateVa
      bDisable                     => open,                          -- out boolean
      bDisableController           => bDisableController,            -- out boolean := tr
      bFlushIrqStrobe              => bFlushIrqStrobe,               -- out boolean
      bSetEnableIrq                => bSetEnableIrq,                 -- out boolean
      bClearEnableIrq              => bClearEnableIrq,               -- out boolean
      bClearFlushingIrq            => bClearFlushingIrq,             -- out boolean
      bSetFlushingStatus           => bSetFlushingStatus,            -- out boolean
      bClearFlushingStatus         => bClearFlushingStatus,          -- out boolean
      bSetFlushingFailedStatus     => bSetFlushingFailedStatus,      -- out boolean
      bClearFlushingFailedStatus   => bClearFlushingFailedStatus,    -- out boolean
      bHostEnable                  => bHostEnable,                   -- in  boolean
      bHostDisable                 => bHostDisable,                  -- in  boolean
      bHostFlush                   => bHostFlush,                    -- in  boolean
      bStartChannelRequest         => bStartChannelRequest,          -- in  boolean
      bStopChannelRequest          => bStopChannelRequest,           -- in  boolean
      bStopChannelWithFlushRequest => bStopChannelWithFlushRequest,  -- in  boolean
      bDisabled                    => bDisabled,                     -- in  boolean
      bLinked                      => bLinked,                       -- in  boolean
      bSatcrWriteEvent             => bSatcrWriteEvent,              -- in  boolean
      bFifoFullCount               => bFifoFullCount,                -- in  unsigned
      bWritesDisabled              => bWritesDisabled,               -- in  boolean
      bStateInDefaultClkDomain     => bStateInDefaultClkDomain);     -- in  StreamStateVa



end structure;
