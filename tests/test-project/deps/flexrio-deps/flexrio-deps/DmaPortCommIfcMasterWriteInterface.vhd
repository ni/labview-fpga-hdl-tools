-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcMasterWriteInterface.vhd
-- Author: Florin Hurgoi
-- Original Project: LabVIEW FPGA
-- Date: 04 November 2011
--
-------------------------------------------------------------------------------
-- (c) 2007 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   This block implements the interface between the Write Master Port that sits in
--   "The Window" and the DmaPort connected to NI DMA IP.
--   This component receives requests from MasterPort based on which it sends the
--   arbitration requests to the Input Arbiter. Once the grant is given the requests
--   are sent to the NI DMA IP. The Data and Status interfaces comming from NI DMA IP
--   are decoded for the "channel number" so that only applicable transfers are sent
--   to the Master Port. The Data popped from Master Port is delayed as needed to
--   to meet the expected read latency at NI DMA IP.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

  use work.PkgDmaPortCommunicationInterface.all;

  -- This package contains the definitions for the interface between the NI DMA IP and
  -- the application specific logic
  use work.PkgNiDma.all;

  -- The pkg containing information on the DmaPort configuration.
  use work.PkgNiDmaConfig.all;

  -- The pkg containing information on the Comm Ifc configuration.
  use work.PkgCommIntConfiguration.all;

  -- The package contain data types definitions needed to define Master Port interfaces.
  use work.PkgDmaPortCommIfcMasterPort.all;

  use work.PkgDmaPortCommIfcArbiter.all;

entity DmaPortCommIfcMasterWriteInterface is
    generic(

      kWriteMasterPortNumber : natural := 1

    );
    port(

      -- The asynchronous reset
      aReset : in boolean;

      -------------------------------------------------------------------------
      -- Clocks
      -------------------------------------------------------------------------

      -- The communication interface Bus clock.
      BusClk : in std_logic;

      -------------------------------------------------------------------------
      -- NI DMA IP interface
      -------------------------------------------------------------------------

      bNiFpgaMasterWriteRequestToDma : out NiDmaInputRequestToDma_t;
      bNiFpgaMasterWriteRequestFromDma : in NiDmaInputRequestFromDma_t;
      bNiFpgaMasterWriteDataFromDma : in NiDmaInputDataFromDma_t;
      bNiFpgaMasterWriteDataToDma : out NiDmaInputDataToDma_t;
      bNiFpgaMasterWriteStatusFromDma : in NiDmaInputStatusFromDma_t;

      -- bNiFpgaMasterWriteDataToDmaValid : This signal indicates that Data sent to
      --                                    NI DMA IP is valid. This signal will be used
      --                                    to multiplex the Data bus going to NI DMA IP.
      bNiFpgaMasterWriteDataToDmaValid : out boolean;

      -------------------------------------------------------------------------
      -- Master Port Write interface
      -------------------------------------------------------------------------

      bNiFpgaMasterWriteRequestFromMaster : in NiFpgaMasterWriteRequestFromMaster_t;
      bNiFpgaMasterWriteRequestToMaster : out NiFpgaMasterWriteRequestToMaster_t;
      bNiFpgaMasterWriteDataFromMaster : in NiFpgaMasterWriteDataFromMaster_t;
      bNiFpgaMasterWriteDataToMaster : out NiFpgaMasterWriteDataToMaster_t;
      bNiFpgaMasterWriteStatusToMaster : out NiFpgaMasterWriteStatusToMaster_t;

      -------------------------------------------------------------------------
      -- Arbiter signals
      -------------------------------------------------------------------------

      -- bMasterWriteArbiterReq : This is the signal to the arbiter indicating
      --                          that normal access is requested to the NI DMA IP.
      bMasterWriteArbiterReq    : out std_logic;

      -- bMasterWriteArbiterDone : This is the signal to the arbiter indicating
      --                           that the current access to Input Request
      --                           Interface has completed on this clock cycle.
      --                           This is a strobe bit.
      bMasterWriteArbiterDone    : out std_logic;

      -- bMasterWriteArbiterGrant : This is the signal from the arbiter indicating
      --                            the MasterPort Write has access to Input Request
      --                            Interface. This stays asserted while the
      --                            channel has access.
      bMasterWriteArbiterGrant    : in  std_logic

    );
end DmaPortCommIfcMasterWriteInterface;


