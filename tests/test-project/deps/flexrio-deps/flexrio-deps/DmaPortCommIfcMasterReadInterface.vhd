-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcMasterReadInterface.vhd
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
--   This block implements the interface between the Read Master Port that sits in
--   "The Window" and the DmaPort connected to NI DMA IP.
--   This component receives requests from MasterPort based on which it sends the
--   arbitration requests to the Output Arbiter. Once the grant is given the requests
--   are sent to the NI DMA IP. The Data interface comming from NI DMA IP is decoded
--   for the "channel number" so that only applicable transfers are sent to the
--   Master Port.
--
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

  -- The package containing the definitions for the FIFO interface signals.
  use work.PkgDmaPortDmaFifos.all;

  -- This package contains stream state definitions.
  use work.PkgDmaPortCommIfcStreamStates.all;

  -- This package contains the definitions for the interface between the NI DMA IP and
  -- the application specific logic
  use work.PkgNiDma.all;

  -- The package containing information on the DmaPort configuration.
  use work.PkgNiDmaConfig.all;

  -- The package containing information on the Comm Ifc configuration.
  use work.PkgCommIntConfiguration.all;

  -- The package contain data types definitions needed to define Master Port interfaces.
  use work.PkgDmaPortCommIfcMasterPort.all;

entity DmaPortCommIfcMasterReadInterface is
    generic(

      kReadMasterPortNumber : natural := 1

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

      bNiFpgaMasterReadRequestToDma : out NiDmaOutputRequestToDma_t;
      bNiFpgaMasterReadRequestFromDma : in NiDmaOutputRequestFromDma_t;
      bNiFpgaMasterReadDataFromDma : in NiDmaOutputDataFromDma_t;

      -------------------------------------------------------------------------
      -- Master Port Write interface
      -------------------------------------------------------------------------

      bNiFpgaMasterReadRequestFromMaster : in NiFpgaMasterReadRequestFromMaster_t;
      bNiFpgaMasterReadRequestToMaster : out NiFpgaMasterReadRequestToMaster_t;
      bNiFpgaMasterReadDataToMaster : out NiFpgaMasterReadDataToMaster_t;

      -------------------------------------------------------------------------
      -- Arbiter signals
      -------------------------------------------------------------------------

      -- bMasterReadArbiterReq  : This is the signal to the arbiter indicating
      --                          that access is requested to the NI DMA IP.
      bMasterReadArbiterReq     : out std_logic;

      -- bMasterReadArbiterDone : This is the signal to the arbiter indicating
      --                          that the current access to Request Interface
      --                          has completed on this clock cycle.
      --                          This is a strobe bit.
      bMasterReadArbiterDone    : out std_logic;

      -- bMasterReadArbiterGrant : This is the signal from the arbiter indicating
      --                           the DMA channel has access to Input Request Interface.
      --                           This stays asserted while the channel has access.
      bMasterReadArbiterGrant    : in  std_logic

    );
end DmaPortCommIfcMasterReadInterface;


