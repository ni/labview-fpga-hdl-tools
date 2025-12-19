-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcOutputController.vhd
-- Author: Florin Hugoi
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
--   This component implements a state machine that controls read request
--  sent for a DMA output stream.
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

  -- This package contains utilities to determine FIFO count widths
  use work.PkgDmaPortDataPackingFifo.all;

  use work.PkgNiDma.all;

  use work.PkgCommIntConfiguration.all;

entity DmaPortCommIfcOutputController is
    generic(

      -- The stream number associated with this DMA stream
      kStreamNumber        : natural := 0;

      -- The width of the user data element being pushed to the FIFO
      kSampleSizeInBits     : positive := 64;

      -- The width of the FIFO counts.
      kFifoCountWidth      : natural;

      -- This boolean indicates whether the data type is a FXP type.
      kFxpType             : boolean  := false

    );
    port(

      -- aReset             : This is the asynchronous reset to the state
      --                      machine registers.
      aReset                : in boolean;

      -- bReset             : This is a synchronous reset to the state
      --                      machine.
      bReset                : in boolean;

      -- BusClk             : This is the Rx clock (from the perspective of
      --                      the host) used by IO Port 2.
      BusClk                : in std_logic;

      -------------------------------------------------------------------------
      -- Dma Port interface
      -------------------------------------------------------------------------

      -- bRequestAcknowledge: The Acknowledge from DMA controller indicating that
      --                      the request was received by the DMA controller.
      bRequestAcknowledge   : in NiDmaOutputRequestFromDma_t;

      -- bOutputRequest     : The DMA output send request access to the DMA channel.
      --                      This bus carry the information details about
      --                      the requested transaction.
      bOutputRequest        : out NiDmaOutputRequestToDma_t;

      -- bReadResponseReceived : It is a strobe indicating that data corresponding
      --                         to an issued request was received.
      bReadResponseReceived : in boolean;

      -------------------------------------------------------------------------
      -- Arbiter interface
      -------------------------------------------------------------------------

      -- bArbiterNormalReq    : This is the request line to the arbiter for
      --                        normal priority.  Normal priority occurs when
      --                        the FIFO is at least quarter empty.
      bArbiterNormalReq       : out std_logic;

      -- bArbiterEmergencyReq : This is the request line to the arbiter for
      --                        emergency priority.  Emergency priority occurs
      --                        when the FIFO is at least half empty.
      bArbiterEmergencyReq    : out std_logic;

      -- bArbiterDone         : This is the line to the arbiter indicating that
      --                        the transmission is complete.  This asserts one
      --                        clock cycle after the last word of the
      --                        packet is being sent.
      bArbiterDone            : out std_logic;

      -- bArbiterGrant        : This is the line from the arbiter indicating that
      --                        a request for IO Port 2 access has been granted.
      bArbiterGrant           : in std_logic;

      -------------------------------------------------------------------------
      -- SATCR signals
      -------------------------------------------------------------------------

      -- bMaxPktSize : This is the maximum packet size that can be requested
      --               according to the SATCR value and the CHInCh max packet
      --               size.  The minimum of these two values is determined in
      --               the register interface component and is a registered
      --               input to this component.
      bMaxPktSize    : in NiDmaOutputByteCount_t;

      -------------------------------------------------------------------------
      -- FIFO signals
      -------------------------------------------------------------------------

      -- bFIFOEmptyCount    : This is the count of the number of empty spaces
      --                      in the FIFO.
      bFifoEmptyCount       : in unsigned(kFifoCountWidth-1 downto 0);

      -- bNumWriteSpaces    : This signal represents the number of samples for which
      --                      a data request was sent;
      bNumWriteSpaces       : out NiDmaOutputByteCount_t;

      -- bSatcrWriteStrobe  : This is the signal to strobe in the number of
      --                      spaces reserved in the FIFO.
      bSatcrWriteStrobe     : out boolean;

      -- bReqWriteSpaces    : This is the number of reserved bytes to be
      --                      subtracted from SATCR register when
      --                      bSatcrWriteStrobe is strobed.
      bReqWriteSpaces       : out NiDmaOutputByteCount_t;

      -------------------------------------------------------------------------
      -- Register flags
      -------------------------------------------------------------------------

      -- bDisable              : This is a flag from the DMA control register
      --                         indicating that a disable is requested for this
      --                         DMA stream.
      bDisable                 : in boolean;

      -- bDisabled             : This is the flag to the DMA status register
      --                         indicating when the circuit is actually disabled.
      bDisabled                : out boolean

    );
