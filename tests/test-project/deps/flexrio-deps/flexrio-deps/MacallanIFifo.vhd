------------------------------------------------------------------------------------------
--
-- File: MacallanIFifo.vhd
-- Author: Rolando Ortega
-- Original Project: Instruction Fifo for SDIs
-- Date: 19 May 2015
--
------------------------------------------------------------------------------------------
-- (c) 2015 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
------------------------------------------------------------------------------------------
--
-- Purpose:
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgNiUtilities.all;
-- Instruction Fifo
use work.PkgInstructionFifo.all;
-- Axi Stream
use work.PkgFlexRioAxiStream.all;
-- DmaPort
use work.PkgNiDma.all;
use work.PkgDmaPortRecordFlattening.all;
use work.PkgDmaPortCommIfcArbiter.all;
-- RegPort
use work.PkgBaRegPort.all;

--synthesis translate_off
library MacallanIFifo;
--synthesis translate_on

entity MacallanIFifo is

  port (
    aBusReset               : in  boolean;
    -------------------------------------------------------------------------------------
    -- Host Interface Side
    -------------------------------------------------------------------------------------
    DmaClk                  : in  std_logic;
    -- P2P Sink
    dHighSpeedSinkFromDma   : in  NiDmaHighSpeedSinkFromDma_t;
    -- RegPort
    dBaRegPortIn            : in  BaRegPortIn_t;
    dBaRegPortOutIFifo      : out BaRegPortOut_t;
    -- Input DmaPort
    dIFifoRequestFromDma    : in  NiDmaInputRequestFromDma_t;
    dIFifoRequestToDma      : out NiDmaInputRequestToDma_t;
    dIFifoDataFromDma       : in  NiDmaInputDataFromDma_t;
    dIFifoDataToDma         : out NiDmaInputDataToDma_t;
    dIFifoStatusFromDma     : in  NiDmaInputStatusFromDma_t;
    -- DmaPort Arbiter
    dIFifoArbReq            : out NiDmaArbReq_t;
    dIFifoArbGrant          : in  NiDmaArbGrant_t;
    -------------------------------------------------------------------------------------
    -- Fixed Logic
    -------------------------------------------------------------------------------------
    BusClk                  : in  std_logic;
    aPonReset               : in  boolean;
    -- Write Board Ctrl
    bAxiStreamDataToCtrl    : out AxiStreamData_t;
    bAxiStreamReadyFromCtrl : in  boolean;
    -- Read Board Ctrl
    bAxiStreamDataFromCtrl  : in  AxiStreamData_t;
    bAxiStreamReadyToCtrl   : out boolean;
    -------------------------------------------------------------------------------------
    -- The Window - AxiStream
    -------------------------------------------------------------------------------------
    aDiagramReset           : in  boolean;
    -- Axi Clock
    AxiClk                  : in  std_logic;
    -- Write CLIP
    xAxiStreamDataToClip    : out AxiStreamData_t;
    xAxiStreamReadyFromClip : in  boolean;
    -- Read CLIP
    xAxiStreamDataFromClip  : in  AxiStreamData_t;
    xAxiStreamReadyToClip   : out boolean;
    -------------------------------------------------------------------------------------
    -- Diagram IFifo
    -------------------------------------------------------------------------------------
    ViClk                   : in  std_logic;
    -- Write
    vIFifoWrData            : out IFifoWriteData_t;
    vIFifoWrDataValid       : out std_logic;
    vIFifoWrReadyForOutput  : in  std_logic;
    -- Read
    vIFifoRdData            : in  IFifoReadData_t;
    vIFifoRdIsError         : in  std_logic;
    vIFifoRdDataValid       : in  std_logic;
    vIFifoRdReadyForInput   : out std_logic
    );

end entity MacallanIFifo;

