------------------------------------------------------------------------------------------
--
-- File: FixedLogicWrapper.vhd
-- Author: Rolando Ortega
-- Original Project: The Macallan
-- Date: 18 August 2016
--
------------------------------------------------------------------------------------------
-- (c) 2025 Copyright National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
------------------------------------------------------------------------------------------
--
-- Purpose: Wrapper for FixedLogic netlist.
--
-- This module instantiates the FixedLogic netlist and does type conversion to more
-- easily vhook at higher levels of the hierarchy.
--
------------------------------------------------------------------------------------------
--
-- githubvisible=true
--
-- vreview_group CorubaFixedLogic
-- vreview_closed http://review-board.natinst.com/r/266932/
-- vreview_closed http://review-board.natinst.com/r/260921/
-- vreview_closed http://review-board.natinst.com/r/255990/
-- vreview_closed http://review-board.natinst.com/r/237876/
-- vreview_closed http://review-board.natinst.com/r/217971/
-- vreview_reviewers kygreen dhearn esalinas hrubio lboughal rcastro
--
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgNiUtilities.all;
-- InChWORM Imports
use work.PkgBaRegPort.all;
-- Dma Types
use work.PkgNiDma.all;
use work.PkgDmaPortRecordFlattening.all;

-- Constants from SW
use work.PkgLvFpgaConst.all;

-- Axi Stream
use work.PkgFlexRioAxiStream.all;

--synthesis translate_off
--frmake_addlibrary
--synthesis translate_on