end DmaPortCommIfcOutputController;


architecture rtl of DmaPortCommIfcOutputController is

  -----------------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------------

  -- The number of bits to shift to convert from units of samples to bytes.
  constant kSampleShift : natural := Log2(kSampleSizeInBits)-3;

  constant kChannel : NiDmaGeneralChannel_t :=
    to_unsigned(kStreamNumber, bOutputRequest.Channel'length);

  signal bByteLane, bByteLaneNx : NiDmaByteLane_t;
  signal bOutputRequestLcl, bOutputRequestNx : NiDmaOutputRequestToDma_t;
  signal bReqWriteSpacesLcl, bReqWriteSpacesNx : NiDmaOutputByteCount_t;

  signal bSatcrWriteStrobeNx : boolean;
  signal bArbiterRequestEnable : boolean;
  signal bPacketLength : NiDmaOutputByteCount_t;
  signal bArbiterNormalReqNx, bArbiterEmergencyReqNx : std_logic;
  signal bCanRequestArbiterNormal, bCanRequestArbiterEmergency : boolean;
  signal bAllReadsReceived : boolean;
  signal bReadRequested : boolean;
  signal bArbiterDoneNx : std_logic;
  signal bArbiterDoneLcl : std_logic;
  signal bArbiterGrantQual : std_logic;

  -----------------------------------------------------------------------------
  -- State machine signals
  -----------------------------------------------------------------------------
  type DmaOutputRequestState_t is (

    -- Idle:              The idle state waits until the stream circuit is
    --                    enabled and the SATCR is greater than 0.
    Idle,


    -- Enabled:           The enabled state enables the local arbiter request
    --                    qualifier and waits until the arbiter grants access
    --                    to request data.  If the stream becomes disabled
    --                    or SATCR is zero, it goes to the Disabling state
    --                    and assert the done arbiter request.
    Enabled,


    -- SendDataRequest:   This state transmits the read request and waits until
    --                    the request is accepted by the NiDmaIp.
    SendDataRequest,


    -- Hold:              This state holds one clock cycle while waiting for
    --                    the new SATCR value to propogate back to this
    --                    component from the register block.
    Hold,


    -- Disabling:         This state transitions from the Enabled state to the
    --                    Idle state.  Before the state machine can return to
    --                    Idle, this state makes sure that all incoming data
    --                    has made its way to the FIFO.  Also, if the arbiter
    --                    provides a latent grant in this state, done is
    --                    asserted to prevent deadlocking the arbiter.
    Disabling

  );

  signal bDmaOutputRequestStateNx, bDmaOutputRequestState : DmaOutputRequestState_t;
  signal bDmaOutputRequestStatePrev : DmaOutputRequestState_t;
  signal bFifoEmptyCountReg    : unsigned(kFifoCountWidth-1 downto 0) := (others => '0');


begin

  bOutputRequest <= bOutputRequestLcl;
  bReqWriteSpaces <= bReqWriteSpacesLcl;
  bNumWriteSpaces <= shift_right(bOutputRequestLcl.ByteCount, kSampleShift);
  bArbiterDone <= bArbiterDoneLcl;
  
  -- The ArbiterDone signal is a registered output. Hence, it takes one cycle for the
  -- Arbiter to deassert the Grant after ArbiterDone asserts. The signal below is used
  -- to ignore the Grant during that cycle.
  bArbiterGrantQual <= bArbiterGrant and not bArbiterDoneLcl;

  -- Registers that must reset with a FIFO reset.  The byte lane pointer must
  -- reset with the FIFO because this relates to the byte lane where data
  -- will be written into the FIFO.  When the FIFO resets, it will expect
  -- data to restart at byte lane zero.
  FifoResetRegs: process(BusClk, aReset)
  begin

    if aReset then
      bByteLane <= (others=>'0');
    elsif rising_edge(BusClk) then
      if bReset then
        bByteLane <= (others=>'0');
      else
        bByteLane <= bByteLaneNx;
      end if;
    end if;

  end process FifoResetRegs;

  -- Registers used by the state machine.
  StateRegs: process(BusClk, aReset)
  begin

    if(aReset) then

      -- We reset to the Idle state.
      bDmaOutputRequestState <= Idle;

      bSatcrWriteStrobe <= false;
      bOutputRequestLcl <= kNiDmaOutputRequestToDmaZero;
      bReqWriteSpacesLcl <= (others=>'0');
      bArbiterDoneLcl <= '0';
      bDmaOutputRequestStatePrev <= Idle;

    elsif(rising_edge(BusClk)) then

      -- If bReset occurs, then it is always safe to return to the Idle state,
      -- because the bus itself is being reset.

      if(bReset) then

        bDmaOutputRequestState <= Idle;
        bDmaOutputRequestStatePrev <= Idle;

        bSatcrWriteStrobe <= false;
        bOutputRequestLcl <= kNiDmaOutputRequestToDmaZero;
        bArbiterDoneLcl <= '0';

      else

        bDmaOutputRequestState <= bDmaOutputRequestStateNx;
        bDmaOutputRequestStatePrev <= bDmaOutputRequestState;

        bSatcrWriteStrobe <= bSatcrWriteStrobeNx;
        bOutputRequestLcl <= bOutputRequestNx;
        bReqWriteSpacesLcl <= bReqWriteSpacesNx;
        bArbiterDoneLcl <= bArbiterDoneNx;

      end if;

    end if;

  end process StateRegs;

  --!STATE MACHINE STARTUP!
  --This state machine resets to the Idle state and only moves out of that
  --state if the disabled input goes false.  The disabled input comes from the
  --DMA registers component and can only go false following a register write
  --to the DMA channel.  The disabled input resets to true and a register write
  --cannot occur immediately following reset.  This is assuming that aReset is
  --used and is tied to the bus reset.

  -- The combinatorial state machine logic
  DmaNextStateLogic: process(bDmaOutputRequestState, bDisable, bMaxPktSize,
    bArbiterGrantQual, bPacketLength, bRequestAcknowledge, bAllReadsReceived,
    bByteLane, bOutputRequestLcl, bDmaOutputRequestStatePrev)
  begin

    -- Set initial signal values
    bDmaOutputRequestStateNx <= bDmaOutputRequestState;

    bOutputRequestNx <= kNiDmaOutputRequestToDmaZero;

    bDisabled <= false;
    bArbiterRequestEnable <= false;
    bArbiterDoneNx <= '0';
    bSatcrWriteStrobeNx <= false;
    bReadRequested <= false;
    bByteLaneNx <= bByteLane;
    bReqWriteSpacesNx <= (others=>'0');

    case bDmaOutputRequestState is

      -------------------------------------------------------------------------
      -- Idle:            The idle state waits until the stream circuit is
      --                  enabled and the SATCR is greater than 0.
      -------------------------------------------------------------------------
      when Idle =>

        -- Move to the enabled state when we are not disabling and the SATCR
        -- is non-zero.
        if not bDisable and bMaxPktSize(bMaxPktSize'left downto
          kSampleShift) /= 0 then

          bDmaOutputRequestStateNx <= Enabled;

          -- Enable the local arbiter request qualifier so that the requests
          -- can assert during the next state.
          bArbiterRequestEnable <= true;

        end if;

        -- If the arbiter grant is asserted in this state, we need to assert
        -- arbiter done to prevent a deadlock situation.
        if bArbiterGrantQual = '1' then
          bArbiterDoneNx <= '1';
        end if;

        -- We are disabled while in this state.
        bDisabled <= bDisable;


      -------------------------------------------------------------------------
      -- Enabled:         The enabled state enables the local arbiter request
      --                  qualifier and waits until the arbiter grants access
      --                  to request data.  If the stream becomes disabled
      --                  or SATCR is zero it goes to the Disabling state.
      -------------------------------------------------------------------------
      when Enabled =>

        bArbiterRequestEnable <= true;

        -- Go to DisableRequest state if we get the disable request or the SATCR
        -- drops to zero.
        if bDisable or bMaxPktSize(bMaxPktSize'left downto 
          kSampleShift) = 0 then

          bDmaOutputRequestStateNx <= Disabling;
          bArbiterRequestEnable <= false;

        -- If we get the arbiter grant, go to the Request state to send the
        -- read request.
        elsif bArbiterGrantQual = '1' then

          bDmaOutputRequestStateNx <= SendDataRequest;

          -- The number of spaces to request is equal to the amount of data
          -- requested in the packet, so latch it when we latch the packet.
          bReqWriteSpacesNx <= resize(bPacketLength, bReqWriteSpaces'length);
          bSatcrWriteStrobeNx <= true;

          bOutputRequestNx.Request <= true;
          bOutputRequestNx.Space <= kNiDmaSpaceStream;
          bOutputRequestNx.Channel <= kChannel;
          bOutputRequestNx.Address <= (others => '0');
          bOutputRequestNx.Baggage <= (others => '0');
          bOutputRequestNx.ByteSwap <= (others => '0');
          bOutputRequestNx.ByteLane <= bByteLane;
          bOutputRequestNx.ByteCount <= bPacketLength;
          bOutputRequestNx.Done <= false;
          bOutputRequestNx.EndOfRecord <= false;

          

          -- Disable the arbiter at this point since the FIFO count becomes
          -- invalid as the SATCR write strobe is true.
          bArbiterRequestEnable <= false;

        end if;


      -------------------------------------------------------------------------
      -- SendDataRequest: This state transmits the read request and waits until
      --                  the request is accepted by the DMA controller.
      -------------------------------------------------------------------------
      when SendDataRequest =>

        if bDmaOutputRequestStatePrev=Enabled then
        
          -- Update the next byte lane location based on the current byte lane
          -- and the packet size of the current request.
          bByteLaneNx <= resize(bByteLane + bOutputRequestLcl.ByteCount, bByteLaneNx'length);
          
        end if;
      
        -- Don't enable requests here, since the FIFO count is updating this
        -- cycle and is invalid.
        bArbiterRequestEnable <= false;

        -- When the request is accepted, assert arbiter done and move to the
        -- Hold state.
        if bRequestAcknowledge.Acknowledge then

          bDmaOutputRequestStateNx <= Hold;
          bArbiterDoneNx <= '1';
          bReadRequested <= true;
        else

          bOutputRequestNx <= bOutputRequestLcl;
        end if;


      -------------------------------------------------------------------------
      -- Hold:            This state holds one clock cycle while waiting for
      --                  the new SATCR value to propogate back to this
      --                  component from the register block.
      -------------------------------------------------------------------------
      when Hold =>

        -- The FIFO count updates one cycle after the request is sent, so we 
        -- disable arbiter requests in this state.
        bArbiterRequestEnable <= false;
        bDmaOutputRequestStateNx <= Enabled;


      -------------------------------------------------------------------------
      -- Disabling:       This state transitions from the Enabled state to the
      --                  Idle state.  Before the state machine can return to
      --                  Idle, this state makes sure that all incoming data
      --                  has made its way to the FIFO.  Also, if the arbiter
      --                  provides a latent grant in this state, done is
      --                  asserted to prevent deadlocking the arbiter.
      -------------------------------------------------------------------------
      when Disabling =>

        if bArbiterGrantQual = '1' then
          bArbiterDoneNx <= '1';
        end if;

        -- Check if we are still in a state where we require disabling.  If we
        -- no longer require disabling, we don't need to wait for the 
        -- RsrvdSpacesFilled flag before re-enabling.
        if not bDisable and bMaxPktSize(bMaxPktSize'left downto 
          kSampleShift) /= 0 then

          bDmaOutputRequestStateNx <= Enabled;

          -- Enable the local arbiter request qualifier so that the requests
          -- can assert during the next state.
          bArbiterRequestEnable <= true;

        elsif bAllReadsReceived then

          bDmaOutputRequestStateNx <= Idle;
        end if;

      when Others =>

    end case;

  end process DmaNextStateLogic;

  ----------------------------------------------------------------------------
  -- EmptyCountReg : This process registers the Empty Count register
  EmptyCountReg : process (aReset, BusClk)
  begin
    if aReset then
      bFifoEmptyCountReg <= (others => '0');
    elsif rising_edge(BusClk) then
      bFifoEmptyCountReg <= bFifoEmptyCount;
    end if;
  end process EmptyCountReg;
  
  -----------------------------------------------------------------------------
  -- GetPacketLength
  --
  -- This combinatorial logic determines the maximum size packet that can be
  -- sent at any given time.  This is the min of the
  -- (1) SATCR value
  -- (2) FIFO empty count
  -- (3) Max packet size
  -----------------------------------------------------------------------------
  GetPacketLength: process(bFifoEmptyCountReg, bMaxPktSize)
  begin

    if to_integer(bFifoEmptyCountReg) >= to_integer(bMaxPktSize(
      bMaxPktSize'left downto kSampleShift))
    then
      bPacketLength <= bMaxPktSize;
    else
      bPacketLength <= shift_left(resize(bFifoEmptyCountReg,
        bPacketLength'length), kSampleShift);
    end if;

  end process GetPacketLength;


  -----------------------------------------------------------------------------
  -- HandleArbiterRequests
  --
  -- This block is responsible for the combinatorial logic that produces the
  -- arbiter request signals.
  -----------------------------------------------------------------------------
  HandleArbiterRequests: block is

    signal bFifoHalfEmpty, bFifoQuarterEmpty : boolean;
    signal bFullPacketAvailable, bFullPacketAvailableLatched : boolean;

  begin

    ---------------------------------------------------------------------------
    --
    -- Normal request:     True when (the FIFO is at least one quarter empty
    --                     OR there is at least a full packet size of data
    --                     that can be requested) AND the request enable signal
    --                     is true.
    --
    -- Emergency request:  True when the FIFO is at least half empty or when we
    --                     need to send the done indicator and the request enable
    --                     signal is true.
    ---------------------------------------------------------------------------
    bArbiterNormalReqNx <= to_stdlogic(bCanRequestArbiterNormal and
      bArbiterRequestEnable);
    bArbiterEmergencyReqNx <= to_stdlogic(bCanRequestArbiterEmergency and
      bArbiterRequestEnable);

    bCanRequestArbiterNormal <= bFifoQuarterEmpty or bFullPacketAvailable;
    bCanRequestArbiterEmergency <= bFifoHalfEmpty;


    process(aReset, BusClk)
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
    end process;

    -- Use the top 2 bits of the FIFO empty count to determine whether it is half
    -- or quarter full.
    bFifoQuarterEmpty <= bFifoEmptyCountReg(bFifoEmptyCountReg'left) = '1' or
                         bFifoEmptyCountReg(bFifoEmptyCountReg'left-1) = '1';
    bFifoHalfEmpty <= bFifoEmptyCountReg(bFifoEmptyCountReg'left) = '1';

    -- A full packet is available when the MaxPktSize from the register
    -- component is equal to the DMA controller limited maximum packet size.
    bFullPacketAvailable <= (bFifoEmptyCountReg >=
      bMaxPktSize(bMaxPktSize'left downto kSampleShift) and bMaxPktSize /= 0) or
      bFullPacketAvailableLatched;

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
        bFullPacketAvailableLatched <= bFullPacketAvailable and bArbiterRequestEnable;
      end if;
    end process LatchFullPacketAvailable;
      
  end block HandleArbiterRequests;

  -----------------------------------------------------------------------------
  -- Track the number of outstanding read requests.  This is used to determine
  -- when the stream can safely disable, since the stream should not disable
  -- until responses to all read requests have been received.
  -----------------------------------------------------------------------------
  OutstandingReadCounter: block is

    -- The worst case number of outstanding read requests is the number of
    -- samples in the FIFO.
    signal bReadCount : unsigned(bFifoEmptyCountReg'range);

  begin

    ReadCount: process(aReset, BusClk)
    begin
      if aReset then
        bReadCount <= (others=>'0');
      elsif rising_edge(BusClk) then

        -- Increment the read count whenever a read is requested and decrement it
        -- whenever a read response is received.
        if bReset then
          bReadCount <= (others=>'0');
        elsif bReadRequested and not bReadResponseReceived then
          bReadCount <= bReadCount + 1;
        elsif bReadResponseReceived and not bReadRequested then
          bReadCount <= bReadCount - 1;
        end if;

      end if;
    end process ReadCount;

    -- All outstanding reads have been received when the read count is zero.
    bAllReadsReceived <= bReadCount = 0;

  end block OutstandingReadCounter;

end architecture rtl;
