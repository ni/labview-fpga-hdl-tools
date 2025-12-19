-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcSinkStream.vhd
-- Author: Florin Hurgoi
-- Original Project: LabVIEW FPGA support for Emerald Bay
-- Date: 31 May 2012
--
-------------------------------------------------------------------------------
-- (c) 2008 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   This block implements the sink stream circuit.  This is the receiving end
-- of a peer-to-peer transmission.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

  -- This pkg contains the definitions for the LabVIEW FPGA register
  -- framework signals
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;

  -- This pkg contains the information for the max packet size for the
  -- DmaPort implementation
  use work.PkgCommIntConfiguration.all;

  -- This pkg contains information regarding FIFO address width
  use work.PkgDmaPortDataPackingFifo.all;

  -- The pkg containing the definitions for the FIFO interface signals.
  use work.PkgDmaPortDmaFifos.all;

  -- This pkg contains stream state definitions.
  use work.PkgDmaPortCommIfcStreamStates.all;

  -- This package contains the definitions for the interface between the NI DMA IP and
  -- the application specific logic
  use work.PkgNiDma.all;

entity DmaPortCommIfcSinkStream is
    generic(

      -- kFifoDepth      : This is the size of the DMA FIFO in samples.
      kFifoDepth         : natural := 1024;

      -- kFifoBaseOffset : This is the base offset for the DMA FIFO.  This is
      --                   the whole address and is not the offset specified
      --                   by kBaseOffset.
      kFifoBaseOffset    : natural := 16#10#;

      -- kWriteWindow    : This is the size of the memory window used to
      --                   address the DMA FIFO.  This is simply used to decode
      --                   memory writes intended for the FIFO and is not
      --                   related to the actual FIFO depth.
      kWriteWindow       : natural := 4096;

      -- kSampleWidth    : This is the sample size of the data going to the
      --                   user VI.  This is used to set the FIFO data width
      --                   and the data width of corresponding signals.
      kSampleWidth       : positive := 32;

      -- kBaseOffset     : This is the base offset for addressing the DMA
      --                   channel.  The full address for the DMA channel is
      --                   DmaPortBaseAddress + DMAChannelBaseOffset.
      kBaseOffset        : natural := 0;

      -- kStreamNumber   : This is the stream number associated with the DMA
      --                   channel.
      kStreamNumber      : natural := 0;

      -- kFxpType        : This boolean indicates whether the data type is a
      --                   FXP type.
      kFxpType           : boolean  := false

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

      BusClk : in std_logic;

      -------------------------------------------------------------------------
      -- DmaPort interface
      -------------------------------------------------------------------------

      -- The Input Stream sends a request access to the DMA channel. This bus
      -- carry the information details about the requested transaction.
      bNiDmaInputRequestToDma : out NiDmaInputRequestToDma_t;

      -- The Acknowledge from the DMA controller indicating that the request
      -- was received.
      bNiDmaInputRequestFromDma : in NiDmaInputRequestFromDma_t;

      bNiDmaInputDataFromDma : in NiDmaInputDataFromDma_t;

      bNiDmaInputDataToDma : out NiDmaInputDataToDma_t;

      bNiDmaHighSpeedSinkFromDma : in NiDmaHighSpeedSinkFromDma_t;

      bNiDmaInputDataToDmaValid : out boolean;

      -------------------------------------------------------------------------
      -- Arbiter signals
      -------------------------------------------------------------------------

      -- bArbiterNormalReq   : This is the signal to the arbiter indicating
      --                       that normal access is requested to the DmaPort.
      bArbiterNormalReq      : out std_logic;

      -- bArbiterEmergencyReq: This is the signal to the arbiter indicating
      --                       that emergency access is requested to the
      --                       DmaPort.
      bArbiterEmergencyReq   : out std_logic;

      -- bArbiterDone        : This is the signal to the arbiter indicating
      --                       that the current access to DmaPort has completed
      --                       on this clock cycle.  This is a strobe bit.
      bArbiterDone           : out std_logic;

      -- bArbiterGrant       : This is the signal from the arbiter indicating
      --                       the DMA channel has access to DmaPort.  This
      --                       stays asserted while the channel has access.
      bArbiterGrant          : in  std_logic;

      -------------------------------------------------------------------------
      -- Register access signals from register access component
      -------------------------------------------------------------------------

      -- bRegPortIn          : These are the register access signals coming
      --                       from the register access component to issue
      --                       read and write requests.
      bRegPortIn             : in  RegPortIn_t;

      -- bRegPortOut         : These are the register access signals going back
      --                       to the register access component to provide
      --                       write responses.
      bRegPortOut            : out RegPortOut_t;

      -------------------------------------------------------------------------
      -- FIFO interface
      -------------------------------------------------------------------------

      -- bOutputStreamInterfaceToFifo   : These are the signals going from the
      --                                  DMA component to the FIFO.
      bOutputStreamInterfaceToFifo : out OutputStreamInterfaceToFifo_t;

      -- bOutputStreamInterfaceFromFifo : These are the signals going from the
      --                                  FIFO to the DMA component.
      bOutputStreamInterfaceFromFifo : in OutputStreamInterfaceFromFifo_t;

      -------------------------------------------------------------------------
      -- IRQ signals
      -------------------------------------------------------------------------

      -- bIrq : The IRQ interface to the DmaPortCommIfcLvFpgaIrq component.
      bIrq : out IrqStatusToInterface_t

    );