architecture rtl of DmaPortCommIfcMasterWriteInterface is

  -- kChannel represents the channel number that will be sent together with the
  -- request.
  constant kChannel : NiDmaGeneralChannel_t := to_unsigned(kWriteMasterPortNumber,
    NiDmaGeneralChannel_t'length);

  -- kNumberOfDelayStages represents the number of stages needed to delay the Data
  -- comming from Master Port so that it will meet the latency expected by the NI DMA IP.
  -- The read latency between Pop and Data is 2 on the MasterWriteData interface.
  -- The read latency between Pop and Data expected by the NI DMA IP is
  -- kNiDmaInputDataReadLatency defined in PkgNiDmaConfig.
  constant kNumberOfDelayStages : natural := kNiDmaInputDataReadLatency - 2;
  signal bDataDelayedArray : NiFpgaMasterWriteDataFromMasterArray_t(
    0 to ArbVecMSB(kNumberOfDelayStages));

  signal bPopDelayedArray : BooleanVector(0 to kNiDmaInputDataReadLatency-1);

  signal bMasterWriteDataToMasterLoc : NiFpgaMasterWriteDataToMaster_t;

  signal bNiFpgaMasterWriteRequestToDmaNx, bNiFpgaMasterWriteRequestToDmaLcl :
    NiDmaInputRequestToDma_t;

  type WriteRequestState_t is (
  -- Idle           This is the default state where we wait for a request from the
  --                Master Port. When we receive a request from the Master Port an
  --                arbiter request is issued.
  Idle,

  -- WaitForArbiter In this state we wait for the arbiter to give us the grant for
  --                sending the request on the DmaPort. Once we have the grant we
  --                build the request and move to SendRequest state.
  WaitForArbiter,

  -- SendRequest    In this state the request is sent to the DmaPort until it is accepted.
  --                Once the request it is accepted we send the arbiter done strobe to
  --                the arbiter.
  SendRequest);

  signal bWriteRequestState, bWriteRequestStateNx : WriteRequestState_t := Idle;

begin

  StateReg: process (aReset, BusClk) is
  begin

    if aReset then

      bWriteRequestState <= Idle;
      bNiFpgaMasterWriteRequestToDmaLcl <= kNiDmaInputRequestToDmaZero;

    elsif rising_edge(BusClk) then

      bWriteRequestState <= bWriteRequestStateNx;
      bNiFpgaMasterWriteRequestToDmaLcl <= bNiFpgaMasterWriteRequestToDmaNx;

    end if;

  end process StateReg;

  bNiFpgaMasterWriteRequestToDma <= bNiFpgaMasterWriteRequestToDmaLcl;

  --!STATE MACHINE STARTUP!
  -- This state machine Resets to Idle state and only move out of this state when 
  -- bNiFpgaMasterWriteRequestFromMaster.Request is true. The Request comes from the
  -- the Master Port and we can assueme the signal resets to false and a request is
  -- issued after a register write to the Master Port Register that cannot occur right
  -- after reset.

  WriteRequestNextStateLogic: process (bWriteRequestState, 
    bNiFpgaMasterWriteRequestFromMaster, bMasterWriteArbiterGrant,
    bNiFpgaMasterWriteRequestToDmaLcl, bNiFpgaMasterWriteRequestFromDma) is
  begin

    -- Set initial signal values
    bWriteRequestStateNx <= bWriteRequestState;
    bMasterWriteArbiterReq <= '0';
    bMasterWriteArbiterDone <= '0';
    bNiFpgaMasterWriteRequestToDmaNx <= kNiDmaInputRequestToDmaZero;
    bNiFpgaMasterWriteRequestToMaster.Acknowledge <= false;

    case bWriteRequestState is

      when Idle =>

        if bNiFpgaMasterWriteRequestFromMaster.Request then
          bMasterWriteArbiterReq <= '1';
          bWriteRequestStateNx <= WaitForArbiter;
        end if;

      when WaitForArbiter =>

        bMasterWriteArbiterReq <= '1';

        if bMasterWriteArbiterGrant = '1' then

          bNiFpgaMasterWriteRequestToDmaNx.Request <=
            bNiFpgaMasterWriteRequestFromMaster.Request;
          bNiFpgaMasterWriteRequestToDmaNx.Space <=
            bNiFpgaMasterWriteRequestFromMaster.Space;
          bNiFpgaMasterWriteRequestToDmaNx.Channel <= kChannel;
          bNiFpgaMasterWriteRequestToDmaNx.Address <=
            bNiFpgaMasterWriteRequestFromMaster.Address;
          bNiFpgaMasterWriteRequestToDmaNx.Baggage <=
            bNiFpgaMasterWriteRequestFromMaster.Baggage;
          bNiFpgaMasterWriteRequestToDmaNx.ByteSwap <=
            bNiFpgaMasterWriteRequestFromMaster.ByteSwap;
          bNiFpgaMasterWriteRequestToDmaNx.ByteLane <=
            bNiFpgaMasterWriteRequestFromMaster.ByteLane;
          bNiFpgaMasterWriteRequestToDmaNx.ByteCount <=
            bNiFpgaMasterWriteRequestFromMaster.ByteCount;
          bNiFpgaMasterWriteRequestToDmaNx.Done <= false;
          bNiFpgaMasterWriteRequestToDmaNx.EndOfRecord <= false;

          bWriteRequestStateNx <= SendRequest;

        end if;

      when SendRequest =>

        if bNiFpgaMasterWriteRequestFromDma.Acknowledge then
          bMasterWriteArbiterDone <= '1';
          bWriteRequestStateNx <= Idle;
          bNiFpgaMasterWriteRequestToMaster.Acknowledge <= true;
        else

          bMasterWriteArbiterReq <= '1';
          bNiFpgaMasterWriteRequestToDmaNx <= bNiFpgaMasterWriteRequestToDmaLcl;

        end if;

    end case;

  end process WriteRequestNextStateLogic;


  -- The following process decodes the channel number on the Data Interface comming
  -- from NI DMA IP.
  WriteDataFromDmaDecode: process (bNiFpgaMasterWriteDataFromDma) is
  begin

      if bNiFpgaMasterWriteDataFromDma.DirectChannel(kWriteMasterPortNumber) then

        bMasterWriteDataToMasterLoc.TransferStart <=
          bNiFpgaMasterWriteDataFromDma.TransferStart;
        bMasterWriteDataToMasterLoc.TransferEnd <= 
          bNiFpgaMasterWriteDataFromDma.TransferEnd;
        bMasterWriteDataToMasterLoc.Space <= bNiFpgaMasterWriteDataFromDma.Space;
        bMasterWriteDataToMasterLoc.ByteLane <= bNiFpgaMasterWriteDataFromDma.ByteLane;
        bMasterWriteDataToMasterLoc.ByteCount <=
          bNiFpgaMasterWriteDataFromDma.ByteCount;
        bMasterWriteDataToMasterLoc.ByteEnable <=
          bNiFpgaMasterWriteDataFromDma.ByteEnable;
        bMasterWriteDataToMasterLoc.Pop <= bNiFpgaMasterWriteDataFromDma.Pop;
      else
        bMasterWriteDataToMasterLoc <= kNiFpgaMasterWriteDataToMasterZero;
      end if;

  end process WriteDataFromDmaDecode;

  bNiFpgaMasterWriteDataToMaster <= bMasterWriteDataToMasterLoc;

  -- The following block implements the latecncy between the Pop and Data on Input Data
  -- interface. The Read Data latency is computed at compile time function of the
  -- number of input DMA channels. The Read Data latency needs to be met by
  -- Master Port Data Interface too.
  DelayStagesBlk: block
  begin

    NoDelayStages: if kNumberOfDelayStages = 0 generate

      bNiFpgaMasterWriteDataToDma.Data <= bNiFpgaMasterWriteDataFromMaster.Data;
      
    end generate;
      
    DelayStages: if kNumberOfDelayStages > 0 generate

      InputDataLatency: for i in bDataDelayedArray'range generate

        DataDelayStage: process (aReset, BusClk) is
        begin

          if aReset then
            bDataDelayedArray(i).Data <= (others => '0');
          elsif rising_edge(BusClk) then

            if i = 0 then
              bDataDelayedArray(i).Data <= bNiFpgaMasterWriteDataFromMaster.Data;
            else
              bDataDelayedArray(i)<= bDataDelayedArray(i-1);
            end if;

          end if;

        end process;

      end generate InputDataLatency;

      bNiFpgaMasterWriteDataToDma.Data <= bDataDelayedArray(kNumberOfDelayStages-1).Data;

    end generate DelayStages;

  end block DelayStagesBlk;

  -- PopDelay process delays the Pops that issue Data Write so that we get a signal
  -- that will be asserted together with the Data issued by the not delayed Pop.
  PopDelay: for i in bPopDelayedArray'range generate

  begin

    PopDelayStage: process (aReset, BusClk) is
    begin
      if aReset then
        bPopDelayedArray(i) <= false;
      elsif rising_edge(BusClk) then

        if i = 0 then
          bPopDelayedArray(i) <= bMasterWriteDataToMasterLoc.Pop;
        else
          bPopDelayedArray(i)<= bPopDelayedArray(i-1);
        end if;

      end if;

    end process;

  end generate PopDelay;

  -- Data valid signal is generated from the Pops delayed with kNiDmaInputDataReadLatency
  -- number of clock cycles.
  bNiFpgaMasterWriteDataToDmaValid <= bPopDelayedArray(kNiDmaInputDataReadLatency-1);

  -- The following process decodes the channel number on the Status Interface comming
  -- from NI DMA IP.
  WriteStatusDecode: process (aReset, BusClk) is
  begin

    if aReset then
      bNiFpgaMasterWriteStatusToMaster <= kNiFpgaMasterWriteStatusToMasterZero;
    elsif rising_edge(BusClk) then

      if bNiFpgaMasterWriteStatusFromDma.DirectChannel(kWriteMasterPortNumber) then

        bNiFpgaMasterWriteStatusToMaster.Ready <= bNiFpgaMasterWriteStatusFromDma.Ready;
        bNiFpgaMasterWriteStatusToMaster.Space <= bNiFpgaMasterWriteStatusFromDma.Space;
        bNiFpgaMasterWriteStatusToMaster.ByteCount <=
          bNiFpgaMasterWriteStatusFromDma.ByteCount;
        bNiFpgaMasterWriteStatusToMaster.ErrorStatus <=
          bNiFpgaMasterWriteStatusFromDma.ErrorStatus;
      else
        bNiFpgaMasterWriteStatusToMaster <= kNiFpgaMasterWriteStatusToMasterZero;
      end if;

    end if;

  end process WriteStatusDecode;


end rtl;
