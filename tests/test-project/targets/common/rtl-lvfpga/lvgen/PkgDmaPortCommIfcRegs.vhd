-------------------------------------------------------------------------------
--
-- File: PkgDmaPortCommIfcRegs.vhd
-- Author: Matthew Koenn
-- Original Project: LabVIEW FPGA
-- Date: 6 October 2007
--
-------------------------------------------------------------------------------
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- All rights reserved.
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
--
-- githubvisible=true

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


package PkgDmaPortCommIfcRegs is

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
      defaultVal : boolean;
      size    : integer;
    end record;

  type DmaBitFieldArray is array (DmaBitFields_t) of DmaBitFieldInfo_t;
  constant kDmaBitFieldArray : DmaBitFieldArray :=
    (

     ------------------------------------------------------------------------------------
     -- Control Register bits
     ------------------------------------------------------------------------------------

     -- Default values don't really apply to these write only bits
     Reset                     => (index=>0,  defaultVal=>false, size=> 1),
     StartChannel              => (index=>1,  defaultVal=>false, size=> 1),
     StopChannel               => (index=>2,  defaultVal=>false, size=> 1),
     StopChannelWithFlush      => (index=>3,  defaultVal=>false, size=> 1),
     ResetSatcr                => (index=>4,  defaultVal=>false, size=> 1),
     LinkStream                => (index=>5,  defaultVal=>false, size=> 1),
     UnlinkStream              => (index=>6,  defaultVal=>false, size=> 1),
     ClearOverflowStatus       => (index=>7,  defaultVal=>false, size=> 1),
     ClearUnderflowStatus      => (index=>8,  defaultVal=>false, size=> 1),
     EnableSatcrUpdates        => (index=>9,  defaultVal=>false, size=> 1),
     DisableSatcrUpdates       => (index=>10, defaultVal=>false, size=> 1),
     ClearFlushingStatus       => (index=>11, defaultVal=>false, size=> 1),
     ClearFlushingFailedStatus => (index=>12, defaultVal=>false, size=> 1),
     ClearStreamErrorStatus    => (index=>13, defaultVal=>false, size=> 1),

     ------------------------------------------------------------------------------------
     -- Status Register bits
     ------------------------------------------------------------------------------------

     -- This bit is used as the defaultVal value for the reset state.  Set this to
     -- true to start in the reset state.
     ResetStatus              => (index=>0, defaultVal=>false, size=> 1),

     -- This bit is used as the defaultVal value for the disable state.  Set this
     -- to true to start up in the disabled state, or set to false to start in
     -- the enabled state.
     DisableStatus            => (index=>1, defaultVal=>false, size=> 1),

     -- This field is actually 2 bits wide.  Eventually I will expand the register map
     -- code to reflect this in the configuration.
     State                    => (index=>2, defaultVal=>false, size=> 2),

     -- The overflow and underflow status bits start up in the false state.
     OverflowStatus           => (index=>4, defaultVal=>false, size=> 1),
     UnderflowStatus          => (index=>5, defaultVal=>false, size=> 1),

     -- The SATCR updates are enabled by defaultVal.
     SatcrUpdateStatus        => (index=>6, defaultVal=>true, size=> 1),

     -- The flushing and flushing failed bits are false by defaultVal.
     FlushingStatus           => (index=>7, defaultVal=>false, size=> 1),
     FlushingFailedStatus     => (index=>8, defaultVal=>false, size=> 1),

     -- Stream error is false by defaultVal.
     StreamErrorStatus        => (index=>9, defaultVal=>false, size=> 1),

     ------------------------------------------------------------------------------------
     -- Interrupt Status bits
     ------------------------------------------------------------------------------------
     OverflowIrq              => (index=>0,  defaultVal=>false, size=> 1),
     UnderflowIrq             => (index=>2,  defaultVal=>false, size=> 1),
     StartStreamIrq           => (index=>4,  defaultVal=>false, size=> 1),
     StopStreamIrq            => (index=>6,  defaultVal=>false, size=> 1),
     FlushingIrq              => (index=>8,  defaultVal=>false, size=> 1),
     StreamErrorIrq           => (index=>10, defaultVal=>false, size=> 1),

     ------------------------------------------------------------------------------------
     -- Interrupt Mask bits
     ------------------------------------------------------------------------------------

     EnableOverflowIrq        => (index=>0,  defaultVal=>false, size=> 1),
     DisableOverflowIrq       => (index=>1,  defaultVal=>false, size=> 1),
     EnableUnderflowIrq       => (index=>2,  defaultVal=>false, size=> 1),
     DisableUnderflowIrq      => (index=>3,  defaultVal=>false, size=> 1),
     EnableStartStreamIrq     => (index=>4,  defaultVal=>false, size=> 1),
     DisableStartStreamIrq    => (index=>5,  defaultVal=>false, size=> 1),
     EnableStopStreamIrq      => (index=>6,  defaultVal=>false, size=> 1),
     DisableStopStreamIrq     => (index=>7,  defaultVal=>false, size=> 1),
     EnableFlushingIrq        => (index=>8,  defaultVal=>false, size=> 1),
     DisableFlushingIrq       => (index=>9,  defaultVal=>false, size=> 1),
     EnableStreamErrorIrq     => (index=>10, defaultVal=>false, size=> 1),
     DisableStreamErrorIrq    => (index=>11, defaultVal=>false, size=> 1),

     OverflowIrqMaskStatus    => (index=>0,  defaultVal=>false, size=> 1),
     UnderflowIrqMaskStatus   => (index=>2,  defaultVal=>false, size=> 1),
     StartStreamIrqMaskStatus => (index=>4,  defaultVal=>false, size=> 1),
     StopStreamIrqMaskStatus  => (index=>6,  defaultVal=>false, size=> 1),
     FlushingIrqMaskStatus    => (index=>8,  defaultVal=>false, size=> 1),
     StreamErrorIrqMaskStatus => (index=>10, defaultVal=>false, size=> 1),

     ------------------------------------------------------------------------------------
     -- Transfer Limit bits
     ------------------------------------------------------------------------------------
     MaxPayloadSize           => (index=>16,  defaultVal=>false, size=> 16),

     ------------------------------------------------------------------------------------
     -- Stream Packet Alignment bits
     ------------------------------------------------------------------------------------
     EnableAlignment          => (index=>31, defaultVal=>true,  size=> 1),
     NextBoundary             => (index=>0,  defaultVal=>false, size=> 16)

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
    return kDmaBitFieldArray(RegBit).defaultVal;
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