end DmaPortCommIfcSinkStream;


architecture structure of DmaPortCommIfcSinkStream is

  -- The constant represents the sample width rounded up to the closer standard data type.
  constant kSampleSize : integer := ActualSampleSize (SampleSizeInBits => kSampleWidth,
                                                      PeerToPeer => true,
                                                      FxpType => kFxpType);

  -- The FIFO count width in samples.
  constant kFifoCountWidth : integer := Log2(kFifoDepth);

  constant kReqWriteSpacesZero : unsigned(Log2(kFifoWriteWindow) downto 0) :=
    (others=>'0');

  signal bEmptyCount: unsigned(kFifoCountWidth-1 downto 0);
  signal bReqWriteSpaces: unsigned(kFifoCountWidth-1 downto 0);
  signal bHostReadableFullCount : unsigned(31 downto 0);

  --vhook_sigstart
  signal bByteEnable: NiDmaByteEnable_t;
  signal bClearDisableIrq: boolean;
  signal bClearEnableIrq: boolean;
  signal bDisable: boolean;
  signal bDisabled: boolean;
  signal bDisabledFromDataReceiver: boolean;
  signal bDisabledFromTcrUpdateController: boolean;
  signal bDisabledStatusForHost: boolean;
  signal bDmaReset: boolean;
  signal bFifoData: NiDmaData_t;
  signal bFifoUnderflow: boolean;
  signal bFifoWrite: boolean;
  signal bHostDisable: boolean;
  signal bHostEnable: boolean;
  signal bLinked: boolean;
  signal bPeerAddress: NiDmaAddress_t;
  signal bReportDisabledToDiagram: boolean;
  signal bResetDmaChannel: boolean;
  signal bResetDmaChannelAndFifo: boolean;
  signal bResetDone: boolean;
  signal bResetFifo: boolean;
  signal bSatcrUpdatesEnabled: boolean;
  signal bSatcrWriteStrobe: boolean;
  signal bSetEnableIrq: boolean;
  signal bStartChannelRequest: boolean;
  signal bState: StreamStateValue_t;
  signal bStateInDefaultClkDomain: StreamStateValue_t;
  signal bStopChannelRequest: boolean;
  signal bStreamError: boolean;
  signal bWriteLengthInBytes: NiDmaBusByteCount_t;
  --vhook_sigend

