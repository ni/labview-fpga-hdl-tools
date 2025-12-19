-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcInputController.vhd
-- Author: Florin Hurgoi
-- Original Project: LabVIEW FPGA
-- Date: 16 June 2011
--
-------------------------------------------------------------------------------
-- (c) 2007 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
-- This is the control logic for the input DMA stream circuit.  The components
-- of the DMA stream circuit are the FIFO, input data control, input request arbiter
-- and register block.
-- This piece's main responsibilities are:
--
-- (1) Monitoring the FIFO's full count and producing arbiter request signals
--     when appropriate.
-- (2) Sending the request packets to the DMA controller.
-- (3) Timing how long data has been waiting in the FIFO and asserting an
--     emergency flag when the data times out.
-- (4) Decrementing the SATCR whenever a data word is sent.
--
-- This controller also supports data packing for the FIFO.
--
-- Harmish: 08/04/2014 : Added support for Flush method
-- Based on the FlushReq input from the FIFO interface this module creates the emergency request to the arbiter.
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

  -- This package contains the definitions for the interface between the NI DMA IP and
  -- the application specific logic.
  use work.PkgNiDma.all;

  -- This package contains the definitions for the LabVIEW FPGA register
  -- framework signals
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;

  -- This package contains some useful functions for determining the width of
  -- the empty count from the data packing FIFO.
  use work.PkgDmaPortDataPackingFifo.all;

  use work.PkgCommIntConfiguration.all;

entity DmaPortCommIfcInputController is
    generic(

      -- The stream number associated with this DMA stream
      kStreamNumber : natural := 0;

      -- The width of the user data element being popped from the FIFO
      kSampleSizeInBits : positive := 64;

      -- The width of the FIFO counts.
      kFifoCountWidth : natural;

      -- The number of bus clocks to wait before asserting the emergency
      -- flag if the FIFO is less than half full
      kEvictionTimeout : natural := 128;

      -- kPeerToPeerStream : This indicates whether the input stream is a normal
      --                     host input stream or a peer-to-peer source stream.
      kPeerToPeerStream    : boolean := false
    );
    port(

      -- aReset             : This is the asynchronous reset to the state
      --                      machine registers.
      aReset                : in boolean;

      -- bReset             : This is a synchronous reset to the state
      --                      machine.  This signal comes from the PCI-e
      --                      reset signal.
      bReset                : in boolean;

      -- BusClk             : This is the clock
      BusClk                : in std_logic;

      -------------------------------------------------------------------------
      -- NI DMA IP interface
      -------------------------------------------------------------------------

      -- bInputRequest       : The DMA IN send request access to the DMA channel.
      --                       This bus carry the information details about
      --                       the requested transaction.
      bInputRequest          : out NiDmaInputRequestToDma_t;

      -- bAcknowledgeRequest : The Acknowledge from the NI DMA IP indicating that
      --                       the request was received.
      bRequestAcknowledge    : in NiDmaInputRequestFromDma_t;

      --bInputStatusReceived : This signal indicates that a status response for
      --                       a sent request was received on the status interface,
      --                       indicating that the DMA controller has processed
      --                       one request previously sent.
      bInputStatusReceived   : in boolean;
      -------------------------------------------------------------------------
      -- Arbiter interface
      -------------------------------------------------------------------------

      -- bArbiterNormalReq  : This is the request line to the arbiter for
      --                      normal priority.  Normal priority occurs when
      --                      the FIFO is at least quarter full.  This is a
      --                      registered output.
      bArbiterNormalReq     : out std_logic;

      -- bArbiterEmergencyReq: This is the request line to the arbiter for
      --                       emergency priority.  Emergency priority occurs
      --                       when the FIFO is at least half full.  This is
      --                       a registered output.
      bArbiterEmergencyReq  : out std_logic;

      -- bArbiterDone       : This is the line to the arbiter indicating that
      --                      the transmission is complete.  This asserts on
      --                      the same clock cycle as the last word of the
      --                      packet is being sent.  
      bArbiterDone          : out std_logic;

      -- bArbiterGrant      : This is the line from the arbiter indicating that
      --                      a request for Dma access has been granted.
      --                      This signal is asserted while the stream has
      --                      arbiter access.
      bArbiterGrant         : in std_logic;

      -------------------------------------------------------------------------
      -- SATCR signals
      -------------------------------------------------------------------------

      -- bMaxPktSize : This is the maximum packet size that can be sent
      --               according to the SATCR value and the Dma Port max packet
      --               size.  The minimum of these two values is determined in
      --               the register interface component and is a registered
      --               input to this component.
      bMaxPktSize    : in NiDmaInputByteCount_t;

      -------------------------------------------------------------------------
      -- FIFO signals
      -------------------------------------------------------------------------

      -- bWriteDetected     : Indicates whenever a data is pushed in the FIFO.
      --                      This signal is used to reset the eviction timer.
      bWriteDetected        : in boolean;

      -- bFIFOFullCount     : This is the count of the number of samples
      --                      available in the FIFO.
      bFifoFullCount        : in unsigned(kFifoCountWidth-1 downto 0);

      -- bNumReadSamples    : This signal represents the number of samples for which
      --                      a data request was sent; This will update the FIFO full
      --                      pointer with the number of samples already requested.
      bNumReadSamples       : out NiDmaInputByteCount_t;

      -- bByteLanePtr       : This signal points to the location of the read
      --                      pointer within a single FIFO entry. This is
      --                      useful for cases where the input and output
      --                      ports are not symmetric. So for any data size
      --                      other than 64-bits, this becomes useful as it
      --                      represents the true location of the read pointer.
      bByteLanePtr          : in NiDmaByteLane_t;

      -- bRsrvReadSpaces    : This is a strobe that reserves bNumReadSamples in the FIFO
      --                      for data that was already sent a requested.
      bRsrvReadSpaces       : out boolean;
      bFlushReq             : in boolean; 

      -- bResetFifo         : This signal is true while the FIFO associated
      --                      this DMA channel should reset.  It is held until
      --                      the bResetDone signal is true, indicating that
      --                      the FIFO has finished reseting.
      bResetFifo            : out boolean;

      -- bResetDone         : This signal is strobed whenever the FIFO reset
      --                      has complete.
      bResetDone            : in boolean;

      -------------------------------------------------------------------------
      -- Register flags
      -------------------------------------------------------------------------

      -- bSatcrWriteStrobe  : This flag indicates when the reserved SATCR
      --                      should be decremented by the value specified in
      --                      ReqWriteSpaces.
      bSatcrWriteStrobe     : out boolean;

      -- bReqWriteSpaces    : This value is the number of bytes that are
      --                      to be subtracted from the reserved SATCR.
      bReqWriteSpaces       : out NiDmaInputByteCount_t;

      -- bDisable           : This is a flag from the DMA control register
      --                      indicating that a disable is requested for this
      --                      DMA stream.
      bDisable              : in boolean;

      -- bDisabled          : This is the flag to the DMA status register
      --                      indicating when the circuit is actually disabled.
      bDisabled             : out boolean;

      -- bClearSatcr        : This is a one clock cycle strobe indicating that
      --                      the SATCR should clear.
      bClearSatcr           : out boolean

    );
