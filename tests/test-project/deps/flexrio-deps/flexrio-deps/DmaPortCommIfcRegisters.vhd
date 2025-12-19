-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcRegisters.vhd
-- Author: Matthew Koenn
-- Original Project: LabVIEW FPGA
-- Date: 5 October 2007
--
-------------------------------------------------------------------------------
-- (c) 2007 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   This component implements the DMA registers that will be used by both the
--   input and output DMA stream circuits.  Flags are output for both reset and
--   disable requests, and flags are input for the completion status of resets
--   and disables.  Also, the SATCR value is output to the controller so that
--   it can determine the size of packets it can send, and a decrement flag is
--   input from the controller to notify when to decrement SATCR.  The
--   decrement amount input controls how many samples to decrement the SATCR.
--   This field will be hardcoded while bit packing is not implemented, since
--   the SATCR will always decrement by a constant amount.  However, when bit
--   packing in the FIFOs is enabled, this field will need to indicate the
--   number of samples sent, which could be variable.  Additionally, there is
--   a synchronous reset input that will be derived from the PCI-e reset
--   signal.
--
--   A detailed description of the register map is available in the package
--   file PkgDmaRegs.vhd.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

  -- This package contains the register and bit field definitions for the DMA
  -- register map.
  use work.PkgDmaPortCommIfcRegs.all;

  -- This package contains the definitions for the LabVIEW FPGA register
  -- framework signals
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;

  use work.PkgDmaPortCommIfcStreamStates.all;

  use work.PkgNiDma.all;

entity DmaPortCommIfcRegisters is
  generic (
    kBaseOffset : natural := 16#50#;
    kInputStream : boolean := false;
    kPeerToPeerStream : boolean := false;
    kMaxTransfer: natural
  );
  port (

    -- aReset      : This is the asynchronous reset signal derived from the
    --              diagram reset.
    aReset         : in  boolean;

    -- bReset      : This is the synchronous reset signal derived from the
    --               PCI-e reset signal.
    bReset         : in  boolean;

    -- BusClk      : This is the CHInCh transmit clock.
    BusClk         : in  std_logic;


    ---------------------------------------------------------------------------
    -- Register port signals
    ---------------------------------------------------------------------------

    -- bRegPortIn  : These are the register interface signals used to perform
    --               read and write accesses to the DMA registers.
    bRegPortIn     : in  RegPortIn_t;

    -- bRegPortOut : These are the register interface signals used to respond
    --               to read/write requests from the RegisterAccess component.
    --               These signals are AND'd or OR'd with the register out
    --               signals from the other register clients, as appropriate.
    bRegPortOut    : out RegPortOut_t;


    ---------------------------------------------------------------------------
    -- Flags
    ---------------------------------------------------------------------------

    -- bHostEnable : This is a one clock cycle strobe indicating when the host initiates
    --               a stream start.
    bHostEnable    : out boolean;

    -- bHostDisable: This is a one clock cycle strobe indicating when the host initiates
    --               a stream stop.
    bHostDisable   : out boolean;

    -- bHostFlush  : This is a one clock cycle strobe indicating when the host initiates
    --               a stop and flush.
    bHostFlush     : out boolean;

    -- bDisabled   : This is the disabled flag coming from the controller,
    --               indicating that the stream circuit has been disabled.
    --               This means that all transactions that have started
    --               have been completed and the stream has quiessed.
    bDisabled      : in  boolean;

    -- bDmaReset   : This is the reset request flag indicating to the enable
    --               circuitry that a DMA stream reset has been issued by a
    --               write to the reset bit.  Note that this flag will not be
    --               issued until the stream has been disabled, since
    --               resetting the FIFO while performing a transaction could
    --               could cause problems.
    bDmaReset      : out boolean;

    -- bResetDone  : This is the input flag indicating that the reset has been
    --               performed successfully.  This signal comes from the enable
    --               circuitry.
    bResetDone     : in  boolean;

    -- bFifoOverflow: This is a one clock cycle strobe indicating when an overflow
    --                occurs on the user diagram.
    bFifoOverflow  : in  boolean;

    -- bFifoUnderflow : This is a one clock cycle strobe indicating when an underflow
    --                  occurs on the user diagram.
    bFifoUnderflow : in boolean;

    -- bStartChannelRequest : This is a one clock cycle strobe indicating when the
    --                        user diagram has requested a channel start.
    bStartChannelRequest : in boolean;

    -- bStopChannelRequest : This is a one clock cycle strobe indicating when the
    --                       user diagram has requested a channel stop.
    bStopChannelRequest : in boolean;

    -- bFlushIrqStrobe : This is a one clock cycle strobe indicating when the state
    --                   has transitioned to the flushing state due to a user diagram
    --                   initiated stop and flush.  This should set the flush IRQ.
    bFlushIrqStrobe : in boolean;

    -- bClearEnableIrq : This signal is strobed for one clock cycle whenever the
    --                   enable IRQ should be cleared.
    bClearEnableIrq : in boolean;

    -- bClearDisableIrq : This signal is strobed for one clock cycle whenever the
    --                    disable IRQ should be cleared.
    bClearDisableIrq : in boolean;

    -- bClearFlushingIrq    : This signal is strobed for one clock cycle whenever the
    --                        flushing IRQ should be cleared.
    bClearFlushingIrq : in boolean;

    -- bSetFlushingStatus : This signal is strobed for one clock cycle whenever
    --                    the flushing status bit should be set.
    bSetFlushingStatus    : in boolean;

    -- bClearFlushingStatus : This signal is strobed for one clock cycle whenever
    --                        the flushing status bit should be cleared.
    bClearFlushingStatus    : in boolean;

    -- bSetFlushingFailedStatus : This signal is strobed for one clock cycle whenever
    --                            the flushing failed status bit should be set.
    bSetFlushingFailedStatus    : in boolean;

    -- bClearFlushingFailedStatus : This signal is strobed for one clock cycle whenever
    --                              the flushing failed status bit should be cleared.
    bClearFlushingFailedStatus    : in boolean;

    -- bSatcrWriteEvent : This is a one clock cycle strobe indicating that the SATCR
    --                    has been written.  This is used by the stream state
    --                    controller to determine when a source stream can start.
    bSatcrWriteEvent : out boolean;

    -- bClearSatcr : This is a one clock cycle strobe instructing the SATCR register
    --               to reset its value to zero.
    bClearSatcr : in boolean;

    -- bStreamError : This is a one clock cycle strobe indicating to
    --                the register component that an error has occurred
    --                and the stream should alert the driver.
    bStreamError    : in boolean;


    ---------------------------------------------------------------------------
    -- SATCR signals
    ---------------------------------------------------------------------------

    -- bMaxPktSize     : This is the maximum packet size that can be sent at
    --                   any given time.  This is the minimum of the max packet
    --                   size and the SATCR value.
    bMaxPktSize        : out unsigned(Log2(kMaxTransfer) downto 0);

    -- bRsrvWriteSpaces: This is the flag indicating when to update the number
    --                   of reserved spaces for the reserved SATCR.
    bSatcrWriteStrobe  : in boolean;

    -- bReqWriteSpaces : This is the number of spaces by which to decrement the
    --                   reserved SATCR.
    bReqWriteSpaces    : in unsigned(Log2(kMaxTransfer) downto 0);


    ---------------------------------------------------------------------------
    -- Status signals
    ---------------------------------------------------------------------------

    -- bFifoCount      : This is the FIFO full count (regardless of stream
    --                   direction).
    bFifoCount         : in unsigned;

    -- bPeerAddress    : For a sink stream, this is the address of the source's
    --                   TCR.  If this is not a sink stream, this value is
    --                   simply set to zero and should not be used anywhere.
    bPeerAddress       : out NiDmaAddress_t;

    -- bState          : The current value of the stream state.
    bState             : in StreamStateValue_t;

    -- bLinked         : This boolean indicates whether or not the host has
    --                   put the stream in the linked state.
    bLinked            : out boolean;

    -- bSatcrUpdatesEnabled : This boolean indicates whether or not a sink
    --                        stream's ability to update the SATCR address in
    --                        the corresponding source is enabled.
    bSatcrUpdatesEnabled : out boolean;

    ---------------------------------------------------------------------------
    -- IRQ signals
    ---------------------------------------------------------------------------

    -- bIrq            : This is the DMA channel's IRQ status to report to the
    --                   communication interface interrupt handler.
    bIrq               : out IrqStatusToInterface_t

  );