begin

  bOutputStreamInterfaceToFifo.DmaReset <= bDmaReset or bResetFifo;
  bOutputStreamInterfaceToFifo.FifoWrite <= bFifoWrite;
  bOutputStreamInterfaceToFifo.WriteLengthInBytes <= bWriteLengthInBytes;
  bOutputStreamInterfaceToFifo.FifoData <= bFifoData;
  bOutputStreamInterfaceToFifo.ByteEnable <= bByteEnable;
  bOutputStreamInterfaceToFifo.RsrvWriteSpaces <= bSatcrWriteStrobe;
  bOutputStreamInterfaceToFifo.NumWriteSpaces <= resize(bReqWriteSpaces,
    bOutputStreamInterfaceToFifo.NumWriteSpaces'length);
  bOutputStreamInterfaceToFifo.StreamState <= bState;
  bOutputStreamInterfaceToFifo.ReportDisabledToDiagram <= bReportDisabledToDiagram;

  bResetDone <= bOutputStreamInterfaceFromFifo.ResetDone;
  bEmptyCount <= resize(bOutputStreamInterfaceFromFifo.EmptyCount, bEmptyCount'length);
  bFifoUnderflow <= bOutputStreamInterfaceFromFifo.FifoUnderflow;
  bStartChannelRequest <= bOutputStreamInterfaceFromFifo.StartStreamRequest;
  bStopChannelRequest <= bOutputStreamInterfaceFromFifo.StopStreamRequest;
  bHostReadableFullCount <= bOutputStreamInterfaceFromFifo.HostReadableFullCount;
  bStateInDefaultClkDomain <= bOutputStreamInterfaceFromFifo.StateInDefaultClkDomain;


  -- Synchronously reset the DMA channel with the reset bit or the synchronous reset
  -- for the communication interface.
  bResetDmaChannel <= bDmaReset or bReset;

  -- The synchronous reset signal qualified with the FIFO reset.  This is used to reset
  -- components that must also reset whenever the FIFO resets.
  bResetDmaChannelAndFifo <= bResetDmaChannel or bResetFifo;

  -- The stream is only safely disabled once the data receiver and TCR update
  -- controller both report that they are safely disabled.
  bDisabled <= bDisabledFromDataReceiver and bDisabledFromTcrUpdateController;

  --vhook_e DmaPortCommIfcSinkStreamDataReceiver
  --vhook_a bReset bResetDmaChannelAndFifo
  --vhook_a bHighSpeedSink bNiDmaHighSpeedSinkFromDma
  --vhook_a bDisabled bDisabledFromDataReceiver
  DmaPortCommIfcSinkStreamDataReceiverx: entity work.DmaPortCommIfcSinkStreamDataReceiver (rtl)
    generic map (
      kFifoBaseOffset => kFifoBaseOffset,  -- in  natural
      kWriteWindow    => kWriteWindow,     -- in  natural := 4096
      kStreamNumber   => kStreamNumber)    -- in  natural
    port map (
      aReset              => aReset,                      -- in  boolean
      bReset              => bResetDmaChannelAndFifo,     -- in  boolean
      BusClk              => BusClk,                      -- in  std_logic
      bHighSpeedSink      => bNiDmaHighSpeedSinkFromDma,  -- in  NiDmaHighSpeedSinkFromDm
      bFifoWrite          => bFifoWrite,                  -- out boolean
      bWriteLengthInBytes => bWriteLengthInBytes,         -- out NiDmaBusByteCount_t
      bFifoData           => bFifoData,                   -- out NiDmaData_t
      bByteEnable         => bByteEnable,                 -- out NiDmaByteEnable_t
      bDisable            => bDisable,                    -- in  boolean := true
      bDisabled           => bDisabledFromDataReceiver,   -- out boolean
      bStreamError        => bStreamError);               -- out boolean


  --vhook_e DmaPortCommIfcSinkStreamTcrUpdateController
  --vhook_a kDataWidthInBits kSampleSize
  --vhook_a bSatcrUpdateDataValid bNiDmaInputDataToDmaValid
  --vhook_a bReset bResetDmaChannelAndFifo
  --vhook_a bFifoEmptyCount bEmptyCount
  --vhook_a bTcrAddress bPeerAddress
  --vhook_a bDisabled bDisabledFromTcrUpdateController
  DmaPortCommIfcSinkStreamTcrUpdateControllerx: entity work.DmaPortCommIfcSinkStreamTcrUpdateController (rtl)
    generic map (
      kDataWidthInBits => kSampleSize,      -- in  positive := 64
      kStreamNumber    => kStreamNumber,    -- in  natural
      kFifoCountWidth  => kFifoCountWidth)  -- in  natural
    port map (
      aReset                    => aReset,                            -- in  boolean
      bReset                    => bResetDmaChannelAndFifo,           -- in  boolean
      BusClk                    => BusClk,                            -- in  std_logic
      bNiDmaInputRequestToDma   => bNiDmaInputRequestToDma,           -- out NiDmaInputRe
      bNiDmaInputRequestFromDma => bNiDmaInputRequestFromDma,         -- in  NiDmaInputRe
      bNiDmaInputDataFromDma    => bNiDmaInputDataFromDma,            -- in  NiDmaInputDa
      bNiDmaInputDataToDma      => bNiDmaInputDataToDma,              -- out NiDmaInputDa
      bSatcrUpdateDataValid     => bNiDmaInputDataToDmaValid,         -- out boolean
      bArbiterNormalReq         => bArbiterNormalReq,                 -- out std_logic
      bArbiterEmergencyReq      => bArbiterEmergencyReq,              -- out std_logic
      bArbiterDone              => bArbiterDone,                      -- out std_logic
      bArbiterGrant             => bArbiterGrant,                     -- in  std_logic
      bFifoEmptyCount           => bEmptyCount,                       -- in  unsigned(kFi
      bSatcrWriteStrobe         => bSatcrWriteStrobe,                 -- out boolean
      bReqWriteSpaces           => bReqWriteSpaces,                   -- out unsigned(kFi
      bTcrAddress               => bPeerAddress,                      -- in  NiDmaAddress
      bDisable                  => bDisable,                          -- in  boolean
      bDisabled                 => bDisabledFromTcrUpdateController,  -- out boolean
      bSatcrUpdatesEnabled      => bSatcrUpdatesEnabled);             -- in  boolean



  --vhook_e DmaPortCommIfcRegisters
  --vhook_a kInputStream false
  --vhook_a kPeerToPeerStream true
  --vhook_a kMaxTransfer kFifoWriteWindow
  --vhook_a bFifoOverflow false
  --vhook_a bStartChannelRequest bSetEnableIrq
  --vhook_a bSatcrWriteStrobe false
  --vhook_a bMaxPktSize open
  --vhook_a bReqWriteSpaces kReqWriteSpacesZero
  --vhook_a bFifoCount bHostReadableFullCount
  --vhook_a bClearFlushingIrq false
  --vhook_a bSatcrWriteEvent open
  --vhook_a bClearSatcr false
  --vhook_a bHostFlush open
  --vhook_a bDisabled bDisabledStatusForHost
  --vhook_a bFlushIrqStrobe false
  --vhook_a bSetFlushingFailedStatus false
  --vhook_a bClearFlushingFailedStatus false
  --vhook_a bSetFlushingStatus false
  --vhook_a bClearFlushingStatus false
  DmaPortCommIfcRegistersx: entity work.DmaPortCommIfcRegisters (behavior)
    generic map (
      kBaseOffset       => kBaseOffset,       -- in  natural := 16#50#
      kInputStream      => false,             -- in  boolean := false
      kPeerToPeerStream => true,              -- in  boolean := false
      kMaxTransfer      => kFifoWriteWindow)  -- in  natural
    port map (
      aReset                     => aReset,                  -- in  boolean
      bReset                     => bReset,                  -- in  boolean
      BusClk                     => BusClk,                  -- in  std_logic
      bRegPortIn                 => bRegPortIn,              -- in  RegPortIn_t
      bRegPortOut                => bRegPortOut,             -- out RegPortOut_t
      bHostEnable                => bHostEnable,             -- out boolean
      bHostDisable               => bHostDisable,            -- out boolean
      bHostFlush                 => open,                    -- out boolean
      bDisabled                  => bDisabledStatusForHost,  -- in  boolean
      bDmaReset                  => bDmaReset,               -- out boolean
      bResetDone                 => bResetDone,              -- in  boolean
      bFifoOverflow              => false,                   -- in  boolean
      bFifoUnderflow             => bFifoUnderflow,          -- in  boolean
      bStartChannelRequest       => bSetEnableIrq,           -- in  boolean
      bStopChannelRequest        => bStopChannelRequest,     -- in  boolean
      bFlushIrqStrobe            => false,                   -- in  boolean
      bClearEnableIrq            => bClearEnableIrq,         -- in  boolean
      bClearDisableIrq           => bClearDisableIrq,        -- in  boolean
      bClearFlushingIrq          => false,                   -- in  boolean
      bSetFlushingStatus         => false,                   -- in  boolean
      bClearFlushingStatus       => false,                   -- in  boolean
      bSetFlushingFailedStatus   => false,                   -- in  boolean
      bClearFlushingFailedStatus => false,                   -- in  boolean
      bSatcrWriteEvent           => open,                    -- out boolean
      bClearSatcr                => false,                   -- in  boolean
      bStreamError               => bStreamError,            -- in  boolean
      bMaxPktSize                => open,                    -- out unsigned(Log2(kMaxTra
      bSatcrWriteStrobe          => false,                   -- in  boolean
      bReqWriteSpaces            => kReqWriteSpacesZero,     -- in  unsigned(Log2(kMaxTra
      bFifoCount                 => bHostReadableFullCount,  -- in  unsigned
      bPeerAddress               => bPeerAddress,            -- out NiDmaAddress_t
      bState                     => bState,                  -- in  StreamStateValue_t
      bLinked                    => bLinked,                 -- out boolean
      bSatcrUpdatesEnabled       => bSatcrUpdatesEnabled,    -- out boolean
      bIrq                       => bIrq);                   -- out IrqStatusToInterface_



  --vhook_e DmaPortCommIfcSinkStreamStateController
  --vhook_a bReset bResetDmaChannel
  --vhook_a bStopChannelRequest bStopChannelRequest
  DmaPortCommIfcSinkStreamStateControllerx: entity work.DmaPortCommIfcSinkStreamStateController (behavior)
    port map (
      aReset                   => aReset,                    -- in  boolean
      bReset                   => bResetDmaChannel,          -- in  boolean
      BusClk                   => BusClk,                    -- in  std_logic
      bState                   => bState,                    -- out StreamStateValue_t
      bReportDisabledToDiagram => bReportDisabledToDiagram,  -- out boolean
      bDisable                 => bDisable,                  -- out boolean
      bResetFifo               => bResetFifo,                -- out boolean
      bSetEnableIrq            => bSetEnableIrq,             -- out boolean
      bClearEnableIrq          => bClearEnableIrq,           -- out boolean
      bClearDisableIrq         => bClearDisableIrq,          -- out boolean
      bDisabledStatusForHost   => bDisabledStatusForHost,    -- out boolean
      bHostEnable              => bHostEnable,               -- in  boolean
      bHostDisable             => bHostDisable,              -- in  boolean
      bStopChannelRequest      => bStopChannelRequest,       -- in  boolean
      bStartChannelRequest     => bStartChannelRequest,      -- in  boolean
      bDisabled                => bDisabled,                 -- in  boolean
      bLinked                  => bLinked,                   -- in  boolean
      bResetDone               => bResetDone,                -- in  boolean
      bStreamError             => bStreamError,              -- in  boolean
      bStateInDefaultClkDomain => bStateInDefaultClkDomain); -- in  StreamStateValue_t



end structure;
