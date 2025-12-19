-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcSinkStreamDataReceiver.vhd
-- Author: Florin Hurgoi
-- Original Project: LabVIEW FPGA
-- Date: 24 July 2012
--
-------------------------------------------------------------------------------
-- (c) 2008 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   This component implements the logic to receive incoming memory writes from
-- DMA controller and push data associated with this stream into the FIFO.  Since
-- the FIFO supports data packing, this component also controls which bytes
-- are valid on each push to the FIFO.  Memory writes are considered as being
-- targeted for this stream if the destination address lies between the FIFO
-- base address and the base address plus the write window.
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

  -- This package contains the definitions for LabVIEW FPGA specific data
  -- types used in the communication interface
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;

  -- This package contains the definitions for the interface between the DMA Controller
  -- and the application specific logic
  use work.PkgNiDma.all;

entity DmaPortCommIfcSinkStreamDataReceiver is
    generic(

      -- The base memory offset that the sink FIFO is mapped to.
      kFifoBaseOffset : natural;

      -- The length of the memory window that the FIFO is mapped to.
      kWriteWindow : natural := 4096;

      -- kStreamNumber   : This is the stream number associated with the DMA
      --                   channel.
      kStreamNumber      : natural

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

      bHighSpeedSink : in NiDmaHighSpeedSinkFromDma_t;

      -------------------------------------------------------------------------
      -- FIFO signals
      -------------------------------------------------------------------------

      -- bFifoWrite         : This signal is used to strobe data into the FIFO.
      bFifoWrite            : out boolean;

      -- bWriteLengthInBytes: The number of bytes that are being written when
      --                      the write signal is strobed.
      bWriteLengthInBytes   : out NiDmaBusByteCount_t;

      -- bDataIn            : The data being written to the FIFO.
      bFifoData             : out NiDmaData_t;

      bByteEnable           : out NiDmaByteEnable_t;

      -------------------------------------------------------------------------
      -- Register flags
      -------------------------------------------------------------------------

      -- bDisable           : This is a flag from the DMA control register
      --                      indicating that this stream should disable.
      bDisable              : in boolean := true;

      -- bDisabled          : This indicates to the DMA register when the
      --                      stream has actually disabled.
      bDisabled             : out boolean;

      -- bStreamError       : This is a one clock cycle strobe indicating to
      --                      the register component that an error has occurred
      --                      and the stream should alert the driver.
      bStreamError          : out boolean

    );
end DmaPortCommIfcSinkStreamDataReceiver;


architecture rtl of DmaPortCommIfcSinkStreamDataReceiver is

  -----------------------------------------------------------------------------
  -- Registers
  -----------------------------------------------------------------------------
  signal bStartingByteLane, bStartingByteLaneNx : NiDmaByteLane_t;
  signal bFifoWriteNx : boolean;
  signal bFifoDataNx : NiDmaData_t;
  signal bWriteLengthInBytesLoc, bWriteLengthInBytesNx : NiDmaBusByteCount_t;

  -----------------------------------------------------------------------------
  -- Combinatorial signals
  -----------------------------------------------------------------------------
  signal bDisabledNx : boolean;
  signal bByteEnableNx : NiDmaByteEnable_t;
  signal bSinkStreamAddressDecode, bSinkStreamDecodeLower,
    bSinkStreamDecodeUpper  : boolean;


  -----------------------------------------------------------------------------
  -- State machine signals
  -----------------------------------------------------------------------------
  type SinkStreamDataReceiverState_t is (

    -- Idle:              The data receiver is idle while it is disabled or
    --                    while it is waiting for an incoming data packet.  If
    --                    a packet intended for this stream is received, but
    --                    the stream is disabled, then it moves to the
    --                    DiscardData state where the packet is discarded.
    Idle,

    -- ReceiveData:       In this state, the data receiver is receiving data
    --                    points from DmaPort and pushing them into the FIFO.
    ReceiveData,

    -- DiscardData:       The incoming data is received until the end of the
    --                    packet.  The data is not pushed to the FIFO.
    DiscardData

  );

  signal bSinkStreamDataReceiverStateNx, bSinkStreamDataReceiverState :
    SinkStreamDataReceiverState_t;

  signal bDisabledLoc : boolean := true;
