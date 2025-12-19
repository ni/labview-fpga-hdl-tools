-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcSinkStreamTcrUpdateController.vhd
-- Author: Florin Hurgoi
-- Original Project: LabVIEW FPGA support for Emerald Bay
-- Date: 31 May 2012
--
-------------------------------------------------------------------------------
-- (c) 2007 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   This component implements a state machine that controls TCR update writes
-- to a source stream for a peer-to-peer transfer.  Every update that is sent
-- requests the maximum number of points available in the FIFO.
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

  -- This package contains the definitions for the interface between the NI DMA IP and
  -- the application specific logic
  use work.PkgNiDma.all;

  -- The pkg containing information on the DmaPort configuration.
  use work.PkgNiDmaConfig.all;

  -- The pkg containing some configuration info on the communication interface,
  -- such as the number of DMA channels and size of the DMA FIFO's.
  use work.PkgCommIntConfiguration.all;

  use work.PkgDmaPortCommIfcArbiter.all;

entity DmaPortCommIfcSinkStreamTcrUpdateController is
    generic(

      -- The width of the user data element being pushed to the FIFO
      kDataWidthInBits : positive := 64;

      -- The stream number associated with the DMA channel.
      kStreamNumber : natural;

      -- The width of the FIFO counts.
      kFifoCountWidth : natural

    );
    port(

      -- aReset             : This is the asynchronous reset to the state
      --                      machine registers.
      aReset                : in boolean;

      -- bReset             : This is a synchronous reset to the state
      --                      machine.  This signal comes from the PCI-e
      --                      reset signal.
      bReset                : in boolean;

      BusClk                : in std_logic;

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

      bSatcrUpdateDataValid : out boolean;

      -------------------------------------------------------------------------
      -- Arbiter interface
      -------------------------------------------------------------------------

      -- bArbiterNormalReq  : This is the request line to the arbiter for
      --                      normal priority.  Normal priority occurs when
      --                      the FIFO is at least quarter empty.
      bArbiterNormalReq     : out std_logic;

      -- bArbiterEmergencyReq: This is the request line to the arbiter for
      --                       emergency priority.  Emergency priority occurs
      --                       when the FIFO is at least half empty.
      bArbiterEmergencyReq  : out std_logic;

      -- bArbiterDone       : This is the line to the arbiter indicating that
      --                      the transmission is complete.  This asserts one
      --                      clock cycle after the last word of the
      --                      packet is being sent.
      bArbiterDone          : out std_logic;

      -- bArbiterGrant      : This is the line from the arbiter indicating that
      --                      a request for DMA Port access has been granted.
      bArbiterGrant         : in std_logic;

      -------------------------------------------------------------------------
      -- FIFO signals
      -------------------------------------------------------------------------

      -- bFIFOEmptyCount    : This is the count of the number of empty spaces
      --                      in the FIFO.
      bFifoEmptyCount       : in unsigned(kFifoCountWidth-1 downto 0);

      -- bSatcrWriteStrobe  : This is the signal to strobe in the number of
      --                      spaces reserved in the FIFO.
      bSatcrWriteStrobe     : out boolean;

      -- bReqWriteSpaces    : This is the number of reserved spaces to be
      --                      requested when SatcrWriteStrobe is strobed.
      bReqWriteSpaces       : out unsigned(kFifoCountWidth-1 downto 0);

      -------------------------------------------------------------------------
      -- Peer-to-Peer registers
      -------------------------------------------------------------------------

      -- bTcrAddress        : This is the 64 bit address of the source stream's
      --                      TCR.
      bTcrAddress           : in NiDmaAddress_t;

      -------------------------------------------------------------------------
      -- Register flags
      -------------------------------------------------------------------------

      -- bDisable           : This is a flag from the DMA control register
      --                      indicating that a disable is requested for this
      --                      DMA stream.
      bDisable              : in boolean;

      -- bDisabled          : This flag indicates to the stream state
      --                      controller that it is safe to report the stream
      --                      as disabled.
      bDisabled             : out boolean;

      -- bSatcrUpdatesEnabled : This boolean indicates whether or not a sink
      --                        stream's ability to update the SATCR address in
      --                        the corresponding source is enabled.
      bSatcrUpdatesEnabled  : in boolean

    );
