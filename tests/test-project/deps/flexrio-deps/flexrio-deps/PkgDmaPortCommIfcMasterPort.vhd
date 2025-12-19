-------------------------------------------------------------------------------
--
-- File: PkgDmaPortCommIfcMasterPort.vhd
-- Author: Florin Hurgoi
-- Original Project: Zynq support for LabVIEW FPGA
-- Date: 04 November 2011
--
-------------------------------------------------------------------------------
-- (c) 2010 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
-- This package defines types, functions, and constants used for the Master Port.
-- support.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;

  use work.PkgNiDma.all;

package PkgDmaPortCommIfcMasterPort is

  --=======================================================================
  -- Master Port Write Interface Types
  -------------------------------------------------------------------------

  -- Master Write Request Interface ----------------------------------------------
  type NiFpgaMasterWriteRequestFromMaster_t is record
    Request : boolean;
    Space : NiDmaSpace_t;
    Address : NiDmaAddress_t;
    Baggage : NiDmaBaggage_t;
    ByteSwap : NiDmaByteSwap_t;
    ByteLane : NiDmaByteLane_t;
    ByteCount : NiDmaInputByteCount_t;
  end record;

  constant kNiFpgaMasterWriteRequestFromMasterZero : NiFpgaMasterWriteRequestFromMaster_t
    := (Request => false,
        Space => kNiDmaSpaceStream,
        Address => (others => '0'),
        Baggage => (others => '0'),
        ByteSwap => (others => '0'),
        ByteLane => (others => '0'),
        ByteCount => (others => '0')
        );

  function SizeOf(Var : NiFpgaMasterWriteRequestFromMaster_t) return integer;

  type NiFpgaMasterWriteRequestToMaster_t is record
    Acknowledge : boolean;
  end record;

  constant kNiFpgaMasterWriteRequestToMasterZero : NiFpgaMasterWriteRequestToMaster_t := (
    Acknowledge => false
  );

  function SizeOf(Var : NiFpgaMasterWriteRequestToMaster_t) return integer;

  -- Master Write Data Interface -------------------------------------------------
  type NiFpgaMasterWriteDataFromMaster_t is record
    Data : NiDmaData_t;
  end record;

  constant kNiFpgaMasterWriteDataFromMasterZero : NiFpgaMasterWriteDataFromMaster_t := (
    Data => (others => '0')
  );

  function SizeOf(Var : NiFpgaMasterWriteDataFromMaster_t) return integer;


  type NiFpgaMasterWriteDataToMaster_t is record
    TransferStart : boolean;
    TransferEnd : boolean;
    Space : NiDmaSpace_t;
    ByteLane : NiDmaByteLane_t;
    ByteCount : NiDmaBusByteCount_t;
    ByteEnable : NiDmaByteEnable_t;
    Pop : boolean;
  end record;

  constant kNiFpgaMasterWriteDataToMasterZero : NiFpgaMasterWriteDataToMaster_t := (
    TransferStart => false,
    TransferEnd => false,
    Space => kNiDmaSpaceStream,
    ByteLane => (others => '0'),
    ByteCount => (others => '0'),
    ByteEnable => (others => false),
    Pop => false
  );

  function SizeOf(Var : NiFpgaMasterWriteDataToMaster_t) return integer;

  -- Master Write Status Interface -----------------------------------------------
  type NiFpgaMasterWriteStatusToMaster_t is record
    Ready : boolean;
    Space : NiDmaSpace_t;
    ByteCount : NiDmaInputByteCount_t;
    ErrorStatus : boolean;
  end record;

  constant kNiFpgaMasterWriteStatusToMasterZero : NiFpgaMasterWriteStatusToMaster_t := (
    Ready => false,
    Space => kNiDmaSpaceStream,
    ByteCount => (others => '0'),
    ErrorStatus => false
  );

  function SizeOf(Var : NiFpgaMasterWriteStatusToMaster_t) return integer;

  --=======================================================================
  -- Master Port Read Interface Types
  -------------------------------------------------------------------------

  -- Master Read Request Interface ---------------------------------------------
  type NiFpgaMasterReadRequestFromMaster_t is record
    Request : boolean;
    Space : NiDmaSpace_t;
    Address : NiDmaAddress_t;
    Baggage : NiDmaBaggage_t;
    ByteSwap : NiDmaByteSwap_t;
    ByteLane : NiDmaByteLane_t;
    ByteCount : NiDmaOutputByteCount_t;
  end record;

  constant kNiFpgaMasterReadRequestFromMasterZero : NiFpgaMasterReadRequestFromMaster_t
  := (Request => false,
      Space => kNiDmaSpaceStream,
      Address => (others => '0'),
      Baggage => (others => '0'),
      ByteSwap => (others => '0'),
      ByteLane => (others => '0'),
      ByteCount => (others => '0')
      );

  function SizeOf(Var : NiFpgaMasterReadRequestFromMaster_t) return integer;

  type NiFpgaMasterReadRequestToMaster_t is record
    Acknowledge : boolean;
  end record;

  constant kNiFpgaMasterReadRequestToMasterZero : NiFpgaMasterReadRequestToMaster_t := (
    Acknowledge => false
  );

  function SizeOf(Var : NiFpgaMasterReadRequestToMaster_t) return integer;

  -- Master Read Data Interface ------------------------------------------------
  type NiFpgaMasterReadDataToMaster_t is record
    TransferStart : boolean;
    TransferEnd : boolean;
    Space : NiDmaSpace_t;
    ByteLane : NiDmaByteLane_t;
    ByteCount : NiDmaBusByteCount_t;
    ErrorStatus : boolean;
    ByteEnable : NiDmaByteEnable_t;
    Push : boolean;
    Data : NiDmaData_t;
  end record;

  constant kNiFpgaMasterReadDataToMasterZero : NiFpgaMasterReadDataToMaster_t := (
    TransferStart => false,
    TransferEnd => false,
    Space => kNiDmaSpaceStream,
    ByteLane => (others => '0'),
    ByteCount => (others => '0'),
    ErrorStatus => false,
    ByteEnable => (others => false),
    Push => false,
    Data => (others => '0')
  );

  function SizeOf(Var : NiFpgaMasterReadDataToMaster_t) return integer;


  --===========================================================================
  -- Master Port Interface Arrays
  -----------------------------------------------------------------------------

  type NiFpgaMasterWriteRequestFromMasterArray_t is array (natural range <>)
    of NiFpgaMasterWriteRequestFromMaster_t;

  type NiFpgaMasterWriteRequestToMasterArray_t is array (natural range <>)
    of NiFpgaMasterWriteRequestToMaster_t;

  type NiFpgaMasterWriteDataFromMasterArray_t is array (natural range <>)
    of NiFpgaMasterWriteDataFromMaster_t;

  type NiFpgaMasterWriteDataToMasterArray_t is array (natural range <>)
    of NiFpgaMasterWriteDataToMaster_t;

  type NiFpgaMasterWriteStatusToMasterArray_t is array (natural range <>)
    of NiFpgaMasterWriteStatusToMaster_t;

  type NiFpgaMasterReadRequestFromMasterArray_t is array (natural range <>)
    of NiFpgaMasterReadRequestFromMaster_t;

  type NiFpgaMasterReadRequestToMasterArray_t is array (natural range <>)
    of NiFpgaMasterReadRequestToMaster_t;

  type NiFpgaMasterReadDataToMasterArray_t is array (natural range <>)
    of NiFpgaMasterReadDataToMaster_t;