begin

  bWriteLengthInBytes <= bWriteLengthInBytesLoc;
  bDisabled <= bDisabledLoc;
  
  -- Registers used by the state machine.
  StateRegs: process(BusClk, aReset)
  begin

    if(aReset) then

      -- We reset to the Idle state.
      bSinkStreamDataReceiverState <= Idle;
      bStartingByteLane <= (others=>'0');
      bFifoWrite <= false;
      bFifoData <= (others=>'0');
      bWriteLengthInBytesLoc <= (others=>'0');
      bByteEnable <= (others=>false);
      bDisabledLoc <= true;

    elsif(rising_edge(BusClk)) then

      bFifoData <= bFifoDataNx;

      -- If bReset occurs, then it is always safe to return to the Idle state,
      -- because the bus itself is being reset.

      if(bReset) then

        bSinkStreamDataReceiverState <= Idle;
        bStartingByteLane <= (others=>'0');
        bFifoWrite <= false;
        bWriteLengthInBytesLoc <= (others=>'0');
        bByteEnable <= (others=>false);
        bDisabledLoc <= true;

      else

        bSinkStreamDataReceiverState <= bSinkStreamDataReceiverStateNx;
        bStartingByteLane <= bStartingByteLaneNx;
        bFifoWrite <= bFifoWriteNx;
        bWriteLengthInBytesLoc <= bWriteLengthInBytesNx;
        bByteEnable <= bByteEnableNx;
        bDisabledLoc <= bDisabledNx;

      end if;

    end if;

  end process StateRegs;


  --!STATE MACHINE STARTUP!
  --This state machine resets to the Idle state and only moves out of that state
  --when it receives a register access on DmaPort.  However, there cannot be
  --a packet available on DmaPort immediately following bus reset.  This is
  --assuming that aReset is used and is tied to the bus reset.

  -- The combinatorial state machine logic
  DmaNextStateLogic: process(bSinkStreamDataReceiverState, bHighSpeedSink,
    bDisable, bSinkStreamAddressDecode, bStartingByteLane, bWriteLengthInBytesLoc)
  begin

    -- Set initial signal values
    bSinkStreamDataReceiverStateNx <= bSinkStreamDataReceiverState;
    bStartingByteLaneNx <= bStartingByteLane;
    bFifoDataNx <= (others=>'0');
    bFifoWriteNx <= false;
    bByteEnableNx <= (others=>false);
    bDisabledNx <= false;
    bStreamError <= false;
    bWriteLengthInBytesNx <= bWriteLengthInBytesLoc;

    case bSinkStreamDataReceiverState is

      -------------------------------------------------------------------------
      -- Idle:            The idle state waits until the stream is enabled
      --                  and a header arrives with an address targeting this
      --                  stream.
      -------------------------------------------------------------------------
      when Idle =>

        if bHighSpeedSink.Push and bSinkStreamAddressDecode then

          if not bHighSpeedSink.TransferEnd then

            if bDisable then
              bSinkStreamDataReceiverStateNx <= DiscardData;

            else
              bFifoWriteNx <= bHighSpeedSink.Push;
              bFifoDataNx <= bHighSpeedSink.Data;
              bByteEnableNx <= bHighSpeedSink.ByteEnable;
              bWriteLengthInBytesNx <= bHighSpeedSink.ByteCount;

              bSinkStreamDataReceiverStateNx <= ReceiveData;

            end if;

          elsif not bDisable then

              bFifoWriteNx <= bHighSpeedSink.Push;
              bFifoDataNx <= bHighSpeedSink.Data;
              bByteEnableNx <= bHighSpeedSink.ByteEnable;
              bWriteLengthInBytesNx <= bHighSpeedSink.ByteCount;

              bStartingByteLaneNx <= resize(bHighSpeedSink.ByteLane +
                bHighSpeedSink.ByteCount, bStartingByteLane'length);

          end if;

          if bHighSpeedSink.ByteLane /= bStartingByteLane then

            bStreamError <= true;
            bFifoWriteNx <= false;
            bStartingByteLaneNx <= bStartingByteLane;

            if not bHighSpeedSink.TransferEnd then

              bSinkStreamDataReceiverStateNx <= DiscardData;

            end if;

          end if;

        end if;

        -- We are disabled while in the Idle state as long as the disable signal
        -- is true.
        bDisabledNx <= bDisable;


      -------------------------------------------------------------------------
      -- ReceiveData:       In this state, the data receiver is receiving data
      --                    points from DmaPort and pushing them into the
      --                    FIFO.
      -------------------------------------------------------------------------
      when ReceiveData =>

        if bHighSpeedSink.Push and bSinkStreamAddressDecode then

          bFifoWriteNx <= bHighSpeedSink.Push;
          bFifoDataNx <= bHighSpeedSink.Data;
          bByteEnableNx <= bHighSpeedSink.ByteEnable;
          bWriteLengthInBytesNx <= bHighSpeedSink.ByteCount;

          if bHighSpeedSink.TransferEnd then

            bStartingByteLaneNx <= resize(bHighSpeedSink.ByteLane + bHighSpeedSink.ByteCount,
              bStartingByteLane'length);
            bSinkStreamDataReceiverStateNx <= Idle;

          end if;

        end if;


      -------------------------------------------------------------------------
      -- DiscardData:       The incoming data is received until the end of the
      --                    packet.  The data is not pushed to the FIFO.
      -------------------------------------------------------------------------
      when DiscardData =>

        if bHighSpeedSink.TransferEnd and bSinkStreamAddressDecode then

          bSinkStreamDataReceiverStateNx <= Idle;

        end if;

        -- The stream is always disabled while discarding data.
        bDisabledNx <= true;


      when Others =>

        bSinkStreamDataReceiverStateNx <= Idle;

    end case;

  end process DmaNextStateLogic;

  -- Check to see if the packet is destined for this FIFO's memory space.
  bSinkStreamAddressDecode <= bSinkStreamDecodeLower and bSinkStreamDecodeUpper;
  bSinkStreamDecodeLower <= bHighSpeedSink.Address >= kFifoBaseOffset;
  bSinkStreamDecodeUpper <= bHighSpeedSink.Address < kFifoBaseOffset + kWriteWindow;

end architecture rtl;