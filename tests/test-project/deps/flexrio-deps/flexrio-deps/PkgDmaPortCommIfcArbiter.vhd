-------------------------------------------------------------------------------
--
-- File: PkgDmaPortCommIfcArbiter.vhd
-- Author: Haider Khan
-- Original Project: LV FPGA Chinch Interface
-- Date: 24 September 2007
--
-------------------------------------------------------------------------------
-- (c) 2007 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   This package file implements utilities used by the Dma Port interface 
-- arbiter components.
--
-------------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

Package PkgDmaPortCommIfcArbiter is

  -----------------------------------------------------------------------------
  -- ArbVecMSB
  --
  -- This function returns the highest index of an arbiter vector based on the
  -- number of streams.  Normally, this could simply be done along the lines of
  -- ArrayType_t(NumOfStrms - 1 downto 0), but the length needs to be a minimum
  -- of size 1, even though that one element will be unused.  Therefore, this
  -- function just returns NumOfStrms-1, unless there are 0 streams, in which
  -- case we return 0 instead of -1.
  -- 
  --
  -- Inputs:
  --
  --   NumOfStrms : The number of streams requesting arbiter access.
  --
  --
  -- Outputs:
  --
  --   Vector MSB : The highest end of the range for the vector or array
  --                associated with the streams.
  --
  -----------------------------------------------------------------------------
  function ArbVecMSB(NumOfStrms : natural) return natural;
  
  -- The number of streams to allocate for each sub arbiter for the in and out
  -- stream arbiters.
  constant kNumStreamsPerSubArbiter : natural := 4;

  type NiDmaArbReq_t is record
    NormalReq : std_logic;
    EmergencyReq : std_logic;
    DoneStrb : std_logic;
  end record;
  constant kNiDmaArbReqZero : NiDmaArbReq_t := (others => '0');

  type NiDmaArbReqArray_t is array ( natural range<> ) of NiDmaArbReq_t;

  -- These functions extract an array of one field of the record. These 
  -- are mostly to simplify the update from separate arrays to an array 
  -- of records.
  function GetNormalReq ( val : NiDmaArbReqArray_t ) return std_logic_vector;
  function GetEmergencyReq ( val : NiDmaArbReqArray_t ) return std_logic_vector;
  function GetDoneStrb ( val : NiDmaArbReqArray_t ) return std_logic_vector;

  type NiDmaArbGrant_t is record
    Grant : std_logic;
  end record;
  constant kNiDmaArbGrantZero : NiDmaArbGrant_t := (others => '0');

  type NiDmaArbGrantArray_t is array ( natural range<> ) of NiDmaArbGrant_t;

  function to_NiDmaArbGrantArray_t ( val : std_logic_vector ) return NiDmaArbGrantArray_t;

end Package PkgDmaPortCommIfcArbiter;

Package body PkgDmaPortCommIfcArbiter is

  function ArbVecMSB (NumOfStrms : natural) return natural is  
  begin
    if NumOfStrms=0 then
      return 0;
    else 
      return NumOfStrms-1;
    end if;
  end function;

  function to_NiDmaArbGrantArray_t ( val : std_logic_vector ) return NiDmaArbGrantArray_t is
    variable rval : NiDmaArbGrantArray_t (val'range);
  begin
    for i in val'range loop
      rval ( i ) := (Grant => val ( i ));
    end loop;

    return rval;
  end function to_NiDmaArbGrantArray_t;

  function GetNormalReq ( val : NiDmaArbReqArray_t ) return std_logic_vector is
    variable rval : std_logic_vector ( val'range );
  begin
    for i in val'range loop
      rval ( i ) := val ( i ).NormalReq;
    end loop;
    return rval;
  end function GetNormalReq;

  function GetEmergencyReq ( val : NiDmaArbReqArray_t ) return std_logic_vector is
    variable rval : std_logic_vector ( val'range );
  begin
    for i in val'range loop
      rval ( i ) := val ( i ).EmergencyReq;
    end loop;
    return rval;
  end function GetEmergencyReq;

  function GetDoneStrb ( val : NiDmaArbReqArray_t ) return std_logic_vector is
    variable rval : std_logic_vector ( val'range );
  begin
    for i in val'range loop
      rval ( i ) := val ( i ).DoneStrb;
    end loop;
    return rval;
  end function GetDoneStrb;

end Package body PkgDmaPortCommIfcArbiter;