architecture rtl of DmaPortCommIfcMasterReadInterface is

  -- kChannel represents the number of the Read Master Port.
  constant kChannel : NiDmaGeneralChannel_t := to_unsigned(kReadMasterPortNumber,
    NiDmaGeneralChannel_t'length);

  signal bNiFpgaMasterReadRequestToDmaNx, bNiFpgaMasterReadRequestToDmaLcl :
    NiDmaOutputRequestToDma_t;

  type ReadRequestState_t is (
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

  signal bReadRequestState, bReadRequestStateNx : ReadRequestState_t := Idle;

begin

  StateReg: process (aReset, BusClk) is
  begin

    if aReset then

      bReadRequestState <= Idle;
      bNiFpgaMasterReadRequestToDmaLcl <= kNiDmaOutputRequestToDmaZero;

    elsif rising_edge(BusClk) then

      bReadRequestState <= bReadRequestStateNx;
      bNiFpgaMasterReadRequestToDmaLcl <= bNiFpgaMasterReadRequestToDmaNx;

    end if;

  end process StateReg;

  bNiFpgaMasterReadRequestToDma <= bNiFpgaMasterReadRequestToDmaLcl;

  --!STATE MACHINE STARTUP!
  -- This state machine Resets to Idle state and only move out of this state when 
  -- bNiFpgaMasterReadRequestFromMaster.Request is true. The Request comes from the
  -- the Master Port and we can assueme the signal resets to false and a request is
  -- issued after a register write to the Master Port Register that cannot occur right
  -- after reset.

  ReadRequestNextStateLogic: process (bReadRequestState, 
    bNiFpgaMasterReadRequestFromMaster, bMasterReadArbiterGrant,
    bNiFpgaMasterReadRequestToDmaLcl, bNiFpgaMasterReadRequestFromDma) is
  begin

    -- Set initial signal values
    bReadRequestStateNx <= bReadRequestState;
    bMasterReadArbiterReq <= '0';
    bMasterReadArbiterDone <= '0';
    bNiFpgaMasterReadRequestToDmaNx <= kNiDmaOutputRequestToDmaZero;
    bNiFpgaMasterReadRequestToMaster.Acknowledge <= false;

    case bReadRequestState is

      when Idle =>

        if bNiFpgaMasterReadRequestFromMaster.Request then
          bMasterReadArbiterReq <= '1';
          bReadRequestStateNx <= WaitForArbiter;
        end if;

      when WaitForArbiter =>

        bMasterReadArbiterReq <= '1';

        if bMasterReadArbiterGrant = '1' then

          bNiFpgaMasterReadRequestToDmaNx.Request <=
            bNiFpgaMasterReadRequestFromMaster.Request;
          bNiFpgaMasterReadRequestToDmaNx.Space <=
            bNiFpgaMasterReadRequestFromMaster.Space;
          bNiFpgaMasterReadRequestToDmaNx.Channel <= kChannel;
          bNiFpgaMasterReadRequestToDmaNx.Address <=
            bNiFpgaMasterReadRequestFromMaster.Address;
          bNiFpgaMasterReadRequestToDmaNx.Baggage <=
            bNiFpgaMasterReadRequestFromMaster.Baggage;
          bNiFpgaMasterReadRequestToDmaNx.ByteSwap <=
            bNiFpgaMasterReadRequestFromMaster.ByteSwap;
          bNiFpgaMasterReadRequestToDmaNx.ByteLane <=
            bNiFpgaMasterReadRequestFromMaster.ByteLane;
          bNiFpgaMasterReadRequestToDmaNx.ByteCount <=
            bNiFpgaMasterReadRequestFromMaster.ByteCount;
          bNiFpgaMasterReadRequestToDmaNx.Done <= false;
          bNiFpgaMasterReadRequestToDmaNx.EndOfRecord <= false;

          bReadRequestStateNx <= SendRequest;

        end if;

      when SendRequest =>

        if bNiFpgaMasterReadRequestFromDma.Acknowledge then
          bMasterReadArbiterDone <= '1';
          bReadRequestStateNx <= Idle;
          bNiFpgaMasterReadRequestToMaster.Acknowledge <= true;
        else

          bMasterReadArbiterReq <= '1';
          bNiFpgaMasterReadRequestToDmaNx <= bNiFpgaMasterReadRequestToDmaLcl;

        end if;

    end case;

  end process ReadRequestNextStateLogic;

  -- The following process decodes the channel number on the Data Interface comming
  -- from NI DMA IP.
  ReadDataFromDmaDecode: process (aReset, BusClk) is
  begin
    if aReset then
      bNiFpgaMasterReadDataToMaster <= kNiFpgaMasterReadDataToMasterZero;
    elsif rising_edge(BusClk) then

      if bNiFpgaMasterReadDataFromDma.DirectChannel(kReadMasterPortNumber) then

        bNiFpgaMasterReadDataToMaster.TransferStart <=
          bNiFpgaMasterReadDataFromDma.TransferStart;
        bNiFpgaMasterReadDataToMaster.TransferEnd <= 
          bNiFpgaMasterReadDataFromDma.TransferEnd;
        bNiFpgaMasterReadDataToMaster.Space <= bNiFpgaMasterReadDataFromDma.Space;
        bNiFpgaMasterReadDataToMaster.ByteLane <= bNiFpgaMasterReadDataFromDma.ByteLane;
        bNiFpgaMasterReadDataToMaster.ByteCount <= bNiFpgaMasterReadDataFromDma.ByteCount;
        bNiFpgaMasterReadDataToMaster.ByteEnable <=
          bNiFpgaMasterReadDataFromDma.ByteEnable;
        bNiFpgaMasterReadDataToMaster.ErrorStatus <=
          bNiFpgaMasterReadDataFromDma.ErrorStatus;
        bNiFpgaMasterReadDataToMaster.Push <= bNiFpgaMasterReadDataFromDma.Push;
        bNiFpgaMasterReadDataToMaster.Data <= bNiFpgaMasterReadDataFromDma.Data;
      else
        bNiFpgaMasterReadDataToMaster <= kNiFpgaMasterReadDataToMasterZero;
      end if;

    end if;
  end process ReadDataFromDmaDecode;


end rtl;
