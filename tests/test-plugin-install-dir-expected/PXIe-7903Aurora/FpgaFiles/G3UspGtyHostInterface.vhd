------------------------------------------------------------------------------------------
--
-- File: G3UspGtyHostInterface.vhd
-- Author: Rolando Ortega
-- Original Project: Macallan
-- Date: 25 November 2015
--
------------------------------------------------------------------------------------------
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
------------------------------------------------------------------------------------------
--
-- Purpose: This module instantiates the main blocks for a gen 3x8 PCIe interface for an
-- Ultrascale+ target. This includes the InChWORM, the Inchworm Companion, and the DmaPort
-- Fixed Comm Interface, which mostly communicates with the InChWORM. This does not
-- include the ports for an IsoPort interface.
------------------------------------------------------------------------------------------
--
-- githubvisible=true
--
-- vreview_group HostInterface
-- vreview_closed http://review-board.natinst.com/r/313053/
-- vreview_closed http://review-board.natinst.com/r/217978/
-- vreview_reviewers kygreen dhearn esalinas hrubio lboughal rcastro
--
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgNiUtilities.all;

-- LVFPGA
use work.PkgDmaPortCommunicationInterface.all;
use work.PkgCommIntConfiguration.all;
use work.PkgDmaPortDmaFifos.all;
use work.PkgDmaPortCommIfcMasterPort.all;
use work.PkgDmaPortCommIfcArbiter.all;

-- InChWORM Imports
use work.PkgBaRegPort.all;
use work.PkgCommunicationInterface.all;
use work.PkgNiDma.all;
use work.PkgDmaPortRecordFlattening.all;
use work.PkgSwitchedChinch.all;

-- Others
use work.PkgInstructionFifo.all;
use work.PkgInstructionFifoConfig.all;

-- Axi Stream
use work.PkgFlexRioAxiStream.all;

-- Driver-generated Constants (including PCI Config)
use work.PkgLvFpgaConst.all;