architecture wrap of MacallanIFifo is

  component MacallanIFifoN
    port (
      aBusReset                  : in  boolean;
      DmaClk                     : in  std_logic;
      dFlatHighSpeedSink         : in  FlatNiDmaHighSpeedSinkFromDma_t;
      dFlatBaRegPortIn           : in  FlatBaRegPortIn_t;
      dFlatBaRegPortOutIFifo     : out FlatBaRegPortOut_t;
      dFlatIFifoRequestFromDma   : in  FlatNiDmaInputRequestFromDma_t;
      dFlatIFifoRequestToDma     : out FlatNiDmaInputRequestToDma_t;
      dFlatIFifoDataFromDma      : in  FlatNiDmaInputDataFromDma_t;
      dFlatIFifoDataToDma        : out FlatNiDmaInputDataToDma_t;
      dFlatIFifoStatusFromDma    : in  FlatNiDmaInputStatusFromDma_t;
      dIFifoArbiterDone          : out std_logic;
      dIFifoArbiterGrant         : in  std_logic;
      dIFifoArbiterReq           : out std_logic;
      BusClk                     : in  std_logic;
      aPonReset                  : in  boolean;
      bFlatAxiStreamDataToCtrl   : out FlatAxiStreamData_t;
      bAxiStreamReadyFromCtrl    : in  boolean;
      bFlatAxiStreamDataFromCtrl : in  FlatAxiStreamData_t;
      bAxiStreamReadyToCtrl      : out boolean;
      aDiagramReset              : in  boolean;
      AxiClk                     : in  std_logic;
      xFlatAxiStreamDataToClip   : out FlatAxiStreamData_t;
      xAxiStreamReadyFromClip    : in  boolean;
      xFlatAxiStreamDataFromClip : in  FlatAxiStreamData_t;
      xAxiStreamReadyToClip      : out boolean;
      ViClk                      : in  std_logic;
      vIFifoWrData               : out IFifoWriteData_t;
      vIFifoWrDataValid          : out std_logic;
      vIFifoWrReadyForOutput     : in  std_logic;
      vIFifoRdData               : in  IFifoReadData_t;
      vIFifoRdIsError            : in  std_logic;
      vIFifoRdDataValid          : in  std_logic;
      vIFifoRdReadyForInput      : out std_logic);
  end component;

  --vhook_sigstart
  signal bFlatAxiStreamDataFromCtrl: FlatAxiStreamData_t;
  signal bFlatAxiStreamDataToCtrl: FlatAxiStreamData_t;
  signal dFlatBaRegPortIn: FlatBaRegPortIn_t;
  signal dFlatBaRegPortOutIFifo: FlatBaRegPortOut_t;
  signal dIFifoArbiterDone: std_logic;
  signal dIFifoArbiterGrant: std_logic;
  signal dIFifoArbiterReq: std_logic;
  signal xFlatAxiStreamDataFromClip: FlatAxiStreamData_t;
  signal xFlatAxiStreamDataToClip: FlatAxiStreamData_t;
  --vhook_sigend

  signal dFlatHighSpeedSink : FlatNiDmaHighSpeedSinkFromDma_t;

  signal dFlatIFifoDataFromDma    : FlatNiDmaInputDataFromDma_t;
  signal dFlatIFifoDataToDma      : FlatNiDmaInputDataToDma_t;
  signal dFlatIFifoRequestFromDma : FlatNiDmaInputRequestFromDma_t;
  signal dFlatIFifoRequestToDma   : FlatNiDmaInputRequestToDma_t;
  signal dFlatIFifoStatusFromDma  : FlatNiDmaInputStatusFromDma_t;

