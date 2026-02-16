------------------------------------------------------------------------------
--
-- File: PkgTheWindowFlatWrapper.vhd
-- Author: Auto-generated wrapper
-- Original Project: FlexRIO
-- Date: 2 January 2026
--
------------------------------------------------------------------------------
-- (c) 2026 Copyright National Instruments Corporation
--
-- SPDX-License-Identifier: MIT
------------------------------------------------------------------------------
--
-- Purpose: This wrapper flattens all record-type ports of TheWindow to
--          std_logic_vector ports for compatibility.
--
------------------------------------------------------------------------------
-- githubvisible=true

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

Library work;
  use work.PkgNiUtilities.all;
  use work.PkgCommIntConfiguration.all;
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;
  use work.PkgDmaPortDmaFifos.all;
  use work.PkgDmaPortDmaFifosFlatTypes.all;
  use work.PkgDmaPortCommIfcMasterPort.all;
  use work.PkgDmaPortCommIfcMasterPortFlatTypes.all;

package PkgTheWindowFlatWrapper is

  component TheWindowFlatWrapper is
    port(
      -----------------------------------
      -- CUSTOM BOARD IO
      -----------------------------------
  % if include_custom_io:
  % for signal in custom_signals:
      ${signal['name']} : ${signal['direction']} ${signal['type']}; -- ${signal['name']}
  % endfor
  % endif

      -----------------------------------
      -- Communication interface ports
      -----------------------------------
      -- Reset ports
      aBusReset : in std_logic;

      -- Register Access/ PIO Ports
      bRegPortIn : in std_logic_vector(kRegPortInSize-1 downto 0);
      bRegPortOut : out std_logic_vector(kRegPortOutSize-1 downto 0);
      bRegPortTimeout : in std_logic;

      -- DMA Stream Ports
      dInputStreamInterfaceToFifo : in std_logic_vector(
        Larger(kNumberOfDmaChannels,1)*SizeOf(kInputStreamInterfaceToFifoZero)-1 downto 0);
      dInputStreamInterfaceFromFifo : out std_logic_vector(
        Larger(kNumberOfDmaChannels,1)*SizeOf(kInputStreamInterfaceFromFifoZero)-1 downto 0);
      dOutputStreamInterfaceToFifo : in std_logic_vector(
        Larger(kNumberOfDmaChannels,1)*SizeOf(kOutputStreamInterfaceToFifoZero)-1 downto 0);
      dOutputStreamInterfaceFromFifo : out std_logic_vector(
        Larger(kNumberOfDmaChannels,1)*SizeOf(kOutputStreamInterfaceFromFifoZero)-1 downto 0);

      -- Memory Buffer DMA Stream Ports (if any)

      -- IRQ Ports
      bIrqToInterface : out std_logic_vector(
        Larger(kNumberOfIrqs,1)*kIrqToInterfaceSize*kIrqStatusToInterfaceSize-1 downto 0);

      -- MasterPort Ports
      dNiFpgaMasterWriteRequestFromMaster : out std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterWriteRequestFromMasterZero)-1 downto 0);
      dNiFpgaMasterWriteRequestToMaster : in std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterWriteRequestToMasterZero)-1 downto 0);
      dNiFpgaMasterWriteDataFromMaster : out std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterWriteDataFromMasterZero)-1 downto 0);
      dNiFpgaMasterWriteDataToMaster : in std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterWriteDataToMasterZero)-1 downto 0);
      dNiFpgaMasterWriteStatusToMaster : in std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterWriteStatusToMasterZero)-1 downto 0);

      dNiFpgaMasterReadRequestFromMaster : out std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterReadRequestFromMasterZero)-1 downto 0);
      dNiFpgaMasterReadRequestToMaster : in std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterReadRequestToMasterZero)-1 downto 0);
      dNiFpgaMasterReadDataToMaster : in std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterReadDataToMasterZero)-1 downto 0);

      -----------------------------------
      -- Clocks from TopLevel
      -----------------------------------
      DmaClk :  in std_logic;
      BusClk :  in std_logic;
      ReliableClkIn :  in std_logic;
      PllClk80 :  in std_logic;
      DlyRefClk :  in std_logic;
      PxieClk100 :  in std_logic;
      DramClkLvFpga :  in std_logic;
      Dram0ClkSocket :  in std_logic;
      Dram1ClkSocket :  in std_logic;
      Dram0ClkUser :  in std_logic;
      Dram1ClkUser :  in std_logic;
      dHmbDmaClkSocket :  in std_logic;
      dLlbDmaClkSocket :  in std_logic;

      -----------------------------------
      -- IO Node ports
      -----------------------------------
      pIntSync100 : in std_logic;
      aIntClk10 : in std_logic;

      -----------------------------------
      -- Target Method and Properties ports
      -----------------------------------
      bdIFifoRdData : out  std_logic_vector(63 downto 0);
      bdIFifoRdDataValid : out std_logic;
      bdIFifoRdReadyForInput : in std_logic;
      bdIFifoRdIsError : out std_logic;
      bdIFifoWrData : in  std_logic_vector(63 downto 0);
      bdIFifoWrDataValid : in std_logic;
      bdIFifoWrReadyForOutput : out std_logic;
      bdAxiStreamRdFromClipTData : in  std_logic_vector(31 downto 0);
      bdAxiStreamRdFromClipTLast : in std_logic;
      bdAxiStreamRdFromClipTValid : in std_logic;
      bdAxiStreamRdToClipTReady : out std_logic;
      bdAxiStreamWrToClipTData : out  std_logic_vector(31 downto 0);
      bdAxiStreamWrToClipTLast : out std_logic;
      bdAxiStreamWrToClipTValid : out std_logic;
      bdAxiStreamWrFromClipTReady : in std_logic;

      -----------------------------------
      -- Pass through LabVIEW FPGA ports
      -----------------------------------

      ----------------------------------------
      -- Trigger Routing Socketed CLIP
      ----------------------------------------
      PxieClk100Trigger : in std_logic;
      pIntSync100Trigger : in std_logic;
      dDevClkEn : in std_logic;
      aIntClk10Trigger : in std_logic;
      bRoutingClipPresent : out std_logic;
      bRoutingClipNiCompatible : out std_logic;
      BusClkTrigger : in std_logic;
      abBusResetTrigger : in std_logic;
      bTriggerRoutingBaRegPortInAddress : in std_logic_vector(27 downto 0);
      bTriggerRoutingBaRegPortInData : in std_logic_vector(63 downto 0);
      bTriggerRoutingBaRegPortInWtStrobe : in std_logic_vector(7 downto 0);
      bTriggerRoutingBaRegPortInRdStrobe : in std_logic_vector(7 downto 0);
      bTriggerRoutingBaRegPortOutData : out std_logic_vector(63 downto 0);
      bTriggerRoutingBaRegPortOutAck : out std_logic;
      aPxiTrigDataIn : in  std_logic_vector(7 downto 0);
      aPxiTrigDataOut : out std_logic_vector(7 downto 0);
      aPxiTrigDataTri : out std_logic_vector(7 downto 0);
      aPxiStarData : in std_logic;
      aPxieDstarB : in std_logic;
      aPxieDstarC : out std_logic;

  % if include_clip_socket:
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
  % endif

      -----------------------------------------------------------------------------
      --Dram Interface
      -----------------------------------------------------------------------------
      aDramReady : in std_logic;
      du0DramAddrFifoAddr : out std_logic_vector(29 downto 0);
      du0DramAddrFifoCmd : out std_logic_vector(2 downto 0);
      du0DramAddrFifoFull : in std_logic;
      du0DramAddrFifoWrEn : out std_logic;
      du0DramPhyInitDone : in std_logic;
      du0DramRdDataValid : in std_logic;
      du0DramRdFifoDataOut : in std_logic_vector(639 downto 0);
      du0DramWrFifoDataIn : out std_logic_vector(639 downto 0);
      du0DramWrFifoFull : in std_logic;
      du0DramWrFifoMaskData : out std_logic_vector(79 downto 0);
      du0DramWrFifoWrEn : out std_logic;
      du1DramAddrFifoAddr : out std_logic_vector(29 downto 0);
      du1DramAddrFifoCmd : out std_logic_vector(2 downto 0);
      du1DramAddrFifoFull : in std_logic;
      du1DramAddrFifoWrEn : out std_logic;
      du1DramPhyInitDone : in std_logic;
      du1DramRdDataValid : in std_logic;
      du1DramRdFifoDataOut : in std_logic_vector(639 downto 0);
      du1DramWrFifoDataIn : out std_logic_vector(639 downto 0);
      du1DramWrFifoFull : in std_logic;
      du1DramWrFifoMaskData : out std_logic_vector(79 downto 0);
      du1DramWrFifoWrEn : out std_logic;

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
      rBaseClksValid : in std_logic := '1';
      tDiagramActive : out std_logic;
      rDiagramReset : out std_logic;
      aDiagramReset : out std_logic;
      rDerivedClockLostLockError : out std_logic;
      rGatedBaseClksValid : in std_logic := '1';
      aSafeToEnableGatedClks : out std_logic
    );
  end component;

end package PkgTheWindowFlatWrapper;