-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcOutputStream.vhd
-- Author: Florin Hurgoi
-- Original Project: LabVIEW FPGA
-- Date: 06 September 2011
--
-------------------------------------------------------------------------------
-- (c) 2007 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   This block implements an entire LvFpga output DMA channel.  There are
--   several interfaces to this device.  There is an interface to push data to
--   the FIFO in TheWindow.  There is an interface to the arbiter to request
--   access to the Output Request Interface.  Lastly, the register access component
--   has a register port interface used to access the DMA registers.
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

  -- This pkg contains information regarding FIFO address width
  use work.PkgDmaPortDataPackingFifo.all;

  -- The pkg containing the definitions for the FIFO interface signals.
  use work.PkgDmaPortDmaFifos.all;

  -- This pkg contains stream state information.
  use work.PkgDmaPortCommIfcStreamStates.all;

  -- This package contains the definitions for the interface between the NI DMA IP and
  -- the application specific logic
  use work.PkgNiDma.all;

  use work.PkgCommIntConfiguration.all;

entity DmaPortCommIfcOutputStream is
    generic(

      -- kSampleWidth    : This is the sample size of the data going to the
      --                   user VI.  This is used to set the FIFO data width
      --                   and the data width of corresponding signals.
      kSampleWidth       : positive := 32;

      -- kFifoDepth      : This is the size of the DMA FIFO in samples.
      kFifoDepth         : natural  := 1024;

      -- kBaseOffset     : This is the base offset for addressing the DMA
      --                   channel.
      kBaseOffset        : natural  := 0;

      -- kStreamNumber   : This is the stream number associated with the DMA
      --                   channel.
      kStreamNumber      : natural  := 0;

      -- kFxpType        : This boolean indicates whether the data type is a
      --                   FXP type.
      kFxpType           : boolean  := false

    );
    port(

      -- The asynchronous reset for the stream circuit
      aReset : in boolean;

      -- This is a synchronous reset for the stream circuit.
      bReset : in boolean;

      -------------------------------------------------------------------------
      -- Clocks
      -------------------------------------------------------------------------

      -- The Bus clock
      BusClk : in std_logic;

      -------------------------------------------------------------------------
      -- DmaPort interface
      -------------------------------------------------------------------------

      -- The Output Stream sends a request access to the DMA channel. This bus
      -- carry the information details about the requested transaction.
      bNiDmaOutputRequestToDma : out NiDmaOutputRequestToDma_t;

      -- The Acknowledge from the DMA controller indicating that the request
      -- was received.
      bNiDmaOutputRequestFromDma : in NiDmaOutputRequestFromDma_t;

      bNiDmaOutputDataFromDma : in NiDmaOutputDataFromDma_t;

      -------------------------------------------------------------------------
      -- Arbiter signals
      -------------------------------------------------------------------------

      -- bArbiterNormalReq   : This is the signal to the arbiter indicating
      --                       that normal access is requested to the Output
      --                       Request Interface.
      bArbiterNormalReq      : out std_logic;

      -- bArbiterEmergencyReq: This is the signal to the arbiter indicating
      --                       that emergency access is requested to the
      --                       Output Request Interface.
      bArbiterEmergencyReq   : out std_logic;

      -- bArbiterDone        : This is the signal to the arbiter indicating
      --                       that the current access to Output Request
      --                       Interface has completed on this clock cycle.
      --                       This is a strobe bit.
      bArbiterDone           : out std_logic;

      -- bArbiterGrant       : This is the signal from the arbiter indicating
      --                       the DMA channel has access to Output Request
      --                       Interface.  This stays asserted while the channel
      --                       has access.
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

      bIrq : out IrqStatusToInterface_t

    );
end DmaPortCommIfcOutputStream;


architecture structure of DmaPortCommIfcOutputStream is

  -- The constant represents the sample width rounded up to the closer standard data type.
  constant kSampleSize : integer := ActualSampleSize (SampleSizeInBits => kSampleWidth,
                                                      PeerToPeer => false,
                                                      FxpType => kFxpType);

  -- The FIFO count width in samples.
  constant kFifoCountWidth : integer := Log2(kFifoDepth);

  signal bEmptyCount: unsigned(kFifoCountWidth-1 downto 0);
  signal bHostReadableFullCount : unsigned(31 downto 0);
  signal bStopChannelRequest : boolean;
  signal bReadResponseReceived : boolean;
  signal bOutStreamErrorStatus : boolean;
  signal bReadDataPushEnable, bReadDataPushEnableNx : boolean;

  --vhook_sigstart
  signal bClearDisableIrq: boolean;
  signal bClearEnableIrq: boolean;
  signal bDisable: boolean;
  signal bDisabled: boolean;
  signal bDisabledStatusForHost: boolean;
  signal bDmaReset: boolean;
  signal bFifoUnderflow: boolean;
  signal bHostDisable: boolean;
  signal bHostEnable: boolean;
  signal bLinked: boolean;
  signal bMaxPktSize: unsigned(Log2(kOutputMaxTransfer)downto 0);
  signal bNumWriteSpaces: NiDmaOutputByteCount_t;
  signal bReportDisabledToDiagram: boolean;
  signal bReqWriteSpaces: unsigned(Log2(kOutputMaxTransfer)downto 0);
  signal bResetDmaChannel: boolean;
  signal bResetDmaChannelAndFifo: boolean;
  signal bResetDone: boolean;
  signal bResetFifo: boolean;
  signal bSatcrWriteStrobe: boolean;
  signal bSetEnableIrq: boolean;
  signal bStartChannelRequest: boolean;
  signal bState: StreamStateValue_t;
  signal bStateInDefaultClkDomain: StreamStateValue_t;
  --vhook_sigend