entity G3UspGtyHostInterface is
  generic (
    -- If HMB is in use for this target, hook up DMA
    kHmbInUse : boolean := false
  );
  port (
    -------------------------------------------------------------------------------------
    -- PCIe and PXI
    -------------------------------------------------------------------------------------
    -- RefClk and Reset
    PcieRefClk_p                             : in  std_logic;
    PcieRefClk_n                             : in  std_logic;
    -- PCIe Lanes
    PcieRx_p                                 : in  std_logic_vector(7 downto 0);
    PcieRx_n                                 : in  std_logic_vector(7 downto 0);
    PcieTx_p                                 : out std_logic_vector(7 downto 0);
    PcieTx_n                                 : out std_logic_vector(7 downto 0);
    -- Geographical Addressing
    aGa                                      : in  std_logic_vector(4 downto 0);
    -------------------------------------------------------------------------------------
    -- General Internal Signals
    -------------------------------------------------------------------------------------
    -- Clocks
    DmaClockSource                           : out std_logic;
    DmaClk                                   : in  std_logic;
    BusClk                                   : in  std_logic;
    -- Logic Reset
    aPonReset                                : in boolean;
    aBusReset                                : in boolean;
    -- Inchworm Resets
    aResetToInchworm_n                       : in  std_logic;
    aResetFromInchworm                       : out boolean;
    -------------------------------------------------------------------------------------
    -- Authentication
    -------------------------------------------------------------------------------------
    Clk40MHz                                 : in  std_logic;
    aAuthSdaIn                               : in  std_logic;
    aAuthSdaOut                              : out std_logic;
    -------------------------------------------------------------------------------------
    -- Host Memory Buffer
    -------------------------------------------------------------------------------------
    -- Inputs Signals
    dNiHmbInputRequestToDma                 : in NiDmaInputRequestToDma_t := kNiDmaInputRequestToDmaZero;
    dNiHmbInputRequestFromDma               : out NiDmaInputRequestFromDma_t;
    dNiHmbInputDataToDma                    : in NiDmaInputDataToDma_t := kNiDmaInputDataToDmaZero;
    dNiHmbInputDataFromDma                  : out NiDmaInputDataFromDma_t;
    --vhook_nowarn dNiFpgaInputStatusFromDma
    dNiHmbInputStatusFromDma                : out NiDmaInputStatusFromDma_t;

    -- Outputs Signals
    dNiHmbOutputRequestToDma                : in NiDmaOutputRequestToDma_t := kNiDmaOutputRequestToDmaZero;
    dNiHmbOutputRequestFromDma              : out NiDmaOutputRequestFromDma_t;
    dNiHmbOutputDataFromDma                 : out NiDmaOutputDataFromDma_t;

    -- Arbiter Signals
    dNiHmbInputArbReq                       : in NiDmaArbReq_t := kNiDmaArbReqZero;
    dNiHmbInputArbGrant                     : out NiDmaArbGrant_t;
    dNiHmbOutputArbReq                      : in NiDmaArbReq_t := kNiDmaArbReqZero;
    dNiHmbOutputArbGrant                    : out NiDmaArbGrant_t;
    -------------------------------------------------------------------------------------
    -- The Window - Standard
    -------------------------------------------------------------------------------------
    -- Reset
    aDiagramReset                            : in  std_logic;
    -- Register Port
    bLvWindowRegPortIn                       : out RegPortIn_t;
    bLvWindowRegPortOut                      : in  RegPortOut_t;
    bLvWindowRegPortTimeOut                  : out boolean;
    -- Interrupt
    bIrqToInterface                          : in  IrqToInterfaceArray_t;
    -- DmaFifo Interfaces
    dInputStreamInterfaceFromFifo            : in  InputStreamInterfaceFromFifoArray_t;
    dInputStreamInterfaceToFifo              : out InputStreamInterfaceToFifoArray_t;
    dOutputStreamInterfaceFromFifo           : in  OutputStreamInterfaceFromFifoArray_t;
    dOutputStreamInterfaceToFifo             : out OutputStreamInterfaceToFifoArray_t;
    -- Master Port Interfaces
    dNiFpgaMasterWriteRequestFromMasterArray : in  NiFpgaMasterWriteRequestFromMasterArray_t;
    dNiFpgaMasterWriteRequestToMasterArray   : out NiFpgaMasterWriteRequestToMasterArray_t;
    dNiFpgaMasterWriteDataFromMasterArray    : in  NiFpgaMasterWriteDataFromMasterArray_t;
    dNiFpgaMasterWriteDataToMasterArray      : out NiFpgaMasterWriteDataToMasterArray_t;
    dNiFpgaMasterWriteStatusToMasterArray    : out NiFpgaMasterWriteStatusToMasterArray_t;
    dNiFpgaMasterReadRequestFromMasterArray  : in  NiFpgaMasterReadRequestFromMasterArray_t;
    dNiFpgaMasterReadRequestToMasterArray    : out NiFpgaMasterReadRequestToMasterArray_t;
    dNiFpgaMasterReadDataToMasterArray       : out NiFpgaMasterreadDataToMasterArray_t;
    -------------------------------------------------------------------------------------
    -- The Window - Instruction Fifo
    -------------------------------------------------------------------------------------
    -- AXI4-Stream CLIP
    AxiClk                                   : in  std_logic;
    xAxiStreamFromClipTData                  : in  AxiStreamTData_t;
    xAxiStreamFromClipTLast                  : in  std_logic;
    xAxiStreamToClipTReady                   : out std_logic;
    xAxiStreamFromClipTValid                 : in  std_logic;
    xAxiStreamToClipTData                    : out AxiStreamTData_t;
    xAxiStreamToClipTLast                    : out std_logic;
    xAxiStreamToClipTValid                   : out std_logic;
    xAxiStreamFromClipTReady                 : in  std_logic;
    -- LvFpga IFifo
    ViClk                                    : in  std_logic;
    vIFifoWrData                             : out IFifoWriteData_t;
    vIFifoWrDataValid                        : out std_logic;
    vIFifoWrReadyForOutput                   : in  std_logic;
    vIFifoRdData                             : in  IFifoReadData_t;
    vIFifoRdIsError                          : in  std_logic;
    vIFifoRdDataValid                        : in  std_logic;
    vIFifoRdReadyForInput                    : out std_logic;
    -- Register Port
    dFixedLogicBaRegPortIn                   : out BaRegPortIn_t;
    dFixedLogicBaRegPortOut                  : in  BaRegPortOut_t;
    -------------------------------------------------------------------------------------
    -- The Window - Device RAM Socket
    -------------------------------------------------------------------------------------
    dFlatHighSpeedSinkFromDma                : out FlatNiDmaHighSpeedSinkFromDma_t;
    -------------------------------------------------------------------------------------
    -- Fixed Logic
    -------------------------------------------------------------------------------------
    -- Instruction Fifo
    -- AXI4-Stream Board Control
    bAxiStreamDataToCtrl                     : out AxiStreamData_t;
    bAxiStreamReadyFromCtrl                  : in  boolean;
    bAxiStreamDataFromCtrl                   : in  AxiStreamData_t;
    bAxiStreamReadyToCtrl                    : out boolean;
    -- Interrupts
    dIrqFromFixedLogic                       : in  std_logic;
    -------------------------------------------------------------------------------------
    -- Tandem
    -------------------------------------------------------------------------------------
    aStage2Enabled                           : out boolean;
    -------------------------------------------------------------------------------------
    -- DRP
    -------------------------------------------------------------------------------------
    GtDrpClk                                 : out std_logic;
    gGtDrpAddr                               : in  std_logic_vector(79 downto 0);
    gGtDrpEn                                 : in  std_logic_vector(7 downto 0);
    gGtDrpDi                                 : in  std_logic_vector(127 downto 0);
    gGtDrpWe                                 : in  std_logic_vector(7 downto 0);
    gGtDrpDo                                 : out std_logic_vector(127 downto 0);
    gGtDrpRdy                                : out std_logic_vector(7 downto 0);
    aIbertEyescanResetIn                     : in  std_logic_vector(7 downto 0)
  );
end entity G3UspGtyHostInterface;