end PkgDmaPortCommIfcMasterPort;

package body PkgDmaPortCommIfcMasterPort is

  function SizeOf(Var : NiFpgaMasterWriteRequestFromMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                   -- Request
    RetVal := RetVal + Var.Space'length;    -- Space
    RetVal := RetVal + Var.Address'length;  -- Address
    RetVal := RetVal + Var.Baggage'length;  -- Baggage
    RetVal := RetVal + Var.ByteSwap'length; -- ByteSwap
    RetVal := RetVal + Var.ByteLane'length; -- ByteSwap
    RetVal := RetVal + Var.ByteCount'length;-- ByteCount
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : NiFpgaMasterWriteRequestToMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : NiFpgaMasterWriteDataFromMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + Var.Data'length;
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : NiFpgaMasterWriteDataToMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                     -- Transfer Start
    RetVal := RetVal + 1;                     -- Transfer End
    RetVal := RetVal + Var.Space'length;      -- Space
    RetVal := RetVal + Var.ByteLane'length;   -- ByteSwap
    RetVal := RetVal + Var.ByteCount'length;  -- ByteCount
    RetVal := RetVal + Var.ByteEnable'length; -- ByteCount
    RetVal := RetVal + 1;                     -- Pop
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : NiFpgaMasterWriteStatusToMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                       -- Ready
    RetVal := RetVal + Var.Space'length;        -- Space
    RetVal := RetVal + Var.ByteCount'length;    -- ByteCount
    RetVal := RetVal + 1;  -- ErrorStatus
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : NiFpgaMasterReadRequestFromMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                   -- Request
    RetVal := RetVal + Var.Space'length;    -- Space
    RetVal := RetVal + Var.Address'length;  -- Address
    RetVal := RetVal + Var.Baggage'length;  -- Baggage
    RetVal := RetVal + Var.ByteSwap'length; -- ByteSwap
    RetVal := RetVal + Var.ByteLane'length; -- ByteSwap
    RetVal := RetVal + Var.ByteCount'length;-- ByteCount
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : NiFpgaMasterReadRequestToMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : NiFpgaMasterReadDataToMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                     -- Transfer Start
    RetVal := RetVal + 1;                     -- Transfer End
    RetVal := RetVal + Var.Space'length;      -- Space
    RetVal := RetVal + Var.ByteLane'length;   -- ByteSwap
    RetVal := RetVal + Var.ByteCount'length;  -- ByteCount
    RetVal := RetVal + 1;                     -- ErrorStatus
    RetVal := RetVal + Var.ByteEnable'length; -- ByteEnable
    RetVal := RetVal + 1;                     -- Push
    RetVal := RetVal + Var.Data'length;       -- Data
    return RetVal;
  end function SizeOf;

end PkgDmaPortCommIfcMasterPort;