begin  -- architecture struct

  ---------------------------------------------------------------------------------------
  -- DMA Type Conversions
  ---------------------------------------------------------------------------------------
  -- High Speed Sink
  dFlatHighSpeedSink       <= Flatten(dHighSpeedSinkFromDma);
  -- DmaPort from Dma
  dFlatIFifoRequestFromDma <= Flatten(dIFifoRequestFromDma);
  dFlatIFifoDataFromDma    <= Flatten(dIFifoDataFromDma);
  dFlatIFifoStatusFromDma  <= Flatten(dIFifoStatusFromDma);
  -- DmaPort to Dma
  dIFifoRequestToDma       <= UnFlatten(dFlatIFifoRequestToDma);
  dIFifoDataToDma          <= UnFlatten(dFlatIFifoDataToDma);
  -- RegPort
  dFlatBaRegPortIn         <= Flatten(dBaRegPortIn);
  dBaRegPortOutIFifo       <= UnFlatten(dFlatBaRegPortOutIFifo);
  -- Arbiter
  dIFifoArbiterGrant       <= dIFifoArbGrant.Grant;
  dIFifoArbReq <= (NormalReq    => dIFifoArbiterReq,
                   EmergencyReq => '0',
                   DoneStrb     => dIFifoArbiterDone);

  ---------------------------------------------------------------------------------------
  -- AxiStream Conversions
  ---------------------------------------------------------------------------------------
  -- Ready doesn't need conversion because it's just booleans.

  -- Write Board Ctrl
  bAxiStreamDataToCtrl       <= UnFlatten(bFlatAxiStreamDataToCtrl);
  -- Read Board Ctrl
  bFlatAxiStreamDataFromCtrl <= Flatten(bAxiStreamDataFromCtrl);

  -- Write CLIP
  xAxiStreamDataToClip       <= UnFlatten(xFlatAxiStreamDataToClip);
  -- Read CLIP
  xFlatAxiStreamDataFromClip <= Flatten(xAxiStreamDataFromClip);


  ---------------------------------------------------------------------------------------
  -- Netlist
  ---------------------------------------------------------------------------------------

  --vhook   MacallanIFifoN      IFifoNetlistx
  IFifoNetlistx: MacallanIFifoN
    port map (
      aBusReset                  => aBusReset,                   --in  boolean
      DmaClk                     => DmaClk,                      --in  std_logic
      dFlatHighSpeedSink         => dFlatHighSpeedSink,          --in  FlatNiDmaHighSpeedSinkFromDma_t
      dFlatBaRegPortIn           => dFlatBaRegPortIn,            --in  FlatBaRegPortIn_t
      dFlatBaRegPortOutIFifo     => dFlatBaRegPortOutIFifo,      --out FlatBaRegPortOut_t
      dFlatIFifoRequestFromDma   => dFlatIFifoRequestFromDma,    --in  FlatNiDmaInputRequestFromDma_t
      dFlatIFifoRequestToDma     => dFlatIFifoRequestToDma,      --out FlatNiDmaInputRequestToDma_t
      dFlatIFifoDataFromDma      => dFlatIFifoDataFromDma,       --in  FlatNiDmaInputDataFromDma_t
      dFlatIFifoDataToDma        => dFlatIFifoDataToDma,         --out FlatNiDmaInputDataToDma_t
      dFlatIFifoStatusFromDma    => dFlatIFifoStatusFromDma,     --in  FlatNiDmaInputStatusFromDma_t
      dIFifoArbiterDone          => dIFifoArbiterDone,           --out std_logic
      dIFifoArbiterGrant         => dIFifoArbiterGrant,          --in  std_logic
      dIFifoArbiterReq           => dIFifoArbiterReq,            --out std_logic
      BusClk                     => BusClk,                      --in  std_logic
      aPonReset                  => aPonReset,                   --in  boolean
      bFlatAxiStreamDataToCtrl   => bFlatAxiStreamDataToCtrl,    --out FlatAxiStreamData_t
      bAxiStreamReadyFromCtrl    => bAxiStreamReadyFromCtrl,     --in  boolean
      bFlatAxiStreamDataFromCtrl => bFlatAxiStreamDataFromCtrl,  --in  FlatAxiStreamData_t
      bAxiStreamReadyToCtrl      => bAxiStreamReadyToCtrl,       --out boolean
      aDiagramReset              => aDiagramReset,               --in  boolean
      AxiClk                     => AxiClk,                      --in  std_logic
      xFlatAxiStreamDataToClip   => xFlatAxiStreamDataToClip,    --out FlatAxiStreamData_t
      xAxiStreamReadyFromClip    => xAxiStreamReadyFromClip,     --in  boolean
      xFlatAxiStreamDataFromClip => xFlatAxiStreamDataFromClip,  --in  FlatAxiStreamData_t
      xAxiStreamReadyToClip      => xAxiStreamReadyToClip,       --out boolean
      ViClk                      => ViClk,                       --in  std_logic
      vIFifoWrData               => vIFifoWrData,                --out IFifoWriteData_t
      vIFifoWrDataValid          => vIFifoWrDataValid,           --out std_logic
      vIFifoWrReadyForOutput     => vIFifoWrReadyForOutput,      --in  std_logic
      vIFifoRdData               => vIFifoRdData,                --in  IFifoReadData_t
      vIFifoRdIsError            => vIFifoRdIsError,             --in  std_logic
      vIFifoRdDataValid          => vIFifoRdDataValid,           --in  std_logic
      vIFifoRdReadyForInput      => vIFifoRdReadyForInput);      --out std_logic

end architecture wrap;