architecture struct of G3UspGtyHostInterface is

  -- Fixed Logic Interrupt (in case we need it)
  signal dFixedLogicDmaIrq : IrqStatusArray_t(0 downto 0);

  --vhook_sigstart
  signal dAppHwInterrupt: std_logic_vector(1 downto 0);
  signal dBaRegPortIn: BaRegPortIn_t;
  signal dBaRegPortOut: BaRegPortOut_t;
  signal dBaRegPortOutIFifo: BaRegPortOut_t;
  signal dCfgLtssmState: std_logic_vector(5 downto 0);
  signal dFixedLogicBaRegPortInLcl: BaRegPortIn_t;
  signal dFixedLogicBaRegPortOutLcl: BaRegPortOut_t;
  signal dHighSpeedSinkFromDma: NiDmaHighSpeedSinkFromDma_t;
  signal dIFifoArbGrant: NiDmaArbGrant_t;
  signal dIFifoArbReq: NiDmaArbReq_t;
  signal dIFifoDataFromDma: NiDmaInputDataFromDma_t;
  signal dIFifoDataToDma: NiDmaInputDataToDma_t;
  signal dIFifoRequestFromDma: NiDmaInputRequestFromDma_t;
  signal dIFifoRequestToDma: NiDmaInputRequestToDma_t;
  signal dIFifoStatusFromDma: NiDmaInputStatusFromDma_t;
  signal dInputDataFromDma: NiDmaInputDataFromDma_t;
  signal dInputDataToDma: NiDmaInputDataToDma_t;
  signal dInputRequestFromDma: NiDmaInputRequestFromDma_t;
  signal dInputRequestToDma: NiDmaInputRequestToDma_t;
  signal dInputStatusFromDma: NiDmaInputStatusFromDma_t;
  signal dIrqToInchworm: std_logic_vector(kNumberOfIrqs-1 downto 0);
  signal dLvUserMappable: std_logic;
  signal dNiFpgaInputArbGrant: NiDmaArbGrantArray_t(kNiFpgaFixedInputPorts-1 downto 0);
  signal dNiFpgaInputArbReq: NiDmaArbReqArray_t(kNiFpgaFixedInputPorts-1 downto 0);
  signal dNiFpgaInputDataFromDmaArray: NiDmaInputDataFromDmaArray_t(kNiFpgaFixedInputPorts-1 downto 0);
  signal dNiFpgaInputDataToDmaArray: NiDmaInputDataToDmaArray_t(kNiFpgaFixedInputPorts-1 downto 0);
  signal dNiFpgaInputRequestFromDmaArray: NiDmaInputRequestFromDmaArray_t(kNiFpgaFixedInputPorts-1 downto 0);
  signal dNiFpgaInputRequestToDmaArray: NiDmaInputRequestToDmaArray_t(kNiFpgaFixedInputPorts-1 downto 0);
  signal dNiFpgaInputStatusFromDmaArray: NiDmaInputStatusFromDmaArray_t(kNiFpgaFixedInputPorts-1 downto 0);
  signal dNiFpgaOutputArbGrant: NiDmaArbGrantArray_t(kNiFpgaFixedOutputPorts-1 downto 0);
  signal dNiFpgaOutputArbReq: NiDmaArbReqArray_t(kNiFpgaFixedOutputPorts-1 downto 0);
  signal dNiFpgaOutputDataFromDmaArray: NiDmaOutputDataFromDmaArray_t(kNiFpgaFixedOutputPorts-1 downto 0);
  signal dNiFpgaOutputRequestFromDmaArray: NiDmaOutputRequestFromDmaArray_t(kNiFpgaFixedOutputPorts-1 downto 0);
  signal dNiFpgaOutputRequestToDmaArray: NiDmaOutputRequestToDmaArray_t(kNiFpgaFixedOutputPorts-1 downto 0);
  signal dOutputDataFromDma: NiDmaOutputDataFromDma_t;
  signal dOutputRequestFromDma: NiDmaOutputRequestFromDma_t;
  signal dOutputRequestToDma: NiDmaOutputRequestToDma_t;
  signal dRegPortIn: RegPortIn_t;
  signal dRegPortOut: RegPortOut_t;
  signal dUserAppRdy: std_logic;
  signal dUserLnkUp: std_logic;
  signal xAxiStreamDataToClip: AxiStreamData_t;
  signal xAxiStreamReadyToClip: boolean;
  --vhook_sigend

  ---------------------------------------------------------------------------------------
  -- PCIe Configuration
  ---------------------------------------------------------------------------------------
  -- NI PCIe IP uses RevId to communicate to the filter driver whether we support DPR or
  -- not. A value of 0 means no DPR, 1 means we support DPR.
  constant kCfgRevId        : std_logic_vector(7 downto 0)  := X"01";
  -- NI Vendor ID
  constant kCfgSubsysVendId : std_logic_vector(15 downto 0) := X"1093";

  ---------------------------------------------------------------------------------------
  -- DMA Comms Configuration
  ---------------------------------------------------------------------------------------
  -- The corresponding resource.xml will request two read interface and three write
  -- interfaces of the DmaPort arbiter for fixed logic. One of each is requested for
  -- InChWORM status pushing (using index 0 for both), Host Memory Buffer will be
  -- next (using index 1 for both), and the write interface of index 2 is
  -- requested for the IFifo. The InChWORM status pushing requests don't go through the
  -- LabVEIW arbiter so the corresponding interfaces requested go unused in this file. A
  -- future change to the corresponding resource.xml files could prevent the need to deal
  -- with those unused interfaces here, but such change has not been tested.
  constant kSpDmaIndex    : natural := 0;
  constant kHMBIndex      : natural := 1;
  constant kIFifoDmaIndex : natural := 2;