entity FixedLogicWrapper is

  port (
    -------------------------------------------------------------------------------------
    -- Clocks/resets
    -------------------------------------------------------------------------------------
    aPonReset                          : in  boolean;
    aBusReset                          : in  boolean;
    aDiagramReset                      : in  std_logic;
    DmaClk                             : in  std_logic;
    BusClk                             : in  std_logic;
    MbClk                              : in  std_logic;
    -------------------------------------------------------------------------------------
    -- RegPort
    -------------------------------------------------------------------------------------
    dFixedLogicBaRegPortIn             : in  BaRegPortIn_t;
    dFixedLogicBaRegPortOut            : out BaRegPortOut_t;
    -- Trigger Routing BaRegPort
    bTriggerRoutingBaRegPortInAddress  : out std_logic_vector(BaRegPortAddress_t'range);
    bTriggerRoutingBaRegPortInData     : out std_logic_vector(BaRegPortData_t'range);
    bTriggerRoutingBaRegPortInWtStrobe : out std_logic_vector(BaRegPortStrobe_t'range);
    bTriggerRoutingBaRegPortInRdStrobe : out std_logic_vector(BaRegPortStrobe_t'range);
    bTriggerRoutingBaRegPortOutData    : in  std_logic_vector(BaRegPortData_t'range);
    bTriggerRoutingBaRegPortOutAck     : in  std_logic;
    --Routing Socket ID
    bRoutingClipPresent                : in  std_logic;
    bRoutingClipNiCompatible           : in  std_logic;
    -------------------------------------------------------------------------------------
    -- Labview generated constants
    -------------------------------------------------------------------------------------
    stEnableIoRefClk10                 : in  std_logic;
    stEnableIoRefClk100                : in  std_logic;
    -------------------------------------------------------------------------------------
    -- AxiStream
    -------------------------------------------------------------------------------------
    -- AXI4-Stream iFIFO Ports
    bAxiStreamDataToCtrl               : in  AxiStreamData_t;
    bAxiStreamReadyFromCtrl            : out boolean;
    bAxiStreamDataFromCtrl             : out AxiStreamData_t;
    bAxiStreamReadyToCtrl              : in  boolean;
    -------------------------------------------------------------------------------------
    -- Board Control
    -------------------------------------------------------------------------------------
    -- Monitoring SMBus
    bBaseSmbSclOut                     : out std_logic;
    bBaseSmbSclIn                      : in  std_logic;
    bBaseSmbSclTri                     : out std_logic;
    bBaseSmbSdaIn                      : in  std_logic;
    bBaseSmbSdaOut                     : out std_logic;
    bBaseSmbSdaTri                     : out std_logic;
    -- Control I2C Bus
    bConfigI2cSclIn                    : in  std_logic;
    bConfigI2cSclOut                   : out std_logic;
    bConfigI2cSclTri                   : out std_logic;
    bConfigI2cSdaIn                    : in  std_logic;
    bConfigI2cSdaOut                   : out std_logic;
    bConfigI2cSdaTri                   : out std_logic;
    -- Power supply PMBus
    bPwrSupplyPmbSclIn                 : in  std_logic;
    bPwrSupplyPmbSclOut                : out std_logic;
    bPwrSupplyPmbSclTri                : out std_logic;
    bPwrSupplyPmbSdaIn                 : in  std_logic;
    bPwrSupplyPmbSdaOut                : out std_logic;
    bPwrSupplyPmbSdaTri                : out std_logic;
    -- Mezzanine board SMBus
    bMezzSmbSclIn                      : in  std_logic;
    bMezzSmbSclOut                     : out std_logic;
    bMezzSmbSclTri                     : out std_logic;
    bMezzSmbSdaIn                      : in  std_logic;
    bMezzSmbSdaOut                     : out std_logic;
    bMezzSmbSdaTri                     : out std_logic;
    -- Dram Clock Status
    bDramClocksValid                   : out std_logic;
    -- I/O clocking power supply status
    a3v3APwrGood                       : in    std_logic;
    a1v8APwrGood                       : in    std_logic;
    -- LTM4700 Dithering
    a0v85PwrSync                       : out std_logic;
    -------------------------------------------------------------------------------------
    -- Diagram-Reset-driven Board Control
    -------------------------------------------------------------------------------------
    abDiagramReset                     : out boolean;
    --RefClk Control
    bdSetIoRefClk100Enable             : out std_logic;
    bdClearIoRefClk100Enable           : out std_logic;
    bdSetIoRefClk10Enable              : out std_logic;
    bdClearIoRefClk10Enable            : out std_logic;
    bdSelectIoRefClk100                : out std_logic;
    bdSelectIoRefClk10                 : out std_logic;
    --RefClk Status
    bdIoRefClk100Enabled               : in  std_logic;
    bdIoRefClk10Enabled                : in  std_logic;
    bdIoRefClkSwitch                   : in  std_logic;
    -------------------------------------------------------------------------------------
    -- FAM Communication interface
    -------------------------------------------------------------------------------------
    --Module Capabilities
    stIoModuleSupportsFRAGLs           : in  std_logic;
    -- Axi4Lite
    bdClipAxi4LiteArAddr               : in  std_logic_vector(31 downto 0);
    bdClipAxi4LiteArProt               : in  std_logic_vector(2 downto 0);
    bdClipAxi4LiteArReady              : out std_logic;
    bdClipAxi4LiteArValid              : in  std_logic;
    bdClipAxi4LiteAwAddr               : in  std_logic_vector(31 downto 0);
    bdClipAxi4LiteAwProt               : in  std_logic_vector(2 downto 0);
    bdClipAxi4LiteAwReady              : out std_logic;
    bdClipAxi4LiteAwValid              : in  std_logic;
    bdClipAxi4LiteBReady               : in  std_logic;
    bdClipAxi4LiteBResp                : out std_logic_vector(1 downto 0);
    bdClipAxi4LiteBValid               : out std_logic;
    bdClipAxi4LiteRData                : out std_logic_vector(31 downto 0);
    bdClipAxi4LiteRReady               : in  std_logic;
    bdClipAxi4LiteRResp                : out std_logic_vector(1 downto 0);
    bdClipAxi4LiteRValid               : out std_logic;
    bdClipAxi4LiteWData                : in  std_logic_vector(31 downto 0);
    bdClipAxi4LiteWReady               : out std_logic;
    bdClipAxi4LiteWStrb                : in  std_logic_vector(3 downto 0);
    bdClipAxi4LiteWValid               : in  std_logic;
    -------------------------------------------------------------------------------------
    -- Reconfiguration CPLD
    -------------------------------------------------------------------------------------
    SidebandClk                        : out std_logic;
    sSidebandDataOut                   : out std_logic_vector(3 downto 0);
    aSidebandDataIn                    : in  std_logic;
    aSidebandFifoFull                  : in  std_logic;
    -------------------------------------------------------------------------------------
    -- Triggers
    -------------------------------------------------------------------------------------
    aPxiTrigExtTri                   : out std_logic_vector(7 downto 0);
    -------------------------------------------------------------------------------------
    -- System Monitor
    -------------------------------------------------------------------------------------
    aSysMonVector_p                    : in  std_logic_vector(15 downto 0);
    aSysMonVector_n                    : in  std_logic_vector(15 downto 0);
    -------------------------------------------------------------------------------------
    -- CPLD JTAG Field Update
    -------------------------------------------------------------------------------------
    aFldUpdJtagSel                     : out std_logic;
    bFldUpdJtagTck                     : out std_logic;
    bFldUpdJtagTdi                     : out std_logic;
    aFldUpdJtagTdo                     : in  std_logic;
    bFldUpdJtagTms                     : out std_logic;
    -------------------------------------------------------------------------------------
    -- Interrupt
    -------------------------------------------------------------------------------------
    dIrqFromFixedLogic                 : out std_logic
    );

end entity FixedLogicWrapper;

architecture struct of FixedLogicWrapper is

  component MacallanFixedLogic
    port (
      aPonReset                          : in  boolean;
      aBusReset                          : in  boolean;
      aDiagramReset                      : in  std_logic;
      DmaClk                             : in  std_logic;
      BusClk                             : in  std_logic;
      MbClk                              : in  std_logic;
      dFixedLogicBaRegPortInFlat         : in  FlatBaRegPortIn_t;
      dFixedLogicBaRegPortOutFlat        : out FlatBaRegPortOut_t;
      bTriggerRoutingBaRegPortInAddress  : out std_logic_vector(BaRegPortAddress_t'range);
      bTriggerRoutingBaRegPortInData     : out std_logic_vector(BaRegPortData_t'range);
      bTriggerRoutingBaRegPortInWtStrobe : out std_logic_vector(BaRegPortStrobe_t'range);
      bTriggerRoutingBaRegPortInRdStrobe : out std_logic_vector(BaRegPortStrobe_t'range);
      bTriggerRoutingBaRegPortOutData    : in  std_logic_vector(BaRegPortData_t'range);
      bTriggerRoutingBaRegPortOutAck     : in  std_logic;
      bRoutingClipPresent                : in  std_logic;
      bRoutingClipNiCompatible           : in  std_logic;
      stExpectedTbId                     : in  std_logic_vector(31 downto 0);
      stEnableIoRefClk10                 : in  std_logic;
      stEnableIoRefClk100                : in  std_logic;
      stInsertBank0Mig                   : in  boolean;
      stInsertBank1Mig                   : in  boolean;
      bFlatAxiStreamDataToCtrl           : in  FlatAxiStreamData_t;
      bAxiStreamReadyFromCtrl            : out boolean;
      bFlatAxiStreamDataFromCtrl         : out FlatAxiStreamData_t;
      bAxiStreamReadyToCtrl              : in  boolean;
      bBaseSmbSclOut                     : out std_logic;
      bBaseSmbSclIn                      : in  std_logic;
      bBaseSmbSclTri                     : out std_logic;
      bBaseSmbSdaIn                      : in  std_logic;
      bBaseSmbSdaOut                     : out std_logic;
      bBaseSmbSdaTri                     : out std_logic;
      bConfigI2cSclIn                    : in  std_logic;
      bConfigI2cSclOut                   : out std_logic;
      bConfigI2cSclTri                   : out std_logic;
      bConfigI2cSdaIn                    : in  std_logic;
      bConfigI2cSdaOut                   : out std_logic;
      bConfigI2cSdaTri                   : out std_logic;
      bPwrSupplyPmbSclIn                 : in  std_logic;
      bPwrSupplyPmbSclOut                : out std_logic;
      bPwrSupplyPmbSclTri                : out std_logic;
      bPwrSupplyPmbSdaIn                 : in  std_logic;
      bPwrSupplyPmbSdaOut                : out std_logic;
      bPwrSupplyPmbSdaTri                : out std_logic;
      bMezzSmbSclIn                      : in  std_logic;
      bMezzSmbSclOut                     : out std_logic;
      bMezzSmbSclTri                     : out std_logic;
      bMezzSmbSdaIn                      : in  std_logic;
      bMezzSmbSdaOut                     : out std_logic;
      bMezzSmbSdaTri                     : out std_logic;
      bDramClocksValid                   : out std_logic;
      a3v3APwrGood                       : in  std_logic;
      a1v8APwrGood                       : in  std_logic;
      a0v85PwrSync                       : out std_logic;
      abDiagramReset                     : out boolean;
      bdSetIoRefClk100Enable             : out std_logic;
      bdClearIoRefClk100Enable           : out std_logic;
      bdSetIoRefClk10Enable              : out std_logic;
      bdClearIoRefClk10Enable            : out std_logic;
      bdSelectIoRefClk100                : out std_logic;
      bdSelectIoRefClk10                 : out std_logic;
      bdIoRefClk100Enabled               : in  std_logic;
      bdIoRefClk10Enabled                : in  std_logic;
      bdIoRefClkSwitch                   : in  std_logic;
      stIoModuleSupportsFRAGLs           : in  std_logic;
      bdClipAxi4LiteArAddr               : in  std_logic_vector(31 downto 0);
      bdClipAxi4LiteArProt               : in  std_logic_vector(2 downto 0);
      bdClipAxi4LiteArReady              : out std_logic;
      bdClipAxi4LiteArValid              : in  std_logic;
      bdClipAxi4LiteAwAddr               : in  std_logic_vector(31 downto 0);
      bdClipAxi4LiteAwProt               : in  std_logic_vector(2 downto 0);
      bdClipAxi4LiteAwReady              : out std_logic;
      bdClipAxi4LiteAwValid              : in  std_logic;
      bdClipAxi4LiteBReady               : in  std_logic;
      bdClipAxi4LiteBResp                : out std_logic_vector(1 downto 0);
      bdClipAxi4LiteBValid               : out std_logic;
      bdClipAxi4LiteRData                : out std_logic_vector(31 downto 0);
      bdClipAxi4LiteRReady               : in  std_logic;
      bdClipAxi4LiteRResp                : out std_logic_vector(1 downto 0);
      bdClipAxi4LiteRValid               : out std_logic;
      bdClipAxi4LiteWData                : in  std_logic_vector(31 downto 0);
      bdClipAxi4LiteWReady               : out std_logic;
      bdClipAxi4LiteWStrb                : in  std_logic_vector(3 downto 0);
      bdClipAxi4LiteWValid               : in  std_logic;
      SidebandClk                        : out std_logic;
      sSidebandDataOut                   : out std_logic_vector(3 downto 0);
      aSidebandDataIn                    : in  std_logic;
      aSidebandFifoFull                  : in  std_logic;
      aPxiTrigExtTri                     : out std_logic_vector(7 downto 0);
      aSysMonVector_p                    : in  std_logic_vector(15 downto 0);
      aSysMonVector_n                    : in  std_logic_vector(15 downto 0);
      aFldUpdJtagSel                     : out std_logic;
      bFldUpdJtagTck                     : out std_logic;
      bFldUpdJtagTdi                     : out std_logic;
      aFldUpdJtagTdo                     : in  std_logic;
      bFldUpdJtagTms                     : out std_logic;
      dIrqFromFixedLogic                 : out std_logic);
  end component;

  --vhook_sigstart
  --vhook_sigend

  ---------------------------------------------------------------------------------------
  -- Default Interface Assignments
  ---------------------------------------------------------------------------------------
  -- Axi Stream
  signal bFlatAxiStreamDataFromCtrl  : FlatAxiStreamData_t := Flatten(kAxiStreamDataZero);
  signal bFlatAxiStreamDataToCtrl    : FlatAxiStreamData_t := Flatten(kAxiStreamDataZero);
  -- BaRegPort
  signal dFixedLogicBaRegPortInFlat  : FlatBaRegPortIn_t   := Flatten(kBaRegPortInZero);
  signal dFixedLogicBaRegPortOutFlat : FlatBaRegPortOut_t  := Flatten(kBaRegPortOutZero);

begin  -- architecture struct

  ---------------------------------------------------------------------------------------
  -- Fixed Logic
  ---------------------------------------------------------------------------------------

  --vhook   MacallanFixedLogic
  --vhook_a stExpectedTbId              kExpectedTbId
  --vhook_a stInsertBank0Mig            kInsertBank0Mig
  --vhook_a stInsertBank1Mig            kInsertBank1Mig
  MacallanFixedLogicx: MacallanFixedLogic
    port map (
      aPonReset                          => aPonReset,                           --in  boolean
      aBusReset                          => aBusReset,                           --in  boolean
      aDiagramReset                      => aDiagramReset,                       --in  std_logic
      DmaClk                             => DmaClk,                              --in  std_logic
      BusClk                             => BusClk,                              --in  std_logic
      MbClk                              => MbClk,                               --in  std_logic
      dFixedLogicBaRegPortInFlat         => dFixedLogicBaRegPortInFlat,          --in  FlatBaRegPortIn_t
      dFixedLogicBaRegPortOutFlat        => dFixedLogicBaRegPortOutFlat,         --out FlatBaRegPortOut_t
      bTriggerRoutingBaRegPortInAddress  => bTriggerRoutingBaRegPortInAddress,   --out std_logic_vector(BaRegPortAddress_t'range)
      bTriggerRoutingBaRegPortInData     => bTriggerRoutingBaRegPortInData,      --out std_logic_vector(BaRegPortData_t'range)
      bTriggerRoutingBaRegPortInWtStrobe => bTriggerRoutingBaRegPortInWtStrobe,  --out std_logic_vector(BaRegPortStrobe_t'range)
      bTriggerRoutingBaRegPortInRdStrobe => bTriggerRoutingBaRegPortInRdStrobe,  --out std_logic_vector(BaRegPortStrobe_t'range)
      bTriggerRoutingBaRegPortOutData    => bTriggerRoutingBaRegPortOutData,     --in  std_logic_vector(BaRegPortData_t'range)
      bTriggerRoutingBaRegPortOutAck     => bTriggerRoutingBaRegPortOutAck,      --in  std_logic
      bRoutingClipPresent                => bRoutingClipPresent,                 --in  std_logic
      bRoutingClipNiCompatible           => bRoutingClipNiCompatible,            --in  std_logic
      stExpectedTbId                     => kExpectedTbId,                       --in  std_logic_vector(31:0)
      stEnableIoRefClk10                 => stEnableIoRefClk10,                  --in  std_logic
      stEnableIoRefClk100                => stEnableIoRefClk100,                 --in  std_logic
      stInsertBank0Mig                   => kInsertBank0Mig,                     --in  boolean
      stInsertBank1Mig                   => kInsertBank1Mig,                     --in  boolean
      bFlatAxiStreamDataToCtrl           => bFlatAxiStreamDataToCtrl,            --in  FlatAxiStreamData_t
      bAxiStreamReadyFromCtrl            => bAxiStreamReadyFromCtrl,             --out boolean
      bFlatAxiStreamDataFromCtrl         => bFlatAxiStreamDataFromCtrl,          --out FlatAxiStreamData_t
      bAxiStreamReadyToCtrl              => bAxiStreamReadyToCtrl,               --in  boolean
      bBaseSmbSclOut                     => bBaseSmbSclOut,                      --out std_logic
      bBaseSmbSclIn                      => bBaseSmbSclIn,                       --in  std_logic
      bBaseSmbSclTri                     => bBaseSmbSclTri,                      --out std_logic
      bBaseSmbSdaIn                      => bBaseSmbSdaIn,                       --in  std_logic
      bBaseSmbSdaOut                     => bBaseSmbSdaOut,                      --out std_logic
      bBaseSmbSdaTri                     => bBaseSmbSdaTri,                      --out std_logic
      bConfigI2cSclIn                    => bConfigI2cSclIn,                     --in  std_logic
      bConfigI2cSclOut                   => bConfigI2cSclOut,                    --out std_logic
      bConfigI2cSclTri                   => bConfigI2cSclTri,                    --out std_logic
      bConfigI2cSdaIn                    => bConfigI2cSdaIn,                     --in  std_logic
      bConfigI2cSdaOut                   => bConfigI2cSdaOut,                    --out std_logic
      bConfigI2cSdaTri                   => bConfigI2cSdaTri,                    --out std_logic
      bPwrSupplyPmbSclIn                 => bPwrSupplyPmbSclIn,                  --in  std_logic
      bPwrSupplyPmbSclOut                => bPwrSupplyPmbSclOut,                 --out std_logic
      bPwrSupplyPmbSclTri                => bPwrSupplyPmbSclTri,                 --out std_logic
      bPwrSupplyPmbSdaIn                 => bPwrSupplyPmbSdaIn,                  --in  std_logic
      bPwrSupplyPmbSdaOut                => bPwrSupplyPmbSdaOut,                 --out std_logic
      bPwrSupplyPmbSdaTri                => bPwrSupplyPmbSdaTri,                 --out std_logic
      bMezzSmbSclIn                      => bMezzSmbSclIn,                       --in  std_logic
      bMezzSmbSclOut                     => bMezzSmbSclOut,                      --out std_logic
      bMezzSmbSclTri                     => bMezzSmbSclTri,                      --out std_logic
      bMezzSmbSdaIn                      => bMezzSmbSdaIn,                       --in  std_logic
      bMezzSmbSdaOut                     => bMezzSmbSdaOut,                      --out std_logic
      bMezzSmbSdaTri                     => bMezzSmbSdaTri,                      --out std_logic
      bDramClocksValid                   => bDramClocksValid,                    --out std_logic
      a3v3APwrGood                       => a3v3APwrGood,                        --in  std_logic
      a1v8APwrGood                       => a1v8APwrGood,                        --in  std_logic
      a0v85PwrSync                       => a0v85PwrSync,                        --out std_logic
      abDiagramReset                     => abDiagramReset,                      --out boolean
      bdSetIoRefClk100Enable             => bdSetIoRefClk100Enable,              --out std_logic
      bdClearIoRefClk100Enable           => bdClearIoRefClk100Enable,            --out std_logic
      bdSetIoRefClk10Enable              => bdSetIoRefClk10Enable,               --out std_logic
      bdClearIoRefClk10Enable            => bdClearIoRefClk10Enable,             --out std_logic
      bdSelectIoRefClk100                => bdSelectIoRefClk100,                 --out std_logic
      bdSelectIoRefClk10                 => bdSelectIoRefClk10,                  --out std_logic
      bdIoRefClk100Enabled               => bdIoRefClk100Enabled,                --in  std_logic
      bdIoRefClk10Enabled                => bdIoRefClk10Enabled,                 --in  std_logic
      bdIoRefClkSwitch                   => bdIoRefClkSwitch,                    --in  std_logic
      stIoModuleSupportsFRAGLs           => stIoModuleSupportsFRAGLs,            --in  std_logic
      bdClipAxi4LiteArAddr               => bdClipAxi4LiteArAddr,                --in  std_logic_vector(31:0)
      bdClipAxi4LiteArProt               => bdClipAxi4LiteArProt,                --in  std_logic_vector(2:0)
      bdClipAxi4LiteArReady              => bdClipAxi4LiteArReady,               --out std_logic
      bdClipAxi4LiteArValid              => bdClipAxi4LiteArValid,               --in  std_logic
      bdClipAxi4LiteAwAddr               => bdClipAxi4LiteAwAddr,                --in  std_logic_vector(31:0)
      bdClipAxi4LiteAwProt               => bdClipAxi4LiteAwProt,                --in  std_logic_vector(2:0)
      bdClipAxi4LiteAwReady              => bdClipAxi4LiteAwReady,               --out std_logic
      bdClipAxi4LiteAwValid              => bdClipAxi4LiteAwValid,               --in  std_logic
      bdClipAxi4LiteBReady               => bdClipAxi4LiteBReady,                --in  std_logic
      bdClipAxi4LiteBResp                => bdClipAxi4LiteBResp,                 --out std_logic_vector(1:0)
      bdClipAxi4LiteBValid               => bdClipAxi4LiteBValid,                --out std_logic
      bdClipAxi4LiteRData                => bdClipAxi4LiteRData,                 --out std_logic_vector(31:0)
      bdClipAxi4LiteRReady               => bdClipAxi4LiteRReady,                --in  std_logic
      bdClipAxi4LiteRResp                => bdClipAxi4LiteRResp,                 --out std_logic_vector(1:0)
      bdClipAxi4LiteRValid               => bdClipAxi4LiteRValid,                --out std_logic
      bdClipAxi4LiteWData                => bdClipAxi4LiteWData,                 --in  std_logic_vector(31:0)
      bdClipAxi4LiteWReady               => bdClipAxi4LiteWReady,                --out std_logic
      bdClipAxi4LiteWStrb                => bdClipAxi4LiteWStrb,                 --in  std_logic_vector(3:0)
      bdClipAxi4LiteWValid               => bdClipAxi4LiteWValid,                --in  std_logic
      SidebandClk                        => SidebandClk,                         --out std_logic
      sSidebandDataOut                   => sSidebandDataOut,                    --out std_logic_vector(3:0)
      aSidebandDataIn                    => aSidebandDataIn,                     --in  std_logic
      aSidebandFifoFull                  => aSidebandFifoFull,                   --in  std_logic
      aPxiTrigExtTri                     => aPxiTrigExtTri,                      --out std_logic_vector(7:0)
      aSysMonVector_p                    => aSysMonVector_p,                     --in  std_logic_vector(15:0)
      aSysMonVector_n                    => aSysMonVector_n,                     --in  std_logic_vector(15:0)
      aFldUpdJtagSel                     => aFldUpdJtagSel,                      --out std_logic
      bFldUpdJtagTck                     => bFldUpdJtagTck,                      --out std_logic
      bFldUpdJtagTdi                     => bFldUpdJtagTdi,                      --out std_logic
      aFldUpdJtagTdo                     => aFldUpdJtagTdo,                      --in  std_logic
      bFldUpdJtagTms                     => bFldUpdJtagTms,                      --out std_logic
      dIrqFromFixedLogic                 => dIrqFromFixedLogic);                 --out std_logic

  ---------------------------------------------------------------------------------------
  -- Breakouts
  ---------------------------------------------------------------------------------------
  -- From IFifo
  bFlatAxiStreamDataToCtrl   <= Flatten(bAxiStreamDataToCtrl);
  bAxiStreamDataFromCtrl     <= UnFlatten(bFlatAxiStreamDataFromCtrl);
  -- To IFifo
  dFixedLogicBaRegPortInFlat <= Flatten(dFixedLogicBaRegPortIn);
  dFixedLogicBaRegPortOut    <= UnFlatten(dFixedLogicBaRegPortOutFlat);

end architecture struct;