end DmaPortCommIfcInputController;

architecture rtl of DmaPortCommIfcInputController is

  -----------------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------------

  -- The number of bits to shift to convert from units of samples to bytes.
  constant kSampleShift : natural := Log2(kSampleSizeInBits)-3;

  constant kChannel : NiDmaGeneralChannel_t := 
    to_unsigned(kStreamNumber, bInputRequest.Channel'length);

  -- The stream packet header with the done bit set.
  constant kNiDmaInputRequestToDmaDone : NiDmaInputRequestToDma_t := (
    Request => true,
    Space => kNiDmaSpaceStream,
    Channel => kChannel,
    Address => (others => '0'),
    Baggage => (others => '0'),
    ByteSwap => (others => '0'),
    ByteLane => (others => '0'),
    ByteCount => (others => '0'),
    Done => true,
    EndOfRecord => false
  );
  -----------------------------------------------------------------------------
  -- Registers
  -----------------------------------------------------------------------------

  -- The input request is registered to reduce combinatorial paths to NI DMA IP.
  signal bInputRequestLcl : NiDmaInputRequestToDma_t;
  signal bSatcrWriteStrobeLcl : boolean;
  signal bRsrvReadSpacesLcl : boolean;
  signal bArbiterDoneNx : std_logic;
  signal bArbiterDoneLcl : std_logic;

  -----------------------------------------------------------------------------
  -- Combinatorial signals
  -----------------------------------------------------------------------------
  signal bArbiterNormalReqNx, bArbiterEmergencyReqNx  : std_logic;
  signal bDoneArbiterRequest : boolean;
  signal bSatcrWriteStrobeNx : boolean;
  signal bSatcrWriteStrobeNxNx : boolean;
  signal bResetFifoNx : boolean;
  signal bInputRequestNx : NiDmaInputRequestToDma_t;
  signal bPacketLength, bPacketLengthNx : NiDmaInputByteCount_t;
  signal bAllInputStatusReceived : boolean;
  signal bInputRequestSent : boolean;
  signal bPacketLengthLoad : boolean;
  signal bRsrvReadSpacesNx : boolean;
  signal bArbiterGrantQual : std_logic;

  -----------------------------------------------------------------------------
  -- State machine signals
  -----------------------------------------------------------------------------
  type DmaInputState_t is (

    -- DisableRequest:    The state machine is moving from enabled to disabled,
    --                    and arbiter access is requested so that the done
    --                    packet can be sent to the NI DMA IP.
    DisableRequest,


    -- SendDoneRequest:   A Request stream packet is sent to the NI DMA IP.  The
    --                    packet has no data payload, but the done bit is sent,
    --                    indicating that no more stream data will be sent.
    SendDoneRequest,

    -- WaitForData:       Wait for data corresponding to the previous requests
    --                    to be transferred to the Host. This state will ensure
    --                    that no data will lost during FifoClear state.
    WaitForData,


    -- Disabled:          This state indicates that the stream is disabled.
    --                    This state will hold while the disable request line
    --                    is asserted.  When it is de-asserted, we move to the
    --                    Idle state.
    Disabled,


    -- Idle:              The idle state waits until an arbiter request flag
    --                    asserts.
    Idle,


    -- FifoClear:         This state resets the DMA FIFO and holds until the
    --                    FIFO is successfully reset. It then moves to the
    --                    Idle state.
    FifoClear,


    -- WaitForArbiter:    The appropriate request flags are asserted, and the
    --                    state machine holds until the grant is asserted.
    --                    When grant is asserted, enable the latch of packet length
    --                    count and move to packet setup state.
    WaitForArbiter,


    -- PacketSetup:       The packet length count is latched during this state
    --                    and the request packet is built. We also enable the SATCR
    --                    update during this state.
    PacketSetup,


    -- SendPacketRequest: Send the data request and wait until it is accepted.
    SendPacketRequest

  );

  signal bDmaInputStateNx, bDmaInputState : DmaInputState_t := Disabled;
  signal bFullCountNotYetUpdated : boolean := false;
  signal bFifoFullCountReg : unsigned(kFifoCountWidth-1 downto 0);

  
begin

  -- Registers used by the state machine.
  StateRegs: process(BusClk, aReset)
  begin

    if(aReset) then

      -- We reset to the disabled state.
      bDmaInputState <= Disabled;
      bSatcrWriteStrobeNx <= false;
      bSatcrWriteStrobeLcl <= false;
      bResetFifo <= false;
      bInputRequestLcl <= kNiDmaInputRequestToDmaZero;
      bRsrvReadSpacesLcl <= false;
      bArbiterDoneLcl <= '0';
      bFullCountNotYetUpdated <= false;
      bFifoFullCountReg <= (others => '0');

    elsif(rising_edge(BusClk)) then

      -- If bReset occurs, then it is safe to return to the disabled state,
      -- even if we are in the middle of a transmission, because the
      -- bus itself is being reset as well.

      if(bReset) then

        bDmaInputState <= Disabled;
        bSatcrWriteStrobeNx <= false;
        bSatcrWriteStrobeLcl <= false;
        bResetFifo <= false;
        bInputRequestLcl <= kNiDmaInputRequestToDmaZero;
        bRsrvReadSpacesLcl <= false;
        bArbiterDoneLcl <= '0';
        bFullCountNotYetUpdated <= false;
        bFifoFullCountReg <= (others => '0');

      else

        bDmaInputState <= bDmaInputStateNx;
        bSatcrWriteStrobeNx <= bSatcrWriteStrobeNxNx;
        bSatcrWriteStrobeLcl <= bSatcrWriteStrobeNx;
        bResetFifo <= bResetFifoNx;
        bInputRequestLcl <= bInputRequestNx;
        bRsrvReadSpacesLcl <= bRsrvReadSpacesNx;       
        bArbiterDoneLcl <= bArbiterDoneNx;
        bFullCountNotYetUpdated <= bRsrvReadSpacesLcl;
        bFifoFullCountReg <= bFifoFullCount;

      end if;

    end if;

  end process StateRegs;

  bInputRequest <= bInputRequestLcl;
  bSatcrWriteStrobe <= bSatcrWriteStrobeLcl;
  bRsrvReadSpaces <= bRsrvReadSpacesLcl;
  bArbiterDone <= bArbiterDoneLcl;
  

  -- The ArbiterDone signal is a registered output. Hence, it takes one cycle for the
  -- Arbiter to deassert the Grant after ArbiterDone asserts. The signal below is used
  -- to ignore the Grant during that cycle.
  bArbiterGrantQual <= bArbiterGrant and not bArbiterDoneLcl;

  -- The signals to update SATCR and the FIFO with the amount of data sent
  -- can be get from requested ByteCount to the NiDmaIp.
  bReqWriteSpaces <= bInputRequestLcl.ByteCount;
  bNumReadSamples <= shift_right(bInputRequestLcl.ByteCount, kSampleShift);


  --!STATE MACHINE STARTUP!
  --This state machine resets to the Disabled state and only moves out of that
  --state if the disable input goes false.  The disable input comes from the
  --Stream State Controller component and can only go false following a register
  --write to the DMA channel.  The disable input resets to true and a register write
  --cannot occur immediately following reset.  This is assuming that aReset is
  --used and is tied to the bus reset.

  -- The combinatorial state machine logic
  DmaNextStateLogic: process(bDmaInputState, bArbiterNormalReqNx, bInputRequestLcl,
    bArbiterEmergencyReqNx, bByteLanePtr, bPacketLength, bArbiterGrantQual, bDisable,
    bResetDone, bRequestAcknowledge, bAllInputStatusReceived)
  begin

    -- Set initial signal values
    bDmaInputStateNx <= bDmaInputState;

    bArbiterDoneNx <= '0';
    bDoneArbiterRequest <= false;
    bDisabled <= false;
    bSatcrWriteStrobeNxNx <= false;
    bResetFifoNx <= false;
    bClearSatcr <= false;
    bInputRequestNx <= kNiDmaInputRequestToDmaZero;
    bInputRequestSent <= false;
    bPacketLengthLoad <= false;
    bRsrvReadSpacesNx <= false;

    case bDmaInputState is

      -------------------------------------------------------------------------
      -- DisableRequest:  The state machine is moving from enabled to disabled,
      --                  and arbiter access is requested so that the done
      --                  packet can be sent to the NI DMA IP.
      -------------------------------------------------------------------------
      when DisableRequest =>

        bDoneArbiterRequest <= true;

        if bArbiterGrantQual = '1' then
          bDmaInputStateNx <= SendDoneRequest;
          bInputRequestNx <= kNiDmaInputRequestToDmaDone;
        end if;


      -------------------------------------------------------------------------
      -- SendDoneRequest:   A request packet is sent to the NI DMA IP. 
      --                    The Done bit is sent,indicating that no more stream
      --                    data will be requested.
      -------------------------------------------------------------------------
      when SendDoneRequest =>

        if(bRequestAcknowledge.Acknowledge) then

          bDmaInputStateNx <= WaitForData;

          bArbiterDoneNx <= '1';
          bInputRequestSent <= true;
        else
          -- Keep the Done request word on the lines until it is accepted.
          bInputRequestNx <= kNiDmaInputRequestToDmaDone;

        end if;


      ------------------------------------------------------------------------
      -- WaitForData  : In this state we are waiting the all status reports
      --                corresponding to the issued requests to be received
      --                before to clear the FIFO. The signal bAllInputStatusReceived
      --                indicates when all the status reports was received.
      ------------------------------------------------------------------------
      when WaitForData =>
      
        if bAllInputStatusReceived then

          if not kPeerToPeerStream then
            bDmaInputStateNx <= FifoClear;
            bResetFifoNx <= true;
          else
            bDmaInputStateNx <= Disabled;
          end if;

        end if;


      -------------------------------------------------------------------------
      -- Disabled:        This state indicates that the stream is disabled.
      --                  This state will hold while the disable request line
      --                  is asserted.  When it is de-asserted, we move to the
      --                  FifoClear state.
      -------------------------------------------------------------------------
      when Disabled =>

        bDisabled <= true;

        -- Move out of the disabled state when the disable flag becomes false.
        if not bDisable then

          -- Reset the FIFO on stream startup if the stream is a peer-to-peer stream.
          -- For a normal host stream, the FIFO should not clear on startup, so
          -- transition to the Idle state.
          if kPeerToPeerStream then

            bDmaInputStateNx <= FifoClear;

            -- Reset the FIFO when we move from Disabled to Idle.
            bResetFifoNx <= true;

            -- Clear the SATCR when we start to enable the stream.  For a peer to peer
            -- stream, the sink may have sent some SATCR updates after we last disabled,
            -- and we want to clear out any previous SATCR values.  This should be safe
            -- to do when we enable, since the driver enables the source before the
            -- sink and waits until the source reports that it is no longer disabled.
            bClearSatcr <= true;

          else

            bDmaInputStateNx <= Idle;

          end if;

        end if;


      -------------------------------------------------------------------------
      -- FifoClear:       This state resets the DMA FIFO and holds until the
      --                  FIFO is successfully reset.  It then moves to the
      --                  Idle state.
      -------------------------------------------------------------------------
      when FifoClear =>

        if kPeerToPeerStream then
          -- For Peer-To-Peer streams the stream is still disabled while the FIFO
          -- is clearing.
          bDisabled <= true;
        end if;

        bResetFifoNx <= true;

        if bResetDone then
          bResetFifoNx <= false;

          -- Peer to peer streams reset the FIFO when enabling, while
          -- traditional DMA streams reset the FIFO when disabling.
          if kPeerToPeerStream then
            bDmaInputStateNx <= Idle;
          else
            bDmaInputStateNx <= Disabled;
          end if;

        end if;


      -------------------------------------------------------------------------
      -- Idle:              The idle state waits until an arbiter request flag
      --                    asserts and we are not disabled.
      -------------------------------------------------------------------------
      when Idle =>

        if bDisable then
          bDoneArbiterRequest <= true;
          bDmaInputStateNx <= DisableRequest;
        elsif bArbiterNormalReqNx = '1' or bArbiterEmergencyReqNx = '1' then
          bDmaInputStateNx <= WaitForArbiter;
        end if;

        -- If we get the grant in this state, we can just assert done so that
        -- we don't deadlock the arbiter.  If we're going to disable, we don't
        -- need to do this, because we're going to request arbiter access in
        -- the next state anyway.
        if bArbiterGrantQual = '1' and not bDisable then
          bArbiterDoneNx <= '1';
        end if;


      -------------------------------------------------------------------------
      -- WaitForArbiter:    The appropriate request flags are asserted, and the
      --                    state machine holds until the grant is asserted.
      --                    When grant is asserted, latch the packet length
      --                    information, generate the strobe that will reserve
      --                    FIFO read spaces and move to the next state 
      --                    to build the request packet.
      -------------------------------------------------------------------------
      when WaitForArbiter =>

        -- Move to the disable request state if the disable request line is true.
        if bDisable then
          bDmaInputStateNx <= DisableRequest;
          bDoneArbiterRequest <= true;

        -- Move to the ReturnToIdle state if the request flags go false.
        elsif bArbiterNormalReqNx = '0' and bArbiterEmergencyReqNx = '0' then
          bDmaInputStateNx <= Idle;

        -- When we are granted access to Input Request Interface, enable loading
        -- the packet length and move to the PacketSetup state.
        elsif(bArbiterGrantQual = '1') then

          bPacketLengthLoad <= true;
          
          -- Enable updates to SATCR.
          bSatcrWriteStrobeNxNx <= true;

          bDmaInputStateNx <= PacketSetup;
        end if;

      -------------------------------------------------------------------------------
      -- PacketSetup
      --
      -------------------------------------------------------------------------------
      when PacketSetup =>

        -- Reserve spaces in the FIFO.
        bRsrvReadSpacesNx <= true;

        -- The Request Packet is build.
        bInputRequestNx.Request <= true;
        bInputRequestNx.Space <= kNiDmaSpaceStream;
        bInputRequestNx.Channel <= kChannel;
        bInputRequestNx.Address <= (others => '0');
        bInputRequestNx.Baggage <= (others => '0');
        bInputRequestNx.ByteSwap <= (others => '0');
        bInputRequestNx.ByteLane <= bByteLanePtr;
        bInputRequestNx.ByteCount <= bPacketLength;
        bInputRequestNx.Done <= false;
        bInputRequestNx.EndOfRecord <= false;

        bDmaInputStateNx <= SendPacketRequest;

      --------------------------------------------------------------------------
      -- SendPacketRequest:     In this state the request packet is put together.
      --                        The bRsrvReadSpaces will be asserted for one clock cycle
      --                        so that the FIFO will know it needs to update the
      --                        FifoFullCount by subtracting the bNumReadSpace that
      --                        represent the number of FIFO locations that the request
      --                        ask to be transfered. This state will be mantained until
      --                        the request acknowledge will be received.
      --                        The state machine will go to Idle if there are no other
      --                        arbiter requests or to WaitForArbiter if the Normal or
      --                        Emergency requests are asserted.
      --------------------------------------------------------------------------
      when SendPacketRequest =>

        if bRequestAcknowledge.Acknowledge then
          bArbiterDoneNx <= '1';
          bDmaInputStateNx <= Idle;
          bInputRequestSent <= true;

        else
          bInputRequestNx <= bInputRequestLcl;

        end if;

      when Others =>

        bDmaInputStateNx <= Idle;

    end case;

  end process DmaNextStateLogic;


  -----------------------------------------------------------------------------
  -- GetPacketLength
  --
  -- This combinatorial logic determines the maximum size packet that can be
  -- sent at any given time.  This is the min of the
  -- (1) SATCR value
  -- (2) FIFO full count
  -- (3) Max packet size
  -----------------------------------------------------------------------------
  GetPacketLength: process(bFifoFullCountReg, bMaxPktSize)
  begin

    if bFifoFullCountReg >= bMaxPktSize(bMaxPktSize'left downto kSampleShift) then

      -- Make sure to zero out the non sample aligned part of the packet size.
      if kSampleShift > 0 then
        bPacketLengthNx <= bMaxPktSize(bMaxPktSize'left downto kSampleShift) &
          unsigned(Zeros(kSampleShift));
      else
        -- Some tools complain when the Zeros function are used with a zero
        -- argument.
        bPacketLengthNx <= bMaxPktSize;
      end if;

    else
      bPacketLengthNx <= shift_left(resize(bFifoFullCountReg,
        bPacketLengthNx'length), kSampleShift);
    end if;

  end process GetPacketLength;


  -- Register the packet length signal to reduce timing paths.
  PacketLengthReg: process(aReset, BusClk)
  begin
  
    if aReset then
      bPacketLength <= (others=>'0');
    elsif rising_edge(BusClk) then
      if bPacketLengthLoad then
        bPacketLength <= bPacketLengthNx;
      end if;
    end if;
    
  end process PacketLengthReg;


  -----------------------------------------------------------------------------
  -- HandleArbiterRequests
  --
  -- This block is responsible for the combinatorial logic that produces the
  -- arbiter request signals.  Also, part of the logic driving these signals
  -- relies on an eviction timer to prevent stream starvation.
  -----------------------------------------------------------------------------
  HandleArbiterRequests: block is

    signal bFifoHalfFull, bFifoQuarterFull : boolean;
    signal bFullPacketAvailable, bFullPacketAvailableLatched : boolean;
    signal bEnableRequest : boolean;

    signal bEvictionTimeoutFlag : boolean;
    signal bEvictionCounter : unsigned(Log2(kEvictionTimeout) downto 0);

  begin

    ---------------------------------------------------------------------------
    --
    -- Normal request:     True when (the FIFO has at least enough data to send
    --                     a full packet OR the FIFO is more than one quarter
    --                     full) AND SATCR is greater than zero.  A full
    --                     packet is the minimum of the max packet size and the
    --                     SATCR value.
    --
    -- Emergency request:  True when
    --
    --                     1.  The FIFO is at least half full and the
    --                         SATCR is non-zero
    --
    --                     OR
    --
    --                     2.  The eviction timeout expires.
    --
    --                     OR
    --
    --                     3.  We are disabling and need to send the
    --                         done indicator to the NI DMA IP
        --                                         
        --                     OR
        --
        --                     4. When FlushRequest comes in (Added by Harmish: 08/04/2014)
        --                                                * The condition to check the FifoFullcount is added because I saw a deadlock case when we request 0 byte packet
        --                                                to the DMA. e.g. There are 100 bytes into the FIFO and the Flush request comes in. Then based on below logic
        --                                            request to the arbiter will be made and then controller will request 100 byte packet to the DMA. bFlushReq remains
        --                                                asserted even after the request is accepted by DMA(bFlushReq desserts only when DMA reads out the 100 bytes and that
        --                                                is going to take around 100+X cycles). During this time controller will make other request to the arbiter and 
        --                                                then will request 0 byte packets to DMA. To avoid this we check if FullCount > 0 i.e. if we have 0 bytes to send then don't
        --                                                make request. This works because FullCount is updated as soon as request is accepted by DMA and doesn't wait till all
        --                                                elements are readout from FIFO.
        --                                                * The details of this design can be found in
        --                                                \\labview\docs\web\docs\proposals\2015\FPGA\Low Latency DMA - FlushFIFO\Flush_feature_design details.doc
    --
    ---------------------------------------------------------------------------
    bArbiterNormalReqNx <= to_stdlogic((bFullPacketAvailable or
      bFifoQuarterFull) and shift_right(bMaxPktSize, kSampleShift) /= 0 and
      bEnableRequest);
        bArbiterEmergencyReqNx <= to_stdlogic(((bFifoHalfFull or
      bEvictionTimeoutFlag or (bFlushReq and (bFifoFullCount > 0))) and shift_right(bMaxPktSize,kSampleShift) /= 0 and
      bEnableRequest) or (bDoneArbiterRequest and bArbiterGrantQual = '0')); 

    -- Disable requests while there is a disable request or while the state
    -- machine is starting and the FIFO is not yet clear or while FullCount is invalid
    bEnableRequest <= (not bDisable) and bDmaInputState /= Disabled and
                      bDmaInputState /= FifoClear and (not bFullCountNotYetUpdated);

    -- Note that we qualify the DoneArbiterRequest with the Grant signal being
    -- false.  If we did not do this, we could issue a request in the same clk
    -- cycle that we issue the done for that request.  If we were issued
    -- another grant for that request, we would never assert done for that
    -- grant, and the arbiter would deadlock.
    --
    -- Alternatively, we could check if grant is true while we are in the
    -- disabled state and assert done if it is.  However, this would chew up
    -- the arbiter for extra clock cycles.

    RegisterArbiterReqs: process(aReset, BusClk)
    begin
      if aReset then
        bArbiterNormalReq <= '0';
        bArbiterEmergencyReq <= '0';
      elsif rising_edge(BusClk) then
        if bReset then
          bArbiterNormalReq <= '0';
          bArbiterEmergencyReq <= '0';
        else
          bArbiterNormalReq <= bArbiterNormalReqNx;
          bArbiterEmergencyReq <= bArbiterEmergencyReqNx;
        end if;
      end if;
    end process RegisterArbiterReqs;

    -- Since the FIFO depth is always a power of 2, we can simply use the top
    -- 2 bits of the full count to determine half and quarter fullness.
    bFifoQuarterFull <= (bFifoFullCountReg(bFifoFullCountReg'left-1) = '1') or
                         (bFifoFullCountReg(bFifoFullCountReg'left) = '1');
    bFifoHalfFull <= bFifoFullCountReg(bFifoFullCountReg'left) = '1';

    -- A full packet is defined as the floor of the SATCR value and the bus limited
    -- max packet size.
    bFullPacketAvailable <= ((bFifoFullCountReg >= 
      shift_right(bMaxPktSize, kSampleShift)) and
      (shift_right(bMaxPktSize, kSampleShift) /= 0)) or bFullPacketAvailableLatched;

    -- In the following comment, I = Ioan Catuna
    -- Just to give a little bit of background on why I originally added this latch:
    -- In 2013 April-May, I saw a weird hardware error on Zynq (CAR 397690) in which
    --   a request for a non-existing channel was generated, and that locked
    --   the Zynq itself. I traced the problem to the DmaPort request arbiter,
    --   which would re-arbitrate after a granted request from a stream was withdrawn,
    --   without waiting for the Done bit to be set by the channel which withdrew
    --   its request.
    -- The arbiter interface protocol allows for requests to be withdrawn,
    --   but the circuit which does that still needs to look at the Grant signal
    --   in the next clock cycle, in case its Request was granted just as it was
    --   withdrawing it. If that happens, that circuit needs to send the Done bit
    --   to the arbiter, even if it did not transfer any data. In the corner case
    --   I saw last year, a request was generated & granted, but the stream circuit
    --   acted with duplicity: on one hand, it withdrew its request & not generate
    --   the Done bit, on the other hand its state machine saw the Grant signal
    --   and continued to send its request to the DMA Controller.
    -- The arbiter is never allowed to rearbitrate without the Done bit asserted
    --   for the last granted request.
    -- I fixed the arbiter component to respect the above protocol, but we still had
    --   the output stream controller's duplicity. After discussing with Glen Sescila,
    --   we decided that once the request is generated, the stream controller should not
    --   withdraw it. Even considering the request had a small byte count (e.g. 1 byte),
    --   we considered that the overall performance of the circuit would not suffer.
    -- As the withdrawn request was originally generated due to bFullPacketAvailable
    --   being asserted, and it was withdrawn due to SW writing the SATCR, we decided to
    --   latch bFullPacketAvailable and only clear it when bArbiterRequestEnable signal
    --   deasserted i.e. when the stream controller FSM saw the arbiter Grant signal.
    LatchFullPacketAvailable: process(aReset, BusClk)
    begin
      if aReset then
        bFullPacketAvailableLatched <= false;
      elsif rising_edge(BusClk) then
        bFullPacketAvailableLatched <= bFullPacketAvailable and bEnableRequest;
      end if;
    end process LatchFullPacketAvailable;
    
    -- The eviction timer is true while the eviction counter is greater than or
    -- equal to the timeout threshold value.  The eviction timer will stop counting
    -- when it reaches the timeout value, so the flag will hold true until the timeout
    -- counter is reset.
    bEvictionTimeoutFlag <= bEvictionCounter >= kEvictionTimeout;


    ---------------------------------------------------------------------------
    -- Timeout Counter
    --
    -- The timeout counter should perform reset, holding, and incrementing, in
    -- that order of priority, on the following events:
    --
    -- (1) Reset     : Reset on aReset or whenever an element is written in the FIFO
    --                 or we are disabled.  Also reset whenever we send a request.
    -- (2) Hold      : Hold when the timeout threshold value has been reached
    -- (3) Increment : Increment on clock cycles when the FIFO is not empty
    ---------------------------------------------------------------------------
    TimeoutCounter: process(BusClk, aReset)
    begin
      if aReset then

        bEvictionCounter <= to_unsigned(0, bEvictionCounter'length);

      elsif rising_edge(BusClk) then

        if bReset then

          bEvictionCounter <= to_unsigned(0, bEvictionCounter'length);

        -- (1) Reset whenever an element is written to the  FIFO and the evection
        --     timeout flag is not asserted.  We don't have to reset the eviction timer
        --     once the bEvictionTimeoutFlag is asserted because an emergency request
        --     could be lost if new data is written to the FIFO and we would reset
        --     the eviction timer before the arbiter to grant the request.
        --     We also reset the eviction counter whenever we send a request
        --     or if we are disabled.

        -- It was considered clearing the eviction counter with the following term:
        -- "(not bEvictionTimeoutFlag) and (bFullPacketAvailable or bFifoQuarterFull)
        -- and shift_right(bMaxPktSize, kSampleShift) /= 0".  After we reach a
        -- full packet or a quarter fullness the eviction timer could change our
        -- normal request to an emergency request without writing any new data to
        -- the FIFO.  It is possible for the user to design VIs where other Input
        -- streams are perpetually in an emergency request state.  For example,
        -- one stream could write data to its FIFO as fast as possible so that its FIFO
        -- is always over half full and asserting an emergency request.  Other streams
        -- could completely stop with data in their FIFOs because they have reached
        -- the end of their operation.  With this proposed change the latter streams
        -- will stall indefinitly.  With the existing design those streams would
        -- eventually timeout and promote their request to an emergency.
        elsif (not bEvictionTimeoutFlag and bWriteDetected) or bDisable
          or bSatcrWriteStrobeLcl then

          bEvictionCounter <= to_unsigned(0, bEvictionCounter'length);

        -- (2) Hold when timeout threshold value has been reached
        -- (3) Increment on clock cycles when the FIFO is not empty
        elsif bFifoFullCountReg /= 0 and not bEvictionTimeoutFlag then

          bEvictionCounter <= bEvictionCounter + 1;

        end if;
      end if;
    end process TimeoutCounter;

  end block HandleArbiterRequests;


  -----------------------------------------------------------------------------
  -- Track the number of outstanding input requests.  This is used to determine
  -- when the stream can safely disable, since the stream should not disable
  -- until responses to all write requests have been received.
  -----------------------------------------------------------------------------
  OutstandingReadCounter: block is

    -- The worst case number of outstanding input requests is the number of
    -- samples in the FIFO.
    signal bInputStatusCount : unsigned(bFifoFullCountReg'range);

  begin

    InputStatusCount: process(aReset, BusClk)
    begin
      if aReset then
        bInputStatusCount <= (others=>'0');
      elsif rising_edge(BusClk) then

        -- Increment the status count whenever a input requested is sent and decrement it
        -- whenever a input status is received.
        if bReset then
          bInputStatusCount <= (others=>'0');
        elsif bInputRequestSent and not bInputStatusReceived then
          bInputStatusCount <= bInputStatusCount + 1;
        elsif bInputStatusReceived and not bInputRequestSent then
          bInputStatusCount <= bInputStatusCount - 1;
        end if;

      end if;
    end process InputStatusCount;

    -- All outstanding reads have been received when the read count is zero.
    bAllInputStatusReceived <= bInputStatusCount = 0;

  end block OutstandingReadCounter;

end architecture rtl;
