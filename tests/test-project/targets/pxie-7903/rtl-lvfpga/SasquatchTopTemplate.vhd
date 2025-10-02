------------------------------------------------------------------------------------------
--
-- File: SasquatchTopTemplate.vhd
-- Author: Kyle Green
-- Original Project: Coruba
-- Date: 09 April 2019
--
------------------------------------------------------------------------------------------
-- Copyright (c) 2025 National Instruments Corporation
--
--
-- SPDX-License-Identifier: MIT
------------------------------------------------------------------------------------------
--
-- Purpose: This is the top level file for the 7903
------------------------------------------------------------------------------------------
--
-- githubvisible=true
--
-- vreview_group SasquatchTopTemplate
-- vreview_closed http://review-board.natinst.com/r/217974/
-- vreview_reviewers kygreen dhearn esalinas hrubio lboughal rcastro
--
------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library work;
use work.PkgNiUtilities.all;
use work.PkgSasquatch.all;
-- InChWORM Imports
use work.PkgBaRegPort.all;
use work.PkgCommunicationInterface.all;
use work.PkgDmaPortRecordFlattening.all;
use work.PkgDmaPortCommIfcArbiter.all;
use work.PkgNiDma.all;
use work.PkgNiDmaConfig.all;

-- LVFPGA
use work.PkgDmaPortCommunicationInterface.all;
use work.PkgCommIntConfiguration.all;
use work.PkgDmaPortDmaFifos.all;
use work.PkgDmaPortCommIfcMasterPort.all;
-- LvFpga printed by SW
use work.PkgLvFpgaConst.all;

-- Instruction Fifo
use work.PkgInstructionFifo.all;

-- This package is not used in this file, but it is being included to be seen as a
-- dependency and included as an export.
use work.PkgFlexRioTargetConfig.all;

-- Axi Stream
use work.PkgFlexRioAxiStream.all;

-- Sysmon
use work.PkgSysMonConfig.all;

-- HMB / Dram2DP
use work.PkgDram2DPConstants.all;

-----------------------------------------------------------------------------------------
-- Top-Level Clock/reset domain prefix guide.
-----------------------------------------------------------------------------------------

-- d      - DmaClk, coming from the Inchworm. Reset by a(d)BusReset for the most part.
-- dr[01] - Physical (fast) Dram?Clk for each of the banks.
-- du[01] - Divided down DramUserClk for each of the banks.
-- b      - BusClk, reset by either a(b)BusReset or aPonReset.
-- bd     - BusClk, reset by aDiagramReset. Only exists for signals that use BusClk but
--          connect to The Window.
-- x      - AxiClk on The Window, so also on aDiagramReset. Because we tie AxiClk to
--          BusClk at The Window, in effect x = bd.
-- dt     - DataClk from the FAM Clip
-- dv     - DeviceClk going into the FAM Clip
-- p or s - PxieClk100
-- st     - Static. These signals should be tied to static pins or constants.
-- r      - ReliableClk, as seen by The Window. Not subject to aDiagramReset.
-- it     - IsoTxClk (IsoPort)
-- ir     - IsoRxClk (IsoPort)
-- s      - SidebandClk

entity SasquatchTopTemplate is
  port (
    -------------------------------------------------------------------------------------
    -- Basics
    -------------------------------------------------------------------------------------
    -- Clock Inputs
    --Reliable Clk Input. Comes from an oscillator that is always on
    Osc100ClkIn          : in    std_logic;
    -------------------------------------------------------------------------------------
    -- Board Control
    -------------------------------------------------------------------------------------
    -- I2C bus enable
    aI2cBusEnable        : out   std_logic;
    -- Baseboard monitoring SMBus
    bBaseSmbScl          : inout std_logic;
    bBaseSmbSda          : inout std_logic;
    aBaseSmbAlert_n      : in    std_logic; --vhook_nowarn aBaseSmbAlert_n
    -- Mezanine monitoring SMBus
    bMezzSmbScl          : inout std_logic;
    bMezzSmbSda          : inout std_logic;
    -- Control I2C Bus
    bConfigI2cScl        : inout std_logic;
    bConfigI2cSda        : inout std_logic;
    -- Power supply PMBus
    bPwrSupplyPmbScl     : inout std_logic;
    bPwrSupplyPmbSda     : inout std_logic;
    aPwrSupplyPmbAlert_n : in    std_logic;  --vhook_nowarn aPwrSupplyPmbAlert_n
    -- Clock enables
    aIoRefClk100En       : out   std_logic;
    -- Authentication
    aAuthSda             : inout std_logic;
    -------------------------------------------------------------------------------------
    -- Power
    -------------------------------------------------------------------------------------
    a3v3VDPwrSync        : out std_logic;
    a1v2PwrSync          : out std_logic;
    a0v9PwrSync          : out std_logic;
    aDdr4VttPwrEn        : out std_logic;
    aMgtavttPwrSync      : out std_logic;
    a0v85PwrSync         : out std_logic;
    a1v8fpgaPwrSync      : out std_logic;
    a3v8PwrSync          : out std_logic;
    a3v3OptPwrSync       : out std_logic;
    -------------------------------------------------------------------------------------
    -- PXIe
    -------------------------------------------------------------------------------------
    -- PCIe
    aPcieRst_n           : in    std_logic;
    PcieRefClk_p         : in    std_logic;
    PcieRefClk_n         : in    std_logic;
    PcieRx_p             : in    std_logic_vector (7 downto 0);
    PcieRx_n             : in    std_logic_vector (7 downto 0);
    PcieTx_p             : out   std_logic_vector (7 downto 0);
    PcieTx_n             : out   std_logic_vector (7 downto 0);
    -- PXI trigger/control signals
    aPxiGa               : in    std_logic_vector(4 downto 0);
    aPxiStarData         : in    std_logic;
    aPxiTrigData         : inout std_logic_vector(7 downto 0);
    aPxiTrigDir          : out   std_logic_vector(7 downto 0);
    aPxiTrigOutEn_n      : out   std_logic;
    -- PXIe DStar
    aPxieDStarB_p        : in    std_logic;
    aPxieDStarB_n        : in    std_logic;
    aPxieDStarC_p        : out   std_logic;
    aPxieDStarC_n        : out   std_logic;
    -- PXIe Clk100 and Clk10
    PxieClk100_p         : in    std_logic;
    PxieClk100_n         : in    std_logic;
    pPxieSync100_p       : in    std_logic;
    pPxieSync100_n       : in    std_logic;
    -------------------------------------------------------------------------------------
    -- FAM MGT Plane
    -------------------------------------------------------------------------------------
    -- RefClks
    MgtRefClk_p          : in    std_logic_vector (11 downto 0);
    MgtRefClk_n          : in    std_logic_vector (11 downto 0);

--
-- TheWindow.vhd is generated by LabVIEW FPGA.  We ship a stub to ensure that we can synthesize the design.  This
-- design does not contain any MGT logic.  The MGT logic would be inside the CLIP in the LV Window for LV FPGA
-- generated designs.  For custom FPGA targets, the MGT logic will be placed by the user in the top level entity.
-- Vivado will error when building a design that has MGT lines in the top level entity that are not connected
-- to anything.  So we comment out the MGT lines in the top level.
--
-- If you are making a custom FPGA target, the MGT lines will be statically connected to your MGT logic.  If you are
-- using this FPGA target with a CLIP in LabVIEW FPGA, these MGT signals will be auto-generated by LV FPGA when it
-- processes the VHDL files.  The @ @ BEGIN / END around these signals is where LV FPGA generates the ports.

    
    MgtPortRxLane0_p     : in    std_logic;
    MgtPortRxLane1_p     : in    std_logic;
    MgtPortRxLane2_p     : in    std_logic;
    MgtPortRxLane3_p     : in    std_logic;
    MgtPortRxLane4_p     : in    std_logic;
    MgtPortRxLane5_p     : in    std_logic;
    MgtPortRxLane6_p     : in    std_logic;
    MgtPortRxLane7_p     : in    std_logic;
    MgtPortRxLane8_p     : in    std_logic;
    MgtPortRxLane9_p     : in    std_logic;
    MgtPortRxLane10_p    : in    std_logic;
    MgtPortRxLane11_p    : in    std_logic;
    MgtPortRxLane12_p    : in    std_logic;
    MgtPortRxLane13_p    : in    std_logic;
    MgtPortRxLane14_p    : in    std_logic;
    MgtPortRxLane15_p    : in    std_logic;
    MgtPortRxLane16_p    : in    std_logic;
    MgtPortRxLane17_p    : in    std_logic;
    MgtPortRxLane18_p    : in    std_logic;
    MgtPortRxLane19_p    : in    std_logic;
    MgtPortRxLane20_p    : in    std_logic;
    MgtPortRxLane21_p    : in    std_logic;
    MgtPortRxLane22_p    : in    std_logic;
    MgtPortRxLane23_p    : in    std_logic;
    MgtPortRxLane24_p    : in    std_logic;
    MgtPortRxLane25_p    : in    std_logic;
    MgtPortRxLane26_p    : in    std_logic;
    MgtPortRxLane27_p    : in    std_logic;
    MgtPortRxLane28_p    : in    std_logic;
    MgtPortRxLane29_p    : in    std_logic;
    MgtPortRxLane30_p    : in    std_logic;
    MgtPortRxLane31_p    : in    std_logic;
    MgtPortRxLane32_p    : in    std_logic;
    MgtPortRxLane33_p    : in    std_logic;
    MgtPortRxLane34_p    : in    std_logic;
    MgtPortRxLane35_p    : in    std_logic;
    MgtPortRxLane36_p    : in    std_logic;
    MgtPortRxLane37_p    : in    std_logic;
    MgtPortRxLane38_p    : in    std_logic;
    MgtPortRxLane39_p    : in    std_logic;
    MgtPortRxLane40_p    : in    std_logic;
    MgtPortRxLane41_p    : in    std_logic;
    MgtPortRxLane42_p    : in    std_logic;
    MgtPortRxLane43_p    : in    std_logic;
    MgtPortRxLane44_p    : in    std_logic;
    MgtPortRxLane45_p    : in    std_logic;
    MgtPortRxLane46_p    : in    std_logic;
    MgtPortRxLane47_p    : in    std_logic;
    MgtPortRxLane0_n     : in    std_logic;
    MgtPortRxLane1_n     : in    std_logic;
    MgtPortRxLane2_n     : in    std_logic;
    MgtPortRxLane3_n     : in    std_logic;
    MgtPortRxLane4_n     : in    std_logic;
    MgtPortRxLane5_n     : in    std_logic;
    MgtPortRxLane6_n     : in    std_logic;
    MgtPortRxLane7_n     : in    std_logic;
    MgtPortRxLane8_n     : in    std_logic;
    MgtPortRxLane9_n     : in    std_logic;
    MgtPortRxLane10_n    : in    std_logic;
    MgtPortRxLane11_n    : in    std_logic;
    MgtPortRxLane12_n    : in    std_logic;
    MgtPortRxLane13_n    : in    std_logic;
    MgtPortRxLane14_n    : in    std_logic;
    MgtPortRxLane15_n    : in    std_logic;
    MgtPortRxLane16_n    : in    std_logic;
    MgtPortRxLane17_n    : in    std_logic;
    MgtPortRxLane18_n    : in    std_logic;
    MgtPortRxLane19_n    : in    std_logic;
    MgtPortRxLane20_n    : in    std_logic;
    MgtPortRxLane21_n    : in    std_logic;
    MgtPortRxLane22_n    : in    std_logic;
    MgtPortRxLane23_n    : in    std_logic;
    MgtPortRxLane24_n    : in    std_logic;
    MgtPortRxLane25_n    : in    std_logic;
    MgtPortRxLane26_n    : in    std_logic;
    MgtPortRxLane27_n    : in    std_logic;
    MgtPortRxLane28_n    : in    std_logic;
    MgtPortRxLane29_n    : in    std_logic;
    MgtPortRxLane30_n    : in    std_logic;
    MgtPortRxLane31_n    : in    std_logic;
    MgtPortRxLane32_n    : in    std_logic;
    MgtPortRxLane33_n    : in    std_logic;
    MgtPortRxLane34_n    : in    std_logic;
    MgtPortRxLane35_n    : in    std_logic;
    MgtPortRxLane36_n    : in    std_logic;
    MgtPortRxLane37_n    : in    std_logic;
    MgtPortRxLane38_n    : in    std_logic;
    MgtPortRxLane39_n    : in    std_logic;
    MgtPortRxLane40_n    : in    std_logic;
    MgtPortRxLane41_n    : in    std_logic;
    MgtPortRxLane42_n    : in    std_logic;
    MgtPortRxLane43_n    : in    std_logic;
    MgtPortRxLane44_n    : in    std_logic;
    MgtPortRxLane45_n    : in    std_logic;
    MgtPortRxLane46_n    : in    std_logic;
    MgtPortRxLane47_n    : in    std_logic;
    MgtPortTxLane0_p     : out   std_logic;
    MgtPortTxLane1_p     : out   std_logic;
    MgtPortTxLane2_p     : out   std_logic;
    MgtPortTxLane3_p     : out   std_logic;
    MgtPortTxLane4_p     : out   std_logic;
    MgtPortTxLane5_p     : out   std_logic;
    MgtPortTxLane6_p     : out   std_logic;
    MgtPortTxLane7_p     : out   std_logic;
    MgtPortTxLane8_p     : out   std_logic;
    MgtPortTxLane9_p     : out   std_logic;
    MgtPortTxLane10_p    : out   std_logic;
    MgtPortTxLane11_p    : out   std_logic;
    MgtPortTxLane12_p    : out   std_logic;
    MgtPortTxLane13_p    : out   std_logic;
    MgtPortTxLane14_p    : out   std_logic;
    MgtPortTxLane15_p    : out   std_logic;
    MgtPortTxLane16_p    : out   std_logic;
    MgtPortTxLane17_p    : out   std_logic;
    MgtPortTxLane18_p    : out   std_logic;
    MgtPortTxLane19_p    : out   std_logic;
    MgtPortTxLane20_p    : out   std_logic;
    MgtPortTxLane21_p    : out   std_logic;
    MgtPortTxLane22_p    : out   std_logic;
    MgtPortTxLane23_p    : out   std_logic;
    MgtPortTxLane24_p    : out   std_logic;
    MgtPortTxLane25_p    : out   std_logic;
    MgtPortTxLane26_p    : out   std_logic;
    MgtPortTxLane27_p    : out   std_logic;
    MgtPortTxLane28_p    : out   std_logic;
    MgtPortTxLane29_p    : out   std_logic;
    MgtPortTxLane30_p    : out   std_logic;
    MgtPortTxLane31_p    : out   std_logic;
    MgtPortTxLane32_p    : out   std_logic;
    MgtPortTxLane33_p    : out   std_logic;
    MgtPortTxLane34_p    : out   std_logic;
    MgtPortTxLane35_p    : out   std_logic;
    MgtPortTxLane36_p    : out   std_logic;
    MgtPortTxLane37_p    : out   std_logic;
    MgtPortTxLane38_p    : out   std_logic;
    MgtPortTxLane39_p    : out   std_logic;
    MgtPortTxLane40_p    : out   std_logic;
    MgtPortTxLane41_p    : out   std_logic;
    MgtPortTxLane42_p    : out   std_logic;
    MgtPortTxLane43_p    : out   std_logic;
    MgtPortTxLane44_p    : out   std_logic;
    MgtPortTxLane45_p    : out   std_logic;
    MgtPortTxLane46_p    : out   std_logic;
    MgtPortTxLane47_p    : out   std_logic;
    MgtPortTxLane0_n     : out   std_logic;
    MgtPortTxLane1_n     : out   std_logic;
    MgtPortTxLane2_n     : out   std_logic;
    MgtPortTxLane3_n     : out   std_logic;
    MgtPortTxLane4_n     : out   std_logic;
    MgtPortTxLane5_n     : out   std_logic;
    MgtPortTxLane6_n     : out   std_logic;
    MgtPortTxLane7_n     : out   std_logic;
    MgtPortTxLane8_n     : out   std_logic;
    MgtPortTxLane9_n     : out   std_logic;
    MgtPortTxLane10_n    : out   std_logic;
    MgtPortTxLane11_n    : out   std_logic;
    MgtPortTxLane12_n    : out   std_logic;
    MgtPortTxLane13_n    : out   std_logic;
    MgtPortTxLane14_n    : out   std_logic;
    MgtPortTxLane15_n    : out   std_logic;
    MgtPortTxLane16_n    : out   std_logic;
    MgtPortTxLane17_n    : out   std_logic;
    MgtPortTxLane18_n    : out   std_logic;
    MgtPortTxLane19_n    : out   std_logic;
    MgtPortTxLane20_n    : out   std_logic;
    MgtPortTxLane21_n    : out   std_logic;
    MgtPortTxLane22_n    : out   std_logic;
    MgtPortTxLane23_n    : out   std_logic;
    MgtPortTxLane24_n    : out   std_logic;
    MgtPortTxLane25_n    : out   std_logic;
    MgtPortTxLane26_n    : out   std_logic;
    MgtPortTxLane27_n    : out   std_logic;
    MgtPortTxLane28_n    : out   std_logic;
    MgtPortTxLane29_n    : out   std_logic;
    MgtPortTxLane30_n    : out   std_logic;
    MgtPortTxLane31_n    : out   std_logic;
    MgtPortTxLane32_n    : out   std_logic;
    MgtPortTxLane33_n    : out   std_logic;
    MgtPortTxLane34_n    : out   std_logic;
    MgtPortTxLane35_n    : out   std_logic;
    MgtPortTxLane36_n    : out   std_logic;
    MgtPortTxLane37_n    : out   std_logic;
    MgtPortTxLane38_n    : out   std_logic;
    MgtPortTxLane39_n    : out   std_logic;
    MgtPortTxLane40_n    : out   std_logic;
    MgtPortTxLane41_n    : out   std_logic;
    MgtPortTxLane42_n    : out   std_logic;
    MgtPortTxLane43_n    : out   std_logic;
    MgtPortTxLane44_n    : out   std_logic;
    MgtPortTxLane45_n    : out   std_logic;
    MgtPortTxLane46_n    : out   std_logic;
    MgtPortTxLane47_n    : out   std_logic;
   -------------------------------------------------------------------------------------
    -- FAM Control and Status
    -------------------------------------------------------------------------------------
    aLmkI2cSda            : inout std_logic;
    aLmkI2cScl            : inout std_logic;
    aLmk1Pdn_n            : out   std_logic;
    aLmk2Pdn_n            : out   std_logic;
    aLmk1Gpio0            : out   std_logic;
    aLmk2Gpio0            : out   std_logic;
    aLmk1Status0          : in    std_logic;
    aLmk1Status1          : in    std_logic;
    aLmk2Status0          : in    std_logic;
    aLmk2Status1          : in    std_logic;
    aIPassVccPowerFault_n : in    std_logic;
    aIPassPrsnt_n         : in    std_logic_vector(7 downto 0);
    aIPassIntr_n          : in    std_logic_vector(7 downto 0);
    aIPassSCL             : inout std_logic_vector(11 downto 0);
    aIPassSDA             : inout std_logic_vector(11 downto 0);
    aPortExpReset_n       : out   std_logic;
    aPortExpIntr_n        : in    std_logic;
    aPortExpSda           : inout std_logic;
    aPortExpScl           : inout std_logic;
    -------------------------------------------------------------------------------------
    -- DIO
    -------------------------------------------------------------------------------------
    aDio                 : inout std_logic_vector(7 downto 0);
    aFpgaReady_n         : out   std_logic;
    -------------------------------------------------------------------------------------
    -- Reconfiguration CPLD
    -------------------------------------------------------------------------------------
    SidebandClk          : out   std_logic;
    sSidebandDataOut     : out   std_logic_vector(3 downto 0);
    aSidebandDataIn      : in    std_logic;
    aSidebandFifoFull    : in    std_logic;
    aFpgaStage2Done      : out   std_logic;
    -------------------------------------------------------------------------------------
    -- DRAM signals
    -------------------------------------------------------------------------------------
    -- External oscillators for DRAM controllers
    Dram0RefClk_p        : in    std_logic;
    Dram0RefClk_n        : in    std_logic;
    Dram1RefClk_p        : in    std_logic;
    Dram1RefClk_n        : in    std_logic;
    -------------------------------------------------------------------------------------
    -- Bank 0
    -------------------------------------------------------------------------------------
    -- Outgoing clock
    Dram0Clk_p           : out   std_logic;
    Dram0Clk_n           : out   std_logic;
    -- Data
    dr0DramDq            : inout std_logic_vector(79 downto 0);
    dr0DramDmDbi_n       : inout std_logic_vector(9 downto 0);
    dr0DramDqs_p         : inout std_logic_vector(9 downto 0);
    dr0DramDqs_n         : inout std_logic_vector(9 downto 0);
    -- Address/Command
    dr0DramCs_n          : out   std_logic;
    dr0DramAddr          : out   std_logic_vector(16 downto 0);
    dr0DramBankAddr      : out   std_logic_vector(1 downto 0);
    dr0DramBg            : out   std_logic_vector(0 downto 0);
    dr0DramAct_n         : out   std_logic;
    -- Control/Clocking
    dr0DramClkEn         : out   std_logic;
    dr0DramOdt           : out   std_logic;
    dr0DramReset_n       : out   std_logic;
    -- Test Pin
    dr0DramTestMode      : out   std_logic;
    -------------------------------------------------------------------------------------
    -- Bank 1
    -------------------------------------------------------------------------------------
    -- Outgoing clock
    Dram1Clk_p           : out   std_logic;
    Dram1Clk_n           : out   std_logic;
    -- Data
    dr1DramDq            : inout std_logic_vector(79 downto 0);
    dr1DramDmDbi_n       : inout std_logic_vector(9 downto 0);
    dr1DramDqs_p         : inout std_logic_vector(9 downto 0);
    dr1DramDqs_n         : inout std_logic_vector(9 downto 0);
    -- Address/Command
    dr1DramCs_n          : out   std_logic;
    dr1DramAddr          : out   std_logic_vector(16 downto 0);
    dr1DramBankAddr      : out   std_logic_vector(1 downto 0);
    dr1DramBg            : out   std_logic_vector(0 downto 0);
    dr1DramAct_n         : out   std_logic;
    -- Control/Clocking
    dr1DramClkEn         : out   std_logic;
    dr1DramOdt           : out   std_logic;
    dr1DramReset_n       : out   std_logic;
    dr1DramTestMode      : out   std_logic;
    -------------------------------------------------------------------------------------
    -- System Monitor
    -------------------------------------------------------------------------------------
    --vhook_nodgv {aSysMon_(\w+)_[pn]}
    aSysMon_3v3AMezz_Divided_p     : in   std_logic;
    aSysMon_3v3AMezz_Divided_n     : in   std_logic;
    aSysMon_3v3VDMezz_Divided_p    : in   std_logic;
    aSysMon_3v3VDMezz_Divided_n    : in   std_logic;
    aSysMon_VccioMezz_Divided_p    : in   std_logic;
    aSysMon_VccioMezz_Divided_n    : in   std_logic;
    aSysMon_1v2MgtAvtt_Divided_p   : in   std_logic;
    aSysMon_1v2MgtAvtt_Divided_n   : in   std_logic;
    aSysMon_0v9MgtAvcc_Divided_p   : in   std_logic;
    aSysMon_0v9MgtAvcc_Divided_n   : in   std_logic;
    aSysMon_3v3A_Divided_p         : in   std_logic;
    aSysMon_3v3A_Divided_n         : in   std_logic;
    aSysMon_3v8_Divided_p          : in   std_logic;
    aSysMon_3v8_Divided_n          : in   std_logic;
    aSysMon_3v3D_Divided_p         : in   std_logic;
    aSysMon_3v3D_Divided_n         : in   std_logic;
    aSysMon_DramVpp_Divided_p      : in   std_logic;
    aSysMon_DramVpp_Divided_n      : in   std_logic;
    aSysMon_1v8A_Divided_p         : in   std_logic;
    aSysMon_1v8A_Divided_n         : in   std_logic;
    aSysMon_Dram0Vtt_Sense_p       : in   std_logic;
    aSysMon_Dram0Vtt_Sense_n       : in   std_logic;
    aSysMon_1v8MgtVccaux_Divided_p : in   std_logic;
    aSysMon_1v8MgtVccaux_Divided_n : in   std_logic;
    aSysMon_DramVref_Sense_p       : in   std_logic;
    aSysMon_DramVref_Sense_n       : in   std_logic;
    aSysMon_1v2_Divided_p          : in   std_logic;
    aSysMon_1v2_Divided_n          : in   std_logic;
    -------------------------------------------------------------------------------------
    -- CPLD JTAG Field Update
    -------------------------------------------------------------------------------------
    aFldUpdJtagSel       : out   std_logic;
    bFldUpdJtagTck       : out   std_logic;
    bFldUpdJtagTdi       : out   std_logic;
    aFldUpdJtagTdo       : in    std_logic;
    bFldUpdJtagTms       : out   std_logic;
    -------------------------------------------------------------------------------------
    -- New Pins
    -------------------------------------------------------------------------------------
    aFpgaB2bSpare1     : in  std_logic;
    aFpgaB2bSpare2     : in  std_logic; --vhook_nowarn aFpgaB2bSpare*
    dr0DramAlert_n     : in  std_logic;
    dr1DramAlert_n     : in  std_logic; --vhook_nowarn dr*DramAlert_n
    aPllCtrlStatusEn_n : out std_logic
  );
end entity SasquatchTopTemplate;

architecture struct of SasquatchTopTemplate is

  component PxieUspTimingEngine
    port (
      aPcieRst           : in  std_logic;
      aResetToInchworm_n : out std_logic;
      aResetFromInchworm : in  boolean;
      aBusReset          : out boolean;
      abBusReset         : out boolean;
      PxieClk100_p       : in  std_logic;
      PxieClk100_n       : in  std_logic;
      Osc100ClkIn        : in  std_logic;
      rBaseClksValid     : out std_logic;
      BusClk             : in  std_logic;
      bTePllLocked       : out std_logic;
      ReliableClk        : out std_logic;
      PxieClk100         : out std_logic;
      DlyRefClk          : out std_logic;
      PllClk40           : out std_logic;
      PllClk80           : out std_logic;
      MbClk              : out std_logic;
      aStage2Enabled     : in  boolean;
      pPxieSync100_p     : in  std_logic;
      pPxieSync100_n     : in  std_logic;
      pClk10GenD         : out std_logic;
      pIntSync100        : out std_logic;
      aIntClk10          : out std_logic;
      aEnableClk10       : in  boolean;
      aDramClocksValid   : in  boolean;
      aDramPllLocked     : in  boolean;
      aDramPonReset      : out boolean;
      aDramReady         : out std_logic;
      du0DramPhyInitDone : in  std_logic;
      du1DramPhyInitDone : in  std_logic;
      aPonReset          : out boolean;
      adlyReset          : out boolean);
  end component;

  component TheWindow is
    port(

      -----------------------------------
      -- CUSTOM BOARD IO
      -----------------------------------
      xIoModuleReady : in std_logic; -- IO Socket\IO Ready
      xIoModuleErrorCode : in std_logic_vector(31 downto 0); -- IO Socket\IO Error
      aDioOut : out std_logic_vector(7 downto 0); -- IO Socket\DIO Out
      aDioIn : in std_logic_vector(7 downto 0); -- IO Socket\DIO In
      UserClkPort0 : in std_logic; -- IO Socket\Port0 User Clock
      aPort0PmaInit : out std_logic; -- IO Socket\Port0\PmaInit
      aPort0ResetPb : out std_logic; -- IO Socket\Port0\ResetPb
      uPort0AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port0\Tx\TData0
      uPort0AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port0\Tx\TData1
      uPort0AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port0\Tx\TData2
      uPort0AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port0\Tx\TData3
      uPort0AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port0\Tx\TKeep
      uPort0AxiTxTLast : out std_logic; -- IO Socket\Port0\Tx\TLast
      uPort0AxiTxTValid : out std_logic; -- IO Socket\Port0\Tx\TValid
      uPort0AxiTxTReady : in std_logic; -- IO Socket\Port0\Tx\TReady
      uPort0AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port0\Rx\TData0
      uPort0AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port0\Rx\TData1
      uPort0AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port0\Rx\TData2
      uPort0AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port0\Rx\TData3
      uPort0AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port0\Rx\TKeep
      uPort0AxiRxTLast : in std_logic; -- IO Socket\Port0\Rx\TLast
      uPort0AxiRxTValid : in std_logic; -- IO Socket\Port0\Rx\TValid
      uPort0AxiNfcTValid : out std_logic; -- IO Socket\Port0\Nfc\TValid
      uPort0AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port0\Nfc\TData
      uPort0AxiNfcTReady : in std_logic; -- IO Socket\Port0\Nfc\TReady
      uPort0HardError : in std_logic; -- IO Socket\Port0\HardError
      uPort0SoftError : in std_logic; -- IO Socket\Port0\SoftError
      uPort0LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port0\LaneUp
      uPort0ChannelUp : in std_logic; -- IO Socket\Port0\ChannelUp
      uPort0SysResetOut : in std_logic; -- IO Socket\Port0\SysResetOut
      uPort0MmcmNotLockOut : in std_logic; -- IO Socket\Port0\MmcmNotLockOut
      uPort0CrcPassFail_n : in std_logic; -- IO Socket\Port0\CrcPassFail_n
      uPort0CrcValid : in std_logic; -- IO Socket\Port0\CrcValid
      iPort0LinkResetOut : in std_logic; -- IO Socket\Port0\LinkResetOut
      sGtwiz0CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port0\CtrlAxi\AWAddr
      sGtwiz0CtrlAxiAWValid : out std_logic; -- IO Socket\Port0\CtrlAxi\AWValid
      sGtwiz0CtrlAxiAWReady : in std_logic; -- IO Socket\Port0\CtrlAxi\AWReady
      sGtwiz0CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port0\CtrlAxi\WData
      sGtwiz0CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port0\CtrlAxi\WStrb
      sGtwiz0CtrlAxiWValid : out std_logic; -- IO Socket\Port0\CtrlAxi\WValid
      sGtwiz0CtrlAxiWReady : in std_logic; -- IO Socket\Port0\CtrlAxi\WReady
      sGtwiz0CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port0\CtrlAxi\BResp
      sGtwiz0CtrlAxiBValid : in std_logic; -- IO Socket\Port0\CtrlAxi\BValid
      sGtwiz0CtrlAxiBReady : out std_logic; -- IO Socket\Port0\CtrlAxi\BReady
      sGtwiz0CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port0\CtrlAxi\ARAddr
      sGtwiz0CtrlAxiARValid : out std_logic; -- IO Socket\Port0\CtrlAxi\ARValid
      sGtwiz0CtrlAxiARReady : in std_logic; -- IO Socket\Port0\CtrlAxi\ARReady
      sGtwiz0CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port0\CtrlAxi\RData
      sGtwiz0CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port0\CtrlAxi\RResp
      sGtwiz0CtrlAxiRValid : in std_logic; -- IO Socket\Port0\CtrlAxi\RValid
      sGtwiz0CtrlAxiRReady : out std_logic; -- IO Socket\Port0\CtrlAxi\RReady
      sGtwiz0DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port0\DrpChAxi\AWAddr
      sGtwiz0DrpChAxiAWValid : out std_logic; -- IO Socket\Port0\DrpChAxi\AWValid
      sGtwiz0DrpChAxiAWReady : in std_logic; -- IO Socket\Port0\DrpChAxi\AWReady
      sGtwiz0DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port0\DrpChAxi\WData
      sGtwiz0DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port0\DrpChAxi\WStrb
      sGtwiz0DrpChAxiWValid : out std_logic; -- IO Socket\Port0\DrpChAxi\WValid
      sGtwiz0DrpChAxiWReady : in std_logic; -- IO Socket\Port0\DrpChAxi\WReady
      sGtwiz0DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port0\DrpChAxi\BResp
      sGtwiz0DrpChAxiBValid : in std_logic; -- IO Socket\Port0\DrpChAxi\BValid
      sGtwiz0DrpChAxiBReady : out std_logic; -- IO Socket\Port0\DrpChAxi\BReady
      sGtwiz0DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port0\DrpChAxi\ARAddr
      sGtwiz0DrpChAxiARValid : out std_logic; -- IO Socket\Port0\DrpChAxi\ARValid
      sGtwiz0DrpChAxiARReady : in std_logic; -- IO Socket\Port0\DrpChAxi\ARReady
      sGtwiz0DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port0\DrpChAxi\RData
      sGtwiz0DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port0\DrpChAxi\RResp
      sGtwiz0DrpChAxiRValid : in std_logic; -- IO Socket\Port0\DrpChAxi\RValid
      sGtwiz0DrpChAxiRReady : out std_logic; -- IO Socket\Port0\DrpChAxi\RReady
      UserClkPort1 : in std_logic; -- IO Socket\Port1 User Clock
      aPort1PmaInit : out std_logic; -- IO Socket\Port1\PmaInit
      aPort1ResetPb : out std_logic; -- IO Socket\Port1\ResetPb
      uPort1AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port1\Tx\TData0
      uPort1AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port1\Tx\TData1
      uPort1AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port1\Tx\TData2
      uPort1AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port1\Tx\TData3
      uPort1AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port1\Tx\TKeep
      uPort1AxiTxTLast : out std_logic; -- IO Socket\Port1\Tx\TLast
      uPort1AxiTxTValid : out std_logic; -- IO Socket\Port1\Tx\TValid
      uPort1AxiTxTReady : in std_logic; -- IO Socket\Port1\Tx\TReady
      uPort1AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port1\Rx\TData0
      uPort1AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port1\Rx\TData1
      uPort1AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port1\Rx\TData2
      uPort1AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port1\Rx\TData3
      uPort1AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port1\Rx\TKeep
      uPort1AxiRxTLast : in std_logic; -- IO Socket\Port1\Rx\TLast
      uPort1AxiRxTValid : in std_logic; -- IO Socket\Port1\Rx\TValid
      uPort1AxiNfcTValid : out std_logic; -- IO Socket\Port1\Nfc\TValid
      uPort1AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port1\Nfc\TData
      uPort1AxiNfcTReady : in std_logic; -- IO Socket\Port1\Nfc\TReady
      uPort1HardError : in std_logic; -- IO Socket\Port1\HardError
      uPort1SoftError : in std_logic; -- IO Socket\Port1\SoftError
      uPort1LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port1\LaneUp
      uPort1ChannelUp : in std_logic; -- IO Socket\Port1\ChannelUp
      uPort1SysResetOut : in std_logic; -- IO Socket\Port1\SysResetOut
      uPort1MmcmNotLockOut : in std_logic; -- IO Socket\Port1\MmcmNotLockOut
      uPort1CrcPassFail_n : in std_logic; -- IO Socket\Port1\CrcPassFail_n
      uPort1CrcValid : in std_logic; -- IO Socket\Port1\CrcValid
      iPort1LinkResetOut : in std_logic; -- IO Socket\Port1\LinkResetOut
      sGtwiz1CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port1\CtrlAxi\AWAddr
      sGtwiz1CtrlAxiAWValid : out std_logic; -- IO Socket\Port1\CtrlAxi\AWValid
      sGtwiz1CtrlAxiAWReady : in std_logic; -- IO Socket\Port1\CtrlAxi\AWReady
      sGtwiz1CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port1\CtrlAxi\WData
      sGtwiz1CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port1\CtrlAxi\WStrb
      sGtwiz1CtrlAxiWValid : out std_logic; -- IO Socket\Port1\CtrlAxi\WValid
      sGtwiz1CtrlAxiWReady : in std_logic; -- IO Socket\Port1\CtrlAxi\WReady
      sGtwiz1CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port1\CtrlAxi\BResp
      sGtwiz1CtrlAxiBValid : in std_logic; -- IO Socket\Port1\CtrlAxi\BValid
      sGtwiz1CtrlAxiBReady : out std_logic; -- IO Socket\Port1\CtrlAxi\BReady
      sGtwiz1CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port1\CtrlAxi\ARAddr
      sGtwiz1CtrlAxiARValid : out std_logic; -- IO Socket\Port1\CtrlAxi\ARValid
      sGtwiz1CtrlAxiARReady : in std_logic; -- IO Socket\Port1\CtrlAxi\ARReady
      sGtwiz1CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port1\CtrlAxi\RData
      sGtwiz1CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port1\CtrlAxi\RResp
      sGtwiz1CtrlAxiRValid : in std_logic; -- IO Socket\Port1\CtrlAxi\RValid
      sGtwiz1CtrlAxiRReady : out std_logic; -- IO Socket\Port1\CtrlAxi\RReady
      sGtwiz1DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port1\DrpChAxi\AWAddr
      sGtwiz1DrpChAxiAWValid : out std_logic; -- IO Socket\Port1\DrpChAxi\AWValid
      sGtwiz1DrpChAxiAWReady : in std_logic; -- IO Socket\Port1\DrpChAxi\AWReady
      sGtwiz1DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port1\DrpChAxi\WData
      sGtwiz1DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port1\DrpChAxi\WStrb
      sGtwiz1DrpChAxiWValid : out std_logic; -- IO Socket\Port1\DrpChAxi\WValid
      sGtwiz1DrpChAxiWReady : in std_logic; -- IO Socket\Port1\DrpChAxi\WReady
      sGtwiz1DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port1\DrpChAxi\BResp
      sGtwiz1DrpChAxiBValid : in std_logic; -- IO Socket\Port1\DrpChAxi\BValid
      sGtwiz1DrpChAxiBReady : out std_logic; -- IO Socket\Port1\DrpChAxi\BReady
      sGtwiz1DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port1\DrpChAxi\ARAddr
      sGtwiz1DrpChAxiARValid : out std_logic; -- IO Socket\Port1\DrpChAxi\ARValid
      sGtwiz1DrpChAxiARReady : in std_logic; -- IO Socket\Port1\DrpChAxi\ARReady
      sGtwiz1DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port1\DrpChAxi\RData
      sGtwiz1DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port1\DrpChAxi\RResp
      sGtwiz1DrpChAxiRValid : in std_logic; -- IO Socket\Port1\DrpChAxi\RValid
      sGtwiz1DrpChAxiRReady : out std_logic; -- IO Socket\Port1\DrpChAxi\RReady
      UserClkPort2 : in std_logic; -- IO Socket\Port2 User Clock
      aPort2PmaInit : out std_logic; -- IO Socket\Port2\PmaInit
      aPort2ResetPb : out std_logic; -- IO Socket\Port2\ResetPb
      uPort2AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port2\Tx\TData0
      uPort2AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port2\Tx\TData1
      uPort2AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port2\Tx\TData2
      uPort2AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port2\Tx\TData3
      uPort2AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port2\Tx\TKeep
      uPort2AxiTxTLast : out std_logic; -- IO Socket\Port2\Tx\TLast
      uPort2AxiTxTValid : out std_logic; -- IO Socket\Port2\Tx\TValid
      uPort2AxiTxTReady : in std_logic; -- IO Socket\Port2\Tx\TReady
      uPort2AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port2\Rx\TData0
      uPort2AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port2\Rx\TData1
      uPort2AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port2\Rx\TData2
      uPort2AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port2\Rx\TData3
      uPort2AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port2\Rx\TKeep
      uPort2AxiRxTLast : in std_logic; -- IO Socket\Port2\Rx\TLast
      uPort2AxiRxTValid : in std_logic; -- IO Socket\Port2\Rx\TValid
      uPort2AxiNfcTValid : out std_logic; -- IO Socket\Port2\Nfc\TValid
      uPort2AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port2\Nfc\TData
      uPort2AxiNfcTReady : in std_logic; -- IO Socket\Port2\Nfc\TReady
      uPort2HardError : in std_logic; -- IO Socket\Port2\HardError
      uPort2SoftError : in std_logic; -- IO Socket\Port2\SoftError
      uPort2LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port2\LaneUp
      uPort2ChannelUp : in std_logic; -- IO Socket\Port2\ChannelUp
      uPort2SysResetOut : in std_logic; -- IO Socket\Port2\SysResetOut
      uPort2MmcmNotLockOut : in std_logic; -- IO Socket\Port2\MmcmNotLockOut
      uPort2CrcPassFail_n : in std_logic; -- IO Socket\Port2\CrcPassFail_n
      uPort2CrcValid : in std_logic; -- IO Socket\Port2\CrcValid
      iPort2LinkResetOut : in std_logic; -- IO Socket\Port2\LinkResetOut
      sGtwiz2CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port2\CtrlAxi\AWAddr
      sGtwiz2CtrlAxiAWValid : out std_logic; -- IO Socket\Port2\CtrlAxi\AWValid
      sGtwiz2CtrlAxiAWReady : in std_logic; -- IO Socket\Port2\CtrlAxi\AWReady
      sGtwiz2CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port2\CtrlAxi\WData
      sGtwiz2CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port2\CtrlAxi\WStrb
      sGtwiz2CtrlAxiWValid : out std_logic; -- IO Socket\Port2\CtrlAxi\WValid
      sGtwiz2CtrlAxiWReady : in std_logic; -- IO Socket\Port2\CtrlAxi\WReady
      sGtwiz2CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port2\CtrlAxi\BResp
      sGtwiz2CtrlAxiBValid : in std_logic; -- IO Socket\Port2\CtrlAxi\BValid
      sGtwiz2CtrlAxiBReady : out std_logic; -- IO Socket\Port2\CtrlAxi\BReady
      sGtwiz2CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port2\CtrlAxi\ARAddr
      sGtwiz2CtrlAxiARValid : out std_logic; -- IO Socket\Port2\CtrlAxi\ARValid
      sGtwiz2CtrlAxiARReady : in std_logic; -- IO Socket\Port2\CtrlAxi\ARReady
      sGtwiz2CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port2\CtrlAxi\RData
      sGtwiz2CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port2\CtrlAxi\RResp
      sGtwiz2CtrlAxiRValid : in std_logic; -- IO Socket\Port2\CtrlAxi\RValid
      sGtwiz2CtrlAxiRReady : out std_logic; -- IO Socket\Port2\CtrlAxi\RReady
      sGtwiz2DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port2\DrpChAxi\AWAddr
      sGtwiz2DrpChAxiAWValid : out std_logic; -- IO Socket\Port2\DrpChAxi\AWValid
      sGtwiz2DrpChAxiAWReady : in std_logic; -- IO Socket\Port2\DrpChAxi\AWReady
      sGtwiz2DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port2\DrpChAxi\WData
      sGtwiz2DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port2\DrpChAxi\WStrb
      sGtwiz2DrpChAxiWValid : out std_logic; -- IO Socket\Port2\DrpChAxi\WValid
      sGtwiz2DrpChAxiWReady : in std_logic; -- IO Socket\Port2\DrpChAxi\WReady
      sGtwiz2DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port2\DrpChAxi\BResp
      sGtwiz2DrpChAxiBValid : in std_logic; -- IO Socket\Port2\DrpChAxi\BValid
      sGtwiz2DrpChAxiBReady : out std_logic; -- IO Socket\Port2\DrpChAxi\BReady
      sGtwiz2DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port2\DrpChAxi\ARAddr
      sGtwiz2DrpChAxiARValid : out std_logic; -- IO Socket\Port2\DrpChAxi\ARValid
      sGtwiz2DrpChAxiARReady : in std_logic; -- IO Socket\Port2\DrpChAxi\ARReady
      sGtwiz2DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port2\DrpChAxi\RData
      sGtwiz2DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port2\DrpChAxi\RResp
      sGtwiz2DrpChAxiRValid : in std_logic; -- IO Socket\Port2\DrpChAxi\RValid
      sGtwiz2DrpChAxiRReady : out std_logic; -- IO Socket\Port2\DrpChAxi\RReady
      UserClkPort3 : in std_logic; -- IO Socket\Port3 User Clock
      aPort3PmaInit : out std_logic; -- IO Socket\Port3\PmaInit
      aPort3ResetPb : out std_logic; -- IO Socket\Port3\ResetPb
      uPort3AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port3\Tx\TData0
      uPort3AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port3\Tx\TData1
      uPort3AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port3\Tx\TData2
      uPort3AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port3\Tx\TData3
      uPort3AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port3\Tx\TKeep
      uPort3AxiTxTLast : out std_logic; -- IO Socket\Port3\Tx\TLast
      uPort3AxiTxTValid : out std_logic; -- IO Socket\Port3\Tx\TValid
      uPort3AxiTxTReady : in std_logic; -- IO Socket\Port3\Tx\TReady
      uPort3AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port3\Rx\TData0
      uPort3AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port3\Rx\TData1
      uPort3AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port3\Rx\TData2
      uPort3AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port3\Rx\TData3
      uPort3AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port3\Rx\TKeep
      uPort3AxiRxTLast : in std_logic; -- IO Socket\Port3\Rx\TLast
      uPort3AxiRxTValid : in std_logic; -- IO Socket\Port3\Rx\TValid
      uPort3AxiNfcTValid : out std_logic; -- IO Socket\Port3\Nfc\TValid
      uPort3AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port3\Nfc\TData
      uPort3AxiNfcTReady : in std_logic; -- IO Socket\Port3\Nfc\TReady
      uPort3HardError : in std_logic; -- IO Socket\Port3\HardError
      uPort3SoftError : in std_logic; -- IO Socket\Port3\SoftError
      uPort3LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port3\LaneUp
      uPort3ChannelUp : in std_logic; -- IO Socket\Port3\ChannelUp
      uPort3SysResetOut : in std_logic; -- IO Socket\Port3\SysResetOut
      uPort3MmcmNotLockOut : in std_logic; -- IO Socket\Port3\MmcmNotLockOut
      uPort3CrcPassFail_n : in std_logic; -- IO Socket\Port3\CrcPassFail_n
      uPort3CrcValid : in std_logic; -- IO Socket\Port3\CrcValid
      iPort3LinkResetOut : in std_logic; -- IO Socket\Port3\LinkResetOut
      sGtwiz3CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port3\CtrlAxi\AWAddr
      sGtwiz3CtrlAxiAWValid : out std_logic; -- IO Socket\Port3\CtrlAxi\AWValid
      sGtwiz3CtrlAxiAWReady : in std_logic; -- IO Socket\Port3\CtrlAxi\AWReady
      sGtwiz3CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port3\CtrlAxi\WData
      sGtwiz3CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port3\CtrlAxi\WStrb
      sGtwiz3CtrlAxiWValid : out std_logic; -- IO Socket\Port3\CtrlAxi\WValid
      sGtwiz3CtrlAxiWReady : in std_logic; -- IO Socket\Port3\CtrlAxi\WReady
      sGtwiz3CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port3\CtrlAxi\BResp
      sGtwiz3CtrlAxiBValid : in std_logic; -- IO Socket\Port3\CtrlAxi\BValid
      sGtwiz3CtrlAxiBReady : out std_logic; -- IO Socket\Port3\CtrlAxi\BReady
      sGtwiz3CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port3\CtrlAxi\ARAddr
      sGtwiz3CtrlAxiARValid : out std_logic; -- IO Socket\Port3\CtrlAxi\ARValid
      sGtwiz3CtrlAxiARReady : in std_logic; -- IO Socket\Port3\CtrlAxi\ARReady
      sGtwiz3CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port3\CtrlAxi\RData
      sGtwiz3CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port3\CtrlAxi\RResp
      sGtwiz3CtrlAxiRValid : in std_logic; -- IO Socket\Port3\CtrlAxi\RValid
      sGtwiz3CtrlAxiRReady : out std_logic; -- IO Socket\Port3\CtrlAxi\RReady
      sGtwiz3DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port3\DrpChAxi\AWAddr
      sGtwiz3DrpChAxiAWValid : out std_logic; -- IO Socket\Port3\DrpChAxi\AWValid
      sGtwiz3DrpChAxiAWReady : in std_logic; -- IO Socket\Port3\DrpChAxi\AWReady
      sGtwiz3DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port3\DrpChAxi\WData
      sGtwiz3DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port3\DrpChAxi\WStrb
      sGtwiz3DrpChAxiWValid : out std_logic; -- IO Socket\Port3\DrpChAxi\WValid
      sGtwiz3DrpChAxiWReady : in std_logic; -- IO Socket\Port3\DrpChAxi\WReady
      sGtwiz3DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port3\DrpChAxi\BResp
      sGtwiz3DrpChAxiBValid : in std_logic; -- IO Socket\Port3\DrpChAxi\BValid
      sGtwiz3DrpChAxiBReady : out std_logic; -- IO Socket\Port3\DrpChAxi\BReady
      sGtwiz3DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port3\DrpChAxi\ARAddr
      sGtwiz3DrpChAxiARValid : out std_logic; -- IO Socket\Port3\DrpChAxi\ARValid
      sGtwiz3DrpChAxiARReady : in std_logic; -- IO Socket\Port3\DrpChAxi\ARReady
      sGtwiz3DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port3\DrpChAxi\RData
      sGtwiz3DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port3\DrpChAxi\RResp
      sGtwiz3DrpChAxiRValid : in std_logic; -- IO Socket\Port3\DrpChAxi\RValid
      sGtwiz3DrpChAxiRReady : out std_logic; -- IO Socket\Port3\DrpChAxi\RReady
      UserClkPort4 : in std_logic; -- IO Socket\Port4 User Clock
      aPort4PmaInit : out std_logic; -- IO Socket\Port4\PmaInit
      aPort4ResetPb : out std_logic; -- IO Socket\Port4\ResetPb
      uPort4AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port4\Tx\TData0
      uPort4AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port4\Tx\TData1
      uPort4AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port4\Tx\TData2
      uPort4AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port4\Tx\TData3
      uPort4AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port4\Tx\TKeep
      uPort4AxiTxTLast : out std_logic; -- IO Socket\Port4\Tx\TLast
      uPort4AxiTxTValid : out std_logic; -- IO Socket\Port4\Tx\TValid
      uPort4AxiTxTReady : in std_logic; -- IO Socket\Port4\Tx\TReady
      uPort4AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port4\Rx\TData0
      uPort4AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port4\Rx\TData1
      uPort4AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port4\Rx\TData2
      uPort4AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port4\Rx\TData3
      uPort4AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port4\Rx\TKeep
      uPort4AxiRxTLast : in std_logic; -- IO Socket\Port4\Rx\TLast
      uPort4AxiRxTValid : in std_logic; -- IO Socket\Port4\Rx\TValid
      uPort4AxiNfcTValid : out std_logic; -- IO Socket\Port4\Nfc\TValid
      uPort4AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port4\Nfc\TData
      uPort4AxiNfcTReady : in std_logic; -- IO Socket\Port4\Nfc\TReady
      uPort4HardError : in std_logic; -- IO Socket\Port4\HardError
      uPort4SoftError : in std_logic; -- IO Socket\Port4\SoftError
      uPort4LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port4\LaneUp
      uPort4ChannelUp : in std_logic; -- IO Socket\Port4\ChannelUp
      uPort4SysResetOut : in std_logic; -- IO Socket\Port4\SysResetOut
      uPort4MmcmNotLockOut : in std_logic; -- IO Socket\Port4\MmcmNotLockOut
      uPort4CrcPassFail_n : in std_logic; -- IO Socket\Port4\CrcPassFail_n
      uPort4CrcValid : in std_logic; -- IO Socket\Port4\CrcValid
      iPort4LinkResetOut : in std_logic; -- IO Socket\Port4\LinkResetOut
      sGtwiz4CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port4\CtrlAxi\AWAddr
      sGtwiz4CtrlAxiAWValid : out std_logic; -- IO Socket\Port4\CtrlAxi\AWValid
      sGtwiz4CtrlAxiAWReady : in std_logic; -- IO Socket\Port4\CtrlAxi\AWReady
      sGtwiz4CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port4\CtrlAxi\WData
      sGtwiz4CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port4\CtrlAxi\WStrb
      sGtwiz4CtrlAxiWValid : out std_logic; -- IO Socket\Port4\CtrlAxi\WValid
      sGtwiz4CtrlAxiWReady : in std_logic; -- IO Socket\Port4\CtrlAxi\WReady
      sGtwiz4CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port4\CtrlAxi\BResp
      sGtwiz4CtrlAxiBValid : in std_logic; -- IO Socket\Port4\CtrlAxi\BValid
      sGtwiz4CtrlAxiBReady : out std_logic; -- IO Socket\Port4\CtrlAxi\BReady
      sGtwiz4CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port4\CtrlAxi\ARAddr
      sGtwiz4CtrlAxiARValid : out std_logic; -- IO Socket\Port4\CtrlAxi\ARValid
      sGtwiz4CtrlAxiARReady : in std_logic; -- IO Socket\Port4\CtrlAxi\ARReady
      sGtwiz4CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port4\CtrlAxi\RData
      sGtwiz4CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port4\CtrlAxi\RResp
      sGtwiz4CtrlAxiRValid : in std_logic; -- IO Socket\Port4\CtrlAxi\RValid
      sGtwiz4CtrlAxiRReady : out std_logic; -- IO Socket\Port4\CtrlAxi\RReady
      sGtwiz4DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port4\DrpChAxi\AWAddr
      sGtwiz4DrpChAxiAWValid : out std_logic; -- IO Socket\Port4\DrpChAxi\AWValid
      sGtwiz4DrpChAxiAWReady : in std_logic; -- IO Socket\Port4\DrpChAxi\AWReady
      sGtwiz4DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port4\DrpChAxi\WData
      sGtwiz4DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port4\DrpChAxi\WStrb
      sGtwiz4DrpChAxiWValid : out std_logic; -- IO Socket\Port4\DrpChAxi\WValid
      sGtwiz4DrpChAxiWReady : in std_logic; -- IO Socket\Port4\DrpChAxi\WReady
      sGtwiz4DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port4\DrpChAxi\BResp
      sGtwiz4DrpChAxiBValid : in std_logic; -- IO Socket\Port4\DrpChAxi\BValid
      sGtwiz4DrpChAxiBReady : out std_logic; -- IO Socket\Port4\DrpChAxi\BReady
      sGtwiz4DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port4\DrpChAxi\ARAddr
      sGtwiz4DrpChAxiARValid : out std_logic; -- IO Socket\Port4\DrpChAxi\ARValid
      sGtwiz4DrpChAxiARReady : in std_logic; -- IO Socket\Port4\DrpChAxi\ARReady
      sGtwiz4DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port4\DrpChAxi\RData
      sGtwiz4DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port4\DrpChAxi\RResp
      sGtwiz4DrpChAxiRValid : in std_logic; -- IO Socket\Port4\DrpChAxi\RValid
      sGtwiz4DrpChAxiRReady : out std_logic; -- IO Socket\Port4\DrpChAxi\RReady
      UserClkPort5 : in std_logic; -- IO Socket\Port5 User Clock
      aPort5PmaInit : out std_logic; -- IO Socket\Port5\PmaInit
      aPort5ResetPb : out std_logic; -- IO Socket\Port5\ResetPb
      uPort5AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port5\Tx\TData0
      uPort5AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port5\Tx\TData1
      uPort5AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port5\Tx\TData2
      uPort5AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port5\Tx\TData3
      uPort5AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port5\Tx\TKeep
      uPort5AxiTxTLast : out std_logic; -- IO Socket\Port5\Tx\TLast
      uPort5AxiTxTValid : out std_logic; -- IO Socket\Port5\Tx\TValid
      uPort5AxiTxTReady : in std_logic; -- IO Socket\Port5\Tx\TReady
      uPort5AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port5\Rx\TData0
      uPort5AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port5\Rx\TData1
      uPort5AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port5\Rx\TData2
      uPort5AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port5\Rx\TData3
      uPort5AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port5\Rx\TKeep
      uPort5AxiRxTLast : in std_logic; -- IO Socket\Port5\Rx\TLast
      uPort5AxiRxTValid : in std_logic; -- IO Socket\Port5\Rx\TValid
      uPort5AxiNfcTValid : out std_logic; -- IO Socket\Port5\Nfc\TValid
      uPort5AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port5\Nfc\TData
      uPort5AxiNfcTReady : in std_logic; -- IO Socket\Port5\Nfc\TReady
      uPort5HardError : in std_logic; -- IO Socket\Port5\HardError
      uPort5SoftError : in std_logic; -- IO Socket\Port5\SoftError
      uPort5LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port5\LaneUp
      uPort5ChannelUp : in std_logic; -- IO Socket\Port5\ChannelUp
      uPort5SysResetOut : in std_logic; -- IO Socket\Port5\SysResetOut
      uPort5MmcmNotLockOut : in std_logic; -- IO Socket\Port5\MmcmNotLockOut
      uPort5CrcPassFail_n : in std_logic; -- IO Socket\Port5\CrcPassFail_n
      uPort5CrcValid : in std_logic; -- IO Socket\Port5\CrcValid
      iPort5LinkResetOut : in std_logic; -- IO Socket\Port5\LinkResetOut
      sGtwiz5CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port5\CtrlAxi\AWAddr
      sGtwiz5CtrlAxiAWValid : out std_logic; -- IO Socket\Port5\CtrlAxi\AWValid
      sGtwiz5CtrlAxiAWReady : in std_logic; -- IO Socket\Port5\CtrlAxi\AWReady
      sGtwiz5CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port5\CtrlAxi\WData
      sGtwiz5CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port5\CtrlAxi\WStrb
      sGtwiz5CtrlAxiWValid : out std_logic; -- IO Socket\Port5\CtrlAxi\WValid
      sGtwiz5CtrlAxiWReady : in std_logic; -- IO Socket\Port5\CtrlAxi\WReady
      sGtwiz5CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port5\CtrlAxi\BResp
      sGtwiz5CtrlAxiBValid : in std_logic; -- IO Socket\Port5\CtrlAxi\BValid
      sGtwiz5CtrlAxiBReady : out std_logic; -- IO Socket\Port5\CtrlAxi\BReady
      sGtwiz5CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port5\CtrlAxi\ARAddr
      sGtwiz5CtrlAxiARValid : out std_logic; -- IO Socket\Port5\CtrlAxi\ARValid
      sGtwiz5CtrlAxiARReady : in std_logic; -- IO Socket\Port5\CtrlAxi\ARReady
      sGtwiz5CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port5\CtrlAxi\RData
      sGtwiz5CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port5\CtrlAxi\RResp
      sGtwiz5CtrlAxiRValid : in std_logic; -- IO Socket\Port5\CtrlAxi\RValid
      sGtwiz5CtrlAxiRReady : out std_logic; -- IO Socket\Port5\CtrlAxi\RReady
      sGtwiz5DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port5\DrpChAxi\AWAddr
      sGtwiz5DrpChAxiAWValid : out std_logic; -- IO Socket\Port5\DrpChAxi\AWValid
      sGtwiz5DrpChAxiAWReady : in std_logic; -- IO Socket\Port5\DrpChAxi\AWReady
      sGtwiz5DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port5\DrpChAxi\WData
      sGtwiz5DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port5\DrpChAxi\WStrb
      sGtwiz5DrpChAxiWValid : out std_logic; -- IO Socket\Port5\DrpChAxi\WValid
      sGtwiz5DrpChAxiWReady : in std_logic; -- IO Socket\Port5\DrpChAxi\WReady
      sGtwiz5DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port5\DrpChAxi\BResp
      sGtwiz5DrpChAxiBValid : in std_logic; -- IO Socket\Port5\DrpChAxi\BValid
      sGtwiz5DrpChAxiBReady : out std_logic; -- IO Socket\Port5\DrpChAxi\BReady
      sGtwiz5DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port5\DrpChAxi\ARAddr
      sGtwiz5DrpChAxiARValid : out std_logic; -- IO Socket\Port5\DrpChAxi\ARValid
      sGtwiz5DrpChAxiARReady : in std_logic; -- IO Socket\Port5\DrpChAxi\ARReady
      sGtwiz5DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port5\DrpChAxi\RData
      sGtwiz5DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port5\DrpChAxi\RResp
      sGtwiz5DrpChAxiRValid : in std_logic; -- IO Socket\Port5\DrpChAxi\RValid
      sGtwiz5DrpChAxiRReady : out std_logic; -- IO Socket\Port5\DrpChAxi\RReady
      UserClkPort6 : in std_logic; -- IO Socket\Port6 User Clock
      aPort6PmaInit : out std_logic; -- IO Socket\Port6\PmaInit
      aPort6ResetPb : out std_logic; -- IO Socket\Port6\ResetPb
      uPort6AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port6\Tx\TData0
      uPort6AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port6\Tx\TData1
      uPort6AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port6\Tx\TData2
      uPort6AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port6\Tx\TData3
      uPort6AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port6\Tx\TKeep
      uPort6AxiTxTLast : out std_logic; -- IO Socket\Port6\Tx\TLast
      uPort6AxiTxTValid : out std_logic; -- IO Socket\Port6\Tx\TValid
      uPort6AxiTxTReady : in std_logic; -- IO Socket\Port6\Tx\TReady
      uPort6AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port6\Rx\TData0
      uPort6AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port6\Rx\TData1
      uPort6AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port6\Rx\TData2
      uPort6AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port6\Rx\TData3
      uPort6AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port6\Rx\TKeep
      uPort6AxiRxTLast : in std_logic; -- IO Socket\Port6\Rx\TLast
      uPort6AxiRxTValid : in std_logic; -- IO Socket\Port6\Rx\TValid
      uPort6AxiNfcTValid : out std_logic; -- IO Socket\Port6\Nfc\TValid
      uPort6AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port6\Nfc\TData
      uPort6AxiNfcTReady : in std_logic; -- IO Socket\Port6\Nfc\TReady
      uPort6HardError : in std_logic; -- IO Socket\Port6\HardError
      uPort6SoftError : in std_logic; -- IO Socket\Port6\SoftError
      uPort6LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port6\LaneUp
      uPort6ChannelUp : in std_logic; -- IO Socket\Port6\ChannelUp
      uPort6SysResetOut : in std_logic; -- IO Socket\Port6\SysResetOut
      uPort6MmcmNotLockOut : in std_logic; -- IO Socket\Port6\MmcmNotLockOut
      uPort6CrcPassFail_n : in std_logic; -- IO Socket\Port6\CrcPassFail_n
      uPort6CrcValid : in std_logic; -- IO Socket\Port6\CrcValid
      iPort6LinkResetOut : in std_logic; -- IO Socket\Port6\LinkResetOut
      sGtwiz6CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port6\CtrlAxi\AWAddr
      sGtwiz6CtrlAxiAWValid : out std_logic; -- IO Socket\Port6\CtrlAxi\AWValid
      sGtwiz6CtrlAxiAWReady : in std_logic; -- IO Socket\Port6\CtrlAxi\AWReady
      sGtwiz6CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port6\CtrlAxi\WData
      sGtwiz6CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port6\CtrlAxi\WStrb
      sGtwiz6CtrlAxiWValid : out std_logic; -- IO Socket\Port6\CtrlAxi\WValid
      sGtwiz6CtrlAxiWReady : in std_logic; -- IO Socket\Port6\CtrlAxi\WReady
      sGtwiz6CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port6\CtrlAxi\BResp
      sGtwiz6CtrlAxiBValid : in std_logic; -- IO Socket\Port6\CtrlAxi\BValid
      sGtwiz6CtrlAxiBReady : out std_logic; -- IO Socket\Port6\CtrlAxi\BReady
      sGtwiz6CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port6\CtrlAxi\ARAddr
      sGtwiz6CtrlAxiARValid : out std_logic; -- IO Socket\Port6\CtrlAxi\ARValid
      sGtwiz6CtrlAxiARReady : in std_logic; -- IO Socket\Port6\CtrlAxi\ARReady
      sGtwiz6CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port6\CtrlAxi\RData
      sGtwiz6CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port6\CtrlAxi\RResp
      sGtwiz6CtrlAxiRValid : in std_logic; -- IO Socket\Port6\CtrlAxi\RValid
      sGtwiz6CtrlAxiRReady : out std_logic; -- IO Socket\Port6\CtrlAxi\RReady
      sGtwiz6DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port6\DrpChAxi\AWAddr
      sGtwiz6DrpChAxiAWValid : out std_logic; -- IO Socket\Port6\DrpChAxi\AWValid
      sGtwiz6DrpChAxiAWReady : in std_logic; -- IO Socket\Port6\DrpChAxi\AWReady
      sGtwiz6DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port6\DrpChAxi\WData
      sGtwiz6DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port6\DrpChAxi\WStrb
      sGtwiz6DrpChAxiWValid : out std_logic; -- IO Socket\Port6\DrpChAxi\WValid
      sGtwiz6DrpChAxiWReady : in std_logic; -- IO Socket\Port6\DrpChAxi\WReady
      sGtwiz6DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port6\DrpChAxi\BResp
      sGtwiz6DrpChAxiBValid : in std_logic; -- IO Socket\Port6\DrpChAxi\BValid
      sGtwiz6DrpChAxiBReady : out std_logic; -- IO Socket\Port6\DrpChAxi\BReady
      sGtwiz6DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port6\DrpChAxi\ARAddr
      sGtwiz6DrpChAxiARValid : out std_logic; -- IO Socket\Port6\DrpChAxi\ARValid
      sGtwiz6DrpChAxiARReady : in std_logic; -- IO Socket\Port6\DrpChAxi\ARReady
      sGtwiz6DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port6\DrpChAxi\RData
      sGtwiz6DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port6\DrpChAxi\RResp
      sGtwiz6DrpChAxiRValid : in std_logic; -- IO Socket\Port6\DrpChAxi\RValid
      sGtwiz6DrpChAxiRReady : out std_logic; -- IO Socket\Port6\DrpChAxi\RReady
      UserClkPort7 : in std_logic; -- IO Socket\Port7 User Clock
      aPort7PmaInit : out std_logic; -- IO Socket\Port7\PmaInit
      aPort7ResetPb : out std_logic; -- IO Socket\Port7\ResetPb
      uPort7AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port7\Tx\TData0
      uPort7AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port7\Tx\TData1
      uPort7AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port7\Tx\TData2
      uPort7AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port7\Tx\TData3
      uPort7AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port7\Tx\TKeep
      uPort7AxiTxTLast : out std_logic; -- IO Socket\Port7\Tx\TLast
      uPort7AxiTxTValid : out std_logic; -- IO Socket\Port7\Tx\TValid
      uPort7AxiTxTReady : in std_logic; -- IO Socket\Port7\Tx\TReady
      uPort7AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port7\Rx\TData0
      uPort7AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port7\Rx\TData1
      uPort7AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port7\Rx\TData2
      uPort7AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port7\Rx\TData3
      uPort7AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port7\Rx\TKeep
      uPort7AxiRxTLast : in std_logic; -- IO Socket\Port7\Rx\TLast
      uPort7AxiRxTValid : in std_logic; -- IO Socket\Port7\Rx\TValid
      uPort7AxiNfcTValid : out std_logic; -- IO Socket\Port7\Nfc\TValid
      uPort7AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port7\Nfc\TData
      uPort7AxiNfcTReady : in std_logic; -- IO Socket\Port7\Nfc\TReady
      uPort7HardError : in std_logic; -- IO Socket\Port7\HardError
      uPort7SoftError : in std_logic; -- IO Socket\Port7\SoftError
      uPort7LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port7\LaneUp
      uPort7ChannelUp : in std_logic; -- IO Socket\Port7\ChannelUp
      uPort7SysResetOut : in std_logic; -- IO Socket\Port7\SysResetOut
      uPort7MmcmNotLockOut : in std_logic; -- IO Socket\Port7\MmcmNotLockOut
      uPort7CrcPassFail_n : in std_logic; -- IO Socket\Port7\CrcPassFail_n
      uPort7CrcValid : in std_logic; -- IO Socket\Port7\CrcValid
      iPort7LinkResetOut : in std_logic; -- IO Socket\Port7\LinkResetOut
      sGtwiz7CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port7\CtrlAxi\AWAddr
      sGtwiz7CtrlAxiAWValid : out std_logic; -- IO Socket\Port7\CtrlAxi\AWValid
      sGtwiz7CtrlAxiAWReady : in std_logic; -- IO Socket\Port7\CtrlAxi\AWReady
      sGtwiz7CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port7\CtrlAxi\WData
      sGtwiz7CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port7\CtrlAxi\WStrb
      sGtwiz7CtrlAxiWValid : out std_logic; -- IO Socket\Port7\CtrlAxi\WValid
      sGtwiz7CtrlAxiWReady : in std_logic; -- IO Socket\Port7\CtrlAxi\WReady
      sGtwiz7CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port7\CtrlAxi\BResp
      sGtwiz7CtrlAxiBValid : in std_logic; -- IO Socket\Port7\CtrlAxi\BValid
      sGtwiz7CtrlAxiBReady : out std_logic; -- IO Socket\Port7\CtrlAxi\BReady
      sGtwiz7CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port7\CtrlAxi\ARAddr
      sGtwiz7CtrlAxiARValid : out std_logic; -- IO Socket\Port7\CtrlAxi\ARValid
      sGtwiz7CtrlAxiARReady : in std_logic; -- IO Socket\Port7\CtrlAxi\ARReady
      sGtwiz7CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port7\CtrlAxi\RData
      sGtwiz7CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port7\CtrlAxi\RResp
      sGtwiz7CtrlAxiRValid : in std_logic; -- IO Socket\Port7\CtrlAxi\RValid
      sGtwiz7CtrlAxiRReady : out std_logic; -- IO Socket\Port7\CtrlAxi\RReady
      sGtwiz7DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port7\DrpChAxi\AWAddr
      sGtwiz7DrpChAxiAWValid : out std_logic; -- IO Socket\Port7\DrpChAxi\AWValid
      sGtwiz7DrpChAxiAWReady : in std_logic; -- IO Socket\Port7\DrpChAxi\AWReady
      sGtwiz7DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port7\DrpChAxi\WData
      sGtwiz7DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port7\DrpChAxi\WStrb
      sGtwiz7DrpChAxiWValid : out std_logic; -- IO Socket\Port7\DrpChAxi\WValid
      sGtwiz7DrpChAxiWReady : in std_logic; -- IO Socket\Port7\DrpChAxi\WReady
      sGtwiz7DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port7\DrpChAxi\BResp
      sGtwiz7DrpChAxiBValid : in std_logic; -- IO Socket\Port7\DrpChAxi\BValid
      sGtwiz7DrpChAxiBReady : out std_logic; -- IO Socket\Port7\DrpChAxi\BReady
      sGtwiz7DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port7\DrpChAxi\ARAddr
      sGtwiz7DrpChAxiARValid : out std_logic; -- IO Socket\Port7\DrpChAxi\ARValid
      sGtwiz7DrpChAxiARReady : in std_logic; -- IO Socket\Port7\DrpChAxi\ARReady
      sGtwiz7DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port7\DrpChAxi\RData
      sGtwiz7DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port7\DrpChAxi\RResp
      sGtwiz7DrpChAxiRValid : in std_logic; -- IO Socket\Port7\DrpChAxi\RValid
      sGtwiz7DrpChAxiRReady : out std_logic; -- IO Socket\Port7\DrpChAxi\RReady
      UserClkPort8 : in std_logic; -- IO Socket\Port8 User Clock
      aPort8PmaInit : out std_logic; -- IO Socket\Port8\PmaInit
      aPort8ResetPb : out std_logic; -- IO Socket\Port8\ResetPb
      uPort8AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port8\Tx\TData0
      uPort8AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port8\Tx\TData1
      uPort8AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port8\Tx\TData2
      uPort8AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port8\Tx\TData3
      uPort8AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port8\Tx\TKeep
      uPort8AxiTxTLast : out std_logic; -- IO Socket\Port8\Tx\TLast
      uPort8AxiTxTValid : out std_logic; -- IO Socket\Port8\Tx\TValid
      uPort8AxiTxTReady : in std_logic; -- IO Socket\Port8\Tx\TReady
      uPort8AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port8\Rx\TData0
      uPort8AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port8\Rx\TData1
      uPort8AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port8\Rx\TData2
      uPort8AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port8\Rx\TData3
      uPort8AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port8\Rx\TKeep
      uPort8AxiRxTLast : in std_logic; -- IO Socket\Port8\Rx\TLast
      uPort8AxiRxTValid : in std_logic; -- IO Socket\Port8\Rx\TValid
      uPort8AxiNfcTValid : out std_logic; -- IO Socket\Port8\Nfc\TValid
      uPort8AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port8\Nfc\TData
      uPort8AxiNfcTReady : in std_logic; -- IO Socket\Port8\Nfc\TReady
      uPort8HardError : in std_logic; -- IO Socket\Port8\HardError
      uPort8SoftError : in std_logic; -- IO Socket\Port8\SoftError
      uPort8LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port8\LaneUp
      uPort8ChannelUp : in std_logic; -- IO Socket\Port8\ChannelUp
      uPort8SysResetOut : in std_logic; -- IO Socket\Port8\SysResetOut
      uPort8MmcmNotLockOut : in std_logic; -- IO Socket\Port8\MmcmNotLockOut
      uPort8CrcPassFail_n : in std_logic; -- IO Socket\Port8\CrcPassFail_n
      uPort8CrcValid : in std_logic; -- IO Socket\Port8\CrcValid
      iPort8LinkResetOut : in std_logic; -- IO Socket\Port8\LinkResetOut
      sGtwiz8CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port8\CtrlAxi\AWAddr
      sGtwiz8CtrlAxiAWValid : out std_logic; -- IO Socket\Port8\CtrlAxi\AWValid
      sGtwiz8CtrlAxiAWReady : in std_logic; -- IO Socket\Port8\CtrlAxi\AWReady
      sGtwiz8CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port8\CtrlAxi\WData
      sGtwiz8CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port8\CtrlAxi\WStrb
      sGtwiz8CtrlAxiWValid : out std_logic; -- IO Socket\Port8\CtrlAxi\WValid
      sGtwiz8CtrlAxiWReady : in std_logic; -- IO Socket\Port8\CtrlAxi\WReady
      sGtwiz8CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port8\CtrlAxi\BResp
      sGtwiz8CtrlAxiBValid : in std_logic; -- IO Socket\Port8\CtrlAxi\BValid
      sGtwiz8CtrlAxiBReady : out std_logic; -- IO Socket\Port8\CtrlAxi\BReady
      sGtwiz8CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port8\CtrlAxi\ARAddr
      sGtwiz8CtrlAxiARValid : out std_logic; -- IO Socket\Port8\CtrlAxi\ARValid
      sGtwiz8CtrlAxiARReady : in std_logic; -- IO Socket\Port8\CtrlAxi\ARReady
      sGtwiz8CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port8\CtrlAxi\RData
      sGtwiz8CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port8\CtrlAxi\RResp
      sGtwiz8CtrlAxiRValid : in std_logic; -- IO Socket\Port8\CtrlAxi\RValid
      sGtwiz8CtrlAxiRReady : out std_logic; -- IO Socket\Port8\CtrlAxi\RReady
      sGtwiz8DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port8\DrpChAxi\AWAddr
      sGtwiz8DrpChAxiAWValid : out std_logic; -- IO Socket\Port8\DrpChAxi\AWValid
      sGtwiz8DrpChAxiAWReady : in std_logic; -- IO Socket\Port8\DrpChAxi\AWReady
      sGtwiz8DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port8\DrpChAxi\WData
      sGtwiz8DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port8\DrpChAxi\WStrb
      sGtwiz8DrpChAxiWValid : out std_logic; -- IO Socket\Port8\DrpChAxi\WValid
      sGtwiz8DrpChAxiWReady : in std_logic; -- IO Socket\Port8\DrpChAxi\WReady
      sGtwiz8DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port8\DrpChAxi\BResp
      sGtwiz8DrpChAxiBValid : in std_logic; -- IO Socket\Port8\DrpChAxi\BValid
      sGtwiz8DrpChAxiBReady : out std_logic; -- IO Socket\Port8\DrpChAxi\BReady
      sGtwiz8DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port8\DrpChAxi\ARAddr
      sGtwiz8DrpChAxiARValid : out std_logic; -- IO Socket\Port8\DrpChAxi\ARValid
      sGtwiz8DrpChAxiARReady : in std_logic; -- IO Socket\Port8\DrpChAxi\ARReady
      sGtwiz8DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port8\DrpChAxi\RData
      sGtwiz8DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port8\DrpChAxi\RResp
      sGtwiz8DrpChAxiRValid : in std_logic; -- IO Socket\Port8\DrpChAxi\RValid
      sGtwiz8DrpChAxiRReady : out std_logic; -- IO Socket\Port8\DrpChAxi\RReady
      UserClkPort9 : in std_logic; -- IO Socket\Port9 User Clock
      aPort9PmaInit : out std_logic; -- IO Socket\Port9\PmaInit
      aPort9ResetPb : out std_logic; -- IO Socket\Port9\ResetPb
      uPort9AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port9\Tx\TData0
      uPort9AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port9\Tx\TData1
      uPort9AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port9\Tx\TData2
      uPort9AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port9\Tx\TData3
      uPort9AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port9\Tx\TKeep
      uPort9AxiTxTLast : out std_logic; -- IO Socket\Port9\Tx\TLast
      uPort9AxiTxTValid : out std_logic; -- IO Socket\Port9\Tx\TValid
      uPort9AxiTxTReady : in std_logic; -- IO Socket\Port9\Tx\TReady
      uPort9AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port9\Rx\TData0
      uPort9AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port9\Rx\TData1
      uPort9AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port9\Rx\TData2
      uPort9AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port9\Rx\TData3
      uPort9AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port9\Rx\TKeep
      uPort9AxiRxTLast : in std_logic; -- IO Socket\Port9\Rx\TLast
      uPort9AxiRxTValid : in std_logic; -- IO Socket\Port9\Rx\TValid
      uPort9AxiNfcTValid : out std_logic; -- IO Socket\Port9\Nfc\TValid
      uPort9AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port9\Nfc\TData
      uPort9AxiNfcTReady : in std_logic; -- IO Socket\Port9\Nfc\TReady
      uPort9HardError : in std_logic; -- IO Socket\Port9\HardError
      uPort9SoftError : in std_logic; -- IO Socket\Port9\SoftError
      uPort9LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port9\LaneUp
      uPort9ChannelUp : in std_logic; -- IO Socket\Port9\ChannelUp
      uPort9SysResetOut : in std_logic; -- IO Socket\Port9\SysResetOut
      uPort9MmcmNotLockOut : in std_logic; -- IO Socket\Port9\MmcmNotLockOut
      uPort9CrcPassFail_n : in std_logic; -- IO Socket\Port9\CrcPassFail_n
      uPort9CrcValid : in std_logic; -- IO Socket\Port9\CrcValid
      iPort9LinkResetOut : in std_logic; -- IO Socket\Port9\LinkResetOut
      sGtwiz9CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port9\CtrlAxi\AWAddr
      sGtwiz9CtrlAxiAWValid : out std_logic; -- IO Socket\Port9\CtrlAxi\AWValid
      sGtwiz9CtrlAxiAWReady : in std_logic; -- IO Socket\Port9\CtrlAxi\AWReady
      sGtwiz9CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port9\CtrlAxi\WData
      sGtwiz9CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port9\CtrlAxi\WStrb
      sGtwiz9CtrlAxiWValid : out std_logic; -- IO Socket\Port9\CtrlAxi\WValid
      sGtwiz9CtrlAxiWReady : in std_logic; -- IO Socket\Port9\CtrlAxi\WReady
      sGtwiz9CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port9\CtrlAxi\BResp
      sGtwiz9CtrlAxiBValid : in std_logic; -- IO Socket\Port9\CtrlAxi\BValid
      sGtwiz9CtrlAxiBReady : out std_logic; -- IO Socket\Port9\CtrlAxi\BReady
      sGtwiz9CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port9\CtrlAxi\ARAddr
      sGtwiz9CtrlAxiARValid : out std_logic; -- IO Socket\Port9\CtrlAxi\ARValid
      sGtwiz9CtrlAxiARReady : in std_logic; -- IO Socket\Port9\CtrlAxi\ARReady
      sGtwiz9CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port9\CtrlAxi\RData
      sGtwiz9CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port9\CtrlAxi\RResp
      sGtwiz9CtrlAxiRValid : in std_logic; -- IO Socket\Port9\CtrlAxi\RValid
      sGtwiz9CtrlAxiRReady : out std_logic; -- IO Socket\Port9\CtrlAxi\RReady
      sGtwiz9DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port9\DrpChAxi\AWAddr
      sGtwiz9DrpChAxiAWValid : out std_logic; -- IO Socket\Port9\DrpChAxi\AWValid
      sGtwiz9DrpChAxiAWReady : in std_logic; -- IO Socket\Port9\DrpChAxi\AWReady
      sGtwiz9DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port9\DrpChAxi\WData
      sGtwiz9DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port9\DrpChAxi\WStrb
      sGtwiz9DrpChAxiWValid : out std_logic; -- IO Socket\Port9\DrpChAxi\WValid
      sGtwiz9DrpChAxiWReady : in std_logic; -- IO Socket\Port9\DrpChAxi\WReady
      sGtwiz9DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port9\DrpChAxi\BResp
      sGtwiz9DrpChAxiBValid : in std_logic; -- IO Socket\Port9\DrpChAxi\BValid
      sGtwiz9DrpChAxiBReady : out std_logic; -- IO Socket\Port9\DrpChAxi\BReady
      sGtwiz9DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port9\DrpChAxi\ARAddr
      sGtwiz9DrpChAxiARValid : out std_logic; -- IO Socket\Port9\DrpChAxi\ARValid
      sGtwiz9DrpChAxiARReady : in std_logic; -- IO Socket\Port9\DrpChAxi\ARReady
      sGtwiz9DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port9\DrpChAxi\RData
      sGtwiz9DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port9\DrpChAxi\RResp
      sGtwiz9DrpChAxiRValid : in std_logic; -- IO Socket\Port9\DrpChAxi\RValid
      sGtwiz9DrpChAxiRReady : out std_logic; -- IO Socket\Port9\DrpChAxi\RReady
      UserClkPort10 : in std_logic; -- IO Socket\Port10 User Clock
      aPort10PmaInit : out std_logic; -- IO Socket\Port10\PmaInit
      aPort10ResetPb : out std_logic; -- IO Socket\Port10\ResetPb
      uPort10AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port10\Tx\TData0
      uPort10AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port10\Tx\TData1
      uPort10AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port10\Tx\TData2
      uPort10AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port10\Tx\TData3
      uPort10AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port10\Tx\TKeep
      uPort10AxiTxTLast : out std_logic; -- IO Socket\Port10\Tx\TLast
      uPort10AxiTxTValid : out std_logic; -- IO Socket\Port10\Tx\TValid
      uPort10AxiTxTReady : in std_logic; -- IO Socket\Port10\Tx\TReady
      uPort10AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port10\Rx\TData0
      uPort10AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port10\Rx\TData1
      uPort10AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port10\Rx\TData2
      uPort10AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port10\Rx\TData3
      uPort10AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port10\Rx\TKeep
      uPort10AxiRxTLast : in std_logic; -- IO Socket\Port10\Rx\TLast
      uPort10AxiRxTValid : in std_logic; -- IO Socket\Port10\Rx\TValid
      uPort10AxiNfcTValid : out std_logic; -- IO Socket\Port10\Nfc\TValid
      uPort10AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port10\Nfc\TData
      uPort10AxiNfcTReady : in std_logic; -- IO Socket\Port10\Nfc\TReady
      uPort10HardError : in std_logic; -- IO Socket\Port10\HardError
      uPort10SoftError : in std_logic; -- IO Socket\Port10\SoftError
      uPort10LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port10\LaneUp
      uPort10ChannelUp : in std_logic; -- IO Socket\Port10\ChannelUp
      uPort10SysResetOut : in std_logic; -- IO Socket\Port10\SysResetOut
      uPort10MmcmNotLockOut : in std_logic; -- IO Socket\Port10\MmcmNotLockOut
      uPort10CrcPassFail_n : in std_logic; -- IO Socket\Port10\CrcPassFail_n
      uPort10CrcValid : in std_logic; -- IO Socket\Port10\CrcValid
      iPort10LinkResetOut : in std_logic; -- IO Socket\Port10\LinkResetOut
      sGtwiz10CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port10\CtrlAxi\AWAddr
      sGtwiz10CtrlAxiAWValid : out std_logic; -- IO Socket\Port10\CtrlAxi\AWValid
      sGtwiz10CtrlAxiAWReady : in std_logic; -- IO Socket\Port10\CtrlAxi\AWReady
      sGtwiz10CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port10\CtrlAxi\WData
      sGtwiz10CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port10\CtrlAxi\WStrb
      sGtwiz10CtrlAxiWValid : out std_logic; -- IO Socket\Port10\CtrlAxi\WValid
      sGtwiz10CtrlAxiWReady : in std_logic; -- IO Socket\Port10\CtrlAxi\WReady
      sGtwiz10CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port10\CtrlAxi\BResp
      sGtwiz10CtrlAxiBValid : in std_logic; -- IO Socket\Port10\CtrlAxi\BValid
      sGtwiz10CtrlAxiBReady : out std_logic; -- IO Socket\Port10\CtrlAxi\BReady
      sGtwiz10CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port10\CtrlAxi\ARAddr
      sGtwiz10CtrlAxiARValid : out std_logic; -- IO Socket\Port10\CtrlAxi\ARValid
      sGtwiz10CtrlAxiARReady : in std_logic; -- IO Socket\Port10\CtrlAxi\ARReady
      sGtwiz10CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port10\CtrlAxi\RData
      sGtwiz10CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port10\CtrlAxi\RResp
      sGtwiz10CtrlAxiRValid : in std_logic; -- IO Socket\Port10\CtrlAxi\RValid
      sGtwiz10CtrlAxiRReady : out std_logic; -- IO Socket\Port10\CtrlAxi\RReady
      sGtwiz10DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port10\DrpChAxi\AWAddr
      sGtwiz10DrpChAxiAWValid : out std_logic; -- IO Socket\Port10\DrpChAxi\AWValid
      sGtwiz10DrpChAxiAWReady : in std_logic; -- IO Socket\Port10\DrpChAxi\AWReady
      sGtwiz10DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port10\DrpChAxi\WData
      sGtwiz10DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port10\DrpChAxi\WStrb
      sGtwiz10DrpChAxiWValid : out std_logic; -- IO Socket\Port10\DrpChAxi\WValid
      sGtwiz10DrpChAxiWReady : in std_logic; -- IO Socket\Port10\DrpChAxi\WReady
      sGtwiz10DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port10\DrpChAxi\BResp
      sGtwiz10DrpChAxiBValid : in std_logic; -- IO Socket\Port10\DrpChAxi\BValid
      sGtwiz10DrpChAxiBReady : out std_logic; -- IO Socket\Port10\DrpChAxi\BReady
      sGtwiz10DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port10\DrpChAxi\ARAddr
      sGtwiz10DrpChAxiARValid : out std_logic; -- IO Socket\Port10\DrpChAxi\ARValid
      sGtwiz10DrpChAxiARReady : in std_logic; -- IO Socket\Port10\DrpChAxi\ARReady
      sGtwiz10DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port10\DrpChAxi\RData
      sGtwiz10DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port10\DrpChAxi\RResp
      sGtwiz10DrpChAxiRValid : in std_logic; -- IO Socket\Port10\DrpChAxi\RValid
      sGtwiz10DrpChAxiRReady : out std_logic; -- IO Socket\Port10\DrpChAxi\RReady
      UserClkPort11 : in std_logic; -- IO Socket\Port11 User Clock
      aPort11PmaInit : out std_logic; -- IO Socket\Port11\PmaInit
      aPort11ResetPb : out std_logic; -- IO Socket\Port11\ResetPb
      uPort11AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port11\Tx\TData0
      uPort11AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port11\Tx\TData1
      uPort11AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port11\Tx\TData2
      uPort11AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port11\Tx\TData3
      uPort11AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port11\Tx\TKeep
      uPort11AxiTxTLast : out std_logic; -- IO Socket\Port11\Tx\TLast
      uPort11AxiTxTValid : out std_logic; -- IO Socket\Port11\Tx\TValid
      uPort11AxiTxTReady : in std_logic; -- IO Socket\Port11\Tx\TReady
      uPort11AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port11\Rx\TData0
      uPort11AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port11\Rx\TData1
      uPort11AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port11\Rx\TData2
      uPort11AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port11\Rx\TData3
      uPort11AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port11\Rx\TKeep
      uPort11AxiRxTLast : in std_logic; -- IO Socket\Port11\Rx\TLast
      uPort11AxiRxTValid : in std_logic; -- IO Socket\Port11\Rx\TValid
      uPort11AxiNfcTValid : out std_logic; -- IO Socket\Port11\Nfc\TValid
      uPort11AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port11\Nfc\TData
      uPort11AxiNfcTReady : in std_logic; -- IO Socket\Port11\Nfc\TReady
      uPort11HardError : in std_logic; -- IO Socket\Port11\HardError
      uPort11SoftError : in std_logic; -- IO Socket\Port11\SoftError
      uPort11LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port11\LaneUp
      uPort11ChannelUp : in std_logic; -- IO Socket\Port11\ChannelUp
      uPort11SysResetOut : in std_logic; -- IO Socket\Port11\SysResetOut
      uPort11MmcmNotLockOut : in std_logic; -- IO Socket\Port11\MmcmNotLockOut
      uPort11CrcPassFail_n : in std_logic; -- IO Socket\Port11\CrcPassFail_n
      uPort11CrcValid : in std_logic; -- IO Socket\Port11\CrcValid
      iPort11LinkResetOut : in std_logic; -- IO Socket\Port11\LinkResetOut
      sGtwiz11CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port11\CtrlAxi\AWAddr
      sGtwiz11CtrlAxiAWValid : out std_logic; -- IO Socket\Port11\CtrlAxi\AWValid
      sGtwiz11CtrlAxiAWReady : in std_logic; -- IO Socket\Port11\CtrlAxi\AWReady
      sGtwiz11CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port11\CtrlAxi\WData
      sGtwiz11CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port11\CtrlAxi\WStrb
      sGtwiz11CtrlAxiWValid : out std_logic; -- IO Socket\Port11\CtrlAxi\WValid
      sGtwiz11CtrlAxiWReady : in std_logic; -- IO Socket\Port11\CtrlAxi\WReady
      sGtwiz11CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port11\CtrlAxi\BResp
      sGtwiz11CtrlAxiBValid : in std_logic; -- IO Socket\Port11\CtrlAxi\BValid
      sGtwiz11CtrlAxiBReady : out std_logic; -- IO Socket\Port11\CtrlAxi\BReady
      sGtwiz11CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port11\CtrlAxi\ARAddr
      sGtwiz11CtrlAxiARValid : out std_logic; -- IO Socket\Port11\CtrlAxi\ARValid
      sGtwiz11CtrlAxiARReady : in std_logic; -- IO Socket\Port11\CtrlAxi\ARReady
      sGtwiz11CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port11\CtrlAxi\RData
      sGtwiz11CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port11\CtrlAxi\RResp
      sGtwiz11CtrlAxiRValid : in std_logic; -- IO Socket\Port11\CtrlAxi\RValid
      sGtwiz11CtrlAxiRReady : out std_logic; -- IO Socket\Port11\CtrlAxi\RReady
      sGtwiz11DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port11\DrpChAxi\AWAddr
      sGtwiz11DrpChAxiAWValid : out std_logic; -- IO Socket\Port11\DrpChAxi\AWValid
      sGtwiz11DrpChAxiAWReady : in std_logic; -- IO Socket\Port11\DrpChAxi\AWReady
      sGtwiz11DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port11\DrpChAxi\WData
      sGtwiz11DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port11\DrpChAxi\WStrb
      sGtwiz11DrpChAxiWValid : out std_logic; -- IO Socket\Port11\DrpChAxi\WValid
      sGtwiz11DrpChAxiWReady : in std_logic; -- IO Socket\Port11\DrpChAxi\WReady
      sGtwiz11DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port11\DrpChAxi\BResp
      sGtwiz11DrpChAxiBValid : in std_logic; -- IO Socket\Port11\DrpChAxi\BValid
      sGtwiz11DrpChAxiBReady : out std_logic; -- IO Socket\Port11\DrpChAxi\BReady
      sGtwiz11DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port11\DrpChAxi\ARAddr
      sGtwiz11DrpChAxiARValid : out std_logic; -- IO Socket\Port11\DrpChAxi\ARValid
      sGtwiz11DrpChAxiARReady : in std_logic; -- IO Socket\Port11\DrpChAxi\ARReady
      sGtwiz11DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port11\DrpChAxi\RData
      sGtwiz11DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port11\DrpChAxi\RResp
      sGtwiz11DrpChAxiRValid : in std_logic; -- IO Socket\Port11\DrpChAxi\RValid
      sGtwiz11DrpChAxiRReady : out std_logic; -- IO Socket\Port11\DrpChAxi\RReady

      -----------------------------------
      -- Communication interface ports
      -----------------------------------
      -- Reset ports
      aBusReset : in boolean;

      -- Register Access/ PIO Ports
      bRegPortIn      : in  RegPortIn_t;
      bRegPortOut     : out RegPortOut_t;
      bRegPortTimeout : in  boolean;

      -- DMA Stream Ports
      dInputStreamInterfaceToFifo    : in  InputStreamInterfaceToFifoArray_t (Larger(kNumberOfDmaChannels, 1)-1 downto 0);
      dInputStreamInterfaceFromFifo  : out InputStreamInterfaceFromFifoArray_t (Larger(kNumberOfDmaChannels, 1)-1 downto 0);
      dOutputStreamInterfaceToFifo   : in  OutputStreamInterfaceToFifoArray_t (Larger(kNumberOfDmaChannels, 1)-1 downto 0);
      dOutputStreamInterfaceFromFifo : out OutputStreamInterfaceFromFifoArray_t (Larger(kNumberOfDmaChannels, 1)-1 downto 0);

      -- IRQ Ports
      bIrqToInterface : out IrqToInterfaceArray_t(Larger(kNumberOfIrqs, 1)-1 downto 0);

      -- MasterPort Ports
      dNiFpgaMasterWriteRequestFromMaster : out NiFpgaMasterWriteRequestFromMasterArray_t (Larger(kNumberOfMasterPorts, 1)-1 downto 0);
      dNiFpgaMasterWriteRequestToMaster   : in  NiFpgaMasterWriteRequestToMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1 downto 0);
      dNiFpgaMasterWriteDataFromMaster    : out NiFpgaMasterWriteDataFromMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1 downto 0);
      dNiFpgaMasterWriteDataToMaster      : in  NiFpgaMasterWriteDataToMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1 downto 0);
      dNiFpgaMasterWriteStatusToMaster    : in  NiFpgaMasterWriteStatusToMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1 downto 0);

      dNiFpgaMasterReadRequestFromMaster : out NiFpgaMasterReadRequestFromMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1 downto 0);
      dNiFpgaMasterReadRequestToMaster   : in  NiFpgaMasterReadRequestToMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1 downto 0);
      dNiFpgaMasterReadDataToMaster      : in  NiFpgaMasterReadDataToMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1 downto 0);

      -----------------------------------
      -- Clocks from TopLevel
      -----------------------------------
      DmaClk            : in std_logic;
      BusClk            : in std_logic;
      ReliableClkIn     : in std_logic;
      PllClk80          : in std_logic;
      DlyRefClk         : in std_logic;
      PxieClk100        : in std_logic;
      DramClkLvFpga     : in std_logic;
      Dram0ClkSocket    : in std_logic;
      Dram1ClkSocket    : in std_logic;
      Dram0ClkUser      : in std_logic;
      Dram1ClkUser      : in std_logic;
      dHmbDmaClkSocket  : in std_logic;
      dLlbDmaClkSocket  : in std_logic;


      -----------------------------------
      -- Handshaking signals for derived
      -- clocks on external clocks
      -----------------------------------


      -----------------------------------
      -- IO Node ports
      -----------------------------------
      pIntSync100            : in    std_logic;
      aIntClk10              : in    std_logic;

      -----------------------------------
      -- Target Method and Properties ports
      -----------------------------------
      bdIFifoRdData               : out std_logic_vector(63 downto 0);
      bdIFifoRdDataValid          : out std_logic;
      bdIFifoRdReadyForInput      : in  std_logic;
      bdIFifoRdIsError            : out std_logic;
      bdIFifoWrData               : in  std_logic_vector(63 downto 0);
      bdIFifoWrDataValid          : in  std_logic;
      bdIFifoWrReadyForOutput     : out std_logic;
      bdAxiStreamRdFromClipTData  : in  std_logic_vector(31 downto 0);
      bdAxiStreamRdFromClipTLast  : in  std_logic;
      bdAxiStreamRdFromClipTValid : in  std_logic;
      bdAxiStreamRdToClipTReady   : out std_logic;
      bdAxiStreamWrToClipTData    : out std_logic_vector(31 downto 0);
      bdAxiStreamWrToClipTLast    : out std_logic;
      bdAxiStreamWrToClipTValid   : out std_logic;
      bdAxiStreamWrFromClipTReady : in  std_logic;

      -----------------------------------
      -- Pass through LabVIEW FPGA ports
      -----------------------------------

      ----------------------------------------
      -- Trigger Routing Socketed CLIP
      ----------------------------------------
      PxieClk100Trigger  : in  std_logic;
      pIntSync100Trigger : in  std_logic;
      dDevClkEn          : in  std_logic;
      aIntClk10Trigger   : in  std_logic;
      --ID Signals from Routing CLIP
      bRoutingClipPresent      : out std_logic;
      bRoutingClipNiCompatible : out std_logic;

      BusClkTrigger : in std_logic;
      abBusResetTrigger : in std_logic;

      -- From PkgBaRegPort
      -- RegPortIn_t Size = Address 28 Data 64 WrStrobes 8 RdStrobes 8 = 108
      -- RegPortOut_t Size = Data 64 + Ack 1 = 65
      bTriggerRoutingBaRegPortInAddress  : in std_logic_vector(27 downto 0);
      bTriggerRoutingBaRegPortInData     : in std_logic_vector(63 downto 0);
      bTriggerRoutingBaRegPortInWtStrobe : in std_logic_vector(7 downto 0);
      bTriggerRoutingBaRegPortInRdStrobe : in std_logic_vector(7 downto 0);

      bTriggerRoutingBaRegPortOutData : out std_logic_vector(63 downto 0);
      bTriggerRoutingBaRegPortOutAck  : out std_logic;

      aPxiTrigDataIn         : in  std_logic_vector(7 downto 0);
      aPxiTrigDataOut        : out std_logic_vector(7 downto 0);
      aPxiTrigDataTri        : out std_logic_vector(7 downto 0);
      aPxiStarData           : in    std_logic;
      aPxieDstarB            : in    std_logic;
      aPxieDstarC            : out   std_logic;

      -----------------------------------
      -- CLIP Socket ports
      -----------------------------------

      -- AxiClk is the same as BusCLk is the same as PllClk80
      AxiClk : in std_logic;

      xDiagramAxiStreamFromClipTData  : out std_logic_vector(31 downto 0);
      xDiagramAxiStreamFromClipTLast  : out std_logic;
      xDiagramAxiStreamFromClipTReady : out std_logic;
      xDiagramAxiStreamFromClipTValid : out std_logic;
      xDiagramAxiStreamToClipTData    : in  std_logic_vector(31 downto 0);
      xDiagramAxiStreamToClipTLast    : in  std_logic;
      xDiagramAxiStreamToClipTReady   : in  std_logic;
      xDiagramAxiStreamToClipTValid   : in  std_logic;

      xHostAxiStreamFromClipTData  : out std_logic_vector(31 downto 0);
      xHostAxiStreamFromClipTLast  : out std_logic;
      xHostAxiStreamFromClipTReady : out std_logic;
      xHostAxiStreamFromClipTValid : out std_logic;
      xHostAxiStreamToClipTData    : in  std_logic_vector(31 downto 0);
      xHostAxiStreamToClipTLast    : in  std_logic;
      xHostAxiStreamToClipTReady   : in  std_logic;
      xHostAxiStreamToClipTValid   : in  std_logic;


      -- Axi4Lite Interface from the CLIP to FixedLogic
      xClipAxi4LiteMasterARAddr  : out std_logic_vector(31 downto 0);
      xClipAxi4LiteMasterARProt  : out std_logic_vector(2 downto 0);
      xClipAxi4LiteMasterARReady : in  std_logic;
      xClipAxi4LiteMasterARValid : out std_logic;
      xClipAxi4LiteMasterAWAddr  : out std_logic_vector(31 downto 0);
      xClipAxi4LiteMasterAWProt  : out std_logic_vector(2 downto 0);
      xClipAxi4LiteMasterAWReady : in  std_logic;
      xClipAxi4LiteMasterAWValid : out std_logic;
      xClipAxi4LiteMasterBReady  : out std_logic;
      xClipAxi4LiteMasterBResp   : in  std_logic_vector(1 downto 0);
      xClipAxi4LiteMasterBValid  : in  std_logic;
      xClipAxi4LiteMasterRData   : in  std_logic_vector(31 downto 0);
      xClipAxi4LiteMasterRReady  : out std_logic;
      xClipAxi4LiteMasterRResp   : in  std_logic_vector(1 downto 0);
      xClipAxi4LiteMasterRValid  : in  std_logic;
      xClipAxi4LiteMasterWData   : out std_logic_vector(31 downto 0);
      xClipAxi4LiteMasterWReady  : in  std_logic;
      xClipAxi4LiteMasterWStrb   : out std_logic_vector(3 downto 0);
      xClipAxi4LiteMasterWValid  : out std_logic;
      xClipAxi4LiteInterrupt     : in  std_logic;

      --Reserved CLIP Signals
      stIoModuleSupportsFRAGLs : out std_logic;

      -- RefClks
      MgtRefClk_p               : in    std_logic_vector (11 downto 0);
      MgtRefClk_n               : in    std_logic_vector (11 downto 0);
      -- MGTs
      MgtPortRx_p               : in    std_logic_vector (47 downto 0);
      MgtPortRx_n               : in    std_logic_vector (47 downto 0);
      MgtPortTx_p               : out   std_logic_vector (47 downto 0);
      MgtPortTx_n               : out   std_logic_vector (47 downto 0);

      -- Base board DIO
      aDio                      : inout std_logic_vector(7 downto 0);

      -- Configuration
      aLmkI2cSda            : inout std_logic;
      aLmkI2cScl            : inout std_logic;
      aLmk1Pdn_n            : out std_logic;
      aLmk2Pdn_n            : out std_logic;
      aLmk1Gpio0            : out std_logic;
      aLmk2Gpio0            : out std_logic;
      aLmk1Status0          : in std_logic;
      aLmk1Status1          : in std_logic;
      aLmk2Status0          : in std_logic;
      aLmk2Status1          : in std_logic;
      aIPassVccPowerFault_n : in std_logic;
      aIPassPrsnt_n         : in std_logic_vector(7 downto 0);
      aIPassIntr_n          : in std_logic_vector(7 downto 0);
      aIPassSCL             : inout std_logic_vector(11 downto 0);
      aIPassSDA             : inout std_logic_vector(11 downto 0);
      aPortExpReset_n       : out std_logic;
      aPortExpIntr_n        : in std_logic;
      aPortExpSda           : inout std_logic;
      aPortExpScl           : inout std_logic;
      
      -----------------------------------------------------------------------------
      --Dram Interface
      -----------------------------------------------------------------------------
      aDramReady               : in    std_logic;
      du0DramAddrFifoAddr      : out   std_logic_vector(29 downto 0);
      du0DramAddrFifoCmd       : out   std_logic_vector(2 downto 0);
      du0DramAddrFifoFull      : in    std_logic;
      du0DramAddrFifoWrEn      : out   std_logic;
      du0DramPhyInitDone       : in    std_logic;
      du0DramRdDataValid       : in    std_logic;
      du0DramRdFifoDataOut     : in    std_logic_vector(639 downto 0);
      du0DramWrFifoDataIn      : out   std_logic_vector(639 downto 0);
      du0DramWrFifoFull        : in    std_logic;
      du0DramWrFifoMaskData    : out   std_logic_vector(79 downto 0);
      du0DramWrFifoWrEn        : out   std_logic;
      du1DramAddrFifoAddr      : out   std_logic_vector(29 downto 0);
      du1DramAddrFifoCmd       : out   std_logic_vector(2 downto 0);
      du1DramAddrFifoFull      : in    std_logic;
      du1DramAddrFifoWrEn      : out   std_logic;
      du1DramPhyInitDone       : in    std_logic;
      du1DramRdDataValid       : in    std_logic;
      du1DramRdFifoDataOut     : in    std_logic_vector(639 downto 0);
      du1DramWrFifoDataIn      : out   std_logic_vector(639 downto 0);
      du1DramWrFifoFull        : in    std_logic;
      du1DramWrFifoMaskData    : out   std_logic_vector(79 downto 0);
      du1DramWrFifoWrEn        : out   std_logic;

      -----------------------------------------------------------------------------
      --HMB Interface
      -----------------------------------------------------------------------------
      dHmbDramAddrFifoAddr : out std_logic_vector(31 downto 0);
      dHmbDramAddrFifoCmd : out std_logic_vector(2 downto 0);
      dHmbDramAddrFifoFull : in std_logic;
      dHmbDramAddrFifoWrEn : out std_logic;
      dHmbDramRdDataValid : in std_logic;
      dHmbDramRdFifoDataOut : in std_logic_vector(1023 downto 0);
      dHmbDramWrFifoDataIn : out std_logic_vector(1023 downto 0);
      dHmbDramWrFifoFull : in std_logic;
      dHmbDramWrFifoMaskData : out std_logic_vector(127 downto 0);
      dHmbDramWrFifoWrEn : out std_logic;
      dHmbPhyInitDoneForLvfpga : in std_logic;
      dLlbDramAddrFifoAddr : out std_logic_vector(31 downto 0);
      dLlbDramAddrFifoCmd : out std_logic_vector(2 downto 0);
      dLlbDramAddrFifoFull : in std_logic;
      dLlbDramAddrFifoWrEn : out std_logic;
      dLlbDramRdDataValid : in std_logic;
      dLlbDramRdFifoDataOut : in std_logic_vector(1023 downto 0);
      dLlbDramWrFifoDataIn : out std_logic_vector(1023 downto 0);
      dLlbDramWrFifoFull : in std_logic;
      dLlbDramWrFifoMaskData : out std_logic_vector(127 downto 0);
      dLlbDramWrFifoWrEn : out std_logic;
      dLlbPhyInitDoneForLvfpga : in std_logic;

      -----------------------------------
      -- Clocks from TheWindow
      -----------------------------------
      TopLevelClkOut : out std_logic;
      ReliableClkOut : out std_logic;

      -----------------------------------
      -- Diagram/Reset/Clock status
      -----------------------------------
      rBaseClksValid             : in  std_logic := '1';
      tDiagramActive             : out std_logic;
      rDiagramReset              : out std_logic;
      aDiagramReset              : out std_logic;
      rDerivedClockLostLockError : out std_logic;
      rGatedBaseClksValid        : in  std_logic := '1';
      aSafeToEnableGatedClks     : out std_logic
      );

  end component;


  --vhook_sigstart
  signal aPxiTrigDataTri: std_logic_vector(7 downto 0);
  signal MbClk: std_logic;
  --vhook_sigend


  signal xIoModuleReady : std_logic; -- IO Ready (input)
  signal xIoModuleErrorCode : std_logic_vector(31 downto 0); -- IO Error (input)
  signal aDioOut : std_logic_vector(7 downto 0); -- DIO Out (output)
  signal aDioIn : std_logic_vector(7 downto 0); -- DIO In (input)

  signal UserClkPort0 : std_logic; -- Port0 User Clock (input)
  signal aPort0PmaInit : std_logic; -- Port0.PmaInit (output)
  signal aPort0ResetPb : std_logic; -- Port0.ResetPb (output)
  signal uPort0AxiTxTData0 : std_logic_vector(63 downto 0); -- Port0.Tx.TData0 (output)
  signal uPort0AxiTxTData1 : std_logic_vector(63 downto 0); -- Port0.Tx.TData1 (output)
  signal uPort0AxiTxTData2 : std_logic_vector(63 downto 0); -- Port0.Tx.TData2 (output)
  signal uPort0AxiTxTData3 : std_logic_vector(63 downto 0); -- Port0.Tx.TData3 (output)
  signal uPort0AxiTxTKeep : std_logic_vector(31 downto 0); -- Port0.Tx.TKeep (output)
  signal uPort0AxiTxTLast : std_logic; -- Port0.Tx.TLast (output)
  signal uPort0AxiTxTValid : std_logic; -- Port0.Tx.TValid (output)
  signal uPort0AxiTxTReady : std_logic; -- Port0.Tx.TReady (input)
  signal uPort0AxiRxTData0 : std_logic_vector(63 downto 0); -- Port0.Rx.TData0 (input)
  signal uPort0AxiRxTData1 : std_logic_vector(63 downto 0); -- Port0.Rx.TData1 (input)
  signal uPort0AxiRxTData2 : std_logic_vector(63 downto 0); -- Port0.Rx.TData2 (input)
  signal uPort0AxiRxTData3 : std_logic_vector(63 downto 0); -- Port0.Rx.TData3 (input)
  signal uPort0AxiRxTKeep : std_logic_vector(31 downto 0); -- Port0.Rx.TKeep (input)
  signal uPort0AxiRxTLast : std_logic; -- Port0.Rx.TLast (input)
  signal uPort0AxiRxTValid : std_logic; -- Port0.Rx.TValid (input)
  signal uPort0AxiNfcTValid : std_logic; -- Port0.Nfc.TValid (output)
  signal uPort0AxiNfcTData : std_logic_vector(31 downto 0); -- Port0.Nfc.TData (output)
  signal uPort0AxiNfcTReady : std_logic; -- Port0.Nfc.TReady (input)
  signal uPort0HardError : std_logic; -- Port0.HardError (input)
  signal uPort0SoftError : std_logic; -- Port0.SoftError (input)
  signal uPort0LaneUp : std_logic_vector(3 downto 0); -- Port0.LaneUp (input)
  signal uPort0ChannelUp : std_logic; -- Port0.ChannelUp (input)
  signal uPort0SysResetOut : std_logic; -- Port0.SysResetOut (input)
  signal uPort0MmcmNotLockOut : std_logic; -- Port0.MmcmNotLockOut (input)
  signal uPort0CrcPassFail_n : std_logic; -- Port0.CrcPassFail_n (input)
  signal uPort0CrcValid : std_logic; -- Port0.CrcValid (input)
  signal iPort0LinkResetOut : std_logic; -- Port0.LinkResetOut (input)
  signal sGtwiz0CtrlAxiAWAddr : std_logic_vector(31 downto 0); -- Port0.CtrlAxi.AWAddr (output)
  signal sGtwiz0CtrlAxiAWValid : std_logic; -- Port0.CtrlAxi.AWValid (output)
  signal sGtwiz0CtrlAxiAWReady : std_logic; -- Port0.CtrlAxi.AWReady (input)
  signal sGtwiz0CtrlAxiWData : std_logic_vector(31 downto 0); -- Port0.CtrlAxi.WData (output)
  signal sGtwiz0CtrlAxiWStrb : std_logic_vector(3 downto 0); -- Port0.CtrlAxi.WStrb (output)
  signal sGtwiz0CtrlAxiWValid : std_logic; -- Port0.CtrlAxi.WValid (output)
  signal sGtwiz0CtrlAxiWReady : std_logic; -- Port0.CtrlAxi.WReady (input)
  signal sGtwiz0CtrlAxiBResp : std_logic_vector(1 downto 0); -- Port0.CtrlAxi.BResp (input)
  signal sGtwiz0CtrlAxiBValid : std_logic; -- Port0.CtrlAxi.BValid (input)
  signal sGtwiz0CtrlAxiBReady : std_logic; -- Port0.CtrlAxi.BReady (output)
  signal sGtwiz0CtrlAxiARAddr : std_logic_vector(31 downto 0); -- Port0.CtrlAxi.ARAddr (output)
  signal sGtwiz0CtrlAxiARValid : std_logic; -- Port0.CtrlAxi.ARValid (output)
  signal sGtwiz0CtrlAxiARReady : std_logic; -- Port0.CtrlAxi.ARReady (input)
  signal sGtwiz0CtrlAxiRData : std_logic_vector(31 downto 0); -- Port0.CtrlAxi.RData (input)
  signal sGtwiz0CtrlAxiRResp : std_logic_vector(1 downto 0); -- Port0.CtrlAxi.RResp (input)
  signal sGtwiz0CtrlAxiRValid : std_logic; -- Port0.CtrlAxi.RValid (input)
  signal sGtwiz0CtrlAxiRReady : std_logic; -- Port0.CtrlAxi.RReady (output)
  signal sGtwiz0DrpChAxiAWAddr : std_logic_vector(31 downto 0); -- Port0.DrpChAxi.AWAddr (output)
  signal sGtwiz0DrpChAxiAWValid : std_logic; -- Port0.DrpChAxi.AWValid (output)
  signal sGtwiz0DrpChAxiAWReady : std_logic; -- Port0.DrpChAxi.AWReady (input)
  signal sGtwiz0DrpChAxiWData : std_logic_vector(31 downto 0); -- Port0.DrpChAxi.WData (output)
  signal sGtwiz0DrpChAxiWStrb : std_logic_vector(3 downto 0); -- Port0.DrpChAxi.WStrb (output)
  signal sGtwiz0DrpChAxiWValid : std_logic; -- Port0.DrpChAxi.WValid (output)
  signal sGtwiz0DrpChAxiWReady : std_logic; -- Port0.DrpChAxi.WReady (input)
  signal sGtwiz0DrpChAxiBResp : std_logic_vector(1 downto 0); -- Port0.DrpChAxi.BResp (input)
  signal sGtwiz0DrpChAxiBValid : std_logic; -- Port0.DrpChAxi.BValid (input)
  signal sGtwiz0DrpChAxiBReady : std_logic; -- Port0.DrpChAxi.BReady (output)
  signal sGtwiz0DrpChAxiARAddr : std_logic_vector(31 downto 0); -- Port0.DrpChAxi.ARAddr (output)
  signal sGtwiz0DrpChAxiARValid : std_logic; -- Port0.DrpChAxi.ARValid (output)
  signal sGtwiz0DrpChAxiARReady : std_logic; -- Port0.DrpChAxi.ARReady (input)
  signal sGtwiz0DrpChAxiRData : std_logic_vector(31 downto 0); -- Port0.DrpChAxi.RData (input)
  signal sGtwiz0DrpChAxiRResp : std_logic_vector(1 downto 0); -- Port0.DrpChAxi.RResp (input)
  signal sGtwiz0DrpChAxiRValid : std_logic; -- Port0.DrpChAxi.RValid (input)
  signal sGtwiz0DrpChAxiRReady : std_logic; -- Port0.DrpChAxi.RReady (output)
  signal UserClkPort1 : std_logic; -- Port1 User Clock (input)
  signal aPort1PmaInit : std_logic; -- Port1.PmaInit (output)
  signal aPort1ResetPb : std_logic; -- Port1.ResetPb (output)
  signal uPort1AxiTxTData0 : std_logic_vector(63 downto 0); -- Port1.Tx.TData0 (output)
  signal uPort1AxiTxTData1 : std_logic_vector(63 downto 0); -- Port1.Tx.TData1 (output)
  signal uPort1AxiTxTData2 : std_logic_vector(63 downto 0); -- Port1.Tx.TData2 (output)
  signal uPort1AxiTxTData3 : std_logic_vector(63 downto 0); -- Port1.Tx.TData3 (output)
  signal uPort1AxiTxTKeep : std_logic_vector(31 downto 0); -- Port1.Tx.TKeep (output)
  signal uPort1AxiTxTLast : std_logic; -- Port1.Tx.TLast (output)
  signal uPort1AxiTxTValid : std_logic; -- Port1.Tx.TValid (output)
  signal uPort1AxiTxTReady : std_logic; -- Port1.Tx.TReady (input)
  signal uPort1AxiRxTData0 : std_logic_vector(63 downto 0); -- Port1.Rx.TData0 (input)
  signal uPort1AxiRxTData1 : std_logic_vector(63 downto 0); -- Port1.Rx.TData1 (input)
  signal uPort1AxiRxTData2 : std_logic_vector(63 downto 0); -- Port1.Rx.TData2 (input)
  signal uPort1AxiRxTData3 : std_logic_vector(63 downto 0); -- Port1.Rx.TData3 (input)
  signal uPort1AxiRxTKeep : std_logic_vector(31 downto 0); -- Port1.Rx.TKeep (input)
  signal uPort1AxiRxTLast : std_logic; -- Port1.Rx.TLast (input)
  signal uPort1AxiRxTValid : std_logic; -- Port1.Rx.TValid (input)
  signal uPort1AxiNfcTValid : std_logic; -- Port1.Nfc.TValid (output)
  signal uPort1AxiNfcTData : std_logic_vector(31 downto 0); -- Port1.Nfc.TData (output)
  signal uPort1AxiNfcTReady : std_logic; -- Port1.Nfc.TReady (input)
  signal uPort1HardError : std_logic; -- Port1.HardError (input)
  signal uPort1SoftError : std_logic; -- Port1.SoftError (input)
  signal uPort1LaneUp : std_logic_vector(3 downto 0); -- Port1.LaneUp (input)
  signal uPort1ChannelUp : std_logic; -- Port1.ChannelUp (input)
  signal uPort1SysResetOut : std_logic; -- Port1.SysResetOut (input)
  signal uPort1MmcmNotLockOut : std_logic; -- Port1.MmcmNotLockOut (input)
  signal uPort1CrcPassFail_n : std_logic; -- Port1.CrcPassFail_n (input)
  signal uPort1CrcValid : std_logic; -- Port1.CrcValid (input)
  signal iPort1LinkResetOut : std_logic; -- Port1.LinkResetOut (input)
  signal sGtwiz1CtrlAxiAWAddr : std_logic_vector(31 downto 0); -- Port1.CtrlAxi.AWAddr (output)
  signal sGtwiz1CtrlAxiAWValid : std_logic; -- Port1.CtrlAxi.AWValid (output)
  signal sGtwiz1CtrlAxiAWReady : std_logic; -- Port1.CtrlAxi.AWReady (input)
  signal sGtwiz1CtrlAxiWData : std_logic_vector(31 downto 0); -- Port1.CtrlAxi.WData (output)
  signal sGtwiz1CtrlAxiWStrb : std_logic_vector(3 downto 0); -- Port1.CtrlAxi.WStrb (output)
  signal sGtwiz1CtrlAxiWValid : std_logic; -- Port1.CtrlAxi.WValid (output)
  signal sGtwiz1CtrlAxiWReady : std_logic; -- Port1.CtrlAxi.WReady (input)
  signal sGtwiz1CtrlAxiBResp : std_logic_vector(1 downto 0); -- Port1.CtrlAxi.BResp (input)
  signal sGtwiz1CtrlAxiBValid : std_logic; -- Port1.CtrlAxi.BValid (input)
  signal sGtwiz1CtrlAxiBReady : std_logic; -- Port1.CtrlAxi.BReady (output)
  signal sGtwiz1CtrlAxiARAddr : std_logic_vector(31 downto 0); -- Port1.CtrlAxi.ARAddr (output)
  signal sGtwiz1CtrlAxiARValid : std_logic; -- Port1.CtrlAxi.ARValid (output)
  signal sGtwiz1CtrlAxiARReady : std_logic; -- Port1.CtrlAxi.ARReady (input)
  signal sGtwiz1CtrlAxiRData : std_logic_vector(31 downto 0); -- Port1.CtrlAxi.RData (input)
  signal sGtwiz1CtrlAxiRResp : std_logic_vector(1 downto 0); -- Port1.CtrlAxi.RResp (input)
  signal sGtwiz1CtrlAxiRValid : std_logic; -- Port1.CtrlAxi.RValid (input)
  signal sGtwiz1CtrlAxiRReady : std_logic; -- Port1.CtrlAxi.RReady (output)
  signal sGtwiz1DrpChAxiAWAddr : std_logic_vector(31 downto 0); -- Port1.DrpChAxi.AWAddr (output)
  signal sGtwiz1DrpChAxiAWValid : std_logic; -- Port1.DrpChAxi.AWValid (output)
  signal sGtwiz1DrpChAxiAWReady : std_logic; -- Port1.DrpChAxi.AWReady (input)
  signal sGtwiz1DrpChAxiWData : std_logic_vector(31 downto 0); -- Port1.DrpChAxi.WData (output)
  signal sGtwiz1DrpChAxiWStrb : std_logic_vector(3 downto 0); -- Port1.DrpChAxi.WStrb (output)
  signal sGtwiz1DrpChAxiWValid : std_logic; -- Port1.DrpChAxi.WValid (output)
  signal sGtwiz1DrpChAxiWReady : std_logic; -- Port1.DrpChAxi.WReady (input)
  signal sGtwiz1DrpChAxiBResp : std_logic_vector(1 downto 0); -- Port1.DrpChAxi.BResp (input)
  signal sGtwiz1DrpChAxiBValid : std_logic; -- Port1.DrpChAxi.BValid (input)
  signal sGtwiz1DrpChAxiBReady : std_logic; -- Port1.DrpChAxi.BReady (output)
  signal sGtwiz1DrpChAxiARAddr : std_logic_vector(31 downto 0); -- Port1.DrpChAxi.ARAddr (output)
  signal sGtwiz1DrpChAxiARValid : std_logic; -- Port1.DrpChAxi.ARValid (output)
  signal sGtwiz1DrpChAxiARReady : std_logic; -- Port1.DrpChAxi.ARReady (input)
  signal sGtwiz1DrpChAxiRData : std_logic_vector(31 downto 0); -- Port1.DrpChAxi.RData (input)
  signal sGtwiz1DrpChAxiRResp : std_logic_vector(1 downto 0); -- Port1.DrpChAxi.RResp (input)
  signal sGtwiz1DrpChAxiRValid : std_logic; -- Port1.DrpChAxi.RValid (input)
  signal sGtwiz1DrpChAxiRReady : std_logic; -- Port1.DrpChAxi.RReady (output)
  signal UserClkPort2 : std_logic; -- Port2 User Clock (input)
  signal aPort2PmaInit : std_logic; -- Port2.PmaInit (output)
  signal aPort2ResetPb : std_logic; -- Port2.ResetPb (output)
  signal uPort2AxiTxTData0 : std_logic_vector(63 downto 0); -- Port2.Tx.TData0 (output)
  signal uPort2AxiTxTData1 : std_logic_vector(63 downto 0); -- Port2.Tx.TData1 (output)
  signal uPort2AxiTxTData2 : std_logic_vector(63 downto 0); -- Port2.Tx.TData2 (output)
  signal uPort2AxiTxTData3 : std_logic_vector(63 downto 0); -- Port2.Tx.TData3 (output)
  signal uPort2AxiTxTKeep : std_logic_vector(31 downto 0); -- Port2.Tx.TKeep (output)
  signal uPort2AxiTxTLast : std_logic; -- Port2.Tx.TLast (output)
  signal uPort2AxiTxTValid : std_logic; -- Port2.Tx.TValid (output)
  signal uPort2AxiTxTReady : std_logic; -- Port2.Tx.TReady (input)
  signal uPort2AxiRxTData0 : std_logic_vector(63 downto 0); -- Port2.Rx.TData0 (input)
  signal uPort2AxiRxTData1 : std_logic_vector(63 downto 0); -- Port2.Rx.TData1 (input)
  signal uPort2AxiRxTData2 : std_logic_vector(63 downto 0); -- Port2.Rx.TData2 (input)
  signal uPort2AxiRxTData3 : std_logic_vector(63 downto 0); -- Port2.Rx.TData3 (input)
  signal uPort2AxiRxTKeep : std_logic_vector(31 downto 0); -- Port2.Rx.TKeep (input)
  signal uPort2AxiRxTLast : std_logic; -- Port2.Rx.TLast (input)
  signal uPort2AxiRxTValid : std_logic; -- Port2.Rx.TValid (input)
  signal uPort2AxiNfcTValid : std_logic; -- Port2.Nfc.TValid (output)
  signal uPort2AxiNfcTData : std_logic_vector(31 downto 0); -- Port2.Nfc.TData (output)
  signal uPort2AxiNfcTReady : std_logic; -- Port2.Nfc.TReady (input)
  signal uPort2HardError : std_logic; -- Port2.HardError (input)
  signal uPort2SoftError : std_logic; -- Port2.SoftError (input)
  signal uPort2LaneUp : std_logic_vector(3 downto 0); -- Port2.LaneUp (input)
  signal uPort2ChannelUp : std_logic; -- Port2.ChannelUp (input)
  signal uPort2SysResetOut : std_logic; -- Port2.SysResetOut (input)
  signal uPort2MmcmNotLockOut : std_logic; -- Port2.MmcmNotLockOut (input)
  signal uPort2CrcPassFail_n : std_logic; -- Port2.CrcPassFail_n (input)
  signal uPort2CrcValid : std_logic; -- Port2.CrcValid (input)
  signal iPort2LinkResetOut : std_logic; -- Port2.LinkResetOut (input)
  signal sGtwiz2CtrlAxiAWAddr : std_logic_vector(31 downto 0); -- Port2.CtrlAxi.AWAddr (output)
  signal sGtwiz2CtrlAxiAWValid : std_logic; -- Port2.CtrlAxi.AWValid (output)
  signal sGtwiz2CtrlAxiAWReady : std_logic; -- Port2.CtrlAxi.AWReady (input)
  signal sGtwiz2CtrlAxiWData : std_logic_vector(31 downto 0); -- Port2.CtrlAxi.WData (output)
  signal sGtwiz2CtrlAxiWStrb : std_logic_vector(3 downto 0); -- Port2.CtrlAxi.WStrb (output)
  signal sGtwiz2CtrlAxiWValid : std_logic; -- Port2.CtrlAxi.WValid (output)
  signal sGtwiz2CtrlAxiWReady : std_logic; -- Port2.CtrlAxi.WReady (input)
  signal sGtwiz2CtrlAxiBResp : std_logic_vector(1 downto 0); -- Port2.CtrlAxi.BResp (input)
  signal sGtwiz2CtrlAxiBValid : std_logic; -- Port2.CtrlAxi.BValid (input)
  signal sGtwiz2CtrlAxiBReady : std_logic; -- Port2.CtrlAxi.BReady (output)
  signal sGtwiz2CtrlAxiARAddr : std_logic_vector(31 downto 0); -- Port2.CtrlAxi.ARAddr (output)
  signal sGtwiz2CtrlAxiARValid : std_logic; -- Port2.CtrlAxi.ARValid (output)
  signal sGtwiz2CtrlAxiARReady : std_logic; -- Port2.CtrlAxi.ARReady (input)
  signal sGtwiz2CtrlAxiRData : std_logic_vector(31 downto 0); -- Port2.CtrlAxi.RData (input)
  signal sGtwiz2CtrlAxiRResp : std_logic_vector(1 downto 0); -- Port2.CtrlAxi.RResp (input)
  signal sGtwiz2CtrlAxiRValid : std_logic; -- Port2.CtrlAxi.RValid (input)
  signal sGtwiz2CtrlAxiRReady : std_logic; -- Port2.CtrlAxi.RReady (output)
  signal sGtwiz2DrpChAxiAWAddr : std_logic_vector(31 downto 0); -- Port2.DrpChAxi.AWAddr (output)
  signal sGtwiz2DrpChAxiAWValid : std_logic; -- Port2.DrpChAxi.AWValid (output)
  signal sGtwiz2DrpChAxiAWReady : std_logic; -- Port2.DrpChAxi.AWReady (input)
  signal sGtwiz2DrpChAxiWData : std_logic_vector(31 downto 0); -- Port2.DrpChAxi.WData (output)
  signal sGtwiz2DrpChAxiWStrb : std_logic_vector(3 downto 0); -- Port2.DrpChAxi.WStrb (output)
  signal sGtwiz2DrpChAxiWValid : std_logic; -- Port2.DrpChAxi.WValid (output)
  signal sGtwiz2DrpChAxiWReady : std_logic; -- Port2.DrpChAxi.WReady (input)
  signal sGtwiz2DrpChAxiBResp : std_logic_vector(1 downto 0); -- Port2.DrpChAxi.BResp (input)
  signal sGtwiz2DrpChAxiBValid : std_logic; -- Port2.DrpChAxi.BValid (input)
  signal sGtwiz2DrpChAxiBReady : std_logic; -- Port2.DrpChAxi.BReady (output)
  signal sGtwiz2DrpChAxiARAddr : std_logic_vector(31 downto 0); -- Port2.DrpChAxi.ARAddr (output)
  signal sGtwiz2DrpChAxiARValid : std_logic; -- Port2.DrpChAxi.ARValid (output)
  signal sGtwiz2DrpChAxiARReady : std_logic; -- Port2.DrpChAxi.ARReady (input)
  signal sGtwiz2DrpChAxiRData : std_logic_vector(31 downto 0); -- Port2.DrpChAxi.RData (input)
  signal sGtwiz2DrpChAxiRResp : std_logic_vector(1 downto 0); -- Port2.DrpChAxi.RResp (input)
  signal sGtwiz2DrpChAxiRValid : std_logic; -- Port2.DrpChAxi.RValid (input)
  signal sGtwiz2DrpChAxiRReady : std_logic; -- Port2.DrpChAxi.RReady (output)
  signal UserClkPort3 : std_logic; -- Port3 User Clock (input)
  signal aPort3PmaInit : std_logic; -- Port3.PmaInit (output)
  signal aPort3ResetPb : std_logic; -- Port3.ResetPb (output)
  signal uPort3AxiTxTData0 : std_logic_vector(63 downto 0); -- Port3.Tx.TData0 (output)
  signal uPort3AxiTxTData1 : std_logic_vector(63 downto 0); -- Port3.Tx.TData1 (output)
  signal uPort3AxiTxTData2 : std_logic_vector(63 downto 0); -- Port3.Tx.TData2 (output)
  signal uPort3AxiTxTData3 : std_logic_vector(63 downto 0); -- Port3.Tx.TData3 (output)
  signal uPort3AxiTxTKeep : std_logic_vector(31 downto 0); -- Port3.Tx.TKeep (output)
  signal uPort3AxiTxTLast : std_logic; -- Port3.Tx.TLast (output)
  signal uPort3AxiTxTValid : std_logic; -- Port3.Tx.TValid (output)
  signal uPort3AxiTxTReady : std_logic; -- Port3.Tx.TReady (input)
  signal uPort3AxiRxTData0 : std_logic_vector(63 downto 0); -- Port3.Rx.TData0 (input)
  signal uPort3AxiRxTData1 : std_logic_vector(63 downto 0); -- Port3.Rx.TData1 (input)
  signal uPort3AxiRxTData2 : std_logic_vector(63 downto 0); -- Port3.Rx.TData2 (input)
  signal uPort3AxiRxTData3 : std_logic_vector(63 downto 0); -- Port3.Rx.TData3 (input)
  signal uPort3AxiRxTKeep : std_logic_vector(31 downto 0); -- Port3.Rx.TKeep (input)
  signal uPort3AxiRxTLast : std_logic; -- Port3.Rx.TLast (input)
  signal uPort3AxiRxTValid : std_logic; -- Port3.Rx.TValid (input)
  signal uPort3AxiNfcTValid : std_logic; -- Port3.Nfc.TValid (output)
  signal uPort3AxiNfcTData : std_logic_vector(31 downto 0); -- Port3.Nfc.TData (output)
  signal uPort3AxiNfcTReady : std_logic; -- Port3.Nfc.TReady (input)
  signal uPort3HardError : std_logic; -- Port3.HardError (input)
  signal uPort3SoftError : std_logic; -- Port3.SoftError (input)
  signal uPort3LaneUp : std_logic_vector(3 downto 0); -- Port3.LaneUp (input)
  signal uPort3ChannelUp : std_logic; -- Port3.ChannelUp (input)
  signal uPort3SysResetOut : std_logic; -- Port3.SysResetOut (input)
  signal uPort3MmcmNotLockOut : std_logic; -- Port3.MmcmNotLockOut (input)
  signal uPort3CrcPassFail_n : std_logic; -- Port3.CrcPassFail_n (input)
  signal uPort3CrcValid : std_logic; -- Port3.CrcValid (input)
  signal iPort3LinkResetOut : std_logic; -- Port3.LinkResetOut (input)
  signal sGtwiz3CtrlAxiAWAddr : std_logic_vector(31 downto 0); -- Port3.CtrlAxi.AWAddr (output)
  signal sGtwiz3CtrlAxiAWValid : std_logic; -- Port3.CtrlAxi.AWValid (output)
  signal sGtwiz3CtrlAxiAWReady : std_logic; -- Port3.CtrlAxi.AWReady (input)
  signal sGtwiz3CtrlAxiWData : std_logic_vector(31 downto 0); -- Port3.CtrlAxi.WData (output)
  signal sGtwiz3CtrlAxiWStrb : std_logic_vector(3 downto 0); -- Port3.CtrlAxi.WStrb (output)
  signal sGtwiz3CtrlAxiWValid : std_logic; -- Port3.CtrlAxi.WValid (output)
  signal sGtwiz3CtrlAxiWReady : std_logic; -- Port3.CtrlAxi.WReady (input)
  signal sGtwiz3CtrlAxiBResp : std_logic_vector(1 downto 0); -- Port3.CtrlAxi.BResp (input)
  signal sGtwiz3CtrlAxiBValid : std_logic; -- Port3.CtrlAxi.BValid (input)
  signal sGtwiz3CtrlAxiBReady : std_logic; -- Port3.CtrlAxi.BReady (output)
  signal sGtwiz3CtrlAxiARAddr : std_logic_vector(31 downto 0); -- Port3.CtrlAxi.ARAddr (output)
  signal sGtwiz3CtrlAxiARValid : std_logic; -- Port3.CtrlAxi.ARValid (output)
  signal sGtwiz3CtrlAxiARReady : std_logic; -- Port3.CtrlAxi.ARReady (input)
  signal sGtwiz3CtrlAxiRData : std_logic_vector(31 downto 0); -- Port3.CtrlAxi.RData (input)
  signal sGtwiz3CtrlAxiRResp : std_logic_vector(1 downto 0); -- Port3.CtrlAxi.RResp (input)
  signal sGtwiz3CtrlAxiRValid : std_logic; -- Port3.CtrlAxi.RValid (input)
  signal sGtwiz3CtrlAxiRReady : std_logic; -- Port3.CtrlAxi.RReady (output)
  signal sGtwiz3DrpChAxiAWAddr : std_logic_vector(31 downto 0); -- Port3.DrpChAxi.AWAddr (output)
  signal sGtwiz3DrpChAxiAWValid : std_logic; -- Port3.DrpChAxi.AWValid (output)
  signal sGtwiz3DrpChAxiAWReady : std_logic; -- Port3.DrpChAxi.AWReady (input)
  signal sGtwiz3DrpChAxiWData : std_logic_vector(31 downto 0); -- Port3.DrpChAxi.WData (output)
  signal sGtwiz3DrpChAxiWStrb : std_logic_vector(3 downto 0); -- Port3.DrpChAxi.WStrb (output)
  signal sGtwiz3DrpChAxiWValid : std_logic; -- Port3.DrpChAxi.WValid (output)
  signal sGtwiz3DrpChAxiWReady : std_logic; -- Port3.DrpChAxi.WReady (input)
  signal sGtwiz3DrpChAxiBResp : std_logic_vector(1 downto 0); -- Port3.DrpChAxi.BResp (input)
  signal sGtwiz3DrpChAxiBValid : std_logic; -- Port3.DrpChAxi.BValid (input)
  signal sGtwiz3DrpChAxiBReady : std_logic; -- Port3.DrpChAxi.BReady (output)
  signal sGtwiz3DrpChAxiARAddr : std_logic_vector(31 downto 0); -- Port3.DrpChAxi.ARAddr (output)
  signal sGtwiz3DrpChAxiARValid : std_logic; -- Port3.DrpChAxi.ARValid (output)
  signal sGtwiz3DrpChAxiARReady : std_logic; -- Port3.DrpChAxi.ARReady (input)
  signal sGtwiz3DrpChAxiRData : std_logic_vector(31 downto 0); -- Port3.DrpChAxi.RData (input)
  signal sGtwiz3DrpChAxiRResp : std_logic_vector(1 downto 0); -- Port3.DrpChAxi.RResp (input)
  signal sGtwiz3DrpChAxiRValid : std_logic; -- Port3.DrpChAxi.RValid (input)
  signal sGtwiz3DrpChAxiRReady : std_logic; -- Port3.DrpChAxi.RReady (output)
  signal UserClkPort4 : std_logic; -- Port4 User Clock (input)
  signal aPort4PmaInit : std_logic; -- Port4.PmaInit (output)
  signal aPort4ResetPb : std_logic; -- Port4.ResetPb (output)
  signal uPort4AxiTxTData0 : std_logic_vector(63 downto 0); -- Port4.Tx.TData0 (output)
  signal uPort4AxiTxTData1 : std_logic_vector(63 downto 0); -- Port4.Tx.TData1 (output)
  signal uPort4AxiTxTData2 : std_logic_vector(63 downto 0); -- Port4.Tx.TData2 (output)
  signal uPort4AxiTxTData3 : std_logic_vector(63 downto 0); -- Port4.Tx.TData3 (output)
  signal uPort4AxiTxTKeep : std_logic_vector(31 downto 0); -- Port4.Tx.TKeep (output)
  signal uPort4AxiTxTLast : std_logic; -- Port4.Tx.TLast (output)
  signal uPort4AxiTxTValid : std_logic; -- Port4.Tx.TValid (output)
  signal uPort4AxiTxTReady : std_logic; -- Port4.Tx.TReady (input)
  signal uPort4AxiRxTData0 : std_logic_vector(63 downto 0); -- Port4.Rx.TData0 (input)
  signal uPort4AxiRxTData1 : std_logic_vector(63 downto 0); -- Port4.Rx.TData1 (input)
  signal uPort4AxiRxTData2 : std_logic_vector(63 downto 0); -- Port4.Rx.TData2 (input)
  signal uPort4AxiRxTData3 : std_logic_vector(63 downto 0); -- Port4.Rx.TData3 (input)
  signal uPort4AxiRxTKeep : std_logic_vector(31 downto 0); -- Port4.Rx.TKeep (input)
  signal uPort4AxiRxTLast : std_logic; -- Port4.Rx.TLast (input)
  signal uPort4AxiRxTValid : std_logic; -- Port4.Rx.TValid (input)
  signal uPort4AxiNfcTValid : std_logic; -- Port4.Nfc.TValid (output)
  signal uPort4AxiNfcTData : std_logic_vector(31 downto 0); -- Port4.Nfc.TData (output)
  signal uPort4AxiNfcTReady : std_logic; -- Port4.Nfc.TReady (input)
  signal uPort4HardError : std_logic; -- Port4.HardError (input)
  signal uPort4SoftError : std_logic; -- Port4.SoftError (input)
  signal uPort4LaneUp : std_logic_vector(3 downto 0); -- Port4.LaneUp (input)
  signal uPort4ChannelUp : std_logic; -- Port4.ChannelUp (input)
  signal uPort4SysResetOut : std_logic; -- Port4.SysResetOut (input)
  signal uPort4MmcmNotLockOut : std_logic; -- Port4.MmcmNotLockOut (input)
  signal uPort4CrcPassFail_n : std_logic; -- Port4.CrcPassFail_n (input)
  signal uPort4CrcValid : std_logic; -- Port4.CrcValid (input)
  signal iPort4LinkResetOut : std_logic; -- Port4.LinkResetOut (input)
  signal sGtwiz4CtrlAxiAWAddr : std_logic_vector(31 downto 0); -- Port4.CtrlAxi.AWAddr (output)
  signal sGtwiz4CtrlAxiAWValid : std_logic; -- Port4.CtrlAxi.AWValid (output)
  signal sGtwiz4CtrlAxiAWReady : std_logic; -- Port4.CtrlAxi.AWReady (input)
  signal sGtwiz4CtrlAxiWData : std_logic_vector(31 downto 0); -- Port4.CtrlAxi.WData (output)
  signal sGtwiz4CtrlAxiWStrb : std_logic_vector(3 downto 0); -- Port4.CtrlAxi.WStrb (output)
  signal sGtwiz4CtrlAxiWValid : std_logic; -- Port4.CtrlAxi.WValid (output)
  signal sGtwiz4CtrlAxiWReady : std_logic; -- Port4.CtrlAxi.WReady (input)
  signal sGtwiz4CtrlAxiBResp : std_logic_vector(1 downto 0); -- Port4.CtrlAxi.BResp (input)
  signal sGtwiz4CtrlAxiBValid : std_logic; -- Port4.CtrlAxi.BValid (input)
  signal sGtwiz4CtrlAxiBReady : std_logic; -- Port4.CtrlAxi.BReady (output)
  signal sGtwiz4CtrlAxiARAddr : std_logic_vector(31 downto 0); -- Port4.CtrlAxi.ARAddr (output)
  signal sGtwiz4CtrlAxiARValid : std_logic; -- Port4.CtrlAxi.ARValid (output)
  signal sGtwiz4CtrlAxiARReady : std_logic; -- Port4.CtrlAxi.ARReady (input)
  signal sGtwiz4CtrlAxiRData : std_logic_vector(31 downto 0); -- Port4.CtrlAxi.RData (input)
  signal sGtwiz4CtrlAxiRResp : std_logic_vector(1 downto 0); -- Port4.CtrlAxi.RResp (input)
  signal sGtwiz4CtrlAxiRValid : std_logic; -- Port4.CtrlAxi.RValid (input)
  signal sGtwiz4CtrlAxiRReady : std_logic; -- Port4.CtrlAxi.RReady (output)
  signal sGtwiz4DrpChAxiAWAddr : std_logic_vector(31 downto 0); -- Port4.DrpChAxi.AWAddr (output)
  signal sGtwiz4DrpChAxiAWValid : std_logic; -- Port4.DrpChAxi.AWValid (output)
  signal sGtwiz4DrpChAxiAWReady : std_logic; -- Port4.DrpChAxi.AWReady (input)
  signal sGtwiz4DrpChAxiWData : std_logic_vector(31 downto 0); -- Port4.DrpChAxi.WData (output)
  signal sGtwiz4DrpChAxiWStrb : std_logic_vector(3 downto 0); -- Port4.DrpChAxi.WStrb (output)
  signal sGtwiz4DrpChAxiWValid : std_logic; -- Port4.DrpChAxi.WValid (output)
  signal sGtwiz4DrpChAxiWReady : std_logic; -- Port4.DrpChAxi.WReady (input)
  signal sGtwiz4DrpChAxiBResp : std_logic_vector(1 downto 0); -- Port4.DrpChAxi.BResp (input)
  signal sGtwiz4DrpChAxiBValid : std_logic; -- Port4.DrpChAxi.BValid (input)
  signal sGtwiz4DrpChAxiBReady : std_logic; -- Port4.DrpChAxi.BReady (output)
  signal sGtwiz4DrpChAxiARAddr : std_logic_vector(31 downto 0); -- Port4.DrpChAxi.ARAddr (output)
  signal sGtwiz4DrpChAxiARValid : std_logic; -- Port4.DrpChAxi.ARValid (output)
  signal sGtwiz4DrpChAxiARReady : std_logic; -- Port4.DrpChAxi.ARReady (input)
  signal sGtwiz4DrpChAxiRData : std_logic_vector(31 downto 0); -- Port4.DrpChAxi.RData (input)
  signal sGtwiz4DrpChAxiRResp : std_logic_vector(1 downto 0); -- Port4.DrpChAxi.RResp (input)
  signal sGtwiz4DrpChAxiRValid : std_logic; -- Port4.DrpChAxi.RValid (input)
  signal sGtwiz4DrpChAxiRReady : std_logic; -- Port4.DrpChAxi.RReady (output)
  signal UserClkPort5 : std_logic; -- Port5 User Clock (input)
  signal aPort5PmaInit : std_logic; -- Port5.PmaInit (output)
  signal aPort5ResetPb : std_logic; -- Port5.ResetPb (output)
  signal uPort5AxiTxTData0 : std_logic_vector(63 downto 0); -- Port5.Tx.TData0 (output)
  signal uPort5AxiTxTData1 : std_logic_vector(63 downto 0); -- Port5.Tx.TData1 (output)
  signal uPort5AxiTxTData2 : std_logic_vector(63 downto 0); -- Port5.Tx.TData2 (output)
  signal uPort5AxiTxTData3 : std_logic_vector(63 downto 0); -- Port5.Tx.TData3 (output)
  signal uPort5AxiTxTKeep : std_logic_vector(31 downto 0); -- Port5.Tx.TKeep (output)
  signal uPort5AxiTxTLast : std_logic; -- Port5.Tx.TLast (output)
  signal uPort5AxiTxTValid : std_logic; -- Port5.Tx.TValid (output)
  signal uPort5AxiTxTReady : std_logic; -- Port5.Tx.TReady (input)
  signal uPort5AxiRxTData0 : std_logic_vector(63 downto 0); -- Port5.Rx.TData0 (input)
  signal uPort5AxiRxTData1 : std_logic_vector(63 downto 0); -- Port5.Rx.TData1 (input)
  signal uPort5AxiRxTData2 : std_logic_vector(63 downto 0); -- Port5.Rx.TData2 (input)
  signal uPort5AxiRxTData3 : std_logic_vector(63 downto 0); -- Port5.Rx.TData3 (input)
  signal uPort5AxiRxTKeep : std_logic_vector(31 downto 0); -- Port5.Rx.TKeep (input)
  signal uPort5AxiRxTLast : std_logic; -- Port5.Rx.TLast (input)
  signal uPort5AxiRxTValid : std_logic; -- Port5.Rx.TValid (input)
  signal uPort5AxiNfcTValid : std_logic; -- Port5.Nfc.TValid (output)
  signal uPort5AxiNfcTData : std_logic_vector(31 downto 0); -- Port5.Nfc.TData (output)
  signal uPort5AxiNfcTReady : std_logic; -- Port5.Nfc.TReady (input)
  signal uPort5HardError : std_logic; -- Port5.HardError (input)
  signal uPort5SoftError : std_logic; -- Port5.SoftError (input)
  signal uPort5LaneUp : std_logic_vector(3 downto 0); -- Port5.LaneUp (input)
  signal uPort5ChannelUp : std_logic; -- Port5.ChannelUp (input)
  signal uPort5SysResetOut : std_logic; -- Port5.SysResetOut (input)
  signal uPort5MmcmNotLockOut : std_logic; -- Port5.MmcmNotLockOut (input)
  signal uPort5CrcPassFail_n : std_logic; -- Port5.CrcPassFail_n (input)
  signal uPort5CrcValid : std_logic; -- Port5.CrcValid (input)
  signal iPort5LinkResetOut : std_logic; -- Port5.LinkResetOut (input)
  signal sGtwiz5CtrlAxiAWAddr : std_logic_vector(31 downto 0); -- Port5.CtrlAxi.AWAddr (output)
  signal sGtwiz5CtrlAxiAWValid : std_logic; -- Port5.CtrlAxi.AWValid (output)
  signal sGtwiz5CtrlAxiAWReady : std_logic; -- Port5.CtrlAxi.AWReady (input)
  signal sGtwiz5CtrlAxiWData : std_logic_vector(31 downto 0); -- Port5.CtrlAxi.WData (output)
  signal sGtwiz5CtrlAxiWStrb : std_logic_vector(3 downto 0); -- Port5.CtrlAxi.WStrb (output)
  signal sGtwiz5CtrlAxiWValid : std_logic; -- Port5.CtrlAxi.WValid (output)
  signal sGtwiz5CtrlAxiWReady : std_logic; -- Port5.CtrlAxi.WReady (input)
  signal sGtwiz5CtrlAxiBResp : std_logic_vector(1 downto 0); -- Port5.CtrlAxi.BResp (input)
  signal sGtwiz5CtrlAxiBValid : std_logic; -- Port5.CtrlAxi.BValid (input)
  signal sGtwiz5CtrlAxiBReady : std_logic; -- Port5.CtrlAxi.BReady (output)
  signal sGtwiz5CtrlAxiARAddr : std_logic_vector(31 downto 0); -- Port5.CtrlAxi.ARAddr (output)
  signal sGtwiz5CtrlAxiARValid : std_logic; -- Port5.CtrlAxi.ARValid (output)
  signal sGtwiz5CtrlAxiARReady : std_logic; -- Port5.CtrlAxi.ARReady (input)
  signal sGtwiz5CtrlAxiRData : std_logic_vector(31 downto 0); -- Port5.CtrlAxi.RData (input)
  signal sGtwiz5CtrlAxiRResp : std_logic_vector(1 downto 0); -- Port5.CtrlAxi.RResp (input)
  signal sGtwiz5CtrlAxiRValid : std_logic; -- Port5.CtrlAxi.RValid (input)
  signal sGtwiz5CtrlAxiRReady : std_logic; -- Port5.CtrlAxi.RReady (output)
  signal sGtwiz5DrpChAxiAWAddr : std_logic_vector(31 downto 0); -- Port5.DrpChAxi.AWAddr (output)
  signal sGtwiz5DrpChAxiAWValid : std_logic; -- Port5.DrpChAxi.AWValid (output)
  signal sGtwiz5DrpChAxiAWReady : std_logic; -- Port5.DrpChAxi.AWReady (input)
  signal sGtwiz5DrpChAxiWData : std_logic_vector(31 downto 0); -- Port5.DrpChAxi.WData (output)
  signal sGtwiz5DrpChAxiWStrb : std_logic_vector(3 downto 0); -- Port5.DrpChAxi.WStrb (output)
  signal sGtwiz5DrpChAxiWValid : std_logic; -- Port5.DrpChAxi.WValid (output)
  signal sGtwiz5DrpChAxiWReady : std_logic; -- Port5.DrpChAxi.WReady (input)
  signal sGtwiz5DrpChAxiBResp : std_logic_vector(1 downto 0); -- Port5.DrpChAxi.BResp (input)
  signal sGtwiz5DrpChAxiBValid : std_logic; -- Port5.DrpChAxi.BValid (input)
  signal sGtwiz5DrpChAxiBReady : std_logic; -- Port5.DrpChAxi.BReady (output)
  signal sGtwiz5DrpChAxiARAddr : std_logic_vector(31 downto 0); -- Port5.DrpChAxi.ARAddr (output)
  signal sGtwiz5DrpChAxiARValid : std_logic; -- Port5.DrpChAxi.ARValid (output)
  signal sGtwiz5DrpChAxiARReady : std_logic; -- Port5.DrpChAxi.ARReady (input)
  signal sGtwiz5DrpChAxiRData : std_logic_vector(31 downto 0); -- Port5.DrpChAxi.RData (input)
  signal sGtwiz5DrpChAxiRResp : std_logic_vector(1 downto 0); -- Port5.DrpChAxi.RResp (input)
  signal sGtwiz5DrpChAxiRValid : std_logic; -- Port5.DrpChAxi.RValid (input)
  signal sGtwiz5DrpChAxiRReady : std_logic; -- Port5.DrpChAxi.RReady (output)
  signal UserClkPort6 : std_logic; -- Port6 User Clock (input)
  signal aPort6PmaInit : std_logic; -- Port6.PmaInit (output)
  signal aPort6ResetPb : std_logic; -- Port6.ResetPb (output)
  signal uPort6AxiTxTData0 : std_logic_vector(63 downto 0); -- Port6.Tx.TData0 (output)
  signal uPort6AxiTxTData1 : std_logic_vector(63 downto 0); -- Port6.Tx.TData1 (output)
  signal uPort6AxiTxTData2 : std_logic_vector(63 downto 0); -- Port6.Tx.TData2 (output)
  signal uPort6AxiTxTData3 : std_logic_vector(63 downto 0); -- Port6.Tx.TData3 (output)
  signal uPort6AxiTxTKeep : std_logic_vector(31 downto 0); -- Port6.Tx.TKeep (output)
  signal uPort6AxiTxTLast : std_logic; -- Port6.Tx.TLast (output)
  signal uPort6AxiTxTValid : std_logic; -- Port6.Tx.TValid (output)
  signal uPort6AxiTxTReady : std_logic; -- Port6.Tx.TReady (input)
  signal uPort6AxiRxTData0 : std_logic_vector(63 downto 0); -- Port6.Rx.TData0 (input)
  signal uPort6AxiRxTData1 : std_logic_vector(63 downto 0); -- Port6.Rx.TData1 (input)
  signal uPort6AxiRxTData2 : std_logic_vector(63 downto 0); -- Port6.Rx.TData2 (input)
  signal uPort6AxiRxTData3 : std_logic_vector(63 downto 0); -- Port6.Rx.TData3 (input)
  signal uPort6AxiRxTKeep : std_logic_vector(31 downto 0); -- Port6.Rx.TKeep (input)
  signal uPort6AxiRxTLast : std_logic; -- Port6.Rx.TLast (input)
  signal uPort6AxiRxTValid : std_logic; -- Port6.Rx.TValid (input)
  signal uPort6AxiNfcTValid : std_logic; -- Port6.Nfc.TValid (output)
  signal uPort6AxiNfcTData : std_logic_vector(31 downto 0); -- Port6.Nfc.TData (output)
  signal uPort6AxiNfcTReady : std_logic; -- Port6.Nfc.TReady (input)
  signal uPort6HardError : std_logic; -- Port6.HardError (input)
  signal uPort6SoftError : std_logic; -- Port6.SoftError (input)
  signal uPort6LaneUp : std_logic_vector(3 downto 0); -- Port6.LaneUp (input)
  signal uPort6ChannelUp : std_logic; -- Port6.ChannelUp (input)
  signal uPort6SysResetOut : std_logic; -- Port6.SysResetOut (input)
  signal uPort6MmcmNotLockOut : std_logic; -- Port6.MmcmNotLockOut (input)
  signal uPort6CrcPassFail_n : std_logic; -- Port6.CrcPassFail_n (input)
  signal uPort6CrcValid : std_logic; -- Port6.CrcValid (input)
  signal iPort6LinkResetOut : std_logic; -- Port6.LinkResetOut (input)
  signal sGtwiz6CtrlAxiAWAddr : std_logic_vector(31 downto 0); -- Port6.CtrlAxi.AWAddr (output)
  signal sGtwiz6CtrlAxiAWValid : std_logic; -- Port6.CtrlAxi.AWValid (output)
  signal sGtwiz6CtrlAxiAWReady : std_logic; -- Port6.CtrlAxi.AWReady (input)
  signal sGtwiz6CtrlAxiWData : std_logic_vector(31 downto 0); -- Port6.CtrlAxi.WData (output)
  signal sGtwiz6CtrlAxiWStrb : std_logic_vector(3 downto 0); -- Port6.CtrlAxi.WStrb (output)
  signal sGtwiz6CtrlAxiWValid : std_logic; -- Port6.CtrlAxi.WValid (output)
  signal sGtwiz6CtrlAxiWReady : std_logic; -- Port6.CtrlAxi.WReady (input)
  signal sGtwiz6CtrlAxiBResp : std_logic_vector(1 downto 0); -- Port6.CtrlAxi.BResp (input)
  signal sGtwiz6CtrlAxiBValid : std_logic; -- Port6.CtrlAxi.BValid (input)
  signal sGtwiz6CtrlAxiBReady : std_logic; -- Port6.CtrlAxi.BReady (output)
  signal sGtwiz6CtrlAxiARAddr : std_logic_vector(31 downto 0); -- Port6.CtrlAxi.ARAddr (output)
  signal sGtwiz6CtrlAxiARValid : std_logic; -- Port6.CtrlAxi.ARValid (output)
  signal sGtwiz6CtrlAxiARReady : std_logic; -- Port6.CtrlAxi.ARReady (input)
  signal sGtwiz6CtrlAxiRData : std_logic_vector(31 downto 0); -- Port6.CtrlAxi.RData (input)
  signal sGtwiz6CtrlAxiRResp : std_logic_vector(1 downto 0); -- Port6.CtrlAxi.RResp (input)
  signal sGtwiz6CtrlAxiRValid : std_logic; -- Port6.CtrlAxi.RValid (input)
  signal sGtwiz6CtrlAxiRReady : std_logic; -- Port6.CtrlAxi.RReady (output)
  signal sGtwiz6DrpChAxiAWAddr : std_logic_vector(31 downto 0); -- Port6.DrpChAxi.AWAddr (output)
  signal sGtwiz6DrpChAxiAWValid : std_logic; -- Port6.DrpChAxi.AWValid (output)
  signal sGtwiz6DrpChAxiAWReady : std_logic; -- Port6.DrpChAxi.AWReady (input)
  signal sGtwiz6DrpChAxiWData : std_logic_vector(31 downto 0); -- Port6.DrpChAxi.WData (output)
  signal sGtwiz6DrpChAxiWStrb : std_logic_vector(3 downto 0); -- Port6.DrpChAxi.WStrb (output)
  signal sGtwiz6DrpChAxiWValid : std_logic; -- Port6.DrpChAxi.WValid (output)
  signal sGtwiz6DrpChAxiWReady : std_logic; -- Port6.DrpChAxi.WReady (input)
  signal sGtwiz6DrpChAxiBResp : std_logic_vector(1 downto 0); -- Port6.DrpChAxi.BResp (input)
  signal sGtwiz6DrpChAxiBValid : std_logic; -- Port6.DrpChAxi.BValid (input)
  signal sGtwiz6DrpChAxiBReady : std_logic; -- Port6.DrpChAxi.BReady (output)
  signal sGtwiz6DrpChAxiARAddr : std_logic_vector(31 downto 0); -- Port6.DrpChAxi.ARAddr (output)
  signal sGtwiz6DrpChAxiARValid : std_logic; -- Port6.DrpChAxi.ARValid (output)
  signal sGtwiz6DrpChAxiARReady : std_logic; -- Port6.DrpChAxi.ARReady (input)
  signal sGtwiz6DrpChAxiRData : std_logic_vector(31 downto 0); -- Port6.DrpChAxi.RData (input)
  signal sGtwiz6DrpChAxiRResp : std_logic_vector(1 downto 0); -- Port6.DrpChAxi.RResp (input)
  signal sGtwiz6DrpChAxiRValid : std_logic; -- Port6.DrpChAxi.RValid (input)
  signal sGtwiz6DrpChAxiRReady : std_logic; -- Port6.DrpChAxi.RReady (output)
  signal UserClkPort7 : std_logic; -- Port7 User Clock (input)
  signal aPort7PmaInit : std_logic; -- Port7.PmaInit (output)
  signal aPort7ResetPb : std_logic; -- Port7.ResetPb (output)
  signal uPort7AxiTxTData0 : std_logic_vector(63 downto 0); -- Port7.Tx.TData0 (output)
  signal uPort7AxiTxTData1 : std_logic_vector(63 downto 0); -- Port7.Tx.TData1 (output)
  signal uPort7AxiTxTData2 : std_logic_vector(63 downto 0); -- Port7.Tx.TData2 (output)
  signal uPort7AxiTxTData3 : std_logic_vector(63 downto 0); -- Port7.Tx.TData3 (output)
  signal uPort7AxiTxTKeep : std_logic_vector(31 downto 0); -- Port7.Tx.TKeep (output)
  signal uPort7AxiTxTLast : std_logic; -- Port7.Tx.TLast (output)
  signal uPort7AxiTxTValid : std_logic; -- Port7.Tx.TValid (output)
  signal uPort7AxiTxTReady : std_logic; -- Port7.Tx.TReady (input)
  signal uPort7AxiRxTData0 : std_logic_vector(63 downto 0); -- Port7.Rx.TData0 (input)
  signal uPort7AxiRxTData1 : std_logic_vector(63 downto 0); -- Port7.Rx.TData1 (input)
  signal uPort7AxiRxTData2 : std_logic_vector(63 downto 0); -- Port7.Rx.TData2 (input)
  signal uPort7AxiRxTData3 : std_logic_vector(63 downto 0); -- Port7.Rx.TData3 (input)
  signal uPort7AxiRxTKeep : std_logic_vector(31 downto 0); -- Port7.Rx.TKeep (input)
  signal uPort7AxiRxTLast : std_logic; -- Port7.Rx.TLast (input)
  signal uPort7AxiRxTValid : std_logic; -- Port7.Rx.TValid (input)
  signal uPort7AxiNfcTValid : std_logic; -- Port7.Nfc.TValid (output)
  signal uPort7AxiNfcTData : std_logic_vector(31 downto 0); -- Port7.Nfc.TData (output)
  signal uPort7AxiNfcTReady : std_logic; -- Port7.Nfc.TReady (input)
  signal uPort7HardError : std_logic; -- Port7.HardError (input)
  signal uPort7SoftError : std_logic; -- Port7.SoftError (input)
  signal uPort7LaneUp : std_logic_vector(3 downto 0); -- Port7.LaneUp (input)
  signal uPort7ChannelUp : std_logic; -- Port7.ChannelUp (input)
  signal uPort7SysResetOut : std_logic; -- Port7.SysResetOut (input)
  signal uPort7MmcmNotLockOut : std_logic; -- Port7.MmcmNotLockOut (input)
  signal uPort7CrcPassFail_n : std_logic; -- Port7.CrcPassFail_n (input)
  signal uPort7CrcValid : std_logic; -- Port7.CrcValid (input)
  signal iPort7LinkResetOut : std_logic; -- Port7.LinkResetOut (input)
  signal sGtwiz7CtrlAxiAWAddr : std_logic_vector(31 downto 0); -- Port7.CtrlAxi.AWAddr (output)
  signal sGtwiz7CtrlAxiAWValid : std_logic; -- Port7.CtrlAxi.AWValid (output)
  signal sGtwiz7CtrlAxiAWReady : std_logic; -- Port7.CtrlAxi.AWReady (input)
  signal sGtwiz7CtrlAxiWData : std_logic_vector(31 downto 0); -- Port7.CtrlAxi.WData (output)
  signal sGtwiz7CtrlAxiWStrb : std_logic_vector(3 downto 0); -- Port7.CtrlAxi.WStrb (output)
  signal sGtwiz7CtrlAxiWValid : std_logic; -- Port7.CtrlAxi.WValid (output)
  signal sGtwiz7CtrlAxiWReady : std_logic; -- Port7.CtrlAxi.WReady (input)
  signal sGtwiz7CtrlAxiBResp : std_logic_vector(1 downto 0); -- Port7.CtrlAxi.BResp (input)
  signal sGtwiz7CtrlAxiBValid : std_logic; -- Port7.CtrlAxi.BValid (input)
  signal sGtwiz7CtrlAxiBReady : std_logic; -- Port7.CtrlAxi.BReady (output)
  signal sGtwiz7CtrlAxiARAddr : std_logic_vector(31 downto 0); -- Port7.CtrlAxi.ARAddr (output)
  signal sGtwiz7CtrlAxiARValid : std_logic; -- Port7.CtrlAxi.ARValid (output)
  signal sGtwiz7CtrlAxiARReady : std_logic; -- Port7.CtrlAxi.ARReady (input)
  signal sGtwiz7CtrlAxiRData : std_logic_vector(31 downto 0); -- Port7.CtrlAxi.RData (input)
  signal sGtwiz7CtrlAxiRResp : std_logic_vector(1 downto 0); -- Port7.CtrlAxi.RResp (input)
  signal sGtwiz7CtrlAxiRValid : std_logic; -- Port7.CtrlAxi.RValid (input)
  signal sGtwiz7CtrlAxiRReady : std_logic; -- Port7.CtrlAxi.RReady (output)
  signal sGtwiz7DrpChAxiAWAddr : std_logic_vector(31 downto 0); -- Port7.DrpChAxi.AWAddr (output)
  signal sGtwiz7DrpChAxiAWValid : std_logic; -- Port7.DrpChAxi.AWValid (output)
  signal sGtwiz7DrpChAxiAWReady : std_logic; -- Port7.DrpChAxi.AWReady (input)
  signal sGtwiz7DrpChAxiWData : std_logic_vector(31 downto 0); -- Port7.DrpChAxi.WData (output)
  signal sGtwiz7DrpChAxiWStrb : std_logic_vector(3 downto 0); -- Port7.DrpChAxi.WStrb (output)
  signal sGtwiz7DrpChAxiWValid : std_logic; -- Port7.DrpChAxi.WValid (output)
  signal sGtwiz7DrpChAxiWReady : std_logic; -- Port7.DrpChAxi.WReady (input)
  signal sGtwiz7DrpChAxiBResp : std_logic_vector(1 downto 0); -- Port7.DrpChAxi.BResp (input)
  signal sGtwiz7DrpChAxiBValid : std_logic; -- Port7.DrpChAxi.BValid (input)
  signal sGtwiz7DrpChAxiBReady : std_logic; -- Port7.DrpChAxi.BReady (output)
  signal sGtwiz7DrpChAxiARAddr : std_logic_vector(31 downto 0); -- Port7.DrpChAxi.ARAddr (output)
  signal sGtwiz7DrpChAxiARValid : std_logic; -- Port7.DrpChAxi.ARValid (output)
  signal sGtwiz7DrpChAxiARReady : std_logic; -- Port7.DrpChAxi.ARReady (input)
  signal sGtwiz7DrpChAxiRData : std_logic_vector(31 downto 0); -- Port7.DrpChAxi.RData (input)
  signal sGtwiz7DrpChAxiRResp : std_logic_vector(1 downto 0); -- Port7.DrpChAxi.RResp (input)
  signal sGtwiz7DrpChAxiRValid : std_logic; -- Port7.DrpChAxi.RValid (input)
  signal sGtwiz7DrpChAxiRReady : std_logic; -- Port7.DrpChAxi.RReady (output)
  signal UserClkPort8 : std_logic; -- Port8 User Clock (input)
  signal aPort8PmaInit : std_logic; -- Port8.PmaInit (output)
  signal aPort8ResetPb : std_logic; -- Port8.ResetPb (output)
  signal uPort8AxiTxTData0 : std_logic_vector(63 downto 0); -- Port8.Tx.TData0 (output)
  signal uPort8AxiTxTData1 : std_logic_vector(63 downto 0); -- Port8.Tx.TData1 (output)
  signal uPort8AxiTxTData2 : std_logic_vector(63 downto 0); -- Port8.Tx.TData2 (output)
  signal uPort8AxiTxTData3 : std_logic_vector(63 downto 0); -- Port8.Tx.TData3 (output)
  signal uPort8AxiTxTKeep : std_logic_vector(31 downto 0); -- Port8.Tx.TKeep (output)
  signal uPort8AxiTxTLast : std_logic; -- Port8.Tx.TLast (output)
  signal uPort8AxiTxTValid : std_logic; -- Port8.Tx.TValid (output)
  signal uPort8AxiTxTReady : std_logic; -- Port8.Tx.TReady (input)
  signal uPort8AxiRxTData0 : std_logic_vector(63 downto 0); -- Port8.Rx.TData0 (input)
  signal uPort8AxiRxTData1 : std_logic_vector(63 downto 0); -- Port8.Rx.TData1 (input)
  signal uPort8AxiRxTData2 : std_logic_vector(63 downto 0); -- Port8.Rx.TData2 (input)
  signal uPort8AxiRxTData3 : std_logic_vector(63 downto 0); -- Port8.Rx.TData3 (input)
  signal uPort8AxiRxTKeep : std_logic_vector(31 downto 0); -- Port8.Rx.TKeep (input)
  signal uPort8AxiRxTLast : std_logic; -- Port8.Rx.TLast (input)
  signal uPort8AxiRxTValid : std_logic; -- Port8.Rx.TValid (input)
  signal uPort8AxiNfcTValid : std_logic; -- Port8.Nfc.TValid (output)
  signal uPort8AxiNfcTData : std_logic_vector(31 downto 0); -- Port8.Nfc.TData (output)
  signal uPort8AxiNfcTReady : std_logic; -- Port8.Nfc.TReady (input)
  signal uPort8HardError : std_logic; -- Port8.HardError (input)
  signal uPort8SoftError : std_logic; -- Port8.SoftError (input)
  signal uPort8LaneUp : std_logic_vector(3 downto 0); -- Port8.LaneUp (input)
  signal uPort8ChannelUp : std_logic; -- Port8.ChannelUp (input)
  signal uPort8SysResetOut : std_logic; -- Port8.SysResetOut (input)
  signal uPort8MmcmNotLockOut : std_logic; -- Port8.MmcmNotLockOut (input)
  signal uPort8CrcPassFail_n : std_logic; -- Port8.CrcPassFail_n (input)
  signal uPort8CrcValid : std_logic; -- Port8.CrcValid (input)
  signal iPort8LinkResetOut : std_logic; -- Port8.LinkResetOut (input)
  signal sGtwiz8CtrlAxiAWAddr : std_logic_vector(31 downto 0); -- Port8.CtrlAxi.AWAddr (output)
  signal sGtwiz8CtrlAxiAWValid : std_logic; -- Port8.CtrlAxi.AWValid (output)
  signal sGtwiz8CtrlAxiAWReady : std_logic; -- Port8.CtrlAxi.AWReady (input)
  signal sGtwiz8CtrlAxiWData : std_logic_vector(31 downto 0); -- Port8.CtrlAxi.WData (output)
  signal sGtwiz8CtrlAxiWStrb : std_logic_vector(3 downto 0); -- Port8.CtrlAxi.WStrb (output)
  signal sGtwiz8CtrlAxiWValid : std_logic; -- Port8.CtrlAxi.WValid (output)
  signal sGtwiz8CtrlAxiWReady : std_logic; -- Port8.CtrlAxi.WReady (input)
  signal sGtwiz8CtrlAxiBResp : std_logic_vector(1 downto 0); -- Port8.CtrlAxi.BResp (input)
  signal sGtwiz8CtrlAxiBValid : std_logic; -- Port8.CtrlAxi.BValid (input)
  signal sGtwiz8CtrlAxiBReady : std_logic; -- Port8.CtrlAxi.BReady (output)
  signal sGtwiz8CtrlAxiARAddr : std_logic_vector(31 downto 0); -- Port8.CtrlAxi.ARAddr (output)
  signal sGtwiz8CtrlAxiARValid : std_logic; -- Port8.CtrlAxi.ARValid (output)
  signal sGtwiz8CtrlAxiARReady : std_logic; -- Port8.CtrlAxi.ARReady (input)
  signal sGtwiz8CtrlAxiRData : std_logic_vector(31 downto 0); -- Port8.CtrlAxi.RData (input)
  signal sGtwiz8CtrlAxiRResp : std_logic_vector(1 downto 0); -- Port8.CtrlAxi.RResp (input)
  signal sGtwiz8CtrlAxiRValid : std_logic; -- Port8.CtrlAxi.RValid (input)
  signal sGtwiz8CtrlAxiRReady : std_logic; -- Port8.CtrlAxi.RReady (output)
  signal sGtwiz8DrpChAxiAWAddr : std_logic_vector(31 downto 0); -- Port8.DrpChAxi.AWAddr (output)
  signal sGtwiz8DrpChAxiAWValid : std_logic; -- Port8.DrpChAxi.AWValid (output)
  signal sGtwiz8DrpChAxiAWReady : std_logic; -- Port8.DrpChAxi.AWReady (input)
  signal sGtwiz8DrpChAxiWData : std_logic_vector(31 downto 0); -- Port8.DrpChAxi.WData (output)
  signal sGtwiz8DrpChAxiWStrb : std_logic_vector(3 downto 0); -- Port8.DrpChAxi.WStrb (output)
  signal sGtwiz8DrpChAxiWValid : std_logic; -- Port8.DrpChAxi.WValid (output)
  signal sGtwiz8DrpChAxiWReady : std_logic; -- Port8.DrpChAxi.WReady (input)
  signal sGtwiz8DrpChAxiBResp : std_logic_vector(1 downto 0); -- Port8.DrpChAxi.BResp (input)
  signal sGtwiz8DrpChAxiBValid : std_logic; -- Port8.DrpChAxi.BValid (input)
  signal sGtwiz8DrpChAxiBReady : std_logic; -- Port8.DrpChAxi.BReady (output)
  signal sGtwiz8DrpChAxiARAddr : std_logic_vector(31 downto 0); -- Port8.DrpChAxi.ARAddr (output)
  signal sGtwiz8DrpChAxiARValid : std_logic; -- Port8.DrpChAxi.ARValid (output)
  signal sGtwiz8DrpChAxiARReady : std_logic; -- Port8.DrpChAxi.ARReady (input)
  signal sGtwiz8DrpChAxiRData : std_logic_vector(31 downto 0); -- Port8.DrpChAxi.RData (input)
  signal sGtwiz8DrpChAxiRResp : std_logic_vector(1 downto 0); -- Port8.DrpChAxi.RResp (input)
  signal sGtwiz8DrpChAxiRValid : std_logic; -- Port8.DrpChAxi.RValid (input)
  signal sGtwiz8DrpChAxiRReady : std_logic; -- Port8.DrpChAxi.RReady (output)
  signal UserClkPort9 : std_logic; -- Port9 User Clock (input)
  signal aPort9PmaInit : std_logic; -- Port9.PmaInit (output)
  signal aPort9ResetPb : std_logic; -- Port9.ResetPb (output)
  signal uPort9AxiTxTData0 : std_logic_vector(63 downto 0); -- Port9.Tx.TData0 (output)
  signal uPort9AxiTxTData1 : std_logic_vector(63 downto 0); -- Port9.Tx.TData1 (output)
  signal uPort9AxiTxTData2 : std_logic_vector(63 downto 0); -- Port9.Tx.TData2 (output)
  signal uPort9AxiTxTData3 : std_logic_vector(63 downto 0); -- Port9.Tx.TData3 (output)
  signal uPort9AxiTxTKeep : std_logic_vector(31 downto 0); -- Port9.Tx.TKeep (output)
  signal uPort9AxiTxTLast : std_logic; -- Port9.Tx.TLast (output)
  signal uPort9AxiTxTValid : std_logic; -- Port9.Tx.TValid (output)
  signal uPort9AxiTxTReady : std_logic; -- Port9.Tx.TReady (input)
  signal uPort9AxiRxTData0 : std_logic_vector(63 downto 0); -- Port9.Rx.TData0 (input)
  signal uPort9AxiRxTData1 : std_logic_vector(63 downto 0); -- Port9.Rx.TData1 (input)
  signal uPort9AxiRxTData2 : std_logic_vector(63 downto 0); -- Port9.Rx.TData2 (input)
  signal uPort9AxiRxTData3 : std_logic_vector(63 downto 0); -- Port9.Rx.TData3 (input)
  signal uPort9AxiRxTKeep : std_logic_vector(31 downto 0); -- Port9.Rx.TKeep (input)
  signal uPort9AxiRxTLast : std_logic; -- Port9.Rx.TLast (input)
  signal uPort9AxiRxTValid : std_logic; -- Port9.Rx.TValid (input)
  signal uPort9AxiNfcTValid : std_logic; -- Port9.Nfc.TValid (output)
  signal uPort9AxiNfcTData : std_logic_vector(31 downto 0); -- Port9.Nfc.TData (output)
  signal uPort9AxiNfcTReady : std_logic; -- Port9.Nfc.TReady (input)
  signal uPort9HardError : std_logic; -- Port9.HardError (input)
  signal uPort9SoftError : std_logic; -- Port9.SoftError (input)
  signal uPort9LaneUp : std_logic_vector(3 downto 0); -- Port9.LaneUp (input)
  signal uPort9ChannelUp : std_logic; -- Port9.ChannelUp (input)
  signal uPort9SysResetOut : std_logic; -- Port9.SysResetOut (input)
  signal uPort9MmcmNotLockOut : std_logic; -- Port9.MmcmNotLockOut (input)
  signal uPort9CrcPassFail_n : std_logic; -- Port9.CrcPassFail_n (input)
  signal uPort9CrcValid : std_logic; -- Port9.CrcValid (input)
  signal iPort9LinkResetOut : std_logic; -- Port9.LinkResetOut (input)
  signal sGtwiz9CtrlAxiAWAddr : std_logic_vector(31 downto 0); -- Port9.CtrlAxi.AWAddr (output)
  signal sGtwiz9CtrlAxiAWValid : std_logic; -- Port9.CtrlAxi.AWValid (output)
  signal sGtwiz9CtrlAxiAWReady : std_logic; -- Port9.CtrlAxi.AWReady (input)
  signal sGtwiz9CtrlAxiWData : std_logic_vector(31 downto 0); -- Port9.CtrlAxi.WData (output)
  signal sGtwiz9CtrlAxiWStrb : std_logic_vector(3 downto 0); -- Port9.CtrlAxi.WStrb (output)
  signal sGtwiz9CtrlAxiWValid : std_logic; -- Port9.CtrlAxi.WValid (output)
  signal sGtwiz9CtrlAxiWReady : std_logic; -- Port9.CtrlAxi.WReady (input)
  signal sGtwiz9CtrlAxiBResp : std_logic_vector(1 downto 0); -- Port9.CtrlAxi.BResp (input)
  signal sGtwiz9CtrlAxiBValid : std_logic; -- Port9.CtrlAxi.BValid (input)
  signal sGtwiz9CtrlAxiBReady : std_logic; -- Port9.CtrlAxi.BReady (output)
  signal sGtwiz9CtrlAxiARAddr : std_logic_vector(31 downto 0); -- Port9.CtrlAxi.ARAddr (output)
  signal sGtwiz9CtrlAxiARValid : std_logic; -- Port9.CtrlAxi.ARValid (output)
  signal sGtwiz9CtrlAxiARReady : std_logic; -- Port9.CtrlAxi.ARReady (input)
  signal sGtwiz9CtrlAxiRData : std_logic_vector(31 downto 0); -- Port9.CtrlAxi.RData (input)
  signal sGtwiz9CtrlAxiRResp : std_logic_vector(1 downto 0); -- Port9.CtrlAxi.RResp (input)
  signal sGtwiz9CtrlAxiRValid : std_logic; -- Port9.CtrlAxi.RValid (input)
  signal sGtwiz9CtrlAxiRReady : std_logic; -- Port9.CtrlAxi.RReady (output)
  signal sGtwiz9DrpChAxiAWAddr : std_logic_vector(31 downto 0); -- Port9.DrpChAxi.AWAddr (output)
  signal sGtwiz9DrpChAxiAWValid : std_logic; -- Port9.DrpChAxi.AWValid (output)
  signal sGtwiz9DrpChAxiAWReady : std_logic; -- Port9.DrpChAxi.AWReady (input)
  signal sGtwiz9DrpChAxiWData : std_logic_vector(31 downto 0); -- Port9.DrpChAxi.WData (output)
  signal sGtwiz9DrpChAxiWStrb : std_logic_vector(3 downto 0); -- Port9.DrpChAxi.WStrb (output)
  signal sGtwiz9DrpChAxiWValid : std_logic; -- Port9.DrpChAxi.WValid (output)
  signal sGtwiz9DrpChAxiWReady : std_logic; -- Port9.DrpChAxi.WReady (input)
  signal sGtwiz9DrpChAxiBResp : std_logic_vector(1 downto 0); -- Port9.DrpChAxi.BResp (input)
  signal sGtwiz9DrpChAxiBValid : std_logic; -- Port9.DrpChAxi.BValid (input)
  signal sGtwiz9DrpChAxiBReady : std_logic; -- Port9.DrpChAxi.BReady (output)
  signal sGtwiz9DrpChAxiARAddr : std_logic_vector(31 downto 0); -- Port9.DrpChAxi.ARAddr (output)
  signal sGtwiz9DrpChAxiARValid : std_logic; -- Port9.DrpChAxi.ARValid (output)
  signal sGtwiz9DrpChAxiARReady : std_logic; -- Port9.DrpChAxi.ARReady (input)
  signal sGtwiz9DrpChAxiRData : std_logic_vector(31 downto 0); -- Port9.DrpChAxi.RData (input)
  signal sGtwiz9DrpChAxiRResp : std_logic_vector(1 downto 0); -- Port9.DrpChAxi.RResp (input)
  signal sGtwiz9DrpChAxiRValid : std_logic; -- Port9.DrpChAxi.RValid (input)
  signal sGtwiz9DrpChAxiRReady : std_logic; -- Port9.DrpChAxi.RReady (output)
  signal UserClkPort10 : std_logic; -- Port10 User Clock (input)
  signal aPort10PmaInit : std_logic; -- Port10.PmaInit (output)
  signal aPort10ResetPb : std_logic; -- Port10.ResetPb (output)
  signal uPort10AxiTxTData0 : std_logic_vector(63 downto 0); -- Port10.Tx.TData0 (output)
  signal uPort10AxiTxTData1 : std_logic_vector(63 downto 0); -- Port10.Tx.TData1 (output)
  signal uPort10AxiTxTData2 : std_logic_vector(63 downto 0); -- Port10.Tx.TData2 (output)
  signal uPort10AxiTxTData3 : std_logic_vector(63 downto 0); -- Port10.Tx.TData3 (output)
  signal uPort10AxiTxTKeep : std_logic_vector(31 downto 0); -- Port10.Tx.TKeep (output)
  signal uPort10AxiTxTLast : std_logic; -- Port10.Tx.TLast (output)
  signal uPort10AxiTxTValid : std_logic; -- Port10.Tx.TValid (output)
  signal uPort10AxiTxTReady : std_logic; -- Port10.Tx.TReady (input)
  signal uPort10AxiRxTData0 : std_logic_vector(63 downto 0); -- Port10.Rx.TData0 (input)
  signal uPort10AxiRxTData1 : std_logic_vector(63 downto 0); -- Port10.Rx.TData1 (input)
  signal uPort10AxiRxTData2 : std_logic_vector(63 downto 0); -- Port10.Rx.TData2 (input)
  signal uPort10AxiRxTData3 : std_logic_vector(63 downto 0); -- Port10.Rx.TData3 (input)
  signal uPort10AxiRxTKeep : std_logic_vector(31 downto 0); -- Port10.Rx.TKeep (input)
  signal uPort10AxiRxTLast : std_logic; -- Port10.Rx.TLast (input)
  signal uPort10AxiRxTValid : std_logic; -- Port10.Rx.TValid (input)
  signal uPort10AxiNfcTValid : std_logic; -- Port10.Nfc.TValid (output)
  signal uPort10AxiNfcTData : std_logic_vector(31 downto 0); -- Port10.Nfc.TData (output)
  signal uPort10AxiNfcTReady : std_logic; -- Port10.Nfc.TReady (input)
  signal uPort10HardError : std_logic; -- Port10.HardError (input)
  signal uPort10SoftError : std_logic; -- Port10.SoftError (input)
  signal uPort10LaneUp : std_logic_vector(3 downto 0); -- Port10.LaneUp (input)
  signal uPort10ChannelUp : std_logic; -- Port10.ChannelUp (input)
  signal uPort10SysResetOut : std_logic; -- Port10.SysResetOut (input)
  signal uPort10MmcmNotLockOut : std_logic; -- Port10.MmcmNotLockOut (input)
  signal uPort10CrcPassFail_n : std_logic; -- Port10.CrcPassFail_n (input)
  signal uPort10CrcValid : std_logic; -- Port10.CrcValid (input)
  signal iPort10LinkResetOut : std_logic; -- Port10.LinkResetOut (input)
  signal sGtwiz10CtrlAxiAWAddr : std_logic_vector(31 downto 0); -- Port10.CtrlAxi.AWAddr (output)
  signal sGtwiz10CtrlAxiAWValid : std_logic; -- Port10.CtrlAxi.AWValid (output)
  signal sGtwiz10CtrlAxiAWReady : std_logic; -- Port10.CtrlAxi.AWReady (input)
  signal sGtwiz10CtrlAxiWData : std_logic_vector(31 downto 0); -- Port10.CtrlAxi.WData (output)
  signal sGtwiz10CtrlAxiWStrb : std_logic_vector(3 downto 0); -- Port10.CtrlAxi.WStrb (output)
  signal sGtwiz10CtrlAxiWValid : std_logic; -- Port10.CtrlAxi.WValid (output)
  signal sGtwiz10CtrlAxiWReady : std_logic; -- Port10.CtrlAxi.WReady (input)
  signal sGtwiz10CtrlAxiBResp : std_logic_vector(1 downto 0); -- Port10.CtrlAxi.BResp (input)
  signal sGtwiz10CtrlAxiBValid : std_logic; -- Port10.CtrlAxi.BValid (input)
  signal sGtwiz10CtrlAxiBReady : std_logic; -- Port10.CtrlAxi.BReady (output)
  signal sGtwiz10CtrlAxiARAddr : std_logic_vector(31 downto 0); -- Port10.CtrlAxi.ARAddr (output)
  signal sGtwiz10CtrlAxiARValid : std_logic; -- Port10.CtrlAxi.ARValid (output)
  signal sGtwiz10CtrlAxiARReady : std_logic; -- Port10.CtrlAxi.ARReady (input)
  signal sGtwiz10CtrlAxiRData : std_logic_vector(31 downto 0); -- Port10.CtrlAxi.RData (input)
  signal sGtwiz10CtrlAxiRResp : std_logic_vector(1 downto 0); -- Port10.CtrlAxi.RResp (input)
  signal sGtwiz10CtrlAxiRValid : std_logic; -- Port10.CtrlAxi.RValid (input)
  signal sGtwiz10CtrlAxiRReady : std_logic; -- Port10.CtrlAxi.RReady (output)
  signal sGtwiz10DrpChAxiAWAddr : std_logic_vector(31 downto 0); -- Port10.DrpChAxi.AWAddr (output)
  signal sGtwiz10DrpChAxiAWValid : std_logic; -- Port10.DrpChAxi.AWValid (output)
  signal sGtwiz10DrpChAxiAWReady : std_logic; -- Port10.DrpChAxi.AWReady (input)
  signal sGtwiz10DrpChAxiWData : std_logic_vector(31 downto 0); -- Port10.DrpChAxi.WData (output)
  signal sGtwiz10DrpChAxiWStrb : std_logic_vector(3 downto 0); -- Port10.DrpChAxi.WStrb (output)
  signal sGtwiz10DrpChAxiWValid : std_logic; -- Port10.DrpChAxi.WValid (output)
  signal sGtwiz10DrpChAxiWReady : std_logic; -- Port10.DrpChAxi.WReady (input)
  signal sGtwiz10DrpChAxiBResp : std_logic_vector(1 downto 0); -- Port10.DrpChAxi.BResp (input)
  signal sGtwiz10DrpChAxiBValid : std_logic; -- Port10.DrpChAxi.BValid (input)
  signal sGtwiz10DrpChAxiBReady : std_logic; -- Port10.DrpChAxi.BReady (output)
  signal sGtwiz10DrpChAxiARAddr : std_logic_vector(31 downto 0); -- Port10.DrpChAxi.ARAddr (output)
  signal sGtwiz10DrpChAxiARValid : std_logic; -- Port10.DrpChAxi.ARValid (output)
  signal sGtwiz10DrpChAxiARReady : std_logic; -- Port10.DrpChAxi.ARReady (input)
  signal sGtwiz10DrpChAxiRData : std_logic_vector(31 downto 0); -- Port10.DrpChAxi.RData (input)
  signal sGtwiz10DrpChAxiRResp : std_logic_vector(1 downto 0); -- Port10.DrpChAxi.RResp (input)
  signal sGtwiz10DrpChAxiRValid : std_logic; -- Port10.DrpChAxi.RValid (input)
  signal sGtwiz10DrpChAxiRReady : std_logic; -- Port10.DrpChAxi.RReady (output)
  signal UserClkPort11 : std_logic; -- Port11 User Clock (input)
  signal aPort11PmaInit : std_logic; -- Port11.PmaInit (output)
  signal aPort11ResetPb : std_logic; -- Port11.ResetPb (output)
  signal uPort11AxiTxTData0 : std_logic_vector(63 downto 0); -- Port11.Tx.TData0 (output)
  signal uPort11AxiTxTData1 : std_logic_vector(63 downto 0); -- Port11.Tx.TData1 (output)
  signal uPort11AxiTxTData2 : std_logic_vector(63 downto 0); -- Port11.Tx.TData2 (output)
  signal uPort11AxiTxTData3 : std_logic_vector(63 downto 0); -- Port11.Tx.TData3 (output)
  signal uPort11AxiTxTKeep : std_logic_vector(31 downto 0); -- Port11.Tx.TKeep (output)
  signal uPort11AxiTxTLast : std_logic; -- Port11.Tx.TLast (output)
  signal uPort11AxiTxTValid : std_logic; -- Port11.Tx.TValid (output)
  signal uPort11AxiTxTReady : std_logic; -- Port11.Tx.TReady (input)
  signal uPort11AxiRxTData0 : std_logic_vector(63 downto 0); -- Port11.Rx.TData0 (input)
  signal uPort11AxiRxTData1 : std_logic_vector(63 downto 0); -- Port11.Rx.TData1 (input)
  signal uPort11AxiRxTData2 : std_logic_vector(63 downto 0); -- Port11.Rx.TData2 (input)
  signal uPort11AxiRxTData3 : std_logic_vector(63 downto 0); -- Port11.Rx.TData3 (input)
  signal uPort11AxiRxTKeep : std_logic_vector(31 downto 0); -- Port11.Rx.TKeep (input)
  signal uPort11AxiRxTLast : std_logic; -- Port11.Rx.TLast (input)
  signal uPort11AxiRxTValid : std_logic; -- Port11.Rx.TValid (input)
  signal uPort11AxiNfcTValid : std_logic; -- Port11.Nfc.TValid (output)
  signal uPort11AxiNfcTData : std_logic_vector(31 downto 0); -- Port11.Nfc.TData (output)
  signal uPort11AxiNfcTReady : std_logic; -- Port11.Nfc.TReady (input)
  signal uPort11HardError : std_logic; -- Port11.HardError (input)
  signal uPort11SoftError : std_logic; -- Port11.SoftError (input)
  signal uPort11LaneUp : std_logic_vector(3 downto 0); -- Port11.LaneUp (input)
  signal uPort11ChannelUp : std_logic; -- Port11.ChannelUp (input)
  signal uPort11SysResetOut : std_logic; -- Port11.SysResetOut (input)
  signal uPort11MmcmNotLockOut : std_logic; -- Port11.MmcmNotLockOut (input)
  signal uPort11CrcPassFail_n : std_logic; -- Port11.CrcPassFail_n (input)
  signal uPort11CrcValid : std_logic; -- Port11.CrcValid (input)
  signal iPort11LinkResetOut : std_logic; -- Port11.LinkResetOut (input)
  signal sGtwiz11CtrlAxiAWAddr : std_logic_vector(31 downto 0); -- Port11.CtrlAxi.AWAddr (output)
  signal sGtwiz11CtrlAxiAWValid : std_logic; -- Port11.CtrlAxi.AWValid (output)
  signal sGtwiz11CtrlAxiAWReady : std_logic; -- Port11.CtrlAxi.AWReady (input)
  signal sGtwiz11CtrlAxiWData : std_logic_vector(31 downto 0); -- Port11.CtrlAxi.WData (output)
  signal sGtwiz11CtrlAxiWStrb : std_logic_vector(3 downto 0); -- Port11.CtrlAxi.WStrb (output)
  signal sGtwiz11CtrlAxiWValid : std_logic; -- Port11.CtrlAxi.WValid (output)
  signal sGtwiz11CtrlAxiWReady : std_logic; -- Port11.CtrlAxi.WReady (input)
  signal sGtwiz11CtrlAxiBResp : std_logic_vector(1 downto 0); -- Port11.CtrlAxi.BResp (input)
  signal sGtwiz11CtrlAxiBValid : std_logic; -- Port11.CtrlAxi.BValid (input)
  signal sGtwiz11CtrlAxiBReady : std_logic; -- Port11.CtrlAxi.BReady (output)
  signal sGtwiz11CtrlAxiARAddr : std_logic_vector(31 downto 0); -- Port11.CtrlAxi.ARAddr (output)
  signal sGtwiz11CtrlAxiARValid : std_logic; -- Port11.CtrlAxi.ARValid (output)
  signal sGtwiz11CtrlAxiARReady : std_logic; -- Port11.CtrlAxi.ARReady (input)
  signal sGtwiz11CtrlAxiRData : std_logic_vector(31 downto 0); -- Port11.CtrlAxi.RData (input)
  signal sGtwiz11CtrlAxiRResp : std_logic_vector(1 downto 0); -- Port11.CtrlAxi.RResp (input)
  signal sGtwiz11CtrlAxiRValid : std_logic; -- Port11.CtrlAxi.RValid (input)
  signal sGtwiz11CtrlAxiRReady : std_logic; -- Port11.CtrlAxi.RReady (output)
  signal sGtwiz11DrpChAxiAWAddr : std_logic_vector(31 downto 0); -- Port11.DrpChAxi.AWAddr (output)
  signal sGtwiz11DrpChAxiAWValid : std_logic; -- Port11.DrpChAxi.AWValid (output)
  signal sGtwiz11DrpChAxiAWReady : std_logic; -- Port11.DrpChAxi.AWReady (input)
  signal sGtwiz11DrpChAxiWData : std_logic_vector(31 downto 0); -- Port11.DrpChAxi.WData (output)
  signal sGtwiz11DrpChAxiWStrb : std_logic_vector(3 downto 0); -- Port11.DrpChAxi.WStrb (output)
  signal sGtwiz11DrpChAxiWValid : std_logic; -- Port11.DrpChAxi.WValid (output)
  signal sGtwiz11DrpChAxiWReady : std_logic; -- Port11.DrpChAxi.WReady (input)
  signal sGtwiz11DrpChAxiBResp : std_logic_vector(1 downto 0); -- Port11.DrpChAxi.BResp (input)
  signal sGtwiz11DrpChAxiBValid : std_logic; -- Port11.DrpChAxi.BValid (input)
  signal sGtwiz11DrpChAxiBReady : std_logic; -- Port11.DrpChAxi.BReady (output)
  signal sGtwiz11DrpChAxiARAddr : std_logic_vector(31 downto 0); -- Port11.DrpChAxi.ARAddr (output)
  signal sGtwiz11DrpChAxiARValid : std_logic; -- Port11.DrpChAxi.ARValid (output)
  signal sGtwiz11DrpChAxiARReady : std_logic; -- Port11.DrpChAxi.ARReady (input)
  signal sGtwiz11DrpChAxiRData : std_logic_vector(31 downto 0); -- Port11.DrpChAxi.RData (input)
  signal sGtwiz11DrpChAxiRResp : std_logic_vector(1 downto 0); -- Port11.DrpChAxi.RResp (input)
  signal sGtwiz11DrpChAxiRValid : std_logic; -- Port11.DrpChAxi.RValid (input)
  signal sGtwiz11DrpChAxiRReady : std_logic; -- Port11.DrpChAxi.RReady (output)


  signal aAuthSdaInBuf: std_logic;
  signal aAuthSdaOutBuf: std_logic;
  signal abBusReset: boolean;
  signal abDiagramReset: boolean;
  signal aDiagramReset: std_logic;
  signal aDramPonReset: boolean;
  signal aDramReady: std_logic;
  signal aEnableClk10: boolean;
  signal aGa: std_logic_vector(4 downto 0);
  signal aI2cSclIn: std_logic_vector(kNumI2cIfcs-1 downto 0);
  signal aI2cSclOut: std_logic_vector(kNumI2cIfcs-1 downto 0);
  signal aI2cSclTri: std_logic_vector(kNumI2cIfcs-1 downto 0);
  signal aI2cSdaIn: std_logic_vector(kNumI2cIfcs-1 downto 0);
  signal aI2cSdaOut: std_logic_vector(kNumI2cIfcs-1 downto 0);
  signal aI2cSdaTri: std_logic_vector(kNumI2cIfcs-1 downto 0);
  signal aIntClk10: std_logic;
  signal aPcieRst: std_logic;
  signal aPonReset: boolean;
  signal aPxieDstarB: std_logic;
  signal aPxieDstarC: std_logic;
  signal aPxiTrigDataIn: std_logic_vector(7 downto 0);
  signal aPxiTrigDataOut: std_logic_vector(7 downto 0);
  signal aResetFromInchworm: boolean;
  signal aResetToInchworm_n: std_logic;
  signal aSidebandDataInBuf: std_logic;
  signal aSidebandFifoFullBuf: std_logic;
  signal aStage2Enabled: boolean;
  signal aSysMonVector_n: std_logic_vector(15 downto 0);
  signal aSysMonVector_p: std_logic_vector(15 downto 0);
  signal bAxiStreamDataFromCtrl: AxiStreamData_t;
  signal bAxiStreamDataToCtrl: AxiStreamData_t;
  signal bAxiStreamReadyFromCtrl: boolean;
  signal bAxiStreamReadyToCtrl: boolean;
  signal bdClearIoRefClk100Enable: std_logic;
  signal bdClearIoRefClk10Enable: std_logic;
  signal bdClipAxi4LiteARAddr: std_logic_vector(31 downto 0);
  signal bdClipAxi4LiteARProt: std_logic_vector(2 downto 0);
  signal bdClipAxi4LiteARReady: std_logic;
  signal bdClipAxi4LiteARValid: std_logic;
  signal bdClipAxi4LiteAWAddr: std_logic_vector(31 downto 0);
  signal bdClipAxi4LiteAWProt: std_logic_vector(2 downto 0);
  signal bdClipAxi4LiteAWReady: std_logic;
  signal bdClipAxi4LiteAWValid: std_logic;
  signal bdClipAxi4LiteBReady: std_logic;
  signal bdClipAxi4LiteBResp: std_logic_vector(1 downto 0);
  signal bdClipAxi4LiteBValid: std_logic;
  signal bdClipAxi4LiteRData: std_logic_vector(31 downto 0);
  signal bdClipAxi4LiteRReady: std_logic;
  signal bdClipAxi4LiteRResp: std_logic_vector(1 downto 0);
  signal bdClipAxi4LiteRValid: std_logic;
  signal bdClipAxi4LiteWData: std_logic_vector(31 downto 0);
  signal bdClipAxi4LiteWReady: std_logic;
  signal bdClipAxi4LiteWStrb: std_logic_vector(3 downto 0);
  signal bdClipAxi4LiteWValid: std_logic;
  signal bdIFifoRdData: std_logic_vector(63 downto 0);
  signal bdIFifoRdDataValid: std_logic;
  signal bdIFifoRdIsError: std_logic;
  signal bdIFifoRdReadyForInput: std_logic;
  signal bdIFifoWrData: std_logic_vector(63 downto 0);
  signal bdIFifoWrDataValid: std_logic;
  signal bdIFifoWrReadyForOutput: std_logic;
  signal bdIoRefClk100Enabled: std_logic;
  signal bdIoRefClk10Enabled: std_logic;
  signal bdIoRefClkSwitch: std_logic;
  signal bDramClocksValid: std_logic;
  signal bdSelectIoRefClk10: std_logic;
  signal bdSelectIoRefClk100: std_logic;
  signal bdSetIoRefClk100Enable: std_logic;
  signal bdSetIoRefClk10Enable: std_logic;
  signal bIrqToInterface: IrqToInterfaceArray_t(Larger(kNumberOfIrqs,1)-1 downto 0);
  -- Regport interface between Shim and DmaPortCommInt/TheWindow
  signal bRegPortOut: RegPortOut_t;
  signal bRegPortIn: RegPortIn_t;
  signal bLvWindowRegPortOut: RegPortOut_t;
  signal bLvWindowRegPortTimeout: boolean;
  signal bRoutingClipNiCompatible: std_logic;
  signal bRoutingClipPresent: std_logic;
  signal bTriggerRoutingBaRegPortInAddress: std_logic_vector(BaRegPortAddress_t'range);
  signal bTriggerRoutingBaRegPortInData: std_logic_vector(BaRegPortData_t'range);
  signal bTriggerRoutingBaRegPortInRdStrobe: std_logic_vector(BaRegPortStrobe_t'range);
  signal bTriggerRoutingBaRegPortInWtStrobe: std_logic_vector(BaRegPortStrobe_t'range);
  signal bTriggerRoutingBaRegPortOutAck: std_logic;
  signal bTriggerRoutingBaRegPortOutData: std_logic_vector(BaRegPortData_t'range);
  signal BusClk: std_logic;
  signal Clk40MHz: std_logic;
  signal DeviceClk: std_logic;
  signal dFixedLogicBaRegPortIn: BaRegPortIn_t;
  signal dFixedLogicBaRegPortOut: BaRegPortOut_t;
  signal dInputStreamInterfaceFromFifo: InputStreamInterfaceFromFifoArray_t(Larger(kNumberOfDmaChannels,1)-1 downto 0);
  signal dInputStreamInterfaceToFifo: InputStreamInterfaceToFifoArray_t(Larger(kNumberOfDmaChannels,1)-1 downto 0);
  signal dIrqFromFixedLogic: std_logic;
  signal DlyRefClk: std_logic;
  signal DmaClk: std_logic;
  signal dNiFpgaMasterReadDataToMasterArray: NiFpgaMasterReadDataToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
  signal dNiFpgaMasterReadRequestFromMasterArray: NiFpgaMasterReadRequestFromMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
  signal dNiFpgaMasterReadRequestToMasterArray: NiFpgaMasterReadRequestToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
  signal dNiFpgaMasterWriteDataFromMasterArray: NiFpgaMasterWriteDataFromMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
  signal dNiFpgaMasterWriteDataToMasterArray: NiFpgaMasterWriteDataToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
  signal dNiFpgaMasterWriteRequestFromMasterArray: NiFpgaMasterWriteRequestFromMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
  signal dNiFpgaMasterWriteRequestToMasterArray: NiFpgaMasterWriteRequestToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
  signal dNiFpgaMasterWriteStatusToMasterArray: NiFpgaMasterWriteStatusToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
  signal dOutputStreamInterfaceFromFifo: OutputStreamInterfaceFromFifoArray_t(Larger(kNumberOfDmaChannels,1)-1 downto 0);
  signal dOutputStreamInterfaceToFifo: OutputStreamInterfaceToFifoArray_t(Larger(kNumberOfDmaChannels,1)-1 downto 0);
  signal Dram0ClkUser: std_logic;
  signal Dram1ClkUser: std_logic;
  signal DramClkLvFpga: std_logic;
  signal du0DramAddrFifoAddr: std_logic_vector(29 downto 0);
  signal du0DramAddrFifoCmd: std_logic_vector(2 downto 0);
  signal du0DramAddrFifoFull: std_logic;
  signal du0DramAddrFifoWrEn: std_logic;
  signal du0DramPhyInitDone: std_logic;
  signal du0DramRdDataValid: std_logic;
  signal du0DramRdFifoDataOut: std_logic_vector(639 downto 0);
  signal du0DramWrFifoDataIn: std_logic_vector(639 downto 0);
  signal du0DramWrFifoFull: std_logic;
  signal du0DramWrFifoMaskData: std_logic_vector(79 downto 0);
  signal du0DramWrFifoWrEn: std_logic;
  signal du1DramAddrFifoAddr: std_logic_vector(29 downto 0);
  signal du1DramAddrFifoCmd: std_logic_vector(2 downto 0);
  signal du1DramAddrFifoFull: std_logic;
  signal du1DramAddrFifoWrEn: std_logic;
  signal du1DramPhyInitDone: std_logic;
  signal du1DramRdDataValid: std_logic;
  signal du1DramRdFifoDataOut: std_logic_vector(639 downto 0);
  signal du1DramWrFifoDataIn: std_logic_vector(639 downto 0);
  signal du1DramWrFifoFull: std_logic;
  signal du1DramWrFifoMaskData: std_logic_vector(79 downto 0);
  signal du1DramWrFifoWrEn: std_logic;
  signal pIntSync100: std_logic;
  signal PxieClk100: std_logic;
  signal rBaseClksValid: std_logic;
  signal ReliableClk: std_logic;
  signal SidebandClkBuf: std_logic;
  signal sSidebandDataOutBuf: std_logic_vector(3 downto 0);
  signal stEnableIoRefClk10: std_logic;
  signal stEnableIoRefClk100: std_logic;
  signal stIoModuleSupportsFRAGLs: std_logic;
  signal xDiagramAxiStreamFromClipTData: std_logic_vector(31 downto 0);
  signal xDiagramAxiStreamFromClipTLast: std_logic;
  signal xDiagramAxiStreamFromClipTReady: std_logic;
  signal xDiagramAxiStreamFromClipTValid: std_logic;
  signal xDiagramAxiStreamToClipTData: std_logic_vector(31 downto 0);
  signal xDiagramAxiStreamToClipTLast: std_logic;
  signal xDiagramAxiStreamToClipTReady: std_logic;
  signal xDiagramAxiStreamToClipTValid: std_logic;
  signal xHostAxiStreamFromClipTData: std_logic_vector(31 downto 0);
  signal xHostAxiStreamFromClipTLast: std_logic;
  signal xHostAxiStreamFromClipTReady: std_logic;
  signal xHostAxiStreamFromClipTValid: std_logic;
  signal xHostAxiStreamToClipTData: std_logic_vector(31 downto 0);
  signal xHostAxiStreamToClipTLast: std_logic;
  signal xHostAxiStreamToClipTReady: std_logic;
  signal xHostAxiStreamToClipTValid: std_logic;

  -- Inchworm Reset
  signal aBusReset : boolean := true;

  signal dFlatHighSpeedSinkFromDma : FlatNiDmaHighSpeedSinkFromDma_t;

  signal bAddressesDram2DP : boolean;
  signal bRegPortOutDram2DP : RegPortOut_t;
  signal bRegPortInDram2DP : RegPortIn_t;
  signal bRegPortShiftAddress : unsigned(kAlignedAddressWidth - 1 downto 0);
  -- Interface signals between Dram2DP and DMAPort
  signal dNiHmbInputArbGrant: NiDmaArbGrant_t;
  signal dNiHmbInputArbReq: NiDmaArbReq_t;
  signal dNiHmbInputDataFromDma: NiDmaInputDataFromDma_t;
  signal dNiHmbInputDataToDma: NiDmaInputDataToDma_t;
  signal dNiHmbInputRequestFromDma: NiDmaInputRequestFromDma_t;
  signal dNiHmbInputRequestToDma: NiDmaInputRequestToDma_t;
  signal dNiHmbInputStatusFromDma: NiDmaInputStatusFromDma_t;
  signal dNiHmbOutputArbGrant: NiDmaArbGrant_t;
  signal dNiHmbOutputArbReq: NiDmaArbReq_t;
  signal dNiHmbOutputDataFromDma: NiDmaOutputDataFromDma_t;
  signal dNiHmbOutputRequestFromDma: NiDmaOutputRequestFromDma_t;
  signal dNiHmbOutputRequestToDma: NiDmaOutputRequestToDma_t;

  signal dFixedLogicDmaIrq : IrqStatusArray_t(0 downto 0) := (others => kIrqStatusToInterfaceZero);

  -- Interface signals between Dram2DP and DRAM Interface in the Window
  signal dHmbDramAddrFifoAddr: std_logic_vector(31 downto 0);
  signal dHmbDramAddrFifoCmd: std_logic_vector(2 downto 0);
  signal dHmbDramAddrFifoFull: std_logic;
  signal dHmbDramAddrFifoWrEn: std_logic;
  signal dHmbDramRdDataValid: std_logic;
  signal dHmbDramRdFifoDataOut: std_logic_vector(1023 downto 0);
  signal dHmbDramWrFifoDataIn: std_logic_vector(1023 downto 0);
  signal dHmbDramWrFifoFull: std_logic;
  signal dHmbDramWrFifoMaskData: std_logic_vector(127 downto 0);
  signal dHmbDramWrFifoWrEn: std_logic;
  signal dHmbPhyInitDoneForLvfpga: std_logic;
  signal dLlbDramAddrFifoAddr: std_logic_vector(31 downto 0);
  signal dLlbDramAddrFifoCmd: std_logic_vector(2 downto 0);
  signal dLlbDramAddrFifoFull: std_logic;
  signal dLlbDramAddrFifoWrEn: std_logic;
  signal dLlbDramRdDataValid: std_logic;
  signal dLlbDramRdFifoDataOut: std_logic_vector(1023 downto 0);
  signal dLlbDramWrFifoDataIn: std_logic_vector(1023 downto 0);
  signal dLlbDramWrFifoFull: std_logic;
  signal dLlbDramWrFifoMaskData: std_logic_vector(127 downto 0);
  signal dLlbDramWrFifoWrEn: std_logic;
  signal dLlbPhyInitDoneForLvfpga: std_logic;

  -- This constant specifies the size of each memory buffer which (2^kSizeOfMemBuffers)
  -- In this case, it is 2^22= 4MB
  constant kSizeOfMemBuffers : integer := 22;
  -- This constant specifies the maximum number of memory buffers allowed to be used
  -- which (2^kMaxNumOfMemBuffers). In this case, 2^2 = 4 memory buffers.
  constant kMaxNumOfMemBuffers : integer := 2;

  -- Dram2DP Registers are all between 0x60000 and 0x60040 - LV Window shifts by 0x40000
  constant kDram2DPBaseAddress  : unsigned(kAlignedAddressWidth - 1 downto 0) := to_unsigned(work.PkgLvFpgaConst.kDram2DPBaseAddress / 4, kAlignedAddressWidth);
  constant kDram2DPAddressMask  : unsigned(kAlignedAddressWidth - 1 downto 0) := to_unsigned(16#1FC# / 4, kAlignedAddressWidth);

  -- Disable automatic io_buffer creation for FAM MGTs and signals that will instantiate
  -- their own.
  attribute io_buffer_type : string;
  attribute dont_touch     : boolean;

  -- MGT RefClks
  attribute io_buffer_type of MgtRefClk_p      : signal is "none";
  attribute io_buffer_type of MgtRefClk_n      : signal is "none";

  --System Monitor
  attribute io_buffer_type of aSysMon_3v3AMezz_Divided_p     : signal is "none";
  attribute io_buffer_type of aSysMon_3v3AMezz_Divided_n     : signal is "none";
  attribute io_buffer_type of aSysMon_3v3VDMezz_Divided_p    : signal is "none";
  attribute io_buffer_type of aSysMon_3v3VDMezz_Divided_n    : signal is "none";
  attribute io_buffer_type of aSysMon_VccioMezz_Divided_p    : signal is "none";
  attribute io_buffer_type of aSysMon_VccioMezz_Divided_n    : signal is "none";
  attribute io_buffer_type of aSysMon_1v2MgtAvtt_Divided_p   : signal is "none";
  attribute io_buffer_type of aSysMon_1v2MgtAvtt_Divided_n   : signal is "none";
  attribute io_buffer_type of aSysMon_0v9MgtAvcc_Divided_p   : signal is "none";
  attribute io_buffer_type of aSysMon_0v9MgtAvcc_Divided_n   : signal is "none";
  attribute io_buffer_type of aSysMon_3v3A_Divided_p         : signal is "none";
  attribute io_buffer_type of aSysMon_3v3A_Divided_n         : signal is "none";
  attribute io_buffer_type of aSysMon_3v8_Divided_p          : signal is "none";
  attribute io_buffer_type of aSysMon_3v8_Divided_n          : signal is "none";
  attribute io_buffer_type of aSysMon_3v3D_Divided_p         : signal is "none";
  attribute io_buffer_type of aSysMon_3v3D_Divided_n         : signal is "none";
  attribute io_buffer_type of aSysMon_DramVpp_Divided_p      : signal is "none";
  attribute io_buffer_type of aSysMon_DramVpp_Divided_n      : signal is "none";
  attribute io_buffer_type of aSysMon_1v8A_Divided_p         : signal is "none";
  attribute io_buffer_type of aSysMon_1v8A_Divided_n         : signal is "none";
  attribute io_buffer_type of aSysMon_Dram0Vtt_Sense_p       : signal is "none";
  attribute io_buffer_type of aSysMon_Dram0Vtt_Sense_n       : signal is "none";
  attribute io_buffer_type of aSysMon_1v8MgtVccaux_Divided_p : signal is "none";
  attribute io_buffer_type of aSysMon_1v8MgtVccaux_Divided_n : signal is "none";
  attribute io_buffer_type of aSysMon_DramVref_Sense_p       : signal is "none";
  attribute io_buffer_type of aSysMon_DramVref_Sense_n       : signal is "none";
  attribute io_buffer_type of aSysMon_1v2_Divided_p          : signal is "none";
  attribute io_buffer_type of aSysMon_1v2_Divided_n          : signal is "none";

  -- Tandem signals with explicit IOBUF instantiations
  -- This prevents inserting additional buffers which can mess up the stage 1 constraints.
  attribute io_buffer_type of Osc100ClkIn     : signal is "none";
  attribute io_buffer_type of PxieClk100_p    : signal is "none";
  attribute io_buffer_type of PxieClk100_n    : signal is "none";
  attribute io_buffer_type of pPxieSync100_p  : signal is "none";
  attribute io_buffer_type of pPxieSync100_n  : signal is "none";
  attribute io_buffer_type of aPxiGa          : signal is "none";
  attribute io_buffer_type of aAuthSda        : signal is "none";

  attribute io_buffer_type of aPcieRst_n      : signal is "none";

  -- Tandem IO Buffer block
  attribute dont_touch of SasquatchIoBuffersStage1x : label is true;

begin  -- architecture struct

  -- Tags for software's autogeneration
  -- These are not used directly for Appleton, but it makes
  -- software's life easier
  --@@BEGIN LOCAL_SIGNAL_ASSIGNMENT
  --@@END LOCAL_SIGNAL_ASSIGNMENT

  ---------------------------------------------------------------------------------------
  -- Clock Generation and Resets
  ---------------------------------------------------------------------------------------

  --vhook   PxieUspTimingEngine TimingEnginex
  --vhook_a PllClk80            BusClk
  --vhook_a PllClk40            Clk40Mhz
  --vhook_# DRAM
  --vhook_a aDramClocksValid    to_Boolean(bDramClocksValid)
  --vhook_a aDramPllLocked      true
  --vhook_# Clk10 is not used
  --vhook_a pClk10GenD   open
  --vhook_a aEnableClk10 false
  --vhook_# Unused
  --vhook_a adlyReset           open
  --vhook_a bTePllLocked        open
  TimingEnginex: PxieUspTimingEngine
    port map (
      aPcieRst           => aPcieRst,                      --in  std_logic
      aResetToInchworm_n => aResetToInchworm_n,            --out std_logic
      aResetFromInchworm => aResetFromInchworm,            --in  boolean
      aBusReset          => aBusReset,                     --out boolean
      abBusReset         => abBusReset,                    --out boolean
      PxieClk100_p       => PxieClk100_p,                  --in  std_logic
      PxieClk100_n       => PxieClk100_n,                  --in  std_logic
      Osc100ClkIn        => Osc100ClkIn,                   --in  std_logic
      rBaseClksValid     => rBaseClksValid,                --out std_logic
      BusClk             => BusClk,                        --in  std_logic
      bTePllLocked       => open,                          --out std_logic
      ReliableClk        => ReliableClk,                   --out std_logic
      PxieClk100         => PxieClk100,                    --out std_logic
      DlyRefClk          => DlyRefClk,                     --out std_logic
      PllClk40           => Clk40Mhz,                      --out std_logic
      PllClk80           => BusClk,                        --out std_logic
      MbClk              => MbClk,                         --out std_logic
      aStage2Enabled     => aStage2Enabled,                --in  boolean
      pPxieSync100_p     => pPxieSync100_p,                --in  std_logic
      pPxieSync100_n     => pPxieSync100_n,                --in  std_logic
      pClk10GenD         => open,                          --out std_logic
      pIntSync100        => pIntSync100,                   --out std_logic
      aIntClk10          => aIntClk10,                     --out std_logic
      aEnableClk10       => false,                         --in  boolean
      aDramClocksValid   => to_Boolean(bDramClocksValid),  --in  boolean
      aDramPllLocked     => true,                          --in  boolean
      aDramPonReset      => aDramPonReset,                 --out boolean
      aDramReady         => aDramReady,                    --out std_logic
      du0DramPhyInitDone => du0DramPhyInitDone,            --in  std_logic
      du1DramPhyInitDone => du1DramPhyInitDone,            --in  std_logic
      aPonReset          => aPonReset,                     --out boolean
      adlyReset          => open);                         --out boolean

  ---------------------------------------------------------------------------------------
  -- Host Interface
  ---------------------------------------------------------------------------------------

  --VSMake doesn't like prefix-less signals.
  --vhook_nodgv {^Pcie[RT]x_[pn]}

  --vhook_e G3UspGtyHostInterface HostInterfacex
  --vhook_# Use BusClk for AxiClk and ViClk
  --vhook_a AxiClk              BusClk
  --vhook_a {x(AxiStream.+)}    xHost$1
  --vhook_a ViClk               BusClk
  --vhook_a {v(IFifo.+)}        bd$1
  --vhook_# DmaClk wrap-back
  --vhook_a DmaClockSource      DmaClk
  --vhook_a aAuthSdaIn          aAuthSdaInBuf
  --vhook_a aAuthSdaOut         aAuthSdaOutBuf
  --vhook_a bLvWindowRegPortIn  bRegPortIn
  --vhook_a bLvWindowRegPortOut bRegPortOut
  --vhook_g kHmbInUse true
  --vhook_a GtDrpClk              open
  --vhook_a gGt*                  (others => '0') mode=in
  --vhook_a gGt*                  open            mode=out
  --vhook_a aIbertEyescanResetIn  (others => '0')
  HostInterfacex: entity work.G3UspGtyHostInterface (struct)
    generic map (kHmbInUse => true)  --boolean:=false
    port map (
      PcieRefClk_p                             => PcieRefClk_p,                              --in  std_logic
      PcieRefClk_n                             => PcieRefClk_n,                              --in  std_logic
      PcieRx_p                                 => PcieRx_p,                                  --in  std_logic_vector(7:0)
      PcieRx_n                                 => PcieRx_n,                                  --in  std_logic_vector(7:0)
      PcieTx_p                                 => PcieTx_p,                                  --out std_logic_vector(7:0)
      PcieTx_n                                 => PcieTx_n,                                  --out std_logic_vector(7:0)
      aGa                                      => aGa,                                       --in  std_logic_vector(4:0)
      DmaClockSource                           => DmaClk,                                    --out std_logic
      DmaClk                                   => DmaClk,                                    --in  std_logic
      BusClk                                   => BusClk,                                    --in  std_logic
      aPonReset                                => aPonReset,                                 --in  boolean
      aBusReset                                => aBusReset,                                 --in  boolean
      aResetToInchworm_n                       => aResetToInchworm_n,                        --in  std_logic
      aResetFromInchworm                       => aResetFromInchworm,                        --out boolean
      Clk40MHz                                 => Clk40MHz,                                  --in  std_logic
      aAuthSdaIn                               => aAuthSdaInBuf,                             --in  std_logic
      aAuthSdaOut                              => aAuthSdaOutBuf,                            --out std_logic
      dNiHmbInputRequestToDma                  => dNiHmbInputRequestToDma,                   --in  NiDmaInputRequestToDma_t:=kNiDmaInputRequestToDmaZero
      dNiHmbInputRequestFromDma                => dNiHmbInputRequestFromDma,                 --out NiDmaInputRequestFromDma_t
      dNiHmbInputDataToDma                     => dNiHmbInputDataToDma,                      --in  NiDmaInputDataToDma_t:=kNiDmaInputDataToDmaZero
      dNiHmbInputDataFromDma                   => dNiHmbInputDataFromDma,                    --out NiDmaInputDataFromDma_t
      dNiHmbInputStatusFromDma                 => dNiHmbInputStatusFromDma,                  --out NiDmaInputStatusFromDma_t
      dNiHmbOutputRequestToDma                 => dNiHmbOutputRequestToDma,                  --in  NiDmaOutputRequestToDma_t:=kNiDmaOutputRequestToDmaZero
      dNiHmbOutputRequestFromDma               => dNiHmbOutputRequestFromDma,                --out NiDmaOutputRequestFromDma_t
      dNiHmbOutputDataFromDma                  => dNiHmbOutputDataFromDma,                   --out NiDmaOutputDataFromDma_t
      dNiHmbInputArbReq                        => dNiHmbInputArbReq,                         --in  NiDmaArbReq_t:=kNiDmaArbReqZero
      dNiHmbInputArbGrant                      => dNiHmbInputArbGrant,                       --out NiDmaArbGrant_t
      dNiHmbOutputArbReq                       => dNiHmbOutputArbReq,                        --in  NiDmaArbReq_t:=kNiDmaArbReqZero
      dNiHmbOutputArbGrant                     => dNiHmbOutputArbGrant,                      --out NiDmaArbGrant_t
      aDiagramReset                            => aDiagramReset,                             --in  std_logic
      bLvWindowRegPortIn                       => bRegPortIn,                                --out RegPortIn_t
      bLvWindowRegPortOut                      => bRegPortOut,                               --in  RegPortOut_t
      bLvWindowRegPortTimeOut                  => bLvWindowRegPortTimeOut,                   --out boolean
      bIrqToInterface                          => bIrqToInterface,                           --in  IrqToInterfaceArray_t
      dInputStreamInterfaceFromFifo            => dInputStreamInterfaceFromFifo,             --in  InputStreamInterfaceFromFifoArray_t
      dInputStreamInterfaceToFifo              => dInputStreamInterfaceToFifo,               --out InputStreamInterfaceToFifoArray_t
      dOutputStreamInterfaceFromFifo           => dOutputStreamInterfaceFromFifo,            --in  OutputStreamInterfaceFromFifoArray_t
      dOutputStreamInterfaceToFifo             => dOutputStreamInterfaceToFifo,              --out OutputStreamInterfaceToFifoArray_t
      dNiFpgaMasterWriteRequestFromMasterArray => dNiFpgaMasterWriteRequestFromMasterArray,  --in  NiFpgaMasterWriteRequestFromMasterArray_t
      dNiFpgaMasterWriteRequestToMasterArray   => dNiFpgaMasterWriteRequestToMasterArray,    --out NiFpgaMasterWriteRequestToMasterArray_t
      dNiFpgaMasterWriteDataFromMasterArray    => dNiFpgaMasterWriteDataFromMasterArray,     --in  NiFpgaMasterWriteDataFromMasterArray_t
      dNiFpgaMasterWriteDataToMasterArray      => dNiFpgaMasterWriteDataToMasterArray,       --out NiFpgaMasterWriteDataToMasterArray_t
      dNiFpgaMasterWriteStatusToMasterArray    => dNiFpgaMasterWriteStatusToMasterArray,     --out NiFpgaMasterWriteStatusToMasterArray_t
      dNiFpgaMasterReadRequestFromMasterArray  => dNiFpgaMasterReadRequestFromMasterArray,   --in  NiFpgaMasterReadRequestFromMasterArray_t
      dNiFpgaMasterReadRequestToMasterArray    => dNiFpgaMasterReadRequestToMasterArray,     --out NiFpgaMasterReadRequestToMasterArray_t
      dNiFpgaMasterReadDataToMasterArray       => dNiFpgaMasterReadDataToMasterArray,        --out NiFpgaMasterreadDataToMasterArray_t
      AxiClk                                   => BusClk,                                    --in  std_logic
      xAxiStreamFromClipTData                  => xHostAxiStreamFromClipTData,               --in  AxiStreamTData_t
      xAxiStreamFromClipTLast                  => xHostAxiStreamFromClipTLast,               --in  std_logic
      xAxiStreamToClipTReady                   => xHostAxiStreamToClipTReady,                --out std_logic
      xAxiStreamFromClipTValid                 => xHostAxiStreamFromClipTValid,              --in  std_logic
      xAxiStreamToClipTData                    => xHostAxiStreamToClipTData,                 --out AxiStreamTData_t
      xAxiStreamToClipTLast                    => xHostAxiStreamToClipTLast,                 --out std_logic
      xAxiStreamToClipTValid                   => xHostAxiStreamToClipTValid,                --out std_logic
      xAxiStreamFromClipTReady                 => xHostAxiStreamFromClipTReady,              --in  std_logic
      ViClk                                    => BusClk,                                    --in  std_logic
      vIFifoWrData                             => bdIFifoWrData,                             --out IFifoWriteData_t
      vIFifoWrDataValid                        => bdIFifoWrDataValid,                        --out std_logic
      vIFifoWrReadyForOutput                   => bdIFifoWrReadyForOutput,                   --in  std_logic
      vIFifoRdData                             => bdIFifoRdData,                             --in  IFifoReadData_t
      vIFifoRdIsError                          => bdIFifoRdIsError,                          --in  std_logic
      vIFifoRdDataValid                        => bdIFifoRdDataValid,                        --in  std_logic
      vIFifoRdReadyForInput                    => bdIFifoRdReadyForInput,                    --out std_logic
      dFixedLogicBaRegPortIn                   => dFixedLogicBaRegPortIn,                    --out BaRegPortIn_t
      dFixedLogicBaRegPortOut                  => dFixedLogicBaRegPortOut,                   --in  BaRegPortOut_t
      dFlatHighSpeedSinkFromDma                => dFlatHighSpeedSinkFromDma,                 --out FlatNiDmaHighSpeedSinkFromDma_t
      bAxiStreamDataToCtrl                     => bAxiStreamDataToCtrl,                      --out AxiStreamData_t
      bAxiStreamReadyFromCtrl                  => bAxiStreamReadyFromCtrl,                   --in  boolean
      bAxiStreamDataFromCtrl                   => bAxiStreamDataFromCtrl,                    --in  AxiStreamData_t
      bAxiStreamReadyToCtrl                    => bAxiStreamReadyToCtrl,                     --out boolean
      dIrqFromFixedLogic                       => dIrqFromFixedLogic,                        --in  std_logic
      aStage2Enabled                           => aStage2Enabled,                            --out boolean
      GtDrpClk                                 => open,                                      --out std_logic
      gGtDrpAddr                               => (others => '0'),                           --in  std_logic_vector(79:0)
      gGtDrpEn                                 => (others => '0'),                           --in  std_logic_vector(7:0)
      gGtDrpDi                                 => (others => '0'),                           --in  std_logic_vector(127:0)
      gGtDrpWe                                 => (others => '0'),                           --in  std_logic_vector(7:0)
      gGtDrpDo                                 => open,                                      --out std_logic_vector(127:0)
      gGtDrpRdy                                => open,                                      --out std_logic_vector(7:0)
      aIbertEyescanResetIn                     => (others => '0'));                          --in  std_logic_vector(7:0)

  ---------------------------------------------------------------------------------------
  -- Fixed Logic
  ---------------------------------------------------------------------------------------

  --vhook_e FixedLogicWrapper
  --vhook_# I2c
  --vhook_a {^b(.*?)(Scl|Sda)(In|Out|Tri)}      aI2c$2$3(k$1Index)
  --vhook_a SidebandClk       SidebandClkBuf
  --vhook_a sSidebandDataOut  sSidebandDataOutBuf
  --vhook_a aSidebandDataIn   aSidebandDataInBuf
  --vhook_a aSidebandFifoFull aSidebandFifoFullBuf
  --vhook_a a3v3APwrGood '1'
  --vhook_a a1v8APwrGood '1'
  --vhook_a aPxiTrigExtTri aPxiTrigDir
  FixedLogicWrapperx: entity work.FixedLogicWrapper (struct)
    port map (
      aPonReset                          => aPonReset,                           --in  boolean
      aBusReset                          => aBusReset,                           --in  boolean
      aDiagramReset                      => aDiagramReset,                       --in  std_logic
      DmaClk                             => DmaClk,                              --in  std_logic
      BusClk                             => BusClk,                              --in  std_logic
      MbClk                              => MbClk,                               --in  std_logic
      dFixedLogicBaRegPortIn             => dFixedLogicBaRegPortIn,              --in  BaRegPortIn_t
      dFixedLogicBaRegPortOut            => dFixedLogicBaRegPortOut,             --out BaRegPortOut_t
      bTriggerRoutingBaRegPortInAddress  => bTriggerRoutingBaRegPortInAddress,   --out std_logic_vector(BaRegPortAddress_t'range)
      bTriggerRoutingBaRegPortInData     => bTriggerRoutingBaRegPortInData,      --out std_logic_vector(BaRegPortData_t'range)
      bTriggerRoutingBaRegPortInWtStrobe => bTriggerRoutingBaRegPortInWtStrobe,  --out std_logic_vector(BaRegPortStrobe_t'range)
      bTriggerRoutingBaRegPortInRdStrobe => bTriggerRoutingBaRegPortInRdStrobe,  --out std_logic_vector(BaRegPortStrobe_t'range)
      bTriggerRoutingBaRegPortOutData    => bTriggerRoutingBaRegPortOutData,     --in  std_logic_vector(BaRegPortData_t'range)
      bTriggerRoutingBaRegPortOutAck     => bTriggerRoutingBaRegPortOutAck,      --in  std_logic
      bRoutingClipPresent                => bRoutingClipPresent,                 --in  std_logic
      bRoutingClipNiCompatible           => bRoutingClipNiCompatible,            --in  std_logic
      stEnableIoRefClk10                 => stEnableIoRefClk10,                  --in  std_logic
      stEnableIoRefClk100                => stEnableIoRefClk100,                 --in  std_logic
      bAxiStreamDataToCtrl               => bAxiStreamDataToCtrl,                --in  AxiStreamData_t
      bAxiStreamReadyFromCtrl            => bAxiStreamReadyFromCtrl,             --out boolean
      bAxiStreamDataFromCtrl             => bAxiStreamDataFromCtrl,              --out AxiStreamData_t
      bAxiStreamReadyToCtrl              => bAxiStreamReadyToCtrl,               --in  boolean
      bBaseSmbSclOut                     => aI2cSclOut(kBaseSmbIndex),           --out std_logic
      bBaseSmbSclIn                      => aI2cSclIn(kBaseSmbIndex),            --in  std_logic
      bBaseSmbSclTri                     => aI2cSclTri(kBaseSmbIndex),           --out std_logic
      bBaseSmbSdaIn                      => aI2cSdaIn(kBaseSmbIndex),            --in  std_logic
      bBaseSmbSdaOut                     => aI2cSdaOut(kBaseSmbIndex),           --out std_logic
      bBaseSmbSdaTri                     => aI2cSdaTri(kBaseSmbIndex),           --out std_logic
      bConfigI2cSclIn                    => aI2cSclIn(kConfigI2cIndex),          --in  std_logic
      bConfigI2cSclOut                   => aI2cSclOut(kConfigI2cIndex),         --out std_logic
      bConfigI2cSclTri                   => aI2cSclTri(kConfigI2cIndex),         --out std_logic
      bConfigI2cSdaIn                    => aI2cSdaIn(kConfigI2cIndex),          --in  std_logic
      bConfigI2cSdaOut                   => aI2cSdaOut(kConfigI2cIndex),         --out std_logic
      bConfigI2cSdaTri                   => aI2cSdaTri(kConfigI2cIndex),         --out std_logic
      bPwrSupplyPmbSclIn                 => aI2cSclIn(kPwrSupplyPmbIndex),       --in  std_logic
      bPwrSupplyPmbSclOut                => aI2cSclOut(kPwrSupplyPmbIndex),      --out std_logic
      bPwrSupplyPmbSclTri                => aI2cSclTri(kPwrSupplyPmbIndex),      --out std_logic
      bPwrSupplyPmbSdaIn                 => aI2cSdaIn(kPwrSupplyPmbIndex),       --in  std_logic
      bPwrSupplyPmbSdaOut                => aI2cSdaOut(kPwrSupplyPmbIndex),      --out std_logic
      bPwrSupplyPmbSdaTri                => aI2cSdaTri(kPwrSupplyPmbIndex),      --out std_logic
      bMezzSmbSclIn                      => aI2cSclIn(kMezzSmbIndex),            --in  std_logic
      bMezzSmbSclOut                     => aI2cSclOut(kMezzSmbIndex),           --out std_logic
      bMezzSmbSclTri                     => aI2cSclTri(kMezzSmbIndex),           --out std_logic
      bMezzSmbSdaIn                      => aI2cSdaIn(kMezzSmbIndex),            --in  std_logic
      bMezzSmbSdaOut                     => aI2cSdaOut(kMezzSmbIndex),           --out std_logic
      bMezzSmbSdaTri                     => aI2cSdaTri(kMezzSmbIndex),           --out std_logic
      bDramClocksValid                   => bDramClocksValid,                    --out std_logic
      a3v3APwrGood                       => '1',                                 --in  std_logic
      a1v8APwrGood                       => '1',                                 --in  std_logic
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
      SidebandClk                        => SidebandClkBuf,                      --out std_logic
      sSidebandDataOut                   => sSidebandDataOutBuf,                 --out std_logic_vector(3:0)
      aSidebandDataIn                    => aSidebandDataInBuf,                  --in  std_logic
      aSidebandFifoFull                  => aSidebandFifoFullBuf,                --in  std_logic
      aPxiTrigExtTri                     => aPxiTrigDir,                         --out std_logic_vector(7:0)
      aSysMonVector_p                    => aSysMonVector_p,                     --in  std_logic_vector(15:0)
      aSysMonVector_n                    => aSysMonVector_n,                     --in  std_logic_vector(15:0)
      aFldUpdJtagSel                     => aFldUpdJtagSel,                      --out std_logic
      bFldUpdJtagTck                     => bFldUpdJtagTck,                      --out std_logic
      bFldUpdJtagTdi                     => bFldUpdJtagTdi,                      --out std_logic
      aFldUpdJtagTdo                     => aFldUpdJtagTdo,                      --in  std_logic
      bFldUpdJtagTms                     => bFldUpdJtagTms,                      --out std_logic
      dIrqFromFixedLogic                 => dIrqFromFixedLogic);                 --out std_logic

  aSysMonVector_p <= (kSysMon_DramVref_Sense       => aSysMon_DramVref_Sense_p,
                      kSysMon_Dram0Vtt_Sense       => aSysMon_Dram0Vtt_Sense_p,
                      kSysMon_DramVpp_Divided      => aSysMon_DramVpp_Divided_p,
                      kSysMon_3v8_Divided          => aSysMon_3v8_Divided_p,
                      kSysMon_VccioMezz_Divided    => aSysMon_VccioMezz_Divided_p,
                      kSysMon_3v3AMezz_Divided     => aSysMon_3v3AMezz_Divided_p,
                      kSysMon_1v2MgtAvtt_Divided   => aSysMon_1v2MgtAvtt_Divided_p,
                      kSysMon_1v8MgtVccaux_Divided => aSysMon_1v8MgtVccaux_Divided_p,
                      kSysMon_1v8A_Divided         => aSysMon_1v8A_Divided_p,
                      kSysMon_3v3D_Divided         => aSysMon_3v3D_Divided_p,
                      kSysMon_3v3A_Divided         => aSysMon_3v3A_Divided_p,
                      kSysMon_3v3VDMezz_Divided    => aSysMon_3v3VDMezz_Divided_p,
                      kSysMon_0v9MgtAvcc_Divided   => aSysMon_0v9MgtAvcc_Divided_p,
                      kSysMon_1v2_Divided          => aSysMon_1v2_Divided_p,
                      others                       => '0');

  aSysMonVector_n <= (kSysMon_DramVref_Sense       => aSysMon_DramVref_Sense_n,
                      kSysMon_Dram0Vtt_Sense       => aSysMon_Dram0Vtt_Sense_n,
                      kSysMon_DramVpp_Divided      => aSysMon_DramVpp_Divided_n,
                      kSysMon_3v8_Divided          => aSysMon_3v8_Divided_n,
                      kSysMon_VccioMezz_Divided    => aSysMon_VccioMezz_Divided_n,
                      kSysMon_3v3AMezz_Divided     => aSysMon_3v3AMezz_Divided_n,
                      kSysMon_1v2MgtAvtt_Divided   => aSysMon_1v2MgtAvtt_Divided_n,
                      kSysMon_1v8MgtVccaux_Divided => aSysMon_1v8MgtVccaux_Divided_n,
                      kSysMon_1v8A_Divided         => aSysMon_1v8A_Divided_n,
                      kSysMon_3v3D_Divided         => aSysMon_3v3D_Divided_n,
                      kSysMon_3v3A_Divided         => aSysMon_3v3A_Divided_n,
                      kSysMon_3v3VDMezz_Divided    => aSysMon_3v3VDMezz_Divided_n,
                      kSysMon_0v9MgtAvcc_Divided   => aSysMon_0v9MgtAvcc_Divided_n,
                      kSysMon_1v2_Divided          => aSysMon_1v2_Divided_n,
                      others                       => '0');

  --vhook_e IoRefClkSelect
  IoRefClkSelectx: entity work.IoRefClkSelect (rtl)
    port map (
      BusClk                   => BusClk,                    --in  std_logic
      abDiagramReset           => abDiagramReset,            --in  boolean
      bdSetIoRefClk100Enable   => bdSetIoRefClk100Enable,    --in  std_logic
      bdClearIoRefClk100Enable => bdClearIoRefClk100Enable,  --in  std_logic
      bdSetIoRefClk10Enable    => bdSetIoRefClk10Enable,     --in  std_logic
      bdClearIoRefClk10Enable  => bdClearIoRefClk10Enable,   --in  std_logic
      bdSelectIoRefClk100      => bdSelectIoRefClk100,       --in  std_logic
      bdSelectIoRefClk10       => bdSelectIoRefClk10,        --in  std_logic
      bdIoRefClk100Enabled     => bdIoRefClk100Enabled,      --out std_logic
      bdIoRefClk10Enabled      => bdIoRefClk10Enabled,       --out std_logic
      bdIoRefClkSwitch         => bdIoRefClkSwitch,          --out std_logic
      stEnableIoRefClk10       => stEnableIoRefClk10,        --out std_logic
      stEnableIoRefClk100      => stEnableIoRefClk100);      --out std_logic

  -- Outputs
  aIoRefClk100En  <= bdIoRefClk100Enabled;
  -- To TimingEngine
  aEnableClk10 <= false;

  ---------------------------------------------------------------------------------------
  -- IO BUFFERs
  ---------------------------------------------------------------------------------------

  --vhook_e  SasquatchIoBuffers
  --vhook_#  I2C Outputs
  --vhook_af {aI2c(Scl|Sda)$}(kMezzSmbIndex)            {bMezzSmb$1}                continue=true
  --vhook_af {aI2c(Scl|Sda)$}(kBaseSmbIndex)            {bBaseSmb$1}          continue=true
  --vhook_af {aI2c(Scl|Sda)$}(kConfigI2cIndex)          {bConfigI2c$1}        continue=true
  --vhook_af {aI2c(Scl|Sda)$}(kPwrSupplyPmbIndex)       {bPwrSupplyPmb$1}
  --vhook_#  Out Enables that are currently unused
  --vhook_a  aPxieDStarCEn_n                            '0'
  SasquatchIoBuffersx: entity work.SasquatchIoBuffers (struct)
    generic map (kNumI2cIfcs => kNumI2cIfcs)  --natural:=5
    port map (
      aI2cSclIn                   => aI2cSclIn,             --out std_logic_vector(kNumI2cIfcs-1:0)
      aI2cSclOut                  => aI2cSclOut,            --in  std_logic_vector(kNumI2cIfcs-1:0)
      aI2cSclTri                  => aI2cSclTri,            --in  std_logic_vector(kNumI2cIfcs-1:0)
      aI2cScl(kMezzSmbIndex)      => bMezzSmbScl,           --inout std_logic_vector(kNumI2cIfcs-1:0)
      aI2cScl(kBaseSmbIndex)      => bBaseSmbScl,           --inout std_logic_vector(kNumI2cIfcs-1:0)
      aI2cScl(kConfigI2cIndex)    => bConfigI2cScl,         --inout std_logic_vector(kNumI2cIfcs-1:0)
      aI2cScl(kPwrSupplyPmbIndex) => bPwrSupplyPmbScl,      --inout std_logic_vector(kNumI2cIfcs-1:0)
      aI2cSdaIn                   => aI2cSdaIn,             --out std_logic_vector(kNumI2cIfcs-1:0)
      aI2cSdaOut                  => aI2cSdaOut,            --in  std_logic_vector(kNumI2cIfcs-1:0)
      aI2cSdaTri                  => aI2cSdaTri,            --in  std_logic_vector(kNumI2cIfcs-1:0)
      aI2cSda(kMezzSmbIndex)      => bMezzSmbSda,           --inout std_logic_vector(kNumI2cIfcs-1:0)
      aI2cSda(kBaseSmbIndex)      => bBaseSmbSda,           --inout std_logic_vector(kNumI2cIfcs-1:0)
      aI2cSda(kConfigI2cIndex)    => bConfigI2cSda,         --inout std_logic_vector(kNumI2cIfcs-1:0)
      aI2cSda(kPwrSupplyPmbIndex) => bPwrSupplyPmbSda,      --inout std_logic_vector(kNumI2cIfcs-1:0)
      aPxiTrigDataIn              => aPxiTrigDataIn,        --out std_logic_vector(7:0)
      aPxiTrigDataOut             => aPxiTrigDataOut,       --in  std_logic_vector(7:0)
      aPxiTrigDataTri             => aPxiTrigDataTri,       --in  std_logic_vector(7:0)
      aPxiTrigData                => aPxiTrigData,          --inout std_logic_vector(7:0)
      aPxieDStarB                 => aPxieDStarB,           --out std_logic
      aPxieDStarB_p               => aPxieDStarB_p,         --in  std_logic
      aPxieDStarB_n               => aPxieDStarB_n,         --in  std_logic
      aPxieDStarC                 => aPxieDStarC,           --in  std_logic
      aPxieDStarCEn_n             => '0',                   --in  std_logic
      aPxieDStarC_p               => aPxieDStarC_p,         --out std_logic
      aPxieDStarC_n               => aPxieDStarC_n,         --out std_logic
      SidebandClk                 => SidebandClk,           --out std_logic
      sSidebandDataOut            => sSidebandDataOut,      --out std_logic_vector(3:0)
      aSidebandDataIn             => aSidebandDataIn,       --in  std_logic
      aSidebandFifoFull           => aSidebandFifoFull,     --in  std_logic
      SidebandClkBuf              => SidebandClkBuf,        --in  std_logic
      sSidebandDataOutBuf         => sSidebandDataOutBuf,   --in  std_logic_vector(3:0)
      aSidebandDataInBuf          => aSidebandDataInBuf,    --out std_logic
      aSidebandFifoFullBuf        => aSidebandFifoFullBuf,  --out std_logic
      aFpgaStage2Done             => aFpgaStage2Done);      --out std_logic

  --vhook_e SasquatchIoBuffersStage1
  SasquatchIoBuffersStage1x: entity work.SasquatchIoBuffersStage1 (struct)
    port map (
      aStage2Enabled => aStage2Enabled,  --in  boolean
      aAuthSda       => aAuthSda,        --inout std_logic
      aAuthSdaInBuf  => aAuthSdaInBuf,   --out std_logic
      aAuthSdaOutBuf => aAuthSdaOutBuf,  --in  std_logic
      aPxiGa         => aPxiGa,          --in  std_logic_vector(4:0)
      aGa            => aGa,             --out std_logic_vector(4:0)
      aPcieRst_n     => aPcieRst_n,      --in  std_logic
      aPcieRst       => aPcieRst);       --out std_logic

  aPxiTrigOutEn_n <= '0';

  ---------------------------------------------------------------------------------------
  -- DRAM Instantiation
  ---------------------------------------------------------------------------------------
  --vhook_e SasquatchDram
  SasquatchDramx: entity work.SasquatchDram (struct)
    port map (
      aDramPonReset         => aDramPonReset,          --in  boolean
      Dram0RefClk_p         => Dram0RefClk_p,          --in  std_logic
      Dram0RefClk_n         => Dram0RefClk_n,          --in  std_logic
      Dram1RefClk_p         => Dram1RefClk_p,          --in  std_logic
      Dram1RefClk_n         => Dram1RefClk_n,          --in  std_logic
      DramClkLvFpga         => DramClkLvFpga,          --out std_logic
      Dram0Clk_p            => Dram0Clk_p,             --out std_logic
      Dram0Clk_n            => Dram0Clk_n,             --out std_logic
      dr0DramCs_n           => dr0DramCs_n,            --out std_logic
      dr0DramAct_n          => dr0DramAct_n,           --out std_logic
      dr0DramAddr           => dr0DramAddr,            --out std_logic_vector(16:0)
      dr0DramBankAddr       => dr0DramBankAddr,        --out std_logic_vector(1:0)
      dr0DramBg             => dr0DramBg,              --out std_logic_vector(0:0)
      dr0DramClkEn          => dr0DramClkEn,           --out std_logic
      dr0DramOdt            => dr0DramOdt,             --out std_logic
      dr0DramReset_n        => dr0DramReset_n,         --out std_logic
      dr0DramDmDbi_n        => dr0DramDmDbi_n,         --inout std_logic_vector(9:0)
      dr0DramDq             => dr0DramDq,              --inout std_logic_vector(79:0)
      dr0DramDqs_p          => dr0DramDqs_p,           --inout std_logic_vector(9:0)
      dr0DramDqs_n          => dr0DramDqs_n,           --inout std_logic_vector(9:0)
      dr0DramTestMode       => dr0DramTestMode,        --out std_logic
      Dram0ClkUser          => Dram0ClkUser,           --out std_logic
      du0DramPhyInitDone    => du0DramPhyInitDone,     --out std_logic
      du0DramAddrFifoFull   => du0DramAddrFifoFull,    --out std_logic
      du0DramAddrFifoAddr   => du0DramAddrFifoAddr,    --in  std_logic_vector(29:0)
      du0DramAddrFifoCmd    => du0DramAddrFifoCmd,     --in  std_logic_vector(2:0)
      du0DramAddrFifoWrEn   => du0DramAddrFifoWrEn,    --in  std_logic
      du0DramWrFifoFull     => du0DramWrFifoFull,      --out std_logic
      du0DramWrFifoWrEn     => du0DramWrFifoWrEn,      --in  std_logic
      du0DramWrFifoDataIn   => du0DramWrFifoDataIn,    --in  std_logic_vector(639:0)
      du0DramWrFifoMaskData => du0DramWrFifoMaskData,  --in  std_logic_vector(79:0)
      du0DramRdDataValid    => du0DramRdDataValid,     --out std_logic
      du0DramRdFifoDataOut  => du0DramRdFifoDataOut,   --out std_logic_vector(639:0)
      Dram1Clk_p            => Dram1Clk_p,             --out std_logic
      Dram1Clk_n            => Dram1Clk_n,             --out std_logic
      dr1DramCs_n           => dr1DramCs_n,            --out std_logic
      dr1DramAct_n          => dr1DramAct_n,           --out std_logic
      dr1DramAddr           => dr1DramAddr,            --out std_logic_vector(16:0)
      dr1DramBankAddr       => dr1DramBankAddr,        --out std_logic_vector(1:0)
      dr1DramBg             => dr1DramBg,              --out std_logic_vector(0:0)
      dr1DramClkEn          => dr1DramClkEn,           --out std_logic
      dr1DramOdt            => dr1DramOdt,             --out std_logic
      dr1DramReset_n        => dr1DramReset_n,         --out std_logic
      dr1DramDmDbi_n        => dr1DramDmDbi_n,         --inout std_logic_vector(9:0)
      dr1DramDq             => dr1DramDq,              --inout std_logic_vector(79:0)
      dr1DramDqs_p          => dr1DramDqs_p,           --inout std_logic_vector(9:0)
      dr1DramDqs_n          => dr1DramDqs_n,           --inout std_logic_vector(9:0)
      dr1DramTestMode       => dr1DramTestMode,        --out std_logic
      Dram1ClkUser          => Dram1ClkUser,           --out std_logic
      du1DramPhyInitDone    => du1DramPhyInitDone,     --out std_logic
      du1DramAddrFifoFull   => du1DramAddrFifoFull,    --out std_logic
      du1DramAddrFifoAddr   => du1DramAddrFifoAddr,    --in  std_logic_vector(29:0)
      du1DramAddrFifoCmd    => du1DramAddrFifoCmd,     --in  std_logic_vector(2:0)
      du1DramAddrFifoWrEn   => du1DramAddrFifoWrEn,    --in  std_logic
      du1DramWrFifoFull     => du1DramWrFifoFull,      --out std_logic
      du1DramWrFifoWrEn     => du1DramWrFifoWrEn,      --in  std_logic
      du1DramWrFifoDataIn   => du1DramWrFifoDataIn,    --in  std_logic_vector(639:0)
      du1DramWrFifoMaskData => du1DramWrFifoMaskData,  --in  std_logic_vector(79:0)
      du1DramRdDataValid    => du1DramRdDataValid,     --out std_logic
      du1DramRdFifoDataOut  => du1DramRdFifoDataOut);  --out std_logic_vector(639:0)

  bRegPortOut.Data <= bLvWindowRegPortOut.Data or
                      bRegPortOutDram2DP.Data;

  bRegPortOut.DataValid <= bLvWindowRegPortOut.DataValid or
                           bRegPortOutDram2DP.DataValid;

  bRegPortOut.Ready <= bLvWindowRegPortOut.Ready and
                       bRegPortOutDram2DP.Ready;

  bAddressesDram2DP  <= (bRegportIn.Address >= kDram2DPBaseAddress) and
                        (bRegportIn.Address <= (kDram2DPBaseAddress + kDram2DPAddressMask));

  MergeRegPortInDram2DP: process(bRegportIn, bAddressesDram2DP)
  begin
    bRegPortInDram2DP <= bRegportIn;
    bRegPortInDram2DP.Rd <= bAddressesDram2DP and bRegportIn.Rd;
    bRegPortInDram2DP.Wt <= bAddressesDram2DP and bRegportIn.Wt;
    bRegPortInDram2DP.Address <= bRegportIn.Address and kDram2DPAddressMask;
  end process;


  -- Dram2DP is used to translate write and read requests from DRAM Interface in the Window
  -- to DMAPort requests in the fixed logic DMAPort
  -- Use DMAPort channel 0x3B, the 5th reserved channel
  Dram2DPx: entity work.Dram2DP (rtl)
    generic map (
      kSizeOfMemBuffers   => kSizeOfMemBuffers,
      kMaxNumOfMemBuffers => kMaxNumOfMemBuffers,
      kDmaChannelNum      => "0111011",
      kHmbInUse           => work.PkgLvFpgaConst.kInsertHostMemoryBufferMig,  -- in  boolean := true
      kLlbInUse           => work.PkgLvFpgaConst.kInsertLowLatencyBufferMig,  -- in  boolean := true
      kDefaultBaggage     => SetField(0, 16#00#, kNiDmaBaggageWidth),
      kDramInterfaceDataWidth => 1024)
    port map (
      aBusReset                   => to_stdlogic(aBusReset),
      BusClk                      => BusClk,
      bRegPortIn                  => bRegPortInDram2DP,
      bRegPortOut                 => bRegPortOutDram2DP,
      dHighSpeedSinkFromDma       => UnFlatten(dFlatHighSpeedSinkFromDma),
      dDramAddrFifoAddr           => dHmbDramAddrFifoAddr,
      dDramAddrFifoCmd            => dHmbDramAddrFifoCmd,
      dDramAddrFifoFull           => dHmbDramAddrFifoFull,
      dDramAddrFifoWrEn           => dHmbDramAddrFifoWrEn,
      dDramRdDataValid            => dHmbDramRdDataValid,
      dDramRdFifoDataOut          => dHmbDramRdFifoDataOut,
      dDramWrFifoDataIn           => dHmbDramWrFifoDataIn,
      dDramWrFifoFull             => dHmbDramWrFifoFull,
      dDramWrFifoMaskData         => dHmbDramWrFifoMaskData,
      dDramWrFifoWrEn             => dHmbDramWrFifoWrEn,
      dPhyInitDoneForLvfpga       => dHmbPhyInitDoneForLvfpga,
      dLlbDramAddrFifoAddr        => dLlbDramAddrFifoAddr,
      dLlbDramAddrFifoCmd         => dLlbDramAddrFifoCmd,
      dLlbDramAddrFifoFull        => dLlbDramAddrFifoFull,
      dLlbDramAddrFifoWrEn        => dLlbDramAddrFifoWrEn,
      dLlbDramRdDataValid         => dLlbDramRdDataValid,
      dLlbDramRdFifoDataOut       => dLlbDramRdFifoDataOut,
      dLlbDramWrFifoDataIn        => dLlbDramWrFifoDataIn,
      dLlbDramWrFifoFull          => dLlbDramWrFifoFull,
      dLlbDramWrFifoMaskData      => dLlbDramWrFifoMaskData,
      dLlbDramWrFifoWrEn          => dLlbDramWrFifoWrEn,
      dLlbPhyInitDoneForLvfpga    => dLlbPhyInitDoneForLvfpga,
      DMAClk                      => DmaClk,
      dNiFpgaInputRequestToDma    => dNiHmbInputRequestToDma,
      dNiFpgaInputRequestFromDma  => dNiHmbInputRequestFromDma,
      dNiFpgaInputDataToDma       => dNiHmbInputDataToDma,
      dNiFpgaInputDataFromDma     => dNiHmbInputDataFromDma,
      dNiFpgaInputStatusFromDma   => dNiHmbInputStatusFromDma,
      dNiFpgaOutputRequestToDma   => dNiHmbOutputRequestToDma,
      dNiFpgaOutputRequestFromDma => dNiHmbOutputRequestFromDma,
      dNiFpgaOutputDataFromDma    => dNiHmbOutputDataFromDma,
      dNiFpgaInputArbReq          => dNiHmbInputArbReq,
      dNiFpgaInputArbGrant        => dNiHmbInputArbGrant,
      dNiFpgaOutputArbReq         => dNiHmbOutputArbReq,
      dNiFpgaOutputArbGrant       => dNiHmbOutputArbGrant);


  SasquatchWindow: TheWindow
    port map (
      ------------------------
      -- CLIP ports copied over from TheWindowInstantiationExample.vhd
      ------------------------
      xIoModuleReady => xIoModuleReady,
      xIoModuleErrorCode => xIoModuleErrorCode,
      aDioOut => aDioOut,
      aDioIn => aDioIn,
      UserClkPort0 => UserClkPort0,
      aPort0PmaInit => aPort0PmaInit,
      aPort0ResetPb => aPort0ResetPb,
      uPort0AxiTxTData0 => uPort0AxiTxTData0,
      uPort0AxiTxTData1 => uPort0AxiTxTData1,
      uPort0AxiTxTData2 => uPort0AxiTxTData2,
      uPort0AxiTxTData3 => uPort0AxiTxTData3,
      uPort0AxiTxTKeep => uPort0AxiTxTKeep,
      uPort0AxiTxTLast => uPort0AxiTxTLast,
      uPort0AxiTxTValid => uPort0AxiTxTValid,
      uPort0AxiTxTReady => uPort0AxiTxTReady,
      uPort0AxiRxTData0 => uPort0AxiRxTData0,
      uPort0AxiRxTData1 => uPort0AxiRxTData1,
      uPort0AxiRxTData2 => uPort0AxiRxTData2,
      uPort0AxiRxTData3 => uPort0AxiRxTData3,
      uPort0AxiRxTKeep => uPort0AxiRxTKeep,
      uPort0AxiRxTLast => uPort0AxiRxTLast,
      uPort0AxiRxTValid => uPort0AxiRxTValid,
      uPort0AxiNfcTValid => uPort0AxiNfcTValid,
      uPort0AxiNfcTData => uPort0AxiNfcTData,
      uPort0AxiNfcTReady => uPort0AxiNfcTReady,
      uPort0HardError => uPort0HardError,
      uPort0SoftError => uPort0SoftError,
      uPort0LaneUp => uPort0LaneUp,
      uPort0ChannelUp => uPort0ChannelUp,
      uPort0SysResetOut => uPort0SysResetOut,
      uPort0MmcmNotLockOut => uPort0MmcmNotLockOut,
      uPort0CrcPassFail_n => uPort0CrcPassFail_n,
      uPort0CrcValid => uPort0CrcValid,
      iPort0LinkResetOut => iPort0LinkResetOut,
      sGtwiz0CtrlAxiAWAddr => sGtwiz0CtrlAxiAWAddr,
      sGtwiz0CtrlAxiAWValid => sGtwiz0CtrlAxiAWValid,
      sGtwiz0CtrlAxiAWReady => sGtwiz0CtrlAxiAWReady,
      sGtwiz0CtrlAxiWData => sGtwiz0CtrlAxiWData,
      sGtwiz0CtrlAxiWStrb => sGtwiz0CtrlAxiWStrb,
      sGtwiz0CtrlAxiWValid => sGtwiz0CtrlAxiWValid,
      sGtwiz0CtrlAxiWReady => sGtwiz0CtrlAxiWReady,
      sGtwiz0CtrlAxiBResp => sGtwiz0CtrlAxiBResp,
      sGtwiz0CtrlAxiBValid => sGtwiz0CtrlAxiBValid,
      sGtwiz0CtrlAxiBReady => sGtwiz0CtrlAxiBReady,
      sGtwiz0CtrlAxiARAddr => sGtwiz0CtrlAxiARAddr,
      sGtwiz0CtrlAxiARValid => sGtwiz0CtrlAxiARValid,
      sGtwiz0CtrlAxiARReady => sGtwiz0CtrlAxiARReady,
      sGtwiz0CtrlAxiRData => sGtwiz0CtrlAxiRData,
      sGtwiz0CtrlAxiRResp => sGtwiz0CtrlAxiRResp,
      sGtwiz0CtrlAxiRValid => sGtwiz0CtrlAxiRValid,
      sGtwiz0CtrlAxiRReady => sGtwiz0CtrlAxiRReady,
      sGtwiz0DrpChAxiAWAddr => sGtwiz0DrpChAxiAWAddr,
      sGtwiz0DrpChAxiAWValid => sGtwiz0DrpChAxiAWValid,
      sGtwiz0DrpChAxiAWReady => sGtwiz0DrpChAxiAWReady,
      sGtwiz0DrpChAxiWData => sGtwiz0DrpChAxiWData,
      sGtwiz0DrpChAxiWStrb => sGtwiz0DrpChAxiWStrb,
      sGtwiz0DrpChAxiWValid => sGtwiz0DrpChAxiWValid,
      sGtwiz0DrpChAxiWReady => sGtwiz0DrpChAxiWReady,
      sGtwiz0DrpChAxiBResp => sGtwiz0DrpChAxiBResp,
      sGtwiz0DrpChAxiBValid => sGtwiz0DrpChAxiBValid,
      sGtwiz0DrpChAxiBReady => sGtwiz0DrpChAxiBReady,
      sGtwiz0DrpChAxiARAddr => sGtwiz0DrpChAxiARAddr,
      sGtwiz0DrpChAxiARValid => sGtwiz0DrpChAxiARValid,
      sGtwiz0DrpChAxiARReady => sGtwiz0DrpChAxiARReady,
      sGtwiz0DrpChAxiRData => sGtwiz0DrpChAxiRData,
      sGtwiz0DrpChAxiRResp => sGtwiz0DrpChAxiRResp,
      sGtwiz0DrpChAxiRValid => sGtwiz0DrpChAxiRValid,
      sGtwiz0DrpChAxiRReady => sGtwiz0DrpChAxiRReady,
      UserClkPort1 => UserClkPort1,
      aPort1PmaInit => aPort1PmaInit,
      aPort1ResetPb => aPort1ResetPb,
      uPort1AxiTxTData0 => uPort1AxiTxTData0,
      uPort1AxiTxTData1 => uPort1AxiTxTData1,
      uPort1AxiTxTData2 => uPort1AxiTxTData2,
      uPort1AxiTxTData3 => uPort1AxiTxTData3,
      uPort1AxiTxTKeep => uPort1AxiTxTKeep,
      uPort1AxiTxTLast => uPort1AxiTxTLast,
      uPort1AxiTxTValid => uPort1AxiTxTValid,
      uPort1AxiTxTReady => uPort1AxiTxTReady,
      uPort1AxiRxTData0 => uPort1AxiRxTData0,
      uPort1AxiRxTData1 => uPort1AxiRxTData1,
      uPort1AxiRxTData2 => uPort1AxiRxTData2,
      uPort1AxiRxTData3 => uPort1AxiRxTData3,
      uPort1AxiRxTKeep => uPort1AxiRxTKeep,
      uPort1AxiRxTLast => uPort1AxiRxTLast,
      uPort1AxiRxTValid => uPort1AxiRxTValid,
      uPort1AxiNfcTValid => uPort1AxiNfcTValid,
      uPort1AxiNfcTData => uPort1AxiNfcTData,
      uPort1AxiNfcTReady => uPort1AxiNfcTReady,
      uPort1HardError => uPort1HardError,
      uPort1SoftError => uPort1SoftError,
      uPort1LaneUp => uPort1LaneUp,
      uPort1ChannelUp => uPort1ChannelUp,
      uPort1SysResetOut => uPort1SysResetOut,
      uPort1MmcmNotLockOut => uPort1MmcmNotLockOut,
      uPort1CrcPassFail_n => uPort1CrcPassFail_n,
      uPort1CrcValid => uPort1CrcValid,
      iPort1LinkResetOut => iPort1LinkResetOut,
      sGtwiz1CtrlAxiAWAddr => sGtwiz1CtrlAxiAWAddr,
      sGtwiz1CtrlAxiAWValid => sGtwiz1CtrlAxiAWValid,
      sGtwiz1CtrlAxiAWReady => sGtwiz1CtrlAxiAWReady,
      sGtwiz1CtrlAxiWData => sGtwiz1CtrlAxiWData,
      sGtwiz1CtrlAxiWStrb => sGtwiz1CtrlAxiWStrb,
      sGtwiz1CtrlAxiWValid => sGtwiz1CtrlAxiWValid,
      sGtwiz1CtrlAxiWReady => sGtwiz1CtrlAxiWReady,
      sGtwiz1CtrlAxiBResp => sGtwiz1CtrlAxiBResp,
      sGtwiz1CtrlAxiBValid => sGtwiz1CtrlAxiBValid,
      sGtwiz1CtrlAxiBReady => sGtwiz1CtrlAxiBReady,
      sGtwiz1CtrlAxiARAddr => sGtwiz1CtrlAxiARAddr,
      sGtwiz1CtrlAxiARValid => sGtwiz1CtrlAxiARValid,
      sGtwiz1CtrlAxiARReady => sGtwiz1CtrlAxiARReady,
      sGtwiz1CtrlAxiRData => sGtwiz1CtrlAxiRData,
      sGtwiz1CtrlAxiRResp => sGtwiz1CtrlAxiRResp,
      sGtwiz1CtrlAxiRValid => sGtwiz1CtrlAxiRValid,
      sGtwiz1CtrlAxiRReady => sGtwiz1CtrlAxiRReady,
      sGtwiz1DrpChAxiAWAddr => sGtwiz1DrpChAxiAWAddr,
      sGtwiz1DrpChAxiAWValid => sGtwiz1DrpChAxiAWValid,
      sGtwiz1DrpChAxiAWReady => sGtwiz1DrpChAxiAWReady,
      sGtwiz1DrpChAxiWData => sGtwiz1DrpChAxiWData,
      sGtwiz1DrpChAxiWStrb => sGtwiz1DrpChAxiWStrb,
      sGtwiz1DrpChAxiWValid => sGtwiz1DrpChAxiWValid,
      sGtwiz1DrpChAxiWReady => sGtwiz1DrpChAxiWReady,
      sGtwiz1DrpChAxiBResp => sGtwiz1DrpChAxiBResp,
      sGtwiz1DrpChAxiBValid => sGtwiz1DrpChAxiBValid,
      sGtwiz1DrpChAxiBReady => sGtwiz1DrpChAxiBReady,
      sGtwiz1DrpChAxiARAddr => sGtwiz1DrpChAxiARAddr,
      sGtwiz1DrpChAxiARValid => sGtwiz1DrpChAxiARValid,
      sGtwiz1DrpChAxiARReady => sGtwiz1DrpChAxiARReady,
      sGtwiz1DrpChAxiRData => sGtwiz1DrpChAxiRData,
      sGtwiz1DrpChAxiRResp => sGtwiz1DrpChAxiRResp,
      sGtwiz1DrpChAxiRValid => sGtwiz1DrpChAxiRValid,
      sGtwiz1DrpChAxiRReady => sGtwiz1DrpChAxiRReady,
      UserClkPort2 => UserClkPort2,
      aPort2PmaInit => aPort2PmaInit,
      aPort2ResetPb => aPort2ResetPb,
      uPort2AxiTxTData0 => uPort2AxiTxTData0,
      uPort2AxiTxTData1 => uPort2AxiTxTData1,
      uPort2AxiTxTData2 => uPort2AxiTxTData2,
      uPort2AxiTxTData3 => uPort2AxiTxTData3,
      uPort2AxiTxTKeep => uPort2AxiTxTKeep,
      uPort2AxiTxTLast => uPort2AxiTxTLast,
      uPort2AxiTxTValid => uPort2AxiTxTValid,
      uPort2AxiTxTReady => uPort2AxiTxTReady,
      uPort2AxiRxTData0 => uPort2AxiRxTData0,
      uPort2AxiRxTData1 => uPort2AxiRxTData1,
      uPort2AxiRxTData2 => uPort2AxiRxTData2,
      uPort2AxiRxTData3 => uPort2AxiRxTData3,
      uPort2AxiRxTKeep => uPort2AxiRxTKeep,
      uPort2AxiRxTLast => uPort2AxiRxTLast,
      uPort2AxiRxTValid => uPort2AxiRxTValid,
      uPort2AxiNfcTValid => uPort2AxiNfcTValid,
      uPort2AxiNfcTData => uPort2AxiNfcTData,
      uPort2AxiNfcTReady => uPort2AxiNfcTReady,
      uPort2HardError => uPort2HardError,
      uPort2SoftError => uPort2SoftError,
      uPort2LaneUp => uPort2LaneUp,
      uPort2ChannelUp => uPort2ChannelUp,
      uPort2SysResetOut => uPort2SysResetOut,
      uPort2MmcmNotLockOut => uPort2MmcmNotLockOut,
      uPort2CrcPassFail_n => uPort2CrcPassFail_n,
      uPort2CrcValid => uPort2CrcValid,
      iPort2LinkResetOut => iPort2LinkResetOut,
      sGtwiz2CtrlAxiAWAddr => sGtwiz2CtrlAxiAWAddr,
      sGtwiz2CtrlAxiAWValid => sGtwiz2CtrlAxiAWValid,
      sGtwiz2CtrlAxiAWReady => sGtwiz2CtrlAxiAWReady,
      sGtwiz2CtrlAxiWData => sGtwiz2CtrlAxiWData,
      sGtwiz2CtrlAxiWStrb => sGtwiz2CtrlAxiWStrb,
      sGtwiz2CtrlAxiWValid => sGtwiz2CtrlAxiWValid,
      sGtwiz2CtrlAxiWReady => sGtwiz2CtrlAxiWReady,
      sGtwiz2CtrlAxiBResp => sGtwiz2CtrlAxiBResp,
      sGtwiz2CtrlAxiBValid => sGtwiz2CtrlAxiBValid,
      sGtwiz2CtrlAxiBReady => sGtwiz2CtrlAxiBReady,
      sGtwiz2CtrlAxiARAddr => sGtwiz2CtrlAxiARAddr,
      sGtwiz2CtrlAxiARValid => sGtwiz2CtrlAxiARValid,
      sGtwiz2CtrlAxiARReady => sGtwiz2CtrlAxiARReady,
      sGtwiz2CtrlAxiRData => sGtwiz2CtrlAxiRData,
      sGtwiz2CtrlAxiRResp => sGtwiz2CtrlAxiRResp,
      sGtwiz2CtrlAxiRValid => sGtwiz2CtrlAxiRValid,
      sGtwiz2CtrlAxiRReady => sGtwiz2CtrlAxiRReady,
      sGtwiz2DrpChAxiAWAddr => sGtwiz2DrpChAxiAWAddr,
      sGtwiz2DrpChAxiAWValid => sGtwiz2DrpChAxiAWValid,
      sGtwiz2DrpChAxiAWReady => sGtwiz2DrpChAxiAWReady,
      sGtwiz2DrpChAxiWData => sGtwiz2DrpChAxiWData,
      sGtwiz2DrpChAxiWStrb => sGtwiz2DrpChAxiWStrb,
      sGtwiz2DrpChAxiWValid => sGtwiz2DrpChAxiWValid,
      sGtwiz2DrpChAxiWReady => sGtwiz2DrpChAxiWReady,
      sGtwiz2DrpChAxiBResp => sGtwiz2DrpChAxiBResp,
      sGtwiz2DrpChAxiBValid => sGtwiz2DrpChAxiBValid,
      sGtwiz2DrpChAxiBReady => sGtwiz2DrpChAxiBReady,
      sGtwiz2DrpChAxiARAddr => sGtwiz2DrpChAxiARAddr,
      sGtwiz2DrpChAxiARValid => sGtwiz2DrpChAxiARValid,
      sGtwiz2DrpChAxiARReady => sGtwiz2DrpChAxiARReady,
      sGtwiz2DrpChAxiRData => sGtwiz2DrpChAxiRData,
      sGtwiz2DrpChAxiRResp => sGtwiz2DrpChAxiRResp,
      sGtwiz2DrpChAxiRValid => sGtwiz2DrpChAxiRValid,
      sGtwiz2DrpChAxiRReady => sGtwiz2DrpChAxiRReady,
      UserClkPort3 => UserClkPort3,
      aPort3PmaInit => aPort3PmaInit,
      aPort3ResetPb => aPort3ResetPb,
      uPort3AxiTxTData0 => uPort3AxiTxTData0,
      uPort3AxiTxTData1 => uPort3AxiTxTData1,
      uPort3AxiTxTData2 => uPort3AxiTxTData2,
      uPort3AxiTxTData3 => uPort3AxiTxTData3,
      uPort3AxiTxTKeep => uPort3AxiTxTKeep,
      uPort3AxiTxTLast => uPort3AxiTxTLast,
      uPort3AxiTxTValid => uPort3AxiTxTValid,
      uPort3AxiTxTReady => uPort3AxiTxTReady,
      uPort3AxiRxTData0 => uPort3AxiRxTData0,
      uPort3AxiRxTData1 => uPort3AxiRxTData1,
      uPort3AxiRxTData2 => uPort3AxiRxTData2,
      uPort3AxiRxTData3 => uPort3AxiRxTData3,
      uPort3AxiRxTKeep => uPort3AxiRxTKeep,
      uPort3AxiRxTLast => uPort3AxiRxTLast,
      uPort3AxiRxTValid => uPort3AxiRxTValid,
      uPort3AxiNfcTValid => uPort3AxiNfcTValid,
      uPort3AxiNfcTData => uPort3AxiNfcTData,
      uPort3AxiNfcTReady => uPort3AxiNfcTReady,
      uPort3HardError => uPort3HardError,
      uPort3SoftError => uPort3SoftError,
      uPort3LaneUp => uPort3LaneUp,
      uPort3ChannelUp => uPort3ChannelUp,
      uPort3SysResetOut => uPort3SysResetOut,
      uPort3MmcmNotLockOut => uPort3MmcmNotLockOut,
      uPort3CrcPassFail_n => uPort3CrcPassFail_n,
      uPort3CrcValid => uPort3CrcValid,
      iPort3LinkResetOut => iPort3LinkResetOut,
      sGtwiz3CtrlAxiAWAddr => sGtwiz3CtrlAxiAWAddr,
      sGtwiz3CtrlAxiAWValid => sGtwiz3CtrlAxiAWValid,
      sGtwiz3CtrlAxiAWReady => sGtwiz3CtrlAxiAWReady,
      sGtwiz3CtrlAxiWData => sGtwiz3CtrlAxiWData,
      sGtwiz3CtrlAxiWStrb => sGtwiz3CtrlAxiWStrb,
      sGtwiz3CtrlAxiWValid => sGtwiz3CtrlAxiWValid,
      sGtwiz3CtrlAxiWReady => sGtwiz3CtrlAxiWReady,
      sGtwiz3CtrlAxiBResp => sGtwiz3CtrlAxiBResp,
      sGtwiz3CtrlAxiBValid => sGtwiz3CtrlAxiBValid,
      sGtwiz3CtrlAxiBReady => sGtwiz3CtrlAxiBReady,
      sGtwiz3CtrlAxiARAddr => sGtwiz3CtrlAxiARAddr,
      sGtwiz3CtrlAxiARValid => sGtwiz3CtrlAxiARValid,
      sGtwiz3CtrlAxiARReady => sGtwiz3CtrlAxiARReady,
      sGtwiz3CtrlAxiRData => sGtwiz3CtrlAxiRData,
      sGtwiz3CtrlAxiRResp => sGtwiz3CtrlAxiRResp,
      sGtwiz3CtrlAxiRValid => sGtwiz3CtrlAxiRValid,
      sGtwiz3CtrlAxiRReady => sGtwiz3CtrlAxiRReady,
      sGtwiz3DrpChAxiAWAddr => sGtwiz3DrpChAxiAWAddr,
      sGtwiz3DrpChAxiAWValid => sGtwiz3DrpChAxiAWValid,
      sGtwiz3DrpChAxiAWReady => sGtwiz3DrpChAxiAWReady,
      sGtwiz3DrpChAxiWData => sGtwiz3DrpChAxiWData,
      sGtwiz3DrpChAxiWStrb => sGtwiz3DrpChAxiWStrb,
      sGtwiz3DrpChAxiWValid => sGtwiz3DrpChAxiWValid,
      sGtwiz3DrpChAxiWReady => sGtwiz3DrpChAxiWReady,
      sGtwiz3DrpChAxiBResp => sGtwiz3DrpChAxiBResp,
      sGtwiz3DrpChAxiBValid => sGtwiz3DrpChAxiBValid,
      sGtwiz3DrpChAxiBReady => sGtwiz3DrpChAxiBReady,
      sGtwiz3DrpChAxiARAddr => sGtwiz3DrpChAxiARAddr,
      sGtwiz3DrpChAxiARValid => sGtwiz3DrpChAxiARValid,
      sGtwiz3DrpChAxiARReady => sGtwiz3DrpChAxiARReady,
      sGtwiz3DrpChAxiRData => sGtwiz3DrpChAxiRData,
      sGtwiz3DrpChAxiRResp => sGtwiz3DrpChAxiRResp,
      sGtwiz3DrpChAxiRValid => sGtwiz3DrpChAxiRValid,
      sGtwiz3DrpChAxiRReady => sGtwiz3DrpChAxiRReady,
      UserClkPort4 => UserClkPort4,
      aPort4PmaInit => aPort4PmaInit,
      aPort4ResetPb => aPort4ResetPb,
      uPort4AxiTxTData0 => uPort4AxiTxTData0,
      uPort4AxiTxTData1 => uPort4AxiTxTData1,
      uPort4AxiTxTData2 => uPort4AxiTxTData2,
      uPort4AxiTxTData3 => uPort4AxiTxTData3,
      uPort4AxiTxTKeep => uPort4AxiTxTKeep,
      uPort4AxiTxTLast => uPort4AxiTxTLast,
      uPort4AxiTxTValid => uPort4AxiTxTValid,
      uPort4AxiTxTReady => uPort4AxiTxTReady,
      uPort4AxiRxTData0 => uPort4AxiRxTData0,
      uPort4AxiRxTData1 => uPort4AxiRxTData1,
      uPort4AxiRxTData2 => uPort4AxiRxTData2,
      uPort4AxiRxTData3 => uPort4AxiRxTData3,
      uPort4AxiRxTKeep => uPort4AxiRxTKeep,
      uPort4AxiRxTLast => uPort4AxiRxTLast,
      uPort4AxiRxTValid => uPort4AxiRxTValid,
      uPort4AxiNfcTValid => uPort4AxiNfcTValid,
      uPort4AxiNfcTData => uPort4AxiNfcTData,
      uPort4AxiNfcTReady => uPort4AxiNfcTReady,
      uPort4HardError => uPort4HardError,
      uPort4SoftError => uPort4SoftError,
      uPort4LaneUp => uPort4LaneUp,
      uPort4ChannelUp => uPort4ChannelUp,
      uPort4SysResetOut => uPort4SysResetOut,
      uPort4MmcmNotLockOut => uPort4MmcmNotLockOut,
      uPort4CrcPassFail_n => uPort4CrcPassFail_n,
      uPort4CrcValid => uPort4CrcValid,
      iPort4LinkResetOut => iPort4LinkResetOut,
      sGtwiz4CtrlAxiAWAddr => sGtwiz4CtrlAxiAWAddr,
      sGtwiz4CtrlAxiAWValid => sGtwiz4CtrlAxiAWValid,
      sGtwiz4CtrlAxiAWReady => sGtwiz4CtrlAxiAWReady,
      sGtwiz4CtrlAxiWData => sGtwiz4CtrlAxiWData,
      sGtwiz4CtrlAxiWStrb => sGtwiz4CtrlAxiWStrb,
      sGtwiz4CtrlAxiWValid => sGtwiz4CtrlAxiWValid,
      sGtwiz4CtrlAxiWReady => sGtwiz4CtrlAxiWReady,
      sGtwiz4CtrlAxiBResp => sGtwiz4CtrlAxiBResp,
      sGtwiz4CtrlAxiBValid => sGtwiz4CtrlAxiBValid,
      sGtwiz4CtrlAxiBReady => sGtwiz4CtrlAxiBReady,
      sGtwiz4CtrlAxiARAddr => sGtwiz4CtrlAxiARAddr,
      sGtwiz4CtrlAxiARValid => sGtwiz4CtrlAxiARValid,
      sGtwiz4CtrlAxiARReady => sGtwiz4CtrlAxiARReady,
      sGtwiz4CtrlAxiRData => sGtwiz4CtrlAxiRData,
      sGtwiz4CtrlAxiRResp => sGtwiz4CtrlAxiRResp,
      sGtwiz4CtrlAxiRValid => sGtwiz4CtrlAxiRValid,
      sGtwiz4CtrlAxiRReady => sGtwiz4CtrlAxiRReady,
      sGtwiz4DrpChAxiAWAddr => sGtwiz4DrpChAxiAWAddr,
      sGtwiz4DrpChAxiAWValid => sGtwiz4DrpChAxiAWValid,
      sGtwiz4DrpChAxiAWReady => sGtwiz4DrpChAxiAWReady,
      sGtwiz4DrpChAxiWData => sGtwiz4DrpChAxiWData,
      sGtwiz4DrpChAxiWStrb => sGtwiz4DrpChAxiWStrb,
      sGtwiz4DrpChAxiWValid => sGtwiz4DrpChAxiWValid,
      sGtwiz4DrpChAxiWReady => sGtwiz4DrpChAxiWReady,
      sGtwiz4DrpChAxiBResp => sGtwiz4DrpChAxiBResp,
      sGtwiz4DrpChAxiBValid => sGtwiz4DrpChAxiBValid,
      sGtwiz4DrpChAxiBReady => sGtwiz4DrpChAxiBReady,
      sGtwiz4DrpChAxiARAddr => sGtwiz4DrpChAxiARAddr,
      sGtwiz4DrpChAxiARValid => sGtwiz4DrpChAxiARValid,
      sGtwiz4DrpChAxiARReady => sGtwiz4DrpChAxiARReady,
      sGtwiz4DrpChAxiRData => sGtwiz4DrpChAxiRData,
      sGtwiz4DrpChAxiRResp => sGtwiz4DrpChAxiRResp,
      sGtwiz4DrpChAxiRValid => sGtwiz4DrpChAxiRValid,
      sGtwiz4DrpChAxiRReady => sGtwiz4DrpChAxiRReady,
      UserClkPort5 => UserClkPort5,
      aPort5PmaInit => aPort5PmaInit,
      aPort5ResetPb => aPort5ResetPb,
      uPort5AxiTxTData0 => uPort5AxiTxTData0,
      uPort5AxiTxTData1 => uPort5AxiTxTData1,
      uPort5AxiTxTData2 => uPort5AxiTxTData2,
      uPort5AxiTxTData3 => uPort5AxiTxTData3,
      uPort5AxiTxTKeep => uPort5AxiTxTKeep,
      uPort5AxiTxTLast => uPort5AxiTxTLast,
      uPort5AxiTxTValid => uPort5AxiTxTValid,
      uPort5AxiTxTReady => uPort5AxiTxTReady,
      uPort5AxiRxTData0 => uPort5AxiRxTData0,
      uPort5AxiRxTData1 => uPort5AxiRxTData1,
      uPort5AxiRxTData2 => uPort5AxiRxTData2,
      uPort5AxiRxTData3 => uPort5AxiRxTData3,
      uPort5AxiRxTKeep => uPort5AxiRxTKeep,
      uPort5AxiRxTLast => uPort5AxiRxTLast,
      uPort5AxiRxTValid => uPort5AxiRxTValid,
      uPort5AxiNfcTValid => uPort5AxiNfcTValid,
      uPort5AxiNfcTData => uPort5AxiNfcTData,
      uPort5AxiNfcTReady => uPort5AxiNfcTReady,
      uPort5HardError => uPort5HardError,
      uPort5SoftError => uPort5SoftError,
      uPort5LaneUp => uPort5LaneUp,
      uPort5ChannelUp => uPort5ChannelUp,
      uPort5SysResetOut => uPort5SysResetOut,
      uPort5MmcmNotLockOut => uPort5MmcmNotLockOut,
      uPort5CrcPassFail_n => uPort5CrcPassFail_n,
      uPort5CrcValid => uPort5CrcValid,
      iPort5LinkResetOut => iPort5LinkResetOut,
      sGtwiz5CtrlAxiAWAddr => sGtwiz5CtrlAxiAWAddr,
      sGtwiz5CtrlAxiAWValid => sGtwiz5CtrlAxiAWValid,
      sGtwiz5CtrlAxiAWReady => sGtwiz5CtrlAxiAWReady,
      sGtwiz5CtrlAxiWData => sGtwiz5CtrlAxiWData,
      sGtwiz5CtrlAxiWStrb => sGtwiz5CtrlAxiWStrb,
      sGtwiz5CtrlAxiWValid => sGtwiz5CtrlAxiWValid,
      sGtwiz5CtrlAxiWReady => sGtwiz5CtrlAxiWReady,
      sGtwiz5CtrlAxiBResp => sGtwiz5CtrlAxiBResp,
      sGtwiz5CtrlAxiBValid => sGtwiz5CtrlAxiBValid,
      sGtwiz5CtrlAxiBReady => sGtwiz5CtrlAxiBReady,
      sGtwiz5CtrlAxiARAddr => sGtwiz5CtrlAxiARAddr,
      sGtwiz5CtrlAxiARValid => sGtwiz5CtrlAxiARValid,
      sGtwiz5CtrlAxiARReady => sGtwiz5CtrlAxiARReady,
      sGtwiz5CtrlAxiRData => sGtwiz5CtrlAxiRData,
      sGtwiz5CtrlAxiRResp => sGtwiz5CtrlAxiRResp,
      sGtwiz5CtrlAxiRValid => sGtwiz5CtrlAxiRValid,
      sGtwiz5CtrlAxiRReady => sGtwiz5CtrlAxiRReady,
      sGtwiz5DrpChAxiAWAddr => sGtwiz5DrpChAxiAWAddr,
      sGtwiz5DrpChAxiAWValid => sGtwiz5DrpChAxiAWValid,
      sGtwiz5DrpChAxiAWReady => sGtwiz5DrpChAxiAWReady,
      sGtwiz5DrpChAxiWData => sGtwiz5DrpChAxiWData,
      sGtwiz5DrpChAxiWStrb => sGtwiz5DrpChAxiWStrb,
      sGtwiz5DrpChAxiWValid => sGtwiz5DrpChAxiWValid,
      sGtwiz5DrpChAxiWReady => sGtwiz5DrpChAxiWReady,
      sGtwiz5DrpChAxiBResp => sGtwiz5DrpChAxiBResp,
      sGtwiz5DrpChAxiBValid => sGtwiz5DrpChAxiBValid,
      sGtwiz5DrpChAxiBReady => sGtwiz5DrpChAxiBReady,
      sGtwiz5DrpChAxiARAddr => sGtwiz5DrpChAxiARAddr,
      sGtwiz5DrpChAxiARValid => sGtwiz5DrpChAxiARValid,
      sGtwiz5DrpChAxiARReady => sGtwiz5DrpChAxiARReady,
      sGtwiz5DrpChAxiRData => sGtwiz5DrpChAxiRData,
      sGtwiz5DrpChAxiRResp => sGtwiz5DrpChAxiRResp,
      sGtwiz5DrpChAxiRValid => sGtwiz5DrpChAxiRValid,
      sGtwiz5DrpChAxiRReady => sGtwiz5DrpChAxiRReady,
      UserClkPort6 => UserClkPort6,
      aPort6PmaInit => aPort6PmaInit,
      aPort6ResetPb => aPort6ResetPb,
      uPort6AxiTxTData0 => uPort6AxiTxTData0,
      uPort6AxiTxTData1 => uPort6AxiTxTData1,
      uPort6AxiTxTData2 => uPort6AxiTxTData2,
      uPort6AxiTxTData3 => uPort6AxiTxTData3,
      uPort6AxiTxTKeep => uPort6AxiTxTKeep,
      uPort6AxiTxTLast => uPort6AxiTxTLast,
      uPort6AxiTxTValid => uPort6AxiTxTValid,
      uPort6AxiTxTReady => uPort6AxiTxTReady,
      uPort6AxiRxTData0 => uPort6AxiRxTData0,
      uPort6AxiRxTData1 => uPort6AxiRxTData1,
      uPort6AxiRxTData2 => uPort6AxiRxTData2,
      uPort6AxiRxTData3 => uPort6AxiRxTData3,
      uPort6AxiRxTKeep => uPort6AxiRxTKeep,
      uPort6AxiRxTLast => uPort6AxiRxTLast,
      uPort6AxiRxTValid => uPort6AxiRxTValid,
      uPort6AxiNfcTValid => uPort6AxiNfcTValid,
      uPort6AxiNfcTData => uPort6AxiNfcTData,
      uPort6AxiNfcTReady => uPort6AxiNfcTReady,
      uPort6HardError => uPort6HardError,
      uPort6SoftError => uPort6SoftError,
      uPort6LaneUp => uPort6LaneUp,
      uPort6ChannelUp => uPort6ChannelUp,
      uPort6SysResetOut => uPort6SysResetOut,
      uPort6MmcmNotLockOut => uPort6MmcmNotLockOut,
      uPort6CrcPassFail_n => uPort6CrcPassFail_n,
      uPort6CrcValid => uPort6CrcValid,
      iPort6LinkResetOut => iPort6LinkResetOut,
      sGtwiz6CtrlAxiAWAddr => sGtwiz6CtrlAxiAWAddr,
      sGtwiz6CtrlAxiAWValid => sGtwiz6CtrlAxiAWValid,
      sGtwiz6CtrlAxiAWReady => sGtwiz6CtrlAxiAWReady,
      sGtwiz6CtrlAxiWData => sGtwiz6CtrlAxiWData,
      sGtwiz6CtrlAxiWStrb => sGtwiz6CtrlAxiWStrb,
      sGtwiz6CtrlAxiWValid => sGtwiz6CtrlAxiWValid,
      sGtwiz6CtrlAxiWReady => sGtwiz6CtrlAxiWReady,
      sGtwiz6CtrlAxiBResp => sGtwiz6CtrlAxiBResp,
      sGtwiz6CtrlAxiBValid => sGtwiz6CtrlAxiBValid,
      sGtwiz6CtrlAxiBReady => sGtwiz6CtrlAxiBReady,
      sGtwiz6CtrlAxiARAddr => sGtwiz6CtrlAxiARAddr,
      sGtwiz6CtrlAxiARValid => sGtwiz6CtrlAxiARValid,
      sGtwiz6CtrlAxiARReady => sGtwiz6CtrlAxiARReady,
      sGtwiz6CtrlAxiRData => sGtwiz6CtrlAxiRData,
      sGtwiz6CtrlAxiRResp => sGtwiz6CtrlAxiRResp,
      sGtwiz6CtrlAxiRValid => sGtwiz6CtrlAxiRValid,
      sGtwiz6CtrlAxiRReady => sGtwiz6CtrlAxiRReady,
      sGtwiz6DrpChAxiAWAddr => sGtwiz6DrpChAxiAWAddr,
      sGtwiz6DrpChAxiAWValid => sGtwiz6DrpChAxiAWValid,
      sGtwiz6DrpChAxiAWReady => sGtwiz6DrpChAxiAWReady,
      sGtwiz6DrpChAxiWData => sGtwiz6DrpChAxiWData,
      sGtwiz6DrpChAxiWStrb => sGtwiz6DrpChAxiWStrb,
      sGtwiz6DrpChAxiWValid => sGtwiz6DrpChAxiWValid,
      sGtwiz6DrpChAxiWReady => sGtwiz6DrpChAxiWReady,
      sGtwiz6DrpChAxiBResp => sGtwiz6DrpChAxiBResp,
      sGtwiz6DrpChAxiBValid => sGtwiz6DrpChAxiBValid,
      sGtwiz6DrpChAxiBReady => sGtwiz6DrpChAxiBReady,
      sGtwiz6DrpChAxiARAddr => sGtwiz6DrpChAxiARAddr,
      sGtwiz6DrpChAxiARValid => sGtwiz6DrpChAxiARValid,
      sGtwiz6DrpChAxiARReady => sGtwiz6DrpChAxiARReady,
      sGtwiz6DrpChAxiRData => sGtwiz6DrpChAxiRData,
      sGtwiz6DrpChAxiRResp => sGtwiz6DrpChAxiRResp,
      sGtwiz6DrpChAxiRValid => sGtwiz6DrpChAxiRValid,
      sGtwiz6DrpChAxiRReady => sGtwiz6DrpChAxiRReady,
      UserClkPort7 => UserClkPort7,
      aPort7PmaInit => aPort7PmaInit,
      aPort7ResetPb => aPort7ResetPb,
      uPort7AxiTxTData0 => uPort7AxiTxTData0,
      uPort7AxiTxTData1 => uPort7AxiTxTData1,
      uPort7AxiTxTData2 => uPort7AxiTxTData2,
      uPort7AxiTxTData3 => uPort7AxiTxTData3,
      uPort7AxiTxTKeep => uPort7AxiTxTKeep,
      uPort7AxiTxTLast => uPort7AxiTxTLast,
      uPort7AxiTxTValid => uPort7AxiTxTValid,
      uPort7AxiTxTReady => uPort7AxiTxTReady,
      uPort7AxiRxTData0 => uPort7AxiRxTData0,
      uPort7AxiRxTData1 => uPort7AxiRxTData1,
      uPort7AxiRxTData2 => uPort7AxiRxTData2,
      uPort7AxiRxTData3 => uPort7AxiRxTData3,
      uPort7AxiRxTKeep => uPort7AxiRxTKeep,
      uPort7AxiRxTLast => uPort7AxiRxTLast,
      uPort7AxiRxTValid => uPort7AxiRxTValid,
      uPort7AxiNfcTValid => uPort7AxiNfcTValid,
      uPort7AxiNfcTData => uPort7AxiNfcTData,
      uPort7AxiNfcTReady => uPort7AxiNfcTReady,
      uPort7HardError => uPort7HardError,
      uPort7SoftError => uPort7SoftError,
      uPort7LaneUp => uPort7LaneUp,
      uPort7ChannelUp => uPort7ChannelUp,
      uPort7SysResetOut => uPort7SysResetOut,
      uPort7MmcmNotLockOut => uPort7MmcmNotLockOut,
      uPort7CrcPassFail_n => uPort7CrcPassFail_n,
      uPort7CrcValid => uPort7CrcValid,
      iPort7LinkResetOut => iPort7LinkResetOut,
      sGtwiz7CtrlAxiAWAddr => sGtwiz7CtrlAxiAWAddr,
      sGtwiz7CtrlAxiAWValid => sGtwiz7CtrlAxiAWValid,
      sGtwiz7CtrlAxiAWReady => sGtwiz7CtrlAxiAWReady,
      sGtwiz7CtrlAxiWData => sGtwiz7CtrlAxiWData,
      sGtwiz7CtrlAxiWStrb => sGtwiz7CtrlAxiWStrb,
      sGtwiz7CtrlAxiWValid => sGtwiz7CtrlAxiWValid,
      sGtwiz7CtrlAxiWReady => sGtwiz7CtrlAxiWReady,
      sGtwiz7CtrlAxiBResp => sGtwiz7CtrlAxiBResp,
      sGtwiz7CtrlAxiBValid => sGtwiz7CtrlAxiBValid,
      sGtwiz7CtrlAxiBReady => sGtwiz7CtrlAxiBReady,
      sGtwiz7CtrlAxiARAddr => sGtwiz7CtrlAxiARAddr,
      sGtwiz7CtrlAxiARValid => sGtwiz7CtrlAxiARValid,
      sGtwiz7CtrlAxiARReady => sGtwiz7CtrlAxiARReady,
      sGtwiz7CtrlAxiRData => sGtwiz7CtrlAxiRData,
      sGtwiz7CtrlAxiRResp => sGtwiz7CtrlAxiRResp,
      sGtwiz7CtrlAxiRValid => sGtwiz7CtrlAxiRValid,
      sGtwiz7CtrlAxiRReady => sGtwiz7CtrlAxiRReady,
      sGtwiz7DrpChAxiAWAddr => sGtwiz7DrpChAxiAWAddr,
      sGtwiz7DrpChAxiAWValid => sGtwiz7DrpChAxiAWValid,
      sGtwiz7DrpChAxiAWReady => sGtwiz7DrpChAxiAWReady,
      sGtwiz7DrpChAxiWData => sGtwiz7DrpChAxiWData,
      sGtwiz7DrpChAxiWStrb => sGtwiz7DrpChAxiWStrb,
      sGtwiz7DrpChAxiWValid => sGtwiz7DrpChAxiWValid,
      sGtwiz7DrpChAxiWReady => sGtwiz7DrpChAxiWReady,
      sGtwiz7DrpChAxiBResp => sGtwiz7DrpChAxiBResp,
      sGtwiz7DrpChAxiBValid => sGtwiz7DrpChAxiBValid,
      sGtwiz7DrpChAxiBReady => sGtwiz7DrpChAxiBReady,
      sGtwiz7DrpChAxiARAddr => sGtwiz7DrpChAxiARAddr,
      sGtwiz7DrpChAxiARValid => sGtwiz7DrpChAxiARValid,
      sGtwiz7DrpChAxiARReady => sGtwiz7DrpChAxiARReady,
      sGtwiz7DrpChAxiRData => sGtwiz7DrpChAxiRData,
      sGtwiz7DrpChAxiRResp => sGtwiz7DrpChAxiRResp,
      sGtwiz7DrpChAxiRValid => sGtwiz7DrpChAxiRValid,
      sGtwiz7DrpChAxiRReady => sGtwiz7DrpChAxiRReady,
      UserClkPort8 => UserClkPort8,
      aPort8PmaInit => aPort8PmaInit,
      aPort8ResetPb => aPort8ResetPb,
      uPort8AxiTxTData0 => uPort8AxiTxTData0,
      uPort8AxiTxTData1 => uPort8AxiTxTData1,
      uPort8AxiTxTData2 => uPort8AxiTxTData2,
      uPort8AxiTxTData3 => uPort8AxiTxTData3,
      uPort8AxiTxTKeep => uPort8AxiTxTKeep,
      uPort8AxiTxTLast => uPort8AxiTxTLast,
      uPort8AxiTxTValid => uPort8AxiTxTValid,
      uPort8AxiTxTReady => uPort8AxiTxTReady,
      uPort8AxiRxTData0 => uPort8AxiRxTData0,
      uPort8AxiRxTData1 => uPort8AxiRxTData1,
      uPort8AxiRxTData2 => uPort8AxiRxTData2,
      uPort8AxiRxTData3 => uPort8AxiRxTData3,
      uPort8AxiRxTKeep => uPort8AxiRxTKeep,
      uPort8AxiRxTLast => uPort8AxiRxTLast,
      uPort8AxiRxTValid => uPort8AxiRxTValid,
      uPort8AxiNfcTValid => uPort8AxiNfcTValid,
      uPort8AxiNfcTData => uPort8AxiNfcTData,
      uPort8AxiNfcTReady => uPort8AxiNfcTReady,
      uPort8HardError => uPort8HardError,
      uPort8SoftError => uPort8SoftError,
      uPort8LaneUp => uPort8LaneUp,
      uPort8ChannelUp => uPort8ChannelUp,
      uPort8SysResetOut => uPort8SysResetOut,
      uPort8MmcmNotLockOut => uPort8MmcmNotLockOut,
      uPort8CrcPassFail_n => uPort8CrcPassFail_n,
      uPort8CrcValid => uPort8CrcValid,
      iPort8LinkResetOut => iPort8LinkResetOut,
      sGtwiz8CtrlAxiAWAddr => sGtwiz8CtrlAxiAWAddr,
      sGtwiz8CtrlAxiAWValid => sGtwiz8CtrlAxiAWValid,
      sGtwiz8CtrlAxiAWReady => sGtwiz8CtrlAxiAWReady,
      sGtwiz8CtrlAxiWData => sGtwiz8CtrlAxiWData,
      sGtwiz8CtrlAxiWStrb => sGtwiz8CtrlAxiWStrb,
      sGtwiz8CtrlAxiWValid => sGtwiz8CtrlAxiWValid,
      sGtwiz8CtrlAxiWReady => sGtwiz8CtrlAxiWReady,
      sGtwiz8CtrlAxiBResp => sGtwiz8CtrlAxiBResp,
      sGtwiz8CtrlAxiBValid => sGtwiz8CtrlAxiBValid,
      sGtwiz8CtrlAxiBReady => sGtwiz8CtrlAxiBReady,
      sGtwiz8CtrlAxiARAddr => sGtwiz8CtrlAxiARAddr,
      sGtwiz8CtrlAxiARValid => sGtwiz8CtrlAxiARValid,
      sGtwiz8CtrlAxiARReady => sGtwiz8CtrlAxiARReady,
      sGtwiz8CtrlAxiRData => sGtwiz8CtrlAxiRData,
      sGtwiz8CtrlAxiRResp => sGtwiz8CtrlAxiRResp,
      sGtwiz8CtrlAxiRValid => sGtwiz8CtrlAxiRValid,
      sGtwiz8CtrlAxiRReady => sGtwiz8CtrlAxiRReady,
      sGtwiz8DrpChAxiAWAddr => sGtwiz8DrpChAxiAWAddr,
      sGtwiz8DrpChAxiAWValid => sGtwiz8DrpChAxiAWValid,
      sGtwiz8DrpChAxiAWReady => sGtwiz8DrpChAxiAWReady,
      sGtwiz8DrpChAxiWData => sGtwiz8DrpChAxiWData,
      sGtwiz8DrpChAxiWStrb => sGtwiz8DrpChAxiWStrb,
      sGtwiz8DrpChAxiWValid => sGtwiz8DrpChAxiWValid,
      sGtwiz8DrpChAxiWReady => sGtwiz8DrpChAxiWReady,
      sGtwiz8DrpChAxiBResp => sGtwiz8DrpChAxiBResp,
      sGtwiz8DrpChAxiBValid => sGtwiz8DrpChAxiBValid,
      sGtwiz8DrpChAxiBReady => sGtwiz8DrpChAxiBReady,
      sGtwiz8DrpChAxiARAddr => sGtwiz8DrpChAxiARAddr,
      sGtwiz8DrpChAxiARValid => sGtwiz8DrpChAxiARValid,
      sGtwiz8DrpChAxiARReady => sGtwiz8DrpChAxiARReady,
      sGtwiz8DrpChAxiRData => sGtwiz8DrpChAxiRData,
      sGtwiz8DrpChAxiRResp => sGtwiz8DrpChAxiRResp,
      sGtwiz8DrpChAxiRValid => sGtwiz8DrpChAxiRValid,
      sGtwiz8DrpChAxiRReady => sGtwiz8DrpChAxiRReady,
      UserClkPort9 => UserClkPort9,
      aPort9PmaInit => aPort9PmaInit,
      aPort9ResetPb => aPort9ResetPb,
      uPort9AxiTxTData0 => uPort9AxiTxTData0,
      uPort9AxiTxTData1 => uPort9AxiTxTData1,
      uPort9AxiTxTData2 => uPort9AxiTxTData2,
      uPort9AxiTxTData3 => uPort9AxiTxTData3,
      uPort9AxiTxTKeep => uPort9AxiTxTKeep,
      uPort9AxiTxTLast => uPort9AxiTxTLast,
      uPort9AxiTxTValid => uPort9AxiTxTValid,
      uPort9AxiTxTReady => uPort9AxiTxTReady,
      uPort9AxiRxTData0 => uPort9AxiRxTData0,
      uPort9AxiRxTData1 => uPort9AxiRxTData1,
      uPort9AxiRxTData2 => uPort9AxiRxTData2,
      uPort9AxiRxTData3 => uPort9AxiRxTData3,
      uPort9AxiRxTKeep => uPort9AxiRxTKeep,
      uPort9AxiRxTLast => uPort9AxiRxTLast,
      uPort9AxiRxTValid => uPort9AxiRxTValid,
      uPort9AxiNfcTValid => uPort9AxiNfcTValid,
      uPort9AxiNfcTData => uPort9AxiNfcTData,
      uPort9AxiNfcTReady => uPort9AxiNfcTReady,
      uPort9HardError => uPort9HardError,
      uPort9SoftError => uPort9SoftError,
      uPort9LaneUp => uPort9LaneUp,
      uPort9ChannelUp => uPort9ChannelUp,
      uPort9SysResetOut => uPort9SysResetOut,
      uPort9MmcmNotLockOut => uPort9MmcmNotLockOut,
      uPort9CrcPassFail_n => uPort9CrcPassFail_n,
      uPort9CrcValid => uPort9CrcValid,
      iPort9LinkResetOut => iPort9LinkResetOut,
      sGtwiz9CtrlAxiAWAddr => sGtwiz9CtrlAxiAWAddr,
      sGtwiz9CtrlAxiAWValid => sGtwiz9CtrlAxiAWValid,
      sGtwiz9CtrlAxiAWReady => sGtwiz9CtrlAxiAWReady,
      sGtwiz9CtrlAxiWData => sGtwiz9CtrlAxiWData,
      sGtwiz9CtrlAxiWStrb => sGtwiz9CtrlAxiWStrb,
      sGtwiz9CtrlAxiWValid => sGtwiz9CtrlAxiWValid,
      sGtwiz9CtrlAxiWReady => sGtwiz9CtrlAxiWReady,
      sGtwiz9CtrlAxiBResp => sGtwiz9CtrlAxiBResp,
      sGtwiz9CtrlAxiBValid => sGtwiz9CtrlAxiBValid,
      sGtwiz9CtrlAxiBReady => sGtwiz9CtrlAxiBReady,
      sGtwiz9CtrlAxiARAddr => sGtwiz9CtrlAxiARAddr,
      sGtwiz9CtrlAxiARValid => sGtwiz9CtrlAxiARValid,
      sGtwiz9CtrlAxiARReady => sGtwiz9CtrlAxiARReady,
      sGtwiz9CtrlAxiRData => sGtwiz9CtrlAxiRData,
      sGtwiz9CtrlAxiRResp => sGtwiz9CtrlAxiRResp,
      sGtwiz9CtrlAxiRValid => sGtwiz9CtrlAxiRValid,
      sGtwiz9CtrlAxiRReady => sGtwiz9CtrlAxiRReady,
      sGtwiz9DrpChAxiAWAddr => sGtwiz9DrpChAxiAWAddr,
      sGtwiz9DrpChAxiAWValid => sGtwiz9DrpChAxiAWValid,
      sGtwiz9DrpChAxiAWReady => sGtwiz9DrpChAxiAWReady,
      sGtwiz9DrpChAxiWData => sGtwiz9DrpChAxiWData,
      sGtwiz9DrpChAxiWStrb => sGtwiz9DrpChAxiWStrb,
      sGtwiz9DrpChAxiWValid => sGtwiz9DrpChAxiWValid,
      sGtwiz9DrpChAxiWReady => sGtwiz9DrpChAxiWReady,
      sGtwiz9DrpChAxiBResp => sGtwiz9DrpChAxiBResp,
      sGtwiz9DrpChAxiBValid => sGtwiz9DrpChAxiBValid,
      sGtwiz9DrpChAxiBReady => sGtwiz9DrpChAxiBReady,
      sGtwiz9DrpChAxiARAddr => sGtwiz9DrpChAxiARAddr,
      sGtwiz9DrpChAxiARValid => sGtwiz9DrpChAxiARValid,
      sGtwiz9DrpChAxiARReady => sGtwiz9DrpChAxiARReady,
      sGtwiz9DrpChAxiRData => sGtwiz9DrpChAxiRData,
      sGtwiz9DrpChAxiRResp => sGtwiz9DrpChAxiRResp,
      sGtwiz9DrpChAxiRValid => sGtwiz9DrpChAxiRValid,
      sGtwiz9DrpChAxiRReady => sGtwiz9DrpChAxiRReady,
      UserClkPort10 => UserClkPort10,
      aPort10PmaInit => aPort10PmaInit,
      aPort10ResetPb => aPort10ResetPb,
      uPort10AxiTxTData0 => uPort10AxiTxTData0,
      uPort10AxiTxTData1 => uPort10AxiTxTData1,
      uPort10AxiTxTData2 => uPort10AxiTxTData2,
      uPort10AxiTxTData3 => uPort10AxiTxTData3,
      uPort10AxiTxTKeep => uPort10AxiTxTKeep,
      uPort10AxiTxTLast => uPort10AxiTxTLast,
      uPort10AxiTxTValid => uPort10AxiTxTValid,
      uPort10AxiTxTReady => uPort10AxiTxTReady,
      uPort10AxiRxTData0 => uPort10AxiRxTData0,
      uPort10AxiRxTData1 => uPort10AxiRxTData1,
      uPort10AxiRxTData2 => uPort10AxiRxTData2,
      uPort10AxiRxTData3 => uPort10AxiRxTData3,
      uPort10AxiRxTKeep => uPort10AxiRxTKeep,
      uPort10AxiRxTLast => uPort10AxiRxTLast,
      uPort10AxiRxTValid => uPort10AxiRxTValid,
      uPort10AxiNfcTValid => uPort10AxiNfcTValid,
      uPort10AxiNfcTData => uPort10AxiNfcTData,
      uPort10AxiNfcTReady => uPort10AxiNfcTReady,
      uPort10HardError => uPort10HardError,
      uPort10SoftError => uPort10SoftError,
      uPort10LaneUp => uPort10LaneUp,
      uPort10ChannelUp => uPort10ChannelUp,
      uPort10SysResetOut => uPort10SysResetOut,
      uPort10MmcmNotLockOut => uPort10MmcmNotLockOut,
      uPort10CrcPassFail_n => uPort10CrcPassFail_n,
      uPort10CrcValid => uPort10CrcValid,
      iPort10LinkResetOut => iPort10LinkResetOut,
      sGtwiz10CtrlAxiAWAddr => sGtwiz10CtrlAxiAWAddr,
      sGtwiz10CtrlAxiAWValid => sGtwiz10CtrlAxiAWValid,
      sGtwiz10CtrlAxiAWReady => sGtwiz10CtrlAxiAWReady,
      sGtwiz10CtrlAxiWData => sGtwiz10CtrlAxiWData,
      sGtwiz10CtrlAxiWStrb => sGtwiz10CtrlAxiWStrb,
      sGtwiz10CtrlAxiWValid => sGtwiz10CtrlAxiWValid,
      sGtwiz10CtrlAxiWReady => sGtwiz10CtrlAxiWReady,
      sGtwiz10CtrlAxiBResp => sGtwiz10CtrlAxiBResp,
      sGtwiz10CtrlAxiBValid => sGtwiz10CtrlAxiBValid,
      sGtwiz10CtrlAxiBReady => sGtwiz10CtrlAxiBReady,
      sGtwiz10CtrlAxiARAddr => sGtwiz10CtrlAxiARAddr,
      sGtwiz10CtrlAxiARValid => sGtwiz10CtrlAxiARValid,
      sGtwiz10CtrlAxiARReady => sGtwiz10CtrlAxiARReady,
      sGtwiz10CtrlAxiRData => sGtwiz10CtrlAxiRData,
      sGtwiz10CtrlAxiRResp => sGtwiz10CtrlAxiRResp,
      sGtwiz10CtrlAxiRValid => sGtwiz10CtrlAxiRValid,
      sGtwiz10CtrlAxiRReady => sGtwiz10CtrlAxiRReady,
      sGtwiz10DrpChAxiAWAddr => sGtwiz10DrpChAxiAWAddr,
      sGtwiz10DrpChAxiAWValid => sGtwiz10DrpChAxiAWValid,
      sGtwiz10DrpChAxiAWReady => sGtwiz10DrpChAxiAWReady,
      sGtwiz10DrpChAxiWData => sGtwiz10DrpChAxiWData,
      sGtwiz10DrpChAxiWStrb => sGtwiz10DrpChAxiWStrb,
      sGtwiz10DrpChAxiWValid => sGtwiz10DrpChAxiWValid,
      sGtwiz10DrpChAxiWReady => sGtwiz10DrpChAxiWReady,
      sGtwiz10DrpChAxiBResp => sGtwiz10DrpChAxiBResp,
      sGtwiz10DrpChAxiBValid => sGtwiz10DrpChAxiBValid,
      sGtwiz10DrpChAxiBReady => sGtwiz10DrpChAxiBReady,
      sGtwiz10DrpChAxiARAddr => sGtwiz10DrpChAxiARAddr,
      sGtwiz10DrpChAxiARValid => sGtwiz10DrpChAxiARValid,
      sGtwiz10DrpChAxiARReady => sGtwiz10DrpChAxiARReady,
      sGtwiz10DrpChAxiRData => sGtwiz10DrpChAxiRData,
      sGtwiz10DrpChAxiRResp => sGtwiz10DrpChAxiRResp,
      sGtwiz10DrpChAxiRValid => sGtwiz10DrpChAxiRValid,
      sGtwiz10DrpChAxiRReady => sGtwiz10DrpChAxiRReady,
      UserClkPort11 => UserClkPort11,
      aPort11PmaInit => aPort11PmaInit,
      aPort11ResetPb => aPort11ResetPb,
      uPort11AxiTxTData0 => uPort11AxiTxTData0,
      uPort11AxiTxTData1 => uPort11AxiTxTData1,
      uPort11AxiTxTData2 => uPort11AxiTxTData2,
      uPort11AxiTxTData3 => uPort11AxiTxTData3,
      uPort11AxiTxTKeep => uPort11AxiTxTKeep,
      uPort11AxiTxTLast => uPort11AxiTxTLast,
      uPort11AxiTxTValid => uPort11AxiTxTValid,
      uPort11AxiTxTReady => uPort11AxiTxTReady,
      uPort11AxiRxTData0 => uPort11AxiRxTData0,
      uPort11AxiRxTData1 => uPort11AxiRxTData1,
      uPort11AxiRxTData2 => uPort11AxiRxTData2,
      uPort11AxiRxTData3 => uPort11AxiRxTData3,
      uPort11AxiRxTKeep => uPort11AxiRxTKeep,
      uPort11AxiRxTLast => uPort11AxiRxTLast,
      uPort11AxiRxTValid => uPort11AxiRxTValid,
      uPort11AxiNfcTValid => uPort11AxiNfcTValid,
      uPort11AxiNfcTData => uPort11AxiNfcTData,
      uPort11AxiNfcTReady => uPort11AxiNfcTReady,
      uPort11HardError => uPort11HardError,
      uPort11SoftError => uPort11SoftError,
      uPort11LaneUp => uPort11LaneUp,
      uPort11ChannelUp => uPort11ChannelUp,
      uPort11SysResetOut => uPort11SysResetOut,
      uPort11MmcmNotLockOut => uPort11MmcmNotLockOut,
      uPort11CrcPassFail_n => uPort11CrcPassFail_n,
      uPort11CrcValid => uPort11CrcValid,
      iPort11LinkResetOut => iPort11LinkResetOut,
      sGtwiz11CtrlAxiAWAddr => sGtwiz11CtrlAxiAWAddr,
      sGtwiz11CtrlAxiAWValid => sGtwiz11CtrlAxiAWValid,
      sGtwiz11CtrlAxiAWReady => sGtwiz11CtrlAxiAWReady,
      sGtwiz11CtrlAxiWData => sGtwiz11CtrlAxiWData,
      sGtwiz11CtrlAxiWStrb => sGtwiz11CtrlAxiWStrb,
      sGtwiz11CtrlAxiWValid => sGtwiz11CtrlAxiWValid,
      sGtwiz11CtrlAxiWReady => sGtwiz11CtrlAxiWReady,
      sGtwiz11CtrlAxiBResp => sGtwiz11CtrlAxiBResp,
      sGtwiz11CtrlAxiBValid => sGtwiz11CtrlAxiBValid,
      sGtwiz11CtrlAxiBReady => sGtwiz11CtrlAxiBReady,
      sGtwiz11CtrlAxiARAddr => sGtwiz11CtrlAxiARAddr,
      sGtwiz11CtrlAxiARValid => sGtwiz11CtrlAxiARValid,
      sGtwiz11CtrlAxiARReady => sGtwiz11CtrlAxiARReady,
      sGtwiz11CtrlAxiRData => sGtwiz11CtrlAxiRData,
      sGtwiz11CtrlAxiRResp => sGtwiz11CtrlAxiRResp,
      sGtwiz11CtrlAxiRValid => sGtwiz11CtrlAxiRValid,
      sGtwiz11CtrlAxiRReady => sGtwiz11CtrlAxiRReady,
      sGtwiz11DrpChAxiAWAddr => sGtwiz11DrpChAxiAWAddr,
      sGtwiz11DrpChAxiAWValid => sGtwiz11DrpChAxiAWValid,
      sGtwiz11DrpChAxiAWReady => sGtwiz11DrpChAxiAWReady,
      sGtwiz11DrpChAxiWData => sGtwiz11DrpChAxiWData,
      sGtwiz11DrpChAxiWStrb => sGtwiz11DrpChAxiWStrb,
      sGtwiz11DrpChAxiWValid => sGtwiz11DrpChAxiWValid,
      sGtwiz11DrpChAxiWReady => sGtwiz11DrpChAxiWReady,
      sGtwiz11DrpChAxiBResp => sGtwiz11DrpChAxiBResp,
      sGtwiz11DrpChAxiBValid => sGtwiz11DrpChAxiBValid,
      sGtwiz11DrpChAxiBReady => sGtwiz11DrpChAxiBReady,
      sGtwiz11DrpChAxiARAddr => sGtwiz11DrpChAxiARAddr,
      sGtwiz11DrpChAxiARValid => sGtwiz11DrpChAxiARValid,
      sGtwiz11DrpChAxiARReady => sGtwiz11DrpChAxiARReady,
      sGtwiz11DrpChAxiRData => sGtwiz11DrpChAxiRData,
      sGtwiz11DrpChAxiRResp => sGtwiz11DrpChAxiRResp,
      sGtwiz11DrpChAxiRValid => sGtwiz11DrpChAxiRValid,
      sGtwiz11DrpChAxiRReady => sGtwiz11DrpChAxiRReady,  

      aBusReset                           => aBusReset,                                 --in  boolean
      bRegPortIn                          => bRegPortIn,                                --in  RegPortIn_t
      bRegPortOut                         => bLvWindowRegPortOut,                       --out RegPortOut_t
      bRegPortTimeout                     => bLvWindowRegPortTimeout,                   --in  boolean
      dInputStreamInterfaceToFifo         => dInputStreamInterfaceToFifo,               --in  InputStreamInterfaceToFifoArray_t(Larger(kNumberOfDmaChannels, 1)-1:0)
      dInputStreamInterfaceFromFifo       => dInputStreamInterfaceFromFifo,             --out InputStreamInterfaceFromFifoArray_t(Larger(kNumberOfDmaChannels, 1)-1:0)
      dOutputStreamInterfaceToFifo        => dOutputStreamInterfaceToFifo,              --in  OutputStreamInterfaceToFifoArray_t(Larger(kNumberOfDmaChannels, 1)-1:0)
      dOutputStreamInterfaceFromFifo      => dOutputStreamInterfaceFromFifo,            --out OutputStreamInterfaceFromFifoArray_t(Larger(kNumberOfDmaChannels, 1)-1:0)
      bIrqToInterface                     => bIrqToInterface,                           --out IrqToInterfaceArray_t(Larger(kNumberOfIrqs, 1)-1:0)
      dNiFpgaMasterWriteRequestFromMaster => dNiFpgaMasterWriteRequestFromMasterArray,  --out NiFpgaMasterWriteRequestFromMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1:0)
      dNiFpgaMasterWriteRequestToMaster   => dNiFpgaMasterWriteRequestToMasterArray,    --in  NiFpgaMasterWriteRequestToMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1:0)
      dNiFpgaMasterWriteDataFromMaster    => dNiFpgaMasterWriteDataFromMasterArray,     --out NiFpgaMasterWriteDataFromMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1:0)
      dNiFpgaMasterWriteDataToMaster      => dNiFpgaMasterWriteDataToMasterArray,       --in  NiFpgaMasterWriteDataToMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1:0)
      dNiFpgaMasterWriteStatusToMaster    => dNiFpgaMasterWriteStatusToMasterArray,     --in  NiFpgaMasterWriteStatusToMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1:0)
      dNiFpgaMasterReadRequestFromMaster  => dNiFpgaMasterReadRequestFromMasterArray,   --out NiFpgaMasterReadRequestFromMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1:0)
      dNiFpgaMasterReadRequestToMaster    => dNiFpgaMasterReadRequestToMasterArray,     --in  NiFpgaMasterReadRequestToMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1:0)
      dNiFpgaMasterReadDataToMaster       => dNiFpgaMasterReadDataToMasterArray,        --in  NiFpgaMasterReadDataToMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1:0)
      DmaClk                              => DmaClk,                                    --in  std_logic
      BusClk                              => BusClk,                                    --in  std_logic
      ReliableClkIn                       => ReliableClk,                               --in  std_logic
      PllClk80                            => BusClk,                                    --in  std_logic
      DlyRefClk                           => DlyRefClk,                                 --in  std_logic
      PxieClk100                          => PxieClk100,                                --in  std_logic
      DramClkLvFpga                       => DramClkLvFpga,                             --in  std_logic
      Dram0ClkSocket                      => Dram0ClkUser,                              --in  std_logic
      Dram1ClkSocket                      => Dram1ClkUser,                              --in  std_logic
      Dram0ClkUser                        => Dram0ClkUser,                              --in  std_logic
      Dram1ClkUser                        => Dram1ClkUser,                              --in  std_logic
      dHmbDmaClkSocket                    => DmaClk,                                    --in  std_logic
      dLlbDmaClkSocket                    => DmaClk,                                    --in  std_logic
      pIntSync100                         => pIntSync100,                               --in  std_logic
      aIntClk10                           => aIntClk10,                                 --in  std_logic
      bdIFifoRdData                       => bdIFifoRdData,                             --out std_logic_vector(63:0)
      bdIFifoRdDataValid                  => bdIFifoRdDataValid,                        --out std_logic
      bdIFifoRdReadyForInput              => bdIFifoRdReadyForInput,                    --in  std_logic
      bdIFifoRdIsError                    => bdIFifoRdIsError,                          --out std_logic
      bdIFifoWrData                       => bdIFifoWrData,                             --in  std_logic_vector(63:0)
      bdIFifoWrDataValid                  => bdIFifoWrDataValid,                        --in  std_logic
      bdIFifoWrReadyForOutput             => bdIFifoWrReadyForOutput,                   --out std_logic
      bdAxiStreamRdFromClipTData          => xDiagramAxiStreamFromClipTData,            --in  std_logic_vector(31:0)
      bdAxiStreamRdFromClipTLast          => xDiagramAxiStreamFromClipTLast,            --in  std_logic
      bdAxiStreamRdFromClipTValid         => xDiagramAxiStreamFromClipTValid,           --in  std_logic
      bdAxiStreamRdToClipTReady           => xDiagramAxiStreamToClipTReady,             --out std_logic
      bdAxiStreamWrToClipTData            => xDiagramAxiStreamToClipTData,              --out std_logic_vector(31:0)
      bdAxiStreamWrToClipTLast            => xDiagramAxiStreamToClipTLast,              --out std_logic
      bdAxiStreamWrToClipTValid           => xDiagramAxiStreamToClipTValid,             --out std_logic
      bdAxiStreamWrFromClipTReady         => xDiagramAxiStreamFromClipTReady,           --in  std_logic
      PxieClk100Trigger                   => PxieClk100,                                --in  std_logic
      pIntSync100Trigger                  => pIntSync100,                               --in  std_logic
      dDevClkEn                           => '0',                                       --in  std_logic
      aIntClk10Trigger                    => aIntClk10,                                 --in  std_logic
      bRoutingClipPresent                 => bRoutingClipPresent,                       --out std_logic
      bRoutingClipNiCompatible            => bRoutingClipNiCompatible,                  --out std_logic
      BusClkTrigger                       => BusClk,                                    --in  std_logic
      abBusResetTrigger                   => to_StdLogic(abBusReset),                   --in  std_logic
      bTriggerRoutingBaRegPortInAddress   => bTriggerRoutingBaRegPortInAddress,         --in  std_logic_vector(27:0)
      bTriggerRoutingBaRegPortInData      => bTriggerRoutingBaRegPortInData,            --in  std_logic_vector(63:0)
      bTriggerRoutingBaRegPortInWtStrobe  => bTriggerRoutingBaRegPortInWtStrobe,        --in  std_logic_vector(7:0)
      bTriggerRoutingBaRegPortInRdStrobe  => bTriggerRoutingBaRegPortInRdStrobe,        --in  std_logic_vector(7:0)
      bTriggerRoutingBaRegPortOutData     => bTriggerRoutingBaRegPortOutData,           --out std_logic_vector(63:0)
      bTriggerRoutingBaRegPortOutAck      => bTriggerRoutingBaRegPortOutAck,            --out std_logic
      aPxiTrigDataIn                      => aPxiTrigDataIn,                            --in  std_logic_vector(7:0)
      aPxiTrigDataOut                     => aPxiTrigDataOut,                           --out std_logic_vector(7:0)
      aPxiTrigDataTri                     => aPxiTrigDataTri,                           --out std_logic_vector(7:0)
      aPxiStarData                        => aPxiStarData,                              --in  std_logic
      aPxieDstarB                         => aPxieDstarB,                               --in  std_logic
      aPxieDstarC                         => aPxieDstarC,                               --out std_logic
      ---------------------
      -- BEGIN IO SOCKET PORTS
      --
      -- For this Custom Aurora target, all of the IO socket ports on The Window are left unconnected.
      --
      -- Ideally, we would not inlcude the CLIP socket on The Window in this design that has the Aurora CLIP code
      -- moved outside of The Window.  However, the FlexRIO driver needs to have the CLIP socket on the LV FPGA
      -- target plugin to properly generate some constants into a package file.  So we must leave the socket on 
      -- The Window.  
      --
      -- Eventually, we will update the FlexRIO driver to not require the CLIP socket on the Window and then these
      -- ports can be removed.
      ---------------------      
      AxiClk                              => '0',                                    --in  std_logic
      xDiagramAxiStreamFromClipTData      => open,            --out std_logic_vector(31:0)
      xDiagramAxiStreamFromClipTLast      => open,            --out std_logic
      xDiagramAxiStreamFromClipTReady     => open,           --out std_logic
      xDiagramAxiStreamFromClipTValid     => open,           --out std_logic
      xDiagramAxiStreamToClipTData        => (others => '0'),              --in  std_logic_vector(31:0)
      xDiagramAxiStreamToClipTLast        => '0',              --in  std_logic
      xDiagramAxiStreamToClipTReady       => '0',             --in  std_logic
      xDiagramAxiStreamToClipTValid       => '0',             --in  std_logic
      xHostAxiStreamFromClipTData         => open,               --out std_logic_vector(31:0)
      xHostAxiStreamFromClipTLast         => open,               --out std_logic
      xHostAxiStreamFromClipTReady        => open,              --out std_logic
      xHostAxiStreamFromClipTValid        => open,              --out std_logic
      xHostAxiStreamToClipTData           => (others => '0'),                 --in  std_logic_vector(31:0)
      xHostAxiStreamToClipTLast           => '0',                 --in  std_logic
      xHostAxiStreamToClipTReady          => '0',                --in  std_logic
      xHostAxiStreamToClipTValid          => '0',                --in  std_logic
      xClipAxi4LiteMasterARAddr           => open,                      --out std_logic_vector(31:0)
      xClipAxi4LiteMasterARProt           => open,                      --out std_logic_vector(2:0)
      xClipAxi4LiteMasterARReady          => '0',                     --in  std_logic
      xClipAxi4LiteMasterARValid          => open,                     --out std_logic
      xClipAxi4LiteMasterAWAddr           => open,                      --out std_logic_vector(31:0)
      xClipAxi4LiteMasterAWProt           => open,                      --out std_logic_vector(2:0)
      xClipAxi4LiteMasterAWReady          => '0',                     --in  std_logic
      xClipAxi4LiteMasterAWValid          => open,                     --out std_logic
      xClipAxi4LiteMasterBReady           => open,                      --out std_logic
      xClipAxi4LiteMasterBResp            => (others => '0'),                       --in  std_logic_vector(1:0)
      xClipAxi4LiteMasterBValid           => '0',                      --in  std_logic
      xClipAxi4LiteMasterRData            => (others => '0'),                       --in  std_logic_vector(31:0)
      xClipAxi4LiteMasterRReady           => open,                      --out std_logic
      xClipAxi4LiteMasterRResp            => (others => '0'),                       --in  std_logic_vector(1:0)
      xClipAxi4LiteMasterRValid           => '0',                      --in  std_logic
      xClipAxi4LiteMasterWData            => open,                       --out std_logic_vector(31:0)
      xClipAxi4LiteMasterWReady           => '0',                      --in  std_logic
      xClipAxi4LiteMasterWStrb            => open,                       --out std_logic_vector(3:0)
      xClipAxi4LiteMasterWValid           => open,                      --out std_logic
      xClipAxi4LiteInterrupt              => '0',                                       --in  std_logic
      stIoModuleSupportsFRAGLs            => open,                  --out std_logic
      MgtRefClk_p                         => (others => '0'),                               --in  std_logic_vector(11:0)
      MgtRefClk_n                         => (others => '0'),                               --in  std_logic_vector(11:0)
      --@@BEGIN COMPONENT_SIGNAL_ASSIGNMENT
--
-- TheWindow.vhd is generated by LabVIEW FPGA.  We ship a stub to ensure that we can synthesize the design.
-- Vivado will error when building a design that has MGT lines in the top level entity that are not connected
-- to anything.  So we comment out the MGT lines in the top level and in the Window stub.
--
-- If you are making a custom FPGA target, the MGT lines will be statically connected to your MGT logic.  If you are
-- using this FPGA target with a CLIP in LabVIEW FPGA, these MGT signals will be auto-generated by LV FPGA when it
-- processes the VHDL files.  The @ @ BEGIN / END around these signals is where LV FPGA generates the ports.
--

      MgtPortRx_p                     => (others => '0'),                               --in  std_logic_vector(47:0)
      MgtPortRx_n                     => (others => '0'),                               --in  std_logic_vector(47:0)
      MgtPortTx_p                     => open,                                          --out  std_logic_vector(47:0)
      MgtPortTx_n                     => open,                                          --out  std_logic_vector(47:0)

      --@@END COMPONENT_SIGNAL_ASSIGNMENT
      aDio                                => open,                                      --inout std_logic_vector(7:0)
      aLmkI2cSda                          => open,                                --inout std_logic
      aLmkI2cScl                          => open,                                --inout std_logic
      aLmk1Pdn_n                          => open,                                --out std_logic
      aLmk2Pdn_n                          => open,                                --out std_logic
      aLmk1Gpio0                          => open,                                --out std_logic
      aLmk2Gpio0                          => open,                                --out std_logic
      aLmk1Status0                        => '0',                              --in  std_logic
      aLmk1Status1                        => '0',                              --in  std_logic
      aLmk2Status0                        => '0',                              --in  std_logic
      aLmk2Status1                        => '0',                              --in  std_logic
      aIPassVccPowerFault_n               => '0',                     --in  std_logic
      aIPassPrsnt_n                       => (others => '0'),                             --in  std_logic_vector(7:0)
      aIPassIntr_n                        => (others => '0'),                              --in  std_logic_vector(7:0)
      aIPassSCL                           => open,                                 --inout std_logic_vector(11:0)
      aIPassSDA                           => open,                                 --inout std_logic_vector(11:0)
      aPortExpReset_n                     => open,                           --out std_logic
      aPortExpIntr_n                      => '0',                            --in  std_logic
      aPortExpSda                         => open,                               --inout std_logic
      aPortExpScl                         => open,                               --inout std_logic
      ----------------------
      -- END IO SOCKET PORTS
      ----------------------
      aDramReady                          => aDramReady,                                --in  std_logic
      du0DramAddrFifoAddr                 => du0DramAddrFifoAddr,                       --out std_logic_vector(29:0)
      du0DramAddrFifoCmd                  => du0DramAddrFifoCmd,                        --out std_logic_vector(2:0)
      du0DramAddrFifoFull                 => du0DramAddrFifoFull,                       --in  std_logic
      du0DramAddrFifoWrEn                 => du0DramAddrFifoWrEn,                       --out std_logic
      du0DramPhyInitDone                  => du0DramPhyInitDone,                        --in  std_logic
      du0DramRdDataValid                  => du0DramRdDataValid,                        --in  std_logic
      du0DramRdFifoDataOut                => du0DramRdFifoDataOut,                      --in  std_logic_vector(639:0)
      du0DramWrFifoDataIn                 => du0DramWrFifoDataIn,                       --out std_logic_vector(639:0)
      du0DramWrFifoFull                   => du0DramWrFifoFull,                         --in  std_logic
      du0DramWrFifoMaskData               => du0DramWrFifoMaskData,                     --out std_logic_vector(79:0)
      du0DramWrFifoWrEn                   => du0DramWrFifoWrEn,                         --out std_logic
      du1DramAddrFifoAddr                 => du1DramAddrFifoAddr,                       --out std_logic_vector(29:0)
      du1DramAddrFifoCmd                  => du1DramAddrFifoCmd,                        --out std_logic_vector(2:0)
      du1DramAddrFifoFull                 => du1DramAddrFifoFull,                       --in  std_logic
      du1DramAddrFifoWrEn                 => du1DramAddrFifoWrEn,                       --out std_logic
      du1DramPhyInitDone                  => du1DramPhyInitDone,                        --in  std_logic
      du1DramRdDataValid                  => du1DramRdDataValid,                        --in  std_logic
      du1DramRdFifoDataOut                => du1DramRdFifoDataOut,                      --in  std_logic_vector(639:0)
      du1DramWrFifoDataIn                 => du1DramWrFifoDataIn,                       --out std_logic_vector(639:0)
      du1DramWrFifoFull                   => du1DramWrFifoFull,                         --in  std_logic
      du1DramWrFifoMaskData               => du1DramWrFifoMaskData,                     --out std_logic_vector(79:0)
      du1DramWrFifoWrEn                   => du1DramWrFifoWrEn,                         --out std_logic
      dHmbDramAddrFifoAddr                => dHmbDramAddrFifoAddr,                      --out std_logic_vector(31:0)
      dHmbDramAddrFifoCmd                 => dHmbDramAddrFifoCmd,                       --out std_logic_vector(2:0)
      dHmbDramAddrFifoFull                => dHmbDramAddrFifoFull,                      --in  std_logic
      dHmbDramAddrFifoWrEn                => dHmbDramAddrFifoWrEn,                      --out std_logic
      dHmbDramRdDataValid                 => dHmbDramRdDataValid,                       --in  std_logic
      dHmbDramRdFifoDataOut               => dHmbDramRdFifoDataOut,                     --in  std_logic_vector(1023:0)
      dHmbDramWrFifoDataIn                => dHmbDramWrFifoDataIn,                      --out std_logic_vector(1023:0)
      dHmbDramWrFifoFull                  => dHmbDramWrFifoFull,                        --in  std_logic
      dHmbDramWrFifoMaskData              => dHmbDramWrFifoMaskData,                    --out std_logic_vector(127:0)
      dHmbDramWrFifoWrEn                  => dHmbDramWrFifoWrEn,                        --out std_logic
      dHmbPhyInitDoneForLvfpga            => dHmbPhyInitDoneForLvfpga,                  --in  std_logic
      dLlbDramAddrFifoAddr                => dLlbDramAddrFifoAddr,                      --out std_logic_vector(31:0)
      dLlbDramAddrFifoCmd                 => dLlbDramAddrFifoCmd,                       --out std_logic_vector(2:0)
      dLlbDramAddrFifoFull                => dLlbDramAddrFifoFull,                      --in  std_logic
      dLlbDramAddrFifoWrEn                => dLlbDramAddrFifoWrEn,                      --out std_logic
      dLlbDramRdDataValid                 => dLlbDramRdDataValid,                       --in  std_logic
      dLlbDramRdFifoDataOut               => dLlbDramRdFifoDataOut,                     --in  std_logic_vector(1023:0)
      dLlbDramWrFifoDataIn                => dLlbDramWrFifoDataIn,                      --out std_logic_vector(1023:0)
      dLlbDramWrFifoFull                  => dLlbDramWrFifoFull,                        --in  std_logic
      dLlbDramWrFifoMaskData              => dLlbDramWrFifoMaskData,                    --out std_logic_vector(127:0)
      dLlbDramWrFifoWrEn                  => dLlbDramWrFifoWrEn,                        --out std_logic
      dLlbPhyInitDoneForLvfpga            => dLlbPhyInitDoneForLvfpga,                  --in  std_logic
      TopLevelClkOut                      => open,                                      --out std_logic
      ReliableClkOut                      => open,                                      --out std_logic
      rBaseClksValid                      => rBaseClksValid,                            --in  std_logic:='1'
      tDiagramActive                      => open,                                      --out std_logic
      rDiagramReset                       => open,                                      --out std_logic
      aDiagramReset                       => aDiagramReset,                             --out std_logic
      rDerivedClockLostLockError          => open,                                      --out std_logic
      rGatedBaseClksValid                 => '1',                                       --in  std_logic:='1'
      aSafeToEnableGatedClks              => open);                                     --out std_logic



  UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst: entity work.UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz (rtl)
  port map (
      aResetSl => aDiagramReset,
      aLmkI2cSda => aLmkI2cSda,
      aLmkI2cScl => aLmkI2cScl,
      aLmk1Pdn_n => aLmk1Pdn_n,
      aLmk2Pdn_n => aLmk2Pdn_n,
      aLmk1Gpio0 => aLmk1Gpio0,
      aLmk2Gpio0 => aLmk2Gpio0,
      aLmk1Status0 => aLmk1Status0,
      aLmk1Status1 => aLmk1Status1,
      aLmk2Status0 => aLmk2Status0,
      aLmk2Status1 => aLmk2Status1,
      aIPassPrsnt_n => aIPassPrsnt_n,
      aIPassIntr_n => aIPassIntr_n,
      aIPassSCL => aIPassSCL,
      aIPassSDA => aIPassSDA,
      aPortExpReset_n => aPortExpReset_n,
      aPortExpIntr_n => aPortExpIntr_n,
      aPortExpSda => aPortExpSda,
      aPortExpScl => aPortExpScl,
      aIPassVccPowerFault_n => aIPassVccPowerFault_n,
      stIoModuleSupportsFRAGLs => stIoModuleSupportsFRAGLs,
      aDio => aDio,
      AxiClk => BusClk,
      xHostAxiStreamToClipTData => xHostAxiStreamToClipTData,
      xHostAxiStreamToClipTLast => xHostAxiStreamToClipTLast,
      xHostAxiStreamFromClipTReady => xHostAxiStreamFromClipTReady,
      xHostAxiStreamToClipTValid => xHostAxiStreamToClipTValid,
      xHostAxiStreamFromClipTData => xHostAxiStreamFromClipTData,
      xHostAxiStreamFromClipTLast => xHostAxiStreamFromClipTLast,
      xHostAxiStreamToClipTReady => xHostAxiStreamToClipTReady,
      xHostAxiStreamFromClipTValid => xHostAxiStreamFromClipTValid,
      xDiagramAxiStreamToClipTData => xDiagramAxiStreamToClipTData,
      xDiagramAxiStreamToClipTLast => xDiagramAxiStreamToClipTLast,
      xDiagramAxiStreamFromClipTReady => xDiagramAxiStreamFromClipTReady,
      xDiagramAxiStreamToClipTValid => xDiagramAxiStreamToClipTValid,
      xDiagramAxiStreamFromClipTData => xDiagramAxiStreamFromClipTData,
      xDiagramAxiStreamFromClipTLast => xDiagramAxiStreamFromClipTLast,
      xDiagramAxiStreamToClipTReady => xDiagramAxiStreamToClipTReady,
      xDiagramAxiStreamFromClipTValid => xDiagramAxiStreamFromClipTValid,
      xClipAxi4LiteMasterARAddr => bdClipAxi4LiteARAddr,
      xClipAxi4LiteMasterARProt => bdClipAxi4LiteARProt,
      xClipAxi4LiteMasterARReady => bdClipAxi4LiteARReady,
      xClipAxi4LiteMasterARValid => bdClipAxi4LiteARValid,
      xClipAxi4LiteMasterAWAddr => bdClipAxi4LiteAWAddr,
      xClipAxi4LiteMasterAWProt => bdClipAxi4LiteAWProt,
      xClipAxi4LiteMasterAWReady => bdClipAxi4LiteAWReady,
      xClipAxi4LiteMasterAWValid => bdClipAxi4LiteAWValid,
      xClipAxi4LiteMasterBReady => bdClipAxi4LiteBReady,
      xClipAxi4LiteMasterBResp => bdClipAxi4LiteBResp,
      xClipAxi4LiteMasterBValid => bdClipAxi4LiteBValid,
      xClipAxi4LiteMasterRData => bdClipAxi4LiteRData,
      xClipAxi4LiteMasterRReady => bdClipAxi4LiteRReady,
      xClipAxi4LiteMasterRResp => bdClipAxi4LiteRResp,
      xClipAxi4LiteMasterRValid => bdClipAxi4LiteRValid,
      xClipAxi4LiteMasterWData => bdClipAxi4LiteWData,
      xClipAxi4LiteMasterWReady => bdClipAxi4LiteWReady,
      xClipAxi4LiteMasterWStrb => bdClipAxi4LiteWStrb,
      xClipAxi4LiteMasterWValid => bdClipAxi4LiteWValid,
      xClipAxi4LiteInterrupt => '0',
      MgtRefClk_p => MgtRefClk_p,
      MgtRefClk_n => MgtRefClk_n,
      MgtPortRx_n(0) => MgtPortRxLane0_n,
      MgtPortRx_n(1) => MgtPortRxLane1_n,
      MgtPortRx_n(2) => MgtPortRxLane2_n,
      MgtPortRx_n(3) => MgtPortRxLane3_n,
      MgtPortRx_n(4) => MgtPortRxLane4_n,
      MgtPortRx_n(5) => MgtPortRxLane5_n,
      MgtPortRx_n(6) => MgtPortRxLane6_n,
      MgtPortRx_n(7) => MgtPortRxLane7_n,
      MgtPortRx_n(8) => MgtPortRxLane8_n,
      MgtPortRx_n(9) => MgtPortRxLane9_n,
      MgtPortRx_n(10) => MgtPortRxLane10_n,
      MgtPortRx_n(11) => MgtPortRxLane11_n,
      MgtPortRx_n(12) => MgtPortRxLane12_n,
      MgtPortRx_n(13) => MgtPortRxLane13_n,
      MgtPortRx_n(14) => MgtPortRxLane14_n,
      MgtPortRx_n(15) => MgtPortRxLane15_n,
      MgtPortRx_n(16) => MgtPortRxLane16_n,
      MgtPortRx_n(17) => MgtPortRxLane17_n,
      MgtPortRx_n(18) => MgtPortRxLane18_n,
      MgtPortRx_n(19) => MgtPortRxLane19_n,
      MgtPortRx_n(20) => MgtPortRxLane20_n,
      MgtPortRx_n(21) => MgtPortRxLane21_n,
      MgtPortRx_n(22) => MgtPortRxLane22_n,
      MgtPortRx_n(23) => MgtPortRxLane23_n,
      MgtPortRx_n(24) => MgtPortRxLane24_n,
      MgtPortRx_n(25) => MgtPortRxLane25_n,
      MgtPortRx_n(26) => MgtPortRxLane26_n,
      MgtPortRx_n(27) => MgtPortRxLane27_n,
      MgtPortRx_n(28) => MgtPortRxLane28_n,
      MgtPortRx_n(29) => MgtPortRxLane29_n,
      MgtPortRx_n(30) => MgtPortRxLane30_n,
      MgtPortRx_n(31) => MgtPortRxLane31_n,
      MgtPortRx_n(32) => MgtPortRxLane32_n,
      MgtPortRx_n(33) => MgtPortRxLane33_n,
      MgtPortRx_n(34) => MgtPortRxLane34_n,
      MgtPortRx_n(35) => MgtPortRxLane35_n,
      MgtPortRx_n(36) => MgtPortRxLane36_n,
      MgtPortRx_n(37) => MgtPortRxLane37_n,
      MgtPortRx_n(38) => MgtPortRxLane38_n,
      MgtPortRx_n(39) => MgtPortRxLane39_n,
      MgtPortRx_n(40) => MgtPortRxLane40_n,
      MgtPortRx_n(41) => MgtPortRxLane41_n,
      MgtPortRx_n(42) => MgtPortRxLane42_n,
      MgtPortRx_n(43) => MgtPortRxLane43_n,
      MgtPortRx_n(44) => MgtPortRxLane44_n,
      MgtPortRx_n(45) => MgtPortRxLane45_n,
      MgtPortRx_n(46) => MgtPortRxLane46_n,
      MgtPortRx_n(47) => MgtPortRxLane47_n,
      MgtPortRx_p(0) => MgtPortRxLane0_p,
      MgtPortRx_p(1) => MgtPortRxLane1_p,
      MgtPortRx_p(2) => MgtPortRxLane2_p,
      MgtPortRx_p(3) => MgtPortRxLane3_p,
      MgtPortRx_p(4) => MgtPortRxLane4_p,
      MgtPortRx_p(5) => MgtPortRxLane5_p,
      MgtPortRx_p(6) => MgtPortRxLane6_p,
      MgtPortRx_p(7) => MgtPortRxLane7_p,
      MgtPortRx_p(8) => MgtPortRxLane8_p,
      MgtPortRx_p(9) => MgtPortRxLane9_p,
      MgtPortRx_p(10) => MgtPortRxLane10_p,
      MgtPortRx_p(11) => MgtPortRxLane11_p,
      MgtPortRx_p(12) => MgtPortRxLane12_p,
      MgtPortRx_p(13) => MgtPortRxLane13_p,
      MgtPortRx_p(14) => MgtPortRxLane14_p,
      MgtPortRx_p(15) => MgtPortRxLane15_p,
      MgtPortRx_p(16) => MgtPortRxLane16_p,
      MgtPortRx_p(17) => MgtPortRxLane17_p,
      MgtPortRx_p(18) => MgtPortRxLane18_p,
      MgtPortRx_p(19) => MgtPortRxLane19_p,
      MgtPortRx_p(20) => MgtPortRxLane20_p,
      MgtPortRx_p(21) => MgtPortRxLane21_p,
      MgtPortRx_p(22) => MgtPortRxLane22_p,
      MgtPortRx_p(23) => MgtPortRxLane23_p,
      MgtPortRx_p(24) => MgtPortRxLane24_p,
      MgtPortRx_p(25) => MgtPortRxLane25_p,
      MgtPortRx_p(26) => MgtPortRxLane26_p,
      MgtPortRx_p(27) => MgtPortRxLane27_p,
      MgtPortRx_p(28) => MgtPortRxLane28_p,
      MgtPortRx_p(29) => MgtPortRxLane29_p,
      MgtPortRx_p(30) => MgtPortRxLane30_p,
      MgtPortRx_p(31) => MgtPortRxLane31_p,
      MgtPortRx_p(32) => MgtPortRxLane32_p,
      MgtPortRx_p(33) => MgtPortRxLane33_p,
      MgtPortRx_p(34) => MgtPortRxLane34_p,
      MgtPortRx_p(35) => MgtPortRxLane35_p,
      MgtPortRx_p(36) => MgtPortRxLane36_p,
      MgtPortRx_p(37) => MgtPortRxLane37_p,
      MgtPortRx_p(38) => MgtPortRxLane38_p,
      MgtPortRx_p(39) => MgtPortRxLane39_p,
      MgtPortRx_p(40) => MgtPortRxLane40_p,
      MgtPortRx_p(41) => MgtPortRxLane41_p,
      MgtPortRx_p(42) => MgtPortRxLane42_p,
      MgtPortRx_p(43) => MgtPortRxLane43_p,
      MgtPortRx_p(44) => MgtPortRxLane44_p,
      MgtPortRx_p(45) => MgtPortRxLane45_p,
      MgtPortRx_p(46) => MgtPortRxLane46_p,
      MgtPortRx_p(47) => MgtPortRxLane47_p,
      MgtPortTx_n(0) => MgtPortTxLane0_n,
      MgtPortTx_n(1) => MgtPortTxLane1_n,
      MgtPortTx_n(2) => MgtPortTxLane2_n,
      MgtPortTx_n(3) => MgtPortTxLane3_n,
      MgtPortTx_n(4) => MgtPortTxLane4_n,
      MgtPortTx_n(5) => MgtPortTxLane5_n,
      MgtPortTx_n(6) => MgtPortTxLane6_n,
      MgtPortTx_n(7) => MgtPortTxLane7_n,
      MgtPortTx_n(8) => MgtPortTxLane8_n,
      MgtPortTx_n(9) => MgtPortTxLane9_n,
      MgtPortTx_n(10) => MgtPortTxLane10_n,
      MgtPortTx_n(11) => MgtPortTxLane11_n,
      MgtPortTx_n(12) => MgtPortTxLane12_n,
      MgtPortTx_n(13) => MgtPortTxLane13_n,
      MgtPortTx_n(14) => MgtPortTxLane14_n,
      MgtPortTx_n(15) => MgtPortTxLane15_n,
      MgtPortTx_n(16) => MgtPortTxLane16_n,
      MgtPortTx_n(17) => MgtPortTxLane17_n,
      MgtPortTx_n(18) => MgtPortTxLane18_n,
      MgtPortTx_n(19) => MgtPortTxLane19_n,
      MgtPortTx_n(20) => MgtPortTxLane20_n,
      MgtPortTx_n(21) => MgtPortTxLane21_n,
      MgtPortTx_n(22) => MgtPortTxLane22_n,
      MgtPortTx_n(23) => MgtPortTxLane23_n,
      MgtPortTx_n(24) => MgtPortTxLane24_n,
      MgtPortTx_n(25) => MgtPortTxLane25_n,
      MgtPortTx_n(26) => MgtPortTxLane26_n,
      MgtPortTx_n(27) => MgtPortTxLane27_n,
      MgtPortTx_n(28) => MgtPortTxLane28_n,
      MgtPortTx_n(29) => MgtPortTxLane29_n,
      MgtPortTx_n(30) => MgtPortTxLane30_n,
      MgtPortTx_n(31) => MgtPortTxLane31_n,
      MgtPortTx_n(32) => MgtPortTxLane32_n,
      MgtPortTx_n(33) => MgtPortTxLane33_n,
      MgtPortTx_n(34) => MgtPortTxLane34_n,
      MgtPortTx_n(35) => MgtPortTxLane35_n,
      MgtPortTx_n(36) => MgtPortTxLane36_n,
      MgtPortTx_n(37) => MgtPortTxLane37_n,
      MgtPortTx_n(38) => MgtPortTxLane38_n,
      MgtPortTx_n(39) => MgtPortTxLane39_n,
      MgtPortTx_n(40) => MgtPortTxLane40_n,
      MgtPortTx_n(41) => MgtPortTxLane41_n,
      MgtPortTx_n(42) => MgtPortTxLane42_n,
      MgtPortTx_n(43) => MgtPortTxLane43_n,
      MgtPortTx_n(44) => MgtPortTxLane44_n,
      MgtPortTx_n(45) => MgtPortTxLane45_n,
      MgtPortTx_n(46) => MgtPortTxLane46_n,
      MgtPortTx_n(47) => MgtPortTxLane47_n,
      MgtPortTx_p(0) => MgtPortTxLane0_p,
      MgtPortTx_p(1) => MgtPortTxLane1_p,
      MgtPortTx_p(2) => MgtPortTxLane2_p,
      MgtPortTx_p(3) => MgtPortTxLane3_p,
      MgtPortTx_p(4) => MgtPortTxLane4_p,
      MgtPortTx_p(5) => MgtPortTxLane5_p,
      MgtPortTx_p(6) => MgtPortTxLane6_p,
      MgtPortTx_p(7) => MgtPortTxLane7_p,
      MgtPortTx_p(8) => MgtPortTxLane8_p,
      MgtPortTx_p(9) => MgtPortTxLane9_p,
      MgtPortTx_p(10) => MgtPortTxLane10_p,
      MgtPortTx_p(11) => MgtPortTxLane11_p,
      MgtPortTx_p(12) => MgtPortTxLane12_p,
      MgtPortTx_p(13) => MgtPortTxLane13_p,
      MgtPortTx_p(14) => MgtPortTxLane14_p,
      MgtPortTx_p(15) => MgtPortTxLane15_p,
      MgtPortTx_p(16) => MgtPortTxLane16_p,
      MgtPortTx_p(17) => MgtPortTxLane17_p,
      MgtPortTx_p(18) => MgtPortTxLane18_p,
      MgtPortTx_p(19) => MgtPortTxLane19_p,
      MgtPortTx_p(20) => MgtPortTxLane20_p,
      MgtPortTx_p(21) => MgtPortTxLane21_p,
      MgtPortTx_p(22) => MgtPortTxLane22_p,
      MgtPortTx_p(23) => MgtPortTxLane23_p,
      MgtPortTx_p(24) => MgtPortTxLane24_p,
      MgtPortTx_p(25) => MgtPortTxLane25_p,
      MgtPortTx_p(26) => MgtPortTxLane26_p,
      MgtPortTx_p(27) => MgtPortTxLane27_p,
      MgtPortTx_p(28) => MgtPortTxLane28_p,
      MgtPortTx_p(29) => MgtPortTxLane29_p,
      MgtPortTx_p(30) => MgtPortTxLane30_p,
      MgtPortTx_p(31) => MgtPortTxLane31_p,
      MgtPortTx_p(32) => MgtPortTxLane32_p,
      MgtPortTx_p(33) => MgtPortTxLane33_p,
      MgtPortTx_p(34) => MgtPortTxLane34_p,
      MgtPortTx_p(35) => MgtPortTxLane35_p,
      MgtPortTx_p(36) => MgtPortTxLane36_p,
      MgtPortTx_p(37) => MgtPortTxLane37_p,
      MgtPortTx_p(38) => MgtPortTxLane38_p,
      MgtPortTx_p(39) => MgtPortTxLane39_p,
      MgtPortTx_p(40) => MgtPortTxLane40_p,
      MgtPortTx_p(41) => MgtPortTxLane41_p,
      MgtPortTx_p(42) => MgtPortTxLane42_p,
      MgtPortTx_p(43) => MgtPortTxLane43_p,
      MgtPortTx_p(44) => MgtPortTxLane44_p,
      MgtPortTx_p(45) => MgtPortTxLane45_p,
      MgtPortTx_p(46) => MgtPortTxLane46_p,
      MgtPortTx_p(47) => MgtPortTxLane47_p,
      TopLevelClk80 => BusClk,
      xIoModuleReady => xIoModuleReady,
      xIoModuleErrorCode => xIoModuleErrorCode,
      aDioOut => aDioOut,
      aDioIn => aDioIn,
      UserClkPort0 => UserClkPort0,
      UserClkPort1 => UserClkPort1,
      UserClkPort2 => UserClkPort2,
      UserClkPort3 => UserClkPort3,
      UserClkPort4 => UserClkPort4,
      UserClkPort5 => UserClkPort5,
      UserClkPort6 => UserClkPort6,
      UserClkPort7 => UserClkPort7,
      UserClkPort8 => UserClkPort8,
      UserClkPort9 => UserClkPort9,
      UserClkPort10 => UserClkPort10,
      UserClkPort11 => UserClkPort11,
      aPort0PmaInit => aPort0PmaInit,
      aPort1PmaInit => aPort1PmaInit,
      aPort2PmaInit => aPort2PmaInit,
      aPort3PmaInit => aPort3PmaInit,
      aPort4PmaInit => aPort4PmaInit,
      aPort5PmaInit => aPort5PmaInit,
      aPort6PmaInit => aPort6PmaInit,
      aPort7PmaInit => aPort7PmaInit,
      aPort8PmaInit => aPort8PmaInit,
      aPort9PmaInit => aPort9PmaInit,
      aPort10PmaInit => aPort10PmaInit,
      aPort11PmaInit => aPort11PmaInit,
      aPort0ResetPb => aPort0ResetPb,
      aPort1ResetPb => aPort1ResetPb,
      aPort2ResetPb => aPort2ResetPb,
      aPort3ResetPb => aPort3ResetPb,
      aPort4ResetPb => aPort4ResetPb,
      aPort5ResetPb => aPort5ResetPb,
      aPort6ResetPb => aPort6ResetPb,
      aPort7ResetPb => aPort7ResetPb,
      aPort8ResetPb => aPort8ResetPb,
      aPort9ResetPb => aPort9ResetPb,
      aPort10ResetPb => aPort10ResetPb,
      aPort11ResetPb => aPort11ResetPb,
      uPort0AxiTxTData0 => uPort0AxiTxTData0,
      uPort0AxiTxTData1 => uPort0AxiTxTData1,
      uPort0AxiTxTData2 => uPort0AxiTxTData2,
      uPort0AxiTxTData3 => uPort0AxiTxTData3,
      uPort0AxiTxTKeep => uPort0AxiTxTKeep,
      uPort0AxiTxTLast => uPort0AxiTxTLast,
      uPort0AxiTxTValid => uPort0AxiTxTValid,
      uPort0AxiTxTReady => uPort0AxiTxTReady,
      uPort1AxiTxTData0 => uPort1AxiTxTData0,
      uPort1AxiTxTData1 => uPort1AxiTxTData1,
      uPort1AxiTxTData2 => uPort1AxiTxTData2,
      uPort1AxiTxTData3 => uPort1AxiTxTData3,
      uPort1AxiTxTKeep => uPort1AxiTxTKeep,
      uPort1AxiTxTLast => uPort1AxiTxTLast,
      uPort1AxiTxTValid => uPort1AxiTxTValid,
      uPort1AxiTxTReady => uPort1AxiTxTReady,
      uPort2AxiTxTData0 => uPort2AxiTxTData0,
      uPort2AxiTxTData1 => uPort2AxiTxTData1,
      uPort2AxiTxTData2 => uPort2AxiTxTData2,
      uPort2AxiTxTData3 => uPort2AxiTxTData3,
      uPort2AxiTxTKeep => uPort2AxiTxTKeep,
      uPort2AxiTxTLast => uPort2AxiTxTLast,
      uPort2AxiTxTValid => uPort2AxiTxTValid,
      uPort2AxiTxTReady => uPort2AxiTxTReady,
      uPort3AxiTxTData0 => uPort3AxiTxTData0,
      uPort3AxiTxTData1 => uPort3AxiTxTData1,
      uPort3AxiTxTData2 => uPort3AxiTxTData2,
      uPort3AxiTxTData3 => uPort3AxiTxTData3,
      uPort3AxiTxTKeep => uPort3AxiTxTKeep,
      uPort3AxiTxTLast => uPort3AxiTxTLast,
      uPort3AxiTxTValid => uPort3AxiTxTValid,
      uPort3AxiTxTReady => uPort3AxiTxTReady,
      uPort4AxiTxTData0 => uPort4AxiTxTData0,
      uPort4AxiTxTData1 => uPort4AxiTxTData1,
      uPort4AxiTxTData2 => uPort4AxiTxTData2,
      uPort4AxiTxTData3 => uPort4AxiTxTData3,
      uPort4AxiTxTKeep => uPort4AxiTxTKeep,
      uPort4AxiTxTLast => uPort4AxiTxTLast,
      uPort4AxiTxTValid => uPort4AxiTxTValid,
      uPort4AxiTxTReady => uPort4AxiTxTReady,
      uPort5AxiTxTData0 => uPort5AxiTxTData0,
      uPort5AxiTxTData1 => uPort5AxiTxTData1,
      uPort5AxiTxTData2 => uPort5AxiTxTData2,
      uPort5AxiTxTData3 => uPort5AxiTxTData3,
      uPort5AxiTxTKeep => uPort5AxiTxTKeep,
      uPort5AxiTxTLast => uPort5AxiTxTLast,
      uPort5AxiTxTValid => uPort5AxiTxTValid,
      uPort5AxiTxTReady => uPort5AxiTxTReady,
      uPort6AxiTxTData0 => uPort6AxiTxTData0,
      uPort6AxiTxTData1 => uPort6AxiTxTData1,
      uPort6AxiTxTData2 => uPort6AxiTxTData2,
      uPort6AxiTxTData3 => uPort6AxiTxTData3,
      uPort6AxiTxTKeep => uPort6AxiTxTKeep,
      uPort6AxiTxTLast => uPort6AxiTxTLast,
      uPort6AxiTxTValid => uPort6AxiTxTValid,
      uPort6AxiTxTReady => uPort6AxiTxTReady,
      uPort7AxiTxTData0 => uPort7AxiTxTData0,
      uPort7AxiTxTData1 => uPort7AxiTxTData1,
      uPort7AxiTxTData2 => uPort7AxiTxTData2,
      uPort7AxiTxTData3 => uPort7AxiTxTData3,
      uPort7AxiTxTKeep => uPort7AxiTxTKeep,
      uPort7AxiTxTLast => uPort7AxiTxTLast,
      uPort7AxiTxTValid => uPort7AxiTxTValid,
      uPort7AxiTxTReady => uPort7AxiTxTReady,
      uPort8AxiTxTData0 => uPort8AxiTxTData0,
      uPort8AxiTxTData1 => uPort8AxiTxTData1,
      uPort8AxiTxTData2 => uPort8AxiTxTData2,
      uPort8AxiTxTData3 => uPort8AxiTxTData3,
      uPort8AxiTxTKeep => uPort8AxiTxTKeep,
      uPort8AxiTxTLast => uPort8AxiTxTLast,
      uPort8AxiTxTValid => uPort8AxiTxTValid,
      uPort8AxiTxTReady => uPort8AxiTxTReady,
      uPort9AxiTxTData0 => uPort9AxiTxTData0,
      uPort9AxiTxTData1 => uPort9AxiTxTData1,
      uPort9AxiTxTData2 => uPort9AxiTxTData2,
      uPort9AxiTxTData3 => uPort9AxiTxTData3,
      uPort9AxiTxTKeep => uPort9AxiTxTKeep,
      uPort9AxiTxTLast => uPort9AxiTxTLast,
      uPort9AxiTxTValid => uPort9AxiTxTValid,
      uPort9AxiTxTReady => uPort9AxiTxTReady,
      uPort10AxiTxTData0 => uPort10AxiTxTData0,
      uPort10AxiTxTData1 => uPort10AxiTxTData1,
      uPort10AxiTxTData2 => uPort10AxiTxTData2,
      uPort10AxiTxTData3 => uPort10AxiTxTData3,
      uPort10AxiTxTKeep => uPort10AxiTxTKeep,
      uPort10AxiTxTLast => uPort10AxiTxTLast,
      uPort10AxiTxTValid => uPort10AxiTxTValid,
      uPort10AxiTxTReady => uPort10AxiTxTReady,
      uPort11AxiTxTData0 => uPort11AxiTxTData0,
      uPort11AxiTxTData1 => uPort11AxiTxTData1,
      uPort11AxiTxTData2 => uPort11AxiTxTData2,
      uPort11AxiTxTData3 => uPort11AxiTxTData3,
      uPort11AxiTxTKeep => uPort11AxiTxTKeep,
      uPort11AxiTxTLast => uPort11AxiTxTLast,
      uPort11AxiTxTValid => uPort11AxiTxTValid,
      uPort11AxiTxTReady => uPort11AxiTxTReady,
      uPort0AxiRxTData0 => uPort0AxiRxTData0,
      uPort0AxiRxTData1 => uPort0AxiRxTData1,
      uPort0AxiRxTData2 => uPort0AxiRxTData2,
      uPort0AxiRxTData3 => uPort0AxiRxTData3,
      uPort0AxiRxTKeep => uPort0AxiRxTKeep,
      uPort0AxiRxTLast => uPort0AxiRxTLast,
      uPort0AxiRxTValid => uPort0AxiRxTValid,
      uPort1AxiRxTData0 => uPort1AxiRxTData0,
      uPort1AxiRxTData1 => uPort1AxiRxTData1,
      uPort1AxiRxTData2 => uPort1AxiRxTData2,
      uPort1AxiRxTData3 => uPort1AxiRxTData3,
      uPort1AxiRxTKeep => uPort1AxiRxTKeep,
      uPort1AxiRxTLast => uPort1AxiRxTLast,
      uPort1AxiRxTValid => uPort1AxiRxTValid,
      uPort2AxiRxTData0 => uPort2AxiRxTData0,
      uPort2AxiRxTData1 => uPort2AxiRxTData1,
      uPort2AxiRxTData2 => uPort2AxiRxTData2,
      uPort2AxiRxTData3 => uPort2AxiRxTData3,
      uPort2AxiRxTKeep => uPort2AxiRxTKeep,
      uPort2AxiRxTLast => uPort2AxiRxTLast,
      uPort2AxiRxTValid => uPort2AxiRxTValid,
      uPort3AxiRxTData0 => uPort3AxiRxTData0,
      uPort3AxiRxTData1 => uPort3AxiRxTData1,
      uPort3AxiRxTData2 => uPort3AxiRxTData2,
      uPort3AxiRxTData3 => uPort3AxiRxTData3,
      uPort3AxiRxTKeep => uPort3AxiRxTKeep,
      uPort3AxiRxTLast => uPort3AxiRxTLast,
      uPort3AxiRxTValid => uPort3AxiRxTValid,
      uPort4AxiRxTData0 => uPort4AxiRxTData0,
      uPort4AxiRxTData1 => uPort4AxiRxTData1,
      uPort4AxiRxTData2 => uPort4AxiRxTData2,
      uPort4AxiRxTData3 => uPort4AxiRxTData3,
      uPort4AxiRxTKeep => uPort4AxiRxTKeep,
      uPort4AxiRxTLast => uPort4AxiRxTLast,
      uPort4AxiRxTValid => uPort4AxiRxTValid,
      uPort5AxiRxTData0 => uPort5AxiRxTData0,
      uPort5AxiRxTData1 => uPort5AxiRxTData1,
      uPort5AxiRxTData2 => uPort5AxiRxTData2,
      uPort5AxiRxTData3 => uPort5AxiRxTData3,
      uPort5AxiRxTKeep => uPort5AxiRxTKeep,
      uPort5AxiRxTLast => uPort5AxiRxTLast,
      uPort5AxiRxTValid => uPort5AxiRxTValid,
      uPort6AxiRxTData0 => uPort6AxiRxTData0,
      uPort6AxiRxTData1 => uPort6AxiRxTData1,
      uPort6AxiRxTData2 => uPort6AxiRxTData2,
      uPort6AxiRxTData3 => uPort6AxiRxTData3,
      uPort6AxiRxTKeep => uPort6AxiRxTKeep,
      uPort6AxiRxTLast => uPort6AxiRxTLast,
      uPort6AxiRxTValid => uPort6AxiRxTValid,
      uPort7AxiRxTData0 => uPort7AxiRxTData0,
      uPort7AxiRxTData1 => uPort7AxiRxTData1,
      uPort7AxiRxTData2 => uPort7AxiRxTData2,
      uPort7AxiRxTData3 => uPort7AxiRxTData3,
      uPort7AxiRxTKeep => uPort7AxiRxTKeep,
      uPort7AxiRxTLast => uPort7AxiRxTLast,
      uPort7AxiRxTValid => uPort7AxiRxTValid,
      uPort8AxiRxTData0 => uPort8AxiRxTData0,
      uPort8AxiRxTData1 => uPort8AxiRxTData1,
      uPort8AxiRxTData2 => uPort8AxiRxTData2,
      uPort8AxiRxTData3 => uPort8AxiRxTData3,
      uPort8AxiRxTKeep => uPort8AxiRxTKeep,
      uPort8AxiRxTLast => uPort8AxiRxTLast,
      uPort8AxiRxTValid => uPort8AxiRxTValid,
      uPort9AxiRxTData0 => uPort9AxiRxTData0,
      uPort9AxiRxTData1 => uPort9AxiRxTData1,
      uPort9AxiRxTData2 => uPort9AxiRxTData2,
      uPort9AxiRxTData3 => uPort9AxiRxTData3,
      uPort9AxiRxTKeep => uPort9AxiRxTKeep,
      uPort9AxiRxTLast => uPort9AxiRxTLast,
      uPort9AxiRxTValid => uPort9AxiRxTValid,
      uPort10AxiRxTData0 => uPort10AxiRxTData0,
      uPort10AxiRxTData1 => uPort10AxiRxTData1,
      uPort10AxiRxTData2 => uPort10AxiRxTData2,
      uPort10AxiRxTData3 => uPort10AxiRxTData3,
      uPort10AxiRxTKeep => uPort10AxiRxTKeep,
      uPort10AxiRxTLast => uPort10AxiRxTLast,
      uPort10AxiRxTValid => uPort10AxiRxTValid,
      uPort11AxiRxTData0 => uPort11AxiRxTData0,
      uPort11AxiRxTData1 => uPort11AxiRxTData1,
      uPort11AxiRxTData2 => uPort11AxiRxTData2,
      uPort11AxiRxTData3 => uPort11AxiRxTData3,
      uPort11AxiRxTKeep => uPort11AxiRxTKeep,
      uPort11AxiRxTLast => uPort11AxiRxTLast,
      uPort11AxiRxTValid => uPort11AxiRxTValid,
      uPort0AxiNfcTValid => uPort0AxiNfcTValid,
      uPort0AxiNfcTData => uPort0AxiNfcTData,
      uPort0AxiNfcTReady => uPort0AxiNfcTReady,
      uPort1AxiNfcTValid => uPort1AxiNfcTValid,
      uPort1AxiNfcTData => uPort1AxiNfcTData,
      uPort1AxiNfcTReady => uPort1AxiNfcTReady,
      uPort2AxiNfcTValid => uPort2AxiNfcTValid,
      uPort2AxiNfcTData => uPort2AxiNfcTData,
      uPort2AxiNfcTReady => uPort2AxiNfcTReady,
      uPort3AxiNfcTValid => uPort3AxiNfcTValid,
      uPort3AxiNfcTData => uPort3AxiNfcTData,
      uPort3AxiNfcTReady => uPort3AxiNfcTReady,
      uPort4AxiNfcTValid => uPort4AxiNfcTValid,
      uPort4AxiNfcTData => uPort4AxiNfcTData,
      uPort4AxiNfcTReady => uPort4AxiNfcTReady,
      uPort5AxiNfcTValid => uPort5AxiNfcTValid,
      uPort5AxiNfcTData => uPort5AxiNfcTData,
      uPort5AxiNfcTReady => uPort5AxiNfcTReady,
      uPort6AxiNfcTValid => uPort6AxiNfcTValid,
      uPort6AxiNfcTData => uPort6AxiNfcTData,
      uPort6AxiNfcTReady => uPort6AxiNfcTReady,
      uPort7AxiNfcTValid => uPort7AxiNfcTValid,
      uPort7AxiNfcTData => uPort7AxiNfcTData,
      uPort7AxiNfcTReady => uPort7AxiNfcTReady,
      uPort8AxiNfcTValid => uPort8AxiNfcTValid,
      uPort8AxiNfcTData => uPort8AxiNfcTData,
      uPort8AxiNfcTReady => uPort8AxiNfcTReady,
      uPort9AxiNfcTValid => uPort9AxiNfcTValid,
      uPort9AxiNfcTData => uPort9AxiNfcTData,
      uPort9AxiNfcTReady => uPort9AxiNfcTReady,
      uPort10AxiNfcTValid => uPort10AxiNfcTValid,
      uPort10AxiNfcTData => uPort10AxiNfcTData,
      uPort10AxiNfcTReady => uPort10AxiNfcTReady,
      uPort11AxiNfcTValid => uPort11AxiNfcTValid,
      uPort11AxiNfcTData => uPort11AxiNfcTData,
      uPort11AxiNfcTReady => uPort11AxiNfcTReady,
      uPort0HardError => uPort0HardError,
      uPort0SoftError => uPort0SoftError,
      uPort0LaneUp => uPort0LaneUp,
      uPort0ChannelUp => uPort0ChannelUp,
      uPort0SysResetOut => uPort0SysResetOut,
      uPort0MmcmNotLockOut => uPort0MmcmNotLockOut,
      uPort0CrcPassFail_n => uPort0CrcPassFail_n,
      uPort0CrcValid => uPort0CrcValid,
      uPort1HardError => uPort1HardError,
      uPort1SoftError => uPort1SoftError,
      uPort1LaneUp => uPort1LaneUp,
      uPort1ChannelUp => uPort1ChannelUp,
      uPort1SysResetOut => uPort1SysResetOut,
      uPort1MmcmNotLockOut => uPort1MmcmNotLockOut,
      uPort1CrcPassFail_n => uPort1CrcPassFail_n,
      uPort1CrcValid => uPort1CrcValid,
      uPort2HardError => uPort2HardError,
      uPort2SoftError => uPort2SoftError,
      uPort2LaneUp => uPort2LaneUp,
      uPort2ChannelUp => uPort2ChannelUp,
      uPort2SysResetOut => uPort2SysResetOut,
      uPort2MmcmNotLockOut => uPort2MmcmNotLockOut,
      uPort2CrcPassFail_n => uPort2CrcPassFail_n,
      uPort2CrcValid => uPort2CrcValid,
      uPort3HardError => uPort3HardError,
      uPort3SoftError => uPort3SoftError,
      uPort3LaneUp => uPort3LaneUp,
      uPort3ChannelUp => uPort3ChannelUp,
      uPort3SysResetOut => uPort3SysResetOut,
      uPort3MmcmNotLockOut => uPort3MmcmNotLockOut,
      uPort3CrcPassFail_n => uPort3CrcPassFail_n,
      uPort3CrcValid => uPort3CrcValid,
      uPort4HardError => uPort4HardError,
      uPort4SoftError => uPort4SoftError,
      uPort4LaneUp => uPort4LaneUp,
      uPort4ChannelUp => uPort4ChannelUp,
      uPort4SysResetOut => uPort4SysResetOut,
      uPort4MmcmNotLockOut => uPort4MmcmNotLockOut,
      uPort4CrcPassFail_n => uPort4CrcPassFail_n,
      uPort4CrcValid => uPort4CrcValid,
      uPort5HardError => uPort5HardError,
      uPort5SoftError => uPort5SoftError,
      uPort5LaneUp => uPort5LaneUp,
      uPort5ChannelUp => uPort5ChannelUp,
      uPort5SysResetOut => uPort5SysResetOut,
      uPort5MmcmNotLockOut => uPort5MmcmNotLockOut,
      uPort5CrcPassFail_n => uPort5CrcPassFail_n,
      uPort5CrcValid => uPort5CrcValid,
      uPort6HardError => uPort6HardError,
      uPort6SoftError => uPort6SoftError,
      uPort6LaneUp => uPort6LaneUp,
      uPort6ChannelUp => uPort6ChannelUp,
      uPort6SysResetOut => uPort6SysResetOut,
      uPort6MmcmNotLockOut => uPort6MmcmNotLockOut,
      uPort6CrcPassFail_n => uPort6CrcPassFail_n,
      uPort6CrcValid => uPort6CrcValid,
      uPort7HardError => uPort7HardError,
      uPort7SoftError => uPort7SoftError,
      uPort7LaneUp => uPort7LaneUp,
      uPort7ChannelUp => uPort7ChannelUp,
      uPort7SysResetOut => uPort7SysResetOut,
      uPort7MmcmNotLockOut => uPort7MmcmNotLockOut,
      uPort7CrcPassFail_n => uPort7CrcPassFail_n,
      uPort7CrcValid => uPort7CrcValid,
      uPort8HardError => uPort8HardError,
      uPort8SoftError => uPort8SoftError,
      uPort8LaneUp => uPort8LaneUp,
      uPort8ChannelUp => uPort8ChannelUp,
      uPort8SysResetOut => uPort8SysResetOut,
      uPort8MmcmNotLockOut => uPort8MmcmNotLockOut,
      uPort8CrcPassFail_n => uPort8CrcPassFail_n,
      uPort8CrcValid => uPort8CrcValid,
      uPort9HardError => uPort9HardError,
      uPort9SoftError => uPort9SoftError,
      uPort9LaneUp => uPort9LaneUp,
      uPort9ChannelUp => uPort9ChannelUp,
      uPort9SysResetOut => uPort9SysResetOut,
      uPort9MmcmNotLockOut => uPort9MmcmNotLockOut,
      uPort9CrcPassFail_n => uPort9CrcPassFail_n,
      uPort9CrcValid => uPort9CrcValid,
      uPort10HardError => uPort10HardError,
      uPort10SoftError => uPort10SoftError,
      uPort10LaneUp => uPort10LaneUp,
      uPort10ChannelUp => uPort10ChannelUp,
      uPort10SysResetOut => uPort10SysResetOut,
      uPort10MmcmNotLockOut => uPort10MmcmNotLockOut,
      uPort10CrcPassFail_n => uPort10CrcPassFail_n,
      uPort10CrcValid => uPort10CrcValid,
      uPort11HardError => uPort11HardError,
      uPort11SoftError => uPort11SoftError,
      uPort11LaneUp => uPort11LaneUp,
      uPort11ChannelUp => uPort11ChannelUp,
      uPort11SysResetOut => uPort11SysResetOut,
      uPort11MmcmNotLockOut => uPort11MmcmNotLockOut,
      uPort11CrcPassFail_n => uPort11CrcPassFail_n,
      uPort11CrcValid => uPort11CrcValid,
      iPort0LinkResetOut => iPort0LinkResetOut,
      iPort1LinkResetOut => iPort1LinkResetOut,
      iPort2LinkResetOut => iPort2LinkResetOut,
      iPort3LinkResetOut => iPort3LinkResetOut,
      iPort4LinkResetOut => iPort4LinkResetOut,
      iPort5LinkResetOut => iPort5LinkResetOut,
      iPort6LinkResetOut => iPort6LinkResetOut,
      iPort7LinkResetOut => iPort7LinkResetOut,
      iPort8LinkResetOut => iPort8LinkResetOut,
      iPort9LinkResetOut => iPort9LinkResetOut,
      iPort10LinkResetOut => iPort10LinkResetOut,
      iPort11LinkResetOut => iPort11LinkResetOut,
      sGtwiz0CtrlAxiAWAddr => sGtwiz0CtrlAxiAWAddr,
      sGtwiz0CtrlAxiAWValid => sGtwiz0CtrlAxiAWValid,
      sGtwiz0CtrlAxiAWReady => sGtwiz0CtrlAxiAWReady,
      sGtwiz0CtrlAxiWData => sGtwiz0CtrlAxiWData,
      sGtwiz0CtrlAxiWStrb => sGtwiz0CtrlAxiWStrb,
      sGtwiz0CtrlAxiWValid => sGtwiz0CtrlAxiWValid,
      sGtwiz0CtrlAxiWReady => sGtwiz0CtrlAxiWReady,
      sGtwiz0CtrlAxiBResp => sGtwiz0CtrlAxiBResp,
      sGtwiz0CtrlAxiBValid => sGtwiz0CtrlAxiBValid,
      sGtwiz0CtrlAxiBReady => sGtwiz0CtrlAxiBReady,
      sGtwiz0CtrlAxiARAddr => sGtwiz0CtrlAxiARAddr,
      sGtwiz0CtrlAxiARValid => sGtwiz0CtrlAxiARValid,
      sGtwiz0CtrlAxiARReady => sGtwiz0CtrlAxiARReady,
      sGtwiz0CtrlAxiRData => sGtwiz0CtrlAxiRData,
      sGtwiz0CtrlAxiRResp => sGtwiz0CtrlAxiRResp,
      sGtwiz0CtrlAxiRValid => sGtwiz0CtrlAxiRValid,
      sGtwiz0CtrlAxiRReady => sGtwiz0CtrlAxiRReady,
      sGtwiz0DrpChAxiAWAddr => sGtwiz0DrpChAxiAWAddr,
      sGtwiz0DrpChAxiAWValid => sGtwiz0DrpChAxiAWValid,
      sGtwiz0DrpChAxiAWReady => sGtwiz0DrpChAxiAWReady,
      sGtwiz0DrpChAxiWData => sGtwiz0DrpChAxiWData,
      sGtwiz0DrpChAxiWStrb => sGtwiz0DrpChAxiWStrb,
      sGtwiz0DrpChAxiWValid => sGtwiz0DrpChAxiWValid,
      sGtwiz0DrpChAxiWReady => sGtwiz0DrpChAxiWReady,
      sGtwiz0DrpChAxiBResp => sGtwiz0DrpChAxiBResp,
      sGtwiz0DrpChAxiBValid => sGtwiz0DrpChAxiBValid,
      sGtwiz0DrpChAxiBReady => sGtwiz0DrpChAxiBReady,
      sGtwiz0DrpChAxiARAddr => sGtwiz0DrpChAxiARAddr,
      sGtwiz0DrpChAxiARValid => sGtwiz0DrpChAxiARValid,
      sGtwiz0DrpChAxiARReady => sGtwiz0DrpChAxiARReady,
      sGtwiz0DrpChAxiRData => sGtwiz0DrpChAxiRData,
      sGtwiz0DrpChAxiRResp => sGtwiz0DrpChAxiRResp,
      sGtwiz0DrpChAxiRValid => sGtwiz0DrpChAxiRValid,
      sGtwiz0DrpChAxiRReady => sGtwiz0DrpChAxiRReady,
      sGtwiz1CtrlAxiAWAddr => sGtwiz1CtrlAxiAWAddr,
      sGtwiz1CtrlAxiAWValid => sGtwiz1CtrlAxiAWValid,
      sGtwiz1CtrlAxiAWReady => sGtwiz1CtrlAxiAWReady,
      sGtwiz1CtrlAxiWData => sGtwiz1CtrlAxiWData,
      sGtwiz1CtrlAxiWStrb => sGtwiz1CtrlAxiWStrb,
      sGtwiz1CtrlAxiWValid => sGtwiz1CtrlAxiWValid,
      sGtwiz1CtrlAxiWReady => sGtwiz1CtrlAxiWReady,
      sGtwiz1CtrlAxiBResp => sGtwiz1CtrlAxiBResp,
      sGtwiz1CtrlAxiBValid => sGtwiz1CtrlAxiBValid,
      sGtwiz1CtrlAxiBReady => sGtwiz1CtrlAxiBReady,
      sGtwiz1CtrlAxiARAddr => sGtwiz1CtrlAxiARAddr,
      sGtwiz1CtrlAxiARValid => sGtwiz1CtrlAxiARValid,
      sGtwiz1CtrlAxiARReady => sGtwiz1CtrlAxiARReady,
      sGtwiz1CtrlAxiRData => sGtwiz1CtrlAxiRData,
      sGtwiz1CtrlAxiRResp => sGtwiz1CtrlAxiRResp,
      sGtwiz1CtrlAxiRValid => sGtwiz1CtrlAxiRValid,
      sGtwiz1CtrlAxiRReady => sGtwiz1CtrlAxiRReady,
      sGtwiz1DrpChAxiAWAddr => sGtwiz1DrpChAxiAWAddr,
      sGtwiz1DrpChAxiAWValid => sGtwiz1DrpChAxiAWValid,
      sGtwiz1DrpChAxiAWReady => sGtwiz1DrpChAxiAWReady,
      sGtwiz1DrpChAxiWData => sGtwiz1DrpChAxiWData,
      sGtwiz1DrpChAxiWStrb => sGtwiz1DrpChAxiWStrb,
      sGtwiz1DrpChAxiWValid => sGtwiz1DrpChAxiWValid,
      sGtwiz1DrpChAxiWReady => sGtwiz1DrpChAxiWReady,
      sGtwiz1DrpChAxiBResp => sGtwiz1DrpChAxiBResp,
      sGtwiz1DrpChAxiBValid => sGtwiz1DrpChAxiBValid,
      sGtwiz1DrpChAxiBReady => sGtwiz1DrpChAxiBReady,
      sGtwiz1DrpChAxiARAddr => sGtwiz1DrpChAxiARAddr,
      sGtwiz1DrpChAxiARValid => sGtwiz1DrpChAxiARValid,
      sGtwiz1DrpChAxiARReady => sGtwiz1DrpChAxiARReady,
      sGtwiz1DrpChAxiRData => sGtwiz1DrpChAxiRData,
      sGtwiz1DrpChAxiRResp => sGtwiz1DrpChAxiRResp,
      sGtwiz1DrpChAxiRValid => sGtwiz1DrpChAxiRValid,
      sGtwiz1DrpChAxiRReady => sGtwiz1DrpChAxiRReady,
      sGtwiz2CtrlAxiAWAddr => sGtwiz2CtrlAxiAWAddr,
      sGtwiz2CtrlAxiAWValid => sGtwiz2CtrlAxiAWValid,
      sGtwiz2CtrlAxiAWReady => sGtwiz2CtrlAxiAWReady,
      sGtwiz2CtrlAxiWData => sGtwiz2CtrlAxiWData,
      sGtwiz2CtrlAxiWStrb => sGtwiz2CtrlAxiWStrb,
      sGtwiz2CtrlAxiWValid => sGtwiz2CtrlAxiWValid,
      sGtwiz2CtrlAxiWReady => sGtwiz2CtrlAxiWReady,
      sGtwiz2CtrlAxiBResp => sGtwiz2CtrlAxiBResp,
      sGtwiz2CtrlAxiBValid => sGtwiz2CtrlAxiBValid,
      sGtwiz2CtrlAxiBReady => sGtwiz2CtrlAxiBReady,
      sGtwiz2CtrlAxiARAddr => sGtwiz2CtrlAxiARAddr,
      sGtwiz2CtrlAxiARValid => sGtwiz2CtrlAxiARValid,
      sGtwiz2CtrlAxiARReady => sGtwiz2CtrlAxiARReady,
      sGtwiz2CtrlAxiRData => sGtwiz2CtrlAxiRData,
      sGtwiz2CtrlAxiRResp => sGtwiz2CtrlAxiRResp,
      sGtwiz2CtrlAxiRValid => sGtwiz2CtrlAxiRValid,
      sGtwiz2CtrlAxiRReady => sGtwiz2CtrlAxiRReady,
      sGtwiz2DrpChAxiAWAddr => sGtwiz2DrpChAxiAWAddr,
      sGtwiz2DrpChAxiAWValid => sGtwiz2DrpChAxiAWValid,
      sGtwiz2DrpChAxiAWReady => sGtwiz2DrpChAxiAWReady,
      sGtwiz2DrpChAxiWData => sGtwiz2DrpChAxiWData,
      sGtwiz2DrpChAxiWStrb => sGtwiz2DrpChAxiWStrb,
      sGtwiz2DrpChAxiWValid => sGtwiz2DrpChAxiWValid,
      sGtwiz2DrpChAxiWReady => sGtwiz2DrpChAxiWReady,
      sGtwiz2DrpChAxiBResp => sGtwiz2DrpChAxiBResp,
      sGtwiz2DrpChAxiBValid => sGtwiz2DrpChAxiBValid,
      sGtwiz2DrpChAxiBReady => sGtwiz2DrpChAxiBReady,
      sGtwiz2DrpChAxiARAddr => sGtwiz2DrpChAxiARAddr,
      sGtwiz2DrpChAxiARValid => sGtwiz2DrpChAxiARValid,
      sGtwiz2DrpChAxiARReady => sGtwiz2DrpChAxiARReady,
      sGtwiz2DrpChAxiRData => sGtwiz2DrpChAxiRData,
      sGtwiz2DrpChAxiRResp => sGtwiz2DrpChAxiRResp,
      sGtwiz2DrpChAxiRValid => sGtwiz2DrpChAxiRValid,
      sGtwiz2DrpChAxiRReady => sGtwiz2DrpChAxiRReady,
      sGtwiz3CtrlAxiAWAddr => sGtwiz3CtrlAxiAWAddr,
      sGtwiz3CtrlAxiAWValid => sGtwiz3CtrlAxiAWValid,
      sGtwiz3CtrlAxiAWReady => sGtwiz3CtrlAxiAWReady,
      sGtwiz3CtrlAxiWData => sGtwiz3CtrlAxiWData,
      sGtwiz3CtrlAxiWStrb => sGtwiz3CtrlAxiWStrb,
      sGtwiz3CtrlAxiWValid => sGtwiz3CtrlAxiWValid,
      sGtwiz3CtrlAxiWReady => sGtwiz3CtrlAxiWReady,
      sGtwiz3CtrlAxiBResp => sGtwiz3CtrlAxiBResp,
      sGtwiz3CtrlAxiBValid => sGtwiz3CtrlAxiBValid,
      sGtwiz3CtrlAxiBReady => sGtwiz3CtrlAxiBReady,
      sGtwiz3CtrlAxiARAddr => sGtwiz3CtrlAxiARAddr,
      sGtwiz3CtrlAxiARValid => sGtwiz3CtrlAxiARValid,
      sGtwiz3CtrlAxiARReady => sGtwiz3CtrlAxiARReady,
      sGtwiz3CtrlAxiRData => sGtwiz3CtrlAxiRData,
      sGtwiz3CtrlAxiRResp => sGtwiz3CtrlAxiRResp,
      sGtwiz3CtrlAxiRValid => sGtwiz3CtrlAxiRValid,
      sGtwiz3CtrlAxiRReady => sGtwiz3CtrlAxiRReady,
      sGtwiz3DrpChAxiAWAddr => sGtwiz3DrpChAxiAWAddr,
      sGtwiz3DrpChAxiAWValid => sGtwiz3DrpChAxiAWValid,
      sGtwiz3DrpChAxiAWReady => sGtwiz3DrpChAxiAWReady,
      sGtwiz3DrpChAxiWData => sGtwiz3DrpChAxiWData,
      sGtwiz3DrpChAxiWStrb => sGtwiz3DrpChAxiWStrb,
      sGtwiz3DrpChAxiWValid => sGtwiz3DrpChAxiWValid,
      sGtwiz3DrpChAxiWReady => sGtwiz3DrpChAxiWReady,
      sGtwiz3DrpChAxiBResp => sGtwiz3DrpChAxiBResp,
      sGtwiz3DrpChAxiBValid => sGtwiz3DrpChAxiBValid,
      sGtwiz3DrpChAxiBReady => sGtwiz3DrpChAxiBReady,
      sGtwiz3DrpChAxiARAddr => sGtwiz3DrpChAxiARAddr,
      sGtwiz3DrpChAxiARValid => sGtwiz3DrpChAxiARValid,
      sGtwiz3DrpChAxiARReady => sGtwiz3DrpChAxiARReady,
      sGtwiz3DrpChAxiRData => sGtwiz3DrpChAxiRData,
      sGtwiz3DrpChAxiRResp => sGtwiz3DrpChAxiRResp,
      sGtwiz3DrpChAxiRValid => sGtwiz3DrpChAxiRValid,
      sGtwiz3DrpChAxiRReady => sGtwiz3DrpChAxiRReady,
      sGtwiz4CtrlAxiAWAddr => sGtwiz4CtrlAxiAWAddr,
      sGtwiz4CtrlAxiAWValid => sGtwiz4CtrlAxiAWValid,
      sGtwiz4CtrlAxiAWReady => sGtwiz4CtrlAxiAWReady,
      sGtwiz4CtrlAxiWData => sGtwiz4CtrlAxiWData,
      sGtwiz4CtrlAxiWStrb => sGtwiz4CtrlAxiWStrb,
      sGtwiz4CtrlAxiWValid => sGtwiz4CtrlAxiWValid,
      sGtwiz4CtrlAxiWReady => sGtwiz4CtrlAxiWReady,
      sGtwiz4CtrlAxiBResp => sGtwiz4CtrlAxiBResp,
      sGtwiz4CtrlAxiBValid => sGtwiz4CtrlAxiBValid,
      sGtwiz4CtrlAxiBReady => sGtwiz4CtrlAxiBReady,
      sGtwiz4CtrlAxiARAddr => sGtwiz4CtrlAxiARAddr,
      sGtwiz4CtrlAxiARValid => sGtwiz4CtrlAxiARValid,
      sGtwiz4CtrlAxiARReady => sGtwiz4CtrlAxiARReady,
      sGtwiz4CtrlAxiRData => sGtwiz4CtrlAxiRData,
      sGtwiz4CtrlAxiRResp => sGtwiz4CtrlAxiRResp,
      sGtwiz4CtrlAxiRValid => sGtwiz4CtrlAxiRValid,
      sGtwiz4CtrlAxiRReady => sGtwiz4CtrlAxiRReady,
      sGtwiz4DrpChAxiAWAddr => sGtwiz4DrpChAxiAWAddr,
      sGtwiz4DrpChAxiAWValid => sGtwiz4DrpChAxiAWValid,
      sGtwiz4DrpChAxiAWReady => sGtwiz4DrpChAxiAWReady,
      sGtwiz4DrpChAxiWData => sGtwiz4DrpChAxiWData,
      sGtwiz4DrpChAxiWStrb => sGtwiz4DrpChAxiWStrb,
      sGtwiz4DrpChAxiWValid => sGtwiz4DrpChAxiWValid,
      sGtwiz4DrpChAxiWReady => sGtwiz4DrpChAxiWReady,
      sGtwiz4DrpChAxiBResp => sGtwiz4DrpChAxiBResp,
      sGtwiz4DrpChAxiBValid => sGtwiz4DrpChAxiBValid,
      sGtwiz4DrpChAxiBReady => sGtwiz4DrpChAxiBReady,
      sGtwiz4DrpChAxiARAddr => sGtwiz4DrpChAxiARAddr,
      sGtwiz4DrpChAxiARValid => sGtwiz4DrpChAxiARValid,
      sGtwiz4DrpChAxiARReady => sGtwiz4DrpChAxiARReady,
      sGtwiz4DrpChAxiRData => sGtwiz4DrpChAxiRData,
      sGtwiz4DrpChAxiRResp => sGtwiz4DrpChAxiRResp,
      sGtwiz4DrpChAxiRValid => sGtwiz4DrpChAxiRValid,
      sGtwiz4DrpChAxiRReady => sGtwiz4DrpChAxiRReady,
      sGtwiz5CtrlAxiAWAddr => sGtwiz5CtrlAxiAWAddr,
      sGtwiz5CtrlAxiAWValid => sGtwiz5CtrlAxiAWValid,
      sGtwiz5CtrlAxiAWReady => sGtwiz5CtrlAxiAWReady,
      sGtwiz5CtrlAxiWData => sGtwiz5CtrlAxiWData,
      sGtwiz5CtrlAxiWStrb => sGtwiz5CtrlAxiWStrb,
      sGtwiz5CtrlAxiWValid => sGtwiz5CtrlAxiWValid,
      sGtwiz5CtrlAxiWReady => sGtwiz5CtrlAxiWReady,
      sGtwiz5CtrlAxiBResp => sGtwiz5CtrlAxiBResp,
      sGtwiz5CtrlAxiBValid => sGtwiz5CtrlAxiBValid,
      sGtwiz5CtrlAxiBReady => sGtwiz5CtrlAxiBReady,
      sGtwiz5CtrlAxiARAddr => sGtwiz5CtrlAxiARAddr,
      sGtwiz5CtrlAxiARValid => sGtwiz5CtrlAxiARValid,
      sGtwiz5CtrlAxiARReady => sGtwiz5CtrlAxiARReady,
      sGtwiz5CtrlAxiRData => sGtwiz5CtrlAxiRData,
      sGtwiz5CtrlAxiRResp => sGtwiz5CtrlAxiRResp,
      sGtwiz5CtrlAxiRValid => sGtwiz5CtrlAxiRValid,
      sGtwiz5CtrlAxiRReady => sGtwiz5CtrlAxiRReady,
      sGtwiz5DrpChAxiAWAddr => sGtwiz5DrpChAxiAWAddr,
      sGtwiz5DrpChAxiAWValid => sGtwiz5DrpChAxiAWValid,
      sGtwiz5DrpChAxiAWReady => sGtwiz5DrpChAxiAWReady,
      sGtwiz5DrpChAxiWData => sGtwiz5DrpChAxiWData,
      sGtwiz5DrpChAxiWStrb => sGtwiz5DrpChAxiWStrb,
      sGtwiz5DrpChAxiWValid => sGtwiz5DrpChAxiWValid,
      sGtwiz5DrpChAxiWReady => sGtwiz5DrpChAxiWReady,
      sGtwiz5DrpChAxiBResp => sGtwiz5DrpChAxiBResp,
      sGtwiz5DrpChAxiBValid => sGtwiz5DrpChAxiBValid,
      sGtwiz5DrpChAxiBReady => sGtwiz5DrpChAxiBReady,
      sGtwiz5DrpChAxiARAddr => sGtwiz5DrpChAxiARAddr,
      sGtwiz5DrpChAxiARValid => sGtwiz5DrpChAxiARValid,
      sGtwiz5DrpChAxiARReady => sGtwiz5DrpChAxiARReady,
      sGtwiz5DrpChAxiRData => sGtwiz5DrpChAxiRData,
      sGtwiz5DrpChAxiRResp => sGtwiz5DrpChAxiRResp,
      sGtwiz5DrpChAxiRValid => sGtwiz5DrpChAxiRValid,
      sGtwiz5DrpChAxiRReady => sGtwiz5DrpChAxiRReady,
      sGtwiz6CtrlAxiAWAddr => sGtwiz6CtrlAxiAWAddr,
      sGtwiz6CtrlAxiAWValid => sGtwiz6CtrlAxiAWValid,
      sGtwiz6CtrlAxiAWReady => sGtwiz6CtrlAxiAWReady,
      sGtwiz6CtrlAxiWData => sGtwiz6CtrlAxiWData,
      sGtwiz6CtrlAxiWStrb => sGtwiz6CtrlAxiWStrb,
      sGtwiz6CtrlAxiWValid => sGtwiz6CtrlAxiWValid,
      sGtwiz6CtrlAxiWReady => sGtwiz6CtrlAxiWReady,
      sGtwiz6CtrlAxiBResp => sGtwiz6CtrlAxiBResp,
      sGtwiz6CtrlAxiBValid => sGtwiz6CtrlAxiBValid,
      sGtwiz6CtrlAxiBReady => sGtwiz6CtrlAxiBReady,
      sGtwiz6CtrlAxiARAddr => sGtwiz6CtrlAxiARAddr,
      sGtwiz6CtrlAxiARValid => sGtwiz6CtrlAxiARValid,
      sGtwiz6CtrlAxiARReady => sGtwiz6CtrlAxiARReady,
      sGtwiz6CtrlAxiRData => sGtwiz6CtrlAxiRData,
      sGtwiz6CtrlAxiRResp => sGtwiz6CtrlAxiRResp,
      sGtwiz6CtrlAxiRValid => sGtwiz6CtrlAxiRValid,
      sGtwiz6CtrlAxiRReady => sGtwiz6CtrlAxiRReady,
      sGtwiz6DrpChAxiAWAddr => sGtwiz6DrpChAxiAWAddr,
      sGtwiz6DrpChAxiAWValid => sGtwiz6DrpChAxiAWValid,
      sGtwiz6DrpChAxiAWReady => sGtwiz6DrpChAxiAWReady,
      sGtwiz6DrpChAxiWData => sGtwiz6DrpChAxiWData,
      sGtwiz6DrpChAxiWStrb => sGtwiz6DrpChAxiWStrb,
      sGtwiz6DrpChAxiWValid => sGtwiz6DrpChAxiWValid,
      sGtwiz6DrpChAxiWReady => sGtwiz6DrpChAxiWReady,
      sGtwiz6DrpChAxiBResp => sGtwiz6DrpChAxiBResp,
      sGtwiz6DrpChAxiBValid => sGtwiz6DrpChAxiBValid,
      sGtwiz6DrpChAxiBReady => sGtwiz6DrpChAxiBReady,
      sGtwiz6DrpChAxiARAddr => sGtwiz6DrpChAxiARAddr,
      sGtwiz6DrpChAxiARValid => sGtwiz6DrpChAxiARValid,
      sGtwiz6DrpChAxiARReady => sGtwiz6DrpChAxiARReady,
      sGtwiz6DrpChAxiRData => sGtwiz6DrpChAxiRData,
      sGtwiz6DrpChAxiRResp => sGtwiz6DrpChAxiRResp,
      sGtwiz6DrpChAxiRValid => sGtwiz6DrpChAxiRValid,
      sGtwiz6DrpChAxiRReady => sGtwiz6DrpChAxiRReady,
      sGtwiz7CtrlAxiAWAddr => sGtwiz7CtrlAxiAWAddr,
      sGtwiz7CtrlAxiAWValid => sGtwiz7CtrlAxiAWValid,
      sGtwiz7CtrlAxiAWReady => sGtwiz7CtrlAxiAWReady,
      sGtwiz7CtrlAxiWData => sGtwiz7CtrlAxiWData,
      sGtwiz7CtrlAxiWStrb => sGtwiz7CtrlAxiWStrb,
      sGtwiz7CtrlAxiWValid => sGtwiz7CtrlAxiWValid,
      sGtwiz7CtrlAxiWReady => sGtwiz7CtrlAxiWReady,
      sGtwiz7CtrlAxiBResp => sGtwiz7CtrlAxiBResp,
      sGtwiz7CtrlAxiBValid => sGtwiz7CtrlAxiBValid,
      sGtwiz7CtrlAxiBReady => sGtwiz7CtrlAxiBReady,
      sGtwiz7CtrlAxiARAddr => sGtwiz7CtrlAxiARAddr,
      sGtwiz7CtrlAxiARValid => sGtwiz7CtrlAxiARValid,
      sGtwiz7CtrlAxiARReady => sGtwiz7CtrlAxiARReady,
      sGtwiz7CtrlAxiRData => sGtwiz7CtrlAxiRData,
      sGtwiz7CtrlAxiRResp => sGtwiz7CtrlAxiRResp,
      sGtwiz7CtrlAxiRValid => sGtwiz7CtrlAxiRValid,
      sGtwiz7CtrlAxiRReady => sGtwiz7CtrlAxiRReady,
      sGtwiz7DrpChAxiAWAddr => sGtwiz7DrpChAxiAWAddr,
      sGtwiz7DrpChAxiAWValid => sGtwiz7DrpChAxiAWValid,
      sGtwiz7DrpChAxiAWReady => sGtwiz7DrpChAxiAWReady,
      sGtwiz7DrpChAxiWData => sGtwiz7DrpChAxiWData,
      sGtwiz7DrpChAxiWStrb => sGtwiz7DrpChAxiWStrb,
      sGtwiz7DrpChAxiWValid => sGtwiz7DrpChAxiWValid,
      sGtwiz7DrpChAxiWReady => sGtwiz7DrpChAxiWReady,
      sGtwiz7DrpChAxiBResp => sGtwiz7DrpChAxiBResp,
      sGtwiz7DrpChAxiBValid => sGtwiz7DrpChAxiBValid,
      sGtwiz7DrpChAxiBReady => sGtwiz7DrpChAxiBReady,
      sGtwiz7DrpChAxiARAddr => sGtwiz7DrpChAxiARAddr,
      sGtwiz7DrpChAxiARValid => sGtwiz7DrpChAxiARValid,
      sGtwiz7DrpChAxiARReady => sGtwiz7DrpChAxiARReady,
      sGtwiz7DrpChAxiRData => sGtwiz7DrpChAxiRData,
      sGtwiz7DrpChAxiRResp => sGtwiz7DrpChAxiRResp,
      sGtwiz7DrpChAxiRValid => sGtwiz7DrpChAxiRValid,
      sGtwiz7DrpChAxiRReady => sGtwiz7DrpChAxiRReady,
      sGtwiz8CtrlAxiAWAddr => sGtwiz8CtrlAxiAWAddr,
      sGtwiz8CtrlAxiAWValid => sGtwiz8CtrlAxiAWValid,
      sGtwiz8CtrlAxiAWReady => sGtwiz8CtrlAxiAWReady,
      sGtwiz8CtrlAxiWData => sGtwiz8CtrlAxiWData,
      sGtwiz8CtrlAxiWStrb => sGtwiz8CtrlAxiWStrb,
      sGtwiz8CtrlAxiWValid => sGtwiz8CtrlAxiWValid,
      sGtwiz8CtrlAxiWReady => sGtwiz8CtrlAxiWReady,
      sGtwiz8CtrlAxiBResp => sGtwiz8CtrlAxiBResp,
      sGtwiz8CtrlAxiBValid => sGtwiz8CtrlAxiBValid,
      sGtwiz8CtrlAxiBReady => sGtwiz8CtrlAxiBReady,
      sGtwiz8CtrlAxiARAddr => sGtwiz8CtrlAxiARAddr,
      sGtwiz8CtrlAxiARValid => sGtwiz8CtrlAxiARValid,
      sGtwiz8CtrlAxiARReady => sGtwiz8CtrlAxiARReady,
      sGtwiz8CtrlAxiRData => sGtwiz8CtrlAxiRData,
      sGtwiz8CtrlAxiRResp => sGtwiz8CtrlAxiRResp,
      sGtwiz8CtrlAxiRValid => sGtwiz8CtrlAxiRValid,
      sGtwiz8CtrlAxiRReady => sGtwiz8CtrlAxiRReady,
      sGtwiz8DrpChAxiAWAddr => sGtwiz8DrpChAxiAWAddr,
      sGtwiz8DrpChAxiAWValid => sGtwiz8DrpChAxiAWValid,
      sGtwiz8DrpChAxiAWReady => sGtwiz8DrpChAxiAWReady,
      sGtwiz8DrpChAxiWData => sGtwiz8DrpChAxiWData,
      sGtwiz8DrpChAxiWStrb => sGtwiz8DrpChAxiWStrb,
      sGtwiz8DrpChAxiWValid => sGtwiz8DrpChAxiWValid,
      sGtwiz8DrpChAxiWReady => sGtwiz8DrpChAxiWReady,
      sGtwiz8DrpChAxiBResp => sGtwiz8DrpChAxiBResp,
      sGtwiz8DrpChAxiBValid => sGtwiz8DrpChAxiBValid,
      sGtwiz8DrpChAxiBReady => sGtwiz8DrpChAxiBReady,
      sGtwiz8DrpChAxiARAddr => sGtwiz8DrpChAxiARAddr,
      sGtwiz8DrpChAxiARValid => sGtwiz8DrpChAxiARValid,
      sGtwiz8DrpChAxiARReady => sGtwiz8DrpChAxiARReady,
      sGtwiz8DrpChAxiRData => sGtwiz8DrpChAxiRData,
      sGtwiz8DrpChAxiRResp => sGtwiz8DrpChAxiRResp,
      sGtwiz8DrpChAxiRValid => sGtwiz8DrpChAxiRValid,
      sGtwiz8DrpChAxiRReady => sGtwiz8DrpChAxiRReady,
      sGtwiz9CtrlAxiAWAddr => sGtwiz9CtrlAxiAWAddr,
      sGtwiz9CtrlAxiAWValid => sGtwiz9CtrlAxiAWValid,
      sGtwiz9CtrlAxiAWReady => sGtwiz9CtrlAxiAWReady,
      sGtwiz9CtrlAxiWData => sGtwiz9CtrlAxiWData,
      sGtwiz9CtrlAxiWStrb => sGtwiz9CtrlAxiWStrb,
      sGtwiz9CtrlAxiWValid => sGtwiz9CtrlAxiWValid,
      sGtwiz9CtrlAxiWReady => sGtwiz9CtrlAxiWReady,
      sGtwiz9CtrlAxiBResp => sGtwiz9CtrlAxiBResp,
      sGtwiz9CtrlAxiBValid => sGtwiz9CtrlAxiBValid,
      sGtwiz9CtrlAxiBReady => sGtwiz9CtrlAxiBReady,
      sGtwiz9CtrlAxiARAddr => sGtwiz9CtrlAxiARAddr,
      sGtwiz9CtrlAxiARValid => sGtwiz9CtrlAxiARValid,
      sGtwiz9CtrlAxiARReady => sGtwiz9CtrlAxiARReady,
      sGtwiz9CtrlAxiRData => sGtwiz9CtrlAxiRData,
      sGtwiz9CtrlAxiRResp => sGtwiz9CtrlAxiRResp,
      sGtwiz9CtrlAxiRValid => sGtwiz9CtrlAxiRValid,
      sGtwiz9CtrlAxiRReady => sGtwiz9CtrlAxiRReady,
      sGtwiz9DrpChAxiAWAddr => sGtwiz9DrpChAxiAWAddr,
      sGtwiz9DrpChAxiAWValid => sGtwiz9DrpChAxiAWValid,
      sGtwiz9DrpChAxiAWReady => sGtwiz9DrpChAxiAWReady,
      sGtwiz9DrpChAxiWData => sGtwiz9DrpChAxiWData,
      sGtwiz9DrpChAxiWStrb => sGtwiz9DrpChAxiWStrb,
      sGtwiz9DrpChAxiWValid => sGtwiz9DrpChAxiWValid,
      sGtwiz9DrpChAxiWReady => sGtwiz9DrpChAxiWReady,
      sGtwiz9DrpChAxiBResp => sGtwiz9DrpChAxiBResp,
      sGtwiz9DrpChAxiBValid => sGtwiz9DrpChAxiBValid,
      sGtwiz9DrpChAxiBReady => sGtwiz9DrpChAxiBReady,
      sGtwiz9DrpChAxiARAddr => sGtwiz9DrpChAxiARAddr,
      sGtwiz9DrpChAxiARValid => sGtwiz9DrpChAxiARValid,
      sGtwiz9DrpChAxiARReady => sGtwiz9DrpChAxiARReady,
      sGtwiz9DrpChAxiRData => sGtwiz9DrpChAxiRData,
      sGtwiz9DrpChAxiRResp => sGtwiz9DrpChAxiRResp,
      sGtwiz9DrpChAxiRValid => sGtwiz9DrpChAxiRValid,
      sGtwiz9DrpChAxiRReady => sGtwiz9DrpChAxiRReady,
      sGtwiz10CtrlAxiAWAddr => sGtwiz10CtrlAxiAWAddr,
      sGtwiz10CtrlAxiAWValid => sGtwiz10CtrlAxiAWValid,
      sGtwiz10CtrlAxiAWReady => sGtwiz10CtrlAxiAWReady,
      sGtwiz10CtrlAxiWData => sGtwiz10CtrlAxiWData,
      sGtwiz10CtrlAxiWStrb => sGtwiz10CtrlAxiWStrb,
      sGtwiz10CtrlAxiWValid => sGtwiz10CtrlAxiWValid,
      sGtwiz10CtrlAxiWReady => sGtwiz10CtrlAxiWReady,
      sGtwiz10CtrlAxiBResp => sGtwiz10CtrlAxiBResp,
      sGtwiz10CtrlAxiBValid => sGtwiz10CtrlAxiBValid,
      sGtwiz10CtrlAxiBReady => sGtwiz10CtrlAxiBReady,
      sGtwiz10CtrlAxiARAddr => sGtwiz10CtrlAxiARAddr,
      sGtwiz10CtrlAxiARValid => sGtwiz10CtrlAxiARValid,
      sGtwiz10CtrlAxiARReady => sGtwiz10CtrlAxiARReady,
      sGtwiz10CtrlAxiRData => sGtwiz10CtrlAxiRData,
      sGtwiz10CtrlAxiRResp => sGtwiz10CtrlAxiRResp,
      sGtwiz10CtrlAxiRValid => sGtwiz10CtrlAxiRValid,
      sGtwiz10CtrlAxiRReady => sGtwiz10CtrlAxiRReady,
      sGtwiz10DrpChAxiAWAddr => sGtwiz10DrpChAxiAWAddr,
      sGtwiz10DrpChAxiAWValid => sGtwiz10DrpChAxiAWValid,
      sGtwiz10DrpChAxiAWReady => sGtwiz10DrpChAxiAWReady,
      sGtwiz10DrpChAxiWData => sGtwiz10DrpChAxiWData,
      sGtwiz10DrpChAxiWStrb => sGtwiz10DrpChAxiWStrb,
      sGtwiz10DrpChAxiWValid => sGtwiz10DrpChAxiWValid,
      sGtwiz10DrpChAxiWReady => sGtwiz10DrpChAxiWReady,
      sGtwiz10DrpChAxiBResp => sGtwiz10DrpChAxiBResp,
      sGtwiz10DrpChAxiBValid => sGtwiz10DrpChAxiBValid,
      sGtwiz10DrpChAxiBReady => sGtwiz10DrpChAxiBReady,
      sGtwiz10DrpChAxiARAddr => sGtwiz10DrpChAxiARAddr,
      sGtwiz10DrpChAxiARValid => sGtwiz10DrpChAxiARValid,
      sGtwiz10DrpChAxiARReady => sGtwiz10DrpChAxiARReady,
      sGtwiz10DrpChAxiRData => sGtwiz10DrpChAxiRData,
      sGtwiz10DrpChAxiRResp => sGtwiz10DrpChAxiRResp,
      sGtwiz10DrpChAxiRValid => sGtwiz10DrpChAxiRValid,
      sGtwiz10DrpChAxiRReady => sGtwiz10DrpChAxiRReady,
      sGtwiz11CtrlAxiAWAddr => sGtwiz11CtrlAxiAWAddr,
      sGtwiz11CtrlAxiAWValid => sGtwiz11CtrlAxiAWValid,
      sGtwiz11CtrlAxiAWReady => sGtwiz11CtrlAxiAWReady,
      sGtwiz11CtrlAxiWData => sGtwiz11CtrlAxiWData,
      sGtwiz11CtrlAxiWStrb => sGtwiz11CtrlAxiWStrb,
      sGtwiz11CtrlAxiWValid => sGtwiz11CtrlAxiWValid,
      sGtwiz11CtrlAxiWReady => sGtwiz11CtrlAxiWReady,
      sGtwiz11CtrlAxiBResp => sGtwiz11CtrlAxiBResp,
      sGtwiz11CtrlAxiBValid => sGtwiz11CtrlAxiBValid,
      sGtwiz11CtrlAxiBReady => sGtwiz11CtrlAxiBReady,
      sGtwiz11CtrlAxiARAddr => sGtwiz11CtrlAxiARAddr,
      sGtwiz11CtrlAxiARValid => sGtwiz11CtrlAxiARValid,
      sGtwiz11CtrlAxiARReady => sGtwiz11CtrlAxiARReady,
      sGtwiz11CtrlAxiRData => sGtwiz11CtrlAxiRData,
      sGtwiz11CtrlAxiRResp => sGtwiz11CtrlAxiRResp,
      sGtwiz11CtrlAxiRValid => sGtwiz11CtrlAxiRValid,
      sGtwiz11CtrlAxiRReady => sGtwiz11CtrlAxiRReady,
      sGtwiz11DrpChAxiAWAddr => sGtwiz11DrpChAxiAWAddr,
      sGtwiz11DrpChAxiAWValid => sGtwiz11DrpChAxiAWValid,
      sGtwiz11DrpChAxiAWReady => sGtwiz11DrpChAxiAWReady,
      sGtwiz11DrpChAxiWData => sGtwiz11DrpChAxiWData,
      sGtwiz11DrpChAxiWStrb => sGtwiz11DrpChAxiWStrb,
      sGtwiz11DrpChAxiWValid => sGtwiz11DrpChAxiWValid,
      sGtwiz11DrpChAxiWReady => sGtwiz11DrpChAxiWReady,
      sGtwiz11DrpChAxiBResp => sGtwiz11DrpChAxiBResp,
      sGtwiz11DrpChAxiBValid => sGtwiz11DrpChAxiBValid,
      sGtwiz11DrpChAxiBReady => sGtwiz11DrpChAxiBReady,
      sGtwiz11DrpChAxiARAddr => sGtwiz11DrpChAxiARAddr,
      sGtwiz11DrpChAxiARValid => sGtwiz11DrpChAxiARValid,
      sGtwiz11DrpChAxiARReady => sGtwiz11DrpChAxiARReady,
      sGtwiz11DrpChAxiRData => sGtwiz11DrpChAxiRData,
      sGtwiz11DrpChAxiRResp => sGtwiz11DrpChAxiRResp,
      sGtwiz11DrpChAxiRValid => sGtwiz11DrpChAxiRValid,
      sGtwiz11DrpChAxiRReady => sGtwiz11DrpChAxiRReady,
      InitClk => BusClk,
      SAClk => BusClk
  );


  ---------------------------------------------------------------------------------------
  -- Unused or constant I/O
  ---------------------------------------------------------------------------------------
  -- Power sync pins which are spared by default
  a3v3VDPwrSync   <= 'Z';
  a1v2PwrSync     <= 'Z';
  a0v9PwrSync     <= 'Z';
  a1v8fpgaPwrSync <= 'Z';
  a3v8PwrSync     <= 'Z';
  a3v3OptPwrSync  <= 'Z';
  aMgtavttPwrSync <= 'Z';

  -- DRAM power enable
  aDdr4VttPwrEn   <= '1';

  -- Always enable the baseboard I2C bus
  aI2cBusEnable <= '1';

  -- Always enable the PLL status buffer
  aPllCtrlStatusEn_n <= '0';

  -- Enable the DIO when FPGA is up
  aFpgaReady_n <= '0';

end architecture struct;
