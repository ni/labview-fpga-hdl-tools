-------------------------------------------------------------------------------
-- File: UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz.vhd
-- Author: National Instruments
-- Workspace: PXIe-7903 HSS
-- Date: 26 August 2022
-------------------------------------------------------------------------------
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
-------------------------------------------------------------------------------
--
-- Purpose:
--   This CLIP instantiates an Aurora 64b66b core for the PXIe-7903. This core
-- is configured with the following settings:
--
-- 12 Ports
-- 4 Lanes
-- Line rate: 28.0Gbps
-- Reference Clock: 175.0MHz
-- Interface: Framing
-- CRC: True
-- Flow Control : Immediate NFC
-- Little Endian ： True
--
-------------------------------------------------------------------------------
--
-- githubvisible=true
--
-- vreview_group Ni7903AuroraStreamingVhdl
-- vreview_closed http://review-board.natinst.com/r/332238/
-- vreview_reviewers kygreen dhearn amoch
--
-------------------------------------------------------------------------------


library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgAXI4Lite_GTYE4_Control.all;

library unisim;
  use unisim.vcomponents.all;

entity UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz is
  port (
    -------------------------------------------------------------------------------------
    -- NI 7903 Required Signals
    -------------------------------------------------------------------------------------
    -------------------------------------------------------
    -- Reset
    -------------------------------------------------------
    -- Asynchronous reset signal from the LabVIEW FPGA environment.
    -- This signal *must* be present in the port interface for all IO Socket CLIPs.
    -- You should reset your CLIP logic whenever this signal is logic high.
    aResetSl                        : in  std_logic;

    -------------------------------------------------------
    -- REQUIRED Socket Signals
    -------------------------------------------------------
    -- Configuration
    aLmkI2cSda                      : inout std_logic;
    aLmkI2cScl                      : inout std_logic;
    aLmk1Pdn_n                      : out std_logic;
    aLmk2Pdn_n                      : out std_logic;
    aLmk1Gpio0                      : out std_logic;
    aLmk2Gpio0                      : out std_logic;
    aLmk1Status0                    : in std_logic;
    aLmk1Status1                    : in std_logic;
    aLmk2Status0                    : in std_logic;
    aLmk2Status1                    : in std_logic;
    aIPassPrsnt_n                   : in std_logic_vector(7 downto 0);
    aIPassIntr_n                    : in std_logic_vector(7 downto 0);
    aIPassSCL                       : inout std_logic_vector(11 downto 0);
    aIPassSDA                       : inout std_logic_vector(11 downto 0);
    aPortExpReset_n                 : out std_logic;
    aPortExpIntr_n                  : in std_logic;
    aPortExpSda                     : inout std_logic;
    aPortExpScl                     : inout std_logic;
    aIPassVccPowerFault_n           : in std_logic;

    -- Reserved Interfaces
    stIoModuleSupportsFRAGLs        : out std_logic;

    -------------------------------------------------------
    -- DIO Signals
    -------------------------------------------------------
    aDio                            : inout std_logic_vector(7 downto 0);

    -------------------------------------------------------
    -- AXI Communication Interfaces
    -------------------------------------------------------
    AxiClk                          : in  std_logic;
    xHostAxiStreamToClipTData       : in  std_logic_vector(31 downto 0);
    xHostAxiStreamToClipTLast       : in  std_logic;
    xHostAxiStreamFromClipTReady    : out std_logic;
    xHostAxiStreamToClipTValid      : in  std_logic;
    xHostAxiStreamFromClipTData     : out std_logic_vector(31 downto 0);
    xHostAxiStreamFromClipTLast     : out std_logic;
    xHostAxiStreamToClipTReady      : in  std_logic;
    xHostAxiStreamFromClipTValid    : out std_logic;
    xDiagramAxiStreamToClipTData    : in  std_logic_vector(31 downto 0);
    xDiagramAxiStreamToClipTLast    : in  std_logic;
    xDiagramAxiStreamFromClipTReady : out std_logic;
    xDiagramAxiStreamToClipTValid   : in  std_logic;
    xDiagramAxiStreamFromClipTData  : out std_logic_vector(31 downto 0);
    xDiagramAxiStreamFromClipTLast  : out std_logic;
    xDiagramAxiStreamToClipTReady   : in  std_logic;
    xDiagramAxiStreamFromClipTValid : out std_logic;

    -- AXI4 Lite interfaces
    xClipAxi4LiteMasterARAddr       : out std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterARProt       : out std_logic_vector(2 downto 0);
    xClipAxi4LiteMasterARReady      : in  std_logic;
    xClipAxi4LiteMasterARValid      : out std_logic;
    xClipAxi4LiteMasterAWAddr       : out std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterAWProt       : out std_logic_vector(2 downto 0);
    xClipAxi4LiteMasterAWReady      : in  std_logic;
    xClipAxi4LiteMasterAWValid      : out std_logic;
    xClipAxi4LiteMasterBReady       : out std_logic;
    xClipAxi4LiteMasterBResp        : in  std_logic_vector(1 downto 0);
    xClipAxi4LiteMasterBValid       : in  std_logic;
    xClipAxi4LiteMasterRData        : in  std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterRReady       : out std_logic;
    xClipAxi4LiteMasterRResp        : in  std_logic_vector(1 downto 0);
    xClipAxi4LiteMasterRValid       : in  std_logic;
    xClipAxi4LiteMasterWData        : out std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterWReady       : in  std_logic;
    xClipAxi4LiteMasterWStrb        : out std_logic_vector(3 downto 0);
    xClipAxi4LiteMasterWValid       : out std_logic;

    xClipAxi4LiteInterrupt          : in  std_logic;
    --vhook_nowarn xClipAxi4LiteInterrupt

    -------------------------------------------------------
    -- MGT Socket Interface
    -------------------------------------------------------
    -- These signals connect directly to the MGT pins, and should be connected to the
    -- user's IP.
    MgtRefClk_p                     : in  std_logic_vector(11 downto 0);
    MgtRefClk_n                     : in  std_logic_vector(11 downto 0);
    MgtPortRx_p                     : in  std_logic_vector(47 downto 0);
    MgtPortRx_n                     : in  std_logic_vector(47 downto 0);
    MgtPortTx_p                     : out std_logic_vector(47 downto 0);
    MgtPortTx_n                     : out std_logic_vector(47 downto 0);

    -------------------------------------------------------------------------------------
    -- Diagram facing signals
    -- This is the collection of signals that appears in LabVIEW FPGA.
    -- LabVIEW FPGA signals must use one of the following signal directions:  {in, out}
    -- LabVIEW FPGA signals must use one of the following data types:
    --          std_logic
    --          std_logic_vector(7 downto 0)
    --          std_logic_vector(15 downto 0)
    --          std_logic_vector(31 downto 0)
    --          std_logic_vector(63 downto 0)
    -------------------------------------------------------------------------------------

    -------------------------------------------------------
    -- REQUIRED Diagram Signals
    -------------------------------------------------------
    -- This is the exact same clock as AxiClk, but we need to bring it in so LVFPGA can enforce its use.
    --vhook_nowarn TopLevelClk80
    TopLevelClk80                   : in  std_logic;
    -- Status signals to the diagram
    xIoModuleReady                  : out std_logic;
    xIoModuleErrorCode              : out std_logic_vector(31 downto 0);
    -- DIO
    aDioOut                         : in  std_logic_vector(7 downto 0);
    aDioIn                          : out std_logic_vector(7 downto 0);

    -------------------------------------------------------------------------------------
    -- Aurora Signals
    -------------------------------------------------------------------------------------
    -------------------------------------------------------
    -- Aurora User Clock
    -------------------------------------------------------
    -- AXI Streaming User Clock Outputs (to LabVIEW FPGA diagram from I/O Socket)
    -- These clocks run at the line rate/64. By default, at 28.0Gbps, these
    -- clocks run at 437.5MHz.
    UserClkPort0                    : out std_logic;
    UserClkPort1                    : out std_logic;
    UserClkPort2                    : out std_logic;
    UserClkPort3                    : out std_logic;
    UserClkPort4                    : out std_logic;
    UserClkPort5                    : out std_logic;
    UserClkPort6                    : out std_logic;
    UserClkPort7                    : out std_logic;
    UserClkPort8                    : out std_logic;
    UserClkPort9                    : out std_logic;
    UserClkPort10                    : out std_logic;
    UserClkPort11                    : out std_logic;

    -------------------------------------------------------
    -- Aurora Reset Interface
    -------------------------------------------------------
    -- Initialization reset signals to the Aurora cores
    -- pma_init : clock domain async
    --   The transceiver pma_init reset signal is connected to the top level
    --   through a debouncer. Systematically resets all Physical Coding Sublayer (PCS)
    --   and Physical Medium Attachment (PMA) subcomponents of the transceiver.
    aPort0PmaInit                   : in  std_logic;
    aPort1PmaInit                   : in  std_logic;
    aPort2PmaInit                   : in  std_logic;
    aPort3PmaInit                   : in  std_logic;
    aPort4PmaInit                   : in  std_logic;
    aPort5PmaInit                   : in  std_logic;
    aPort6PmaInit                   : in  std_logic;
    aPort7PmaInit                   : in  std_logic;
    aPort8PmaInit                   : in  std_logic;
    aPort9PmaInit                   : in  std_logic;
    aPort10PmaInit                   : in  std_logic;
    aPort11PmaInit                   : in  std_logic;

    -- reset_pb : clock domain async
    --   Push Button Reset. The top-level reset input at the example design level.
    aPort0ResetPb                   : in  std_logic;
    aPort1ResetPb                   : in  std_logic;
    aPort2ResetPb                   : in  std_logic;
    aPort3ResetPb                   : in  std_logic;
    aPort4ResetPb                   : in  std_logic;
    aPort5ResetPb                   : in  std_logic;
    aPort6ResetPb                   : in  std_logic;
    aPort7ResetPb                   : in  std_logic;
    aPort8ResetPb                   : in  std_logic;
    aPort9ResetPb                   : in  std_logic;
    aPort10ResetPb                   : in  std_logic;
    aPort11ResetPb                   : in  std_logic;

    -------------------------------------------------------
    -- Aurora AXI Tx Data Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the UserClkPort0 domain:
    uPort0AxiTxTData0               : in  std_logic_vector(63 downto 0);
    uPort0AxiTxTData1               : in  std_logic_vector(63 downto 0);
    uPort0AxiTxTData2               : in  std_logic_vector(63 downto 0);
    uPort0AxiTxTData3               : in  std_logic_vector(63 downto 0);
    uPort0AxiTxTKeep                : in  std_logic_vector(31 downto 0);
    uPort0AxiTxTLast                : in  std_logic;
    uPort0AxiTxTValid               : in  std_logic;
    uPort0AxiTxTReady               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort1 domain:
    uPort1AxiTxTData0               : in  std_logic_vector(63 downto 0);
    uPort1AxiTxTData1               : in  std_logic_vector(63 downto 0);
    uPort1AxiTxTData2               : in  std_logic_vector(63 downto 0);
    uPort1AxiTxTData3               : in  std_logic_vector(63 downto 0);
    uPort1AxiTxTKeep                : in  std_logic_vector(31 downto 0);
    uPort1AxiTxTLast                : in  std_logic;
    uPort1AxiTxTValid               : in  std_logic;
    uPort1AxiTxTReady               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort2 domain:
    uPort2AxiTxTData0               : in  std_logic_vector(63 downto 0);
    uPort2AxiTxTData1               : in  std_logic_vector(63 downto 0);
    uPort2AxiTxTData2               : in  std_logic_vector(63 downto 0);
    uPort2AxiTxTData3               : in  std_logic_vector(63 downto 0);
    uPort2AxiTxTKeep                : in  std_logic_vector(31 downto 0);
    uPort2AxiTxTLast                : in  std_logic;
    uPort2AxiTxTValid               : in  std_logic;
    uPort2AxiTxTReady               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort3 domain:
    uPort3AxiTxTData0               : in  std_logic_vector(63 downto 0);
    uPort3AxiTxTData1               : in  std_logic_vector(63 downto 0);
    uPort3AxiTxTData2               : in  std_logic_vector(63 downto 0);
    uPort3AxiTxTData3               : in  std_logic_vector(63 downto 0);
    uPort3AxiTxTKeep                : in  std_logic_vector(31 downto 0);
    uPort3AxiTxTLast                : in  std_logic;
    uPort3AxiTxTValid               : in  std_logic;
    uPort3AxiTxTReady               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort4 domain:
    uPort4AxiTxTData0               : in  std_logic_vector(63 downto 0);
    uPort4AxiTxTData1               : in  std_logic_vector(63 downto 0);
    uPort4AxiTxTData2               : in  std_logic_vector(63 downto 0);
    uPort4AxiTxTData3               : in  std_logic_vector(63 downto 0);
    uPort4AxiTxTKeep                : in  std_logic_vector(31 downto 0);
    uPort4AxiTxTLast                : in  std_logic;
    uPort4AxiTxTValid               : in  std_logic;
    uPort4AxiTxTReady               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort5 domain:
    uPort5AxiTxTData0               : in  std_logic_vector(63 downto 0);
    uPort5AxiTxTData1               : in  std_logic_vector(63 downto 0);
    uPort5AxiTxTData2               : in  std_logic_vector(63 downto 0);
    uPort5AxiTxTData3               : in  std_logic_vector(63 downto 0);
    uPort5AxiTxTKeep                : in  std_logic_vector(31 downto 0);
    uPort5AxiTxTLast                : in  std_logic;
    uPort5AxiTxTValid               : in  std_logic;
    uPort5AxiTxTReady               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort6 domain:
    uPort6AxiTxTData0               : in  std_logic_vector(63 downto 0);
    uPort6AxiTxTData1               : in  std_logic_vector(63 downto 0);
    uPort6AxiTxTData2               : in  std_logic_vector(63 downto 0);
    uPort6AxiTxTData3               : in  std_logic_vector(63 downto 0);
    uPort6AxiTxTKeep                : in  std_logic_vector(31 downto 0);
    uPort6AxiTxTLast                : in  std_logic;
    uPort6AxiTxTValid               : in  std_logic;
    uPort6AxiTxTReady               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort7 domain:
    uPort7AxiTxTData0               : in  std_logic_vector(63 downto 0);
    uPort7AxiTxTData1               : in  std_logic_vector(63 downto 0);
    uPort7AxiTxTData2               : in  std_logic_vector(63 downto 0);
    uPort7AxiTxTData3               : in  std_logic_vector(63 downto 0);
    uPort7AxiTxTKeep                : in  std_logic_vector(31 downto 0);
    uPort7AxiTxTLast                : in  std_logic;
    uPort7AxiTxTValid               : in  std_logic;
    uPort7AxiTxTReady               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort8 domain:
    uPort8AxiTxTData0               : in  std_logic_vector(63 downto 0);
    uPort8AxiTxTData1               : in  std_logic_vector(63 downto 0);
    uPort8AxiTxTData2               : in  std_logic_vector(63 downto 0);
    uPort8AxiTxTData3               : in  std_logic_vector(63 downto 0);
    uPort8AxiTxTKeep                : in  std_logic_vector(31 downto 0);
    uPort8AxiTxTLast                : in  std_logic;
    uPort8AxiTxTValid               : in  std_logic;
    uPort8AxiTxTReady               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort9 domain:
    uPort9AxiTxTData0               : in  std_logic_vector(63 downto 0);
    uPort9AxiTxTData1               : in  std_logic_vector(63 downto 0);
    uPort9AxiTxTData2               : in  std_logic_vector(63 downto 0);
    uPort9AxiTxTData3               : in  std_logic_vector(63 downto 0);
    uPort9AxiTxTKeep                : in  std_logic_vector(31 downto 0);
    uPort9AxiTxTLast                : in  std_logic;
    uPort9AxiTxTValid               : in  std_logic;
    uPort9AxiTxTReady               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort10 domain:
    uPort10AxiTxTData0               : in  std_logic_vector(63 downto 0);
    uPort10AxiTxTData1               : in  std_logic_vector(63 downto 0);
    uPort10AxiTxTData2               : in  std_logic_vector(63 downto 0);
    uPort10AxiTxTData3               : in  std_logic_vector(63 downto 0);
    uPort10AxiTxTKeep                : in  std_logic_vector(31 downto 0);
    uPort10AxiTxTLast                : in  std_logic;
    uPort10AxiTxTValid               : in  std_logic;
    uPort10AxiTxTReady               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort11 domain:
    uPort11AxiTxTData0               : in  std_logic_vector(63 downto 0);
    uPort11AxiTxTData1               : in  std_logic_vector(63 downto 0);
    uPort11AxiTxTData2               : in  std_logic_vector(63 downto 0);
    uPort11AxiTxTData3               : in  std_logic_vector(63 downto 0);
    uPort11AxiTxTKeep                : in  std_logic_vector(31 downto 0);
    uPort11AxiTxTLast                : in  std_logic;
    uPort11AxiTxTValid               : in  std_logic;
    uPort11AxiTxTReady               : out std_logic;


    -------------------------------------------------------
    -- Aurora AXI Rx Data Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the UserClkPort0 domain:
    uPort0AxiRxTData0               : out std_logic_vector(63 downto 0);
    uPort0AxiRxTData1               : out std_logic_vector(63 downto 0);
    uPort0AxiRxTData2               : out std_logic_vector(63 downto 0);
    uPort0AxiRxTData3               : out std_logic_vector(63 downto 0);
    uPort0AxiRxTKeep                : out std_logic_vector(31 downto 0);
    uPort0AxiRxTLast                : out std_logic;
    uPort0AxiRxTValid               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort1 domain:
    uPort1AxiRxTData0               : out std_logic_vector(63 downto 0);
    uPort1AxiRxTData1               : out std_logic_vector(63 downto 0);
    uPort1AxiRxTData2               : out std_logic_vector(63 downto 0);
    uPort1AxiRxTData3               : out std_logic_vector(63 downto 0);
    uPort1AxiRxTKeep                : out std_logic_vector(31 downto 0);
    uPort1AxiRxTLast                : out std_logic;
    uPort1AxiRxTValid               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort2 domain:
    uPort2AxiRxTData0               : out std_logic_vector(63 downto 0);
    uPort2AxiRxTData1               : out std_logic_vector(63 downto 0);
    uPort2AxiRxTData2               : out std_logic_vector(63 downto 0);
    uPort2AxiRxTData3               : out std_logic_vector(63 downto 0);
    uPort2AxiRxTKeep                : out std_logic_vector(31 downto 0);
    uPort2AxiRxTLast                : out std_logic;
    uPort2AxiRxTValid               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort3 domain:
    uPort3AxiRxTData0               : out std_logic_vector(63 downto 0);
    uPort3AxiRxTData1               : out std_logic_vector(63 downto 0);
    uPort3AxiRxTData2               : out std_logic_vector(63 downto 0);
    uPort3AxiRxTData3               : out std_logic_vector(63 downto 0);
    uPort3AxiRxTKeep                : out std_logic_vector(31 downto 0);
    uPort3AxiRxTLast                : out std_logic;
    uPort3AxiRxTValid               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort4 domain:
    uPort4AxiRxTData0               : out std_logic_vector(63 downto 0);
    uPort4AxiRxTData1               : out std_logic_vector(63 downto 0);
    uPort4AxiRxTData2               : out std_logic_vector(63 downto 0);
    uPort4AxiRxTData3               : out std_logic_vector(63 downto 0);
    uPort4AxiRxTKeep                : out std_logic_vector(31 downto 0);
    uPort4AxiRxTLast                : out std_logic;
    uPort4AxiRxTValid               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort5 domain:
    uPort5AxiRxTData0               : out std_logic_vector(63 downto 0);
    uPort5AxiRxTData1               : out std_logic_vector(63 downto 0);
    uPort5AxiRxTData2               : out std_logic_vector(63 downto 0);
    uPort5AxiRxTData3               : out std_logic_vector(63 downto 0);
    uPort5AxiRxTKeep                : out std_logic_vector(31 downto 0);
    uPort5AxiRxTLast                : out std_logic;
    uPort5AxiRxTValid               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort6 domain:
    uPort6AxiRxTData0               : out std_logic_vector(63 downto 0);
    uPort6AxiRxTData1               : out std_logic_vector(63 downto 0);
    uPort6AxiRxTData2               : out std_logic_vector(63 downto 0);
    uPort6AxiRxTData3               : out std_logic_vector(63 downto 0);
    uPort6AxiRxTKeep                : out std_logic_vector(31 downto 0);
    uPort6AxiRxTLast                : out std_logic;
    uPort6AxiRxTValid               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort7 domain:
    uPort7AxiRxTData0               : out std_logic_vector(63 downto 0);
    uPort7AxiRxTData1               : out std_logic_vector(63 downto 0);
    uPort7AxiRxTData2               : out std_logic_vector(63 downto 0);
    uPort7AxiRxTData3               : out std_logic_vector(63 downto 0);
    uPort7AxiRxTKeep                : out std_logic_vector(31 downto 0);
    uPort7AxiRxTLast                : out std_logic;
    uPort7AxiRxTValid               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort8 domain:
    uPort8AxiRxTData0               : out std_logic_vector(63 downto 0);
    uPort8AxiRxTData1               : out std_logic_vector(63 downto 0);
    uPort8AxiRxTData2               : out std_logic_vector(63 downto 0);
    uPort8AxiRxTData3               : out std_logic_vector(63 downto 0);
    uPort8AxiRxTKeep                : out std_logic_vector(31 downto 0);
    uPort8AxiRxTLast                : out std_logic;
    uPort8AxiRxTValid               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort9 domain:
    uPort9AxiRxTData0               : out std_logic_vector(63 downto 0);
    uPort9AxiRxTData1               : out std_logic_vector(63 downto 0);
    uPort9AxiRxTData2               : out std_logic_vector(63 downto 0);
    uPort9AxiRxTData3               : out std_logic_vector(63 downto 0);
    uPort9AxiRxTKeep                : out std_logic_vector(31 downto 0);
    uPort9AxiRxTLast                : out std_logic;
    uPort9AxiRxTValid               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort10 domain:
    uPort10AxiRxTData0               : out std_logic_vector(63 downto 0);
    uPort10AxiRxTData1               : out std_logic_vector(63 downto 0);
    uPort10AxiRxTData2               : out std_logic_vector(63 downto 0);
    uPort10AxiRxTData3               : out std_logic_vector(63 downto 0);
    uPort10AxiRxTKeep                : out std_logic_vector(31 downto 0);
    uPort10AxiRxTLast                : out std_logic;
    uPort10AxiRxTValid               : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort11 domain:
    uPort11AxiRxTData0               : out std_logic_vector(63 downto 0);
    uPort11AxiRxTData1               : out std_logic_vector(63 downto 0);
    uPort11AxiRxTData2               : out std_logic_vector(63 downto 0);
    uPort11AxiRxTData3               : out std_logic_vector(63 downto 0);
    uPort11AxiRxTKeep                : out std_logic_vector(31 downto 0);
    uPort11AxiRxTLast                : out std_logic;
    uPort11AxiRxTValid               : out std_logic;


    -------------------------------------------------------
    -- Aurora AXI Native Flow Control Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the UserClkPort0 domain:
    uPort0AxiNfcTValid              : in  std_logic;
    uPort0AxiNfcTData               : in  std_logic_vector(31 downto 0);
    uPort0AxiNfcTReady              : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort1 domain:
    uPort1AxiNfcTValid              : in  std_logic;
    uPort1AxiNfcTData               : in  std_logic_vector(31 downto 0);
    uPort1AxiNfcTReady              : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort2 domain:
    uPort2AxiNfcTValid              : in  std_logic;
    uPort2AxiNfcTData               : in  std_logic_vector(31 downto 0);
    uPort2AxiNfcTReady              : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort3 domain:
    uPort3AxiNfcTValid              : in  std_logic;
    uPort3AxiNfcTData               : in  std_logic_vector(31 downto 0);
    uPort3AxiNfcTReady              : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort4 domain:
    uPort4AxiNfcTValid              : in  std_logic;
    uPort4AxiNfcTData               : in  std_logic_vector(31 downto 0);
    uPort4AxiNfcTReady              : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort5 domain:
    uPort5AxiNfcTValid              : in  std_logic;
    uPort5AxiNfcTData               : in  std_logic_vector(31 downto 0);
    uPort5AxiNfcTReady              : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort6 domain:
    uPort6AxiNfcTValid              : in  std_logic;
    uPort6AxiNfcTData               : in  std_logic_vector(31 downto 0);
    uPort6AxiNfcTReady              : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort7 domain:
    uPort7AxiNfcTValid              : in  std_logic;
    uPort7AxiNfcTData               : in  std_logic_vector(31 downto 0);
    uPort7AxiNfcTReady              : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort8 domain:
    uPort8AxiNfcTValid              : in  std_logic;
    uPort8AxiNfcTData               : in  std_logic_vector(31 downto 0);
    uPort8AxiNfcTReady              : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort9 domain:
    uPort9AxiNfcTValid              : in  std_logic;
    uPort9AxiNfcTData               : in  std_logic_vector(31 downto 0);
    uPort9AxiNfcTReady              : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort10 domain:
    uPort10AxiNfcTValid              : in  std_logic;
    uPort10AxiNfcTData               : in  std_logic_vector(31 downto 0);
    uPort10AxiNfcTReady              : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort11 domain:
    uPort11AxiNfcTValid              : in  std_logic;
    uPort11AxiNfcTData               : in  std_logic_vector(31 downto 0);
    uPort11AxiNfcTReady              : out std_logic;


    -------------------------------------------------------
    -- Aurora Link Status Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the UserClkPort0 domain:
    uPort0HardError                 : out std_logic;
    uPort0SoftError                 : out std_logic;
    uPort0LaneUp                    : out std_logic_vector(3 downto 0);
    uPort0ChannelUp                 : out std_logic;
    uPort0SysResetOut               : out std_logic;
    uPort0MmcmNotLockOut            : out std_logic;
    uPort0CrcPassFail_n             : out std_logic;
    uPort0CrcValid                  : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort1 domain:
    uPort1HardError                 : out std_logic;
    uPort1SoftError                 : out std_logic;
    uPort1LaneUp                    : out std_logic_vector(3 downto 0);
    uPort1ChannelUp                 : out std_logic;
    uPort1SysResetOut               : out std_logic;
    uPort1MmcmNotLockOut            : out std_logic;
    uPort1CrcPassFail_n             : out std_logic;
    uPort1CrcValid                  : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort2 domain:
    uPort2HardError                 : out std_logic;
    uPort2SoftError                 : out std_logic;
    uPort2LaneUp                    : out std_logic_vector(3 downto 0);
    uPort2ChannelUp                 : out std_logic;
    uPort2SysResetOut               : out std_logic;
    uPort2MmcmNotLockOut            : out std_logic;
    uPort2CrcPassFail_n             : out std_logic;
    uPort2CrcValid                  : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort3 domain:
    uPort3HardError                 : out std_logic;
    uPort3SoftError                 : out std_logic;
    uPort3LaneUp                    : out std_logic_vector(3 downto 0);
    uPort3ChannelUp                 : out std_logic;
    uPort3SysResetOut               : out std_logic;
    uPort3MmcmNotLockOut            : out std_logic;
    uPort3CrcPassFail_n             : out std_logic;
    uPort3CrcValid                  : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort4 domain:
    uPort4HardError                 : out std_logic;
    uPort4SoftError                 : out std_logic;
    uPort4LaneUp                    : out std_logic_vector(3 downto 0);
    uPort4ChannelUp                 : out std_logic;
    uPort4SysResetOut               : out std_logic;
    uPort4MmcmNotLockOut            : out std_logic;
    uPort4CrcPassFail_n             : out std_logic;
    uPort4CrcValid                  : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort5 domain:
    uPort5HardError                 : out std_logic;
    uPort5SoftError                 : out std_logic;
    uPort5LaneUp                    : out std_logic_vector(3 downto 0);
    uPort5ChannelUp                 : out std_logic;
    uPort5SysResetOut               : out std_logic;
    uPort5MmcmNotLockOut            : out std_logic;
    uPort5CrcPassFail_n             : out std_logic;
    uPort5CrcValid                  : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort6 domain:
    uPort6HardError                 : out std_logic;
    uPort6SoftError                 : out std_logic;
    uPort6LaneUp                    : out std_logic_vector(3 downto 0);
    uPort6ChannelUp                 : out std_logic;
    uPort6SysResetOut               : out std_logic;
    uPort6MmcmNotLockOut            : out std_logic;
    uPort6CrcPassFail_n             : out std_logic;
    uPort6CrcValid                  : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort7 domain:
    uPort7HardError                 : out std_logic;
    uPort7SoftError                 : out std_logic;
    uPort7LaneUp                    : out std_logic_vector(3 downto 0);
    uPort7ChannelUp                 : out std_logic;
    uPort7SysResetOut               : out std_logic;
    uPort7MmcmNotLockOut            : out std_logic;
    uPort7CrcPassFail_n             : out std_logic;
    uPort7CrcValid                  : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort8 domain:
    uPort8HardError                 : out std_logic;
    uPort8SoftError                 : out std_logic;
    uPort8LaneUp                    : out std_logic_vector(3 downto 0);
    uPort8ChannelUp                 : out std_logic;
    uPort8SysResetOut               : out std_logic;
    uPort8MmcmNotLockOut            : out std_logic;
    uPort8CrcPassFail_n             : out std_logic;
    uPort8CrcValid                  : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort9 domain:
    uPort9HardError                 : out std_logic;
    uPort9SoftError                 : out std_logic;
    uPort9LaneUp                    : out std_logic_vector(3 downto 0);
    uPort9ChannelUp                 : out std_logic;
    uPort9SysResetOut               : out std_logic;
    uPort9MmcmNotLockOut            : out std_logic;
    uPort9CrcPassFail_n             : out std_logic;
    uPort9CrcValid                  : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort10 domain:
    uPort10HardError                 : out std_logic;
    uPort10SoftError                 : out std_logic;
    uPort10LaneUp                    : out std_logic_vector(3 downto 0);
    uPort10ChannelUp                 : out std_logic;
    uPort10SysResetOut               : out std_logic;
    uPort10MmcmNotLockOut            : out std_logic;
    uPort10CrcPassFail_n             : out std_logic;
    uPort10CrcValid                  : out std_logic;

    -- The following signals are REQUIRED to be in the UserClkPort11 domain:
    uPort11HardError                 : out std_logic;
    uPort11SoftError                 : out std_logic;
    uPort11LaneUp                    : out std_logic_vector(3 downto 0);
    uPort11ChannelUp                 : out std_logic;
    uPort11SysResetOut               : out std_logic;
    uPort11MmcmNotLockOut            : out std_logic;
    uPort11CrcPassFail_n             : out std_logic;
    uPort11CrcValid                  : out std_logic;


    -- The following signals are REQUIRED to be in the init_clk domain:
    iPort0LinkResetOut              : out std_logic;  -- Driven High if hot-plug count expires
    iPort1LinkResetOut              : out std_logic;  -- Driven High if hot-plug count expires
    iPort2LinkResetOut              : out std_logic;  -- Driven High if hot-plug count expires
    iPort3LinkResetOut              : out std_logic;  -- Driven High if hot-plug count expires
    iPort4LinkResetOut              : out std_logic;  -- Driven High if hot-plug count expires
    iPort5LinkResetOut              : out std_logic;  -- Driven High if hot-plug count expires
    iPort6LinkResetOut              : out std_logic;  -- Driven High if hot-plug count expires
    iPort7LinkResetOut              : out std_logic;  -- Driven High if hot-plug count expires
    iPort8LinkResetOut              : out std_logic;  -- Driven High if hot-plug count expires
    iPort9LinkResetOut              : out std_logic;  -- Driven High if hot-plug count expires
    iPort10LinkResetOut              : out std_logic;  -- Driven High if hot-plug count expires
    iPort11LinkResetOut              : out std_logic;  -- Driven High if hot-plug count expires

    -------------------------------------------------------------------------------------
    -- Aurora AXI4-Lite Ctrl/Drp Interface
    -------------------------------------------------------------------------------------
    -------------------------------------------------------
    -- Aurora Port 0 Ctrl Register Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz0CtrlAxiAWAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz0CtrlAxiAWValid           : in  std_logic;
    sGtwiz0CtrlAxiAWReady           : out std_logic;
    sGtwiz0CtrlAxiWData             : in  std_logic_vector(31 downto 0);
    sGtwiz0CtrlAxiWStrb             : in  std_logic_vector(3 downto 0);
    sGtwiz0CtrlAxiWValid            : in  std_logic;
    sGtwiz0CtrlAxiWReady            : out std_logic;
    sGtwiz0CtrlAxiBResp             : out std_logic_vector(1 downto 0);
    sGtwiz0CtrlAxiBValid            : out std_logic;
    sGtwiz0CtrlAxiBReady            : in  std_logic;
    sGtwiz0CtrlAxiARAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz0CtrlAxiARValid           : in  std_logic;
    sGtwiz0CtrlAxiARReady           : out std_logic;
    sGtwiz0CtrlAxiRData             : out std_logic_vector(31 downto 0);
    sGtwiz0CtrlAxiRResp             : out std_logic_vector(1 downto 0);
    sGtwiz0CtrlAxiRValid            : out std_logic;
    sGtwiz0CtrlAxiRReady            : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 0 Channel DRP Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz0DrpChAxiAWAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz0DrpChAxiAWValid          : in  std_logic;
    sGtwiz0DrpChAxiAWReady          : out std_logic;
    sGtwiz0DrpChAxiWData            : in  std_logic_vector(31 downto 0);
    sGtwiz0DrpChAxiWStrb            : in  std_logic_vector(3 downto 0);
    sGtwiz0DrpChAxiWValid           : in  std_logic;
    sGtwiz0DrpChAxiWReady           : out std_logic;
    sGtwiz0DrpChAxiBResp            : out std_logic_vector(1 downto 0);
    sGtwiz0DrpChAxiBValid           : out std_logic;
    sGtwiz0DrpChAxiBReady           : in  std_logic;
    sGtwiz0DrpChAxiARAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz0DrpChAxiARValid          : in  std_logic;
    sGtwiz0DrpChAxiARReady          : out std_logic;
    sGtwiz0DrpChAxiRData            : out std_logic_vector(31 downto 0);
    sGtwiz0DrpChAxiRResp            : out std_logic_vector(1 downto 0);
    sGtwiz0DrpChAxiRValid           : out std_logic;
    sGtwiz0DrpChAxiRReady           : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 1 Ctrl Register Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz1CtrlAxiAWAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz1CtrlAxiAWValid           : in  std_logic;
    sGtwiz1CtrlAxiAWReady           : out std_logic;
    sGtwiz1CtrlAxiWData             : in  std_logic_vector(31 downto 0);
    sGtwiz1CtrlAxiWStrb             : in  std_logic_vector(3 downto 0);
    sGtwiz1CtrlAxiWValid            : in  std_logic;
    sGtwiz1CtrlAxiWReady            : out std_logic;
    sGtwiz1CtrlAxiBResp             : out std_logic_vector(1 downto 0);
    sGtwiz1CtrlAxiBValid            : out std_logic;
    sGtwiz1CtrlAxiBReady            : in  std_logic;
    sGtwiz1CtrlAxiARAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz1CtrlAxiARValid           : in  std_logic;
    sGtwiz1CtrlAxiARReady           : out std_logic;
    sGtwiz1CtrlAxiRData             : out std_logic_vector(31 downto 0);
    sGtwiz1CtrlAxiRResp             : out std_logic_vector(1 downto 0);
    sGtwiz1CtrlAxiRValid            : out std_logic;
    sGtwiz1CtrlAxiRReady            : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 1 Channel DRP Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz1DrpChAxiAWAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz1DrpChAxiAWValid          : in  std_logic;
    sGtwiz1DrpChAxiAWReady          : out std_logic;
    sGtwiz1DrpChAxiWData            : in  std_logic_vector(31 downto 0);
    sGtwiz1DrpChAxiWStrb            : in  std_logic_vector(3 downto 0);
    sGtwiz1DrpChAxiWValid           : in  std_logic;
    sGtwiz1DrpChAxiWReady           : out std_logic;
    sGtwiz1DrpChAxiBResp            : out std_logic_vector(1 downto 0);
    sGtwiz1DrpChAxiBValid           : out std_logic;
    sGtwiz1DrpChAxiBReady           : in  std_logic;
    sGtwiz1DrpChAxiARAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz1DrpChAxiARValid          : in  std_logic;
    sGtwiz1DrpChAxiARReady          : out std_logic;
    sGtwiz1DrpChAxiRData            : out std_logic_vector(31 downto 0);
    sGtwiz1DrpChAxiRResp            : out std_logic_vector(1 downto 0);
    sGtwiz1DrpChAxiRValid           : out std_logic;
    sGtwiz1DrpChAxiRReady           : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 2 Ctrl Register Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz2CtrlAxiAWAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz2CtrlAxiAWValid           : in  std_logic;
    sGtwiz2CtrlAxiAWReady           : out std_logic;
    sGtwiz2CtrlAxiWData             : in  std_logic_vector(31 downto 0);
    sGtwiz2CtrlAxiWStrb             : in  std_logic_vector(3 downto 0);
    sGtwiz2CtrlAxiWValid            : in  std_logic;
    sGtwiz2CtrlAxiWReady            : out std_logic;
    sGtwiz2CtrlAxiBResp             : out std_logic_vector(1 downto 0);
    sGtwiz2CtrlAxiBValid            : out std_logic;
    sGtwiz2CtrlAxiBReady            : in  std_logic;
    sGtwiz2CtrlAxiARAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz2CtrlAxiARValid           : in  std_logic;
    sGtwiz2CtrlAxiARReady           : out std_logic;
    sGtwiz2CtrlAxiRData             : out std_logic_vector(31 downto 0);
    sGtwiz2CtrlAxiRResp             : out std_logic_vector(1 downto 0);
    sGtwiz2CtrlAxiRValid            : out std_logic;
    sGtwiz2CtrlAxiRReady            : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 2 Channel DRP Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz2DrpChAxiAWAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz2DrpChAxiAWValid          : in  std_logic;
    sGtwiz2DrpChAxiAWReady          : out std_logic;
    sGtwiz2DrpChAxiWData            : in  std_logic_vector(31 downto 0);
    sGtwiz2DrpChAxiWStrb            : in  std_logic_vector(3 downto 0);
    sGtwiz2DrpChAxiWValid           : in  std_logic;
    sGtwiz2DrpChAxiWReady           : out std_logic;
    sGtwiz2DrpChAxiBResp            : out std_logic_vector(1 downto 0);
    sGtwiz2DrpChAxiBValid           : out std_logic;
    sGtwiz2DrpChAxiBReady           : in  std_logic;
    sGtwiz2DrpChAxiARAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz2DrpChAxiARValid          : in  std_logic;
    sGtwiz2DrpChAxiARReady          : out std_logic;
    sGtwiz2DrpChAxiRData            : out std_logic_vector(31 downto 0);
    sGtwiz2DrpChAxiRResp            : out std_logic_vector(1 downto 0);
    sGtwiz2DrpChAxiRValid           : out std_logic;
    sGtwiz2DrpChAxiRReady           : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 3 Ctrl Register Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz3CtrlAxiAWAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz3CtrlAxiAWValid           : in  std_logic;
    sGtwiz3CtrlAxiAWReady           : out std_logic;
    sGtwiz3CtrlAxiWData             : in  std_logic_vector(31 downto 0);
    sGtwiz3CtrlAxiWStrb             : in  std_logic_vector(3 downto 0);
    sGtwiz3CtrlAxiWValid            : in  std_logic;
    sGtwiz3CtrlAxiWReady            : out std_logic;
    sGtwiz3CtrlAxiBResp             : out std_logic_vector(1 downto 0);
    sGtwiz3CtrlAxiBValid            : out std_logic;
    sGtwiz3CtrlAxiBReady            : in  std_logic;
    sGtwiz3CtrlAxiARAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz3CtrlAxiARValid           : in  std_logic;
    sGtwiz3CtrlAxiARReady           : out std_logic;
    sGtwiz3CtrlAxiRData             : out std_logic_vector(31 downto 0);
    sGtwiz3CtrlAxiRResp             : out std_logic_vector(1 downto 0);
    sGtwiz3CtrlAxiRValid            : out std_logic;
    sGtwiz3CtrlAxiRReady            : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 3 Channel DRP Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz3DrpChAxiAWAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz3DrpChAxiAWValid          : in  std_logic;
    sGtwiz3DrpChAxiAWReady          : out std_logic;
    sGtwiz3DrpChAxiWData            : in  std_logic_vector(31 downto 0);
    sGtwiz3DrpChAxiWStrb            : in  std_logic_vector(3 downto 0);
    sGtwiz3DrpChAxiWValid           : in  std_logic;
    sGtwiz3DrpChAxiWReady           : out std_logic;
    sGtwiz3DrpChAxiBResp            : out std_logic_vector(1 downto 0);
    sGtwiz3DrpChAxiBValid           : out std_logic;
    sGtwiz3DrpChAxiBReady           : in  std_logic;
    sGtwiz3DrpChAxiARAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz3DrpChAxiARValid          : in  std_logic;
    sGtwiz3DrpChAxiARReady          : out std_logic;
    sGtwiz3DrpChAxiRData            : out std_logic_vector(31 downto 0);
    sGtwiz3DrpChAxiRResp            : out std_logic_vector(1 downto 0);
    sGtwiz3DrpChAxiRValid           : out std_logic;
    sGtwiz3DrpChAxiRReady           : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 4 Ctrl Register Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz4CtrlAxiAWAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz4CtrlAxiAWValid           : in  std_logic;
    sGtwiz4CtrlAxiAWReady           : out std_logic;
    sGtwiz4CtrlAxiWData             : in  std_logic_vector(31 downto 0);
    sGtwiz4CtrlAxiWStrb             : in  std_logic_vector(3 downto 0);
    sGtwiz4CtrlAxiWValid            : in  std_logic;
    sGtwiz4CtrlAxiWReady            : out std_logic;
    sGtwiz4CtrlAxiBResp             : out std_logic_vector(1 downto 0);
    sGtwiz4CtrlAxiBValid            : out std_logic;
    sGtwiz4CtrlAxiBReady            : in  std_logic;
    sGtwiz4CtrlAxiARAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz4CtrlAxiARValid           : in  std_logic;
    sGtwiz4CtrlAxiARReady           : out std_logic;
    sGtwiz4CtrlAxiRData             : out std_logic_vector(31 downto 0);
    sGtwiz4CtrlAxiRResp             : out std_logic_vector(1 downto 0);
    sGtwiz4CtrlAxiRValid            : out std_logic;
    sGtwiz4CtrlAxiRReady            : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 4 Channel DRP Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz4DrpChAxiAWAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz4DrpChAxiAWValid          : in  std_logic;
    sGtwiz4DrpChAxiAWReady          : out std_logic;
    sGtwiz4DrpChAxiWData            : in  std_logic_vector(31 downto 0);
    sGtwiz4DrpChAxiWStrb            : in  std_logic_vector(3 downto 0);
    sGtwiz4DrpChAxiWValid           : in  std_logic;
    sGtwiz4DrpChAxiWReady           : out std_logic;
    sGtwiz4DrpChAxiBResp            : out std_logic_vector(1 downto 0);
    sGtwiz4DrpChAxiBValid           : out std_logic;
    sGtwiz4DrpChAxiBReady           : in  std_logic;
    sGtwiz4DrpChAxiARAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz4DrpChAxiARValid          : in  std_logic;
    sGtwiz4DrpChAxiARReady          : out std_logic;
    sGtwiz4DrpChAxiRData            : out std_logic_vector(31 downto 0);
    sGtwiz4DrpChAxiRResp            : out std_logic_vector(1 downto 0);
    sGtwiz4DrpChAxiRValid           : out std_logic;
    sGtwiz4DrpChAxiRReady           : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 5 Ctrl Register Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz5CtrlAxiAWAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz5CtrlAxiAWValid           : in  std_logic;
    sGtwiz5CtrlAxiAWReady           : out std_logic;
    sGtwiz5CtrlAxiWData             : in  std_logic_vector(31 downto 0);
    sGtwiz5CtrlAxiWStrb             : in  std_logic_vector(3 downto 0);
    sGtwiz5CtrlAxiWValid            : in  std_logic;
    sGtwiz5CtrlAxiWReady            : out std_logic;
    sGtwiz5CtrlAxiBResp             : out std_logic_vector(1 downto 0);
    sGtwiz5CtrlAxiBValid            : out std_logic;
    sGtwiz5CtrlAxiBReady            : in  std_logic;
    sGtwiz5CtrlAxiARAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz5CtrlAxiARValid           : in  std_logic;
    sGtwiz5CtrlAxiARReady           : out std_logic;
    sGtwiz5CtrlAxiRData             : out std_logic_vector(31 downto 0);
    sGtwiz5CtrlAxiRResp             : out std_logic_vector(1 downto 0);
    sGtwiz5CtrlAxiRValid            : out std_logic;
    sGtwiz5CtrlAxiRReady            : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 5 Channel DRP Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz5DrpChAxiAWAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz5DrpChAxiAWValid          : in  std_logic;
    sGtwiz5DrpChAxiAWReady          : out std_logic;
    sGtwiz5DrpChAxiWData            : in  std_logic_vector(31 downto 0);
    sGtwiz5DrpChAxiWStrb            : in  std_logic_vector(3 downto 0);
    sGtwiz5DrpChAxiWValid           : in  std_logic;
    sGtwiz5DrpChAxiWReady           : out std_logic;
    sGtwiz5DrpChAxiBResp            : out std_logic_vector(1 downto 0);
    sGtwiz5DrpChAxiBValid           : out std_logic;
    sGtwiz5DrpChAxiBReady           : in  std_logic;
    sGtwiz5DrpChAxiARAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz5DrpChAxiARValid          : in  std_logic;
    sGtwiz5DrpChAxiARReady          : out std_logic;
    sGtwiz5DrpChAxiRData            : out std_logic_vector(31 downto 0);
    sGtwiz5DrpChAxiRResp            : out std_logic_vector(1 downto 0);
    sGtwiz5DrpChAxiRValid           : out std_logic;
    sGtwiz5DrpChAxiRReady           : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 6 Ctrl Register Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz6CtrlAxiAWAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz6CtrlAxiAWValid           : in  std_logic;
    sGtwiz6CtrlAxiAWReady           : out std_logic;
    sGtwiz6CtrlAxiWData             : in  std_logic_vector(31 downto 0);
    sGtwiz6CtrlAxiWStrb             : in  std_logic_vector(3 downto 0);
    sGtwiz6CtrlAxiWValid            : in  std_logic;
    sGtwiz6CtrlAxiWReady            : out std_logic;
    sGtwiz6CtrlAxiBResp             : out std_logic_vector(1 downto 0);
    sGtwiz6CtrlAxiBValid            : out std_logic;
    sGtwiz6CtrlAxiBReady            : in  std_logic;
    sGtwiz6CtrlAxiARAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz6CtrlAxiARValid           : in  std_logic;
    sGtwiz6CtrlAxiARReady           : out std_logic;
    sGtwiz6CtrlAxiRData             : out std_logic_vector(31 downto 0);
    sGtwiz6CtrlAxiRResp             : out std_logic_vector(1 downto 0);
    sGtwiz6CtrlAxiRValid            : out std_logic;
    sGtwiz6CtrlAxiRReady            : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 6 Channel DRP Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz6DrpChAxiAWAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz6DrpChAxiAWValid          : in  std_logic;
    sGtwiz6DrpChAxiAWReady          : out std_logic;
    sGtwiz6DrpChAxiWData            : in  std_logic_vector(31 downto 0);
    sGtwiz6DrpChAxiWStrb            : in  std_logic_vector(3 downto 0);
    sGtwiz6DrpChAxiWValid           : in  std_logic;
    sGtwiz6DrpChAxiWReady           : out std_logic;
    sGtwiz6DrpChAxiBResp            : out std_logic_vector(1 downto 0);
    sGtwiz6DrpChAxiBValid           : out std_logic;
    sGtwiz6DrpChAxiBReady           : in  std_logic;
    sGtwiz6DrpChAxiARAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz6DrpChAxiARValid          : in  std_logic;
    sGtwiz6DrpChAxiARReady          : out std_logic;
    sGtwiz6DrpChAxiRData            : out std_logic_vector(31 downto 0);
    sGtwiz6DrpChAxiRResp            : out std_logic_vector(1 downto 0);
    sGtwiz6DrpChAxiRValid           : out std_logic;
    sGtwiz6DrpChAxiRReady           : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 7 Ctrl Register Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz7CtrlAxiAWAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz7CtrlAxiAWValid           : in  std_logic;
    sGtwiz7CtrlAxiAWReady           : out std_logic;
    sGtwiz7CtrlAxiWData             : in  std_logic_vector(31 downto 0);
    sGtwiz7CtrlAxiWStrb             : in  std_logic_vector(3 downto 0);
    sGtwiz7CtrlAxiWValid            : in  std_logic;
    sGtwiz7CtrlAxiWReady            : out std_logic;
    sGtwiz7CtrlAxiBResp             : out std_logic_vector(1 downto 0);
    sGtwiz7CtrlAxiBValid            : out std_logic;
    sGtwiz7CtrlAxiBReady            : in  std_logic;
    sGtwiz7CtrlAxiARAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz7CtrlAxiARValid           : in  std_logic;
    sGtwiz7CtrlAxiARReady           : out std_logic;
    sGtwiz7CtrlAxiRData             : out std_logic_vector(31 downto 0);
    sGtwiz7CtrlAxiRResp             : out std_logic_vector(1 downto 0);
    sGtwiz7CtrlAxiRValid            : out std_logic;
    sGtwiz7CtrlAxiRReady            : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 7 Channel DRP Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz7DrpChAxiAWAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz7DrpChAxiAWValid          : in  std_logic;
    sGtwiz7DrpChAxiAWReady          : out std_logic;
    sGtwiz7DrpChAxiWData            : in  std_logic_vector(31 downto 0);
    sGtwiz7DrpChAxiWStrb            : in  std_logic_vector(3 downto 0);
    sGtwiz7DrpChAxiWValid           : in  std_logic;
    sGtwiz7DrpChAxiWReady           : out std_logic;
    sGtwiz7DrpChAxiBResp            : out std_logic_vector(1 downto 0);
    sGtwiz7DrpChAxiBValid           : out std_logic;
    sGtwiz7DrpChAxiBReady           : in  std_logic;
    sGtwiz7DrpChAxiARAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz7DrpChAxiARValid          : in  std_logic;
    sGtwiz7DrpChAxiARReady          : out std_logic;
    sGtwiz7DrpChAxiRData            : out std_logic_vector(31 downto 0);
    sGtwiz7DrpChAxiRResp            : out std_logic_vector(1 downto 0);
    sGtwiz7DrpChAxiRValid           : out std_logic;
    sGtwiz7DrpChAxiRReady           : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 8 Ctrl Register Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz8CtrlAxiAWAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz8CtrlAxiAWValid           : in  std_logic;
    sGtwiz8CtrlAxiAWReady           : out std_logic;
    sGtwiz8CtrlAxiWData             : in  std_logic_vector(31 downto 0);
    sGtwiz8CtrlAxiWStrb             : in  std_logic_vector(3 downto 0);
    sGtwiz8CtrlAxiWValid            : in  std_logic;
    sGtwiz8CtrlAxiWReady            : out std_logic;
    sGtwiz8CtrlAxiBResp             : out std_logic_vector(1 downto 0);
    sGtwiz8CtrlAxiBValid            : out std_logic;
    sGtwiz8CtrlAxiBReady            : in  std_logic;
    sGtwiz8CtrlAxiARAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz8CtrlAxiARValid           : in  std_logic;
    sGtwiz8CtrlAxiARReady           : out std_logic;
    sGtwiz8CtrlAxiRData             : out std_logic_vector(31 downto 0);
    sGtwiz8CtrlAxiRResp             : out std_logic_vector(1 downto 0);
    sGtwiz8CtrlAxiRValid            : out std_logic;
    sGtwiz8CtrlAxiRReady            : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 8 Channel DRP Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz8DrpChAxiAWAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz8DrpChAxiAWValid          : in  std_logic;
    sGtwiz8DrpChAxiAWReady          : out std_logic;
    sGtwiz8DrpChAxiWData            : in  std_logic_vector(31 downto 0);
    sGtwiz8DrpChAxiWStrb            : in  std_logic_vector(3 downto 0);
    sGtwiz8DrpChAxiWValid           : in  std_logic;
    sGtwiz8DrpChAxiWReady           : out std_logic;
    sGtwiz8DrpChAxiBResp            : out std_logic_vector(1 downto 0);
    sGtwiz8DrpChAxiBValid           : out std_logic;
    sGtwiz8DrpChAxiBReady           : in  std_logic;
    sGtwiz8DrpChAxiARAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz8DrpChAxiARValid          : in  std_logic;
    sGtwiz8DrpChAxiARReady          : out std_logic;
    sGtwiz8DrpChAxiRData            : out std_logic_vector(31 downto 0);
    sGtwiz8DrpChAxiRResp            : out std_logic_vector(1 downto 0);
    sGtwiz8DrpChAxiRValid           : out std_logic;
    sGtwiz8DrpChAxiRReady           : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 9 Ctrl Register Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz9CtrlAxiAWAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz9CtrlAxiAWValid           : in  std_logic;
    sGtwiz9CtrlAxiAWReady           : out std_logic;
    sGtwiz9CtrlAxiWData             : in  std_logic_vector(31 downto 0);
    sGtwiz9CtrlAxiWStrb             : in  std_logic_vector(3 downto 0);
    sGtwiz9CtrlAxiWValid            : in  std_logic;
    sGtwiz9CtrlAxiWReady            : out std_logic;
    sGtwiz9CtrlAxiBResp             : out std_logic_vector(1 downto 0);
    sGtwiz9CtrlAxiBValid            : out std_logic;
    sGtwiz9CtrlAxiBReady            : in  std_logic;
    sGtwiz9CtrlAxiARAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz9CtrlAxiARValid           : in  std_logic;
    sGtwiz9CtrlAxiARReady           : out std_logic;
    sGtwiz9CtrlAxiRData             : out std_logic_vector(31 downto 0);
    sGtwiz9CtrlAxiRResp             : out std_logic_vector(1 downto 0);
    sGtwiz9CtrlAxiRValid            : out std_logic;
    sGtwiz9CtrlAxiRReady            : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 9 Channel DRP Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz9DrpChAxiAWAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz9DrpChAxiAWValid          : in  std_logic;
    sGtwiz9DrpChAxiAWReady          : out std_logic;
    sGtwiz9DrpChAxiWData            : in  std_logic_vector(31 downto 0);
    sGtwiz9DrpChAxiWStrb            : in  std_logic_vector(3 downto 0);
    sGtwiz9DrpChAxiWValid           : in  std_logic;
    sGtwiz9DrpChAxiWReady           : out std_logic;
    sGtwiz9DrpChAxiBResp            : out std_logic_vector(1 downto 0);
    sGtwiz9DrpChAxiBValid           : out std_logic;
    sGtwiz9DrpChAxiBReady           : in  std_logic;
    sGtwiz9DrpChAxiARAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz9DrpChAxiARValid          : in  std_logic;
    sGtwiz9DrpChAxiARReady          : out std_logic;
    sGtwiz9DrpChAxiRData            : out std_logic_vector(31 downto 0);
    sGtwiz9DrpChAxiRResp            : out std_logic_vector(1 downto 0);
    sGtwiz9DrpChAxiRValid           : out std_logic;
    sGtwiz9DrpChAxiRReady           : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 10 Ctrl Register Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz10CtrlAxiAWAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz10CtrlAxiAWValid           : in  std_logic;
    sGtwiz10CtrlAxiAWReady           : out std_logic;
    sGtwiz10CtrlAxiWData             : in  std_logic_vector(31 downto 0);
    sGtwiz10CtrlAxiWStrb             : in  std_logic_vector(3 downto 0);
    sGtwiz10CtrlAxiWValid            : in  std_logic;
    sGtwiz10CtrlAxiWReady            : out std_logic;
    sGtwiz10CtrlAxiBResp             : out std_logic_vector(1 downto 0);
    sGtwiz10CtrlAxiBValid            : out std_logic;
    sGtwiz10CtrlAxiBReady            : in  std_logic;
    sGtwiz10CtrlAxiARAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz10CtrlAxiARValid           : in  std_logic;
    sGtwiz10CtrlAxiARReady           : out std_logic;
    sGtwiz10CtrlAxiRData             : out std_logic_vector(31 downto 0);
    sGtwiz10CtrlAxiRResp             : out std_logic_vector(1 downto 0);
    sGtwiz10CtrlAxiRValid            : out std_logic;
    sGtwiz10CtrlAxiRReady            : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 10 Channel DRP Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz10DrpChAxiAWAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz10DrpChAxiAWValid          : in  std_logic;
    sGtwiz10DrpChAxiAWReady          : out std_logic;
    sGtwiz10DrpChAxiWData            : in  std_logic_vector(31 downto 0);
    sGtwiz10DrpChAxiWStrb            : in  std_logic_vector(3 downto 0);
    sGtwiz10DrpChAxiWValid           : in  std_logic;
    sGtwiz10DrpChAxiWReady           : out std_logic;
    sGtwiz10DrpChAxiBResp            : out std_logic_vector(1 downto 0);
    sGtwiz10DrpChAxiBValid           : out std_logic;
    sGtwiz10DrpChAxiBReady           : in  std_logic;
    sGtwiz10DrpChAxiARAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz10DrpChAxiARValid          : in  std_logic;
    sGtwiz10DrpChAxiARReady          : out std_logic;
    sGtwiz10DrpChAxiRData            : out std_logic_vector(31 downto 0);
    sGtwiz10DrpChAxiRResp            : out std_logic_vector(1 downto 0);
    sGtwiz10DrpChAxiRValid           : out std_logic;
    sGtwiz10DrpChAxiRReady           : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 11 Ctrl Register Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz11CtrlAxiAWAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz11CtrlAxiAWValid           : in  std_logic;
    sGtwiz11CtrlAxiAWReady           : out std_logic;
    sGtwiz11CtrlAxiWData             : in  std_logic_vector(31 downto 0);
    sGtwiz11CtrlAxiWStrb             : in  std_logic_vector(3 downto 0);
    sGtwiz11CtrlAxiWValid            : in  std_logic;
    sGtwiz11CtrlAxiWReady            : out std_logic;
    sGtwiz11CtrlAxiBResp             : out std_logic_vector(1 downto 0);
    sGtwiz11CtrlAxiBValid            : out std_logic;
    sGtwiz11CtrlAxiBReady            : in  std_logic;
    sGtwiz11CtrlAxiARAddr            : in  std_logic_vector(31 downto 0);
    sGtwiz11CtrlAxiARValid           : in  std_logic;
    sGtwiz11CtrlAxiARReady           : out std_logic;
    sGtwiz11CtrlAxiRData             : out std_logic_vector(31 downto 0);
    sGtwiz11CtrlAxiRResp             : out std_logic_vector(1 downto 0);
    sGtwiz11CtrlAxiRValid            : out std_logic;
    sGtwiz11CtrlAxiRReady            : in  std_logic;

    -------------------------------------------------------
    -- Aurora Port 11 Channel DRP Interface
    -------------------------------------------------------
    -- The following signals are REQUIRED to be in the SAClk domain:
    sGtwiz11DrpChAxiAWAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz11DrpChAxiAWValid          : in  std_logic;
    sGtwiz11DrpChAxiAWReady          : out std_logic;
    sGtwiz11DrpChAxiWData            : in  std_logic_vector(31 downto 0);
    sGtwiz11DrpChAxiWStrb            : in  std_logic_vector(3 downto 0);
    sGtwiz11DrpChAxiWValid           : in  std_logic;
    sGtwiz11DrpChAxiWReady           : out std_logic;
    sGtwiz11DrpChAxiBResp            : out std_logic_vector(1 downto 0);
    sGtwiz11DrpChAxiBValid           : out std_logic;
    sGtwiz11DrpChAxiBReady           : in  std_logic;
    sGtwiz11DrpChAxiARAddr           : in  std_logic_vector(31 downto 0);
    sGtwiz11DrpChAxiARValid          : in  std_logic;
    sGtwiz11DrpChAxiARReady          : out std_logic;
    sGtwiz11DrpChAxiRData            : out std_logic_vector(31 downto 0);
    sGtwiz11DrpChAxiRResp            : out std_logic_vector(1 downto 0);
    sGtwiz11DrpChAxiRValid           : out std_logic;
    sGtwiz11DrpChAxiRReady           : in  std_logic;

    -------------------------------------------------------------------------------------
    -- Clocks
    -------------------------------------------------------------------------------------
    -- These signals may be modified to meet the requirements of the CLIP.
    -- If the ports are modified, the CLIP XML file must be updated to
    -- reflect the port map.
    -- InitClk required by Aurora IP core to register and debounce the pma_init signal.
    -- InitClk is also connected to the DRPCLK port of the GTHE3/GTYE3/GTHE4/GTYE4
    -- CHANNEL interface.
    InitClk                         : in  std_logic;
    -- SAClk is the main clock for AXI interface to access MGT registers and Channel DRP
    SAClk                           : in  std_logic
  );
end UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz;

architecture rtl of UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz is

  --vhook_sigstart
  signal aDioOutEn: std_logic_vector(7 downto 0);
  --vhook_sigend

  constant kNumLanes : integer := 4;  -- lanes per port
  constant kAddrSize : integer := 10; -- DRP address width
  constant kNumPorts : integer := 12;  -- number of ports on front panel
  constant kCutOffFreqForExtraReg : real := 16.375; -- cut off frequency for extra pipeline register to improve timing, unit GHz

  --vhook_d AXI4Lite_GTYE4_Control_Regs4
  component AXI4Lite_GTYE4_Control_Regs4
    port (
      LiteClk                     : in  std_logic;
      aReset_n                    : in  std_logic;
      lAxiMasterWritePort         : in  Axi4LiteWritePortIn_t;
      lAxiSlaveWritePort          : out Axi4LiteWritePortOut_t;
      lAxiMasterReadPort          : in  Axi4LiteReadPortIn_t;
      lAxiSlaveReadPort           : out Axi4LiteReadPortOut_t;
      RxUsrClk2                   : in  std_logic_vector(4-1 downto 0);
      TxUsrClk2                   : in  std_logic_vector(4-1 downto 0);
      MgtRefClk                   : in  std_logic;
      aGtWiz_ResetAll_in          : out std_logic;
      aGtWiz_RxCdr_stable_out     : in  std_logic;
      aGtWiz_ResetTx_pll_data_in  : out std_logic;
      aGtWiz_ResetTx_data_in      : out std_logic;
      aGtWiz_ResetTx_Done_out     : in  std_logic;
      aGtWiz_UserClkTx_active_out : in  std_logic_vector(3 downto 0);
      aGtWiz_ResetRx_pll_data_in  : out std_logic;
      aGtWiz_ResetRx_data_in      : out std_logic;
      aGtWiz_ResetRx_Done_out     : in  std_logic;
      aGtWiz_UserClkRx_active_out : in  std_logic_vector(3 downto 0);
      rRxResetDone_out            : in  std_logic_vector(4-1 downto 0);
      aRxPmaResetDone_out         : in  std_logic_vector(4-1 downto 0);
      aRxPmaReset_in              : out std_logic_vector(4-1 downto 0);
      tTxResetDone_out            : in  std_logic_vector(4-1 downto 0);
      aTxPmaResetDone_out         : in  std_logic_vector(4-1 downto 0);
      aTxPmaReset_in              : out std_logic_vector(4-1 downto 0);
      aTxPcsReset_in              : out std_logic_vector(4-1 downto 0);
      aEyeScanReset_in            : out std_logic_vector(4-1 downto 0);
      aGtPowerGood_out            : in  std_logic_vector(4-1 downto 0);
      aCpllPD_in                  : out std_logic_vector(4-1 downto 0);
      aCpllReset_in               : out std_logic_vector(4-1 downto 0);
      aCpllRefClkSel_in           : out GTRefClkSelAry_t(4-1 downto 0);
      aCpllLock_out               : in  std_logic_vector(4-1 downto 0);
      aCpllRefClkLost_out         : in  std_logic_vector(4-1 downto 0);
      aQpll0PD_in                 : out std_logic;
      aQpll0Reset_in              : out std_logic;
      aQpll0RefClkSel_in          : out GTRefClkSel_t;
      aQpll0Lock_out              : in  std_logic;
      aQpll0RefClkLost_out        : in  std_logic;
      aQpll0SdmReset_in           : out std_logic;
      aQpll0SdmData_in            : out std_logic_vector(24 downto 0);
      aQpll0SdmWidth_in           : out std_logic_vector(1 downto 0);
      aQpll0SdmToggle_in          : out std_logic;
      aQpll0SdmFinalOut_out       : in  std_logic_vector(3 downto 0);
      aQpll1PD_in                 : out std_logic;
      aQpll1Reset_in              : out std_logic;
      aQpll1RefClkSel_in          : out GTRefClkSel_t;
      aQpll1Lock_out              : in  std_logic;
      aQpll1RefClkLost_out        : in  std_logic;
      aQpll1SdmReset_in           : out std_logic;
      aQpll1SdmData_in            : out std_logic_vector(24 downto 0);
      aQpll1SdmWidth_in           : out std_logic_vector(1 downto 0);
      aQpll1SdmToggle_in          : out std_logic;
      aQpll1SdmFinalOut_out       : in  std_logic_vector(3 downto 0);
      aTxSysClkSel_in             : out GTClkSelAry_t(4-1 downto 0);
      aRxSysClkSel_in             : out GTClkSelAry_t(4-1 downto 0);
      aTxPllClkSel_in             : out GTClkSelAry_t(4-1 downto 0);
      aRxPllClkSel_in             : out GTClkSelAry_t(4-1 downto 0);
      aTxOutClkSel_in             : out GTOutClkSelAry_t(4-1 downto 0);
      aRxOutClkSel_in             : out GTOutClkSelAry_t(4-1 downto 0);
      aRxCdrHold_in               : out std_logic_vector(4-1 downto 0);
      aRxCdrOvrdEn_in             : out std_logic_vector(4-1 downto 0);
      aRxCdrReset_in              : out std_logic_vector(4-1 downto 0);
      aRxCdrLock_out              : in  std_logic_vector(4-1 downto 0);
      tTxPiPpmEn_in               : out std_logic_vector(4-1 downto 0);
      tTxPiPpmOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      aTxPiPpmPD_in               : out std_logic_vector(4-1 downto 0);
      tTxPiPpmSel_in              : out std_logic_vector(4-1 downto 0);
      tTxPiPpmStepSize_in         : out GTTxPiPpmStepSizeAry_t(4-1 downto 0);
      rRxDfeOSHold_in             : out std_logic_vector(4-1 downto 0);
      rRxDfeOSOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeAgcHold_in            : out std_logic_vector(4-1 downto 0);
      rRxDfeAgcOvrdEn_in          : out std_logic_vector(4-1 downto 0);
      rRxDfeLFHold_in             : out std_logic_vector(4-1 downto 0);
      rRxDfeLFOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeUTHold_in             : out std_logic_vector(4-1 downto 0);
      rRxDfeUTOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeVPHold_in             : out std_logic_vector(4-1 downto 0);
      rRxDfeVPOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap2Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap2OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap3Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap3OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap4Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap4OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap5Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap5OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap6Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap6OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap7Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap7OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap8Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap8OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap9Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap9OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap10Hold_in          : out std_logic_vector(4-1 downto 0);
      rRxDfeTap10OvrdEn_in        : out std_logic_vector(4-1 downto 0);
      rRxDfeTap11Hold_in          : out std_logic_vector(4-1 downto 0);
      rRxDfeTap11OvrdEn_in        : out std_logic_vector(4-1 downto 0);
      rRxDfeTap12Hold_in          : out std_logic_vector(4-1 downto 0);
      rRxDfeTap12OvrdEn_in        : out std_logic_vector(4-1 downto 0);
      rRxDfeTap13Hold_in          : out std_logic_vector(4-1 downto 0);
      rRxDfeTap13OvrdEn_in        : out std_logic_vector(4-1 downto 0);
      rRxDfeTap14Hold_in          : out std_logic_vector(4-1 downto 0);
      rRxDfeTap14OvrdEn_in        : out std_logic_vector(4-1 downto 0);
      rRxDfeTap15Hold_in          : out std_logic_vector(4-1 downto 0);
      rRxDfeTap15OvrdEn_in        : out std_logic_vector(4-1 downto 0);
      rRxLpmEn_in                 : out std_logic_vector(4-1 downto 0);
      rRxLpmOSHold_in             : out std_logic_vector(4-1 downto 0);
      rRxLpmOSOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      rRxLpmGCHold_in             : out std_logic_vector(4-1 downto 0);
      rRxLpmGCOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      rRxLpmHFHold_in             : out std_logic_vector(4-1 downto 0);
      rRxLpmHFOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      rRxLpmLFHold_in             : out std_logic_vector(4-1 downto 0);
      rRxLpmLFOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      DmonClk                     : in  std_logic_vector(4-1 downto 0);
      dDMonitorOut_out            : in  GTYE4DMonitorOutAry_t(4-1 downto 0);
      rRxRate_in                  : out GTRateSelAry_t(4-1 downto 0);
      rRxRateDone_out             : in  std_logic_vector(4-1 downto 0);
      tTxRate_in                  : out GTRateSelAry_t(4-1 downto 0);
      tTxRateDone_out             : in  std_logic_vector(4-1 downto 0);
      tTxDiffCtrl_in              : out GTYDiffCtrlAry_t(4-1 downto 0);
      aTxPreCursor_in             : out GTYCursorSelAry_t(4-1 downto 0);
      aTxPostCursor_in            : out GTYCursorSelAry_t(4-1 downto 0);
      rRxPrbsSel_in               : out GTPrbsSelAry_t(4-1 downto 0);
      rRxPrbsErr_out              : in  std_logic_vector(4-1 downto 0);
      rRxPrbsLocked_out           : in  std_logic_vector(4-1 downto 0);
      rRxPrbsCntReset_in          : out std_logic_vector(4-1 downto 0);
      rRxPolarity_in              : out std_logic_vector(4-1 downto 0);
      tTxPrbsSel_in               : out GTPrbsSelAry_t(4-1 downto 0);
      tTxPrbsForceErr_in          : out std_logic_vector(4-1 downto 0);
      tTxPolarity_in              : out std_logic_vector(4-1 downto 0);
      tTxDetectRx_in              : out std_logic_vector(4-1 downto 0);
      rPhyStatus_out              : in  std_logic_vector(4-1 downto 0);
      rRxStatus_out               : in  GTRxStatusAry_t(4-1 downto 0);
      tTxPd_in                    : out GTPdAry_t(4-1 downto 0);
      rRxPd_in                    : out GTPdAry_t(4-1 downto 0);
      aLoopback_in                : out GTLoopbackSelAry_t(4-1 downto 0));
  end component;

  --vhook_d aurora64b66b_framing_crcx4_28p0GHz
  component aurora64b66b_framing_crcx4_28p0GHz
    port (
      s_axi_tx_tdata              : in  STD_LOGIC_VECTOR(255 downto 0);
      s_axi_tx_tlast              : in  STD_LOGIC;
      s_axi_tx_tkeep              : in  STD_LOGIC_VECTOR(31 downto 0);
      s_axi_tx_tvalid             : in  STD_LOGIC;
      s_axi_tx_tready             : out STD_LOGIC;
      m_axi_rx_tdata              : out STD_LOGIC_VECTOR(255 downto 0);
      m_axi_rx_tlast              : out STD_LOGIC;
      m_axi_rx_tkeep              : out STD_LOGIC_VECTOR(31 downto 0);
      m_axi_rx_tvalid             : out STD_LOGIC;
      s_axi_nfc_tvalid            : in  STD_LOGIC;
      s_axi_nfc_tdata             : in  STD_LOGIC_VECTOR(15 downto 0);
      s_axi_nfc_tready            : out STD_LOGIC;
      rxp                         : in  STD_LOGIC_VECTOR(0 to 3);
      rxn                         : in  STD_LOGIC_VECTOR(0 to 3);
      txp                         : out STD_LOGIC_VECTOR(0 to 3);
      txn                         : out STD_LOGIC_VECTOR(0 to 3);
      refclk1_in                  : in  STD_LOGIC;
      hard_err                    : out STD_LOGIC;
      soft_err                    : out STD_LOGIC;
      channel_up                  : out STD_LOGIC;
      lane_up                     : out STD_LOGIC_VECTOR(0 to 3);
      crc_pass_fail_n             : out STD_LOGIC;
      crc_valid                   : out STD_LOGIC;
      user_clk_out                : out STD_LOGIC;
      mmcm_not_locked_out         : out STD_LOGIC;
      sync_clk_out                : out STD_LOGIC;
      reset_pb                    : in  STD_LOGIC;
      gt_rxcdrovrden_in           : in  STD_LOGIC;
      power_down                  : in  STD_LOGIC;
      loopback                    : in  STD_LOGIC_VECTOR(2 downto 0);
      pma_init                    : in  STD_LOGIC;
      gt_pll_lock                 : out STD_LOGIC;
      gt0_drpaddr                 : in  STD_LOGIC_VECTOR(9 downto 0);
      gt0_drpdi                   : in  STD_LOGIC_VECTOR(15 downto 0);
      gt0_drpdo                   : out STD_LOGIC_VECTOR(15 downto 0);
      gt0_drprdy                  : out STD_LOGIC;
      gt0_drpen                   : in  STD_LOGIC;
      gt0_drpwe                   : in  STD_LOGIC;
      gt1_drpaddr                 : in  STD_LOGIC_VECTOR(9 downto 0);
      gt1_drpdi                   : in  STD_LOGIC_VECTOR(15 downto 0);
      gt1_drpdo                   : out STD_LOGIC_VECTOR(15 downto 0);
      gt1_drprdy                  : out STD_LOGIC;
      gt1_drpen                   : in  STD_LOGIC;
      gt1_drpwe                   : in  STD_LOGIC;
      gt2_drpaddr                 : in  STD_LOGIC_VECTOR(9 downto 0);
      gt2_drpdi                   : in  STD_LOGIC_VECTOR(15 downto 0);
      gt2_drpdo                   : out STD_LOGIC_VECTOR(15 downto 0);
      gt2_drprdy                  : out STD_LOGIC;
      gt2_drpen                   : in  STD_LOGIC;
      gt2_drpwe                   : in  STD_LOGIC;
      gt3_drpaddr                 : in  STD_LOGIC_VECTOR(9 downto 0);
      gt3_drpdi                   : in  STD_LOGIC_VECTOR(15 downto 0);
      gt3_drpdo                   : out STD_LOGIC_VECTOR(15 downto 0);
      gt3_drprdy                  : out STD_LOGIC;
      gt3_drpen                   : in  STD_LOGIC;
      gt3_drpwe                   : in  STD_LOGIC;
      init_clk                    : in  STD_LOGIC;
      link_reset_out              : out STD_LOGIC;
      gt_rxusrclk_out             : out STD_LOGIC;
      gt_eyescandataerror         : out STD_LOGIC_VECTOR(3 downto 0);
      gt_eyescanreset             : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_eyescantrigger           : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxcdrhold                : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxdfelpmreset            : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxlpmen                  : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxpmareset               : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxpcsreset               : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxrate                   : in  STD_LOGIC_VECTOR(11 downto 0);
      gt_rxbufreset               : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxpmaresetdone           : out STD_LOGIC_VECTOR(3 downto 0);
      gt_rxprbssel                : in  STD_LOGIC_VECTOR(15 downto 0);
      gt_rxprbserr                : out STD_LOGIC_VECTOR(3 downto 0);
      gt_rxprbscntreset           : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxresetdone              : out STD_LOGIC_VECTOR(3 downto 0);
      gt_rxbufstatus              : out STD_LOGIC_VECTOR(11 downto 0);
      gt_txpostcursor             : in  STD_LOGIC_VECTOR(19 downto 0);
      gt_txdiffctrl               : in  STD_LOGIC_VECTOR(19 downto 0);
      gt_txprecursor              : in  STD_LOGIC_VECTOR(19 downto 0);
      gt_txpolarity               : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txinhibit                : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txpmareset               : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txpcsreset               : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txprbssel                : in  STD_LOGIC_VECTOR(15 downto 0);
      gt_txprbsforceerr           : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txbufstatus              : out STD_LOGIC_VECTOR(7 downto 0);
      gt_txresetdone              : out STD_LOGIC_VECTOR(3 downto 0);
      gt_pcsrsvdin                : in  STD_LOGIC_VECTOR(63 downto 0);
      gt_dmonitorout              : out STD_LOGIC_VECTOR(63 downto 0);
      gt_cplllock                 : out STD_LOGIC_VECTOR(3 downto 0);
      gt_qplllock                 : out STD_LOGIC;
      gt_powergood                : out STD_LOGIC_VECTOR(3 downto 0);
      gt_qpllclk_quad1_out        : out STD_LOGIC;
      gt_qpllrefclk_quad1_out     : out STD_LOGIC;
      gt_qplllock_quad1_out       : out STD_LOGIC;
      gt_qpllrefclklost_quad1_out : out STD_LOGIC;
      sys_reset_out               : out STD_LOGIC;
      gt_reset_out                : out STD_LOGIC;
      tx_out_clk                  : out STD_LOGIC);
  end component;

  --vhook_d SasquatchClipFixedLogic
  component SasquatchClipFixedLogic
    port (
      AxiClk                          : in  std_logic;
      aDiagramReset                   : in  std_logic;
      aLmkI2cSda                      : inout std_logic;
      aLmkI2cScl                      : inout std_logic;
      aLmk1Pdn_n                      : out std_logic;
      aLmk2Pdn_n                      : out std_logic;
      aLmk1Gpio0                      : out std_logic;
      aLmk2Gpio0                      : out std_logic;
      aLmk1Status0                    : in  std_logic;
      aLmk1Status1                    : in  std_logic;
      aLmk2Status0                    : in  std_logic;
      aLmk2Status1                    : in  std_logic;
      aIPassPrsnt_n                   : in  std_logic_vector(7 downto 0);
      aIPassIntr_n                    : in  std_logic_vector(7 downto 0);
      aIPassSCL                       : inout std_logic_vector(11 downto 0);
      aIPassSDA                       : inout std_logic_vector(11 downto 0);
      aPortExpReset_n                 : out std_logic;
      aPortExpIntr_n                  : in  std_logic;
      aPortExpSda                     : inout std_logic;
      aPortExpScl                     : inout std_logic;
      stIoModuleSupportsFRAGLs        : out std_logic;
      xIoModuleReady                  : out std_logic;
      xIoModuleErrorCode              : out std_logic_vector(31 downto 0);
      xMgtRefClkEnabled               : out std_logic_vector(11 downto 0);
      aDioOutEn                       : out std_logic_vector(7 downto 0);
      xHostAxiStreamToClipTData       : in  std_logic_vector(31 downto 0);
      xHostAxiStreamToClipTLast       : in  std_logic;
      xHostAxiStreamFromClipTReady    : out std_logic;
      xHostAxiStreamToClipTValid      : in  std_logic;
      xHostAxiStreamFromClipTData     : out std_logic_vector(31 downto 0);
      xHostAxiStreamFromClipTLast     : out std_logic;
      xHostAxiStreamToClipTReady      : in  std_logic;
      xHostAxiStreamFromClipTValid    : out std_logic;
      xDiagramAxiStreamToClipTData    : in  std_logic_vector(31 downto 0);
      xDiagramAxiStreamToClipTLast    : in  std_logic;
      xDiagramAxiStreamFromClipTReady : out std_logic;
      xDiagramAxiStreamToClipTValid   : in  std_logic;
      xDiagramAxiStreamFromClipTData  : out std_logic_vector(31 downto 0);
      xDiagramAxiStreamFromClipTLast  : out std_logic;
      xDiagramAxiStreamToClipTReady   : in  std_logic;
      xDiagramAxiStreamFromClipTValid : out std_logic;
      xClipAxi4LiteMasterARAddr       : out std_logic_vector(31 downto 0);
      xClipAxi4LiteMasterARProt       : out std_logic_vector(2 downto 0);
      xClipAxi4LiteMasterARReady      : in  std_logic;
      xClipAxi4LiteMasterARValid      : out std_logic;
      xClipAxi4LiteMasterAWAddr       : out std_logic_vector(31 downto 0);
      xClipAxi4LiteMasterAWProt       : out std_logic_vector(2 downto 0);
      xClipAxi4LiteMasterAWReady      : in  std_logic;
      xClipAxi4LiteMasterAWValid      : out std_logic;
      xClipAxi4LiteMasterBReady       : out std_logic;
      xClipAxi4LiteMasterBResp        : in  std_logic_vector(1 downto 0);
      xClipAxi4LiteMasterBValid       : in  std_logic;
      xClipAxi4LiteMasterRData        : in  std_logic_vector(31 downto 0);
      xClipAxi4LiteMasterRReady       : out std_logic;
      xClipAxi4LiteMasterRResp        : in  std_logic_vector(1 downto 0);
      xClipAxi4LiteMasterRValid       : in  std_logic;
      xClipAxi4LiteMasterWData        : out std_logic_vector(31 downto 0);
      xClipAxi4LiteMasterWReady       : in  std_logic;
      xClipAxi4LiteMasterWStrb        : out std_logic_vector(3 downto 0);
      xClipAxi4LiteMasterWValid       : out std_logic);
  end component;

  --vhook_d AxiLiteToMgtDrp
  component AxiLiteToMgtDrp
    generic (
      kNumLanes : integer := 4;
      kAddrSize : integer := 10);
    port (
      aResetSl        : in  std_logic;
      SAxiAClk        : in  std_logic;
      sAxiAWaddr      : in  std_logic_vector(31 downto 0);
      sAxiAWValid     : in  std_logic;
      sAxiAWReady     : out std_logic;
      sAxiWData       : in  std_logic_vector(31 downto 0);
      sAxiWStrb       : in  std_logic_vector(3 downto 0);
      sAxiWValid      : in  std_logic;
      sAxiWReady      : out std_logic;
      sAxiBResp       : out std_logic_vector(1 downto 0);
      sAxiBValid      : out std_logic;
      sAxiBReady      : in  std_logic;
      sAxiARAddr      : in  std_logic_vector(31 downto 0);
      sAxiARValid     : in  std_logic;
      sAxiARReady     : out std_logic;
      sAxiRData       : out std_logic_vector(31 downto 0);
      sAxiRResp       : out std_logic_vector(1 downto 0);
      sAxiRValid      : out std_logic;
      sAxiRReady      : in  std_logic;
      InitClk         : in  std_logic;
      iGtwizDrpClk    : out std_logic_vector(kNumLanes-1 downto 0);
      iGtwizDrpAddrIn : out std_logic_vector(kNumLanes*kAddrSize-1 downto 0);
      iGtwizDrpDiIn   : out std_logic_vector(kNumLanes*16-1 downto 0);
      iGtwizDrpDoOut  : in  std_logic_vector(kNumLanes*16-1 downto 0);
      iGtwizDrpEnIn   : out std_logic_vector(kNumLanes-1 downto 0);
      iGtwizDrpWeIn   : out std_logic_vector(kNumLanes-1 downto 0);
      iGtwizDrpRdyOut : in  std_logic_vector(kNumLanes-1 downto 0));
  end component;

  --vhook_d AxiFramingRegx4
  component AxiFramingRegx4
    port (
      aclk : in std_logic;
      aresetn : in std_logic;
      s_axis_tvalid : in std_logic;
      s_axis_tready : out std_logic;
      s_axis_tdata : in std_logic_vector(255 downto 0);
      s_axis_tkeep : in std_logic_vector(31 downto 0);
      s_axis_tlast : in std_logic;
      m_axis_tvalid : out std_logic;
      m_axis_tready : in std_logic;
      m_axis_tdata : out std_logic_vector(255 downto 0);
      m_axis_tkeep : out std_logic_vector(31 downto 0);
      m_axis_tlast : out std_logic
    );
  end component;

  -------------------------------------------------------------
  -- CLIP signals                                            --
  -------------------------------------------------------------
  signal MgtRefClk            : std_logic_vector(11 downto 0);
  signal xMgtRefClkEnabled    : std_logic_vector(11 downto 0);
  signal aReset_n             : std_logic;

  -------------------------------------------------------------
  -- Vectorized signals to connect to GT Wizard Verilog core --
  -------------------------------------------------------------
  signal iGtwizDrpAddrIn      : std_logic_vector(kNumPorts*kNumLanes*kAddrSize-1 downto 0);
  signal iGtwizDrpDiIn        : std_logic_vector(kNumPorts*kNumLanes*16-1 downto 0);
  signal iGtwizDrpDoOut       : std_logic_vector(kNumPorts*kNumLanes*16-1 downto 0);
  signal iGtwizDrpRdyOut      : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal iGtwizDrpEnIn        : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal iGtwizDrpWeIn        : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);

  signal aGtwizDMonitorOut    : std_logic_vector(kNumPorts*kNumLanes*17-1 downto 0);
  signal rGtwizRxRateIn       : std_logic_vector(kNumPorts*kNumLanes*3-1  downto 0);

  signal tGtwizTxDiffCtrlIn   : std_logic_vector(kNumPorts*kNumLanes*5-1  downto 0);
  signal aGtwizTxPreCursorIn  : std_logic_vector(kNumPorts*kNumLanes*5-1  downto 0);
  signal aGtwizTxPostCursorIn : std_logic_vector(kNumPorts*kNumLanes*5-1  downto 0);
  signal rGtwizRxPrbsSelIn    : std_logic_vector(kNumPorts*kNumLanes*4-1  downto 0);
  signal tGtwizTxPrbsSelIn    : std_logic_vector(kNumPorts*kNumLanes*4-1  downto 0);

  -------------------------------------------------------------
  -- Signals to connect to AXI4-Lite Register Set            --
  -------------------------------------------------------------
  type Axi4LiteReadPortInAry_t   is array(natural range <>) of Axi4LiteReadPortIn_t;
  type Axi4LiteWritePortInAry_t  is array(natural range <>) of Axi4LiteWritePortIn_t;
  type Axi4LiteReadPortOutAry_t  is array(natural range <>) of Axi4LiteReadPortOut_t;
  type Axi4LiteWritePortOutAry_t is array(natural range <>) of Axi4LiteWritePortOut_t;
  signal sAxiMasterReadPort   : Axi4LiteReadPortInAry_t  (kNumPorts-1 downto 0);
  signal sAxiMasterWritePort  : Axi4LiteWritePortInAry_t (kNumPorts-1 downto 0);
  signal sAxiSlaveReadPort    : Axi4LiteReadPortOutAry_t (kNumPorts-1 downto 0);
  signal sAxiSlaveWritePort   : Axi4LiteWritePortOutAry_t(kNumPorts-1 downto 0);

  signal RxUsrClk2, TxUsrClk2 : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);

  signal rRxResetDoneOut      : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal aRxPmaResetIn        : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal aGtRxPmaResetDone    : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal tTxResetDoneOut      : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal aTxPmaResetIn        : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);

  signal aTxPcsResetIn        : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal aEyeScanResetIn      : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal aGtPowerGoodOut      : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);

  signal aCpllLockOut         : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);

  signal aQpll0LockOut        : std_logic_vector(kNumPorts-1 downto 0);
  signal aQpll0RefClkLostOut  : std_logic_vector(kNumPorts-1 downto 0);

  signal aRxCdrHoldIn         : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal aRxCdrOvrdEnIn       : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);

  signal rRxLpmEnIn           : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);

  signal SGtwizSlvDmonclk     : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal aDMonitorOut         : GTYE4DMonitorOutAry_t(kNumPorts*kNumLanes-1 downto 0);

  signal rRxRateIn            : GTRateSelAry_t  (kNumPorts*kNumLanes-1 downto 0);

  signal tTxDiffCtrlIn        : GTYDiffCtrlAry_t (kNumPorts*kNumLanes-1 downto 0);
  signal aTxPreCursorIn       : GTYCursorSelAry_t(kNumPorts*kNumLanes-1 downto 0);
  signal aTxPostCursorIn      : GTYCursorSelAry_t(kNumPorts*kNumLanes-1 downto 0);

  signal rRxPrbsSelIn         : GTPrbsSelAry_t  (kNumPorts*kNumLanes-1 downto 0);
  signal rRxPrbsErrOut        : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal rRxPrbsCntResetIn    : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal tTxPrbsSelIn         : GTPrbsSelAry_t  (kNumPorts*kNumLanes-1 downto 0);
  signal tTxPrbsForceErrIn    : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal tTxPolarityIn        : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);

  signal aLoopbackIn          : GTLoopbackSelAry_t(kNumPorts*kNumLanes-1 downto 0);

  -------------------------------------------------------------
  -- Vectorized signals to connect to Aurora core            --
  -------------------------------------------------------------
  signal PortRx_p : std_logic_vector(0 to 47);
  signal PortRx_n : std_logic_vector(0 to 47);
  signal PortTx_p : std_logic_vector(0 to 47);
  signal PortTx_n : std_logic_vector(0 to 47);

  -- SLVs for the single lane port signals on the cores.
  signal uPortHardErr, uPortSoftErr, uPortChannelUp : std_logic_vector(kNumPorts-1 downto 0);
  signal uPortCrcPassFail_n, uPortCrcValid, uPortAxiNfcTValid, uPortAxiNfcTReady : std_logic_vector(kNumPorts-1 downto 0);

  subtype AuroraLaneUp_t is std_logic_vector(kNumLanes-1 downto 0);
  type AuroraLaneUpAry_t is array(natural range <>) of AuroraLaneUp_t;
  signal uPortLaneUp, uPortLaneUpRev : AuroraLaneUpAry_t(kNumPorts-1 downto 0);

  subtype AxiData2_t is std_logic_vector(1 downto 0);
  type AxiData2Ary_t is array(natural range <>) of AxiData2_t;
  signal sGtwizDrpChAxiBResp  : AxiData2Ary_t(kNumPorts-1 downto 0);
  signal sGtwizDrpChAxiRResp  : AxiData2Ary_t(kNumPorts-1 downto 0);

  subtype AxiData4_t is std_logic_vector(3 downto 0);
  type AxiData4Ary_t is array(natural range <>) of AxiData4_t;
  signal sGtwizDrpChAxiWStrb  : AxiData4Ary_t(kNumPorts-1 downto 0);

  subtype AxiData32_t is std_logic_vector(31 downto 0);
  type AxiData32Ary_t is array(natural range <>) of AxiData32_t;
  signal uPortAxiNfcTData : AxiData32Ary_t(kNumPorts-1 downto 0);
  signal sGtwizDrpChAxiAWAddr : AxiData32Ary_t(kNumPorts-1 downto 0);
  signal sGtwizDrpChAxiWData  : AxiData32Ary_t(kNumPorts-1 downto 0);
  signal sGtwizDrpChAxiARAddr : AxiData32Ary_t(kNumPorts-1 downto 0);
  signal sGtwizDrpChAxiRData  : AxiData32Ary_t(kNumPorts-1 downto 0);

  subtype AxiData64_t is std_logic_vector(63 downto 0);
  type AxiData64Ary_t is array(natural range <>) of AxiData64_t;
  signal uPortAxiTxTData0, uPortAxiTxTData1, uPortAxiTxTData2, uPortAxiTxTData3 : AxiData64Ary_t(kNumPorts-1 downto 0);
  signal uPortAxiRxTData0, uPortAxiRxTData1, uPortAxiRxTData2, uPortAxiRxTData3 : AxiData64Ary_t(kNumPorts-1 downto 0);

  subtype AxiData256_t is std_logic_vector(255 downto 0);
  type AxiData256Ary_t is array(natural range <>) of AxiData256_t;
  signal uPortAxiTxTData : AxiData256Ary_t(kNumPorts-1 downto 0);
  signal uPortAxiRegTxTData : AxiData256Ary_t(kNumPorts-1 downto 0);
  signal uPortAxiRxTData : AxiData256Ary_t(kNumPorts-1 downto 0);

  subtype AxiKeep_t is std_logic_vector(31 downto 0);
  type AxiKeepAry_t is array(natural range <>) of AxiKeep_t;
  signal uPortAxiTxTKeep, uPortAxiRxTKeep : AxiKeepAry_t(kNumPorts-1 downto 0);
  signal uPortAxiRegTxTKeep : AxiKeepAry_t(kNumPorts-1 downto 0);

  signal sGtwizDrpChAxiAWValid : std_logic_vector(kNumPorts-1 downto 0);
  signal sGtwizDrpChAxiAWReady : std_logic_vector(kNumPorts-1 downto 0);
  signal sGtwizDrpChAxiWValid  : std_logic_vector(kNumPorts-1 downto 0);
  signal sGtwizDrpChAxiWReady  : std_logic_vector(kNumPorts-1 downto 0);
  signal sGtwizDrpChAxiBValid  : std_logic_vector(kNumPorts-1 downto 0);
  signal sGtwizDrpChAxiBReady  : std_logic_vector(kNumPorts-1 downto 0);
  signal sGtwizDrpChAxiARValid : std_logic_vector(kNumPorts-1 downto 0);
  signal sGtwizDrpChAxiARReady : std_logic_vector(kNumPorts-1 downto 0);
  signal sGtwizDrpChAxiRValid  : std_logic_vector(kNumPorts-1 downto 0);
  signal sGtwizDrpChAxiRReady  : std_logic_vector(kNumPorts-1 downto 0);

  signal uPortAxiTxTLast, uPortAxiTxTValid, uPortAxiTxTReady : std_logic_vector(kNumPorts-1 downto 0);
  signal uPortAxiRegTxTLast, uPortAxiRegTxTValid, uPortAxiRegTxTReady : std_logic_vector(kNumPorts-1 downto 0);
  signal uPortAxiRxTLast, uPortAxiRxTValid : std_logic_vector(kNumPorts-1 downto 0);

  signal UserClkPort, RxUserClk2Port, SyncClkPort, aPortResetPb : std_logic_vector(kNumPorts-1 downto 0);
  signal uPortMmcmNotLocked, uPortSysResetOut, iPortLinkResetOut, aPortPmaInit : std_logic_vector(kNumPorts-1 downto 0);


  -------------------------------------------------------------
  -- Utility Functions                                       --
  -------------------------------------------------------------
  function to_StdLogic(b : boolean) return std_logic is
  begin
    if b then
      return '1';
    else
      return '0';
    end if;
  end to_StdLogic;

  function reversi (arg : std_logic_vector) return std_logic_vector is
    variable RetVal : std_logic_vector(arg'reverse_range) := (others => '0');
  begin  -- reversi
    for index in arg'range loop
      RetVal(index) := arg(index);
    end loop;  -- index
    return RetVal;
  end reversi;

begin

  ---------------------------------------------------------------------------------------
  -- 7903 Required Logic
  ---------------------------------------------------------------------------------------
  -- !!! WARNING !!!
  -- Do not change this logic. Doing so may cause the CLIP to stop functioning.

  -- Configuration Netlist --
  --vhook SasquatchClipFixedLogic
  --vhook_a aDiagramReset  aResetSl
  SasquatchClipFixedLogicx: SasquatchClipFixedLogic
    port map (
      AxiClk                          => AxiClk,                           --in  std_logic
      aDiagramReset                   => aResetSl,                         --in  std_logic
      aLmkI2cSda                      => aLmkI2cSda,                       --inout std_logic
      aLmkI2cScl                      => aLmkI2cScl,                       --inout std_logic
      aLmk1Pdn_n                      => aLmk1Pdn_n,                       --out std_logic
      aLmk2Pdn_n                      => aLmk2Pdn_n,                       --out std_logic
      aLmk1Gpio0                      => aLmk1Gpio0,                       --out std_logic
      aLmk2Gpio0                      => aLmk2Gpio0,                       --out std_logic
      aLmk1Status0                    => aLmk1Status0,                     --in  std_logic
      aLmk1Status1                    => aLmk1Status1,                     --in  std_logic
      aLmk2Status0                    => aLmk2Status0,                     --in  std_logic
      aLmk2Status1                    => aLmk2Status1,                     --in  std_logic
      aIPassPrsnt_n                   => aIPassPrsnt_n,                    --in  std_logic_vector(7:0)
      aIPassIntr_n                    => aIPassIntr_n,                     --in  std_logic_vector(7:0)
      aIPassSCL                       => aIPassSCL,                        --inout std_logic_vector(11:0)
      aIPassSDA                       => aIPassSDA,                        --inout std_logic_vector(11:0)
      aPortExpReset_n                 => aPortExpReset_n,                  --out std_logic
      aPortExpIntr_n                  => aPortExpIntr_n,                   --in  std_logic
      aPortExpSda                     => aPortExpSda,                      --inout std_logic
      aPortExpScl                     => aPortExpScl,                      --inout std_logic
      stIoModuleSupportsFRAGLs        => stIoModuleSupportsFRAGLs,         --out std_logic
      xIoModuleReady                  => xIoModuleReady,                   --out std_logic
      xIoModuleErrorCode              => xIoModuleErrorCode,               --out std_logic_vector(31:0)
      xMgtRefClkEnabled               => xMgtRefClkEnabled,                --out std_logic_vector(11:0)
      aDioOutEn                       => aDioOutEn,                        --out std_logic_vector(7:0)
      xHostAxiStreamToClipTData       => xHostAxiStreamToClipTData,        --in  std_logic_vector(31:0)
      xHostAxiStreamToClipTLast       => xHostAxiStreamToClipTLast,        --in  std_logic
      xHostAxiStreamFromClipTReady    => xHostAxiStreamFromClipTReady,     --out std_logic
      xHostAxiStreamToClipTValid      => xHostAxiStreamToClipTValid,       --in  std_logic
      xHostAxiStreamFromClipTData     => xHostAxiStreamFromClipTData,      --out std_logic_vector(31:0)
      xHostAxiStreamFromClipTLast     => xHostAxiStreamFromClipTLast,      --out std_logic
      xHostAxiStreamToClipTReady      => xHostAxiStreamToClipTReady,       --in  std_logic
      xHostAxiStreamFromClipTValid    => xHostAxiStreamFromClipTValid,     --out std_logic
      xDiagramAxiStreamToClipTData    => xDiagramAxiStreamToClipTData,     --in  std_logic_vector(31:0)
      xDiagramAxiStreamToClipTLast    => xDiagramAxiStreamToClipTLast,     --in  std_logic
      xDiagramAxiStreamFromClipTReady => xDiagramAxiStreamFromClipTReady,  --out std_logic
      xDiagramAxiStreamToClipTValid   => xDiagramAxiStreamToClipTValid,    --in  std_logic
      xDiagramAxiStreamFromClipTData  => xDiagramAxiStreamFromClipTData,   --out std_logic_vector(31:0)
      xDiagramAxiStreamFromClipTLast  => xDiagramAxiStreamFromClipTLast,   --out std_logic
      xDiagramAxiStreamToClipTReady   => xDiagramAxiStreamToClipTReady,    --in  std_logic
      xDiagramAxiStreamFromClipTValid => xDiagramAxiStreamFromClipTValid,  --out std_logic
      xClipAxi4LiteMasterARAddr       => xClipAxi4LiteMasterARAddr,        --out std_logic_vector(31:0)
      xClipAxi4LiteMasterARProt       => xClipAxi4LiteMasterARProt,        --out std_logic_vector(2:0)
      xClipAxi4LiteMasterARReady      => xClipAxi4LiteMasterARReady,       --in  std_logic
      xClipAxi4LiteMasterARValid      => xClipAxi4LiteMasterARValid,       --out std_logic
      xClipAxi4LiteMasterAWAddr       => xClipAxi4LiteMasterAWAddr,        --out std_logic_vector(31:0)
      xClipAxi4LiteMasterAWProt       => xClipAxi4LiteMasterAWProt,        --out std_logic_vector(2:0)
      xClipAxi4LiteMasterAWReady      => xClipAxi4LiteMasterAWReady,       --in  std_logic
      xClipAxi4LiteMasterAWValid      => xClipAxi4LiteMasterAWValid,       --out std_logic
      xClipAxi4LiteMasterBReady       => xClipAxi4LiteMasterBReady,        --out std_logic
      xClipAxi4LiteMasterBResp        => xClipAxi4LiteMasterBResp,         --in  std_logic_vector(1:0)
      xClipAxi4LiteMasterBValid       => xClipAxi4LiteMasterBValid,        --in  std_logic
      xClipAxi4LiteMasterRData        => xClipAxi4LiteMasterRData,         --in  std_logic_vector(31:0)
      xClipAxi4LiteMasterRReady       => xClipAxi4LiteMasterRReady,        --out std_logic
      xClipAxi4LiteMasterRResp        => xClipAxi4LiteMasterRResp,         --in  std_logic_vector(1:0)
      xClipAxi4LiteMasterRValid       => xClipAxi4LiteMasterRValid,        --in  std_logic
      xClipAxi4LiteMasterWData        => xClipAxi4LiteMasterWData,         --out std_logic_vector(31:0)
      xClipAxi4LiteMasterWReady       => xClipAxi4LiteMasterWReady,        --in  std_logic
      xClipAxi4LiteMasterWStrb        => xClipAxi4LiteMasterWStrb,         --out std_logic_vector(3:0)
      xClipAxi4LiteMasterWValid       => xClipAxi4LiteMasterWValid);       --out std_logic

  -- Drive active low reset.
  aReset_n <= not aResetSl;

  GenDioBuffers: for i in aDio'range generate
    aDio(i) <= aDioOut(i) when aDioOutEn(i) = '1' else 'Z';
  end generate GenDioBuffers;
  aDioIn <= aDio;

  ---------------------------------------------------------------------------------------
  -- MGT Reference Clocks
  ---------------------------------------------------------------------------------------
  -- Instantiate IBUFDS_GTE4 buffers on the reference clock pins.
  -- Depending on the application, the IP may already instantiate a buffer, so
  -- these buffers may be removed in this case.

  IbufdsGen: for i in MgtRefClk_p'range generate

    --vhook_i IBUFDS_GTE4 IBUFDS_GTE4_inst hidegeneric=true
    --vhook_a I      MgtRefClk_p(i)
    --vhook_a IB     MgtRefClk_n(i)
    --vhook_a CEB    '0'
    --vhook_a O      MgtRefClk(i)
    --vhook_a ODIV2  open
    IBUFDS_GTE4_inst: IBUFDS_GTE4
      port map (
        O     => MgtRefClk(i),    --out std_ulogic
        ODIV2 => open,            --out std_ulogic
        CEB   => '0',             --in  std_ulogic
        I     => MgtRefClk_p(i),  --in  std_ulogic
        IB    => MgtRefClk_n(i)); --in  std_ulogic

  end generate;

  ---------------------------------------------------------------------------------------
  -- Aurora Core
  ---------------------------------------------------------------------------------------
  ---------------------------------------------------------
  -- Sample Status Signals
  ---------------------------------------------------------
  -- Sample Port0 Status Signals
  process(aResetSl, UserClkPort(0))
  begin
    if aResetSl = '1' then
      uPort0HardError      <= '0';
      uPort0SoftError      <= '0';
      uPort0ChannelUp      <= '0';
      uPort0SysResetOut    <= '1';
      uPort0MmcmNotLockOut <= '1';
      uPort0LaneUp         <= (others => '0');
    elsif rising_edge(UserClkPort(0)) then
      uPort0HardError      <= uPortHardErr    (0);
      uPort0SoftError      <= uPortSoftErr    (0);
      uPort0ChannelUp      <= uPortChannelUp  (0);
      uPort0SysResetOut    <= uPortSysResetOut(0);
      uPort0MmcmNotLockOut <= uPortMmcmNotLocked(0);
      uPort0LaneUp         <= uPortLaneUp(0);
    end if;
  end process;

  -- Sample Port1 Status Signals
  process(aResetSl, UserClkPort(1))
  begin
    if aResetSl = '1' then
      uPort1HardError      <= '0';
      uPort1SoftError      <= '0';
      uPort1ChannelUp      <= '0';
      uPort1SysResetOut    <= '1';
      uPort1MmcmNotLockOut <= '1';
      uPort1LaneUp         <= (others => '0');
    elsif rising_edge(UserClkPort(1)) then
      uPort1HardError      <= uPortHardErr    (1);
      uPort1SoftError      <= uPortSoftErr    (1);
      uPort1ChannelUp      <= uPortChannelUp  (1);
      uPort1SysResetOut    <= uPortSysResetOut(1);
      uPort1MmcmNotLockOut <= uPortMmcmNotLocked(1);
      uPort1LaneUp         <= uPortLaneUp(1);
    end if;
  end process;

  -- Sample Port2 Status Signals
  process(aResetSl, UserClkPort(2))
  begin
    if aResetSl = '1' then
      uPort2HardError      <= '0';
      uPort2SoftError      <= '0';
      uPort2ChannelUp      <= '0';
      uPort2SysResetOut    <= '1';
      uPort2MmcmNotLockOut <= '1';
      uPort2LaneUp         <= (others => '0');
    elsif rising_edge(UserClkPort(2)) then
      uPort2HardError      <= uPortHardErr    (2);
      uPort2SoftError      <= uPortSoftErr    (2);
      uPort2ChannelUp      <= uPortChannelUp  (2);
      uPort2SysResetOut    <= uPortSysResetOut(2);
      uPort2MmcmNotLockOut <= uPortMmcmNotLocked(2);
      uPort2LaneUp         <= uPortLaneUp(2);
    end if;
  end process;

  -- Sample Port3 Status Signals
  process(aResetSl, UserClkPort(3))
  begin
    if aResetSl = '1' then
      uPort3HardError      <= '0';
      uPort3SoftError      <= '0';
      uPort3ChannelUp      <= '0';
      uPort3SysResetOut    <= '1';
      uPort3MmcmNotLockOut <= '1';
      uPort3LaneUp         <= (others => '0');
    elsif rising_edge(UserClkPort(3)) then
      uPort3HardError      <= uPortHardErr    (3);
      uPort3SoftError      <= uPortSoftErr    (3);
      uPort3ChannelUp      <= uPortChannelUp  (3);
      uPort3SysResetOut    <= uPortSysResetOut(3);
      uPort3MmcmNotLockOut <= uPortMmcmNotLocked(3);
      uPort3LaneUp         <= uPortLaneUp(3);
    end if;
  end process;

  -- Sample Port4 Status Signals
  process(aResetSl, UserClkPort(4))
  begin
    if aResetSl = '1' then
      uPort4HardError      <= '0';
      uPort4SoftError      <= '0';
      uPort4ChannelUp      <= '0';
      uPort4SysResetOut    <= '1';
      uPort4MmcmNotLockOut <= '1';
      uPort4LaneUp         <= (others => '0');
    elsif rising_edge(UserClkPort(4)) then
      uPort4HardError      <= uPortHardErr    (4);
      uPort4SoftError      <= uPortSoftErr    (4);
      uPort4ChannelUp      <= uPortChannelUp  (4);
      uPort4SysResetOut    <= uPortSysResetOut(4);
      uPort4MmcmNotLockOut <= uPortMmcmNotLocked(4);
      uPort4LaneUp         <= uPortLaneUp(4);
    end if;
  end process;

  -- Sample Port5 Status Signals
  process(aResetSl, UserClkPort(5))
  begin
    if aResetSl = '1' then
      uPort5HardError      <= '0';
      uPort5SoftError      <= '0';
      uPort5ChannelUp      <= '0';
      uPort5SysResetOut    <= '1';
      uPort5MmcmNotLockOut <= '1';
      uPort5LaneUp         <= (others => '0');
    elsif rising_edge(UserClkPort(5)) then
      uPort5HardError      <= uPortHardErr    (5);
      uPort5SoftError      <= uPortSoftErr    (5);
      uPort5ChannelUp      <= uPortChannelUp  (5);
      uPort5SysResetOut    <= uPortSysResetOut(5);
      uPort5MmcmNotLockOut <= uPortMmcmNotLocked(5);
      uPort5LaneUp         <= uPortLaneUp(5);
    end if;
  end process;

  -- Sample Port6 Status Signals
  process(aResetSl, UserClkPort(6))
  begin
    if aResetSl = '1' then
      uPort6HardError      <= '0';
      uPort6SoftError      <= '0';
      uPort6ChannelUp      <= '0';
      uPort6SysResetOut    <= '1';
      uPort6MmcmNotLockOut <= '1';
      uPort6LaneUp         <= (others => '0');
    elsif rising_edge(UserClkPort(6)) then
      uPort6HardError      <= uPortHardErr    (6);
      uPort6SoftError      <= uPortSoftErr    (6);
      uPort6ChannelUp      <= uPortChannelUp  (6);
      uPort6SysResetOut    <= uPortSysResetOut(6);
      uPort6MmcmNotLockOut <= uPortMmcmNotLocked(6);
      uPort6LaneUp         <= uPortLaneUp(6);
    end if;
  end process;

  -- Sample Port7 Status Signals
  process(aResetSl, UserClkPort(7))
  begin
    if aResetSl = '1' then
      uPort7HardError      <= '0';
      uPort7SoftError      <= '0';
      uPort7ChannelUp      <= '0';
      uPort7SysResetOut    <= '1';
      uPort7MmcmNotLockOut <= '1';
      uPort7LaneUp         <= (others => '0');
    elsif rising_edge(UserClkPort(7)) then
      uPort7HardError      <= uPortHardErr    (7);
      uPort7SoftError      <= uPortSoftErr    (7);
      uPort7ChannelUp      <= uPortChannelUp  (7);
      uPort7SysResetOut    <= uPortSysResetOut(7);
      uPort7MmcmNotLockOut <= uPortMmcmNotLocked(7);
      uPort7LaneUp         <= uPortLaneUp(7);
    end if;
  end process;

  -- Sample Port8 Status Signals
  process(aResetSl, UserClkPort(8))
  begin
    if aResetSl = '1' then
      uPort8HardError      <= '0';
      uPort8SoftError      <= '0';
      uPort8ChannelUp      <= '0';
      uPort8SysResetOut    <= '1';
      uPort8MmcmNotLockOut <= '1';
      uPort8LaneUp         <= (others => '0');
    elsif rising_edge(UserClkPort(8)) then
      uPort8HardError      <= uPortHardErr    (8);
      uPort8SoftError      <= uPortSoftErr    (8);
      uPort8ChannelUp      <= uPortChannelUp  (8);
      uPort8SysResetOut    <= uPortSysResetOut(8);
      uPort8MmcmNotLockOut <= uPortMmcmNotLocked(8);
      uPort8LaneUp         <= uPortLaneUp(8);
    end if;
  end process;

  -- Sample Port9 Status Signals
  process(aResetSl, UserClkPort(9))
  begin
    if aResetSl = '1' then
      uPort9HardError      <= '0';
      uPort9SoftError      <= '0';
      uPort9ChannelUp      <= '0';
      uPort9SysResetOut    <= '1';
      uPort9MmcmNotLockOut <= '1';
      uPort9LaneUp         <= (others => '0');
    elsif rising_edge(UserClkPort(9)) then
      uPort9HardError      <= uPortHardErr    (9);
      uPort9SoftError      <= uPortSoftErr    (9);
      uPort9ChannelUp      <= uPortChannelUp  (9);
      uPort9SysResetOut    <= uPortSysResetOut(9);
      uPort9MmcmNotLockOut <= uPortMmcmNotLocked(9);
      uPort9LaneUp         <= uPortLaneUp(9);
    end if;
  end process;

  -- Sample Port10 Status Signals
  process(aResetSl, UserClkPort(10))
  begin
    if aResetSl = '1' then
      uPort10HardError      <= '0';
      uPort10SoftError      <= '0';
      uPort10ChannelUp      <= '0';
      uPort10SysResetOut    <= '1';
      uPort10MmcmNotLockOut <= '1';
      uPort10LaneUp         <= (others => '0');
    elsif rising_edge(UserClkPort(10)) then
      uPort10HardError      <= uPortHardErr    (10);
      uPort10SoftError      <= uPortSoftErr    (10);
      uPort10ChannelUp      <= uPortChannelUp  (10);
      uPort10SysResetOut    <= uPortSysResetOut(10);
      uPort10MmcmNotLockOut <= uPortMmcmNotLocked(10);
      uPort10LaneUp         <= uPortLaneUp(10);
    end if;
  end process;

  -- Sample Port11 Status Signals
  process(aResetSl, UserClkPort(11))
  begin
    if aResetSl = '1' then
      uPort11HardError      <= '0';
      uPort11SoftError      <= '0';
      uPort11ChannelUp      <= '0';
      uPort11SysResetOut    <= '1';
      uPort11MmcmNotLockOut <= '1';
      uPort11LaneUp         <= (others => '0');
    elsif rising_edge(UserClkPort(11)) then
      uPort11HardError      <= uPortHardErr    (11);
      uPort11SoftError      <= uPortSoftErr    (11);
      uPort11ChannelUp      <= uPortChannelUp  (11);
      uPort11SysResetOut    <= uPortSysResetOut(11);
      uPort11MmcmNotLockOut <= uPortMmcmNotLocked(11);
      uPort11LaneUp         <= uPortLaneUp(11);
    end if;
  end process;


  ---------------------------------------------------------
  -- Linke Reset Out
  ---------------------------------------------------------
  process(aResetSl, InitClk)
  begin
    if aResetSl = '1' then
      iPort0LinkResetOut <= '1';
      iPort1LinkResetOut <= '1';
      iPort2LinkResetOut <= '1';
      iPort3LinkResetOut <= '1';
      iPort4LinkResetOut <= '1';
      iPort5LinkResetOut <= '1';
      iPort6LinkResetOut <= '1';
      iPort7LinkResetOut <= '1';
      iPort8LinkResetOut <= '1';
      iPort9LinkResetOut <= '1';
      iPort10LinkResetOut <= '1';
      iPort11LinkResetOut <= '1';
    elsif rising_edge(InitClk) then
      iPort0LinkResetOut <= iPortLinkResetOut (0);
      iPort1LinkResetOut <= iPortLinkResetOut (1);
      iPort2LinkResetOut <= iPortLinkResetOut (2);
      iPort3LinkResetOut <= iPortLinkResetOut (3);
      iPort4LinkResetOut <= iPortLinkResetOut (4);
      iPort5LinkResetOut <= iPortLinkResetOut (5);
      iPort6LinkResetOut <= iPortLinkResetOut (6);
      iPort7LinkResetOut <= iPortLinkResetOut (7);
      iPort8LinkResetOut <= iPortLinkResetOut (8);
      iPort9LinkResetOut <= iPortLinkResetOut (9);
      iPort10LinkResetOut <= iPortLinkResetOut (10);
      iPort11LinkResetOut <= iPortLinkResetOut (11);
    end if;
  end process;

  ---------------------------------------------------------
  -- Aurora AXI4-Lite to Channel DRP Interface
  ---------------------------------------------------------
  AxiToDrpBlock : block
  begin

    -- Connect Port0 AXI-Lite
    sGtwizDrpChAxiAWaddr(0) <= sGtwiz0DrpChAxiAWAddr;
    sGtwizDrpChAxiAWValid(0) <= sGtwiz0DrpChAxiAWValid;
    sGtwiz0DrpChAxiAWReady <= sGtwizDrpChAxiAWReady(0);
    sGtwizDrpChAxiWData(0) <= sGtwiz0DrpChAxiWData;
    sGtwizDrpChAxiWStrb(0) <= sGtwiz0DrpChAxiWStrb;
    sGtwizDrpChAxiWValid(0) <= sGtwiz0DrpChAxiWValid;
    sGtwiz0DrpChAxiWReady <= sGtwizDrpChAxiWReady(0);
    sGtwiz0DrpChAxiBResp <= sGtwizDrpChAxiBResp(0);
    sGtwiz0DrpChAxiBValid <= sGtwizDrpChAxiBValid(0);
    sGtwizDrpChAxiBReady(0) <= sGtwiz0DrpChAxiBReady;
    sGtwizDrpChAxiARAddr(0) <= sGtwiz0DrpChAxiARAddr;
    sGtwizDrpChAxiARValid(0) <= sGtwiz0DrpChAxiARValid;
    sGtwiz0DrpChAxiARReady <= sGtwizDrpChAxiARReady(0);
    sGtwiz0DrpChAxiRData <= sGtwizDrpChAxiRData(0);
    sGtwiz0DrpChAxiRResp <= sGtwizDrpChAxiRResp(0);
    sGtwiz0DrpChAxiRValid <= sGtwizDrpChAxiRValid(0);
    sGtwizDrpChAxiRReady(0) <= sGtwiz0DrpChAxiRReady;

    -- Connect Port1 AXI-Lite
    sGtwizDrpChAxiAWaddr(1) <= sGtwiz1DrpChAxiAWAddr;
    sGtwizDrpChAxiAWValid(1) <= sGtwiz1DrpChAxiAWValid;
    sGtwiz1DrpChAxiAWReady <= sGtwizDrpChAxiAWReady(1);
    sGtwizDrpChAxiWData(1) <= sGtwiz1DrpChAxiWData;
    sGtwizDrpChAxiWStrb(1) <= sGtwiz1DrpChAxiWStrb;
    sGtwizDrpChAxiWValid(1) <= sGtwiz1DrpChAxiWValid;
    sGtwiz1DrpChAxiWReady <= sGtwizDrpChAxiWReady(1);
    sGtwiz1DrpChAxiBResp <= sGtwizDrpChAxiBResp(1);
    sGtwiz1DrpChAxiBValid <= sGtwizDrpChAxiBValid(1);
    sGtwizDrpChAxiBReady(1) <= sGtwiz1DrpChAxiBReady;
    sGtwizDrpChAxiARAddr(1) <= sGtwiz1DrpChAxiARAddr;
    sGtwizDrpChAxiARValid(1) <= sGtwiz1DrpChAxiARValid;
    sGtwiz1DrpChAxiARReady <= sGtwizDrpChAxiARReady(1);
    sGtwiz1DrpChAxiRData <= sGtwizDrpChAxiRData(1);
    sGtwiz1DrpChAxiRResp <= sGtwizDrpChAxiRResp(1);
    sGtwiz1DrpChAxiRValid <= sGtwizDrpChAxiRValid(1);
    sGtwizDrpChAxiRReady(1) <= sGtwiz1DrpChAxiRReady;

    -- Connect Port2 AXI-Lite
    sGtwizDrpChAxiAWaddr(2) <= sGtwiz2DrpChAxiAWAddr;
    sGtwizDrpChAxiAWValid(2) <= sGtwiz2DrpChAxiAWValid;
    sGtwiz2DrpChAxiAWReady <= sGtwizDrpChAxiAWReady(2);
    sGtwizDrpChAxiWData(2) <= sGtwiz2DrpChAxiWData;
    sGtwizDrpChAxiWStrb(2) <= sGtwiz2DrpChAxiWStrb;
    sGtwizDrpChAxiWValid(2) <= sGtwiz2DrpChAxiWValid;
    sGtwiz2DrpChAxiWReady <= sGtwizDrpChAxiWReady(2);
    sGtwiz2DrpChAxiBResp <= sGtwizDrpChAxiBResp(2);
    sGtwiz2DrpChAxiBValid <= sGtwizDrpChAxiBValid(2);
    sGtwizDrpChAxiBReady(2) <= sGtwiz2DrpChAxiBReady;
    sGtwizDrpChAxiARAddr(2) <= sGtwiz2DrpChAxiARAddr;
    sGtwizDrpChAxiARValid(2) <= sGtwiz2DrpChAxiARValid;
    sGtwiz2DrpChAxiARReady <= sGtwizDrpChAxiARReady(2);
    sGtwiz2DrpChAxiRData <= sGtwizDrpChAxiRData(2);
    sGtwiz2DrpChAxiRResp <= sGtwizDrpChAxiRResp(2);
    sGtwiz2DrpChAxiRValid <= sGtwizDrpChAxiRValid(2);
    sGtwizDrpChAxiRReady(2) <= sGtwiz2DrpChAxiRReady;

    -- Connect Port3 AXI-Lite
    sGtwizDrpChAxiAWaddr(3) <= sGtwiz3DrpChAxiAWAddr;
    sGtwizDrpChAxiAWValid(3) <= sGtwiz3DrpChAxiAWValid;
    sGtwiz3DrpChAxiAWReady <= sGtwizDrpChAxiAWReady(3);
    sGtwizDrpChAxiWData(3) <= sGtwiz3DrpChAxiWData;
    sGtwizDrpChAxiWStrb(3) <= sGtwiz3DrpChAxiWStrb;
    sGtwizDrpChAxiWValid(3) <= sGtwiz3DrpChAxiWValid;
    sGtwiz3DrpChAxiWReady <= sGtwizDrpChAxiWReady(3);
    sGtwiz3DrpChAxiBResp <= sGtwizDrpChAxiBResp(3);
    sGtwiz3DrpChAxiBValid <= sGtwizDrpChAxiBValid(3);
    sGtwizDrpChAxiBReady(3) <= sGtwiz3DrpChAxiBReady;
    sGtwizDrpChAxiARAddr(3) <= sGtwiz3DrpChAxiARAddr;
    sGtwizDrpChAxiARValid(3) <= sGtwiz3DrpChAxiARValid;
    sGtwiz3DrpChAxiARReady <= sGtwizDrpChAxiARReady(3);
    sGtwiz3DrpChAxiRData <= sGtwizDrpChAxiRData(3);
    sGtwiz3DrpChAxiRResp <= sGtwizDrpChAxiRResp(3);
    sGtwiz3DrpChAxiRValid <= sGtwizDrpChAxiRValid(3);
    sGtwizDrpChAxiRReady(3) <= sGtwiz3DrpChAxiRReady;

    -- Connect Port4 AXI-Lite
    sGtwizDrpChAxiAWaddr(4) <= sGtwiz4DrpChAxiAWAddr;
    sGtwizDrpChAxiAWValid(4) <= sGtwiz4DrpChAxiAWValid;
    sGtwiz4DrpChAxiAWReady <= sGtwizDrpChAxiAWReady(4);
    sGtwizDrpChAxiWData(4) <= sGtwiz4DrpChAxiWData;
    sGtwizDrpChAxiWStrb(4) <= sGtwiz4DrpChAxiWStrb;
    sGtwizDrpChAxiWValid(4) <= sGtwiz4DrpChAxiWValid;
    sGtwiz4DrpChAxiWReady <= sGtwizDrpChAxiWReady(4);
    sGtwiz4DrpChAxiBResp <= sGtwizDrpChAxiBResp(4);
    sGtwiz4DrpChAxiBValid <= sGtwizDrpChAxiBValid(4);
    sGtwizDrpChAxiBReady(4) <= sGtwiz4DrpChAxiBReady;
    sGtwizDrpChAxiARAddr(4) <= sGtwiz4DrpChAxiARAddr;
    sGtwizDrpChAxiARValid(4) <= sGtwiz4DrpChAxiARValid;
    sGtwiz4DrpChAxiARReady <= sGtwizDrpChAxiARReady(4);
    sGtwiz4DrpChAxiRData <= sGtwizDrpChAxiRData(4);
    sGtwiz4DrpChAxiRResp <= sGtwizDrpChAxiRResp(4);
    sGtwiz4DrpChAxiRValid <= sGtwizDrpChAxiRValid(4);
    sGtwizDrpChAxiRReady(4) <= sGtwiz4DrpChAxiRReady;

    -- Connect Port5 AXI-Lite
    sGtwizDrpChAxiAWaddr(5) <= sGtwiz5DrpChAxiAWAddr;
    sGtwizDrpChAxiAWValid(5) <= sGtwiz5DrpChAxiAWValid;
    sGtwiz5DrpChAxiAWReady <= sGtwizDrpChAxiAWReady(5);
    sGtwizDrpChAxiWData(5) <= sGtwiz5DrpChAxiWData;
    sGtwizDrpChAxiWStrb(5) <= sGtwiz5DrpChAxiWStrb;
    sGtwizDrpChAxiWValid(5) <= sGtwiz5DrpChAxiWValid;
    sGtwiz5DrpChAxiWReady <= sGtwizDrpChAxiWReady(5);
    sGtwiz5DrpChAxiBResp <= sGtwizDrpChAxiBResp(5);
    sGtwiz5DrpChAxiBValid <= sGtwizDrpChAxiBValid(5);
    sGtwizDrpChAxiBReady(5) <= sGtwiz5DrpChAxiBReady;
    sGtwizDrpChAxiARAddr(5) <= sGtwiz5DrpChAxiARAddr;
    sGtwizDrpChAxiARValid(5) <= sGtwiz5DrpChAxiARValid;
    sGtwiz5DrpChAxiARReady <= sGtwizDrpChAxiARReady(5);
    sGtwiz5DrpChAxiRData <= sGtwizDrpChAxiRData(5);
    sGtwiz5DrpChAxiRResp <= sGtwizDrpChAxiRResp(5);
    sGtwiz5DrpChAxiRValid <= sGtwizDrpChAxiRValid(5);
    sGtwizDrpChAxiRReady(5) <= sGtwiz5DrpChAxiRReady;

    -- Connect Port6 AXI-Lite
    sGtwizDrpChAxiAWaddr(6) <= sGtwiz6DrpChAxiAWAddr;
    sGtwizDrpChAxiAWValid(6) <= sGtwiz6DrpChAxiAWValid;
    sGtwiz6DrpChAxiAWReady <= sGtwizDrpChAxiAWReady(6);
    sGtwizDrpChAxiWData(6) <= sGtwiz6DrpChAxiWData;
    sGtwizDrpChAxiWStrb(6) <= sGtwiz6DrpChAxiWStrb;
    sGtwizDrpChAxiWValid(6) <= sGtwiz6DrpChAxiWValid;
    sGtwiz6DrpChAxiWReady <= sGtwizDrpChAxiWReady(6);
    sGtwiz6DrpChAxiBResp <= sGtwizDrpChAxiBResp(6);
    sGtwiz6DrpChAxiBValid <= sGtwizDrpChAxiBValid(6);
    sGtwizDrpChAxiBReady(6) <= sGtwiz6DrpChAxiBReady;
    sGtwizDrpChAxiARAddr(6) <= sGtwiz6DrpChAxiARAddr;
    sGtwizDrpChAxiARValid(6) <= sGtwiz6DrpChAxiARValid;
    sGtwiz6DrpChAxiARReady <= sGtwizDrpChAxiARReady(6);
    sGtwiz6DrpChAxiRData <= sGtwizDrpChAxiRData(6);
    sGtwiz6DrpChAxiRResp <= sGtwizDrpChAxiRResp(6);
    sGtwiz6DrpChAxiRValid <= sGtwizDrpChAxiRValid(6);
    sGtwizDrpChAxiRReady(6) <= sGtwiz6DrpChAxiRReady;

    -- Connect Port7 AXI-Lite
    sGtwizDrpChAxiAWaddr(7) <= sGtwiz7DrpChAxiAWAddr;
    sGtwizDrpChAxiAWValid(7) <= sGtwiz7DrpChAxiAWValid;
    sGtwiz7DrpChAxiAWReady <= sGtwizDrpChAxiAWReady(7);
    sGtwizDrpChAxiWData(7) <= sGtwiz7DrpChAxiWData;
    sGtwizDrpChAxiWStrb(7) <= sGtwiz7DrpChAxiWStrb;
    sGtwizDrpChAxiWValid(7) <= sGtwiz7DrpChAxiWValid;
    sGtwiz7DrpChAxiWReady <= sGtwizDrpChAxiWReady(7);
    sGtwiz7DrpChAxiBResp <= sGtwizDrpChAxiBResp(7);
    sGtwiz7DrpChAxiBValid <= sGtwizDrpChAxiBValid(7);
    sGtwizDrpChAxiBReady(7) <= sGtwiz7DrpChAxiBReady;
    sGtwizDrpChAxiARAddr(7) <= sGtwiz7DrpChAxiARAddr;
    sGtwizDrpChAxiARValid(7) <= sGtwiz7DrpChAxiARValid;
    sGtwiz7DrpChAxiARReady <= sGtwizDrpChAxiARReady(7);
    sGtwiz7DrpChAxiRData <= sGtwizDrpChAxiRData(7);
    sGtwiz7DrpChAxiRResp <= sGtwizDrpChAxiRResp(7);
    sGtwiz7DrpChAxiRValid <= sGtwizDrpChAxiRValid(7);
    sGtwizDrpChAxiRReady(7) <= sGtwiz7DrpChAxiRReady;

    -- Connect Port8 AXI-Lite
    sGtwizDrpChAxiAWaddr(8) <= sGtwiz8DrpChAxiAWAddr;
    sGtwizDrpChAxiAWValid(8) <= sGtwiz8DrpChAxiAWValid;
    sGtwiz8DrpChAxiAWReady <= sGtwizDrpChAxiAWReady(8);
    sGtwizDrpChAxiWData(8) <= sGtwiz8DrpChAxiWData;
    sGtwizDrpChAxiWStrb(8) <= sGtwiz8DrpChAxiWStrb;
    sGtwizDrpChAxiWValid(8) <= sGtwiz8DrpChAxiWValid;
    sGtwiz8DrpChAxiWReady <= sGtwizDrpChAxiWReady(8);
    sGtwiz8DrpChAxiBResp <= sGtwizDrpChAxiBResp(8);
    sGtwiz8DrpChAxiBValid <= sGtwizDrpChAxiBValid(8);
    sGtwizDrpChAxiBReady(8) <= sGtwiz8DrpChAxiBReady;
    sGtwizDrpChAxiARAddr(8) <= sGtwiz8DrpChAxiARAddr;
    sGtwizDrpChAxiARValid(8) <= sGtwiz8DrpChAxiARValid;
    sGtwiz8DrpChAxiARReady <= sGtwizDrpChAxiARReady(8);
    sGtwiz8DrpChAxiRData <= sGtwizDrpChAxiRData(8);
    sGtwiz8DrpChAxiRResp <= sGtwizDrpChAxiRResp(8);
    sGtwiz8DrpChAxiRValid <= sGtwizDrpChAxiRValid(8);
    sGtwizDrpChAxiRReady(8) <= sGtwiz8DrpChAxiRReady;

    -- Connect Port9 AXI-Lite
    sGtwizDrpChAxiAWaddr(9) <= sGtwiz9DrpChAxiAWAddr;
    sGtwizDrpChAxiAWValid(9) <= sGtwiz9DrpChAxiAWValid;
    sGtwiz9DrpChAxiAWReady <= sGtwizDrpChAxiAWReady(9);
    sGtwizDrpChAxiWData(9) <= sGtwiz9DrpChAxiWData;
    sGtwizDrpChAxiWStrb(9) <= sGtwiz9DrpChAxiWStrb;
    sGtwizDrpChAxiWValid(9) <= sGtwiz9DrpChAxiWValid;
    sGtwiz9DrpChAxiWReady <= sGtwizDrpChAxiWReady(9);
    sGtwiz9DrpChAxiBResp <= sGtwizDrpChAxiBResp(9);
    sGtwiz9DrpChAxiBValid <= sGtwizDrpChAxiBValid(9);
    sGtwizDrpChAxiBReady(9) <= sGtwiz9DrpChAxiBReady;
    sGtwizDrpChAxiARAddr(9) <= sGtwiz9DrpChAxiARAddr;
    sGtwizDrpChAxiARValid(9) <= sGtwiz9DrpChAxiARValid;
    sGtwiz9DrpChAxiARReady <= sGtwizDrpChAxiARReady(9);
    sGtwiz9DrpChAxiRData <= sGtwizDrpChAxiRData(9);
    sGtwiz9DrpChAxiRResp <= sGtwizDrpChAxiRResp(9);
    sGtwiz9DrpChAxiRValid <= sGtwizDrpChAxiRValid(9);
    sGtwizDrpChAxiRReady(9) <= sGtwiz9DrpChAxiRReady;

    -- Connect Port10 AXI-Lite
    sGtwizDrpChAxiAWaddr(10) <= sGtwiz10DrpChAxiAWAddr;
    sGtwizDrpChAxiAWValid(10) <= sGtwiz10DrpChAxiAWValid;
    sGtwiz10DrpChAxiAWReady <= sGtwizDrpChAxiAWReady(10);
    sGtwizDrpChAxiWData(10) <= sGtwiz10DrpChAxiWData;
    sGtwizDrpChAxiWStrb(10) <= sGtwiz10DrpChAxiWStrb;
    sGtwizDrpChAxiWValid(10) <= sGtwiz10DrpChAxiWValid;
    sGtwiz10DrpChAxiWReady <= sGtwizDrpChAxiWReady(10);
    sGtwiz10DrpChAxiBResp <= sGtwizDrpChAxiBResp(10);
    sGtwiz10DrpChAxiBValid <= sGtwizDrpChAxiBValid(10);
    sGtwizDrpChAxiBReady(10) <= sGtwiz10DrpChAxiBReady;
    sGtwizDrpChAxiARAddr(10) <= sGtwiz10DrpChAxiARAddr;
    sGtwizDrpChAxiARValid(10) <= sGtwiz10DrpChAxiARValid;
    sGtwiz10DrpChAxiARReady <= sGtwizDrpChAxiARReady(10);
    sGtwiz10DrpChAxiRData <= sGtwizDrpChAxiRData(10);
    sGtwiz10DrpChAxiRResp <= sGtwizDrpChAxiRResp(10);
    sGtwiz10DrpChAxiRValid <= sGtwizDrpChAxiRValid(10);
    sGtwizDrpChAxiRReady(10) <= sGtwiz10DrpChAxiRReady;

    -- Connect Port11 AXI-Lite
    sGtwizDrpChAxiAWaddr(11) <= sGtwiz11DrpChAxiAWAddr;
    sGtwizDrpChAxiAWValid(11) <= sGtwiz11DrpChAxiAWValid;
    sGtwiz11DrpChAxiAWReady <= sGtwizDrpChAxiAWReady(11);
    sGtwizDrpChAxiWData(11) <= sGtwiz11DrpChAxiWData;
    sGtwizDrpChAxiWStrb(11) <= sGtwiz11DrpChAxiWStrb;
    sGtwizDrpChAxiWValid(11) <= sGtwiz11DrpChAxiWValid;
    sGtwiz11DrpChAxiWReady <= sGtwizDrpChAxiWReady(11);
    sGtwiz11DrpChAxiBResp <= sGtwizDrpChAxiBResp(11);
    sGtwiz11DrpChAxiBValid <= sGtwizDrpChAxiBValid(11);
    sGtwizDrpChAxiBReady(11) <= sGtwiz11DrpChAxiBReady;
    sGtwizDrpChAxiARAddr(11) <= sGtwiz11DrpChAxiARAddr;
    sGtwizDrpChAxiARValid(11) <= sGtwiz11DrpChAxiARValid;
    sGtwiz11DrpChAxiARReady <= sGtwizDrpChAxiARReady(11);
    sGtwiz11DrpChAxiRData <= sGtwizDrpChAxiRData(11);
    sGtwiz11DrpChAxiRResp <= sGtwizDrpChAxiRResp(11);
    sGtwiz11DrpChAxiRValid <= sGtwizDrpChAxiRValid(11);
    sGtwizDrpChAxiRReady(11) <= sGtwiz11DrpChAxiRReady;



    GenAxiToDrp : for i in 0 to kNumPorts-1 generate
      --vhook AxiLiteToMgtDrp AxiLiteToMgtDrpPortN
      --vhook_a {sAxi(.*)} sGtwizDrpChAxi$1(i)
      --vhook_a {sAxi(.*)} sGtwizDrpChAxi$1(i)
      --vhook_a SAxiAClk SAClk
      --vhook_a iGtwizDrpClk     open
      --vhook_a iGtwizDrpAddrIn  iGtwizDrpAddrIn((i+1)*kNumLanes*kAddrSize-1 downto i*kNumLanes*kAddrSize)
      --vhook_a iGtwizDrpDiIn    iGtwizDrpDiIn  ((i+1)*kNumLanes*16-1 downto i*kNumLanes*16)
      --vhook_a iGtwizDrpDoOut   iGtwizDrpDoOut ((i+1)*kNumLanes*16-1 downto i*kNumLanes*16)
      --vhook_a iGtwizDrpEnIn    iGtwizDrpEnIn  ((i+1)*kNumLanes-1    downto i*kNumLanes)
      --vhook_a iGtwizDrpWeIn    iGtwizDrpWeIn  ((i+1)*kNumLanes-1    downto i*kNumLanes)
      --vhook_a iGtwizDrpRdyOut  iGtwizDrpRdyOut((i+1)*kNumLanes-1    downto i*kNumLanes)
      AxiLiteToMgtDrpPortN: AxiLiteToMgtDrp
        generic map (
          kNumLanes => kNumLanes,  --integer:=4
          kAddrSize => kAddrSize)  --integer:=10
        port map (
          aResetSl        => aResetSl,                                                                   --in  std_logic
          SAxiAClk        => SAClk,                                                                      --in  std_logic
          sAxiAWaddr      => sGtwizDrpChAxiAWaddr(i),                                                    --in  std_logic_vector(31:0)
          sAxiAWValid     => sGtwizDrpChAxiAWValid(i),                                                   --in  std_logic
          sAxiAWReady     => sGtwizDrpChAxiAWReady(i),                                                   --out std_logic
          sAxiWData       => sGtwizDrpChAxiWData(i),                                                     --in  std_logic_vector(31:0)
          sAxiWStrb       => sGtwizDrpChAxiWStrb(i),                                                     --in  std_logic_vector(3:0)
          sAxiWValid      => sGtwizDrpChAxiWValid(i),                                                    --in  std_logic
          sAxiWReady      => sGtwizDrpChAxiWReady(i),                                                    --out std_logic
          sAxiBResp       => sGtwizDrpChAxiBResp(i),                                                     --out std_logic_vector(1:0)
          sAxiBValid      => sGtwizDrpChAxiBValid(i),                                                    --out std_logic
          sAxiBReady      => sGtwizDrpChAxiBReady(i),                                                    --in  std_logic
          sAxiARAddr      => sGtwizDrpChAxiARAddr(i),                                                    --in  std_logic_vector(31:0)
          sAxiARValid     => sGtwizDrpChAxiARValid(i),                                                   --in  std_logic
          sAxiARReady     => sGtwizDrpChAxiARReady(i),                                                   --out std_logic
          sAxiRData       => sGtwizDrpChAxiRData(i),                                                     --out std_logic_vector(31:0)
          sAxiRResp       => sGtwizDrpChAxiRResp(i),                                                     --out std_logic_vector(1:0)
          sAxiRValid      => sGtwizDrpChAxiRValid(i),                                                    --out std_logic
          sAxiRReady      => sGtwizDrpChAxiRReady(i),                                                    --in  std_logic
          InitClk         => InitClk,                                                                    --in  std_logic
          iGtwizDrpClk    => open,                                                                       --out std_logic_vector(kNumLanes-1:0)
          iGtwizDrpAddrIn => iGtwizDrpAddrIn((i+1)*kNumLanes*kAddrSize-1 downto i*kNumLanes*kAddrSize),  --out std_logic_vector(kNumLanes*kAddrSize-1:0)
          iGtwizDrpDiIn   => iGtwizDrpDiIn ((i+1)*kNumLanes*16-1 downto i*kNumLanes*16),                 --out std_logic_vector(kNumLanes*16-1:0)
          iGtwizDrpDoOut  => iGtwizDrpDoOut ((i+1)*kNumLanes*16-1 downto i*kNumLanes*16),                --in  std_logic_vector(kNumLanes*16-1:0)
          iGtwizDrpEnIn   => iGtwizDrpEnIn ((i+1)*kNumLanes-1 downto i*kNumLanes),                       --out std_logic_vector(kNumLanes-1:0)
          iGtwizDrpWeIn   => iGtwizDrpWeIn ((i+1)*kNumLanes-1 downto i*kNumLanes),                       --out std_logic_vector(kNumLanes-1:0)
          iGtwizDrpRdyOut => iGtwizDrpRdyOut((i+1)*kNumLanes-1 downto i*kNumLanes));                     --in  std_logic_vector(kNumLanes-1:0)

    end generate;
  end block AxiToDrpBlock;

  ---------------------------------------------------------
  -- Aurora AXI4-Lite to Ctrl Register Interface
  ---------------------------------------------------------
  -- Fill in AXI Port0 records with top level signals.
  sAxiMasterWritePort(0).Address   <= unsigned(sGtwiz0CtrlAxiAWAddr);
  sAxiMasterWritePort(0).AddrValid <= sGtwiz0CtrlAxiAWValid = '1';
  sAxiMasterWritePort(0).Data      <= sGtwiz0CtrlAxiWData;
  sAxiMasterWritePort(0).DataStrb  <= sGtwiz0CtrlAxiWStrb;
  sAxiMasterWritePort(0).DataValid <= sGtwiz0CtrlAxiWValid = '1';
  sAxiMasterWritePort(0).Ready     <= sGtwiz0CtrlAxiBReady = '1';

  sGtwiz0CtrlAxiAWReady <= to_StdLogic(sAxiSlaveWritePort(0).AddrReady);
  sGtwiz0CtrlAxiWReady  <= to_StdLogic(sAxiSlaveWritePort(0).DataReady);
  sGtwiz0CtrlAxiBResp   <= sAxiSlaveWritePort(0).Response;
  sGtwiz0CtrlAxiBValid  <= to_StdLogic(sAxiSlaveWritePort(0).RespValid);

  sAxiMasterReadPort(0).Address   <= unsigned(sGtwiz0CtrlAxiARAddr);
  sAxiMasterReadPort(0).AddrValid <= sGtwiz0CtrlAxiARValid = '1';
  sAxiMasterReadPort(0).Ready     <= sGtwiz0CtrlAxiRReady = '1';

  sGtwiz0CtrlAxiARReady <= to_StdLogic(sAxiSlaveReadPort(0).AddrReady);
  sGtwiz0CtrlAxiRData   <= sAxiSlaveReadPort(0).Data;
  sGtwiz0CtrlAxiRResp   <= sAxiSlaveReadPort(0).Response;
  sGtwiz0CtrlAxiRValid  <= to_StdLogic(sAxiSlaveReadPort(0).DataValid);

  -- Fill in AXI Port1 records with top level signals.
  sAxiMasterWritePort(1).Address   <= unsigned(sGtwiz1CtrlAxiAWAddr);
  sAxiMasterWritePort(1).AddrValid <= sGtwiz1CtrlAxiAWValid = '1';
  sAxiMasterWritePort(1).Data      <= sGtwiz1CtrlAxiWData;
  sAxiMasterWritePort(1).DataStrb  <= sGtwiz1CtrlAxiWStrb;
  sAxiMasterWritePort(1).DataValid <= sGtwiz1CtrlAxiWValid = '1';
  sAxiMasterWritePort(1).Ready     <= sGtwiz1CtrlAxiBReady = '1';

  sGtwiz1CtrlAxiAWReady <= to_StdLogic(sAxiSlaveWritePort(1).AddrReady);
  sGtwiz1CtrlAxiWReady  <= to_StdLogic(sAxiSlaveWritePort(1).DataReady);
  sGtwiz1CtrlAxiBResp   <= sAxiSlaveWritePort(1).Response;
  sGtwiz1CtrlAxiBValid  <= to_StdLogic(sAxiSlaveWritePort(1).RespValid);

  sAxiMasterReadPort(1).Address   <= unsigned(sGtwiz1CtrlAxiARAddr);
  sAxiMasterReadPort(1).AddrValid <= sGtwiz1CtrlAxiARValid = '1';
  sAxiMasterReadPort(1).Ready     <= sGtwiz1CtrlAxiRReady = '1';

  sGtwiz1CtrlAxiARReady <= to_StdLogic(sAxiSlaveReadPort(1).AddrReady);
  sGtwiz1CtrlAxiRData   <= sAxiSlaveReadPort(1).Data;
  sGtwiz1CtrlAxiRResp   <= sAxiSlaveReadPort(1).Response;
  sGtwiz1CtrlAxiRValid  <= to_StdLogic(sAxiSlaveReadPort(1).DataValid);

  -- Fill in AXI Port2 records with top level signals.
  sAxiMasterWritePort(2).Address   <= unsigned(sGtwiz2CtrlAxiAWAddr);
  sAxiMasterWritePort(2).AddrValid <= sGtwiz2CtrlAxiAWValid = '1';
  sAxiMasterWritePort(2).Data      <= sGtwiz2CtrlAxiWData;
  sAxiMasterWritePort(2).DataStrb  <= sGtwiz2CtrlAxiWStrb;
  sAxiMasterWritePort(2).DataValid <= sGtwiz2CtrlAxiWValid = '1';
  sAxiMasterWritePort(2).Ready     <= sGtwiz2CtrlAxiBReady = '1';

  sGtwiz2CtrlAxiAWReady <= to_StdLogic(sAxiSlaveWritePort(2).AddrReady);
  sGtwiz2CtrlAxiWReady  <= to_StdLogic(sAxiSlaveWritePort(2).DataReady);
  sGtwiz2CtrlAxiBResp   <= sAxiSlaveWritePort(2).Response;
  sGtwiz2CtrlAxiBValid  <= to_StdLogic(sAxiSlaveWritePort(2).RespValid);

  sAxiMasterReadPort(2).Address   <= unsigned(sGtwiz2CtrlAxiARAddr);
  sAxiMasterReadPort(2).AddrValid <= sGtwiz2CtrlAxiARValid = '1';
  sAxiMasterReadPort(2).Ready     <= sGtwiz2CtrlAxiRReady = '1';

  sGtwiz2CtrlAxiARReady <= to_StdLogic(sAxiSlaveReadPort(2).AddrReady);
  sGtwiz2CtrlAxiRData   <= sAxiSlaveReadPort(2).Data;
  sGtwiz2CtrlAxiRResp   <= sAxiSlaveReadPort(2).Response;
  sGtwiz2CtrlAxiRValid  <= to_StdLogic(sAxiSlaveReadPort(2).DataValid);

  -- Fill in AXI Port3 records with top level signals.
  sAxiMasterWritePort(3).Address   <= unsigned(sGtwiz3CtrlAxiAWAddr);
  sAxiMasterWritePort(3).AddrValid <= sGtwiz3CtrlAxiAWValid = '1';
  sAxiMasterWritePort(3).Data      <= sGtwiz3CtrlAxiWData;
  sAxiMasterWritePort(3).DataStrb  <= sGtwiz3CtrlAxiWStrb;
  sAxiMasterWritePort(3).DataValid <= sGtwiz3CtrlAxiWValid = '1';
  sAxiMasterWritePort(3).Ready     <= sGtwiz3CtrlAxiBReady = '1';

  sGtwiz3CtrlAxiAWReady <= to_StdLogic(sAxiSlaveWritePort(3).AddrReady);
  sGtwiz3CtrlAxiWReady  <= to_StdLogic(sAxiSlaveWritePort(3).DataReady);
  sGtwiz3CtrlAxiBResp   <= sAxiSlaveWritePort(3).Response;
  sGtwiz3CtrlAxiBValid  <= to_StdLogic(sAxiSlaveWritePort(3).RespValid);

  sAxiMasterReadPort(3).Address   <= unsigned(sGtwiz3CtrlAxiARAddr);
  sAxiMasterReadPort(3).AddrValid <= sGtwiz3CtrlAxiARValid = '1';
  sAxiMasterReadPort(3).Ready     <= sGtwiz3CtrlAxiRReady = '1';

  sGtwiz3CtrlAxiARReady <= to_StdLogic(sAxiSlaveReadPort(3).AddrReady);
  sGtwiz3CtrlAxiRData   <= sAxiSlaveReadPort(3).Data;
  sGtwiz3CtrlAxiRResp   <= sAxiSlaveReadPort(3).Response;
  sGtwiz3CtrlAxiRValid  <= to_StdLogic(sAxiSlaveReadPort(3).DataValid);

  -- Fill in AXI Port4 records with top level signals.
  sAxiMasterWritePort(4).Address   <= unsigned(sGtwiz4CtrlAxiAWAddr);
  sAxiMasterWritePort(4).AddrValid <= sGtwiz4CtrlAxiAWValid = '1';
  sAxiMasterWritePort(4).Data      <= sGtwiz4CtrlAxiWData;
  sAxiMasterWritePort(4).DataStrb  <= sGtwiz4CtrlAxiWStrb;
  sAxiMasterWritePort(4).DataValid <= sGtwiz4CtrlAxiWValid = '1';
  sAxiMasterWritePort(4).Ready     <= sGtwiz4CtrlAxiBReady = '1';

  sGtwiz4CtrlAxiAWReady <= to_StdLogic(sAxiSlaveWritePort(4).AddrReady);
  sGtwiz4CtrlAxiWReady  <= to_StdLogic(sAxiSlaveWritePort(4).DataReady);
  sGtwiz4CtrlAxiBResp   <= sAxiSlaveWritePort(4).Response;
  sGtwiz4CtrlAxiBValid  <= to_StdLogic(sAxiSlaveWritePort(4).RespValid);

  sAxiMasterReadPort(4).Address   <= unsigned(sGtwiz4CtrlAxiARAddr);
  sAxiMasterReadPort(4).AddrValid <= sGtwiz4CtrlAxiARValid = '1';
  sAxiMasterReadPort(4).Ready     <= sGtwiz4CtrlAxiRReady = '1';

  sGtwiz4CtrlAxiARReady <= to_StdLogic(sAxiSlaveReadPort(4).AddrReady);
  sGtwiz4CtrlAxiRData   <= sAxiSlaveReadPort(4).Data;
  sGtwiz4CtrlAxiRResp   <= sAxiSlaveReadPort(4).Response;
  sGtwiz4CtrlAxiRValid  <= to_StdLogic(sAxiSlaveReadPort(4).DataValid);

  -- Fill in AXI Port5 records with top level signals.
  sAxiMasterWritePort(5).Address   <= unsigned(sGtwiz5CtrlAxiAWAddr);
  sAxiMasterWritePort(5).AddrValid <= sGtwiz5CtrlAxiAWValid = '1';
  sAxiMasterWritePort(5).Data      <= sGtwiz5CtrlAxiWData;
  sAxiMasterWritePort(5).DataStrb  <= sGtwiz5CtrlAxiWStrb;
  sAxiMasterWritePort(5).DataValid <= sGtwiz5CtrlAxiWValid = '1';
  sAxiMasterWritePort(5).Ready     <= sGtwiz5CtrlAxiBReady = '1';

  sGtwiz5CtrlAxiAWReady <= to_StdLogic(sAxiSlaveWritePort(5).AddrReady);
  sGtwiz5CtrlAxiWReady  <= to_StdLogic(sAxiSlaveWritePort(5).DataReady);
  sGtwiz5CtrlAxiBResp   <= sAxiSlaveWritePort(5).Response;
  sGtwiz5CtrlAxiBValid  <= to_StdLogic(sAxiSlaveWritePort(5).RespValid);

  sAxiMasterReadPort(5).Address   <= unsigned(sGtwiz5CtrlAxiARAddr);
  sAxiMasterReadPort(5).AddrValid <= sGtwiz5CtrlAxiARValid = '1';
  sAxiMasterReadPort(5).Ready     <= sGtwiz5CtrlAxiRReady = '1';

  sGtwiz5CtrlAxiARReady <= to_StdLogic(sAxiSlaveReadPort(5).AddrReady);
  sGtwiz5CtrlAxiRData   <= sAxiSlaveReadPort(5).Data;
  sGtwiz5CtrlAxiRResp   <= sAxiSlaveReadPort(5).Response;
  sGtwiz5CtrlAxiRValid  <= to_StdLogic(sAxiSlaveReadPort(5).DataValid);

  -- Fill in AXI Port6 records with top level signals.
  sAxiMasterWritePort(6).Address   <= unsigned(sGtwiz6CtrlAxiAWAddr);
  sAxiMasterWritePort(6).AddrValid <= sGtwiz6CtrlAxiAWValid = '1';
  sAxiMasterWritePort(6).Data      <= sGtwiz6CtrlAxiWData;
  sAxiMasterWritePort(6).DataStrb  <= sGtwiz6CtrlAxiWStrb;
  sAxiMasterWritePort(6).DataValid <= sGtwiz6CtrlAxiWValid = '1';
  sAxiMasterWritePort(6).Ready     <= sGtwiz6CtrlAxiBReady = '1';

  sGtwiz6CtrlAxiAWReady <= to_StdLogic(sAxiSlaveWritePort(6).AddrReady);
  sGtwiz6CtrlAxiWReady  <= to_StdLogic(sAxiSlaveWritePort(6).DataReady);
  sGtwiz6CtrlAxiBResp   <= sAxiSlaveWritePort(6).Response;
  sGtwiz6CtrlAxiBValid  <= to_StdLogic(sAxiSlaveWritePort(6).RespValid);

  sAxiMasterReadPort(6).Address   <= unsigned(sGtwiz6CtrlAxiARAddr);
  sAxiMasterReadPort(6).AddrValid <= sGtwiz6CtrlAxiARValid = '1';
  sAxiMasterReadPort(6).Ready     <= sGtwiz6CtrlAxiRReady = '1';

  sGtwiz6CtrlAxiARReady <= to_StdLogic(sAxiSlaveReadPort(6).AddrReady);
  sGtwiz6CtrlAxiRData   <= sAxiSlaveReadPort(6).Data;
  sGtwiz6CtrlAxiRResp   <= sAxiSlaveReadPort(6).Response;
  sGtwiz6CtrlAxiRValid  <= to_StdLogic(sAxiSlaveReadPort(6).DataValid);

  -- Fill in AXI Port7 records with top level signals.
  sAxiMasterWritePort(7).Address   <= unsigned(sGtwiz7CtrlAxiAWAddr);
  sAxiMasterWritePort(7).AddrValid <= sGtwiz7CtrlAxiAWValid = '1';
  sAxiMasterWritePort(7).Data      <= sGtwiz7CtrlAxiWData;
  sAxiMasterWritePort(7).DataStrb  <= sGtwiz7CtrlAxiWStrb;
  sAxiMasterWritePort(7).DataValid <= sGtwiz7CtrlAxiWValid = '1';
  sAxiMasterWritePort(7).Ready     <= sGtwiz7CtrlAxiBReady = '1';

  sGtwiz7CtrlAxiAWReady <= to_StdLogic(sAxiSlaveWritePort(7).AddrReady);
  sGtwiz7CtrlAxiWReady  <= to_StdLogic(sAxiSlaveWritePort(7).DataReady);
  sGtwiz7CtrlAxiBResp   <= sAxiSlaveWritePort(7).Response;
  sGtwiz7CtrlAxiBValid  <= to_StdLogic(sAxiSlaveWritePort(7).RespValid);

  sAxiMasterReadPort(7).Address   <= unsigned(sGtwiz7CtrlAxiARAddr);
  sAxiMasterReadPort(7).AddrValid <= sGtwiz7CtrlAxiARValid = '1';
  sAxiMasterReadPort(7).Ready     <= sGtwiz7CtrlAxiRReady = '1';

  sGtwiz7CtrlAxiARReady <= to_StdLogic(sAxiSlaveReadPort(7).AddrReady);
  sGtwiz7CtrlAxiRData   <= sAxiSlaveReadPort(7).Data;
  sGtwiz7CtrlAxiRResp   <= sAxiSlaveReadPort(7).Response;
  sGtwiz7CtrlAxiRValid  <= to_StdLogic(sAxiSlaveReadPort(7).DataValid);

  -- Fill in AXI Port8 records with top level signals.
  sAxiMasterWritePort(8).Address   <= unsigned(sGtwiz8CtrlAxiAWAddr);
  sAxiMasterWritePort(8).AddrValid <= sGtwiz8CtrlAxiAWValid = '1';
  sAxiMasterWritePort(8).Data      <= sGtwiz8CtrlAxiWData;
  sAxiMasterWritePort(8).DataStrb  <= sGtwiz8CtrlAxiWStrb;
  sAxiMasterWritePort(8).DataValid <= sGtwiz8CtrlAxiWValid = '1';
  sAxiMasterWritePort(8).Ready     <= sGtwiz8CtrlAxiBReady = '1';

  sGtwiz8CtrlAxiAWReady <= to_StdLogic(sAxiSlaveWritePort(8).AddrReady);
  sGtwiz8CtrlAxiWReady  <= to_StdLogic(sAxiSlaveWritePort(8).DataReady);
  sGtwiz8CtrlAxiBResp   <= sAxiSlaveWritePort(8).Response;
  sGtwiz8CtrlAxiBValid  <= to_StdLogic(sAxiSlaveWritePort(8).RespValid);

  sAxiMasterReadPort(8).Address   <= unsigned(sGtwiz8CtrlAxiARAddr);
  sAxiMasterReadPort(8).AddrValid <= sGtwiz8CtrlAxiARValid = '1';
  sAxiMasterReadPort(8).Ready     <= sGtwiz8CtrlAxiRReady = '1';

  sGtwiz8CtrlAxiARReady <= to_StdLogic(sAxiSlaveReadPort(8).AddrReady);
  sGtwiz8CtrlAxiRData   <= sAxiSlaveReadPort(8).Data;
  sGtwiz8CtrlAxiRResp   <= sAxiSlaveReadPort(8).Response;
  sGtwiz8CtrlAxiRValid  <= to_StdLogic(sAxiSlaveReadPort(8).DataValid);

  -- Fill in AXI Port9 records with top level signals.
  sAxiMasterWritePort(9).Address   <= unsigned(sGtwiz9CtrlAxiAWAddr);
  sAxiMasterWritePort(9).AddrValid <= sGtwiz9CtrlAxiAWValid = '1';
  sAxiMasterWritePort(9).Data      <= sGtwiz9CtrlAxiWData;
  sAxiMasterWritePort(9).DataStrb  <= sGtwiz9CtrlAxiWStrb;
  sAxiMasterWritePort(9).DataValid <= sGtwiz9CtrlAxiWValid = '1';
  sAxiMasterWritePort(9).Ready     <= sGtwiz9CtrlAxiBReady = '1';

  sGtwiz9CtrlAxiAWReady <= to_StdLogic(sAxiSlaveWritePort(9).AddrReady);
  sGtwiz9CtrlAxiWReady  <= to_StdLogic(sAxiSlaveWritePort(9).DataReady);
  sGtwiz9CtrlAxiBResp   <= sAxiSlaveWritePort(9).Response;
  sGtwiz9CtrlAxiBValid  <= to_StdLogic(sAxiSlaveWritePort(9).RespValid);

  sAxiMasterReadPort(9).Address   <= unsigned(sGtwiz9CtrlAxiARAddr);
  sAxiMasterReadPort(9).AddrValid <= sGtwiz9CtrlAxiARValid = '1';
  sAxiMasterReadPort(9).Ready     <= sGtwiz9CtrlAxiRReady = '1';

  sGtwiz9CtrlAxiARReady <= to_StdLogic(sAxiSlaveReadPort(9).AddrReady);
  sGtwiz9CtrlAxiRData   <= sAxiSlaveReadPort(9).Data;
  sGtwiz9CtrlAxiRResp   <= sAxiSlaveReadPort(9).Response;
  sGtwiz9CtrlAxiRValid  <= to_StdLogic(sAxiSlaveReadPort(9).DataValid);

  -- Fill in AXI Port10 records with top level signals.
  sAxiMasterWritePort(10).Address   <= unsigned(sGtwiz10CtrlAxiAWAddr);
  sAxiMasterWritePort(10).AddrValid <= sGtwiz10CtrlAxiAWValid = '1';
  sAxiMasterWritePort(10).Data      <= sGtwiz10CtrlAxiWData;
  sAxiMasterWritePort(10).DataStrb  <= sGtwiz10CtrlAxiWStrb;
  sAxiMasterWritePort(10).DataValid <= sGtwiz10CtrlAxiWValid = '1';
  sAxiMasterWritePort(10).Ready     <= sGtwiz10CtrlAxiBReady = '1';

  sGtwiz10CtrlAxiAWReady <= to_StdLogic(sAxiSlaveWritePort(10).AddrReady);
  sGtwiz10CtrlAxiWReady  <= to_StdLogic(sAxiSlaveWritePort(10).DataReady);
  sGtwiz10CtrlAxiBResp   <= sAxiSlaveWritePort(10).Response;
  sGtwiz10CtrlAxiBValid  <= to_StdLogic(sAxiSlaveWritePort(10).RespValid);

  sAxiMasterReadPort(10).Address   <= unsigned(sGtwiz10CtrlAxiARAddr);
  sAxiMasterReadPort(10).AddrValid <= sGtwiz10CtrlAxiARValid = '1';
  sAxiMasterReadPort(10).Ready     <= sGtwiz10CtrlAxiRReady = '1';

  sGtwiz10CtrlAxiARReady <= to_StdLogic(sAxiSlaveReadPort(10).AddrReady);
  sGtwiz10CtrlAxiRData   <= sAxiSlaveReadPort(10).Data;
  sGtwiz10CtrlAxiRResp   <= sAxiSlaveReadPort(10).Response;
  sGtwiz10CtrlAxiRValid  <= to_StdLogic(sAxiSlaveReadPort(10).DataValid);

  -- Fill in AXI Port11 records with top level signals.
  sAxiMasterWritePort(11).Address   <= unsigned(sGtwiz11CtrlAxiAWAddr);
  sAxiMasterWritePort(11).AddrValid <= sGtwiz11CtrlAxiAWValid = '1';
  sAxiMasterWritePort(11).Data      <= sGtwiz11CtrlAxiWData;
  sAxiMasterWritePort(11).DataStrb  <= sGtwiz11CtrlAxiWStrb;
  sAxiMasterWritePort(11).DataValid <= sGtwiz11CtrlAxiWValid = '1';
  sAxiMasterWritePort(11).Ready     <= sGtwiz11CtrlAxiBReady = '1';

  sGtwiz11CtrlAxiAWReady <= to_StdLogic(sAxiSlaveWritePort(11).AddrReady);
  sGtwiz11CtrlAxiWReady  <= to_StdLogic(sAxiSlaveWritePort(11).DataReady);
  sGtwiz11CtrlAxiBResp   <= sAxiSlaveWritePort(11).Response;
  sGtwiz11CtrlAxiBValid  <= to_StdLogic(sAxiSlaveWritePort(11).RespValid);

  sAxiMasterReadPort(11).Address   <= unsigned(sGtwiz11CtrlAxiARAddr);
  sAxiMasterReadPort(11).AddrValid <= sGtwiz11CtrlAxiARValid = '1';
  sAxiMasterReadPort(11).Ready     <= sGtwiz11CtrlAxiRReady = '1';

  sGtwiz11CtrlAxiARReady <= to_StdLogic(sAxiSlaveReadPort(11).AddrReady);
  sGtwiz11CtrlAxiRData   <= sAxiSlaveReadPort(11).Data;
  sGtwiz11CtrlAxiRResp   <= sAxiSlaveReadPort(11).Response;
  sGtwiz11CtrlAxiRValid  <= to_StdLogic(sAxiSlaveReadPort(11).DataValid);


  ---------------------------------------------------------
  -- MGT Connection
  ---------------------------------------------------------
  -- Sasquatch lane 0/1 swapped of each port
  GenMgtRoute:
  for i in 0 to 12-1 generate
    PortRx_p   (4*i to 4*(i+1)-1)     <= reversi(MgtPortRx_p(4*(i+1)-1 downto 4*i));
    PortRx_n   (4*i to 4*(i+1)-1)     <= reversi(MgtPortRx_n(4*(i+1)-1 downto 4*i));
    MgtPortTx_p(4*(i+1)-1 downto 4*i) <= reversi(PortTx_p   (4*i to 4*(i+1)-1));
    MgtPortTx_n(4*(i+1)-1 downto 4*i) <= reversi(PortTx_n   (4*i to 4*(i+1)-1));
  end generate;

  ---------------------------------------------------------
  -- User Clock
  ---------------------------------------------------------
  UserClkPort0 <= UserClkPort(0);
  UserClkPort1 <= UserClkPort(1);
  UserClkPort2 <= UserClkPort(2);
  UserClkPort3 <= UserClkPort(3);
  UserClkPort4 <= UserClkPort(4);
  UserClkPort5 <= UserClkPort(5);
  UserClkPort6 <= UserClkPort(6);
  UserClkPort7 <= UserClkPort(7);
  UserClkPort8 <= UserClkPort(8);
  UserClkPort9 <= UserClkPort(9);
  UserClkPort10 <= UserClkPort(10);
  UserClkPort11 <= UserClkPort(11);

  ---------------------------------------------------------
  -- PmaInit
  ---------------------------------------------------------
  aPortPmaInit(0) <= aPort0PmaInit or aResetSl;
  aPortPmaInit(1) <= aPort1PmaInit or aResetSl;
  aPortPmaInit(2) <= aPort2PmaInit or aResetSl;
  aPortPmaInit(3) <= aPort3PmaInit or aResetSl;
  aPortPmaInit(4) <= aPort4PmaInit or aResetSl;
  aPortPmaInit(5) <= aPort5PmaInit or aResetSl;
  aPortPmaInit(6) <= aPort6PmaInit or aResetSl;
  aPortPmaInit(7) <= aPort7PmaInit or aResetSl;
  aPortPmaInit(8) <= aPort8PmaInit or aResetSl;
  aPortPmaInit(9) <= aPort9PmaInit or aResetSl;
  aPortPmaInit(10) <= aPort10PmaInit or aResetSl;
  aPortPmaInit(11) <= aPort11PmaInit or aResetSl;

  ---------------------------------------------------------
  -- ResetPb
  ---------------------------------------------------------
  aPortResetPb(0) <= aPort0ResetPb;
  aPortResetPb(1) <= aPort1ResetPb;
  aPortResetPb(2) <= aPort2ResetPb;
  aPortResetPb(3) <= aPort3ResetPb;
  aPortResetPb(4) <= aPort4ResetPb;
  aPortResetPb(5) <= aPort5ResetPb;
  aPortResetPb(6) <= aPort6ResetPb;
  aPortResetPb(7) <= aPort7ResetPb;
  aPortResetPb(8) <= aPort8ResetPb;
  aPortResetPb(9) <= aPort9ResetPb;
  aPortResetPb(10) <= aPort10ResetPb;
  aPortResetPb(11) <= aPort11ResetPb;

  ---------------------------------------------------------
  -- CrcPassFail / CrcValid
  ---------------------------------------------------------
  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort0CrcResultWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(0))
    begin
      if aResetSl = '1' then
        uPort0CrcPassFail_n <= '1';
        uPort0CrcValid      <= '0';
      elsif rising_edge(UserClkPort(0)) then
        uPort0CrcPassFail_n <= uPortCrcPassFail_n(0);
        uPort0CrcValid      <= uPortCrcValid(0);
      end if;
    end process;
  end generate;

  GeneratePort0CrcResultWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort0CrcPassFail_n <= uPortCrcPassFail_n(0);
    uPort0CrcValid      <= uPortCrcValid(0);
  end generate;

  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort1CrcResultWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(1))
    begin
      if aResetSl = '1' then
        uPort1CrcPassFail_n <= '1';
        uPort1CrcValid      <= '0';
      elsif rising_edge(UserClkPort(1)) then
        uPort1CrcPassFail_n <= uPortCrcPassFail_n(1);
        uPort1CrcValid      <= uPortCrcValid(1);
      end if;
    end process;
  end generate;

  GeneratePort1CrcResultWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort1CrcPassFail_n <= uPortCrcPassFail_n(1);
    uPort1CrcValid      <= uPortCrcValid(1);
  end generate;

  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort2CrcResultWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(2))
    begin
      if aResetSl = '1' then
        uPort2CrcPassFail_n <= '1';
        uPort2CrcValid      <= '0';
      elsif rising_edge(UserClkPort(2)) then
        uPort2CrcPassFail_n <= uPortCrcPassFail_n(2);
        uPort2CrcValid      <= uPortCrcValid(2);
      end if;
    end process;
  end generate;

  GeneratePort2CrcResultWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort2CrcPassFail_n <= uPortCrcPassFail_n(2);
    uPort2CrcValid      <= uPortCrcValid(2);
  end generate;

  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort3CrcResultWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(3))
    begin
      if aResetSl = '1' then
        uPort3CrcPassFail_n <= '1';
        uPort3CrcValid      <= '0';
      elsif rising_edge(UserClkPort(3)) then
        uPort3CrcPassFail_n <= uPortCrcPassFail_n(3);
        uPort3CrcValid      <= uPortCrcValid(3);
      end if;
    end process;
  end generate;

  GeneratePort3CrcResultWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort3CrcPassFail_n <= uPortCrcPassFail_n(3);
    uPort3CrcValid      <= uPortCrcValid(3);
  end generate;

  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort4CrcResultWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(4))
    begin
      if aResetSl = '1' then
        uPort4CrcPassFail_n <= '1';
        uPort4CrcValid      <= '0';
      elsif rising_edge(UserClkPort(4)) then
        uPort4CrcPassFail_n <= uPortCrcPassFail_n(4);
        uPort4CrcValid      <= uPortCrcValid(4);
      end if;
    end process;
  end generate;

  GeneratePort4CrcResultWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort4CrcPassFail_n <= uPortCrcPassFail_n(4);
    uPort4CrcValid      <= uPortCrcValid(4);
  end generate;

  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort5CrcResultWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(5))
    begin
      if aResetSl = '1' then
        uPort5CrcPassFail_n <= '1';
        uPort5CrcValid      <= '0';
      elsif rising_edge(UserClkPort(5)) then
        uPort5CrcPassFail_n <= uPortCrcPassFail_n(5);
        uPort5CrcValid      <= uPortCrcValid(5);
      end if;
    end process;
  end generate;

  GeneratePort5CrcResultWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort5CrcPassFail_n <= uPortCrcPassFail_n(5);
    uPort5CrcValid      <= uPortCrcValid(5);
  end generate;

  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort6CrcResultWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(6))
    begin
      if aResetSl = '1' then
        uPort6CrcPassFail_n <= '1';
        uPort6CrcValid      <= '0';
      elsif rising_edge(UserClkPort(6)) then
        uPort6CrcPassFail_n <= uPortCrcPassFail_n(6);
        uPort6CrcValid      <= uPortCrcValid(6);
      end if;
    end process;
  end generate;

  GeneratePort6CrcResultWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort6CrcPassFail_n <= uPortCrcPassFail_n(6);
    uPort6CrcValid      <= uPortCrcValid(6);
  end generate;

  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort7CrcResultWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(7))
    begin
      if aResetSl = '1' then
        uPort7CrcPassFail_n <= '1';
        uPort7CrcValid      <= '0';
      elsif rising_edge(UserClkPort(7)) then
        uPort7CrcPassFail_n <= uPortCrcPassFail_n(7);
        uPort7CrcValid      <= uPortCrcValid(7);
      end if;
    end process;
  end generate;

  GeneratePort7CrcResultWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort7CrcPassFail_n <= uPortCrcPassFail_n(7);
    uPort7CrcValid      <= uPortCrcValid(7);
  end generate;

  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort8CrcResultWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(8))
    begin
      if aResetSl = '1' then
        uPort8CrcPassFail_n <= '1';
        uPort8CrcValid      <= '0';
      elsif rising_edge(UserClkPort(8)) then
        uPort8CrcPassFail_n <= uPortCrcPassFail_n(8);
        uPort8CrcValid      <= uPortCrcValid(8);
      end if;
    end process;
  end generate;

  GeneratePort8CrcResultWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort8CrcPassFail_n <= uPortCrcPassFail_n(8);
    uPort8CrcValid      <= uPortCrcValid(8);
  end generate;

  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort9CrcResultWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(9))
    begin
      if aResetSl = '1' then
        uPort9CrcPassFail_n <= '1';
        uPort9CrcValid      <= '0';
      elsif rising_edge(UserClkPort(9)) then
        uPort9CrcPassFail_n <= uPortCrcPassFail_n(9);
        uPort9CrcValid      <= uPortCrcValid(9);
      end if;
    end process;
  end generate;

  GeneratePort9CrcResultWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort9CrcPassFail_n <= uPortCrcPassFail_n(9);
    uPort9CrcValid      <= uPortCrcValid(9);
  end generate;

  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort10CrcResultWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(10))
    begin
      if aResetSl = '1' then
        uPort10CrcPassFail_n <= '1';
        uPort10CrcValid      <= '0';
      elsif rising_edge(UserClkPort(10)) then
        uPort10CrcPassFail_n <= uPortCrcPassFail_n(10);
        uPort10CrcValid      <= uPortCrcValid(10);
      end if;
    end process;
  end generate;

  GeneratePort10CrcResultWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort10CrcPassFail_n <= uPortCrcPassFail_n(10);
    uPort10CrcValid      <= uPortCrcValid(10);
  end generate;

  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort11CrcResultWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(11))
    begin
      if aResetSl = '1' then
        uPort11CrcPassFail_n <= '1';
        uPort11CrcValid      <= '0';
      elsif rising_edge(UserClkPort(11)) then
        uPort11CrcPassFail_n <= uPortCrcPassFail_n(11);
        uPort11CrcValid      <= uPortCrcValid(11);
      end if;
    end process;
  end generate;

  GeneratePort11CrcResultWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort11CrcPassFail_n <= uPortCrcPassFail_n(11);
    uPort11CrcValid      <= uPortCrcValid(11);
  end generate;


  ---------------------------------------------------------
  -- AXI Tx Data Interface
  ---------------------------------------------------------
  -- AXI TX Data Interface Port0
  uPortAxiTxTData0(0)  <= uPort0AxiTxTData0;
  uPortAxiTxTData1(0)  <= uPort0AxiTxTData1;
  uPortAxiTxTData2(0)  <= uPort0AxiTxTData2;
  uPortAxiTxTData3(0)  <= uPort0AxiTxTData3;
  uPortAxiTxTKeep(0)   <= uPort0AxiTxTKeep;
  uPortAxiTxTLast(0)   <= uPort0AxiTxTLast;
  uPortAxiTxTValid(0)  <= uPort0AxiTxTValid;
  uPort0AxiTxTReady    <= uPortAxiTxTReady(0);

  -- AXI TX Data Interface Port1
  uPortAxiTxTData0(1)  <= uPort1AxiTxTData0;
  uPortAxiTxTData1(1)  <= uPort1AxiTxTData1;
  uPortAxiTxTData2(1)  <= uPort1AxiTxTData2;
  uPortAxiTxTData3(1)  <= uPort1AxiTxTData3;
  uPortAxiTxTKeep(1)   <= uPort1AxiTxTKeep;
  uPortAxiTxTLast(1)   <= uPort1AxiTxTLast;
  uPortAxiTxTValid(1)  <= uPort1AxiTxTValid;
  uPort1AxiTxTReady    <= uPortAxiTxTReady(1);

  -- AXI TX Data Interface Port2
  uPortAxiTxTData0(2)  <= uPort2AxiTxTData0;
  uPortAxiTxTData1(2)  <= uPort2AxiTxTData1;
  uPortAxiTxTData2(2)  <= uPort2AxiTxTData2;
  uPortAxiTxTData3(2)  <= uPort2AxiTxTData3;
  uPortAxiTxTKeep(2)   <= uPort2AxiTxTKeep;
  uPortAxiTxTLast(2)   <= uPort2AxiTxTLast;
  uPortAxiTxTValid(2)  <= uPort2AxiTxTValid;
  uPort2AxiTxTReady    <= uPortAxiTxTReady(2);

  -- AXI TX Data Interface Port3
  uPortAxiTxTData0(3)  <= uPort3AxiTxTData0;
  uPortAxiTxTData1(3)  <= uPort3AxiTxTData1;
  uPortAxiTxTData2(3)  <= uPort3AxiTxTData2;
  uPortAxiTxTData3(3)  <= uPort3AxiTxTData3;
  uPortAxiTxTKeep(3)   <= uPort3AxiTxTKeep;
  uPortAxiTxTLast(3)   <= uPort3AxiTxTLast;
  uPortAxiTxTValid(3)  <= uPort3AxiTxTValid;
  uPort3AxiTxTReady    <= uPortAxiTxTReady(3);

  -- AXI TX Data Interface Port4
  uPortAxiTxTData0(4)  <= uPort4AxiTxTData0;
  uPortAxiTxTData1(4)  <= uPort4AxiTxTData1;
  uPortAxiTxTData2(4)  <= uPort4AxiTxTData2;
  uPortAxiTxTData3(4)  <= uPort4AxiTxTData3;
  uPortAxiTxTKeep(4)   <= uPort4AxiTxTKeep;
  uPortAxiTxTLast(4)   <= uPort4AxiTxTLast;
  uPortAxiTxTValid(4)  <= uPort4AxiTxTValid;
  uPort4AxiTxTReady    <= uPortAxiTxTReady(4);

  -- AXI TX Data Interface Port5
  uPortAxiTxTData0(5)  <= uPort5AxiTxTData0;
  uPortAxiTxTData1(5)  <= uPort5AxiTxTData1;
  uPortAxiTxTData2(5)  <= uPort5AxiTxTData2;
  uPortAxiTxTData3(5)  <= uPort5AxiTxTData3;
  uPortAxiTxTKeep(5)   <= uPort5AxiTxTKeep;
  uPortAxiTxTLast(5)   <= uPort5AxiTxTLast;
  uPortAxiTxTValid(5)  <= uPort5AxiTxTValid;
  uPort5AxiTxTReady    <= uPortAxiTxTReady(5);

  -- AXI TX Data Interface Port6
  uPortAxiTxTData0(6)  <= uPort6AxiTxTData0;
  uPortAxiTxTData1(6)  <= uPort6AxiTxTData1;
  uPortAxiTxTData2(6)  <= uPort6AxiTxTData2;
  uPortAxiTxTData3(6)  <= uPort6AxiTxTData3;
  uPortAxiTxTKeep(6)   <= uPort6AxiTxTKeep;
  uPortAxiTxTLast(6)   <= uPort6AxiTxTLast;
  uPortAxiTxTValid(6)  <= uPort6AxiTxTValid;
  uPort6AxiTxTReady    <= uPortAxiTxTReady(6);

  -- AXI TX Data Interface Port7
  uPortAxiTxTData0(7)  <= uPort7AxiTxTData0;
  uPortAxiTxTData1(7)  <= uPort7AxiTxTData1;
  uPortAxiTxTData2(7)  <= uPort7AxiTxTData2;
  uPortAxiTxTData3(7)  <= uPort7AxiTxTData3;
  uPortAxiTxTKeep(7)   <= uPort7AxiTxTKeep;
  uPortAxiTxTLast(7)   <= uPort7AxiTxTLast;
  uPortAxiTxTValid(7)  <= uPort7AxiTxTValid;
  uPort7AxiTxTReady    <= uPortAxiTxTReady(7);

  -- AXI TX Data Interface Port8
  uPortAxiTxTData0(8)  <= uPort8AxiTxTData0;
  uPortAxiTxTData1(8)  <= uPort8AxiTxTData1;
  uPortAxiTxTData2(8)  <= uPort8AxiTxTData2;
  uPortAxiTxTData3(8)  <= uPort8AxiTxTData3;
  uPortAxiTxTKeep(8)   <= uPort8AxiTxTKeep;
  uPortAxiTxTLast(8)   <= uPort8AxiTxTLast;
  uPortAxiTxTValid(8)  <= uPort8AxiTxTValid;
  uPort8AxiTxTReady    <= uPortAxiTxTReady(8);

  -- AXI TX Data Interface Port9
  uPortAxiTxTData0(9)  <= uPort9AxiTxTData0;
  uPortAxiTxTData1(9)  <= uPort9AxiTxTData1;
  uPortAxiTxTData2(9)  <= uPort9AxiTxTData2;
  uPortAxiTxTData3(9)  <= uPort9AxiTxTData3;
  uPortAxiTxTKeep(9)   <= uPort9AxiTxTKeep;
  uPortAxiTxTLast(9)   <= uPort9AxiTxTLast;
  uPortAxiTxTValid(9)  <= uPort9AxiTxTValid;
  uPort9AxiTxTReady    <= uPortAxiTxTReady(9);

  -- AXI TX Data Interface Port10
  uPortAxiTxTData0(10)  <= uPort10AxiTxTData0;
  uPortAxiTxTData1(10)  <= uPort10AxiTxTData1;
  uPortAxiTxTData2(10)  <= uPort10AxiTxTData2;
  uPortAxiTxTData3(10)  <= uPort10AxiTxTData3;
  uPortAxiTxTKeep(10)   <= uPort10AxiTxTKeep;
  uPortAxiTxTLast(10)   <= uPort10AxiTxTLast;
  uPortAxiTxTValid(10)  <= uPort10AxiTxTValid;
  uPort10AxiTxTReady    <= uPortAxiTxTReady(10);

  -- AXI TX Data Interface Port11
  uPortAxiTxTData0(11)  <= uPort11AxiTxTData0;
  uPortAxiTxTData1(11)  <= uPort11AxiTxTData1;
  uPortAxiTxTData2(11)  <= uPort11AxiTxTData2;
  uPortAxiTxTData3(11)  <= uPort11AxiTxTData3;
  uPortAxiTxTKeep(11)   <= uPort11AxiTxTKeep;
  uPortAxiTxTLast(11)   <= uPort11AxiTxTLast;
  uPortAxiTxTValid(11)  <= uPort11AxiTxTValid;
  uPort11AxiTxTReady    <= uPortAxiTxTReady(11);


  ---------------------------------------------------------
  -- AXI Rx Data Interface
  ---------------------------------------------------------
  -- AXI RX Data Interface Port0
  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort0AxiRxWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(0))
    begin
      if aResetSl = '1' then
        uPort0AxiRxTData0  <= (others => '0');
        uPort0AxiRxTData1  <= (others => '0');
        uPort0AxiRxTData2  <= (others => '0');
        uPort0AxiRxTData3  <= (others => '0');
        uPort0AxiRxTKeep   <= (others => '0');
        uPort0AxiRxTLast   <= '0';
        uPort0AxiRxTValid  <= '0';
      elsif rising_edge(UserClkPort(0)) then
        uPort0AxiRxTData0  <= uPortAxiRxTData0(0);
        uPort0AxiRxTData1  <= uPortAxiRxTData1(0);
        uPort0AxiRxTData2  <= uPortAxiRxTData2(0);
        uPort0AxiRxTData3  <= uPortAxiRxTData3(0);
        uPort0AxiRxTKeep   <= uPortAxiRxTKeep(0);
        uPort0AxiRxTLast   <= uPortAxiRxTLast(0);
        uPort0AxiRxTValid  <= uPortAxiRxTValid(0);
      end if;
    end process;
  end generate;

  GeneratePort0AxiRxWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort0AxiRxTData0  <= uPortAxiRxTData0(0);
    uPort0AxiRxTData1  <= uPortAxiRxTData1(0);
    uPort0AxiRxTData2  <= uPortAxiRxTData2(0);
    uPort0AxiRxTData3  <= uPortAxiRxTData3(0);
    uPort0AxiRxTKeep   <= uPortAxiRxTKeep(0);
    uPort0AxiRxTLast   <= uPortAxiRxTLast(0);
    uPort0AxiRxTValid  <= uPortAxiRxTValid(0);
  end generate;

  -- AXI RX Data Interface Port1
  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort1AxiRxWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(1))
    begin
      if aResetSl = '1' then
        uPort1AxiRxTData0  <= (others => '0');
        uPort1AxiRxTData1  <= (others => '0');
        uPort1AxiRxTData2  <= (others => '0');
        uPort1AxiRxTData3  <= (others => '0');
        uPort1AxiRxTKeep   <= (others => '0');
        uPort1AxiRxTLast   <= '0';
        uPort1AxiRxTValid  <= '0';
      elsif rising_edge(UserClkPort(1)) then
        uPort1AxiRxTData0  <= uPortAxiRxTData0(1);
        uPort1AxiRxTData1  <= uPortAxiRxTData1(1);
        uPort1AxiRxTData2  <= uPortAxiRxTData2(1);
        uPort1AxiRxTData3  <= uPortAxiRxTData3(1);
        uPort1AxiRxTKeep   <= uPortAxiRxTKeep(1);
        uPort1AxiRxTLast   <= uPortAxiRxTLast(1);
        uPort1AxiRxTValid  <= uPortAxiRxTValid(1);
      end if;
    end process;
  end generate;

  GeneratePort1AxiRxWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort1AxiRxTData0  <= uPortAxiRxTData0(1);
    uPort1AxiRxTData1  <= uPortAxiRxTData1(1);
    uPort1AxiRxTData2  <= uPortAxiRxTData2(1);
    uPort1AxiRxTData3  <= uPortAxiRxTData3(1);
    uPort1AxiRxTKeep   <= uPortAxiRxTKeep(1);
    uPort1AxiRxTLast   <= uPortAxiRxTLast(1);
    uPort1AxiRxTValid  <= uPortAxiRxTValid(1);
  end generate;

  -- AXI RX Data Interface Port2
  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort2AxiRxWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(2))
    begin
      if aResetSl = '1' then
        uPort2AxiRxTData0  <= (others => '0');
        uPort2AxiRxTData1  <= (others => '0');
        uPort2AxiRxTData2  <= (others => '0');
        uPort2AxiRxTData3  <= (others => '0');
        uPort2AxiRxTKeep   <= (others => '0');
        uPort2AxiRxTLast   <= '0';
        uPort2AxiRxTValid  <= '0';
      elsif rising_edge(UserClkPort(2)) then
        uPort2AxiRxTData0  <= uPortAxiRxTData0(2);
        uPort2AxiRxTData1  <= uPortAxiRxTData1(2);
        uPort2AxiRxTData2  <= uPortAxiRxTData2(2);
        uPort2AxiRxTData3  <= uPortAxiRxTData3(2);
        uPort2AxiRxTKeep   <= uPortAxiRxTKeep(2);
        uPort2AxiRxTLast   <= uPortAxiRxTLast(2);
        uPort2AxiRxTValid  <= uPortAxiRxTValid(2);
      end if;
    end process;
  end generate;

  GeneratePort2AxiRxWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort2AxiRxTData0  <= uPortAxiRxTData0(2);
    uPort2AxiRxTData1  <= uPortAxiRxTData1(2);
    uPort2AxiRxTData2  <= uPortAxiRxTData2(2);
    uPort2AxiRxTData3  <= uPortAxiRxTData3(2);
    uPort2AxiRxTKeep   <= uPortAxiRxTKeep(2);
    uPort2AxiRxTLast   <= uPortAxiRxTLast(2);
    uPort2AxiRxTValid  <= uPortAxiRxTValid(2);
  end generate;

  -- AXI RX Data Interface Port3
  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort3AxiRxWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(3))
    begin
      if aResetSl = '1' then
        uPort3AxiRxTData0  <= (others => '0');
        uPort3AxiRxTData1  <= (others => '0');
        uPort3AxiRxTData2  <= (others => '0');
        uPort3AxiRxTData3  <= (others => '0');
        uPort3AxiRxTKeep   <= (others => '0');
        uPort3AxiRxTLast   <= '0';
        uPort3AxiRxTValid  <= '0';
      elsif rising_edge(UserClkPort(3)) then
        uPort3AxiRxTData0  <= uPortAxiRxTData0(3);
        uPort3AxiRxTData1  <= uPortAxiRxTData1(3);
        uPort3AxiRxTData2  <= uPortAxiRxTData2(3);
        uPort3AxiRxTData3  <= uPortAxiRxTData3(3);
        uPort3AxiRxTKeep   <= uPortAxiRxTKeep(3);
        uPort3AxiRxTLast   <= uPortAxiRxTLast(3);
        uPort3AxiRxTValid  <= uPortAxiRxTValid(3);
      end if;
    end process;
  end generate;

  GeneratePort3AxiRxWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort3AxiRxTData0  <= uPortAxiRxTData0(3);
    uPort3AxiRxTData1  <= uPortAxiRxTData1(3);
    uPort3AxiRxTData2  <= uPortAxiRxTData2(3);
    uPort3AxiRxTData3  <= uPortAxiRxTData3(3);
    uPort3AxiRxTKeep   <= uPortAxiRxTKeep(3);
    uPort3AxiRxTLast   <= uPortAxiRxTLast(3);
    uPort3AxiRxTValid  <= uPortAxiRxTValid(3);
  end generate;

  -- AXI RX Data Interface Port4
  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort4AxiRxWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(4))
    begin
      if aResetSl = '1' then
        uPort4AxiRxTData0  <= (others => '0');
        uPort4AxiRxTData1  <= (others => '0');
        uPort4AxiRxTData2  <= (others => '0');
        uPort4AxiRxTData3  <= (others => '0');
        uPort4AxiRxTKeep   <= (others => '0');
        uPort4AxiRxTLast   <= '0';
        uPort4AxiRxTValid  <= '0';
      elsif rising_edge(UserClkPort(4)) then
        uPort4AxiRxTData0  <= uPortAxiRxTData0(4);
        uPort4AxiRxTData1  <= uPortAxiRxTData1(4);
        uPort4AxiRxTData2  <= uPortAxiRxTData2(4);
        uPort4AxiRxTData3  <= uPortAxiRxTData3(4);
        uPort4AxiRxTKeep   <= uPortAxiRxTKeep(4);
        uPort4AxiRxTLast   <= uPortAxiRxTLast(4);
        uPort4AxiRxTValid  <= uPortAxiRxTValid(4);
      end if;
    end process;
  end generate;

  GeneratePort4AxiRxWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort4AxiRxTData0  <= uPortAxiRxTData0(4);
    uPort4AxiRxTData1  <= uPortAxiRxTData1(4);
    uPort4AxiRxTData2  <= uPortAxiRxTData2(4);
    uPort4AxiRxTData3  <= uPortAxiRxTData3(4);
    uPort4AxiRxTKeep   <= uPortAxiRxTKeep(4);
    uPort4AxiRxTLast   <= uPortAxiRxTLast(4);
    uPort4AxiRxTValid  <= uPortAxiRxTValid(4);
  end generate;

  -- AXI RX Data Interface Port5
  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort5AxiRxWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(5))
    begin
      if aResetSl = '1' then
        uPort5AxiRxTData0  <= (others => '0');
        uPort5AxiRxTData1  <= (others => '0');
        uPort5AxiRxTData2  <= (others => '0');
        uPort5AxiRxTData3  <= (others => '0');
        uPort5AxiRxTKeep   <= (others => '0');
        uPort5AxiRxTLast   <= '0';
        uPort5AxiRxTValid  <= '0';
      elsif rising_edge(UserClkPort(5)) then
        uPort5AxiRxTData0  <= uPortAxiRxTData0(5);
        uPort5AxiRxTData1  <= uPortAxiRxTData1(5);
        uPort5AxiRxTData2  <= uPortAxiRxTData2(5);
        uPort5AxiRxTData3  <= uPortAxiRxTData3(5);
        uPort5AxiRxTKeep   <= uPortAxiRxTKeep(5);
        uPort5AxiRxTLast   <= uPortAxiRxTLast(5);
        uPort5AxiRxTValid  <= uPortAxiRxTValid(5);
      end if;
    end process;
  end generate;

  GeneratePort5AxiRxWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort5AxiRxTData0  <= uPortAxiRxTData0(5);
    uPort5AxiRxTData1  <= uPortAxiRxTData1(5);
    uPort5AxiRxTData2  <= uPortAxiRxTData2(5);
    uPort5AxiRxTData3  <= uPortAxiRxTData3(5);
    uPort5AxiRxTKeep   <= uPortAxiRxTKeep(5);
    uPort5AxiRxTLast   <= uPortAxiRxTLast(5);
    uPort5AxiRxTValid  <= uPortAxiRxTValid(5);
  end generate;

  -- AXI RX Data Interface Port6
  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort6AxiRxWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(6))
    begin
      if aResetSl = '1' then
        uPort6AxiRxTData0  <= (others => '0');
        uPort6AxiRxTData1  <= (others => '0');
        uPort6AxiRxTData2  <= (others => '0');
        uPort6AxiRxTData3  <= (others => '0');
        uPort6AxiRxTKeep   <= (others => '0');
        uPort6AxiRxTLast   <= '0';
        uPort6AxiRxTValid  <= '0';
      elsif rising_edge(UserClkPort(6)) then
        uPort6AxiRxTData0  <= uPortAxiRxTData0(6);
        uPort6AxiRxTData1  <= uPortAxiRxTData1(6);
        uPort6AxiRxTData2  <= uPortAxiRxTData2(6);
        uPort6AxiRxTData3  <= uPortAxiRxTData3(6);
        uPort6AxiRxTKeep   <= uPortAxiRxTKeep(6);
        uPort6AxiRxTLast   <= uPortAxiRxTLast(6);
        uPort6AxiRxTValid  <= uPortAxiRxTValid(6);
      end if;
    end process;
  end generate;

  GeneratePort6AxiRxWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort6AxiRxTData0  <= uPortAxiRxTData0(6);
    uPort6AxiRxTData1  <= uPortAxiRxTData1(6);
    uPort6AxiRxTData2  <= uPortAxiRxTData2(6);
    uPort6AxiRxTData3  <= uPortAxiRxTData3(6);
    uPort6AxiRxTKeep   <= uPortAxiRxTKeep(6);
    uPort6AxiRxTLast   <= uPortAxiRxTLast(6);
    uPort6AxiRxTValid  <= uPortAxiRxTValid(6);
  end generate;

  -- AXI RX Data Interface Port7
  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort7AxiRxWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(7))
    begin
      if aResetSl = '1' then
        uPort7AxiRxTData0  <= (others => '0');
        uPort7AxiRxTData1  <= (others => '0');
        uPort7AxiRxTData2  <= (others => '0');
        uPort7AxiRxTData3  <= (others => '0');
        uPort7AxiRxTKeep   <= (others => '0');
        uPort7AxiRxTLast   <= '0';
        uPort7AxiRxTValid  <= '0';
      elsif rising_edge(UserClkPort(7)) then
        uPort7AxiRxTData0  <= uPortAxiRxTData0(7);
        uPort7AxiRxTData1  <= uPortAxiRxTData1(7);
        uPort7AxiRxTData2  <= uPortAxiRxTData2(7);
        uPort7AxiRxTData3  <= uPortAxiRxTData3(7);
        uPort7AxiRxTKeep   <= uPortAxiRxTKeep(7);
        uPort7AxiRxTLast   <= uPortAxiRxTLast(7);
        uPort7AxiRxTValid  <= uPortAxiRxTValid(7);
      end if;
    end process;
  end generate;

  GeneratePort7AxiRxWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort7AxiRxTData0  <= uPortAxiRxTData0(7);
    uPort7AxiRxTData1  <= uPortAxiRxTData1(7);
    uPort7AxiRxTData2  <= uPortAxiRxTData2(7);
    uPort7AxiRxTData3  <= uPortAxiRxTData3(7);
    uPort7AxiRxTKeep   <= uPortAxiRxTKeep(7);
    uPort7AxiRxTLast   <= uPortAxiRxTLast(7);
    uPort7AxiRxTValid  <= uPortAxiRxTValid(7);
  end generate;

  -- AXI RX Data Interface Port8
  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort8AxiRxWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(8))
    begin
      if aResetSl = '1' then
        uPort8AxiRxTData0  <= (others => '0');
        uPort8AxiRxTData1  <= (others => '0');
        uPort8AxiRxTData2  <= (others => '0');
        uPort8AxiRxTData3  <= (others => '0');
        uPort8AxiRxTKeep   <= (others => '0');
        uPort8AxiRxTLast   <= '0';
        uPort8AxiRxTValid  <= '0';
      elsif rising_edge(UserClkPort(8)) then
        uPort8AxiRxTData0  <= uPortAxiRxTData0(8);
        uPort8AxiRxTData1  <= uPortAxiRxTData1(8);
        uPort8AxiRxTData2  <= uPortAxiRxTData2(8);
        uPort8AxiRxTData3  <= uPortAxiRxTData3(8);
        uPort8AxiRxTKeep   <= uPortAxiRxTKeep(8);
        uPort8AxiRxTLast   <= uPortAxiRxTLast(8);
        uPort8AxiRxTValid  <= uPortAxiRxTValid(8);
      end if;
    end process;
  end generate;

  GeneratePort8AxiRxWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort8AxiRxTData0  <= uPortAxiRxTData0(8);
    uPort8AxiRxTData1  <= uPortAxiRxTData1(8);
    uPort8AxiRxTData2  <= uPortAxiRxTData2(8);
    uPort8AxiRxTData3  <= uPortAxiRxTData3(8);
    uPort8AxiRxTKeep   <= uPortAxiRxTKeep(8);
    uPort8AxiRxTLast   <= uPortAxiRxTLast(8);
    uPort8AxiRxTValid  <= uPortAxiRxTValid(8);
  end generate;

  -- AXI RX Data Interface Port9
  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort9AxiRxWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(9))
    begin
      if aResetSl = '1' then
        uPort9AxiRxTData0  <= (others => '0');
        uPort9AxiRxTData1  <= (others => '0');
        uPort9AxiRxTData2  <= (others => '0');
        uPort9AxiRxTData3  <= (others => '0');
        uPort9AxiRxTKeep   <= (others => '0');
        uPort9AxiRxTLast   <= '0';
        uPort9AxiRxTValid  <= '0';
      elsif rising_edge(UserClkPort(9)) then
        uPort9AxiRxTData0  <= uPortAxiRxTData0(9);
        uPort9AxiRxTData1  <= uPortAxiRxTData1(9);
        uPort9AxiRxTData2  <= uPortAxiRxTData2(9);
        uPort9AxiRxTData3  <= uPortAxiRxTData3(9);
        uPort9AxiRxTKeep   <= uPortAxiRxTKeep(9);
        uPort9AxiRxTLast   <= uPortAxiRxTLast(9);
        uPort9AxiRxTValid  <= uPortAxiRxTValid(9);
      end if;
    end process;
  end generate;

  GeneratePort9AxiRxWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort9AxiRxTData0  <= uPortAxiRxTData0(9);
    uPort9AxiRxTData1  <= uPortAxiRxTData1(9);
    uPort9AxiRxTData2  <= uPortAxiRxTData2(9);
    uPort9AxiRxTData3  <= uPortAxiRxTData3(9);
    uPort9AxiRxTKeep   <= uPortAxiRxTKeep(9);
    uPort9AxiRxTLast   <= uPortAxiRxTLast(9);
    uPort9AxiRxTValid  <= uPortAxiRxTValid(9);
  end generate;

  -- AXI RX Data Interface Port10
  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort10AxiRxWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(10))
    begin
      if aResetSl = '1' then
        uPort10AxiRxTData0  <= (others => '0');
        uPort10AxiRxTData1  <= (others => '0');
        uPort10AxiRxTData2  <= (others => '0');
        uPort10AxiRxTData3  <= (others => '0');
        uPort10AxiRxTKeep   <= (others => '0');
        uPort10AxiRxTLast   <= '0';
        uPort10AxiRxTValid  <= '0';
      elsif rising_edge(UserClkPort(10)) then
        uPort10AxiRxTData0  <= uPortAxiRxTData0(10);
        uPort10AxiRxTData1  <= uPortAxiRxTData1(10);
        uPort10AxiRxTData2  <= uPortAxiRxTData2(10);
        uPort10AxiRxTData3  <= uPortAxiRxTData3(10);
        uPort10AxiRxTKeep   <= uPortAxiRxTKeep(10);
        uPort10AxiRxTLast   <= uPortAxiRxTLast(10);
        uPort10AxiRxTValid  <= uPortAxiRxTValid(10);
      end if;
    end process;
  end generate;

  GeneratePort10AxiRxWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort10AxiRxTData0  <= uPortAxiRxTData0(10);
    uPort10AxiRxTData1  <= uPortAxiRxTData1(10);
    uPort10AxiRxTData2  <= uPortAxiRxTData2(10);
    uPort10AxiRxTData3  <= uPortAxiRxTData3(10);
    uPort10AxiRxTKeep   <= uPortAxiRxTKeep(10);
    uPort10AxiRxTLast   <= uPortAxiRxTLast(10);
    uPort10AxiRxTValid  <= uPortAxiRxTValid(10);
  end generate;

  -- AXI RX Data Interface Port11
  -- If line rate is greater than the cut off line rate, adding extra
  -- pipeline register to improve the timing
  GeneratePort11AxiRxWithRegister :
  if 28.0 > kCutOffFreqForExtraReg generate
    process(aResetSl, UserClkPort(11))
    begin
      if aResetSl = '1' then
        uPort11AxiRxTData0  <= (others => '0');
        uPort11AxiRxTData1  <= (others => '0');
        uPort11AxiRxTData2  <= (others => '0');
        uPort11AxiRxTData3  <= (others => '0');
        uPort11AxiRxTKeep   <= (others => '0');
        uPort11AxiRxTLast   <= '0';
        uPort11AxiRxTValid  <= '0';
      elsif rising_edge(UserClkPort(11)) then
        uPort11AxiRxTData0  <= uPortAxiRxTData0(11);
        uPort11AxiRxTData1  <= uPortAxiRxTData1(11);
        uPort11AxiRxTData2  <= uPortAxiRxTData2(11);
        uPort11AxiRxTData3  <= uPortAxiRxTData3(11);
        uPort11AxiRxTKeep   <= uPortAxiRxTKeep(11);
        uPort11AxiRxTLast   <= uPortAxiRxTLast(11);
        uPort11AxiRxTValid  <= uPortAxiRxTValid(11);
      end if;
    end process;
  end generate;

  GeneratePort11AxiRxWithoutRegister :
  if 28.0 <= kCutOffFreqForExtraReg generate
    uPort11AxiRxTData0  <= uPortAxiRxTData0(11);
    uPort11AxiRxTData1  <= uPortAxiRxTData1(11);
    uPort11AxiRxTData2  <= uPortAxiRxTData2(11);
    uPort11AxiRxTData3  <= uPortAxiRxTData3(11);
    uPort11AxiRxTKeep   <= uPortAxiRxTKeep(11);
    uPort11AxiRxTLast   <= uPortAxiRxTLast(11);
    uPort11AxiRxTValid  <= uPortAxiRxTValid(11);
  end generate;


  ---------------------------------------------------------
  -- AXI Native Flow Control Interface
  ---------------------------------------------------------
  -- AXI Nfc Interface Port0
  uPortAxiNfcTData(0)  <= uPort0AxiNfcTData;
  uPortAxiNfcTValid(0) <= uPort0AxiNfcTValid;
  uPort0AxiNfcTReady   <= uPortAxiNfcTReady(0);

  -- AXI Nfc Interface Port1
  uPortAxiNfcTData(1)  <= uPort1AxiNfcTData;
  uPortAxiNfcTValid(1) <= uPort1AxiNfcTValid;
  uPort1AxiNfcTReady   <= uPortAxiNfcTReady(1);

  -- AXI Nfc Interface Port2
  uPortAxiNfcTData(2)  <= uPort2AxiNfcTData;
  uPortAxiNfcTValid(2) <= uPort2AxiNfcTValid;
  uPort2AxiNfcTReady   <= uPortAxiNfcTReady(2);

  -- AXI Nfc Interface Port3
  uPortAxiNfcTData(3)  <= uPort3AxiNfcTData;
  uPortAxiNfcTValid(3) <= uPort3AxiNfcTValid;
  uPort3AxiNfcTReady   <= uPortAxiNfcTReady(3);

  -- AXI Nfc Interface Port4
  uPortAxiNfcTData(4)  <= uPort4AxiNfcTData;
  uPortAxiNfcTValid(4) <= uPort4AxiNfcTValid;
  uPort4AxiNfcTReady   <= uPortAxiNfcTReady(4);

  -- AXI Nfc Interface Port5
  uPortAxiNfcTData(5)  <= uPort5AxiNfcTData;
  uPortAxiNfcTValid(5) <= uPort5AxiNfcTValid;
  uPort5AxiNfcTReady   <= uPortAxiNfcTReady(5);

  -- AXI Nfc Interface Port6
  uPortAxiNfcTData(6)  <= uPort6AxiNfcTData;
  uPortAxiNfcTValid(6) <= uPort6AxiNfcTValid;
  uPort6AxiNfcTReady   <= uPortAxiNfcTReady(6);

  -- AXI Nfc Interface Port7
  uPortAxiNfcTData(7)  <= uPort7AxiNfcTData;
  uPortAxiNfcTValid(7) <= uPort7AxiNfcTValid;
  uPort7AxiNfcTReady   <= uPortAxiNfcTReady(7);

  -- AXI Nfc Interface Port8
  uPortAxiNfcTData(8)  <= uPort8AxiNfcTData;
  uPortAxiNfcTValid(8) <= uPort8AxiNfcTValid;
  uPort8AxiNfcTReady   <= uPortAxiNfcTReady(8);

  -- AXI Nfc Interface Port9
  uPortAxiNfcTData(9)  <= uPort9AxiNfcTData;
  uPortAxiNfcTValid(9) <= uPort9AxiNfcTValid;
  uPort9AxiNfcTReady   <= uPortAxiNfcTReady(9);

  -- AXI Nfc Interface Port10
  uPortAxiNfcTData(10)  <= uPort10AxiNfcTData;
  uPortAxiNfcTValid(10) <= uPort10AxiNfcTValid;
  uPort10AxiNfcTReady   <= uPortAxiNfcTReady(10);

  -- AXI Nfc Interface Port11
  uPortAxiNfcTData(11)  <= uPort11AxiNfcTData;
  uPortAxiNfcTValid(11) <= uPort11AxiNfcTValid;
  uPort11AxiNfcTReady   <= uPortAxiNfcTReady(11);


  GenSigAssignment : for i in 0 to kNumPorts*kNumLanes-1 generate
    rGtwizRxRateIn      ((i+1)*3-1 downto i*3) <= rRxRateIn      (i);
    tGtwizTxDiffCtrlIn  ((i+1)*5-1 downto i*5) <= tTxDiffCtrlIn  (i);
    aGtwizTxPreCursorIn ((i+1)*5-1 downto i*5) <= aTxPreCursorIn (i);
    aGtwizTxPostCursorIn((i+1)*5-1 downto i*5) <= aTxPostCursorIn(i);
    rGtwizRxPrbsSelIn   ((i+1)*4-1 downto i*4) <= rRxPrbsSelIn   (i);
    tGtwizTxPrbsSelIn   ((i+1)*4-1 downto i*4) <= tTxPrbsSelIn   (i);
  end generate;

  SGtwizSlvDmonclk <= (others => SAClk);

  GenGtwizDMonClk : for i in 0 to kNumPorts*kNumLanes-1 generate
    aDMonitorOut(i) <= aGtwizDMonitorOut((i+1)*16-1 downto i*16);

  end generate;

  AuroraBlock : block
  begin
    GenAurora : for i in 0 to kNumPorts-1 generate
      RxUsrClk2(i*4+0) <= RxUserClk2Port(i);
      RxUsrClk2(i*4+1) <= RxUserClk2Port(i);
      RxUsrClk2(i*4+2) <= RxUserClk2Port(i);
      RxUsrClk2(i*4+3) <= RxUserClk2Port(i);
      TxUsrClk2(i*4+0) <= UserClkPort(i);
      TxUsrClk2(i*4+1) <= UserClkPort(i);
      TxUsrClk2(i*4+2) <= UserClkPort(i);
      TxUsrClk2(i*4+3) <= UserClkPort(i);

      --vhook AXI4Lite_GTYE4_Control_Regs4 AXI4Lite_GTYE4_Control_Regs4_inst
      --vhook_a LiteClk              SAClk
      --vhook_a lAxiMasterWritePort  sAxiMasterWritePort(i)
      --vhook_a lAxiSlaveWritePort   sAxiSlaveWritePort (i)
      --vhook_a lAxiMasterReadPort   sAxiMasterReadPort (i)
      --vhook_a lAxiSlaveReadPort    sAxiSlaveReadPort  (i)
      --vhook_a RxUsrClk2            RxUsrClk2((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a TxUsrClk2            TxUsrClk2((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a MgtRefClk            MgtRefClk(i)
      --vhook_a aGtWiz_ResetAll_in           open
      --vhook_a aGtWiz_RxCdr_stable_out      '1'
      --vhook_a aGtWiz_ResetTx_pll_data_in   open
      --vhook_a aGtWiz_ResetTx_data_in       open
      --vhook_a aGtWiz_ResetTx_Done_out      '1'
      --vhook_a aGtWiz_UserClkTx_active_out  (others => '1')
      --vhook_a aGtWiz_ResetRx_pll_data_in   open
      --vhook_a aGtWiz_ResetRx_data_in       open
      --vhook_a aGtWiz_ResetRx_Done_out      '1'
      --vhook_a aGtWiz_UserClkRx_active_out  (others => '1')
      --vhook_a rRxResetDone_out      rRxResetDoneOut((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aRxPmaResetDone_out   aGtRxPmaResetDone((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aRxPmaReset_in        aRxPmaResetIn  ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a tTxResetDone_out      tTxResetDoneOut((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aTxPmaResetDone_out   (others => '1')
      --vhook_a aTxPmaReset_in        aTxPmaResetIn  ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aTxPcsReset_in        aTxPcsResetIn  ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aEyeScanReset_in      aEyeScanResetIn((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aGtPowerGood_out      aGtPowerGoodOut((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aCpllPD_in            open
      --vhook_a aCpllReset_in         open
      --vhook_a aCpllRefClkSel_in     open
      --vhook_a aCpllLock_out         aCpllLockOut((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aCpllRefClkLost_out   (others => '0')
      --vhook_a aQpll0PD_in           open
      --vhook_a aQpll0Reset_in        open
      --vhook_a aQpll0RefClkSel_in    open
      --vhook_a aQpll0Lock_out        aQpll0LockOut(i)
      --vhook_a aQpll0RefClkLost_out  aQpll0RefClkLostOut(i)
      --vhook_a aQpll0SdmReset_in     open
      --vhook_a aQpll0SdmData_in      open
      --vhook_a aQpll0SdmWidth_in     open
      --vhook_a aQpll0SdmToggle_in    open
      --vhook_a aQpll0SdmFinalOut_out (others => '0')
      --vhook_a aQpll1PD_in           open
      --vhook_a aQpll1Reset_in        open
      --vhook_a aQpll1RefClkSel_in    open
      --vhook_a aQpll1Lock_out        '0'
      --vhook_a aQpll1RefClkLost_out  '0'
      --vhook_a aQpll1SdmReset_in     open
      --vhook_a aQpll1SdmData_in      open
      --vhook_a aQpll1SdmWidth_in     open
      --vhook_a aQpll1SdmToggle_in    open
      --vhook_a aQpll1SdmFinalOut_out (others => '0')
      --vhook_a aTxSysClkSel_in       open
      --vhook_a aRxSysClkSel_in       open
      --vhook_a aTxPllClkSel_in       open
      --vhook_a aRxPllClkSel_in       open
      --vhook_a aTxOutClkSel_in       open
      --vhook_a aRxOutClkSel_in       open
      --vhook_a aRxCdrHold_in         aRxCdrHoldIn  ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aRxCdrOvrdEn_in       aRxCdrOvrdEnIn((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aRxCdrReset_in        open
      --vhook_a aRxCdrLock_out        (others => '0')
      --vhook_a tTxPiPpmEn_in         open
      --vhook_a tTxPiPpmOvrdEn_in     open
      --vhook_a aTxPiPpmPD_in         open
      --vhook_a tTxPiPpmSel_in        open
      --vhook_a tTxPiPpmStepSize_in   open
      --vhook_a rRxDfeOsHold_in       open
      --vhook_a rRxDfeOsOvrdEn_in     open
      --vhook_a rRxDfeAgcHold_in      open
      --vhook_a rRxDfeAgcOvrdEn_in    open
      --vhook_a rRxDfeLfHold_in       open
      --vhook_a rRxDfeLfOvrdEn_in     open
      --vhook_a rRxDfeUtHold_in       open
      --vhook_a rRxDfeUtOvrdEn_in     open
      --vhook_a rRxDfeVpHold_in       open
      --vhook_a rRxDfeVpOvrdEn_in     open
      --vhook_a rRxDfeTap2Hold_in     open
      --vhook_a rRxDfeTap2OvrdEn_in   open
      --vhook_a rRxDfeTap3Hold_in     open
      --vhook_a rRxDfeTap3OvrdEn_in   open
      --vhook_a rRxDfeTap4Hold_in     open
      --vhook_a rRxDfeTap4OvrdEn_in   open
      --vhook_a rRxDfeTap5Hold_in     open
      --vhook_a rRxDfeTap5OvrdEn_in   open
      --vhook_a rRxDfeTap6Hold_in     open
      --vhook_a rRxDfeTap6OvrdEn_in   open
      --vhook_a rRxDfeTap7Hold_in     open
      --vhook_a rRxDfeTap7OvrdEn_in   open
      --vhook_a rRxDfeTap8Hold_in     open
      --vhook_a rRxDfeTap8OvrdEn_in   open
      --vhook_a rRxDfeTap9Hold_in     open
      --vhook_a rRxDfeTap9OvrdEn_in   open
      --vhook_a rRxDfeTap10Hold_in    open
      --vhook_a rRxDfeTap10OvrdEn_in  open
      --vhook_a rRxDfeTap11Hold_in    open
      --vhook_a rRxDfeTap11OvrdEn_in  open
      --vhook_a rRxDfeTap12Hold_in    open
      --vhook_a rRxDfeTap12OvrdEn_in  open
      --vhook_a rRxDfeTap13Hold_in    open
      --vhook_a rRxDfeTap13OvrdEn_in  open
      --vhook_a rRxDfeTap14Hold_in    open
      --vhook_a rRxDfeTap14OvrdEn_in  open
      --vhook_a rRxDfeTap15Hold_in    open
      --vhook_a rRxDfeTap15OvrdEn_in  open
      --vhook_a rRxLpmEn_in           rRxLpmEnIn((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a rRxLpmOSHold_in       open
      --vhook_a rRxLpmOSOvrdEn_in     open
      --vhook_a rRxLpmGCHold_in       open
      --vhook_a rRxLpmGCOvrdEn_in     open
      --vhook_a rRxLpmHFHold_in       open
      --vhook_a rRxLpmHFOvrdEn_in     open
      --vhook_a rRxLpmLFHold_in       open
      --vhook_a rRxLpmLFOvrdEn_in     open
      --vhook_a DmonClk               SGtwizSlvDmonclk((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a dDMonitorOut_out      aDMonitorOut((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a rRxRate_in            rRxRateIn((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a rRxRateDone_out       (others => '1')
      --vhook_a tTxRate_in            open
      --vhook_a tTxRateDone_out       (others => '1')
      --vhook_a tTxDiffCtrl_in        tTxDiffCtrlIn  ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aTxPreCursor_in       aTxPreCursorIn ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aTxPostCursor_in      aTxPostCursorIn((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a rRxPrbsSel_in         rRxPrbsSelIn ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a rRxPrbsErr_out        rRxPrbsErrOut((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a rRxPrbsLocked_out     (others => '1')
      --vhook_a rRxPrbsCntReset_in    rRxPrbsCntResetIn((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a rRxPolarity_in        open
      --vhook_a tTxPrbsSel_in         tTxPrbsSelIn     ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a tTxPrbsForceErr_in    tTxPrbsForceErrIn((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a tTxPolarity_in        tTxPolarityIn    ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a tTxDetectRx_in        open
      --vhook_a rPhyStatus_out        (others => '1')
      --vhook_a rRxStatus_out         (others => (others => '1'))
      --vhook_a tTxPd_in              open
      --vhook_a rRxPd_in              open
      --vhook_a aLoopback_in          aLoopbackIn((i+1)*kNumLanes-1 downto i*kNumLanes)
      AXI4Lite_GTYE4_Control_Regs4_inst: AXI4Lite_GTYE4_Control_Regs4
        port map (
          LiteClk                     => SAClk,                                                    --in  std_logic
          aReset_n                    => aReset_n,                                                 --in  std_logic
          lAxiMasterWritePort         => sAxiMasterWritePort(i),                                   --in  Axi4LiteWritePortIn_t
          lAxiSlaveWritePort          => sAxiSlaveWritePort (i),                                   --out Axi4LiteWritePortOut_t
          lAxiMasterReadPort          => sAxiMasterReadPort (i),                                   --in  Axi4LiteReadPortIn_t
          lAxiSlaveReadPort           => sAxiSlaveReadPort (i),                                    --out Axi4LiteReadPortOut_t
          RxUsrClk2                   => RxUsrClk2((i+1)*kNumLanes-1 downto i*kNumLanes),          --in  std_logic_vector(4-1:0)
          TxUsrClk2                   => TxUsrClk2((i+1)*kNumLanes-1 downto i*kNumLanes),          --in  std_logic_vector(4-1:0)
          MgtRefClk                   => MgtRefClk(i),                                             --in  std_logic
          aGtWiz_ResetAll_in          => open,                                                     --out std_logic
          aGtWiz_RxCdr_stable_out     => '1',                                                      --in  std_logic
          aGtWiz_ResetTx_pll_data_in  => open,                                                     --out std_logic
          aGtWiz_ResetTx_data_in      => open,                                                     --out std_logic
          aGtWiz_ResetTx_Done_out     => '1',                                                      --in  std_logic
          aGtWiz_UserClkTx_active_out => (others => '1'),                                          --in  std_logic_vector(3:0)
          aGtWiz_ResetRx_pll_data_in  => open,                                                     --out std_logic
          aGtWiz_ResetRx_data_in      => open,                                                     --out std_logic
          aGtWiz_ResetRx_Done_out     => '1',                                                      --in  std_logic
          aGtWiz_UserClkRx_active_out => (others => '1'),                                          --in  std_logic_vector(3:0)
          rRxResetDone_out            => rRxResetDoneOut((i+1)*kNumLanes-1 downto i*kNumLanes),    --in  std_logic_vector(4-1:0)
          aRxPmaResetDone_out         => aGtRxPmaResetDone((i+1)*kNumLanes-1 downto i*kNumLanes),  --in  std_logic_vector(4-1:0)
          aRxPmaReset_in              => aRxPmaResetIn ((i+1)*kNumLanes-1 downto i*kNumLanes),     --out std_logic_vector(4-1:0)
          tTxResetDone_out            => tTxResetDoneOut((i+1)*kNumLanes-1 downto i*kNumLanes),    --in  std_logic_vector(4-1:0)
          aTxPmaResetDone_out         => (others => '1'),                                          --in  std_logic_vector(4-1:0)
          aTxPmaReset_in              => aTxPmaResetIn ((i+1)*kNumLanes-1 downto i*kNumLanes),     --out std_logic_vector(4-1:0)
          aTxPcsReset_in              => aTxPcsResetIn ((i+1)*kNumLanes-1 downto i*kNumLanes),     --out std_logic_vector(4-1:0)
          aEyeScanReset_in            => aEyeScanResetIn((i+1)*kNumLanes-1 downto i*kNumLanes),    --out std_logic_vector(4-1:0)
          aGtPowerGood_out            => aGtPowerGoodOut((i+1)*kNumLanes-1 downto i*kNumLanes),    --in  std_logic_vector(4-1:0)
          aCpllPD_in                  => open,                                                     --out std_logic_vector(4-1:0)
          aCpllReset_in               => open,                                                     --out std_logic_vector(4-1:0)
          aCpllRefClkSel_in           => open,                                                     --out GTRefClkSelAry_t(4-1:0)
          aCpllLock_out               => aCpllLockOut((i+1)*kNumLanes-1 downto i*kNumLanes),       --in  std_logic_vector(4-1:0)
          aCpllRefClkLost_out         => (others => '0'),                                          --in  std_logic_vector(4-1:0)
          aQpll0PD_in                 => open,                                                     --out std_logic
          aQpll0Reset_in              => open,                                                     --out std_logic
          aQpll0RefClkSel_in          => open,                                                     --out GTRefClkSel_t
          aQpll0Lock_out              => aQpll0LockOut(i),                                         --in  std_logic
          aQpll0RefClkLost_out        => aQpll0RefClkLostOut(i),                                   --in  std_logic
          aQpll0SdmReset_in           => open,                                                     --out std_logic
          aQpll0SdmData_in            => open,                                                     --out std_logic_vector(24:0)
          aQpll0SdmWidth_in           => open,                                                     --out std_logic_vector(1:0)
          aQpll0SdmToggle_in          => open,                                                     --out std_logic
          aQpll0SdmFinalOut_out       => (others => '0'),                                          --in  std_logic_vector(3:0)
          aQpll1PD_in                 => open,                                                     --out std_logic
          aQpll1Reset_in              => open,                                                     --out std_logic
          aQpll1RefClkSel_in          => open,                                                     --out GTRefClkSel_t
          aQpll1Lock_out              => '0',                                                      --in  std_logic
          aQpll1RefClkLost_out        => '0',                                                      --in  std_logic
          aQpll1SdmReset_in           => open,                                                     --out std_logic
          aQpll1SdmData_in            => open,                                                     --out std_logic_vector(24:0)
          aQpll1SdmWidth_in           => open,                                                     --out std_logic_vector(1:0)
          aQpll1SdmToggle_in          => open,                                                     --out std_logic
          aQpll1SdmFinalOut_out       => (others => '0'),                                          --in  std_logic_vector(3:0)
          aTxSysClkSel_in             => open,                                                     --out GTClkSelAry_t(4-1:0)
          aRxSysClkSel_in             => open,                                                     --out GTClkSelAry_t(4-1:0)
          aTxPllClkSel_in             => open,                                                     --out GTClkSelAry_t(4-1:0)
          aRxPllClkSel_in             => open,                                                     --out GTClkSelAry_t(4-1:0)
          aTxOutClkSel_in             => open,                                                     --out GTOutClkSelAry_t(4-1:0)
          aRxOutClkSel_in             => open,                                                     --out GTOutClkSelAry_t(4-1:0)
          aRxCdrHold_in               => aRxCdrHoldIn ((i+1)*kNumLanes-1 downto i*kNumLanes),      --out std_logic_vector(4-1:0)
          aRxCdrOvrdEn_in             => aRxCdrOvrdEnIn((i+1)*kNumLanes-1 downto i*kNumLanes),     --out std_logic_vector(4-1:0)
          aRxCdrReset_in              => open,                                                     --out std_logic_vector(4-1:0)
          aRxCdrLock_out              => (others => '0'),                                          --in  std_logic_vector(4-1:0)
          tTxPiPpmEn_in               => open,                                                     --out std_logic_vector(4-1:0)
          tTxPiPpmOvrdEn_in           => open,                                                     --out std_logic_vector(4-1:0)
          aTxPiPpmPD_in               => open,                                                     --out std_logic_vector(4-1:0)
          tTxPiPpmSel_in              => open,                                                     --out std_logic_vector(4-1:0)
          tTxPiPpmStepSize_in         => open,                                                     --out GTTxPiPpmStepSizeAry_t(4-1:0)
          rRxDfeOSHold_in             => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeOSOvrdEn_in           => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeAgcHold_in            => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeAgcOvrdEn_in          => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeLFHold_in             => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeLFOvrdEn_in           => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeUTHold_in             => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeUTOvrdEn_in           => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeVPHold_in             => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeVPOvrdEn_in           => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap2Hold_in           => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap2OvrdEn_in         => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap3Hold_in           => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap3OvrdEn_in         => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap4Hold_in           => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap4OvrdEn_in         => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap5Hold_in           => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap5OvrdEn_in         => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap6Hold_in           => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap6OvrdEn_in         => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap7Hold_in           => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap7OvrdEn_in         => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap8Hold_in           => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap8OvrdEn_in         => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap9Hold_in           => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap9OvrdEn_in         => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap10Hold_in          => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap10OvrdEn_in        => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap11Hold_in          => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap11OvrdEn_in        => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap12Hold_in          => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap12OvrdEn_in        => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap13Hold_in          => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap13OvrdEn_in        => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap14Hold_in          => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap14OvrdEn_in        => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap15Hold_in          => open,                                                     --out std_logic_vector(4-1:0)
          rRxDfeTap15OvrdEn_in        => open,                                                     --out std_logic_vector(4-1:0)
          rRxLpmEn_in                 => rRxLpmEnIn((i+1)*kNumLanes-1 downto i*kNumLanes),         --out std_logic_vector(4-1:0)
          rRxLpmOSHold_in             => open,                                                     --out std_logic_vector(4-1:0)
          rRxLpmOSOvrdEn_in           => open,                                                     --out std_logic_vector(4-1:0)
          rRxLpmGCHold_in             => open,                                                     --out std_logic_vector(4-1:0)
          rRxLpmGCOvrdEn_in           => open,                                                     --out std_logic_vector(4-1:0)
          rRxLpmHFHold_in             => open,                                                     --out std_logic_vector(4-1:0)
          rRxLpmHFOvrdEn_in           => open,                                                     --out std_logic_vector(4-1:0)
          rRxLpmLFHold_in             => open,                                                     --out std_logic_vector(4-1:0)
          rRxLpmLFOvrdEn_in           => open,                                                     --out std_logic_vector(4-1:0)
          DmonClk                     => SGtwizSlvDmonclk((i+1)*kNumLanes-1 downto i*kNumLanes),   --in  std_logic_vector(4-1:0)
          dDMonitorOut_out            => aDMonitorOut((i+1)*kNumLanes-1 downto i*kNumLanes),       --in  GTYE4DMonitorOutAry_t(4-1:0)
          rRxRate_in                  => rRxRateIn((i+1)*kNumLanes-1 downto i*kNumLanes),          --out GTRateSelAry_t(4-1:0)
          rRxRateDone_out             => (others => '1'),                                          --in  std_logic_vector(4-1:0)
          tTxRate_in                  => open,                                                     --out GTRateSelAry_t(4-1:0)
          tTxRateDone_out             => (others => '1'),                                          --in  std_logic_vector(4-1:0)
          tTxDiffCtrl_in              => tTxDiffCtrlIn ((i+1)*kNumLanes-1 downto i*kNumLanes),     --out GTYDiffCtrlAry_t(4-1:0)
          aTxPreCursor_in             => aTxPreCursorIn ((i+1)*kNumLanes-1 downto i*kNumLanes),    --out GTYCursorSelAry_t(4-1:0)
          aTxPostCursor_in            => aTxPostCursorIn((i+1)*kNumLanes-1 downto i*kNumLanes),    --out GTYCursorSelAry_t(4-1:0)
          rRxPrbsSel_in               => rRxPrbsSelIn ((i+1)*kNumLanes-1 downto i*kNumLanes),      --out GTPrbsSelAry_t(4-1:0)
          rRxPrbsErr_out              => rRxPrbsErrOut((i+1)*kNumLanes-1 downto i*kNumLanes),      --in  std_logic_vector(4-1:0)
          rRxPrbsLocked_out           => (others => '1'),                                          --in  std_logic_vector(4-1:0)
          rRxPrbsCntReset_in          => rRxPrbsCntResetIn((i+1)*kNumLanes-1 downto i*kNumLanes),  --out std_logic_vector(4-1:0)
          rRxPolarity_in              => open,                                                     --out std_logic_vector(4-1:0)
          tTxPrbsSel_in               => tTxPrbsSelIn ((i+1)*kNumLanes-1 downto i*kNumLanes),      --out GTPrbsSelAry_t(4-1:0)
          tTxPrbsForceErr_in          => tTxPrbsForceErrIn((i+1)*kNumLanes-1 downto i*kNumLanes),  --out std_logic_vector(4-1:0)
          tTxPolarity_in              => tTxPolarityIn ((i+1)*kNumLanes-1 downto i*kNumLanes),     --out std_logic_vector(4-1:0)
          tTxDetectRx_in              => open,                                                     --out std_logic_vector(4-1:0)
          rPhyStatus_out              => (others => '1'),                                          --in  std_logic_vector(4-1:0)
          rRxStatus_out               => (others => (others => '1')),                              --in  GTRxStatusAry_t(4-1:0)
          tTxPd_in                    => open,                                                     --out GTPdAry_t(4-1:0)
          rRxPd_in                    => open,                                                     --out GTPdAry_t(4-1:0)
          aLoopback_in                => aLoopbackIn((i+1)*kNumLanes-1 downto i*kNumLanes));       --out GTLoopbackSelAry_t(4-1:0)

      uPortAxiTxTData(i)  <= uPortAxiTxTData3(i) & uPortAxiTxTData2(i) & uPortAxiTxTData1(i) & uPortAxiTxTData0(i);
      uPortAxiRxTData0(i) <= uPortAxiRxTData(i)(0*64+63 downto 0*64);
      uPortAxiRxTData1(i) <= uPortAxiRxTData(i)(1*64+63 downto 1*64);
      uPortAxiRxTData2(i) <= uPortAxiRxTData(i)(2*64+63 downto 2*64);
      uPortAxiRxTData3(i) <= uPortAxiRxTData(i)(3*64+63 downto 3*64);

      uPortLaneUp(i) <= reversi(uPortLaneUpRev(i));

      -- If line rate is greater than the cut off line rate, adding extra
      -- pipeline register to improve the timing
      GenerateAxiTxWithRegister :
      if 28.0 > kCutOffFreqForExtraReg generate
        --vhook AxiFramingRegx4 AxiFramingRegx4Tx
        --vhook_a aclk           UserClkPort(i)
        --vhook_a aresetn        aReset_n
        --vhook_a s_axis_tvalid  uPortAxiTxTValid(i)
        --vhook_a s_axis_tready  uPortAxiTxTReady(i)
        --vhook_a s_axis_tdata   uPortAxiTxTData (i)
        --vhook_a s_axis_tkeep   uPortAxiTxTKeep (i)
        --vhook_a s_axis_tlast   uPortAxiTxTLast (i)
        --vhook_a m_axis_tvalid  uPortAxiRegTxTValid(i)
        --vhook_a m_axis_tready  uPortAxiRegTxTReady(i)
        --vhook_a m_axis_tdata   uPortAxiRegTxTData (i)
        --vhook_a m_axis_tkeep   uPortAxiRegTxTKeep (i)
        --vhook_a m_axis_tlast   uPortAxiRegTxTLast (i)
        AxiFramingRegx4Tx: AxiFramingRegx4
          port map (
            aclk          => UserClkPort(i),          --in  STD_LOGIC
            aresetn       => aReset_n,                --in  STD_LOGIC
            s_axis_tvalid => uPortAxiTxTValid(i),     --in  STD_LOGIC
            s_axis_tready => uPortAxiTxTReady(i),     --out STD_LOGIC
            s_axis_tdata  => uPortAxiTxTData (i),     --in  STD_LOGIC_VECTOR(255:0)
            s_axis_tkeep  => uPortAxiTxTKeep (i),     --in  STD_LOGIC_VECTOR(31:0)
            s_axis_tlast  => uPortAxiTxTLast (i),     --in  STD_LOGIC
            m_axis_tvalid => uPortAxiRegTxTValid(i),  --out STD_LOGIC
            m_axis_tready => uPortAxiRegTxTReady(i),  --in  STD_LOGIC
            m_axis_tdata  => uPortAxiRegTxTData (i),  --out STD_LOGIC_VECTOR(255:0)
            m_axis_tkeep  => uPortAxiRegTxTKeep (i),  --out STD_LOGIC_VECTOR(31:0)
            m_axis_tlast  => uPortAxiRegTxTLast (i)); --out STD_LOGIC
      end generate;

      GenerateAxiTxWithoutRegister :
      if 28.0 <= kCutOffFreqForExtraReg generate
        uPortAxiRegTxTData (i) <= uPortAxiTxTData (i);
        uPortAxiRegTxTLast (i) <= uPortAxiTxTLast (i);
        uPortAxiRegTxTKeep (i) <= uPortAxiTxTKeep (i);
        uPortAxiRegTxTValid(i) <= uPortAxiTxTValid(i);
        uPortAxiTxTReady(i) <= uPortAxiRegTxTReady(i);
      end generate;

      --vhook aurora64b66b_framing_crcx4_28p0GHz Aurora_PortN
      --vhook_a s_axi_tx_tdata   uPortAxiRegTxTData (i)
      --vhook_a s_axi_tx_tlast   uPortAxiRegTxTLast (i)
      --vhook_a s_axi_tx_tkeep   uPortAxiRegTxTKeep (i)
      --vhook_a s_axi_tx_tvalid  uPortAxiRegTxTValid(i)
      --vhook_a s_axi_tx_tready  uPortAxiRegTxTReady(i)
      --vhook_a m_axi_rx_tdata   uPortAxiRxTData (i)
      --vhook_a m_axi_rx_tlast   uPortAxiRxTLast (i)
      --vhook_a m_axi_rx_tkeep   uPortAxiRxTKeep (i)
      --vhook_a m_axi_rx_tvalid  uPortAxiRxTValid(i)
      --vhook_a s_axi_nfc_tvalid uPortAxiNfcTValid(i)
      --vhook_a s_axi_nfc_tdata  uPortAxiNfcTData (i)(15 downto 0)
      --vhook_a s_axi_nfc_tready uPortAxiNfcTReady(i)
      --vhook_a rxp  PortRx_p(i*4 to i*4+3)
      --vhook_a rxn  PortRx_n(i*4 to i*4+3)
      --vhook_a txp  PortTx_p(i*4 to i*4+3)
      --vhook_a txn  PortTx_n(i*4 to i*4+3)
      --vhook_a refclk1_in  MgtRefClk(i)
      --vhook_a hard_err         uPortHardErr  (i)
      --vhook_a soft_err         uPortSoftErr  (i)
      --vhook_a lane_up          uPortLaneUpRev(i)
      --vhook_a channel_up       uPortChannelUp(i)
      --vhook_a crc_pass_fail_n  uPortCrcPassFail_n(i)
      --vhook_a crc_valid        uPortCrcValid(i)
      --vhook_a init_clk         InitClk
      --vhook_a user_clk_out     UserClkPort(i)
      --vhook_a sync_clk_out     SyncClkPort(i)
      --vhook_a mmcm_not_locked_out  uPortMmcmNotLocked(i)
      --vhook_a pma_init         aPortPmaInit(i)
      --vhook_a reset_pb         aPortResetPb(i)
      --vhook_a power_down       '0'
      --vhook_a loopback         aLoopbackIn(i*kNumLanes)
      --vhook_a gt_pll_lock      open
      --vhook_a link_reset_out   iPortLinkResetOut(i)
      --vhook_a sys_reset_out    uPortSysResetOut (i)
      --vhook_a gt_reset_out     open
      --vhook_a gt_rxusrclk_out  RxUserClk2Port(i)
      --vhook_a tx_out_clk       open
      --vhook_a gt_qpllclk_quad1_out         open
      --vhook_a gt_qpllrefclk_quad1_out      open
      --vhook_a gt_qplllock_quad1_out        aQpll0LockOut(i)
      --vhook_a gt_qpllrefclklost_quad1_out  aQpll0RefClkLostOut(i)
      --vhook_a gt0_drpaddr  iGtwizDrpAddrIn((i*4+1)*kAddrSize-1 downto (i*4+0)*kAddrSize)
      --vhook_a gt0_drpdi    iGtwizDrpDiIn  ((i*4+1)*16-1 downto (i*4+0)*16)
      --vhook_a gt0_drpdo    iGtwizDrpDoOut ((i*4+1)*16-1 downto (i*4+0)*16)
      --vhook_a gt0_drprdy   iGtwizDrpRdyOut (i*4+0)
      --vhook_a gt0_drpen    iGtwizDrpEnIn   (i*4+0)
      --vhook_a gt0_drpwe    iGtwizDrpWeIn   (i*4+0)
      --vhook_a gt1_drpaddr  iGtwizDrpAddrIn((i*4+2)*kAddrSize-1 downto (i*4+1)*kAddrSize)
      --vhook_a gt1_drpdi    iGtwizDrpDiIn  ((i*4+2)*16-1 downto (i*4+1)*16)
      --vhook_a gt1_drpdo    iGtwizDrpDoOut ((i*4+2)*16-1 downto (i*4+1)*16)
      --vhook_a gt1_drprdy   iGtwizDrpRdyOut (i*4+1)
      --vhook_a gt1_drpen    iGtwizDrpEnIn   (i*4+1)
      --vhook_a gt1_drpwe    iGtwizDrpWeIn   (i*4+1)
      --vhook_a gt2_drpaddr  iGtwizDrpAddrIn((i*4+3)*kAddrSize-1 downto (i*4+2)*kAddrSize)
      --vhook_a gt2_drpdi    iGtwizDrpDiIn  ((i*4+3)*16-1 downto (i*4+2)*16)
      --vhook_a gt2_drpdo    iGtwizDrpDoOut ((i*4+3)*16-1 downto (i*4+2)*16)
      --vhook_a gt2_drprdy   iGtwizDrpRdyOut (i*4+2)
      --vhook_a gt2_drpen    iGtwizDrpEnIn   (i*4+2)
      --vhook_a gt2_drpwe    iGtwizDrpWeIn   (i*4+2)
      --vhook_a gt3_drpaddr  iGtwizDrpAddrIn((i*4+4)*kAddrSize-1 downto (i*4+3)*kAddrSize)
      --vhook_a gt3_drpdi    iGtwizDrpDiIn  ((i*4+4)*16-1 downto (i*4+3)*16)
      --vhook_a gt3_drpdo    iGtwizDrpDoOut ((i*4+4)*16-1 downto (i*4+3)*16)
      --vhook_a gt3_drprdy   iGtwizDrpRdyOut (i*4+3)
      --vhook_a gt3_drpen    iGtwizDrpEnIn   (i*4+3)
      --vhook_a gt3_drpwe    iGtwizDrpWeIn   (i*4+3)
      --vhook_a gt_rxcdrovrden_in    aRxCdrOvrdEnIn (i*kNumLanes)
      --vhook_a gt_eyescandataerror  open
      --vhook_a gt_eyescanreset      aEyeScanResetIn((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_eyescantrigger    (others => '0')
      --vhook_a gt_rxcdrhold         aRxCdrHoldIn   ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_rxdfelpmreset     (others => '0')
      --vhook_a gt_rxlpmen           rRxLpmEnIn     ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_rxpmareset        aRxPmaResetIn  ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_rxpcsreset        (others => '0')
      --vhook_a gt_rxrate            rGtwizRxRateIn((i+1)*kNumLanes*3-1 downto i*kNumLanes*3)
      --vhook_a gt_rxbufreset        (others => '0')
      --vhook_a gt_rxpmaresetdone    aGtRxPmaResetDone((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_rxprbssel         rGtwizRxPrbsSelIn((i+1)*kNumLanes*4-1 downto i*kNumLanes*4)
      --vhook_a gt_rxprbserr         rRxPrbsErrOut     ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_rxprbscntreset    rRxPrbsCntResetIn ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_rxresetdone       rRxResetDoneOut   ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_rxbufstatus       open
      --vhook_a gt_txdiffctrl        tGtwizTxDiffCtrlIn  ((i+1)*kNumLanes*5-1 downto i*kNumLanes*5)
      --vhook_a gt_txprecursor       aGtwizTxPreCursorIn ((i+1)*kNumLanes*5-1 downto i*kNumLanes*5)
      --vhook_a gt_txpostcursor      aGtwizTxPostCursorIn((i+1)*kNumLanes*5-1 downto i*kNumLanes*5)
      --vhook_a gt_txpolarity        tTxPolarityIn((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_txinhibit         (others => '0')
      --vhook_a gt_txpmareset        aTxPmaResetIn((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_txpcsreset        aTxPcsResetIn((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_txprbssel         tGtwizTxPrbsSelIn((i+1)*kNumLanes*4-1 downto i*kNumLanes*4)
      --vhook_a gt_txprbsforceerr    tTxPrbsForceErrIn ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_txbufstatus       open
      --vhook_a gt_txresetdone       tTxResetDoneOut   ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_pcsrsvdin         (others => '0')
      --vhook_a gt_powergood         aGtPowerGoodOut((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_dmonitorout       aGtwizDMonitorOut((i+1)*kNumLanes*16-1 downto i*kNumLanes*16)
      --vhook_a gt_cplllock          aCpllLockOut ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_qplllock          open
      Aurora_PortN: aurora64b66b_framing_crcx4_28p0GHz
        port map (
          s_axi_tx_tdata              => uPortAxiRegTxTData (i),                                          --in  STD_LOGIC_VECTOR(255:0)
          s_axi_tx_tlast              => uPortAxiRegTxTLast (i),                                          --in  STD_LOGIC
          s_axi_tx_tkeep              => uPortAxiRegTxTKeep (i),                                          --in  STD_LOGIC_VECTOR(31:0)
          s_axi_tx_tvalid             => uPortAxiRegTxTValid(i),                                          --in  STD_LOGIC
          s_axi_tx_tready             => uPortAxiRegTxTReady(i),                                          --out STD_LOGIC
          m_axi_rx_tdata              => uPortAxiRxTData (i),                                             --out STD_LOGIC_VECTOR(255:0)
          m_axi_rx_tlast              => uPortAxiRxTLast (i),                                             --out STD_LOGIC
          m_axi_rx_tkeep              => uPortAxiRxTKeep (i),                                             --out STD_LOGIC_VECTOR(31:0)
          m_axi_rx_tvalid             => uPortAxiRxTValid(i),                                             --out STD_LOGIC
          s_axi_nfc_tvalid            => uPortAxiNfcTValid(i),                                            --in  STD_LOGIC
          s_axi_nfc_tdata             => uPortAxiNfcTData (i)(15 downto 0),                               --in  STD_LOGIC_VECTOR(15:0)
          s_axi_nfc_tready            => uPortAxiNfcTReady(i),                                            --out STD_LOGIC
          rxp                         => PortRx_p(i*4 to i*4+3),                                          --in  STD_LOGIC_VECTOR(0:3)
          rxn                         => PortRx_n(i*4 to i*4+3),                                          --in  STD_LOGIC_VECTOR(0:3)
          txp                         => PortTx_p(i*4 to i*4+3),                                          --out STD_LOGIC_VECTOR(0:3)
          txn                         => PortTx_n(i*4 to i*4+3),                                          --out STD_LOGIC_VECTOR(0:3)
          refclk1_in                  => MgtRefClk(i),                                                    --in  STD_LOGIC
          hard_err                    => uPortHardErr (i),                                                --out STD_LOGIC
          soft_err                    => uPortSoftErr (i),                                                --out STD_LOGIC
          channel_up                  => uPortChannelUp(i),                                               --out STD_LOGIC
          lane_up                     => uPortLaneUpRev(i),                                               --out STD_LOGIC_VECTOR(0:3)
          crc_pass_fail_n             => uPortCrcPassFail_n(i),                                           --out STD_LOGIC
          crc_valid                   => uPortCrcValid(i),                                                --out STD_LOGIC
          user_clk_out                => UserClkPort(i),                                                  --out STD_LOGIC
          mmcm_not_locked_out         => uPortMmcmNotLocked(i),                                           --out STD_LOGIC
          sync_clk_out                => SyncClkPort(i),                                                  --out STD_LOGIC
          reset_pb                    => aPortResetPb(i),                                                 --in  STD_LOGIC
          gt_rxcdrovrden_in           => aRxCdrOvrdEnIn (i*kNumLanes),                                    --in  STD_LOGIC
          power_down                  => '0',                                                             --in  STD_LOGIC
          loopback                    => aLoopbackIn(i*kNumLanes),                                        --in  STD_LOGIC_VECTOR(2:0)
          pma_init                    => aPortPmaInit(i),                                                 --in  STD_LOGIC
          gt_pll_lock                 => open,                                                            --out STD_LOGIC
          gt0_drpaddr                 => iGtwizDrpAddrIn((i*4+1)*kAddrSize-1 downto (i*4+0)*kAddrSize),   --in  STD_LOGIC_VECTOR(9:0)
          gt0_drpdi                   => iGtwizDrpDiIn ((i*4+1)*16-1 downto (i*4+0)*16),                  --in  STD_LOGIC_VECTOR(15:0)
          gt0_drpdo                   => iGtwizDrpDoOut ((i*4+1)*16-1 downto (i*4+0)*16),                 --out STD_LOGIC_VECTOR(15:0)
          gt0_drprdy                  => iGtwizDrpRdyOut (i*4+0),                                         --out STD_LOGIC
          gt0_drpen                   => iGtwizDrpEnIn (i*4+0),                                           --in  STD_LOGIC
          gt0_drpwe                   => iGtwizDrpWeIn (i*4+0),                                           --in  STD_LOGIC
          gt1_drpaddr                 => iGtwizDrpAddrIn((i*4+2)*kAddrSize-1 downto (i*4+1)*kAddrSize),   --in  STD_LOGIC_VECTOR(9:0)
          gt1_drpdi                   => iGtwizDrpDiIn ((i*4+2)*16-1 downto (i*4+1)*16),                  --in  STD_LOGIC_VECTOR(15:0)
          gt1_drpdo                   => iGtwizDrpDoOut ((i*4+2)*16-1 downto (i*4+1)*16),                 --out STD_LOGIC_VECTOR(15:0)
          gt1_drprdy                  => iGtwizDrpRdyOut (i*4+1),                                         --out STD_LOGIC
          gt1_drpen                   => iGtwizDrpEnIn (i*4+1),                                           --in  STD_LOGIC
          gt1_drpwe                   => iGtwizDrpWeIn (i*4+1),                                           --in  STD_LOGIC
          gt2_drpaddr                 => iGtwizDrpAddrIn((i*4+3)*kAddrSize-1 downto (i*4+2)*kAddrSize),   --in  STD_LOGIC_VECTOR(9:0)
          gt2_drpdi                   => iGtwizDrpDiIn ((i*4+3)*16-1 downto (i*4+2)*16),                  --in  STD_LOGIC_VECTOR(15:0)
          gt2_drpdo                   => iGtwizDrpDoOut ((i*4+3)*16-1 downto (i*4+2)*16),                 --out STD_LOGIC_VECTOR(15:0)
          gt2_drprdy                  => iGtwizDrpRdyOut (i*4+2),                                         --out STD_LOGIC
          gt2_drpen                   => iGtwizDrpEnIn (i*4+2),                                           --in  STD_LOGIC
          gt2_drpwe                   => iGtwizDrpWeIn (i*4+2),                                           --in  STD_LOGIC
          gt3_drpaddr                 => iGtwizDrpAddrIn((i*4+4)*kAddrSize-1 downto (i*4+3)*kAddrSize),   --in  STD_LOGIC_VECTOR(9:0)
          gt3_drpdi                   => iGtwizDrpDiIn ((i*4+4)*16-1 downto (i*4+3)*16),                  --in  STD_LOGIC_VECTOR(15:0)
          gt3_drpdo                   => iGtwizDrpDoOut ((i*4+4)*16-1 downto (i*4+3)*16),                 --out STD_LOGIC_VECTOR(15:0)
          gt3_drprdy                  => iGtwizDrpRdyOut (i*4+3),                                         --out STD_LOGIC
          gt3_drpen                   => iGtwizDrpEnIn (i*4+3),                                           --in  STD_LOGIC
          gt3_drpwe                   => iGtwizDrpWeIn (i*4+3),                                           --in  STD_LOGIC
          init_clk                    => InitClk,                                                         --in  STD_LOGIC
          link_reset_out              => iPortLinkResetOut(i),                                            --out STD_LOGIC
          gt_rxusrclk_out             => RxUserClk2Port(i),                                               --out STD_LOGIC
          gt_eyescandataerror         => open,                                                            --out STD_LOGIC_VECTOR(3:0)
          gt_eyescanreset             => aEyeScanResetIn((i+1)*kNumLanes-1 downto i*kNumLanes),           --in  STD_LOGIC_VECTOR(3:0)
          gt_eyescantrigger           => (others => '0'),                                                 --in  STD_LOGIC_VECTOR(3:0)
          gt_rxcdrhold                => aRxCdrHoldIn ((i+1)*kNumLanes-1 downto i*kNumLanes),             --in  STD_LOGIC_VECTOR(3:0)
          gt_rxdfelpmreset            => (others => '0'),                                                 --in  STD_LOGIC_VECTOR(3:0)
          gt_rxlpmen                  => rRxLpmEnIn ((i+1)*kNumLanes-1 downto i*kNumLanes),               --in  STD_LOGIC_VECTOR(3:0)
          gt_rxpmareset               => aRxPmaResetIn ((i+1)*kNumLanes-1 downto i*kNumLanes),            --in  STD_LOGIC_VECTOR(3:0)
          gt_rxpcsreset               => (others => '0'),                                                 --in  STD_LOGIC_VECTOR(3:0)
          gt_rxrate                   => rGtwizRxRateIn((i+1)*kNumLanes*3-1 downto i*kNumLanes*3),        --in  STD_LOGIC_VECTOR(11:0)
          gt_rxbufreset               => (others => '0'),                                                 --in  STD_LOGIC_VECTOR(3:0)
          gt_rxpmaresetdone           => aGtRxPmaResetDone((i+1)*kNumLanes-1 downto i*kNumLanes),         --out STD_LOGIC_VECTOR(3:0)
          gt_rxprbssel                => rGtwizRxPrbsSelIn((i+1)*kNumLanes*4-1 downto i*kNumLanes*4),     --in  STD_LOGIC_VECTOR(15:0)
          gt_rxprbserr                => rRxPrbsErrOut ((i+1)*kNumLanes-1 downto i*kNumLanes),            --out STD_LOGIC_VECTOR(3:0)
          gt_rxprbscntreset           => rRxPrbsCntResetIn ((i+1)*kNumLanes-1 downto i*kNumLanes),        --in  STD_LOGIC_VECTOR(3:0)
          gt_rxresetdone              => rRxResetDoneOut ((i+1)*kNumLanes-1 downto i*kNumLanes),          --out STD_LOGIC_VECTOR(3:0)
          gt_rxbufstatus              => open,                                                            --out STD_LOGIC_VECTOR(11:0)
          gt_txpostcursor             => aGtwizTxPostCursorIn((i+1)*kNumLanes*5-1 downto i*kNumLanes*5),  --in  STD_LOGIC_VECTOR(19:0)
          gt_txdiffctrl               => tGtwizTxDiffCtrlIn ((i+1)*kNumLanes*5-1 downto i*kNumLanes*5),   --in  STD_LOGIC_VECTOR(19:0)
          gt_txprecursor              => aGtwizTxPreCursorIn ((i+1)*kNumLanes*5-1 downto i*kNumLanes*5),  --in  STD_LOGIC_VECTOR(19:0)
          gt_txpolarity               => tTxPolarityIn((i+1)*kNumLanes-1 downto i*kNumLanes),             --in  STD_LOGIC_VECTOR(3:0)
          gt_txinhibit                => (others => '0'),                                                 --in  STD_LOGIC_VECTOR(3:0)
          gt_txpmareset               => aTxPmaResetIn((i+1)*kNumLanes-1 downto i*kNumLanes),             --in  STD_LOGIC_VECTOR(3:0)
          gt_txpcsreset               => aTxPcsResetIn((i+1)*kNumLanes-1 downto i*kNumLanes),             --in  STD_LOGIC_VECTOR(3:0)
          gt_txprbssel                => tGtwizTxPrbsSelIn((i+1)*kNumLanes*4-1 downto i*kNumLanes*4),     --in  STD_LOGIC_VECTOR(15:0)
          gt_txprbsforceerr           => tTxPrbsForceErrIn ((i+1)*kNumLanes-1 downto i*kNumLanes),        --in  STD_LOGIC_VECTOR(3:0)
          gt_txbufstatus              => open,                                                            --out STD_LOGIC_VECTOR(7:0)
          gt_txresetdone              => tTxResetDoneOut ((i+1)*kNumLanes-1 downto i*kNumLanes),          --out STD_LOGIC_VECTOR(3:0)
          gt_pcsrsvdin                => (others => '0'),                                                 --in  STD_LOGIC_VECTOR(63:0)
          gt_dmonitorout              => aGtwizDMonitorOut((i+1)*kNumLanes*16-1 downto i*kNumLanes*16),   --out STD_LOGIC_VECTOR(63:0)
          gt_cplllock                 => aCpllLockOut ((i+1)*kNumLanes-1 downto i*kNumLanes),             --out STD_LOGIC_VECTOR(3:0)
          gt_qplllock                 => open,                                                            --out STD_LOGIC
          gt_powergood                => aGtPowerGoodOut((i+1)*kNumLanes-1 downto i*kNumLanes),           --out STD_LOGIC_VECTOR(3:0)
          gt_qpllclk_quad1_out        => open,                                                            --out STD_LOGIC
          gt_qpllrefclk_quad1_out     => open,                                                            --out STD_LOGIC
          gt_qplllock_quad1_out       => aQpll0LockOut(i),                                                --out STD_LOGIC
          gt_qpllrefclklost_quad1_out => aQpll0RefClkLostOut(i),                                          --out STD_LOGIC
          sys_reset_out               => uPortSysResetOut (i),                                            --out STD_LOGIC
          gt_reset_out                => open,                                                            --out STD_LOGIC
          tx_out_clk                  => open);                                                           --out STD_LOGIC
    end generate;
  end block AuroraBlock;
end rtl;