begin  -- architecture struct

  --VSMake doesn't like prefix-less signals.
  --vhook_nodgv {^Pcie[RT]x_[pn]}

  ---------------------------------------------------------------------------------------
  -- PCIe InChWORM
  ---------------------------------------------------------------------------------------
  --vhook_e PcieUspG3x8TandemGtyInchwormWrapper Inchwormx
  --vhook_h kForceChannelEnable                 open
  --vhook_a aPcieRst_n                          aResetToInchworm_n
  --vhook_a PcieRefClkOut                       open
  --vhook_a aBusReset                           aResetFromInchworm
  --vhook_a DmaClock                            DmaClk
  --vhook_# We don't use the LIB
  --vhook_h dHostR*                             open   mode=out
  --vhook_a dHostResponseData                   (others => '0')
  --vhook_a dHostResponse*                      false
  --vhook_a dHostRequestRx                      kSwitchedLinkRxZero
  --vhook_# POSC + ConfigPort
  --vhook_a aCpResetOut_n                       open
  --vhook_a aCpResetIn_n                        '1'
  --vhook_a aCpSCEN_n                           '1'
  --vhook_a aPoscRestoreAsyncMode               '0'
  --vhook_h dPoscDone
  --vhook_a dPosc*                              false
  --vhook_# We don't use the PCIe DRP
  --vhook_a {^p?PcieDrp(Clk|En|We)}             '0'
  --vhook_a pPcieDrp*                           (others => '0')         mode=in
  --vhook_a pPcieDrp*                           open                    mode=out
  Inchwormx: entity work.PcieUspG3x8TandemGtyInchwormWrapper (RTL)
    generic map (
      kCfgRevId        => kCfgRevId,         --std_logic_vector(7:0):=X"01"
      kCfgSubsysVendId => kCfgSubsysVendId,  --std_logic_vector(15:0):=X"1093"
      kCfgSubsysId     => kCfgSubsysId)      --std_logic_vector(15:0):=X"C4C4"
    port map (
      aPcieRst_n            => aResetToInchworm_n,     --in  std_logic
      PcieRefClk_p          => PcieRefClk_p,           --in  std_logic
      PcieRefClk_n          => PcieRefClk_n,           --in  std_logic
      PcieRefClkOut         => open,                   --out std_logic
      PcieRx_p              => PcieRx_p,               --in  std_logic_vector(7:0)
      PcieRx_n              => PcieRx_n,               --in  std_logic_vector(7:0)
      PcieTx_p              => PcieTx_p,               --out std_logic_vector(7:0)
      PcieTx_n              => PcieTx_n,               --out std_logic_vector(7:0)
      DmaClockSource        => DmaClockSource,         --out std_logic
      DmaClock              => DmaClk,                 --in  std_logic
      aBusReset             => aResetFromInchworm,     --out boolean
      dAppHwInterrupt       => dAppHwInterrupt,        --in  std_logic_vector(1:0)
      dBaRegPortIn          => dBaRegPortIn,           --out BaRegPortIn_t
      dBaRegPortOut         => dBaRegPortOut,          --in  BaRegPortOut_t
      dLvUserMappable       => dLvUserMappable,        --in  std_logic
      dHighSpeedSinkFromDma => dHighSpeedSinkFromDma,  --out NiDmaHighSpeedSinkFromDma_t
      dHostRequestRx        => kSwitchedLinkRxZero,    --in  SwitchedLinkRx_t
      dHostResponseAck      => false,                  --in  boolean
      dHostResponseErr      => false,                  --in  boolean
      dHostResponseData     => (others => '0'),        --in  std_logic_vector(63:0)
      dInputRequestToDma    => dInputRequestToDma,     --in  NiDmaInputRequestToDma_t
      dInputRequestFromDma  => dInputRequestFromDma,   --out NiDmaInputRequestFromDma_t
      dInputDataToDma       => dInputDataToDma,        --in  NiDmaInputDataToDma_t
      dInputDataFromDma     => dInputDataFromDma,      --out NiDmaInputDataFromDma_t
      dInputStatusFromDma   => dInputStatusFromDma,    --out NiDmaInputStatusFromDma_t
      dOutputRequestToDma   => dOutputRequestToDma,    --in  NiDmaOutputRequestToDma_t
      dOutputRequestFromDma => dOutputRequestFromDma,  --out NiDmaOutputRequestFromDma_t
      dOutputDataFromDma    => dOutputDataFromDma,     --out NiDmaOutputDataFromDma_t
      dPoscPause            => false,                  --in  boolean
      dPoscError            => false,                  --in  boolean
      aCpResetOut_n         => open,                   --out std_logic
      aCpResetIn_n          => '1',                    --in  std_logic
      aCpSCEN_n             => '1',                    --in  std_logic
      aPoscRestoreAsyncMode => '0',                    --in  std_logic
      Clk40Mhz              => Clk40Mhz,               --in  std_logic
      aAuthSdaIn            => aAuthSdaIn,             --in  std_logic
      aAuthSdaOut           => aAuthSdaOut,            --out std_logic
      dCfgLtssmState        => dCfgLtssmState,         --out std_logic_vector(5:0)
      dUserLnkUp            => dUserLnkUp,             --out std_logic
      dUserAppRdy           => dUserAppRdy,            --out std_logic
      PcieDrpClk            => '0',                    --in  std_logic
      pPcieDrpAddr          => (others => '0'),        --in  std_logic_vector(9:0)
      pPcieDrpDi            => (others => '0'),        --in  std_logic_vector(15:0)
      pPcieDrpDo            => open,                   --out std_logic_vector(15:0)
      pPcieDrpEn            => '0',                    --in  std_logic
      pPcieDrpRdy           => open,                   --out std_logic
      pPcieDrpWe            => '0',                    --in  std_logic
      GtDrpClk              => GtDrpClk,               --out std_logic
      gGtDrpAddr            => gGtDrpAddr,             --in  std_logic_vector(79:0)
      gGtDrpEn              => gGtDrpEn,               --in  std_logic_vector(7:0)
      gGtDrpDi              => gGtDrpDi,               --in  std_logic_vector(127:0)
      gGtDrpWe              => gGtDrpWe,               --in  std_logic_vector(7:0)
      gGtDrpDo              => gGtDrpDo,               --out std_logic_vector(127:0)
      gGtDrpRdy             => gGtDrpRdy,              --out std_logic_vector(7:0)
      aIbertEyescanResetIn  => aIbertEyescanResetIn);  --in  std_logic_vector(7:0)

  -- We don't currently use the PCIe status signals that are surfaced by the wrapper. We
  -- might want to read them with ChipScope, though, so we keep them around.
  --vhook_nowarn dCfgLtssmState  dUserLnkUp
  aStage2Enabled <= to_Boolean(dUserAppRdy);

  ---------------------------------------------------------------------------------------
  -- Inchworm Companion (including IsoPort)
  ---------------------------------------------------------------------------------------

  --vhook_e IwCompanion                         IwCompanionx
  --vhook_# RegPorts
  --vhook_a {dFixedLogicBaRegPort(Out|In)}      $0Lcl
  --vhook_a {dDmaCommIfc(RegPort(Out|In))}      d$1
  --vhook_# DmaClk
  --vhook_a DmaClock                            DmaClk
  IwCompanionx: entity work.IwCompanion (wrapper)
    port map (
      aBusReset               => aBusReset,                   --in  boolean
      DmaClock                => DmaClk,                      --in  std_logic
      dBaRegPortIn            => dBaRegPortIn,                --in  BaRegPortIn_t
      dBaRegPortOut           => dBaRegPortOut,               --out BaRegPortOut_t
      dLvUserMappable         => dLvUserMappable,             --out std_logic
      BusClk                  => BusClk,                      --in  std_logic
      bLvWindowRegPortIn      => bLvWindowRegPortIn,          --out RegPortIn_t
      bLvWindowRegPortOut     => bLvWindowRegPortOut,         --in  RegPortOut_t
      bLvWindowRegPortTimeOut => bLvWindowRegPortTimeOut,     --out boolean
      dDmaCommIfcRegPortIn    => dRegPortIn,                  --out RegPortIn_t
      dDmaCommIfcRegPortOut   => dRegPortOut,                 --in  RegPortOut_t
      dFixedLogicBaRegPortIn  => dFixedLogicBaRegPortInLcl,   --out BaRegPortIn_t
      dFixedLogicBaRegPortOut => dFixedLogicBaRegPortOutLcl,  --in  BaRegPortOut_t
      aGa                     => aGa);                        --in  std_logic_vector(4:0)

  ---------------------------------------------------------------------------------------
  -- DMA Port Instantiation
  ---------------------------------------------------------------------------------------

  --vhook_e DmaPortFixedDmaCommunicationInterface
  --vhook_a aReset                              aBusReset
  --vhook_a dReset                              false
  --vhook_a dIrq                                dIrqToInchworm
  --vhook_a IrqClk                              BusClk
  --vhook_a iLvFpgaIrq                          bIrqToInterface
  --vhook_a {dNiDma(.*)}                        d$1
  DmaPortFixedDmaCommunicationInterfacex: entity work.DmaPortFixedDmaCommunicationInterface (struct)
    port map (
      aReset                                   => aBusReset,                                 --in  boolean
      dReset                                   => false,                                     --in  boolean
      DmaClk                                   => DmaClk,                                    --in  std_logic
      IrqClk                                   => BusClk,                                    --in  std_logic
      dNiDmaInputRequestToDma                  => dInputRequestToDma,                        --out NiDmaInputRequestToDma_t
      dNiDmaInputRequestFromDma                => dInputRequestFromDma,                      --in  NiDmaInputRequestFromDma_t
      dNiDmaInputDataToDma                     => dInputDataToDma,                           --out NiDmaInputDataToDma_t
      dNiDmaInputDataFromDma                   => dInputDataFromDma,                         --in  NiDmaInputDataFromDma_t
      dNiDmaInputStatusFromDma                 => dInputStatusFromDma,                       --in  NiDmaInputStatusFromDma_t
      dNiDmaOutputRequestToDma                 => dOutputRequestToDma,                       --out NiDmaOutputRequestToDma_t
      dNiDmaOutputRequestFromDma               => dOutputRequestFromDma,                     --in  NiDmaOutputRequestFromDma_t
      dNiDmaOutputDataFromDma                  => dOutputDataFromDma,                        --in  NiDmaOutputDataFromDma_t
      dNiDmaHighSpeedSinkFromDma               => dHighSpeedSinkFromDma,                     --in  NiDmaHighSpeedSinkFromDma_t
      dInputStreamInterfaceFromFifo            => dInputStreamInterfaceFromFifo,             --in  InputStreamInterfaceFromFifoArray_t(Larger(kNumberOfDmaChannels,1)-1:0)
      dInputStreamInterfaceToFifo              => dInputStreamInterfaceToFifo,               --out InputStreamInterfaceToFifoArray_t(Larger(kNumberOfDmaChannels,1)-1:0)
      dOutputStreamInterfaceFromFifo           => dOutputStreamInterfaceFromFifo,            --in  OutputStreamInterfaceFromFifoArray_t(Larger(kNumberOfDmaChannels,1)-1:0)
      dOutputStreamInterfaceToFifo             => dOutputStreamInterfaceToFifo,              --out OutputStreamInterfaceToFifoArray_t(Larger(kNumberOfDmaChannels,1)-1:0)
      dNiFpgaMasterWriteRequestFromMasterArray => dNiFpgaMasterWriteRequestFromMasterArray,  --in  NiFpgaMasterWriteRequestFromMasterArray_t(Larger(kNumberOfMasterPorts,1)-1:0)
      dNiFpgaMasterWriteRequestToMasterArray   => dNiFpgaMasterWriteRequestToMasterArray,    --out NiFpgaMasterWriteRequestToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1:0)
      dNiFpgaMasterWriteDataFromMasterArray    => dNiFpgaMasterWriteDataFromMasterArray,     --in  NiFpgaMasterWriteDataFromMasterArray_t(Larger(kNumberOfMasterPorts,1)-1:0)
      dNiFpgaMasterWriteDataToMasterArray      => dNiFpgaMasterWriteDataToMasterArray,       --out NiFpgaMasterWriteDataToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1:0)
      dNiFpgaMasterWriteStatusToMasterArray    => dNiFpgaMasterWriteStatusToMasterArray,     --out NiFpgaMasterWriteStatusToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1:0)
      dNiFpgaMasterReadRequestFromMasterArray  => dNiFpgaMasterReadRequestFromMasterArray,   --in  NiFpgaMasterReadRequestFromMasterArray_t(Larger(kNumberOfMasterPorts,1)-1:0)
      dNiFpgaMasterReadRequestToMasterArray    => dNiFpgaMasterReadRequestToMasterArray,     --out NiFpgaMasterReadRequestToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1:0)
      dNiFpgaMasterReadDataToMasterArray       => dNiFpgaMasterReadDataToMasterArray,        --out NiFpgaMasterreadDataToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1:0)
      dNiFpgaInputRequestToDmaArray            => dNiFpgaInputRequestToDmaArray,             --in  NiDmaInputRequestToDmaArray_t(kNiFpgaFixedInputPorts-1:0)
      dNiFpgaInputRequestFromDmaArray          => dNiFpgaInputRequestFromDmaArray,           --out NiDmaInputRequestFromDmaArray_t(kNiFpgaFixedInputPorts-1:0)
      dNiFpgaInputDataToDmaArray               => dNiFpgaInputDataToDmaArray,                --in  NiDmaInputDataToDmaArray_t(kNiFpgaFixedInputPorts-1:0)
      dNiFpgaInputDataFromDmaArray             => dNiFpgaInputDataFromDmaArray,              --out NiDmaInputDataFromDmaArray_t(kNiFpgaFixedInputPorts-1:0)
      dNiFpgaInputStatusFromDmaArray           => dNiFpgaInputStatusFromDmaArray,            --out NiDmaInputStatusFromDmaArray_t(kNiFpgaFixedInputPorts-1:0)
      dNiFpgaOutputRequestToDmaArray           => dNiFpgaOutputRequestToDmaArray,            --in  NiDmaOutputRequestToDmaArray_t(kNiFpgaFixedOutputPorts-1:0)
      dNiFpgaOutputRequestFromDmaArray         => dNiFpgaOutputRequestFromDmaArray,          --out NiDmaOutputRequestFromDmaArray_t(kNiFpgaFixedOutputPorts-1:0)
      dNiFpgaOutputDataFromDmaArray            => dNiFpgaOutputDataFromDmaArray,             --out NiDmaOutputDataFromDmaArray_t(kNiFpgaFixedOutputPorts-1:0)
      dNiFpgaInputArbReq                       => dNiFpgaInputArbReq,                        --in  NiDmaArbReqArray_t(kNiFpgaFixedInputPorts-1:0)
      dNiFpgaInputArbGrant                     => dNiFpgaInputArbGrant,                      --out NiDmaArbGrantArray_t(kNiFpgaFixedInputPorts-1:0)
      dNiFpgaOutputArbReq                      => dNiFpgaOutputArbReq,                       --in  NiDmaArbReqArray_t(kNiFpgaFixedOutputPorts-1:0)
      dNiFpgaOutputArbGrant                    => dNiFpgaOutputArbGrant,                     --out NiDmaArbGrantArray_t(kNiFpgaFixedOutputPorts-1:0)
      iLvFpgaIrq                               => bIrqToInterface,                           --in  IrqToInterfaceArray_t(Larger(kNumberOfIrqs,1)-1:0)
      dFixedLogicDmaIrq                        => dFixedLogicDmaIrq,                         --in  IrqStatusArray_t
      dIrq                                     => dIrqToInchworm,                            --out std_logic_vector(kNumberOfIrqs-1:0)
      dRegPortIn                               => dRegPortIn,                                --in  RegPortIn_t
      dRegPortOut                              => dRegPortOut);                              --out RegPortOut_t

  ---------------------------------------------------------------------------------------
  -- BA RegPort
  ---------------------------------------------------------------------------------------
  -- Intermediate BaRegPort
  dFixedLogicBaRegPortOutLcl <= dFixedLogicBaRegPortOut or dBaRegPortOutIFifo;
  dFixedLogicBaRegPortIn     <= dFixedLogicBaRegPortInLcl;

  ---------------------------------------------------------------------------------------
  -- Status Pushing DmaComms Breakout - unused
  ---------------------------------------------------------------------------------------

  -- Input
  dNiFpgaInputRequestToDmaArray(kSpDmaIndex)  <= kNiDmaInputRequestToDmaZero;
  dNiFpgaInputDataToDmaArray(kSpDmaIndex)     <= kNiDmaInputDataToDmaZero;
  -- Output
  dNiFpgaOutputRequestToDmaArray(kSpDmaIndex) <= kNiDmaOutputRequestToDmaZero;
  -- Grants
  -- Requests
  dNiFpgaInputArbReq(kSpDmaIndex) <= kNiDmaArbReqZero;
  dNiFpgaOutputArbReq(kSpDmaIndex) <= kNiDmaArbReqZero;

  ---------------------------------------------------------------------------------------
  -- InstructionFifo
  ---------------------------------------------------------------------------------------
  --vhook_e MacallanIFifo                       IFifox
  --vhook_a aDiagramReset                       to_Boolean(aDiagramReset)
  --vhook_# RegPort
  --vhook_a dBaRegPortIn                        dFixedLogicBaRegPortInLcl
  --vhook_# AxiStream
  --vhook_a xAxiStreamReadyFromClip             to_Boolean(xAxiStreamFromClipTReady)
  --vhook_af {xAxiStreamDataFromClip}.TData     {xAxiStreamFromClipTData}               continue=true
  --vhook_af {xAxiStreamDataFromClip}.TLast     {to_Boolean(xAxiStreamFromClipTLast)}   continue=true
  --vhook_af {xAxiStreamDataFromClip}.TValid    {to_Boolean(xAxiStreamFromClipTValid)}
  IFifox: entity work.MacallanIFifo (wrap)
    port map (
      aBusReset                     => aBusReset,                             --in  boolean
      DmaClk                        => DmaClk,                                --in  std_logic
      dHighSpeedSinkFromDma         => dHighSpeedSinkFromDma,                 --in  NiDmaHighSpeedSinkFromDma_t
      dBaRegPortIn                  => dFixedLogicBaRegPortInLcl,             --in  BaRegPortIn_t
      dBaRegPortOutIFifo            => dBaRegPortOutIFifo,                    --out BaRegPortOut_t
      dIFifoRequestFromDma          => dIFifoRequestFromDma,                  --in  NiDmaInputRequestFromDma_t
      dIFifoRequestToDma            => dIFifoRequestToDma,                    --out NiDmaInputRequestToDma_t
      dIFifoDataFromDma             => dIFifoDataFromDma,                     --in  NiDmaInputDataFromDma_t
      dIFifoDataToDma               => dIFifoDataToDma,                       --out NiDmaInputDataToDma_t
      dIFifoStatusFromDma           => dIFifoStatusFromDma,                   --in  NiDmaInputStatusFromDma_t
      dIFifoArbReq                  => dIFifoArbReq,                          --out NiDmaArbReq_t
      dIFifoArbGrant                => dIFifoArbGrant,                        --in  NiDmaArbGrant_t
      BusClk                        => BusClk,                                --in  std_logic
      aPonReset                     => aPonReset,                             --in  boolean
      bAxiStreamDataToCtrl          => bAxiStreamDataToCtrl,                  --out AxiStreamData_t
      bAxiStreamReadyFromCtrl       => bAxiStreamReadyFromCtrl,               --in  boolean
      bAxiStreamDataFromCtrl        => bAxiStreamDataFromCtrl,                --in  AxiStreamData_t
      bAxiStreamReadyToCtrl         => bAxiStreamReadyToCtrl,                 --out boolean
      aDiagramReset                 => to_Boolean(aDiagramReset),             --in  boolean
      AxiClk                        => AxiClk,                                --in  std_logic
      xAxiStreamDataToClip          => xAxiStreamDataToClip,                  --out AxiStreamData_t
      xAxiStreamReadyFromClip       => to_Boolean(xAxiStreamFromClipTReady),  --in  boolean
      xAxiStreamDataFromClip.TData  => xAxiStreamFromClipTData,               --in  AxiStreamData_t
      xAxiStreamDataFromClip.TLast  => to_Boolean(xAxiStreamFromClipTLast),   --in  AxiStreamData_t
      xAxiStreamDataFromClip.TValid => to_Boolean(xAxiStreamFromClipTValid),  --in  AxiStreamData_t
      xAxiStreamReadyToClip         => xAxiStreamReadyToClip,                 --out boolean
      ViClk                         => ViClk,                                 --in  std_logic
      vIFifoWrData                  => vIFifoWrData,                          --out IFifoWriteData_t
      vIFifoWrDataValid             => vIFifoWrDataValid,                     --out std_logic
      vIFifoWrReadyForOutput        => vIFifoWrReadyForOutput,                --in  std_logic
      vIFifoRdData                  => vIFifoRdData,                          --in  IFifoReadData_t
      vIFifoRdIsError               => vIFifoRdIsError,                       --in  std_logic
      vIFifoRdDataValid             => vIFifoRdDataValid,                     --in  std_logic
      vIFifoRdReadyForInput         => vIFifoRdReadyForInput);                --out std_logic

  xAxiStreamToClipTData  <= xAxiStreamDataToClip.TData;
  xAxiStreamToClipTLast  <= to_StdLogic(xAxiStreamDataToClip.TLast);
  xAxiStreamToClipTValid <= to_StdLogic(xAxiStreamDataToClip.TValid);
  xAxiStreamToClipTReady <= to_StdLogic(xAxiStreamReadyToClip);

  ---------------------------------------------------------------------------------------
  -- Host Memory Buffer DmaComms Breakout
  ---------------------------------------------------------------------------------------

  -- Input
  With_HMB : if kHmbInUse generate
  begin
    dNiFpgaInputRequestToDmaArray(kHMBIndex)      <= dNiHmbInputRequestToDma;
    dNiHmbInputRequestFromDma                     <= dNiFpgaInputRequestFromDmaArray(kHMBIndex);
    dNiFpgaInputDataToDmaArray(kHMBIndex)         <= dNiHmbInputDataToDma;
    dNiHmbInputDataFromDma                        <= dNiFpgaInputDataFromDmaArray(kHMBIndex);
    dNiHmbInputStatusFromDma                      <= dNiFpgaInputStatusFromDmaArray(kHMBIndex);
    -- Output
    dNiFpgaOutputRequestToDmaArray(kHMBIndex)     <= dNiHmbOutputRequestToDma;
    dNiHmbOutputRequestFromDma                    <= dNiFpgaOutputRequestFromDmaArray(kHMBIndex);
    dNiHmbOutputDataFromDma                       <= dNiFpgaOutputDataFromDmaArray(kHMBIndex);
    -- Grants
    dNiHmbInputArbGrant                           <= dNiFpgaInputArbGrant(kHMBIndex);
    dNiHmbOutputArbGrant                          <= dNiFpgaOutputArbGrant(kHMBIndex);
    -- Requests
    dNiFpgaInputArbReq(kHMBIndex)                 <= dNiHmbInputArbReq;
    dNiFpgaOutputArbReq(kHMBIndex)                <= dNiHmbOutputArbReq;
  end generate;

  ---------------------------------------------------------------------------------------
  -- Instruction Fifo DmaComms Breakout
  ---------------------------------------------------------------------------------------

  -- Input
  dNiFpgaInputRequestToDmaArray(kIFifoDmaIndex) <= dIFifoRequestToDma;
  dIFifoRequestFromDma                          <= dNiFpgaInputRequestFromDmaArray(kIFifoDmaIndex);
  dNiFpgaInputDataToDmaArray(kIFifoDmaIndex)    <= dIFifoDataToDma;
  dIFifoDataFromDma                             <= dNiFpgaInputDataFromDmaArray(kIFifoDmaIndex);
  dIFifoStatusFromDma                           <= dNiFpgaInputStatusFromDmaArray(kIFifoDmaIndex);
  -- Grants
  dIFifoArbGrant                                <= dNiFpgaInputArbGrant(kIFifoDmaIndex);
  -- Requests
  dNiFpgaInputArbReq(kIFifoDmaIndex)            <= dIFifoArbReq;

  ---------------------------------------------------------------------------------------
  -- Interrupts
  ---------------------------------------------------------------------------------------
  -- The InChWORM will receive 2 interrupts. LV generates one, and the board control
  -- microblaze generates the other.
  dAppHwInterrupt <= (0 => dIrqToInchworm(0),
                      1 => dIrqFromFixedLogic);

  dFixedLogicDmaIrq <= (0 => kIrqStatusToInterfaceZero);

end architecture struct;
