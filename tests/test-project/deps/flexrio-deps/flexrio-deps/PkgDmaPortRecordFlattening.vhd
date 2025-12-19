-------------------------------------------------------------------------------
--
-- File: PkgDmaPortRecordFlattening.vhd
-- Author: Hector Rubio
-- Original Project: CHInCh 2
-- Date:  25 9 2014
--
-------------------------------------------------------------------------------
-- (c) 2014 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--    Provide functions to flatten and unflatten record types at the port map of the
--    InChWORM so pre-synthesized netlist will be portable across synthesizer versions
--    (e.g. between Vivado 2013.2 and 2013.3) by using only arrays at the ports but
--    enabling the user to connect those ports to the record type signals easily.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;
  use work.PkgNiDma.all;
  use work.PkgBaRegPort.all;
  use work.PkgSwitchedChinch.all;

package PkgDmaPortRecordFlattening is

  -----------------------------------------------------
  -- REG PORTS (FROM PkgBaRegPort)

  subtype FlatBaRegPortIn_t is std_logic_vector(
    SizeOf(kBaRegPortInZero) - 1 downto 0);

  function Flatten(Var : BaRegPortIn_t) return FlatBaRegPortIn_t;
  function UnFlatten(Var  : FlatBaRegPortIn_t) return BaRegPortIn_t;

  subtype FlatBaRegPortOut_t is std_logic_vector(
    SizeOf(kBaRegPortOutZero) - 1 downto 0);

  function Flatten(Var : BaRegPortOut_t) return FlatBaRegPortOut_t;
  function UnFlatten(Var  : FlatBaRegPortOut_t) return BaRegPortOut_t;

  ------------------------------------------------------------------------------
  -- Input DMA (from PkgNiDma)

  subtype FlatNiDmaInputRequestToDma_t   is std_logic_vector(
    SizeOf(kNiDmaInputRequestToDmaZero) + 1 - 1 downto 0);-- Include request bit itself
  subtype FlatNiDmaInputRequestFromDma_t is std_logic_vector(0 downto 0);
  subtype FlatNiDmaInputDataToDma_t      is std_logic_vector(NiDmaData_t'length-1 downto 0);
  subtype FlatNiDmaInputDataFromDma_t    is std_logic_vector(
    SizeOf(kNiDmaInputDataFromDmaZero) - 1 downto 0);
  subtype FlatNiDmaInputStatusFromDma_t  is std_logic_vector(
    SizeOf(kNiDmaInputStatusFromDmaZero) - 1 downto 0);

  function Flatten(Var : NiDmaInputRequestToDma_t) return FlatNiDmaInputRequestToDma_t;
  function UnFlatten(Var : FlatNiDmaInputRequestToDma_t) return NiDmaInputRequestToDma_t;

  function Flatten(Var : NiDmaInputRequestFromDma_t) return FlatNiDmaInputRequestFromDma_t;
  function UnFlatten(Var : FlatNiDmaInputRequestFromDma_t) return NiDmaInputRequestFromDma_t;

  function Flatten(Var : NiDmaInputDataToDma_t) return FlatNiDmaInputDataToDma_t;
  function UnFlatten(Var : FlatNiDmaInputDataToDma_t) return NiDmaInputDataToDma_t;

  function Flatten(Var : NiDmaInputDataFromDma_t) return FlatNiDmaInputDataFromDma_t;
  function UnFlatten(Var : FlatNiDmaInputDataFromDma_t) return NiDmaInputDataFromDma_t;

  function Flatten(Var : NiDmaInputStatusFromDma_t) return FlatNiDmaInputStatusFromDma_t;
  function UnFlatten(Var : FlatNiDmaInputStatusFromDma_t) return NiDmaInputStatusFromDma_t;

  ------------------------------------------------
  -- Output DMA (from PkgNiDma)
  subtype FlatNiDmaOutputRequestToDma_t   is std_logic_vector(
    SizeOf(kNiDmaOutputRequestToDmaZero) + 1 - 1 downto 0);-- Include request bit itself
  subtype FlatNiDmaOutputRequestFromDma_t is std_logic_vector(0 downto 0);
  subtype FlatNiDmaOutputDataFromDma_t    is std_logic_vector(
    SizeOf(kNiDmaOutputDataFromDmaZero) - 1 downto 0);

  function Flatten(Var : NiDmaOutputRequestToDma_t) return FlatNiDmaOutputRequestToDma_t;
  function UnFlatten(Var : FlatNiDmaOutputRequestToDma_t) return NiDmaOutputRequestToDma_t;

  function Flatten(Var : NiDmaOutputRequestFromDma_t) return FlatNiDmaOutputRequestFromDma_t;
  function UnFlatten(Var : FlatNiDmaOutputRequestFromDma_t) return NiDmaOutputRequestFromDma_t;

  function Flatten(Var : NiDmaOutputDataFromDma_t) return FlatNiDmaOutputDataFromDma_t;
  function UnFlatten(Var : FlatNiDmaOutputDataFromDma_t) return NiDmaOutputDataFromDma_t;

  ------------------------------------------------------------------------------
  -- High Speed Sink Interface (from PkgNiDma)

  constant kFlatHighSpeedSinkFromDmaSize : natural := SizeOf(kNiDmaHighSpeedSinkFromDmaZero);

  subtype FlatNiDmaHighSpeedSinkFromDma_t is std_logic_vector(kFlatHighSpeedSinkFromDmaSize-1 downto 0);

  function Flatten(Var : NiDmaHighSpeedSinkFromDma_t) return FlatNiDmaHighSpeedSinkFromDma_t;
  function UnFlatten(Var : FlatNiDmaHighSpeedSinkFromDma_t) return NiDmaHighSpeedSinkFromDma_t;

  ------------------------------------------------------------------------------
  -- Link Interface (from PkgSwitchedChinch)
  constant kFlatSwitchedLinkTxSize : natural := 64 + -- Data
                                                 1 + -- Ready
                                                 1 + -- LastWord
                                                 4;  -- RFR_Delay
  constant kFlatSwitchedLinkRxSize : natural := 1 + -- Accept
                                                1;  -- ReadyForRead

  subtype FlatSwitchedLinkTx_t is std_logic_vector(kFlatSwitchedLinkTxSize-1 downto 0);
  subtype FlatSwitchedLinkRx_t is std_logic_vector(kFlatSwitchedLinkRxSize-1 downto 0);

  function Flatten(Var : SwitchedLinkTx_t) return FlatSwitchedLinkTx_t;
  function UnFlatten(Var : FlatSwitchedLinkTx_t) return SwitchedLinkTx_t;
  function Flatten(Var : SwitchedLinkRx_t) return FlatSwitchedLinkRx_t;
  function UnFlatten(Var : FlatSwitchedLinkRx_t) return SwitchedLinkRx_t;

end PkgDmaPortRecordFlattening;

package body PkgDmaPortRecordFlattening is

  -----------------------------------------------------
  -- REG PORTS (FROM PkgBaRegPort)
  -- type BaRegPortIn_t is record
  --   Address : BaRegPortAddress_t;
  --   Data : BaRegPortData_t;
  --   WtStrobe : BaRegPortStrobe_t;
  --   RdStrobe : BaRegPortStrobe_t;
  -- end record;

  -- type BaRegPortOut_t is record
  --   Data : BaRegPortData_t;
  --   Acknowledge : boolean;
  -- end record;

  function Flatten(Var : BaRegPortIn_t) return FlatBaRegPortIn_t is
    variable Index  : natural := 0;
    variable RetVal : FlatBaRegPortIn_t;
  begin
    RetVal(Index + kBaRegPortAddressWidth - 1 downto Index)     := std_logic_vector(Var.Address);
      Index := Index + kBaRegPortAddressWidth;
    RetVal(Index + kBaRegPortDataWidth - 1 downto Index)        := std_logic_vector(Var.Data);
      Index := Index + kBaRegPortDataWidth;
    RetVal(Index + kBaRegPortDataWidthInBytes - 1 downto Index) := to_StdLogicVector(Var.WtStrobe);
      Index := Index + kBaRegPortDataWidthInBytes;
    RetVal(Index + kBaRegPortDataWidthInBytes - 1 downto Index) := to_StdLogicVector(Var.RdStrobe);
      Index := Index + kBaRegPortDataWidthInBytes;

    assert Index = RetVal'length report "Flatten function size missmatch" severity failure;
    return RetVal;
  end function Flatten;

  function UnFlatten(Var  : FlatBaRegPortIn_t) return BaRegPortIn_t is
    variable Index  : natural := 0;
    variable RetVal : BaRegPortIn_t;
  begin
    RetVal.Address := BaRegPortAddress_t(Var(Index + kBaRegPortAddressWidth - 1 downto Index));
      Index := Index + kBaRegPortAddressWidth;
    RetVal.Data    := BaRegPortData_t(Var(Index + kBaRegPortDataWidth - 1 downto Index));
      Index := Index + kBaRegPortDataWidth;
    RetVal.WtStrobe := to_BooleanVector(Var(Index + kBaRegPortDataWidthInBytes - 1 downto Index));
      Index := Index + kBaRegPortDataWidthInBytes;
    RetVal.RdStrobe := to_BooleanVector(Var(Index + kBaRegPortDataWidthInBytes - 1 downto Index));
      Index := Index + kBaRegPortDataWidthInBytes;

    return RetVal;
  end function UnFlatten;

  function Flatten(Var : BaRegPortOut_t) return FlatBaRegPortOut_t is
    variable Index  : natural := 0;
    variable RetVal : FlatBaRegPortOut_t;
  begin
    RetVal(Index + kBaRegPortDataWidth - 1 downto Index) := std_logic_vector(Var.Data);
      Index := Index + kBaRegPortDataWidth;
    RetVal(Index)                                        := to_StdLogic(Var.Ack);
      Index := Index + 1;

    assert Index = RetVal'length report "Flatten function size missmatch" severity failure;
    return RetVal;
  end function Flatten;

  function UnFlatten(Var  : FlatBaRegPortOut_t) return BaRegPortOut_t is
    variable Index  : natural := 0;
    variable RetVal : BaRegPortOut_t;
  begin
    RetVal.Data        := BaRegPortData_t(Var(Index + kBaRegPortDataWidth - 1 downto Index));
      Index := Index + kBaRegPortDataWidth;
    RetVal.Ack := to_Boolean(Var(Index));
      Index := Index + 1;

    return RetVal;
  end function UnFlatten;

  ------------------------------------------------------------------------------
  -- Input DMA (from PkgNiDma)
  --   type NiDmaInputRequestToDma_t is record
  --   Request : boolean;
  --   Space : NiDmaSpace_t;
  --   Channel : NiDmaGeneralChannel_t;
  --   Address : NiDmaAddress_t;
  --   Baggage : NiDmaBaggage_t;
  --   ByteSwap : NiDmaByteSwap_t;
  --   ByteLane : NiDmaByteLane_t;
  --   ByteCount : NiDmaInputByteCount_t;
  --   Done : boolean;
  --   EndOfRecord : boolean;
  -- end record;

  function Flatten(Var : NiDmaInputRequestToDma_t) return FlatNiDmaInputRequestToDma_t is
    variable Index  : natural;
    variable RetVal : FlatNiDmaInputRequestToDma_t;
  begin
    Index := 0;
    RetVal(Index)                                       := to_StdLogic(Var.Request);
      Index := Index + 1;
    RetVal(Index + Var.Space'length-1     downto Index) := std_logic_vector(Var.Space);
      Index := Index + Var.Space'length;
    RetVal(Index + Var.Channel'length-1   downto Index) := std_logic_vector(Var.Channel);
      Index := Index + Var.Channel'length;
    RetVal(Index + Var.Address'length-1   downto Index) := std_logic_vector(Var.Address);
      Index := Index + Var.Address'length;
    RetVal(Index + Var.Baggage'length-1   downto Index) := std_logic_vector(Var.Baggage);
      Index := Index + Var.Baggage'length;
    RetVal(Index + Var.ByteSwap'length-1  downto Index) := std_logic_vector(Var.ByteSwap);
      Index := Index + Var.ByteSwap'length;
    RetVal(Index + Var.ByteLane'length-1  downto Index) := std_logic_vector(Var.ByteLane);
      Index := Index + Var.ByteLane'length;
    RetVal(Index + Var.ByteCount'length-1 downto Index) := std_logic_vector(Var.ByteCount);
      Index := Index + Var.ByteCount'length;
    RetVal(Index)                                       := to_StdLogic(Var.Done);
      Index := Index + 1;
    RetVal(Index)                                       := to_StdLogic(Var.EndOfRecord);
      Index := Index + 1;

    assert Index = RetVal'length report "Flatten function size missmatch" severity failure;
    return RetVal;
  end function Flatten;

  function UnFlatten(Var : FlatNiDmaInputRequestToDma_t) return NiDmaInputRequestToDma_t is
    variable Index  : natural;
    variable RetVal : NiDmaInputRequestToDma_t;
  begin
    Index := 0;
    RetVal.Request   := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.Space     := NiDmaSpace_t(Var(Index + RetVal.Space'length-1 downto Index));
      Index := Index + RetVal.Space'length;
    RetVal.Channel   := NiDmaGeneralChannel_t(Var(Index + RetVal.Channel'length-1 downto Index));
      Index := Index + RetVal.Channel'length;
    RetVal.Address   := NiDmaAddress_t(Var(Index + RetVal.Address'length-1 downto Index));
      Index := Index + RetVal.Address'length;
    RetVal.Baggage   := NiDmaBaggage_t(Var(Index + RetVal.Baggage'length-1 downto Index));
      Index := Index + RetVal.Baggage'length;
    RetVal.ByteSwap  := NiDmaByteSwap_t(Var(Index + RetVal.ByteSwap'length-1 downto Index));
      Index := Index + RetVal.ByteSwap'length;
    RetVal.ByteLane  := NiDmaByteLane_t(Var(Index + RetVal.ByteLane'length-1 downto Index));
      Index := Index + RetVal.ByteLane'length;
    RetVal.ByteCount := NiDmaInputByteCount_t(Var(Index + RetVal.ByteCount'length-1 downto Index));
      Index := Index + RetVal.ByteCount'length;
    RetVal.Done      := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.EndOfRecord := to_Boolean(Var(Index));
      Index := Index + 1;

    return RetVal;
  end function UnFlatten;

  -- type NiDmaInputRequestFromDma_t is record
  --   Acknowledge : boolean;
  -- end record;

  function Flatten(Var : NiDmaInputRequestFromDma_t) return FlatNiDmaInputRequestFromDma_t is
    variable RetVal : FlatNiDmaInputRequestFromDma_t;
  begin
    RetVal(0) := to_StdLogic(Var.Acknowledge);

    assert RetVal'length = 1 report "Flatten function size missmatch" severity failure;
    return RetVal;
  end function Flatten;

  function UnFlatten(Var : FlatNiDmaInputRequestFromDma_t) return NiDmaInputRequestFromDma_t is
    variable RetVal : NiDmaInputRequestFromDma_t;
  begin
    RetVal.Acknowledge := to_Boolean(Var(0));

    return RetVal;
  end function UnFlatten;

  -- type NiDmaInputDataToDma_t is record
  --   Data : NiDmaData_t;
  -- end record;

  function Flatten(Var : NiDmaInputDataToDma_t) return FlatNiDmaInputDataToDma_t is
    variable RetVal : FlatNiDmaInputDataToDma_t;
  begin
    RetVal := std_logic_vector(Var.Data);

    assert RetVal'length = Var.Data'length report "Flatten function size missmatch" severity failure;
    return RetVal;
  end function Flatten;

  function UnFlatten(Var : FlatNiDmaInputDataToDma_t) return NiDmaInputDataToDma_t is
    variable RetVal : NiDmaInputDataToDma_t;
  begin
    RetVal.Data := NiDmaData_t(Var);

    return RetVal;
  end function UnFlatten;

  -- type NiDmaInputDataFromDma_t is record
  --   TransferStart : boolean;
  --   TransferEnd : boolean;
  --   Space : NiDmaSpace_t;
  --   Channel : NiDmaGeneralChannel_t;
  --   DmaChannel : NiDmaDmaChannelOneHot_t;
  --   DirectChannel : NiDmaDirectChannelOneHot_t;
  --   ByteLane : NiDmaByteLane_t;
  --   ByteCount : NiDmaBusByteCount_t;
  --   Done : boolean;
  --   EndOfRecord : boolean;
  --   ByteEnable : NiDmaByteEnable_t;
  --   Pop : boolean;
  -- end record;

  function Flatten(Var : NiDmaInputDataFromDma_t) return FlatNiDmaInputDataFromDma_t is
    variable Index  : natural;
    variable RetVal : FlatNiDmaInputDataFromDma_t;
  begin
    Index := 0;
    RetVal(Index)                                           := to_StdLogic(Var.TransferStart);
      Index := Index + 1;
    RetVal(Index)                                           := to_StdLogic(Var.TransferEnd);
      Index := Index + 1;
    RetVal(Index + Var.Space'length-1 downto Index)         := std_logic_vector(Var.Space);
      Index := Index + Var.Space'length;
    RetVal(Index + Var.Channel'length-1 downto Index)       := std_logic_vector(Var.Channel);
      Index := Index + Var.Channel'length;
    RetVal(Index + Var.DmaChannel'length-1 downto Index)    := to_StdLogicVector(Var.DmaChannel);
      Index := Index + Var.DmaChannel'length;
    RetVal(Index + Var.DirectChannel'length-1 downto Index) := to_StdLogicVector(Var.DirectChannel);
      Index := Index + Var.DirectChannel'length;
    RetVal(Index + Var.ByteLane'length-1 downto Index)      := std_logic_vector(Var.ByteLane);
      Index := Index + Var.ByteLane'length;
    RetVal(Index + Var.ByteCount'length-1 downto Index)     := std_logic_vector(Var.ByteCount);
      Index := Index + Var.ByteCount'length;
    RetVal(Index)                                           := to_StdLogic(Var.Done);
      Index := Index + 1;
    RetVal(Index)                                           := to_StdLogic(Var.EndOfRecord);
      Index := Index + 1;
    RetVal(Index + Var.ByteEnable'length-1 downto Index)    := to_StdLogicVector(Var.ByteEnable);
      Index := Index + Var.ByteEnable'length;
    RetVal(Index)                                           := to_StdLogic(Var.Pop);
      Index := Index + 1;

    assert Index = RetVal'length report "Flatten function size missmatch" severity failure;
    return RetVal;
  end function Flatten;

  function UnFlatten(Var : FlatNiDmaInputDataFromDma_t) return NiDmaInputDataFromDma_t is
    variable Index  : natural;
    variable RetVal : NiDmaInputDataFromDma_t;
  begin
    Index := 0;
    RetVal.TransferStart := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.TransferEnd   := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.Space         := NiDmaSpace_t(Var(Index + RetVal.Space'length-1 downto Index));
      Index := Index + RetVal.Space'length;
    RetVal.Channel       := NiDmaGeneralChannel_t(Var(Index + RetVal.Channel'length-1 downto Index));
      Index := Index + RetVal.Channel'length;
    RetVal.DmaChannel    := to_BooleanVector(Var(Index + RetVal.DmaChannel'length-1 downto Index));
      Index := Index + RetVal.DmaChannel'length;
    RetVal.DirectChannel := to_BooleanVector(Var(Index + RetVal.DirectChannel'length-1 downto Index));
      Index := Index + RetVal.DirectChannel'length;
    RetVal.ByteLane      := NiDmaByteLane_t(Var(Index + RetVal.ByteLane'length-1 downto Index));
      Index := Index + RetVal.ByteLane'length;
    RetVal.ByteCount     := NiDmaBusByteCount_t(Var(Index + RetVal.ByteCount'length-1 downto Index));
      Index := Index + RetVal.ByteCount'length;
    RetVal.Done          := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.EndOfRecord   := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.ByteEnable    := to_BooleanVector(Var(Index + RetVal.ByteEnable'length-1 downto Index));
      Index := Index + RetVal.ByteEnable'length;
    RetVal.Pop           := to_Boolean(Var(Index));
      Index := Index + 1;

    return RetVal;
  end function UnFlatten;

  -- type NiDmaInputStatusFromDma_t is record
  --   Ready : boolean;
  --   Space : NiDmaSpace_t;
  --   Channel : NiDmaGeneralChannel_t;
  --   DmaChannel : NiDmaDmaChannelOneHot_t;
  --   DirectChannel : NiDmaDirectChannelOneHot_t;
  --   ByteCount : NiDmaInputByteCount_t;
  --   Done : boolean;
  --   EndOfRecord : boolean;
  --   ErrorStatus : boolean;
  -- end record;

  function Flatten(Var : NiDmaInputStatusFromDma_t) return FlatNiDmaInputStatusFromDma_t is
    variable Index  : natural;
    variable RetVal : FlatNiDmaInputStatusFromDma_t;
  begin
    Index := 0;
    RetVal(Index)                                           := to_StdLogic(Var.Ready);
      Index := Index + 1;
    RetVal(Index + Var.Space'length-1 downto Index)         := std_logic_vector(Var.Space);
      Index := Index + Var.Space'length;
    RetVal(Index + Var.Channel'length-1 downto Index)       := std_logic_vector(Var.Channel);
      Index := Index + Var.Channel'length;
    RetVal(Index + Var.DmaChannel'length-1 downto Index)    := to_StdLogicVector(Var.DmaChannel);
      Index := Index + Var.DmaChannel'length;
    RetVal(Index + Var.DirectChannel'length-1 downto Index) := to_StdLogicVector(Var.DirectChannel);
      Index := Index + Var.DirectChannel'length;
    RetVal(Index + Var.ByteCount'length-1 downto Index)     := std_logic_vector(Var.ByteCount);
      Index := Index + Var.ByteCount'length;
    RetVal(Index)                                           := to_StdLogic(Var.Done);
      Index := Index + 1;
    RetVal(Index)                                           := to_StdLogic(Var.EndOfRecord);
      Index := Index + 1;
    RetVal(Index)                                           := to_StdLogic(Var.ErrorStatus);
      Index := Index + 1;

    assert Index = RetVal'length report "Flatten function size missmatch" severity failure;
    return RetVal;
  end function Flatten;

  function UnFlatten(Var : FlatNiDmaInputStatusFromDma_t) return NiDmaInputStatusFromDma_t is
    variable Index  : natural;
    variable RetVal : NiDmaInputStatusFromDma_t;
  begin
    Index := 0;
    RetVal.Ready         := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.Space         := NiDmaSpace_t(Var(Index + RetVal.Space'length-1 downto Index));
      Index := Index + RetVal.Space'length;
    RetVal.Channel       := NiDmaGeneralChannel_t(Var(Index + RetVal.Channel'length-1 downto Index));
      Index := Index + RetVal.Channel'length;
    RetVal.DmaChannel    := to_BooleanVector(Var(Index + RetVal.DmaChannel'length-1 downto Index));
      Index := Index + RetVal.DmaChannel'length;
    RetVal.DirectChannel := to_BooleanVector(Var(Index + RetVal.DirectChannel'length-1 downto Index));
      Index := Index + RetVal.DirectChannel'length;
    RetVal.ByteCount     := NiDmaInputByteCount_t(Var(Index + RetVal.ByteCount'length-1 downto Index));
      Index := Index + RetVal.ByteCount'length;
    RetVal.Done          := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.EndOfRecord   := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.ErrorStatus   := to_Boolean(Var(Index));
      Index := Index + 1;

    return RetVal;
  end function UnFlatten;

  ------------------------------------------------------------------------------
  -- Output DMA (from PkgNiDma)
  -- type NiDmaOutputRequestToDma_t is record
  --   Request : boolean;
  --   Space : NiDmaSpace_t;
  --   Channel : NiDmaGeneralChannel_t;
  --   Address : NiDmaAddress_t;
  --   Baggage : NiDmaBaggage_t;
  --   ByteSwap : NiDmaByteSwap_t;
  --   ByteLane : NiDmaByteLane_t;
  --   ByteCount : NiDmaOutputByteCount_t;
  --   Done : boolean;
  --   EndOfRecord : boolean;
  -- end record;

  function Flatten(Var : NiDmaOutputRequestToDma_t) return FlatNiDmaOutputRequestToDma_t is
    variable Index  : natural;
    variable RetVal : FlatNiDmaOutputRequestToDma_t;
  begin
    Index := 0;
    RetVal(Index)                                       := to_StdLogic(Var.Request);
      Index := Index + 1;
    RetVal(Index + Var.Space'length-1 downto Index)     := std_logic_vector(Var.Space);
      Index := Index + Var.Space'length;
    RetVal(Index + Var.Channel'length-1 downto Index)   := std_logic_vector(Var.Channel);
      Index := Index + Var.Channel'length;
    RetVal(Index + Var.Address'length-1 downto Index)   := std_logic_vector(Var.Address);
      Index := Index + Var.Address'length;
    RetVal(Index + Var.Baggage'length-1 downto Index)   := std_logic_vector(Var.Baggage);
      Index := Index + Var.Baggage'length;
    RetVal(Index + Var.ByteSwap'length-1 downto Index)  := std_logic_vector(Var.ByteSwap);
      Index := Index + Var.ByteSwap'length;
    RetVal(Index + Var.ByteLane'length-1 downto Index)  := std_logic_vector(Var.ByteLane);
      Index := Index + Var.ByteLane'length;
    RetVal(Index + Var.ByteCount'length-1 downto Index) := std_logic_vector(Var.ByteCount);
      Index := Index + Var.ByteCount'length;
    RetVal(Index)                                       := to_StdLogic(Var.Done);
      Index := Index + 1;
    RetVal(Index)                                       := to_StdLogic(Var.EndOfRecord);
      Index := Index + 1;

    assert Index = RetVal'length report "Flatten function size missmatch" severity failure;
    return RetVal;
  end function Flatten;

  function UnFlatten(Var : FlatNiDmaOutputRequestToDma_t) return NiDmaOutputRequestToDma_t is
    variable Index  : natural;
    variable RetVal : NiDmaOutputRequestToDma_t;
  begin
    Index := 0;
    RetVal.Request     := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.Space       := NiDmaSpace_t(Var(Index + RetVal.Space'length-1 downto Index));
      Index := Index + RetVal.Space'length;
    RetVal.Channel     := NiDmaGeneralChannel_t(Var(Index + RetVal.Channel'length-1 downto Index));
      Index := Index + RetVal.Channel'length;
    RetVal.Address     := NiDmaAddress_t(Var(Index + RetVal.Address'length-1 downto Index));
      Index := Index + RetVal.Address'length;
    RetVal.Baggage     := NiDmaBaggage_t(Var(Index + RetVal.Baggage'length-1 downto Index));
      Index := Index + RetVal.Baggage'length;
    RetVal.ByteSwap    := NiDmaByteSwap_t(Var(Index + RetVal.ByteSwap'length-1 downto Index));
      Index := Index + RetVal.ByteSwap'length;
    RetVal.ByteLane    := NiDmaByteLane_t(Var(Index + RetVal.ByteLane'length-1 downto Index));
      Index := Index + RetVal.ByteLane'length;
    RetVal.ByteCount   := NiDmaOutputByteCount_t(Var(Index + RetVal.ByteCount'length-1 downto Index));
      Index := Index + RetVal.ByteCount'length;
    RetVal.Done        := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.EndOfRecord := to_Boolean(Var(Index));
      Index := Index + 1;

    return RetVal;
  end function UnFlatten;

  -- type NiDmaOutputRequestFromDma_t is record
  --   Acknowledge : boolean;
  -- end record;

  function Flatten(Var : NiDmaOutputRequestFromDma_t) return FlatNiDmaOutputRequestFromDma_t is
    variable RetVal : FlatNiDmaOutputRequestFromDma_t;
  begin
    RetVal(0) := to_StdLogic(Var.Acknowledge);

    assert RetVal'length = 1 report "Flatten function size missmatch" severity failure;
    return RetVal;
  end function Flatten;

  function UnFlatten(Var : FlatNiDmaOutputRequestFromDma_t) return NiDmaOutputRequestFromDma_t is
    variable RetVal : NiDmaOutputRequestFromDma_t;
  begin
    RetVal.Acknowledge := to_Boolean(Var(0));

    return RetVal;
  end function UnFlatten;

  -- type NiDmaOutputDataFromDma_t is record
  --   TransferStart : boolean;
  --   TransferEnd : boolean;
  --   Space : NiDmaSpace_t;
  --   Channel : NiDmaGeneralChannel_t;
  --   DmaChannel : NiDmaDmaChannelOneHot_t;
  --   DirectChannel : NiDmaDirectChannelOneHot_t;
  --   ByteLane : NiDmaByteLane_t;
  --   ByteCount : NiDmaBusByteCount_t;
  --   Done : boolean;
  --   EndOfRecord : boolean;
  --   ErrorStatus : boolean;
  --   ByteEnable : NiDmaByteEnable_t;
  --   Push : boolean;
  --   Data : NiDmaData_t;
  -- end record;

  function Flatten(Var : NiDmaOutputDataFromDma_t) return FlatNiDmaOutputDataFromDma_t is
    variable Index : natural;
    variable RetVal : FlatNiDmaOutputDataFromDma_t;
  begin
    Index := 0;
    RetVal(Index)                                           := to_StdLogic(Var.TransferStart);
      Index := Index + 1;
    RetVal(Index)                                           := to_StdLogic(Var.TransferEnd);
      Index := Index + 1;
    RetVal(Index + Var.Space'length-1 downto Index)         := std_logic_vector(Var.Space);
      Index := Index + Var.Space'length;
    RetVal(Index + Var.Channel'length-1 downto Index)       := std_logic_vector(Var.Channel);
      Index := Index + Var.Channel'length;
    RetVal(Index + Var.DmaChannel'length-1 downto Index)    := to_StdLogicVector(Var.DmaChannel);
      Index := Index + Var.DmaChannel'length;
    RetVal(Index + Var.DirectChannel'length-1 downto Index) := to_StdLogicVector(Var.DirectChannel);
      Index := Index + Var.DirectChannel'length;
    RetVal(Index + Var.ByteLane'length-1 downto Index)      := std_logic_vector(Var.ByteLane);
      Index := Index + Var.ByteLane'length;
    RetVal(Index + Var.ByteCount'length-1 downto Index)     := std_logic_vector(Var.ByteCount);
      Index := Index + Var.ByteCount'length;
    RetVal(Index)                                           := to_StdLogic(Var.Done);
      Index := Index + 1;
    RetVal(Index)                                           := to_StdLogic(Var.EndOfRecord);
      Index := Index + 1;
    RetVal(Index)                                           := to_StdLogic(Var.ErrorStatus);
      Index := Index + 1;
    RetVal(Index + Var.ByteEnable'length-1 downto Index)    := to_StdLogicVector(Var.ByteEnable);
      Index := Index + Var.ByteEnable'length;
    RetVal(Index)                                           := to_StdLogic(Var.Push);
      Index := Index + 1;
    RetVal(Index + Var.Data'length-1 downto Index)          := std_logic_vector(Var.Data);
      Index := Index + Var.Data'length;

    assert Index = RetVal'length report "Flatten function size missmatch" severity failure;
    return RetVal;
  end function Flatten;

  function UnFlatten(Var : FlatNiDmaOutputDataFromDma_t) return NiDmaOutputDataFromDma_t is
    variable Index : natural;
    variable RetVal : NiDmaOutputDataFromDma_t;
  begin
    Index := 0;
    RetVal.TransferStart := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.TransferEnd   := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.Space         := NiDmaSpace_t(Var(Index + RetVal.Space'length-1 downto Index));
      Index := Index + RetVal.Space'length;
    RetVal.Channel       := NiDmaGeneralChannel_t(Var(Index + RetVal.Channel'length-1 downto Index));
      Index := Index + RetVal.Channel'length;
    RetVal.DmaChannel    := to_BooleanVector(Var(Index + RetVal.DmaChannel'length-1 downto Index));
      Index := Index + RetVal.DmaChannel'length;
    RetVal.DirectChannel := to_BooleanVector(Var(Index + RetVal.DirectChannel'length-1 downto Index));
      Index := Index + RetVal.DirectChannel'length;
    RetVal.ByteLane      := NiDmaByteLane_t(Var(Index + RetVal.ByteLane'length-1 downto Index));
      Index := Index + RetVal.ByteLane'length;
    RetVal.ByteCount     := NiDmaBusByteCount_t(Var(Index + RetVal.ByteCount'length-1 downto Index));
      Index := Index + RetVal.ByteCount'length;
    RetVal.Done          := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.EndOfRecord   := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.ErrorStatus   := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.ByteEnable    := to_BooleanVector(Var(Index + RetVal.ByteEnable'length-1 downto Index));
      Index := Index + RetVal.ByteEnable'length;
    RetVal.Push          := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.Data          := NiDmaData_t(Var(Index + RetVal.Data'length-1 downto Index));
      Index := Index + RetVal.Data'length;

    return RetVal;
  end function UnFlatten;

  ------------------------------------------------------------------------------
  -- High Speed Sink Interface (from PkgNiDma)
  -- type NiDmaHighSpeedSinkFromDma_t is record
  --   TransferStart : boolean;
  --   TransferEnd : boolean;
  --   Address : NiDmaHighSpeedSinkAddress_t;
  --   ByteLane : NiDmaByteLane_t;
  --   ByteCount : NiDmaBusByteCount_t;
  --   ByteEnable : NiDmaByteEnable_t;
  --   Push : boolean;
  --   Data : NiDmaData_t;
  -- end record;

  function Flatten(Var : NiDmaHighSpeedSinkFromDma_t) return FlatNiDmaHighSpeedSinkFromDma_t is
    variable Index : natural;
    variable RetVal : FlatNiDmaHighSpeedSinkFromDma_t;
  begin
    Index := 0;
    RetVal(Index)                                        := to_StdLogic(Var.TransferStart);
      Index := Index + 1;
    RetVal(Index)                                        := to_StdLogic(Var.TransferEnd);
      Index := Index + 1;
    RetVal(Index + Var.Address'length-1 downto Index)    := std_logic_vector(Var.Address);
      Index := Index + Var.Address'length;
    RetVal(Index + Var.ByteLane'length-1 downto Index)   := std_logic_vector(Var.ByteLane);
      Index := Index + Var.ByteLane'length;
    RetVal(Index + Var.ByteCount'length-1 downto Index)  := std_logic_vector(Var.ByteCount);
      Index := Index + Var.ByteCount'length;
    RetVal(Index + Var.ByteEnable'length-1 downto Index) := to_StdLogicVector(Var.ByteEnable);
      Index := Index + Var.ByteEnable'length;
    RetVal(Index)                                        := to_StdLogic(Var.Push);
      Index := Index + 1;
    RetVal(Index + Var.Data'length-1 downto Index)           := std_logic_vector(Var.Data);
      Index := Index + Var.Data'length;

    assert Index = RetVal'length report "Flatten function size missmatch" severity failure;
    return RetVal;
  end function Flatten;

  function UnFlatten(Var : FlatNiDmaHighSpeedSinkFromDma_t) return NiDmaHighSpeedSinkFromDma_t is
    variable Index : natural;
    variable RetVal : NiDmaHighSpeedSinkFromDma_t;
  begin
    Index := 0;
    RetVal.TransferStart := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.TransferEnd   := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.Address       := NiDmaHighSpeedSinkAddress_t(Var(Index + RetVal.Address'length-1 downto Index));
      Index := Index + RetVal.Address'length;
    RetVal.ByteLane      := NiDmaByteLane_t(Var(Index + RetVal.ByteLane'length-1 downto Index));
      Index := Index + RetVal.ByteLane'length;
    RetVal.ByteCount     := NiDmaBusByteCount_t(Var(Index + RetVal.ByteCount'length-1 downto Index));
      Index := Index + RetVal.ByteCount'length;
    RetVal.ByteEnable    := to_BooleanVector(Var(Index + RetVal.ByteEnable'length-1 downto Index));
      Index := Index + RetVal.ByteEnable'length;
    RetVal.Push          := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.Data          := NiDmaData_t(Var(Index + RetVal.Data'length-1 downto Index));
      Index := Index + RetVal.Data'length;

    return RetVal;
  end function UnFlatten;

  ------------------------------------------------------------------------------
  -- Link Interface (from PkgSwitchedChinch)

  function Flatten(Var : SwitchedLinkTx_t) return FlatSwitchedLinkTx_t is
    variable Index  : natural;
    variable RetVal : FlatSwitchedLinkTx_t;
  begin
    Index := 0;
    RetVal(Index + Var.Data'length-1 downto Index)      := std_logic_vector(Var.Data);
      Index := Index + Var.Data'length;
    RetVal(Index)                                       := to_StdLogic(Var.Ready);
      Index := Index + 1;
    RetVal(Index)                                       := to_StdLogic(Var.LastWord);
      Index := Index + 1;
    RetVal(Index + Var.RFR_Delay'length-1 downto Index) := std_logic_vector(Var.RFR_Delay);
      Index := Index + Var.RFR_Delay'length;

    assert Index = RetVal'length report "Flatten function size missmatch" severity failure;
    return RetVal;
  end function Flatten;

  function UnFlatten(Var : FlatSwitchedLinkTx_t) return SwitchedLinkTx_t is
    variable Index  : natural;
    variable RetVal : SwitchedLinkTx_t;
  begin
    Index := 0;
    RetVal.Data           := SwitchedPacketWord_t(Var(Index + RetVal.Data'length-1 downto Index));
      Index := Index + RetVal.Data'length;
    RetVal.Ready          := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.LastWord       := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.RFR_Delay      := RFR_Delay_t(Var(Index + RetVal.RFR_Delay'length-1 downto Index));
      Index := Index + RetVal.RFR_Delay'length;

    return RetVal;
  end function UnFlatten;

  function Flatten(Var : SwitchedLinkRx_t) return FlatSwitchedLinkRx_t is
    variable Index  : natural;
    variable RetVal : FlatSwitchedLinkRx_t;
  begin
    Index := 0;
    RetVal(Index)                                       := to_StdLogic(Var.Accept);
      Index := Index + 1;
    RetVal(Index)                                       := to_StdLogic(Var.ReadyForRead);
      Index := Index + 1;

    assert Index = RetVal'length report "Flatten function size missmatch" severity failure;
    return RetVal;
  end function Flatten;

  function UnFlatten(Var : FlatSwitchedLinkRx_t) return SwitchedLinkRx_t is
    variable Index  : natural;
    variable RetVal : SwitchedLinkRx_t;
  begin
    Index := 0;
    RetVal.Accept          := to_Boolean(Var(Index));
      Index := Index + 1;
    RetVal.ReadyForRead    := to_Boolean(Var(Index));
      Index := Index + 1;

    return RetVal;
  end function UnFlatten;


end PkgDmaPortRecordFlattening;