end DmaPortCommIfcRegisters;

architecture behavior of DmaPortCommIfcRegisters is

  constant kSinkStream : boolean := (not kInputStream) and kPeerToPeerStream;
  constant kSourceStream : boolean := kInputStream and kPeerToPeerStream;

  -- The reset registers is set to 1 when the reset bit is set, and it clears
  -- when the reset done signal goes true.  This bit clears on reset.
  signal bDmaResetReg : boolean;

  signal bInterruptStatusReg : InterfaceData_t;

  -- The reserve SATCR register value.  The reserve SATCR is decremented by the
  -- RsrvWriteSpaces signal for the output stream, whereas the normal SATCR is
  -- decremented as points are pushed or popped for an output or input stream.
  signal bSatcr : unsigned(31 downto 0);

  signal bSatcrResetNx : boolean;
  signal bSatcrReset : boolean;

  signal bStatusDecode, bSatcrDecode, bControlDecode, bFifoCountDecode,
         bInterruptStatusDecode, bInterruptMaskDecode,
         bPeerAddressHighDecode, bPeerAddressLowDecode, bPacketAlignmentDecode,
         bMaxPayloadSizeDecode : boolean;
         
  signal bStatusDecodeNx, bSatcrDecodeNx, bControlDecodeNx, bFifoCountDecodeNx,
         bInterruptStatusDecodeNx, bInterruptMaskDecodeNx,
         bPeerAddressHighDecodeNx, bPeerAddressLowDecodeNx, bPacketAlignmentDecodeNx,
         bMaxPayloadSizeDecodeNx : boolean;

  signal bMaskRegReadValue : InterfaceData_t;

  signal bPeerAddressReg : NiDmaAddress_t;

  signal bOverflowStatusReg, bUnderflowStatusReg : boolean;

  signal bSatcrUpdatesEnabledReg : boolean := BitFieldInitValue(SatcrUpdateStatus);
  signal bFlushingStatus : boolean := BitFieldInitValue(FlushingStatus);
  signal bFlushingFailedStatus : boolean := BitFieldInitValue(FlushingFailedStatus);
  signal bStreamErrorStatusReg : boolean := BitFieldInitValue(StreamErrorStatus);
  signal bEnableAlignment : boolean := BitFieldInitValue(EnableAlignment);
  signal bMaxPayloadSize : unsigned(bMaxPktSize'range)
    := to_unsigned(kMaxTransfer, bMaxPktSize'length);
  signal bSatcrWriteEventLcl: std_logic;
  signal bBytesToAlignment : unsigned(Log2(kMaxTransfer) downto 0) :=
    to_unsigned(kMaxTransfer, Log2(kMaxTransfer)+1);
    
  signal bDisabledReg : boolean;

begin

  -- We should only assert the DMA reset signal when the stream is disabled.
  -- If we try to reset while the stream is enabled, it's possible that the
  -- stream is in the process of performing a transmission, and if we reset
  -- the FIFO, we will lose the data we still need to send.  This should not
  -- create any deadlock situations, since the disable signal is true whenever
  -- the reset register is set.
  bDmaReset <= bDmaResetReg and bDisabledReg;
  
  process (aReset, BusClk)
  begin
    if aReset then
      bDisabledReg <= false;
    elsif rising_edge(BusClk) then
      bDisabledReg <= bDisabled;
    end if;
  end process;


  ---------------------------------------------------------------------------------------
  -- Interrupt Block
  ---------------------------------------------------------------------------------------
  InterruptRegister: block is

    -- Interrupt status signals.
    signal bOverflowStatus, bOverflowStatusNx : boolean;
    signal bUnderflowStatus, bUnderflowStatusNx : boolean;
    signal bStartStreamStatus, bStartStreamStatusNx : boolean;
    signal bStopStreamStatus, bStopStreamStatusNx : boolean;
    signal bFlushingStatus, bFlushingStatusNx : boolean;
    signal bStreamErrorStatus, bStreamErrorStatusNx : boolean;

    -- Interrupt mask signals.
    signal bOverflowMask, bOverflowMaskNx : boolean;
    signal bUnderflowMask, bUnderflowMaskNx : boolean;
    signal bStartStreamMask, bStartStreamMaskNx : boolean;
    signal bStopStreamMask, bStopStreamMaskNx : boolean;
    signal bFlushingMask, bFlushingMaskNx : boolean;
    signal bStreamErrorMask, bStreamErrorMaskNx : boolean;

    signal bIrqNx : IrqStatusToInterface_t;

  begin

    WriteInterruptRegs: process(aReset, BusClk)
    begin
      if aReset then

        -- Set initial IRQ status values
        bOverflowStatus <= BitFieldInitValue(OverflowIrq);
        bUnderflowStatus <= BitFieldInitValue(UnderflowIrq);
        bStartStreamStatus <= BitFieldInitValue(StartStreamIrq);
        bStopStreamStatus <= BitFieldInitValue(StopStreamIrq);
        bFlushingStatus <= BitFieldInitValue(FlushingIrq);
        bStreamErrorStatus <= BitFieldInitValue(StreamErrorIrq);

        -- Set initial IRQ mask values
        bOverflowMask <= false;
        bUnderflowMask <= false;
        bStartStreamMask <= false;
        bStopStreamMask <= false;
        bFlushingMask <= false;
        bStreamErrorMask <= false;

        bIrq <= kIrqStatusToInterfaceZero;

      elsif rising_edge(BusClk) then

        -- For a synchronous reset, we hit the bit in the reset register to
        -- perform the reset to the rest of the DMA circuit.
        if bReset then
          bOverflowStatus <= BitFieldInitValue(OverflowIrq);
          bUnderflowStatus <= BitFieldInitValue(UnderflowIrq);
          bStartStreamStatus <= BitFieldInitValue(StartStreamIrq);
          bStopStreamStatus <= BitFieldInitValue(StopStreamIrq);
          bFlushingStatus <= BitFieldInitValue(FlushingIrq);
          bStreamErrorStatus <= BitFieldInitValue(StreamErrorIrq);
          bOverflowMask <= false;
          bUnderflowMask <= false;
          bStartStreamMask <= false;
          bStopStreamMask <= false;
          bFlushingMask <= false;
          bStreamErrorMask <= false;
          bIrq <= kIrqStatusToInterfaceZero;
        else
          bOverflowStatus <= bOverflowStatusNx;
          bUnderflowStatus <= bUnderflowStatusNx;
          bStartStreamStatus <= bStartStreamStatusNx;
          bStopStreamStatus <= bStopStreamStatusNx;
          bFlushingStatus <= bFlushingStatusNx;
          bStreamErrorStatus <= bStreamErrorStatusNx;
          bOverflowMask <= bOverflowMaskNx;
          bUnderflowMask <= bUnderflowMaskNx;
          bStartStreamMask <= bStartStreamMaskNx;
          bStopStreamMask <= bStopStreamMaskNx;
          bFlushingMask <= bFlushingMaskNx;
          bStreamErrorMask <= bStreamErrorMaskNx;
          bIrq <= bIrqNx;
        end if;

      end if;
    end process WriteInterruptRegs;

    -- Determine the next value for the registers
    WriteInterruptRegsNx: process(bRegPortIn, bStartChannelRequest, bStopChannelRequest,
                         bFlushIrqStrobe, bOverflowStatus, bUnderflowStatus,
                         bStartStreamStatus, bStopStreamStatus, bFlushingStatus,
                         bOverflowMask, bUnderflowMask, bStartStreamMask,
                         bStopStreamMask, bFlushingMask, bDmaResetReg,
                         bInterruptStatusDecode, bFifoOverflow, bFifoUnderflow,
                         bInterruptMaskDecode, bStreamErrorMask, bStreamErrorStatus,
                         bStreamError, bClearEnableIrq, bClearDisableIrq,
                         bClearFlushingIrq)
    begin

      bOverflowStatusNx <= bOverflowStatus;
      bUnderflowStatusNx <= bUnderflowStatus;
      bStartStreamStatusNx <= bStartStreamStatus;
      bStopStreamStatusNx <= bStopStreamStatus;
      bFlushingStatusNx <= bFlushingStatus;
      bStreamErrorStatusNx <= bStreamErrorStatus;

      bOverflowMaskNx <= bOverflowMask;
      bUnderflowMaskNx <= bUnderflowMask;
      bStartStreamMaskNx <= bStartStreamMask;
      bStopStreamMaskNx <= bStopStreamMask;
      bFlushingMaskNx <= bFlushingMask;
      bStreamErrorMaskNx <= bStreamErrorMask;

      bIrqNx.Clear <= '0';

      -- Reset the interrupt register when the DMA reset is asserted.
      if bDmaResetReg then

        bOverflowStatusNx <= BitFieldInitValue(OverflowIrq);
        bUnderflowStatusNx <= BitFieldInitValue(UnderflowIrq);
        bStartStreamStatusNx <= BitFieldInitValue(StartStreamIrq);
        bStopStreamStatusNx <= BitFieldInitValue(StopStreamIrq);
        bFlushingStatusNx <= BitFieldInitValue(FlushingIrq);
        bStreamErrorStatusNx <= BitFieldInitValue(StreamErrorIrq);

        bOverflowMaskNx <= false;
        bUnderflowMaskNx <= false;
        bStartStreamMaskNx <= false;
        bStopStreamMaskNx <= false;
        bFlushingMaskNx <= false;
        bStreamErrorMaskNx <= false;

        bIrqNx.Clear <= '0';

      else

        -- Handle register writes to the interrupt register
        if bRegPortIn.Wt and bInterruptStatusDecode then

          -- Re-evaluate the IRQ line whenever there is a write to the IRQ
          -- status register.
          bIrqNx.Clear <= '1';

          if(bRegPortIn.Data(BitFieldIndex(OverflowIrq)) = '1') then
            bOverflowStatusNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(UnderflowIrq)) = '1') then
            bUnderflowStatusNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(StartStreamIrq)) = '1') then
            bStartStreamStatusNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(StopStreamIrq)) = '1') then
            bStopStreamStatusNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(FlushingIrq)) = '1') then
            bFlushingStatusNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(StreamErrorIrq)) = '1') then
            bStreamErrorStatusNx <= false;
          end if;

        end if;


        -- Set the interrupt status bits as the flags are asserted.  This comes after
        -- the register write assignments so that setting the interrupts takes priority
        -- over clearing the interrupts.
        if bFifoOverflow then
          bOverflowStatusNx <= true;
        end if;
        if bFifoUnderflow then
          bUnderflowStatusNx <= true;
        end if;
        if bStartChannelRequest then
          bStartStreamStatusNx <= true;
        end if;
        if bStopChannelRequest then
          bStopStreamStatusNx <= true;
        end if;
        if bFlushIrqStrobe then
          bFlushingStatusNx <= true;
        end if;
        if bStreamError then
          bStreamErrorStatusNx <= true;
        end if;

        -- Clear the state transition request IRQs from the state controller.  This is
        -- done last since it should take priority over the requests themselves setting
        -- the IRQ.
        if bClearEnableIrq then
          bStartStreamStatusNx <= false;
        end if;
        if bClearDisableIrq then
          bStopStreamStatusNx <= false;
        end if;
        if bClearFlushingIrq then
          bFlushingStatusNx <= false;
        end if;


        -- Set the mask register values when the mask register is written to.
        if bRegPortIn.Wt and bInterruptMaskDecode then

          if(bRegPortIn.Data(BitFieldIndex(EnableOverflowIrq)) = '1') then
            bOverflowMaskNx <= true;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(EnableUnderflowIrq)) = '1') then
            bUnderflowMaskNx <= true;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(EnableStartStreamIrq)) = '1') then
            bStartStreamMaskNx <= true;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(EnableStopStreamIrq)) = '1') then
            bStopStreamMaskNx <= true;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(EnableFlushingIrq)) = '1') then
            bFlushingMaskNx <= true;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(EnableStreamErrorIrq)) = '1') then
            bStreamErrorMaskNx <= true;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(DisableOverflowIrq)) = '1') then
            bOverflowMaskNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(DisableUnderflowIrq)) = '1') then
            bUnderflowMaskNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(DisableStartStreamIrq)) = '1') then
            bStartStreamMaskNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(DisableStopStreamIrq)) = '1') then
            bStopStreamMaskNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(DisableFlushingIrq)) = '1') then
            bFlushingMaskNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(DisableStreamErrorIrq)) = '1') then
            bStreamErrorMaskNx <= false;
          end if;

        end if;

      end if;
    end process WriteInterruptRegsNx;

    -- This is the value that is read when the interrupt status register is read.
    SetInterruptStatusValue: process(bOverflowStatus, bUnderflowStatus,
                                     bStartStreamStatus, bStopStreamStatus,
                                     bFlushingStatus, bStreamErrorStatus, bOverflowMask,
                                     bUnderflowMask, bStartStreamMask, bStopStreamMask,
                                     bFlushingMask, bStreamErrorMask)
    begin
      bInterruptStatusReg <= (others=>'0');
      bInterruptStatusReg(BitFieldIndex(OverflowIrq)) <=
        to_StdLogic(bOverflowStatus and bOverflowMask);
      bInterruptStatusReg(BitFieldIndex(UnderflowIrq)) <=
        to_StdLogic(bUnderflowStatus and bUnderflowMask);
      bInterruptStatusReg(BitFieldIndex(StartStreamIrq)) <=
        to_StdLogic(bStartStreamStatus and bStartStreamMask);
      bInterruptStatusReg(BitFieldIndex(StopStreamIrq)) <=
        to_StdLogic(bStopStreamStatus and bStopStreamMask);
      bInterruptStatusReg(BitFieldIndex(FlushingIrq)) <=
        to_StdLogic(bFlushingStatus and bFlushingMask);
      bInterruptStatusReg(BitFieldIndex(StreamErrorIrq)) <=
        to_StdLogic(bStreamErrorStatus and bStreamErrorMask);
    end process SetInterruptStatusValue;

    -- The IRQ status line is the OR of the individual interrupts.
    bIrqNx.Status <= to_StdLogic((bOverflowStatus and bOverflowMask) or
                                 (bUnderflowStatus and bUnderflowMask) or
                                 (bStartStreamStatus and bStartStreamMask) or
                                 (bStopStreamStatus and bStopStreamMask) or
                                 (bFlushingStatus and bFlushingMask) or
                                 (bStreamErrorStatus and bStreamErrorMask));


    -- Build the value read from the interrupt mask register.
    SetMaskRegReadValue: process(bOverflowMask, bUnderflowMask, bStartStreamMask,
                                 bStopStreamMask, bFlushingMask, bStreamErrorMask)
    begin
      bMaskRegReadValue <= (others=>'0');
      bMaskRegReadValue(BitFieldIndex(OverflowIrqMaskStatus)) <=
        to_StdLogic(bOverflowMask);
      bMaskRegReadValue(BitFieldIndex(UnderflowIrqMaskStatus)) <=
        to_StdLogic(bUnderflowMask);
      bMaskRegReadValue(BitFieldIndex(StartStreamIrqMaskStatus)) <=
        to_StdLogic(bStartStreamMask);
      bMaskRegReadValue(BitFieldIndex(StopStreamIrqMaskStatus)) <=
        to_StdLogic(bStopStreamMask);
      bMaskRegReadValue(BitFieldIndex(FlushingIrqMaskStatus)) <=
        to_StdLogic(bFlushingMask);
      bMaskRegReadValue(BitFieldIndex(StreamErrorIrqMaskStatus)) <=
        to_StdLogic(bStreamErrorMask);
    end process SetMaskRegReadValue;

  end block InterruptRegister;



  ---------------------------------------------------------------------------------------
  -- Control/Status Register
  ---------------------------------------------------------------------------------------
  ControlStatusRegister: block is

    signal bDmaResetRegNx : boolean;
    signal bLinkedReg, bLinkedRegNx : boolean;
    signal bHostEnableReg, bHostEnableRegNx : boolean;
    signal bHostDisableReg, bHostDisableRegNx : boolean;
    signal bHostFlushReg, bHostFlushRegNx : boolean;
    signal bOverflowStatusRegNx, bUnderflowStatusRegNx : boolean;
    signal bSatcrUpdatesEnabledRegNx : boolean;
    signal bFlushingStatusNx, bFlushingFailedStatusNx : boolean;
    signal bStreamErrorStatusRegNx : boolean;

  begin

    bLinked <= bLinkedReg;
    bHostEnable <= bHostEnableReg;
    bHostDisable <= bHostDisableReg;
    bHostFlush <= bHostFlushReg;
    bSatcrUpdatesEnabled <= bSatcrUpdatesEnabledReg;

    ControlStatusWriteRegs: process(aReset, BusClk)
    begin
      if aReset then

        -- Set initial register values
        bDmaResetReg <= BitFieldInitValue(ResetStatus);
        bLinkedReg <= false;
        bHostEnableReg <= false;
        bHostDisableReg <= false;
        bHostFlushReg <= false;
        bOverflowStatusReg <= false;
        bUnderflowStatusReg <= false;
        bSatcrUpdatesEnabledReg <= BitFieldInitValue(SatcrUpdateStatus);
        bFlushingStatus <= BitFieldInitValue(FlushingStatus);
        bFlushingFailedStatus <= BitFieldInitValue(FlushingFailedStatus);
        bStreamErrorStatusReg <= BitFieldInitValue(StreamErrorStatus);

      elsif rising_edge(BusClk) then

        -- For a synchronous reset, we hit the bit in the reset register to
        -- perform the reset to the rest of the DMA circuit.
        if bReset then
          bDmaResetReg <= BitFieldInitValue(ResetStatus);
          bLinkedReg <= false;
          bHostEnableReg <= false;
          bHostDisableReg <= false;
          bHostFlushReg <= false;
          bOverflowStatusReg <= false;
          bUnderflowStatusReg <= false;
          bSatcrUpdatesEnabledReg <= BitFieldInitValue(SatcrUpdateStatus);
          bFlushingStatus <= BitFieldInitValue(FlushingStatus);
          bFlushingFailedStatus <= BitFieldInitValue(FlushingFailedStatus);
          bStreamErrorStatusReg <= BitFieldInitValue(StreamErrorStatus);
        else
          bDmaResetReg <= bDmaResetRegNx;
          bLinkedReg <= bLinkedRegNx;
          bHostEnableReg <= bHostEnableRegNx;
          bHostDisableReg <= bHostDisableRegNx;
          bHostFlushReg <= bHostFlushRegNx;
          bOverflowStatusReg <= bOverflowStatusRegNx;
          bUnderflowStatusReg <= bUnderflowStatusRegNx;
          bSatcrUpdatesEnabledReg <= bSatcrUpdatesEnabledRegNx;
          bFlushingStatus <= bFlushingStatusNx;
          bFlushingFailedStatus <= bFlushingFailedStatusNx;
          bStreamErrorStatusReg <= bStreamErrorStatusRegNx;
        end if;

      end if;
    end process ControlStatusWriteRegs;

    -- Determine the next value for the registers
    ControlStatusWriteRegsNx: process(bDmaResetReg, bResetDone, bDisabled,
                                      bFifoOverflow, bFifoUnderflow, bRegPortIn,
                                      bControlDecode, bReqWriteSpaces, bLinkedReg,
                                      bOverflowStatusReg, bUnderflowStatusReg,
                                      bSatcrUpdatesEnabledReg, bClearFlushingStatus,
                                      bSetFlushingStatus, bClearFlushingFailedStatus,
                                      bSetFlushingFailedStatus, bFlushingStatus,
                                      bFlushingFailedStatus, bStreamError,
                                      bStreamErrorStatusReg)
    begin

      bDmaResetRegNx <= bDmaResetReg;
      bSatcrResetNx <= false;
      bLinkedRegNx <= bLinkedReg;
      bOverflowStatusRegNx <= bOverflowStatusReg;
      bUnderflowStatusRegNx <= bUnderflowStatusReg;
      bSatcrUpdatesEnabledRegNx <= bSatcrUpdatesEnabledReg;
      bFlushingStatusNx <= bFlushingStatus;
      bFlushingFailedStatusNx <= bFlushingFailedStatus;
      bStreamErrorStatusRegNx <= bStreamErrorStatusReg;

      -- These are strobe bits.  They get set for one clock cycle to notify the state
      -- controller when the host hits the enable, disable, or flush and disable bits.
      bHostEnableRegNx <= false;
      bHostDisableRegNx <= false;
      bHostFlushRegNx <= false;

      -- Clear the reset bit when the reset is complete
      if bResetDone then
        bDmaResetRegNx <= false;
      end if;

      -- Handle resetting the registers when the reset bit is set.  While the
      -- reset bit is set, we don't allow any other register writes until
      -- reset is complete.
      if bDmaResetReg then

        bLinkedRegNx <= false;
        bSatcrResetNx <= true;
        bOverflowStatusRegNx <= false;
        bUnderflowStatusRegNx <= false;
        bSatcrUpdatesEnabledRegNx <= BitFieldInitValue(SatcrUpdateStatus);
        bStreamErrorStatusRegNx <= BitFieldInitValue(StreamErrorStatus);

      else

        -- Handle writes to the control register
        if bRegPortIn.Wt and bControlDecode then

          -- If disable is being set, then clear the disable output.  If enable
          -- and disable bits are both set simultaneously, give priority to
          -- disable.  Set the flushing bit accordingly, but give priority to a stop
          -- without flush.
          if bRegPortIn.Data(BitFieldIndex(StopChannel)) = '1' then
            bHostDisableRegNx <= true;
          elsif bRegPortIn.Data(BitFieldIndex(StopChannelWithFlush)) = '1' then
            bHostFlushRegNx <= true;
          elsif bRegPortIn.Data(BitFieldIndex(StartChannel)) = '1' then
            bHostEnableRegNx <= true;

            -- If the host sets the start bit then the stream must be linked, so
            -- set linked to true also.
            bLinkedRegNx <= true;

          end if;

          -- If the reset bit is being set, then set the reset register
          if(bRegPortIn.Data(BitFieldIndex(Reset)) = '1') then
            bDmaResetRegNx <= true;
          end if;

          -- If the SATCR reset bit is being set, then clear SATCR.  This is
          -- only allowed while the channel is disabled.
          if(bRegPortIn.Data(BitFieldIndex(ResetSatcr)) = '1' and bDisabled) then
            bSatcrResetNx <= true;
          end if;

          -- Set the linked status with priority given to unlinking.
          if(bRegPortIn.Data(BitFieldIndex(UnlinkStream)) = '1') then
            bLinkedRegNx <= false;
          elsif(bRegPortIn.Data(BitFieldIndex(LinkStream)) = '1') then
            bLinkedRegNx <= true;
          end if;

          -- Clear the overflow and underflow status registers whenever the corresponding
          -- clear bits are written in the control register.
          if(bRegPortIn.Data(BitFieldIndex(ClearOverflowStatus)) = '1') then
            bOverflowStatusRegNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(ClearUnderflowStatus)) = '1') then
            bUnderflowStatusRegNx <= false;
          end if;

          -- Clear the flushing and flushing failed status registers whenever the
          -- corresponding clear bits are written in the control register.
          if bRegPortIn.Data(BitFieldIndex(ClearFlushingStatus)) = '1' then
            bFlushingStatusNx <= false;
          end if;
          if bRegPortIn.Data(BitFieldIndex(ClearFlushingFailedStatus)) = '1' then
            bFlushingFailedStatusNx <= false;
          end if;

          -- Enable or disable the SATCR update whenever the corresponding bits are set.
          -- For P2P sink streams, this refers to disabling the SATCR updates going to the
          -- P2P source.
          -- For regular input & output DMA streams, this refers to the SATCR
          -- Enable/Disable feature (for RF List Mode).
          if kSinkStream or not kPeerToPeerStream then
            if(bRegPortIn.Data(BitFieldIndex(EnableSatcrUpdates)) = '1') then
              bSatcrUpdatesEnabledRegNx <= true;
            end if;
            if(bRegPortIn.Data(BitFieldIndex(DisableSatcrUpdates)) = '1') then
              bSatcrUpdatesEnabledRegNx <= false;
            end if;
          end if;

          if bRegPortIn.Data(BitFieldIndex(ClearStreamErrorStatus)) = '1' then
            bStreamErrorStatusRegNx <= false;
          end if;

        end if;

        -- Set the overflow and underflow bits when the events occur.  This takes
        -- priority over clearing the bits.
        if bFifoOverflow then
          bOverflowStatusRegNx <= true;
        end if;
        if bFifoUnderflow then
          bUnderflowStatusRegNx <= true;
        end if;

        -- Set the values for the flushing and flushing status bits.
        if bClearFlushingStatus then
          bFlushingStatusNx <= false;
        elsif bSetFlushingStatus then
          bFlushingStatusNx <= true;
        end if;

        if bClearFlushingFailedStatus then
          bFlushingFailedStatusNx <= false;
        elsif bSetFlushingFailedStatus then
          bFlushingFailedStatusNx <= true;
        end if;

        if bStreamError then
          bStreamErrorStatusRegNx <= true;
        end if;

      end if;

    end process ControlStatusWriteRegsNx;

  end block ControlStatusRegister;
  
  -- SatcrResetReg : --------------------------------------------------------------------
  -- This process registers the 'bSatcrReset' field of the Control register.
  ---------------------------------------------------------------------------------------
  SatcrResetReg : process(aReset, BusClk)
  begin
    if aReset then
      bSatcrReset <= false;
    elsif rising_edge(BusClk) then
      bSatcrReset <= bSatcrResetNx;
    end if;
  end process SatcrResetReg;


  ---------------------------------------------------------------------------------------
  -- Peer Address register
  ---------------------------------------------------------------------------------------
  SinkStreamRegs: if kSinkStream generate

    signal bPeerAddressRegNx : NiDmaAddress_t;

  begin

    WritePeerRegs: process(aReset, BusClk)
    begin
      if aReset then
        -- Set initial register values
        bPeerAddressReg <= (others => '0');
      elsif rising_edge(BusClk) then
        -- For a synchronous reset, we hit the bit in the reset register to
        -- perform the reset to the rest of the DMA circuit.
        if bReset then
          bPeerAddressReg <= (others => '0');
        else
          bPeerAddressReg <= bPeerAddressRegNx;
        end if;
      end if;
    end process WritePeerRegs;

    -- Determine the next value for the registers
    WritePeerRegsNx: process(bPeerAddressReg, bDmaResetReg, bRegPortIn, bPeerAddressRegNx,
                             bPeerAddressHighDecode, bPeerAddressLowDecode)
    begin

      bPeerAddressRegNx <= bPeerAddressReg;

      -- Handle resetting the registers when the reset bit is set.  While the
      -- reset bit is set, we don't allow any other register writes until
      -- reset is complete.
      if bDmaResetReg then

        bPeerAddressRegNx <= (others=>'0');

      else

        -- Handle writes to the peer address register
        if bRegPortIn.Wt and bPeerAddressLowDecode then
          bPeerAddressRegNx(Smaller(bRegPortIn.Data'left, bPeerAddressRegNx'left) downto 0) <= 
            unsigned(bRegPortIn.Data(Smaller(bRegPortIn.Data'left, bPeerAddressRegNx'left) downto 0));
        elsif bRegPortIn.Wt and bPeerAddressHighDecode then
          bPeerAddressRegNx <= resize(unsigned(bRegPortIn.Data) &
                               bPeerAddressReg(bRegPortIn.Data'left downto 0),
                               bPeerAddressRegNx'length);
        end if;

      end if;

    end process WritePeerRegsNx;

  end generate;

  NoSinkStreamRegs: if not kSinkStream generate
  begin

    bPeerAddressReg <= (others=>'0');

  end generate;

  bPeerAddress <= bPeerAddressReg;


  ---------------------------------------------------------------------------------------
  -- Packet Alignment Register
  ---------------------------------------------------------------------------------------
  PacketAlignmentRegister: block is
    signal bEnableAlignmentNx : boolean;
  begin
  
    PacketAlignmentWriteRegs: process(aReset, BusClk)
    begin
      if aReset then
      
        -- Set initial register values
        bEnableAlignment <= BitFieldInitValue(EnableAlignment);
      elsif rising_edge(BusClk) then
      
        if bReset then
          bEnableAlignment <= BitFieldInitValue(EnableAlignment);
        else
          bEnableAlignment <= bEnableAlignmentNx;
        end if;
    
      end if;
    end process PacketAlignmentWriteRegs;

    -- Determine the next value for the registers
    PacketAlignmentWrite: process(bDmaResetReg, bEnableAlignment, bRegPortIn, 
      bPacketAlignmentDecode)
    begin
    
      bEnableAlignmentNx <= bEnableAlignment;

      if bDmaResetReg then

        bEnableAlignmentNx <= BitFieldInitValue(EnableAlignment);

      else

        -- Handle writes to the packet alignment register
        if bRegPortIn.Wt and bPacketAlignmentDecode then
        
          bEnableAlignmentNx <= to_Boolean(bRegPortIn.Data(
            BitFieldIndex(EnableAlignment)));

        end if;

      end if;

    end process PacketAlignmentWrite;
  
  end block PacketAlignmentRegister;


  ---------------------------------------------------------------------------------------
  -- Max Payload Size Register
  ---------------------------------------------------------------------------------------
  MaxPayloadSizeRegister: block is
    signal bMaxPayloadSizeNx : unsigned(bMaxPayloadSize'range);
  begin

    MaxPayloadSizeRegs: process(aReset, BusClk)
    begin
      if aReset then

        -- Set initial register values
        bMaxPayloadSize <= to_unsigned(kMaxTransfer, bMaxPayloadSize'length);

      elsif rising_edge(BusClk) then

        if bReset then
          bMaxPayloadSize <= to_unsigned(kMaxTransfer, bMaxPayloadSize'length);
        else
          bMaxPayloadSize <= bMaxPayloadSizeNx;
        end if;

      end if;
    end process MaxPayloadSizeRegs;

    -- Determine the next value for the registers
    SetMaxPayloadSize: process(bDmaResetReg, bMaxPayloadSize, bRegPortIn,
      bMaxPayloadSizeDecode)
    begin

      bMaxPayloadSizeNx <= bMaxPayloadSize;

      if bDmaResetReg then

        bMaxPayloadSizeNx <= to_unsigned(kMaxTransfer, bMaxPayloadSize'length);

      else
        -- Handle writes to the max payload size register
        if bRegPortIn.Wt and bMaxPayloadSizeDecode then

          bMaxPayloadSizeNx <= resize(unsigned(bRegPortIn.Data(
            BitFieldUpperIndex(MaxPayloadSize) downto BitFieldIndex(MaxPayloadSize))),
            bMaxPayloadSizeNx'length);

        end if;

      end if;

    end process SetMaxPayloadSize;

  end block MaxPayloadSizeRegister;


  ---------------------------------------------------------------------------------------
  -- Transfer Count Register
  ---------------------------------------------------------------------------------------
  SatcrRegister: if not kSinkStream generate

    signal bSatcrNx : unsigned(bSatcr'range);
    signal bSatcrRegWrite : boolean;

    -- This is the amount to add to SATCR each clock cycle.  This value is set
    -- to zero, except when there is a register access to the SATCR, in which
    -- case it is set to the value written to SATCR.
    signal bSatcrAddAmt, bSatcrAddAmtNx : unsigned (bSatcr'range);

    signal bBytesToAlignmentNx : unsigned(bBytesToAlignment'range) :=
      to_unsigned(kMaxTransfer, bBytesToAlignment'length);

    signal bMaxPktSizeNx : unsigned(bMaxPktSize'range);

  begin

    -- We want to hold the RegWriteStrobe until the write has occurred.  The
    -- write occurs on the first clock edge when SatcrWriteStrobe is not true.
    -- If the SATCR gets reset before the strobe occurs, then clear the strobe
    -- also.  We start the write strobe when the SATCR is written to and the
    -- stream is not in reset.
    RegWriteStrobe: process(aReset, BusClk)
    begin
      if aReset then
        bSatcrRegWrite <= false;
      elsif rising_edge(BusClk) then
        if bReset then
          bSatcrRegWrite <= false;
        else
          if (bSatcrRegWrite and not bSatcrWriteStrobe) or bSatcrReset or bClearSatcr
          then
            bSatcrRegWrite <= false;
          elsif bRegPortIn.Wt and bSatcrDecode then
            bSatcrRegWrite <= true;
          else
            bSatcrRegWrite <= bSatcrRegWrite;
          end if;
        end if;
      end if;
    end process RegWriteStrobe;

    -- The register port is ready at all times except when we are waiting on
    -- an SATCR write.  We are waiting on the SATCR write whenever SatcrRegWrite
    -- is true.
    bRegPortOut.Ready <= not bSatcrRegWrite;

    bSatcrNx <= (others=>'0') when bSatcrReset or bClearSatcr else
                bSatcr - bReqWriteSpaces when bSatcrWriteStrobe else
                bSatcr + bSatcrAddAmt when bSatcrRegWrite else
                bSatcr;

    -- The next max packet size is the minimum of the packet size limited by
    -- the DmaPort and the SATCR value.
    -- If SATCR updates are disabled for an input or output stream, the next max packet
    -- size will not take SATCR into account (i.e. DMA transfers will run continuously,
    -- until they are stopped by the driver).
    FindMaxPktSize: process(bSatcrUpdatesEnabledReg, bSatcr, bBytesToAlignment)
    begin
      if (not bSatcrUpdatesEnabledReg and not kPeerToPeerStream) or
        bSatcr >= bBytesToAlignment then
        bMaxPktSizeNx <= bBytesToAlignment;
      else
        bMaxPktSizeNx <= resize(bSatcr, bMaxPktSize'length);
      end if;
    end process FindMaxPktSize;

    -- Use SATCR updates to track our alignment with a kMaxTransfer frame.
    FindBytesToAlignment: process(bSatcrWriteStrobe, bSatcrReset, bClearSatcr,
      bBytesToAlignment, bReqWriteSpaces, bDmaResetReg, bEnableAlignment,
      bMaxPayloadSize, bRegPortIn, bPacketAlignmentDecode)
    begin
      if bDmaResetReg then
        bBytesToAlignmentNx <= to_unsigned(kMaxTransfer, bBytesToAlignment'length);

      -- Whenever the stream is enabled, the bytes to alignment should be reset to
      -- the value set in the NextBoundary field of the StreamAlignment register.
      elsif bRegPortIn.Wt and bPacketAlignmentDecode then
        bBytesToAlignmentNx <= resize(unsigned(bRegPortIn.Data(
          BitFieldUpperIndex(NextBoundary) downto BitFieldIndex(NextBoundary))),
          bBytesToAlignment'length);

      elsif bSatcrWriteStrobe and not (bSatcrReset or bClearSatcr) then

        -- Set the alignment back to bMaxPayloadSize if alignment is not enabled or the
        -- alignment has dropped to 0.
        if not bEnableAlignment or bBytesToAlignment = bReqWriteSpaces then
          bBytesToAlignmentNx <= resize(bMaxPayloadSize, bBytesToAlignment'length);
        else
          bBytesToAlignmentNx <= bBytesToAlignment - bReqWriteSpaces;
        end if;

      elsif not bEnableAlignment then
        bBytesToAlignmentNx <= resize(bMaxPayloadSize, bBytesToAlignment'length);

      else
        bBytesToAlignmentNx <= bBytesToAlignment;
      end if;
    end process;

    SatcrWriteRegs: process(aReset, BusClk)
    begin
      if aReset then
        -- Set initial register values
        bSatcr <= (others => '0');
        bSatcrAddAmt <= (others => '0');
        bBytesToAlignment <= to_unsigned(kMaxTransfer, bBytesToAlignment'length);
      elsif rising_edge(BusClk) then
        if bReset then
          bSatcr <= (others => '0');
          bSatcrAddAmt <= (others => '0');
          bBytesToAlignment <= to_unsigned(kMaxTransfer, bBytesToAlignment'length);
        else
          bSatcr <= bSatcrNx;
          bSatcrAddAmt <= bSatcrAddAmtNx;
          bBytesToAlignment <= bBytesToAlignmentNx;
        end if;
      end if;
    end process SatcrWriteRegs;

    MaxPktSize: process(aReset, BusClk)
    begin
      if aReset then
        bMaxPktSize <= (others => '0');
      elsif rising_edge(BusClk) then
        if bReset or bSatcrReset or bClearSatcr then
          bMaxPktSize <= (others => '0');
        else
          bMaxPktSize <= bMaxPktSizeNx;
        end if;
      end if;
    end process MaxPktSize;

    -- Determine the next value for the registers
    SatcrWriteRegsNx: process(bDmaResetReg, bRegPortIn, bSatcrDecode, bSatcrAddAmt)
    begin

      bSatcrAddAmtNx <= bSatcrAddAmt;
      bSatcrWriteEventLcl <= '0';

        -- Handle writes to the SATCR register
        if bRegPortIn.Wt and bSatcrDecode then
          bSatcrAddAmtNx <= unsigned(bRegPortIn.Data);
          bSatcrWriteEventLcl <= '1';
        end if;

    end process SatcrWriteRegsNx;

  end generate SatcrRegister;

  -- A sink stream does not implement an SATCR register.  The ready can be set to true,
  -- since we'll always be ready to receive a register access, and the max packet
  -- size is unused for a sink stream.
  NoSatcrRegister: if kSinkStream generate
  begin

    bRegPortOut.Ready <= true;
    bSatcr <= (others=>'0');
    bMaxPktSize <= to_unsigned(kMaxTransfer, bMaxPktSize'length);
    bSatcrWriteEventLcl <= '0';

  end generate NoSatcrRegister;

  bSatcrWriteEvent <= to_boolean(bSatcrWriteEventLcl);
  ---------------------------------------------------------------------------------------
  -- Register Reads
  ---------------------------------------------------------------------------------------
  ReadRegisters: block is

    signal bDmaRegReadDecode : boolean;

  begin

    -- Delay the read signal by one so that we can send the response on the
    -- clock cycle after read was true
    ReadDelay: process(BusClk, aReset)
    begin
      if aReset then
        bRegPortOut.DataValid <= false;
      elsif rising_edge(BusClk) then

        bRegPortOut.DataValid <= false;

        -- Set data valid true for the next clock cycle if there is a read
        -- request and one of the DMA registers is being accessed.
        if bRegPortIn.Rd and bDmaRegReadDecode then
          bRegPortOut.DataValid <= true;
        end if;

      end if;
    end process ReadDelay;

    ReadRegs: process(BusClk, aReset)
      variable bRegDataOut : InterfaceData_t;
    begin

      -- The data out signal is bit-wise OR'd with the data out signals from
      -- the other reg port clients.  Therefore, the data out needs to be zeros
      -- when we are not returning valid data.
      if aReset then
        bRegPortOut.Data <= (others => '0');
      elsif rising_edge(BusClk) then

        bRegPortOut.Data <= (others => '0');

        if bRegPortIn.Rd then

          -- Handle reads to the SATCR and status registers
          if bSatcrDecode then

            bRegPortOut.Data <= std_logic_vector(bSatcr);

          elsif bStatusDecode then

            -- Build the data out for the status register.  The top bits are
            -- reserved and set to zero.  The overflow bit comes straight from
            -- the overflow register.  The disabled bit comes from the disabled
            -- input from external circuitry, which indicates when a disable is
            -- complete.  The reset bit comes from the reset register, but it is
            -- inverted, since the reset register is set while a reset is in progress.

            bRegDataOut := (others=>'0');
            bRegDataOut(BitFieldIndex(UnderflowStatus)) :=
              to_StdLogic(bUnderflowStatusReg);
            bRegDataOut(BitFieldIndex(OverflowStatus)) :=
              to_StdLogic(bOverflowStatusReg);
            bRegDataOut(BitFieldIndex(DisableStatus)) :=
              to_StdLogic(bDisabled);
            bRegDataOut(BitFieldIndex(ResetStatus)) :=
              to_StdLogic(not bDmaResetReg);
            bRegDataOut(BitFieldUpperIndex(State) downto BitFieldIndex(State)) :=
              bState;
            bRegDataOut(BitFieldIndex(SatcrUpdateStatus)) :=
              to_StdLogic(bSatcrUpdatesEnabledReg);
            bRegDataOut(BitFieldIndex(FlushingStatus)) :=
              to_StdLogic(bFlushingStatus);
            bRegDataOut(BitFieldIndex(FlushingFailedStatus)) :=
              to_StdLogic(bFlushingFailedStatus);
            bRegDataOut(BitFieldIndex(StreamErrorStatus)) :=
              to_StdLogic(bStreamErrorStatusReg);

            bRegPortOut.Data <= bRegDataOut;

          elsif bInterruptStatusDecode then

            bRegPortOut.Data <= bInterruptStatusReg;

          elsif bInterruptMaskDecode then

            bRegPortOut.Data <= bMaskRegReadValue;

          elsif bFifoCountDecode then

            bRegPortOut.Data <= std_logic_vector(resize(bFifoCount,
                                bRegPortOut.Data'length));

          elsif kSinkStream and bPeerAddressHighDecode then

            bRegPortOut.Data <= std_logic_vector(resize(shift_right(bPeerAddressReg,
                                bRegPortOut.Data'length),bRegPortOut.Data'length));

          elsif kSinkStream and bPeerAddressLowDecode then

            bRegPortOut.Data <= std_logic_vector(resize(bPeerAddressReg,
                                bRegPortOut.Data'length));

          elsif bPacketAlignmentDecode then

            bRegDataOut := (others=>'0');
            bRegDataOut(BitFieldIndex(EnableAlignment)) :=
              to_StdLogic(bEnableAlignment);
            bRegDataOut(BitFieldUpperIndex(NextBoundary) downto
              BitFieldIndex(NextBoundary)) := std_logic_vector(resize(bBytesToAlignment,
              BitFieldSize(NextBoundary)));

            bRegPortOut.Data <= bRegDataOut;

          elsif bMaxPayloadSizeDecode then

            bRegDataOut := (others=>'0');
            bRegDataOut(BitFieldUpperIndex(MaxPayloadSize) downto
                BitFieldIndex(MaxPayloadSize)) := std_logic_vector(resize(bMaxPayloadSize, BitFieldSize(MaxPayloadSize)));


            bRegPortOut.Data <= bRegDataOut;

          end if;

        end if;

      end if;

    end process ReadRegs;

    -- Determine when a register read to this channel has occurred.
    bDmaRegReadDecode <= bSatcrDecode or bStatusDecode or bInterruptStatusDecode or
                         bInterruptMaskDecode or bFifoCountDecode or
                         (kSinkStream and (bPeerAddressLowDecode or
                         bPeerAddressHighDecode)) or bPacketAlignmentDecode or
                         bMaxPayloadSizeDecode;

  end block ReadRegisters;


  ---------------------------------------------------------------------------------------
  -- Register access decoding
  ---------------------------------------------------------------------------------------

  bSatcrDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(Satcr) +
                  to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bStatusDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(Status) +
                   to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bControlDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(Control) +
                    to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bPeerAddressLowDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(PeerAddressLow) +
                          to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bPeerAddressHighDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(PeerAddressHigh) +
                            to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bInterruptStatusDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(InterruptStatus) +
                            to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bInterruptMaskDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(InterruptMask) +
                            to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bFifoCountDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(FifoCount) +
                      to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bPacketAlignmentDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(PacketAlignment) +
                            to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bMaxPayloadSizeDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(TransferLimit) +
                           to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
                           
  process (aReset, BusClk)
  begin
    if aReset then
      bSatcrDecode <= false;
      bStatusDecode <= false;
      bControlDecode <= false;
      bPeerAddressLowDecode <= false; 
      bPeerAddressHighDecode <= false;
      bInterruptStatusDecode <= false;
      bInterruptMaskDecode <= false;
      bFifoCountDecode <= false;
      bPacketAlignmentDecode <= false;
      bMaxPayloadSizeDecode <= false;
    elsif rising_edge(BusClk) then
      bSatcrDecode <= bSatcrDecodeNx;
      bStatusDecode <= bStatusDecodeNx;
      bControlDecode <= bControlDecodeNx;
      bPeerAddressLowDecode <= bPeerAddressLowDecodeNx;
      bPeerAddressHighDecode <= bPeerAddressHighDecodeNx;
      bInterruptStatusDecode <= bInterruptStatusDecodeNx;
      bInterruptMaskDecode <= bInterruptMaskDecodeNx;
      bFifoCountDecode <= bFifoCountDecodeNx;
      bPacketAlignmentDecode <= bPacketAlignmentDecodeNx;
      bMaxPayloadSizeDecode <= bMaxPayloadSizeDecodeNx;
    end if;
  end process;

end behavior;