end DmaPortCommIfcSinkStreamTcrUpdateController;


architecture rtl of DmaPortCommIfcSinkStreamTcrUpdateController is

  constant kChannel : NiDmaGeneralChannel_t := 
    to_unsigned(kStreamNumber, NiDmaGeneralChannel_t'length);

  -----------------------------------------------------------------------------
  -- Registers
  -----------------------------------------------------------------------------
  signal bInputRequestLoc, bInputRequestNx : NiDmaInputRequestToDma_t;
  signal bSatcrWriteStrobeLoc : boolean;
  signal bReqWriteSpacesLoc : unsigned(kFifoCountWidth-1 downto 0);
  signal bArbiterDoneNx : std_logic;
  signal bArbiterDoneLcl : std_logic;

  -----------------------------------------------------------------------------
  -- Combinatorial signals
  -----------------------------------------------------------------------------
  signal bSatcrUpdateRequest : NiDmaInputRequestToDma_t;
  signal bReqWriteSpacesLocNx : unsigned(kFifoCountWidth-1 downto 0);
  signal bSatcrWriteStrobeLocNx : boolean;
  signal bArbiterNormalReqNx, bArbiterEmergencyReqNx : std_logic;
  signal bArbiterRequestForRead : boolean;
  signal bFifoEmptyCountInBytes : unsigned(31 downto 0);
  signal bEnableArbiterRequests : boolean;
  signal bPopData : boolean;
  signal bArbiterGrantQual : std_logic;


  -----------------------------------------------------------------------------
  -- State machine signals
  -----------------------------------------------------------------------------
  type TcrUpdateState_t is (

    -- Disabled:           The disabled state waits and does nothing until the
    --                     disabled input goes false.
    Disabled,

    -- Idle:               The idle state waits until the stream is enabled and
    --                     there is enough data to request so that an arbiter
    --                     request can be generated.
    Idle,


    -- WaitForArbiter:     This state waits for an arbiter grant signal to
    --                     initiate a packet transmission.  (This could be
    --                     combined with the Idle state.)
    WaitForArbiter,


    -- SendSatcrUpdateRequest: This state sends the SATCR update request and waits
    --                         until it is accepted.
    SendSatcrUpdateRequest,

    -- WaitForPop: 
    --      After the update request has been accepted, this state waits 
    --      for the DmaPort to consume the SATCR value by asserting 
    --      bNiDmaInputDataFromDma.Pop. This fixes the P2P stalling 
    --      problem reported in CAR 473872. 
    WaitForPop

  );

  signal bTcrUpdateStateNx, bTcrUpdateState : TcrUpdateState_t := Disabled;


begin

  bNiDmaInputRequestToDma <= bInputRequestLoc;
  bReqWriteSpaces <= bReqWriteSpacesLoc;
  bSatcrWriteStrobe <= bSatcrWriteStrobeLoc;
  bArbiterDone <= bArbiterDoneLcl;
  
  -- The ArbiterDone signal is a registered output. Hence, it takes one cycle for the
  -- Arbiter to deassert the Grant after ArbiterDone asserts. The signal below is used
  -- to ignore the Grant during that cycle.
  bArbiterGrantQual <= bArbiterGrant and not bArbiterDoneLcl;


  process(BusClk, aReset)
  begin

    if aReset then

      bFifoEmptyCountInBytes <= (others => '0');

    elsif rising_edge(BusClk) then

      if bSatcrWriteStrobeLoc then

        bFifoEmptyCountInBytes <= shift_left(resize(bReqWriteSpacesLoc,
          bFifoEmptyCountInBytes'length), Log2(kDataWidthInBits)-3);

      end if;

    end if;

  end process;

  -- Registers used by the state machine.
  StateRegs: process(BusClk, aReset)
  begin

    if(aReset) then

      -- We reset to the Idle state.
      bTcrUpdateState <= Disabled;
      bInputRequestLoc <= kNiDmaInputRequestToDmaZero;
      bReqWriteSpacesLoc <= (others=>'0');
      bSatcrWriteStrobeLoc <= false;
      bArbiterDoneLcl <= '0';

    elsif(rising_edge(BusClk)) then

      -- If bReset occurs, then it is always safe to return to the Idle state,
      -- because the bus itself is being reset.

      if(bReset) then

        bTcrUpdateState <= Disabled;
        bInputRequestLoc <= kNiDmaInputRequestToDmaZero;
        bReqWriteSpacesLoc <= (others=>'0');
        bSatcrWriteStrobeLoc <= false;
        bArbiterDoneLcl <= '0';

      else

        bTcrUpdateState <= bTcrUpdateStateNx;
        bInputRequestLoc <= bInputRequestNx;
        bReqWriteSpacesLoc <= bReqWriteSpacesLocNx;
        bSatcrWriteStrobeLoc <= bSatcrWriteStrobeLocNx;
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
  DmaNextStateLogic: process(bTcrUpdateState, bInputRequestLoc, bDisable,
                             bArbiterNormalReqNx, bArbiterEmergencyReqNx,
                             bArbiterGrantQual, bFifoEmptyCount, bTcrAddress,
                             bSatcrUpdatesEnabled, bSatcrWriteStrobeLoc,
                             bSatcrUpdateRequest, bNiDmaInputRequestFromDma,
                             bPopData)
  begin

    -- Set initial signal values
    bTcrUpdateStateNx <= bTcrUpdateState;
    bInputRequestNx <= kNiDmaInputRequestToDmaZero;
    bReqWriteSpacesLocNx <= (others=>'0');
    bSatcrWriteStrobeLocNx <= false;
    bArbiterDoneNx <= '0';
    bDisabled <= false;
    bArbiterRequestForRead <= false;
    bEnableArbiterRequests <= false;

    case bTcrUpdateState is

      -------------------------------------------------------------------------
      -- Disabled:          The disabled state waits and does nothing until the
      --                    disabled input goes false.
      -------------------------------------------------------------------------
      when Disabled =>

        -- The state machine always reports disabled while in this state.
        bDisabled <= true;

        -- Move to the Idle state when the state machine becomes enabled.
        if not bDisable then
          bTcrUpdateStateNx <= Idle;
          bEnableArbiterRequests <= true;
        end if;

        if bArbiterGrantQual = '1' then
          bArbiterDoneNx <= '1';
        end if;

      -------------------------------------------------------------------------
      -- Idle:              The idle state waits until the stream is enabled
      --                    and there is enough data to request so that an
      --                    arbiter request can be generated.
      -------------------------------------------------------------------------
      when Idle =>

        bEnableArbiterRequests <= true;

        -- Move to the WaitForArbiter state if we are disabling.  We will wait
        -- for the arbiter to give us permission so that we can send the final
        -- read packet to flush any SATCR writes from the transmit FIFO's.
        -- Note that this is not necessary if SATCR updates are disabled.
        if bDisable then

          if bSatcrUpdatesEnabled then
            bTcrUpdateStateNx <= WaitForArbiter;
            bArbiterRequestForRead <= true;
          else
            bTcrUpdateStateNx <= Disabled;
          end if;

          bEnableArbiterRequests <= false;

        -- Move to the WaitForArbiter state if the stream is not disabled, SATCR
        -- updates are enabled, and the arbiter requests indicate that there is
        -- an update to send.
        elsif bSatcrUpdatesEnabled and (bArbiterNormalReqNx = '1' or
          bArbiterEmergencyReqNx = '1') then

          bTcrUpdateStateNx <= WaitForArbiter;

        -- If the stream is enabled but SATCR updates are not enabled, then we
        -- don't really have a need to update SATCR in the FIFO at all, since this
        -- only affects the empty count, and the empty count is only used in this
        -- module when the SATCR updates are enabled.  However, we'll update
        -- SATCR anyway for completeness.
        elsif not bDisable and not bSatcrUpdatesEnabled then

          -- We can always request the empty count in SATCR when updates are disabled,
          -- but the empty count is updated the clock cycle after the SATCR write
          -- is strobed.  Therefore, we don't updated the SATCR if it was updated in
          -- the previous clock cycle.
          if not bSatcrWriteStrobeLoc then
            bReqWriteSpacesLocNx <= bFifoEmptyCount;
            bSatcrWriteStrobeLocNx <= true;
          end if;

        end if;

        if bArbiterGrantQual = '1' then
          bArbiterDoneNx <= '1';
        end if;


      -------------------------------------------------------------------------
      -- WaitForArbiter:    This state waits for an arbiter grant signal to
      --                    initiate a packet transmission.
      -------------------------------------------------------------------------
      when WaitForArbiter =>

        bEnableArbiterRequests <= true;

        -- If we are disabling, request the arbiter for the final read request.
        if bDisable then
          bTcrUpdateStateNx <= Disabled;
          bEnableArbiterRequests <= false;
        end if;

        if bArbiterGrantQual = '1' then

          bTcrUpdateStateNx <= SendSatcrUpdateRequest;
          bInputRequestNx <= bSatcrUpdateRequest;

          bReqWriteSpacesLocNx <= bFifoEmptyCount;
          bSatcrWriteStrobeLocNx <= true;

        end if;


      -------------------------------------------------------------------------
      -- SendSatcrUpdateRequest:  This state sends the SATCR update request and waits
      --                          until it is accepted.
      -------------------------------------------------------------------------
      when SendSatcrUpdateRequest =>

        if bNiDmaInputRequestFromDma.Acknowledge then
          bArbiterDoneNx <= '1';
          if bPopData then
            bTcrUpdateStateNx <= Idle;
          else
            bTcrUpdateStateNx <= WaitForPop;
          end if;
        else
          bInputRequestNx <= bInputRequestLoc;

        end if;

      -------------------------------------------------------------------------
      -- WaitForPop: If Pop didn't come immediately, wait until it 
      -- asserts before returning to Idle. This ensures that we do not 
      -- request another SATCR packet until we've completed the current 
      -- packet.
      -- It is possible that the pop signal will assert a long time 
      -- after the request is granted by the arbiter. Even though the 
      -- arbiter has chosen the SATCR packet, the Chinch may not be able 
      -- to consume the packet right away. If data is consumed quickly 
      -- from the sink FIFO, we might become ready to request another 
      -- SATCR packet before the first packet's data is consumed by the 
      -- Pop assertion. In that case, the second request's data will 
      -- overwrite the data from the prior request. Both SATCR writes 
      -- will be sent, but the data for the first write will be 
      -- corrupted.
      -- A simple fix for this problem is to pause in this state until 
      -- the SATCR data is consumed. For the current Chinch 
      -- implementation, the time spent in this state will always be a 
      -- handful of clock cycles compared to hundreds or thousands of 
      -- cycles usually spent in Idle.
      -------------------------------------------------------------------------
      when WaitForPop =>
        if bPopData then
          bTcrUpdateStateNx <= Idle;
        end if;

      when Others =>

        bTcrUpdateStateNx <= Idle;

    end case;

  end process DmaNextStateLogic;


  -----------------------------------------------------------------------------
  -- Build the SATCR update request.
  -----------------------------------------------------------------------------
    bSatcrUpdateRequest.Request <= true;
    bSatcrUpdateRequest.Space <= kNiDmaSpaceDirectSysMem;
    bSatcrUpdateRequest.Channel <= kChannel;
    bSatcrUpdateRequest.Address <= bTcrAddress;
    bSatcrUpdateRequest.Baggage <= (others => '0');
    bSatcrUpdateRequest.ByteSwap <= (others => '0');
    bSatcrUpdateRequest.ByteLane <= (others => '0');
    bSatcrUpdateRequest.ByteCount <= to_unsigned(4, bSatcrUpdateRequest.ByteCount'length);
    bSatcrUpdateRequest.Done <= false;
    bSatcrUpdateRequest.EndOfRecord <= false;


  -----------------------------------------------------------------------------
  -- HandleArbiterRequests
  --
  -- This block is responsible for the combinatorial logic that produces the
  -- arbiter request signals.
  -----------------------------------------------------------------------------
  HandleArbiterRequests: block is

    signal bFifoHalfEmpty, bFifoQuarterEmpty : boolean;

  begin

    ---------------------------------------------------------------------------
    --
    -- Normal request:     True when (the FIFO is at least one quarter empty
    --                     or there is at least a full packet size of data
    --                     that can be requested) and the request enable signal
    --                     is true.
    --
    -- Emergency request:  True when the FIFO is at least half empty and the
    --                     request enable signal is true.
    --
    ---------------------------------------------------------------------------
    bArbiterNormalReqNx <= to_stdlogic(bFifoQuarterEmpty and not bDisable and
      bSatcrUpdatesEnabled and bEnableArbiterRequests);
    bArbiterEmergencyReqNx <= to_stdlogic((bFifoHalfEmpty and not bDisable and
      bSatcrUpdatesEnabled and bEnableArbiterRequests) or bArbiterRequestForRead);


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
    bFifoQuarterEmpty <= bFifoEmptyCount(bFifoEmptyCount'left) = '1' or
                         bFifoEmptyCount(bFifoEmptyCount'left-1) = '1';
    bFifoHalfEmpty <= bFifoEmptyCount(bFifoEmptyCount'left) = '1';

  end block HandleArbiterRequests;


  -- The following block implements the latecncy between the Pop and Data (representing
  -- the SATCR updtaes) sent on  the Input Data interface. The Read Data latency
  -- is computed at compile time representing the number of pipeline stages needed
  -- to multiplex the DMA channels  accessing the Input Data interface and the latency
  -- needed to read data from the FIFO. This block will implement kFifoReadLatency
  -- read latency clock cyles equivalent with the latency needed to read data from the
  -- FIFO.
  DelayStagesBlk: block

    signal bDataDelayedArray : NiDmaInputDataToDmaArray_t(
      0 to ArbVecMSB(kFifoReadLatency));

    signal bPopDelayedArray : BooleanVector(0 to kFifoReadLatency-1);

  begin

    NoDelayStages: if kFifoReadLatency = 0 generate

      bNiDmaInputDataToDma.Data <=
        std_logic_vector(resize(bFifoEmptyCountInBytes, kNiDmaDataWidth));

    end generate;

    DelayStages: if kFifoReadLatency > 0 generate

      InputDataLatency: for i in bDataDelayedArray'range generate

        DataDelayStage: process (aReset, BusClk) is
        begin

          if aReset then
            bDataDelayedArray(i).Data <= (others => '0');
          elsif rising_edge(BusClk) then

            if i = 0 then
              bDataDelayedArray(i).Data <=
                std_logic_vector(resize(bFifoEmptyCountInBytes, kNiDmaDataWidth));
            else
              bDataDelayedArray(i)<= bDataDelayedArray(i-1);
            end if;

          end if;

        end process;

      end generate InputDataLatency;

      bNiDmaInputDataToDma.Data <= bDataDelayedArray(kFifoReadLatency-1).Data;

    end generate DelayStages;

    bPopData <= bNiDmaInputDataFromDma.Pop when
      bNiDmaInputDataFromDma.DirectChannel(kStreamNumber) else false;

    -- PopDelay process delays the Pops that issue Data Read so that we get a Data valid
    -- signal for the STCR updates.
    PopDelay: for i in bPopDelayedArray'range generate

    begin

      PopDelayStage: process (aReset, BusClk) is
      begin
        if aReset then
          bPopDelayedArray(i) <= false;
        elsif rising_edge(BusClk) then

          if i = 0 then
            bPopDelayedArray(i) <= bPopData;
          else
            bPopDelayedArray(i)<= bPopDelayedArray(i-1);
          end if;

        end if;

      end process;

    end generate PopDelay;

    -- Data valid signal is generated from the Pops delayed with kFifoReadLatency
    -- number of clock cycles.
    bSatcrUpdateDataValid <= bPopDelayedArray(kFifoReadLatency-1);

  end block DelayStagesBlk;

end architecture rtl;