begin

  bOutputStreamInterfaceToFifo.DmaReset <= bDmaReset or bResetFifo;
  bOutputStreamInterfaceToFifo.FifoWrite <= bNiDmaOutputDataFromDma.Push
    when (bReadDataPushEnable and (not bOutStreamErrorStatus)) and
      bNiDmaOutputDataFromDma.DmaChannel(kStreamNumber) else false;

  bOutputStreamInterfaceToFifo.WriteLengthInBytes <= bNiDmaOutputDataFromDma.ByteCount;
  bOutputStreamInterfaceToFifo.FifoData <= bNiDmaOutputDataFromDma.Data;
  bOutputStreamInterfaceToFifo.RsrvWriteSpaces <= bSatcrWriteStrobe;
  bOutputStreamInterfaceToFifo.NumWriteSpaces <= resize(bNumWriteSpaces,
    bOutputStreamInterfaceToFifo.NumWriteSpaces'length);
  bOutputStreamInterfaceToFifo.StreamState <= bState;
  bOutputStreamInterfaceToFifo.ReportDisabledToDiagram <= bReportDisabledToDiagram;
  bOutputStreamInterfaceToFifo.ByteEnable <= bNiDmaOutputDataFromDma.ByteEnable
    when (bReadDataPushEnable and (not bOutStreamErrorStatus)) and 
      bNiDmaOutputDataFromDma.DmaChannel(kStreamNumber) else (others => false);

  bResetDone <= bOutputStreamInterfaceFromFifo.ResetDone;
  bEmptyCount <= resize(bOutputStreamInterfaceFromFifo.EmptyCount, bEmptyCount'length);
  bFifoUnderflow <= bOutputStreamInterfaceFromFifo.FifoUnderflow;
  bStartChannelRequest <= bOutputStreamInterfaceFromFifo.StartStreamRequest;
  bStopChannelRequest <= bOutputStreamInterfaceFromFifo.StopStreamRequest;
  bHostReadableFullCount <= bOutputStreamInterfaceFromFifo.HostReadableFullCount;
  bStateInDefaultClkDomain <= bOutputStreamInterfaceFromFifo.StateInDefaultClkDomain;

  -- We can consider that data corresponding to a request was received when TransferEnd
  -- on the Output Data Interface is asserted.
  bReadResponseReceived <= bNiDmaOutputDataFromDma.TransferEnd when
                             bNiDmaOutputDataFromDma.DmaChannel(kStreamNumber) and
                             bNiDmaOutputDataFromDma.Push
                            else false;

  bOutStreamErrorStatus <= bNiDmaOutputDataFromDma.ErrorStatus when
                             bNiDmaOutputDataFromDma.DmaChannel(kStreamNumber) and
                             bNiDmaOutputDataFromDma.Push 
                           else false;

  -- Synchronously reset the DMA channel with the reset bit or the synchronous reset
  -- for the communication interface.
  bResetDmaChannel <= bReset or bDmaReset;

  -- This is a reset for components that must also be reset when the FIFO resets.
  bResetDmaChannelAndFifo <= bResetDmaChannel or bResetFifo;

  -- All the data comming after an error occurs need to be ignored. We have to
  -- do not push the data into the FIFO after the ErrorStatus comming on the Output
  -- Data interface is asserted. After the stream is disabled we can enable pushing
  --  data again.
  PushEnableReg: process (aReset, BusClk) is
  begin

    if aReset then
      bReadDataPushEnable <= false;
    elsif rising_edge(BusClk) then
      if bReset then
        bReadDataPushEnable <= false;
      else
        bReadDataPushEnable <= bReadDataPushEnableNx;
      end if;
    end if;

  end process;

  PushEnable: process (bOutStreamErrorStatus, bDisabled, bReadDataPushEnable)
  begin

    if bOutStreamErrorStatus then
       bReadDataPushEnableNx <= false;
    else
      if bDisabled then
         bReadDataPushEnableNx <= true;
      else
        bReadDataPushEnableNx <= bReadDataPushEnable;
      end if;
    end if;

  end process;

  --vhook_e DmaPortCommIfcOutputController
  --vhook_a kSampleSizeInBits kSampleSize
  --vhook_a bReset bResetDmaChannelAndFifo
  --vhook_a bRequestAcknowledge bNiDmaOutputRequestFromDma
  --vhook_a bOutputRequest bNiDmaOutputRequestToDma
  --vhook_a bFifoEmptyCount bEmptyCount
  DmaPortCommIfcOutputControllerx: entity work.DmaPortCommIfcOutputController (rtl)
    generic map (
      kStreamNumber     => kStreamNumber,    -- in  natural := 0
      kSampleSizeInBits => kSampleSize,      -- in  positive := 64
      kFifoCountWidth   => kFifoCountWidth,  -- in  natural
      kFxpType          => kFxpType)         -- in  boolean := false
    port map (
      aReset                => aReset,                      -- in  boolean
      bReset                => bResetDmaChannelAndFifo,     -- in  boolean
      BusClk                => BusClk,                      -- in  std_logic
      bRequestAcknowledge   => bNiDmaOutputRequestFromDma,  -- in  NiDmaOutputRequestFrom
      bOutputRequest        => bNiDmaOutputRequestToDma,    -- out NiDmaOutputRequestToDm
      bReadResponseReceived => bReadResponseReceived,       -- in  boolean
      bArbiterNormalReq     => bArbiterNormalReq,           -- out std_logic
      bArbiterEmergencyReq  => bArbiterEmergencyReq,        -- out std_logic
      bArbiterDone          => bArbiterDone,                -- out std_logic
      bArbiterGrant         => bArbiterGrant,               -- in  std_logic
      bMaxPktSize           => bMaxPktSize,                 -- in  NiDmaOutputByteCount_t
      bFifoEmptyCount       => bEmptyCount,                 -- in  unsigned(kFifoCountWid
      bNumWriteSpaces       => bNumWriteSpaces,             -- out NiDmaOutputByteCount_t
      bSatcrWriteStrobe     => bSatcrWriteStrobe,           -- out boolean
      bReqWriteSpaces       => bReqWriteSpaces,             -- out NiDmaOutputByteCount_t
      bDisable              => bDisable,                    -- in  boolean
      bDisabled             => bDisabled);                  -- out boolean



  --vhook_e DmaPortCommIfcRegisters
  --vhook_a kInputStream false
  --vhook_a kPeerToPeerStream false
  --vhook_a kMaxTransfer kOutputMaxTransfer
  --vhook_a bPeerAddress open
  --vhook_a bDisabled bDisabledStatusForHost
  --vhook_a bFifoOverflow false
  --vhook_a bStartChannelRequest bSetEnableIrq
  --vhook_a bFifoCount bHostReadableFullCount
  --vhook_a bClearFlushingIrq false
  --vhook_a bSatcrWriteEvent open
  --vhook_a bClearSatcr false
  --vhook_a bHostFlush open
  --vhook_a bFlushIrqStrobe false
  --vhook_a bSatcrUpdatesEnabled open
  --vhook_a bSetFlushingFailedStatus false
  --vhook_a bClearFlushingFailedStatus false
  --vhook_a bSetFlushingStatus false
  --vhook_a bClearFlushingStatus false
  --vhook_a bStreamError bOutStreamErrorStatus
  DmaPortCommIfcRegistersx: entity work.DmaPortCommIfcRegisters (behavior)
    generic map (
      kBaseOffset       => kBaseOffset,         -- in  natural := 16#50#
      kInputStream      => false,               -- in  boolean := false
      kPeerToPeerStream => false,               -- in  boolean := false
      kMaxTransfer      => kOutputMaxTransfer)  -- in  natural
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
      bStreamError               => bOutStreamErrorStatus,   -- in  boolean
      bMaxPktSize                => bMaxPktSize,             -- out unsigned(Log2(kMaxTra
      bSatcrWriteStrobe          => bSatcrWriteStrobe,       -- in  boolean
      bReqWriteSpaces            => bReqWriteSpaces,         -- in  unsigned(Log2(kMaxTra
      bFifoCount                 => bHostReadableFullCount,  -- in  unsigned
      bPeerAddress               => open,                    -- out NiDmaAddress_t
      bState                     => bState,                  -- in  StreamStateValue_t
      bLinked                    => bLinked,                 -- out boolean
      bSatcrUpdatesEnabled       => open,                    -- out boolean
      bIrq                       => bIrq);                   -- out IrqStatusToInterface_


  --vhook_e DmaPortCommIfcSinkStreamStateController
  --vhook_a bReset bResetDmaChannel
  --vhook_a bStopChannelRequest bStopChannelRequest
  --vhook_a bStreamError false
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
      bStreamError             => false,                     -- in  boolean
      bStateInDefaultClkDomain => bStateInDefaultClkDomain); -- in  StreamStateValue_t


end structure;
