-------------------------------------------------------------------------------
--
-- File: PkgDmaPortCommIfcRegs.vhd
-- Author: Matthew Koenn
-- Original Project: LabVIEW FPGA
-- Date: 6 October 2007
--
-------------------------------------------------------------------------------
-- (c) 2007 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose: Package for DMA registers.  
-- 
--   This package controls the offsets for the DMA registers and the bit field
--   locations for the individual flags.  Functions are provided to support 
--   easy access to these values.  Additionally, the reset values for the 
--   individual fields are set here.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


package PkgDmaPortCommIfcRegs is

  --XML translate_on
  --<regmap name="DmaPortCommunicationInterface" order="1">
  --  <group name="DmaRegMap">
  --    <info>
  --      {p}
  --        These registers control the DMA input and output stream circuits
  --        and read the status of the DMA channel.  The base offset is accessed
  --        relative to the base offset for each DMA channel.
  --      {/p}
  --    </info>
  --    <register name="DmaControlRegister" size="32" offset="0x0"
  --              attributes="Writable">
  --      <bitfield name="ResetChannel" range="0">
  --        <info>
  --          This is a strobe bit used to reset the DMA channel.  Writing a 1
  --          to this bit triggers the DMA channel to reset.  Writing a 0 to this
  --          bit has no effect.  Read the corresponding bit in the status
  --          register to determine when the channel has been reset.  Resetting
  --          the DMA channel first disables the stream and then resets all
  --          other registers.  The DMA FIFO is also cleared.
  --        </info>
  --      </bitfield>
  --      <bitfield name="StartChannel" range="1">
  --        <info>
  --          This is a strobe bit used to enable the DMA channel.  Writing a 1
  --          to this bit enables the channel.  Writing a 1 to the enable bit
  --          and disable bit simultaneously is undefined and should not be
  --          done.  Read the disabled status bit in the status register to
  --          determine whether the channel is enabled/disabled.
  --        </info>
  --      </bitfield>
  --      <bitfield name="StopChannel" range="2">
  --        <info>
  --          This is a strobe bit used to disable the DMA channel.  Writing a 
  --          1 to this bit disables the channel.  Writing a 1 to the enable 
  --          bit and disable bit simultaneously is undefined and should not be
  --          done.  Read the disabled status bit in the status register to
  --          determine whether the channel is enabled/disabled.
  --        </info>
  --      </bitfield>
  --      <bitfield name="StopChannelWithFlush" range="3">
  --        <info>
  --          This is a strobe bit used to disable the DMA channel after
  --          flushing all data from the FIFO.  Write a 1 to this bit to perform
  --          the stop and flush.  Read the disabled status bit in the status 
  --          register to determine whether the channel is enabled/disabled.
  --        </info>
  --      </bitfield>
  --      <bitfield name="ResetSatcr" range="4">
  --        <info>
  --          This is a strobe bit used to reset the SATCR value.  This action
  --          is only allowed when the channel is disabled.
  --        </info>
  --      </bitfield>
  --      <bitfield name="LinkStream" range="5">
  --        <info>
  --          This is a strobe bit used to set the channel to the linked state.
  --        </info>
  --      </bitfield>
  --      <bitfield name="UnlinkStream" range="6">
  --        <info>
  --          This is a strobe bit used to set the channel to the unlinked state.
  --        </info>
  --      </bitfield>
  --      <bitfield name="ClearOverflowStatus" range="7">
  --        <info>
  --          This is a strobe bit used to clear the overflow status bit in the
  --          Dma Status register.
  --        </info>
  --      </bitfield>
  --      <bitfield name="ClearUnderflowStatus" range="8">
  --        <info>
  --          This is a strobe bit used to clear the underflow status bit in the
  --          Dma Status register.
  --        </info>
  --      </bitfield>
  --      <bitfield name="EnableSatcrUpdates" range="9">
  --        <info>
  --          Write a '1' to this bit to enable SATCR updates.  SATCR updates are
  --          enabled by default. For P2P sink streams, this enables SATCR updates going
  --          to the P2P source. For regular input & output streams, this makes the
  --          SATCR updates from the host be taken into account, thus making SATCR
  --          throttle DMA transfers. This bit does not apply to P2P source streams.
  --        </info>
  --      </bitfield>
  --      <bitfield name="DisableSatcrUpdates" range="10">
  --        <info>
  --          Write a '1' to this bit to disable SATCR updates.  SATCR updates are
  --          enabled by default. For P2P sink streams, this disables SATCR updates going
  --          to the P2P source. For regular input & output streams, this disables the
  --          need to update SATCR from the host, thus making DMA transfers run
  --          continuously (e.g. for the RF List Mode). This bit does not apply to P2P
  --          source streams.
  --        </info>
  --      </bitfield>
  --      <bitfield name="ClearFlushingStatus" range="11">
  --        <info>
  --          This is a strobe bit used to clear the flushing status bit in the
  --          Dma Status register.
  --        </info>
  --      </bitfield>
  --      <bitfield name="ClearFlushingFailedStatus" range="12">
  --        <info>
  --          This is a strobe bit used to clear the flushing failed status bit in the
  --          Dma Status register.
  --        </info>
  --      </bitfield>
  --      <bitfield name="ClearStreamErrorStatus" range="13">
  --        <info>
  --          This is a strobe bit used to clear the stream error status bit in the
  --          Dma Status register.
  --        </info>
  --      </bitfield>
  --    </register>
  --    <register name="DmaStatusRegister" size="32" offset="0x4"
  --              attributes="Readable">
  --      <bitfield name="ResetStatus" range="0">
  --        <info>
  --          This bit indicates the reset status of the DMA channel.  The
  --          channel is in reset while this bit reads a 0.  When this bit
  --          reads a 1, the channel has been successfully reset.  Upon startup
  --          or after a reset has been issued, the DMA channel should not be
  --          enabled and other DMA registers should not be accessed until this
  --          bit is set.
  --        </info>
  --      </bitfield>
  --      <bitfield name="DisableStatus" range="1">
  --        <info>
  --          This bit indicates whether the channel is currently enabled or
  --          disabled.  When this bit reads a 1, the channel is disabled, and
  --          when this bit reads a 0, the channel is enabled.  When the
  --          channel is disabled, no more data transfers will be initiated,
  --          but there may be points still in transit.  The host will need to
  --          check TCR and SATCR to ensure that all points in transit have
  --          arrived at the destination.  The channel resets into the disabled
  --          state.
  --        </info>
  --      </bitfield>
  --      <bitfield name="State" range="2..3">
  --        <info>
  --          The state of the stream.  Values are:
  --            00 - Unlinked
  --            01 - Stopped
  --            10 - Started
  --            11 - Flushing
  --        </info>
  --      </bitfield>
    --      <bitfield name="OverflowStatus" range="4">
  --        <info>
  --          This bit is set whenever an overflow occurs on the user diagram.
  --          This is defined as when a VI is pushing into an input (or source)
  --          stream and the push times out.  An overflow also occurs when a 
  --          sink stream receives data while it is full.  The status holds until
  --          it is cleared with the clear overflow bit in the control register.
  --        </info>
  --      </bitfield>
  --      <bitfield name="UnderflowStatus" range="5">
  --        <info>
  --          This bit is set whenever an underflow occurs on the user diagram.
  --          This is defined as when a VI is popping from an output (or sink)
  --          stream and the pop times out.  The status holds until
  --          it is cleared with the clear underflow bit in the control register.
  --        </info>
  --      </bitfield>
  --      <bitfield name="SatcrUpdateStatus" range="6">
  --        <info>
  --          This bit reads a '1' if SATCR updates are enabled.  SATCR updates are
  --          enabled by default. This only applies for regular input & output streams
  --          and for P2P sink streams. It does not apply to P2P source streams.
  --        </info>
  --      </bitfield>
  --      <bitfield name="FlushingStatus" range="7">
  --        <info>
  --          This bit is set whenever a flushing is attempted.  It is cleared
  --          automatically when the stream enables.
  --        </info>
  --      </bitfield>
  --      <bitfield name="FlushingFailedStatus" range="8">
  --        <info>
  --          This bit is set whenever a flushing was attempted and failed.  It is
  --          cleared automatically when the stream enables.
  --        </info>
  --      </bitfield>
  --      <bitfield name="StreamErrorStatus" range="9">
  --        <info>
  --          This bit is set whenever a stream error occurs.  It can only be cleared
  --          by software.
  --        </info>
  --      </bitfield>
  --    </register>
  --    <register name="DmaSatcrRegister" size="32" offset="0x8"
  --              attributes="Readable|Writable">
  --      <bitfield name="SatcrValue" range="31..0">
  --        <info>
  --          This is the current transfer count value (in bytes) for the stream.  
  --          This is an indicator of the number of bytes that the stream
  --          can transmit (for an input stream) or request (for an output stream).
  --          Writing to this register increments the value in the register by the 
  --          amount written.  Reading from this register reads the current SATCR value.
  --          All writes to this register should be integer multiples of the channel's
  --          data type.
  --        </info>
  --      </bitfield>
  --    </register>
  --    <register name="InterruptStatusRegister" size="32" offset="0xC"
  --              attributes="Readable|Writable">
  --      <bitfield name="Overflow" range="0">
  --        <info>
  --          The interrupt indicating that the user diagram received an overflow or a
  --          sink stream received data from the bus while it was full.  The
  --          error occurred when this bit is read as a 1.  Write a 1 to clear.
  --        </info>
  --      </bitfield>
  --      <bitfield name="Underflow" range="2">
  --        <info>
  --          The interrupt indicating that the user diagram received an underflow.  The
  --          error occurred when this bit is read as a 1.  Write a 1 to clear.
  --        </info>
  --      </bitfield>
  --      <bitfield name="StartStream" range="4">
  --        <info>
  --          Reads a 1 when the target has requested a stream start.  Write a 1 to
  --          clear.
  --        </info>
  --      </bitfield>
  --      <bitfield name="StopStream" range="6">
  --        <info>
  --          Reads a 1 when the target has requested a stream stop.  Write a 1 to
  --          clear.
  --        </info>
  --      </bitfield>
  --      <bitfield name="FlushingStream" range="8">
  --        <info>
  --          Reads a 1 when a source stream has started flushing.  Write a 1 to
  --          clear.
  --        </info>
  --      </bitfield>
  --      <bitfield name="StreamError" range="10">
  --        <info>
  --          Reads a 1 when a stream error has occurred.  Write a 1 to clear.
  --        </info>
  --      </bitfield>
  --    </register>
  --    <register name="InterruptMaskRegister" size="32" offset="0x10"
  --              attributes="Readable|Writable">
  --      <bitfield name="EnableOverflow" range="0">
  --        <info>
  --          Strobe bit.  Write with a '1' to enable the overflow interrupt.
  --          This bit reads a '1' if the mask is enabled and a '0' if not.
  --        </info>
  --      </bitfield>
  --      <bitfield name="DisableOverflow" range="1">
  --        <info>
  --          Strobe bit.  Write with a '1' to disable the overflow interrupt.
  --        </info>
  --      </bitfield>
  --      <bitfield name="EnableUnderflow" range="2">
  --        <info>
  --          Strobe bit.  Write with a '1' to enable the underflow interrupt.
  --          This bit reads a '1' if the mask is enabled and a '0' if not.
  --        </info>
  --      </bitfield>
  --      <bitfield name="DisableUnderflow" range="3">
  --        <info>
  --          Strobe bit.  Write with a '1' to disable the underflow interrupt.
  --        </info>
  --      </bitfield>
  --      <bitfield name="EnableStartStream" range="4">
  --        <info>
  --          Strobe bit.  Write with a '1' to enable the start stream interrupt.
  --          This bit reads a '1' if the mask is enabled and a '0' if not.
  --        </info>
  --      </bitfield>
  --      <bitfield name="DisableStartStream" range="5">
  --        <info>
  --          Strobe bit.  Write with a '1' to disable the start stream interrupt.
  --        </info>
  --      </bitfield>
  --      <bitfield name="EnableStopStream" range="6">
  --        <info>
  --          Strobe bit.  Write with a '1' to enable the stop stream interrupt.
  --          This bit reads a '1' if the mask is enabled and a '0' if not.
  --        </info>
  --      </bitfield>
  --      <bitfield name="DisableStopStream" range="7">
  --        <info>
  --          Strobe bit.  Write with a '1' to disable the stop stream interrupt.
  --        </info>
  --      </bitfield>
  --      <bitfield name="EnableFlushingStream" range="8">
  --        <info>
  --          Strobe bit.  Write with a '1' to enable the flushing stream interrupt.
  --          This bit reads a '1' if the mask is enabled and a '0' if not.
  --        </info>
  --      </bitfield>
  --      <bitfield name="DisableFlushingStream" range="9">
  --        <info>
  --          Strobe bit.  Write with a '1' to disable the flushing stream interrupt.
  --        </info>
  --      </bitfield>
  --      <bitfield name="EnableError" range="10">
  --        <info>
  --          Strobe bit.  Write with a '1' to enable the stream error interrupt.
  --          This bit reads a '1' if the mask is enabled and a '0' if not.
  --        </info>
  --      </bitfield>
  --      <bitfield name="DisableError" range="11">
  --        <info>
  --          Strobe bit.  Write with a '1' to disable the stream error interrupt.
  --        </info>
  --      </bitfield>
  --    </register>
  --    <register name="FifoCountRegister" size="32" offset="0x14"
  --              attributes="Readable">
  --      <bitfield name="FifoCount" range="31..0">
  --        <info>
  --          The full count of the FIFO, regardless of whether it is a source or a sink.
  --        </info>
  --      </bitfield>
  --    </register>
  --    <register name="DmaPeerAddressRegisterLow" size="32" offset="0x18"
  --              attributes="Readable|Writable">
  --      <bitfield name="PeerAddressLow" range="31..0">
  --        <info>
  --          This register is only used for a peer to peer sink stream.  This field
  --          holds the lower 32 bits of the physical address of the corresponding 
  --          source's transfer count register.
  --        </info>
  --      </bitfield>
  --    </register>
  --    <register name="DmaPeerAddressRegisterHigh" size="32" offset="0x1C"
  --              attributes="Readable|Writable">
  --      <bitfield name="PeerAddressHigh" range="31..0">
  --        <info>
  --          This register is only used for a peer to peer sink stream.  This field
  --          holds the upper 32 bits of the physical address of the corresponding 
  --          source's transfer count register.
  --        </info>
  --      </bitfield>
  --    </register>
  --    <register name="StreamTransferLimitRegister" size="32" offset="0x24"
  --              attributes="Readable|Writable">
  --      <bitfield name="StreamMaxPayloadSize" range="31..16">
  --        <info>
  --          The value of this field is the largest payload size that can be used by
  --          the DMA channel.  This field defaults to the max payload size specified
  --          in PkgNiDmaConfig.  This field can only be set to powers of 2.
  --        </info>
  --      </bitfield>
  --    </register>
  --    <register name="StreamPacketAlignmentRegister" size="32" offset="0x28"
  --              attributes="Readable|Writable">
  --      <bitfield name="StreamEnableAlignment" range="31">
  --        <info>
  --          When this bit is set the alignment feature is enabled.  The DMA stream
  --          will break packets at boundaries of the packet size programmed in the
  --          StreamTransferLimitRegister.  If alignment is lost, a packet will be
  --          enforced at the next StreamMaxPayloadSize boundary.
  --        </info>
  --      </bitfield>
  --      <bitfield name="StreamNextBoundary" range="15..0">
  --        <info>
  --          This bitfield indicates the bytes remaining until the next 
  --          StreamMaxPayloadSize boundary.  Software can initialize this field so that
  --          the alignment feature can correct for a mis-aligned buffer.  Software
  --          should initialize this field with StreamMaxPayloadSize - 
  --          (BufferStartAddress mod StreamMaxPayloadSize).  If the result of the
  --          calculation is 0, software should instead write this field with 
  --          StreamMaxPayloadSize.  0 is not a valid value to write to this field.
  --        </info>
  --      </bitfield>
  --    </register>
  --  </group>
  --</regmap>
  --XML translate_off
 
  ---------------------------------------------------------------------------------------
  --Types Declaration (DMA Registers):
  ---------------------------------------------------------------------------------------
  
  subtype DmaRegOffset_t is natural;
  
  type DmaRegInfo_t is
    record
      offset     : DmaRegOffset_t;
    end record;
  
  type DmaReg_t is
    (Control,
     Status,
     Satcr,
     InterruptStatus,
     InterruptMask,
     FifoCount,
     PeerAddressLow,
     PeerAddressHigh,
     TransferLimit,
     PacketAlignment);
  
  type DmaRegArray_t is array (DmaReg_t) of DmaRegInfo_t;
  constant kDmaRegArray : DmaRegArray_t :=
    (Control           => (offset=>16#0#),
     Status            => (offset=>16#4#),
     Satcr             => (offset=>16#8#),
     InterruptStatus   => (offset=>16#C#),
     InterruptMask     => (offset=>16#10#),
     FifoCount         => (offset=>16#14#),
     PeerAddressLow    => (offset=>16#18#),
     PeerAddressHigh   => (offset=>16#1C#),
     TransferLimit     => (offset=>16#24#),
     PacketAlignment   => (offset=>16#28#));
     
     
  type DmaBitFields_t is 
    (
    
     ------------------------------------------------------------------------------------
     -- Control Register bits
     ------------------------------------------------------------------------------------
     Reset,
     StartChannel,
     StopChannel,
     StopChannelWithFlush,
     LinkStream,
     UnlinkStream,
     ResetSatcr,
     ClearOverflowStatus,
     ClearUnderflowStatus,
     EnableSatcrUpdates,
     DisableSatcrUpdates,
     ClearFlushingStatus,
     ClearFlushingFailedStatus,
     ClearStreamErrorStatus,
     
     ------------------------------------------------------------------------------------
     -- Status Register bits
     ------------------------------------------------------------------------------------
     ResetStatus,
     DisableStatus,
     State,
     OverflowStatus,
     UnderflowStatus,
     SatcrUpdateStatus,
     FlushingStatus,
     FlushingFailedStatus,
     StreamErrorStatus,
     
     ------------------------------------------------------------------------------------
     -- Interrupt Status bits
     ------------------------------------------------------------------------------------
     OverflowIrq,
     UnderflowIrq,
     StartStreamIrq,
     StopStreamIrq,
     FlushingIrq,
     StreamErrorIrq,
     
     ------------------------------------------------------------------------------------
     -- Interrupt Mask bits
     ------------------------------------------------------------------------------------
     EnableOverflowIrq,
     DisableOverflowIrq,
     OverflowIrqMaskStatus,
     EnableUnderflowIrq,
     DisableUnderflowIrq,
     UnderflowIrqMaskStatus,
     EnableStartStreamIrq,
     DisableStartStreamIrq,
     StartStreamIrqMaskStatus,
     EnableStopStreamIrq,
     DisableStopStreamIrq,
     StopStreamIrqMaskStatus,
     EnableFlushingIrq,
     DisableFlushingIrq,
     FlushingIrqMaskStatus,
     EnableStreamErrorIrq,
     DisableStreamErrorIrq,
     StreamErrorIrqMaskStatus,
     
     ------------------------------------------------------------------------------------
     -- Transfer Limit bits
     ------------------------------------------------------------------------------------
     MaxPayloadSize,
     
     ------------------------------------------------------------------------------------
     -- Stream Packet Alignment bits
     ------------------------------------------------------------------------------------
     EnableAlignment,
     NextBoundary
     
    );
     
  type DmaBitFieldInfo_t is 
    record
      index   : integer;
      defaultValue : boolean;
      size    : integer;
    end record;
  
  type DmaBitFieldArray is array (DmaBitFields_t) of DmaBitFieldInfo_t;
  constant kDmaBitFieldArray : DmaBitFieldArray := 
    (
     
     ------------------------------------------------------------------------------------
     -- Control Register bits
     ------------------------------------------------------------------------------------
     
     -- Default values don't really apply to these write only bits
     Reset                     => (index=>0,  defaultValue=>false, size=> 1),
     StartChannel              => (index=>1,  defaultValue=>false, size=> 1),
     StopChannel               => (index=>2,  defaultValue=>false, size=> 1),
     StopChannelWithFlush      => (index=>3,  defaultValue=>false, size=> 1),
     ResetSatcr                => (index=>4,  defaultValue=>false, size=> 1),
     LinkStream                => (index=>5,  defaultValue=>false, size=> 1),
     UnlinkStream              => (index=>6,  defaultValue=>false, size=> 1),
     ClearOverflowStatus       => (index=>7,  defaultValue=>false, size=> 1),
     ClearUnderflowStatus      => (index=>8,  defaultValue=>false, size=> 1),
     EnableSatcrUpdates        => (index=>9,  defaultValue=>false, size=> 1),
     DisableSatcrUpdates       => (index=>10, defaultValue=>false, size=> 1),
     ClearFlushingStatus       => (index=>11, defaultValue=>false, size=> 1),
     ClearFlushingFailedStatus => (index=>12, defaultValue=>false, size=> 1),
     ClearStreamErrorStatus    => (index=>13, defaultValue=>false, size=> 1),
     
     ------------------------------------------------------------------------------------
     -- Status Register bits
     ------------------------------------------------------------------------------------
     
     -- This bit is used as the default value for the reset state.  Set this to
     -- true to start in the reset state.
     ResetStatus              => (index=>0, defaultValue=>false, size=> 1),
     
     -- This bit is used as the default value for the disable state.  Set this
     -- to true to start up in the disabled state, or set to false to start in
     -- the enabled state.
     DisableStatus            => (index=>1, defaultValue=>false, size=> 1),
     
     -- This field is actually 2 bits wide.  Eventually I will expand the register map
     -- code to reflect this in the configuration.
     State                    => (index=>2, defaultValue=>false, size=> 2),
     
     -- The overflow and underflow status bits start up in the false state.
     OverflowStatus           => (index=>4, defaultValue=>false, size=> 1),
     UnderflowStatus          => (index=>5, defaultValue=>false, size=> 1),
     
     -- The SATCR updates are enabled by default.
     SatcrUpdateStatus        => (index=>6, defaultValue=>true, size=> 1),
     
     -- The flushing and flushing failed bits are false by default.
     FlushingStatus           => (index=>7, defaultValue=>false, size=> 1),
     FlushingFailedStatus     => (index=>8, defaultValue=>false, size=> 1),
     
     -- Stream error is false by default.
     StreamErrorStatus        => (index=>9, defaultValue=>false, size=> 1),
     
     ------------------------------------------------------------------------------------
     -- Interrupt Status bits
     ------------------------------------------------------------------------------------
     OverflowIrq              => (index=>0,  defaultValue=>false, size=> 1),
     UnderflowIrq             => (index=>2,  defaultValue=>false, size=> 1), 
     StartStreamIrq           => (index=>4,  defaultValue=>false, size=> 1),
     StopStreamIrq            => (index=>6,  defaultValue=>false, size=> 1),
     FlushingIrq              => (index=>8,  defaultValue=>false, size=> 1),
     StreamErrorIrq           => (index=>10, defaultValue=>false, size=> 1),
     
     ------------------------------------------------------------------------------------
     -- Interrupt Mask bits
     ------------------------------------------------------------------------------------
     
     EnableOverflowIrq        => (index=>0,  defaultValue=>false, size=> 1),
     DisableOverflowIrq       => (index=>1,  defaultValue=>false, size=> 1),
     EnableUnderflowIrq       => (index=>2,  defaultValue=>false, size=> 1),
     DisableUnderflowIrq      => (index=>3,  defaultValue=>false, size=> 1),
     EnableStartStreamIrq     => (index=>4,  defaultValue=>false, size=> 1),
     DisableStartStreamIrq    => (index=>5,  defaultValue=>false, size=> 1),
     EnableStopStreamIrq      => (index=>6,  defaultValue=>false, size=> 1),
     DisableStopStreamIrq     => (index=>7,  defaultValue=>false, size=> 1),
     EnableFlushingIrq        => (index=>8,  defaultValue=>false, size=> 1),
     DisableFlushingIrq       => (index=>9,  defaultValue=>false, size=> 1),
     EnableStreamErrorIrq     => (index=>10, defaultValue=>false, size=> 1),
     DisableStreamErrorIrq    => (index=>11, defaultValue=>false, size=> 1),
     
     OverflowIrqMaskStatus    => (index=>0,  defaultValue=>false, size=> 1),
     UnderflowIrqMaskStatus   => (index=>2,  defaultValue=>false, size=> 1),
     StartStreamIrqMaskStatus => (index=>4,  defaultValue=>false, size=> 1),
     StopStreamIrqMaskStatus  => (index=>6,  defaultValue=>false, size=> 1),
     FlushingIrqMaskStatus    => (index=>8,  defaultValue=>false, size=> 1),
     StreamErrorIrqMaskStatus => (index=>10, defaultValue=>false, size=> 1),
     
     ------------------------------------------------------------------------------------
     -- Transfer Limit bits
     ------------------------------------------------------------------------------------
     MaxPayloadSize           => (index=>16,  defaultValue=>false, size=> 16),
     
     ------------------------------------------------------------------------------------
     -- Stream Packet Alignment bits
     ------------------------------------------------------------------------------------
     EnableAlignment          => (index=>31, defaultValue=>true,  size=> 1),
     NextBoundary             => (index=>0,  defaultValue=>false, size=> 16)
     
  );


  ---------------------------------------------------------------------------------------
  --Function prototypes:
  ---------------------------------------------------------------------------------------
  --Reg info:
  function OffsetValue(Reg : DmaReg_t) return DmaRegOffset_t;
  
  --Reg bit-field info:
  function BitFieldIndex(RegBit :  DmaBitFields_t) return integer;
  function BitFieldInitValue(RegBit : DmaBitFields_t) return boolean;
  function BitFieldSize(RegBit : DmaBitFields_t) return integer;
  function BitFieldUpperIndex(RegBit : DmaBitFields_t) return integer;
   
end PkgDmaPortCommIfcRegs;

package body PkgDmaPortCommIfcRegs is 

  function OffsetValue(Reg : DmaReg_t) return DmaRegOffset_t is
  begin
    return kDmaRegArray(Reg).offset;
  end OffsetValue;

  function BitFieldIndex(RegBit : DmaBitFields_t) return integer is
  begin
    return kDmaBitFieldArray(RegBit).index;
  end BitFieldIndex;
  
  function BitFieldInitValue(RegBit : DmaBitFields_t) return boolean is
  begin
    return kDmaBitFieldArray(RegBit).defaultValue;
  end BitFieldInitValue;
  
  function BitFieldSize(RegBit : DmaBitFields_t) return integer is
  begin
    return kDmaBitFieldArray(RegBit).size;
  end BitFieldSize;
  
  function BitFieldUpperIndex(RegBit : DmaBitFields_t) return integer is
  begin
    return BitFieldIndex(RegBit) + BitFieldSize(RegBit) - 1;
  end BitFieldUpperIndex;
  
end PkgDmaPortCommIfcRegs;
