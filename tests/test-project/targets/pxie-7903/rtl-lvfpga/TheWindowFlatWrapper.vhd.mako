------------------------------------------------------------------------------
--
-- File: TheWindowFlatWrapper.vhd
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

entity TheWindowFlatWrapper is
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
end entity TheWindowFlatWrapper;

architecture behavioral of TheWindowFlatWrapper is

  -- Std logic to boolean
  signal aBusResetBool : boolean;
  signal bRegPortTimeoutBool : boolean;

  -- Internal signals for record types
  signal bRegPortInInternal : RegPortIn_t;
  signal bRegPortOutInternal : RegPortOut_t;

  signal dInputStreamInterfaceToFifoInternal : InputStreamInterfaceToFifoArray_t(
    Larger(kNumberOfDmaChannels,1)-1 downto 0);
  signal dInputStreamInterfaceFromFifoInternal : InputStreamInterfaceFromFifoArray_t(
    Larger(kNumberOfDmaChannels,1)-1 downto 0);
  signal dOutputStreamInterfaceToFifoInternal : OutputStreamInterfaceToFifoArray_t(
    Larger(kNumberOfDmaChannels,1)-1 downto 0);
  signal dOutputStreamInterfaceFromFifoInternal : OutputStreamInterfaceFromFifoArray_t(
    Larger(kNumberOfDmaChannels,1)-1 downto 0);
  
  signal bIrqToInterfaceInternal : IrqToInterfaceArray_t(
    Larger(kNumberOfIrqs,1)-1 downto 0);
  
  signal dNiFpgaMasterWriteRequestFromMasterInternal : 
    NiFpgaMasterWriteRequestFromMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
  signal dNiFpgaMasterWriteRequestToMasterInternal : 
    NiFpgaMasterWriteRequestToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
  signal dNiFpgaMasterWriteDataFromMasterInternal : 
    NiFpgaMasterWriteDataFromMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
  signal dNiFpgaMasterWriteDataToMasterInternal : 
    NiFpgaMasterWriteDataToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
  signal dNiFpgaMasterWriteStatusToMasterInternal : 
    NiFpgaMasterWriteStatusToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
  
  signal dNiFpgaMasterReadRequestFromMasterInternal : 
    NiFpgaMasterReadRequestFromMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
  signal dNiFpgaMasterReadRequestToMasterInternal : 
    NiFpgaMasterReadRequestToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
  signal dNiFpgaMasterReadDataToMasterInternal : 
    NiFpgaMasterReadDataToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);

begin

  ----------------------------------
  -- Convert std_logic to boolean
  ----------------------------------
  aBusResetBool <= aBusReset = '1';
  bRegPortTimeoutBool <= bRegPortTimeout = '1';

  -----------------------------------
  -- Convert flat inputs to records
  -----------------------------------
  bRegPortInInternal <= BuildRegPortIn(bRegPortIn);
  
  dInputStreamInterfaceToFifoInternal <= UnflattenStreamInterface(dInputStreamInterfaceToFifo);
  dOutputStreamInterfaceToFifoInternal <= UnflattenStreamInterface(dOutputStreamInterfaceToFifo);
  
  -- Convert flat Master Port inputs
  gen_master_inputs: for i in 0 to Larger(kNumberOfMasterPorts,1)-1 generate
    dNiFpgaMasterWriteRequestToMasterInternal(i) <= 
      UnflattenMasterPortInterface(
        NiFpgaMasterWriteRequestToMasterFlat_t(
          dNiFpgaMasterWriteRequestToMaster(
            (i+1)*SizeOf(kNiFpgaMasterWriteRequestToMasterZero)-1 downto 
            i*SizeOf(kNiFpgaMasterWriteRequestToMasterZero))));
    
    dNiFpgaMasterWriteDataToMasterInternal(i) <= 
      UnflattenMasterPortInterface(
        NiFpgaMasterWriteDataToMasterFlat_t(
          dNiFpgaMasterWriteDataToMaster(
            (i+1)*SizeOf(kNiFpgaMasterWriteDataToMasterZero)-1 downto 
            i*SizeOf(kNiFpgaMasterWriteDataToMasterZero))));
    
    dNiFpgaMasterWriteStatusToMasterInternal(i) <= 
      UnflattenMasterPortInterface(
        NiFpgaMasterWriteStatusToMasterFlat_t(
          dNiFpgaMasterWriteStatusToMaster(
            (i+1)*SizeOf(kNiFpgaMasterWriteStatusToMasterZero)-1 downto 
            i*SizeOf(kNiFpgaMasterWriteStatusToMasterZero))));
    
    dNiFpgaMasterReadRequestToMasterInternal(i) <= 
      UnflattenMasterPortInterface(
        NiFpgaMasterReadRequestToMasterFlat_t(
          dNiFpgaMasterReadRequestToMaster(
            (i+1)*SizeOf(kNiFpgaMasterReadRequestToMasterZero)-1 downto 
            i*SizeOf(kNiFpgaMasterReadRequestToMasterZero))));
    
    dNiFpgaMasterReadDataToMasterInternal(i) <= 
      UnflattenMasterPortInterface(
        NiFpgaMasterReadDataToMasterFlat_t(
          dNiFpgaMasterReadDataToMaster(
            (i+1)*SizeOf(kNiFpgaMasterReadDataToMasterZero)-1 downto 
            i*SizeOf(kNiFpgaMasterReadDataToMasterZero))));
  end generate;


  -----------------------------------
  -- Convert record outputs to flat
  -----------------------------------
  bRegPortOut <= to_StdLogicVector(bRegPortOutInternal);
  
  dInputStreamInterfaceFromFifo <= FlattenStreamInterface(dInputStreamInterfaceFromFifoInternal);
  dOutputStreamInterfaceFromFifo <= FlattenStreamInterface(dOutputStreamInterfaceFromFifoInternal);
  
  bIrqToInterface <= to_StdLogicVector(bIrqToInterfaceInternal);
  
  -- Convert flat Master Port outputs
  gen_master_outputs: for i in 0 to Larger(kNumberOfMasterPorts,1)-1 generate
    dNiFpgaMasterWriteRequestFromMaster(
      (i+1)*SizeOf(kNiFpgaMasterWriteRequestFromMasterZero)-1 downto 
      i*SizeOf(kNiFpgaMasterWriteRequestFromMasterZero)) <= 
        std_logic_vector(FlattenMasterPortInterface(dNiFpgaMasterWriteRequestFromMasterInternal(i)));
    
    dNiFpgaMasterWriteDataFromMaster(
      (i+1)*SizeOf(kNiFpgaMasterWriteDataFromMasterZero)-1 downto 
      i*SizeOf(kNiFpgaMasterWriteDataFromMasterZero)) <= 
        std_logic_vector(FlattenMasterPortInterface(dNiFpgaMasterWriteDataFromMasterInternal(i)));
    
    dNiFpgaMasterReadRequestFromMaster(
      (i+1)*SizeOf(kNiFpgaMasterReadRequestFromMasterZero)-1 downto 
      i*SizeOf(kNiFpgaMasterReadRequestFromMasterZero)) <= 
        std_logic_vector(FlattenMasterPortInterface(dNiFpgaMasterReadRequestFromMasterInternal(i)));
  end generate;

  -----------------------------------
  -- Instantiate TheWindow
  -----------------------------------
  SasquatchWindow : entity work.TheWindow (behavioral)
    port map(
     -----------------------------------
    -- CUSTOM BOARD IO
    -----------------------------------
% if include_custom_io:
% for signal in custom_signals:
    ${signal['name']} => ${signal['name']},
% endfor
% endif      
      -----------------------------------
      -- Communication interface ports
      -----------------------------------
      aBusReset => aBusResetBool,
      bRegPortIn => bRegPortInInternal,
      bRegPortOut => bRegPortOutInternal,
      bRegPortTimeout => bRegPortTimeoutBool,
      dInputStreamInterfaceToFifo => dInputStreamInterfaceToFifoInternal,
      dInputStreamInterfaceFromFifo => dInputStreamInterfaceFromFifoInternal,
      dOutputStreamInterfaceToFifo => dOutputStreamInterfaceToFifoInternal,
      dOutputStreamInterfaceFromFifo => dOutputStreamInterfaceFromFifoInternal,
      bIrqToInterface => bIrqToInterfaceInternal,
      dNiFpgaMasterWriteRequestFromMaster => dNiFpgaMasterWriteRequestFromMasterInternal,
      dNiFpgaMasterWriteRequestToMaster => dNiFpgaMasterWriteRequestToMasterInternal,
      dNiFpgaMasterWriteDataFromMaster => dNiFpgaMasterWriteDataFromMasterInternal,
      dNiFpgaMasterWriteDataToMaster => dNiFpgaMasterWriteDataToMasterInternal,
      dNiFpgaMasterWriteStatusToMaster => dNiFpgaMasterWriteStatusToMasterInternal,
      dNiFpgaMasterReadRequestFromMaster => dNiFpgaMasterReadRequestFromMasterInternal,
      dNiFpgaMasterReadRequestToMaster => dNiFpgaMasterReadRequestToMasterInternal,
      dNiFpgaMasterReadDataToMaster => dNiFpgaMasterReadDataToMasterInternal,
      
      -----------------------------------
      -- Clocks from TopLevel
      -----------------------------------
      DmaClk => DmaClk,
      BusClk => BusClk,
      ReliableClkIn => ReliableClkIn,
      PllClk80 => PllClk80,
      DlyRefClk => DlyRefClk,
      PxieClk100 => PxieClk100,
      DramClkLvFpga => DramClkLvFpga,
      Dram0ClkSocket => Dram0ClkSocket,
      Dram1ClkSocket => Dram1ClkSocket,
      Dram0ClkUser => Dram0ClkUser,
      Dram1ClkUser => Dram1ClkUser,
      dHmbDmaClkSocket => dHmbDmaClkSocket,
      dLlbDmaClkSocket => dLlbDmaClkSocket,
      
      -----------------------------------
      -- IO Node ports
      -----------------------------------
      pIntSync100 => pIntSync100,
      aIntClk10 => aIntClk10,

      -----------------------------------
      -- Target Method and Properties ports
      -----------------------------------
      bdIFifoRdData => bdIFifoRdData,
      bdIFifoRdDataValid => bdIFifoRdDataValid,
      bdIFifoRdReadyForInput => bdIFifoRdReadyForInput,
      bdIFifoRdIsError => bdIFifoRdIsError,
      bdIFifoWrData => bdIFifoWrData,
      bdIFifoWrDataValid => bdIFifoWrDataValid,
      bdIFifoWrReadyForOutput => bdIFifoWrReadyForOutput,
      bdAxiStreamRdFromClipTData => bdAxiStreamRdFromClipTData,
      bdAxiStreamRdFromClipTLast => bdAxiStreamRdFromClipTLast,
      bdAxiStreamRdFromClipTValid => bdAxiStreamRdFromClipTValid,
      bdAxiStreamRdToClipTReady => bdAxiStreamRdToClipTReady,
      bdAxiStreamWrToClipTData => bdAxiStreamWrToClipTData,
      bdAxiStreamWrToClipTLast => bdAxiStreamWrToClipTLast,
      bdAxiStreamWrToClipTValid => bdAxiStreamWrToClipTValid,
      bdAxiStreamWrFromClipTReady => bdAxiStreamWrFromClipTReady,

      -----------------------------------
      -- Pass through LabVIEW FPGA ports
      -----------------------------------

      ----------------------------------------
      -- Trigger Routing Socketed CLIP
      ----------------------------------------
      PxieClk100Trigger => PxieClk100Trigger,
      pIntSync100Trigger => pIntSync100Trigger,
      dDevClkEn => dDevClkEn,
      aIntClk10Trigger => aIntClk10Trigger,
      bRoutingClipPresent => bRoutingClipPresent,
      bRoutingClipNiCompatible => bRoutingClipNiCompatible,
      BusClkTrigger => BusClkTrigger,
      abBusResetTrigger => abBusResetTrigger,
      bTriggerRoutingBaRegPortInAddress => bTriggerRoutingBaRegPortInAddress,
      bTriggerRoutingBaRegPortInData => bTriggerRoutingBaRegPortInData,
      bTriggerRoutingBaRegPortInWtStrobe => bTriggerRoutingBaRegPortInWtStrobe,
      bTriggerRoutingBaRegPortInRdStrobe => bTriggerRoutingBaRegPortInRdStrobe,
      bTriggerRoutingBaRegPortOutData => bTriggerRoutingBaRegPortOutData,
      bTriggerRoutingBaRegPortOutAck => bTriggerRoutingBaRegPortOutAck,
      aPxiTrigDataIn => aPxiTrigDataIn,
      aPxiTrigDataOut => aPxiTrigDataOut,
      aPxiTrigDataTri => aPxiTrigDataTri,
      aPxiStarData => aPxiStarData,
      aPxieDstarB => aPxieDstarB,
      aPxieDstarC => aPxieDstarC,

% if include_clip_socket:
      -----------------------------------
      -- CLIP Socket ports
      -----------------------------------
      AxiClk => AxiClk,
      xDiagramAxiStreamFromClipTData => xDiagramAxiStreamFromClipTData,
      xDiagramAxiStreamFromClipTLast => xDiagramAxiStreamFromClipTLast,
      xDiagramAxiStreamFromClipTReady => xDiagramAxiStreamFromClipTReady,
      xDiagramAxiStreamFromClipTValid => xDiagramAxiStreamFromClipTValid,
      xDiagramAxiStreamToClipTData => xDiagramAxiStreamToClipTData,
      xDiagramAxiStreamToClipTLast => xDiagramAxiStreamToClipTLast,
      xDiagramAxiStreamToClipTReady => xDiagramAxiStreamToClipTReady,
      xDiagramAxiStreamToClipTValid => xDiagramAxiStreamToClipTValid,
      xHostAxiStreamFromClipTData => xHostAxiStreamFromClipTData,
      xHostAxiStreamFromClipTLast => xHostAxiStreamFromClipTLast,
      xHostAxiStreamFromClipTReady => xHostAxiStreamFromClipTReady,
      xHostAxiStreamFromClipTValid => xHostAxiStreamFromClipTValid,
      xHostAxiStreamToClipTData => xHostAxiStreamToClipTData,
      xHostAxiStreamToClipTLast => xHostAxiStreamToClipTLast,
      xHostAxiStreamToClipTReady => xHostAxiStreamToClipTReady,
      xHostAxiStreamToClipTValid => xHostAxiStreamToClipTValid,
      xClipAxi4LiteMasterARAddr => xClipAxi4LiteMasterARAddr,
      xClipAxi4LiteMasterARProt => xClipAxi4LiteMasterARProt,
      xClipAxi4LiteMasterARReady => xClipAxi4LiteMasterARReady,
      xClipAxi4LiteMasterARValid => xClipAxi4LiteMasterARValid,
      xClipAxi4LiteMasterAWAddr => xClipAxi4LiteMasterAWAddr,
      xClipAxi4LiteMasterAWProt => xClipAxi4LiteMasterAWProt,
      xClipAxi4LiteMasterAWReady => xClipAxi4LiteMasterAWReady,
      xClipAxi4LiteMasterAWValid => xClipAxi4LiteMasterAWValid,
      xClipAxi4LiteMasterBReady => xClipAxi4LiteMasterBReady,
      xClipAxi4LiteMasterBResp => xClipAxi4LiteMasterBResp,
      xClipAxi4LiteMasterBValid => xClipAxi4LiteMasterBValid,
      xClipAxi4LiteMasterRData => xClipAxi4LiteMasterRData,
      xClipAxi4LiteMasterRReady => xClipAxi4LiteMasterRReady,
      xClipAxi4LiteMasterRResp => xClipAxi4LiteMasterRResp,
      xClipAxi4LiteMasterRValid => xClipAxi4LiteMasterRValid,
      xClipAxi4LiteMasterWData => xClipAxi4LiteMasterWData,
      xClipAxi4LiteMasterWReady => xClipAxi4LiteMasterWReady,
      xClipAxi4LiteMasterWStrb => xClipAxi4LiteMasterWStrb,
      xClipAxi4LiteMasterWValid => xClipAxi4LiteMasterWValid,
      xClipAxi4LiteInterrupt => xClipAxi4LiteInterrupt,
      stIoModuleSupportsFRAGLs => stIoModuleSupportsFRAGLs,
      MgtRefClk_p => MgtRefClk_p,
      MgtRefClk_n => MgtRefClk_n,
      MgtPortRx_p => MgtPortRx_p,
      MgtPortRx_n => MgtPortRx_n,
      MgtPortTx_p => MgtPortTx_p,
      MgtPortTx_n => MgtPortTx_n,
      aDio => aDio,
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
      aIPassVccPowerFault_n => aIPassVccPowerFault_n,
      aIPassPrsnt_n => aIPassPrsnt_n,
      aIPassIntr_n => aIPassIntr_n,
      aIPassSCL => aIPassSCL,
      aIPassSDA => aIPassSDA,
      aPortExpReset_n => aPortExpReset_n,
      aPortExpIntr_n => aPortExpIntr_n,
      aPortExpSda => aPortExpSda,
      aPortExpScl => aPortExpScl,
% endif

      -----------------------------------------------------------------------------
      --Dram Interface
      -----------------------------------------------------------------------------
      aDramReady => aDramReady,
      du0DramAddrFifoAddr => du0DramAddrFifoAddr,
      du0DramAddrFifoCmd => du0DramAddrFifoCmd,
      du0DramAddrFifoFull => du0DramAddrFifoFull,
      du0DramAddrFifoWrEn => du0DramAddrFifoWrEn,
      du0DramPhyInitDone => du0DramPhyInitDone,
      du0DramRdDataValid => du0DramRdDataValid,
      du0DramRdFifoDataOut => du0DramRdFifoDataOut,
      du0DramWrFifoDataIn => du0DramWrFifoDataIn,
      du0DramWrFifoFull => du0DramWrFifoFull,
      du0DramWrFifoMaskData => du0DramWrFifoMaskData,
      du0DramWrFifoWrEn => du0DramWrFifoWrEn,
      du1DramAddrFifoAddr => du1DramAddrFifoAddr,
      du1DramAddrFifoCmd => du1DramAddrFifoCmd,
      du1DramAddrFifoFull => du1DramAddrFifoFull,
      du1DramAddrFifoWrEn => du1DramAddrFifoWrEn,
      du1DramPhyInitDone => du1DramPhyInitDone,
      du1DramRdDataValid => du1DramRdDataValid,
      du1DramRdFifoDataOut => du1DramRdFifoDataOut,
      du1DramWrFifoDataIn => du1DramWrFifoDataIn,
      du1DramWrFifoFull => du1DramWrFifoFull,
      du1DramWrFifoMaskData => du1DramWrFifoMaskData,
      du1DramWrFifoWrEn => du1DramWrFifoWrEn,

      -----------------------------------------------------------------------------
      --HMB Interface
      -----------------------------------------------------------------------------
      dHmbDramAddrFifoAddr => dHmbDramAddrFifoAddr,
      dHmbDramAddrFifoCmd => dHmbDramAddrFifoCmd,
      dHmbDramAddrFifoFull => dHmbDramAddrFifoFull,
      dHmbDramAddrFifoWrEn => dHmbDramAddrFifoWrEn,
      dHmbDramRdDataValid => dHmbDramRdDataValid,
      dHmbDramRdFifoDataOut => dHmbDramRdFifoDataOut,
      dHmbDramWrFifoDataIn => dHmbDramWrFifoDataIn,
      dHmbDramWrFifoFull => dHmbDramWrFifoFull,
      dHmbDramWrFifoMaskData => dHmbDramWrFifoMaskData,
      dHmbDramWrFifoWrEn => dHmbDramWrFifoWrEn,
      dHmbPhyInitDoneForLvfpga => dHmbPhyInitDoneForLvfpga,
      dLlbDramAddrFifoAddr => dLlbDramAddrFifoAddr,
      dLlbDramAddrFifoCmd => dLlbDramAddrFifoCmd,
      dLlbDramAddrFifoFull => dLlbDramAddrFifoFull,
      dLlbDramAddrFifoWrEn => dLlbDramAddrFifoWrEn,
      dLlbDramRdDataValid => dLlbDramRdDataValid,
      dLlbDramRdFifoDataOut => dLlbDramRdFifoDataOut,
      dLlbDramWrFifoDataIn => dLlbDramWrFifoDataIn,
      dLlbDramWrFifoFull => dLlbDramWrFifoFull,
      dLlbDramWrFifoMaskData => dLlbDramWrFifoMaskData,
      dLlbDramWrFifoWrEn => dLlbDramWrFifoWrEn,
      dLlbPhyInitDoneForLvfpga => dLlbPhyInitDoneForLvfpga,

      -----------------------------------
      -- Clocks from TheWindow
      -----------------------------------
      TopLevelClkOut => TopLevelClkOut,
      ReliableClkOut => ReliableClkOut,

      -----------------------------------
      -- Diagram/Reset/Clock status
      -----------------------------------
      rBaseClksValid => rBaseClksValid,
      tDiagramActive => tDiagramActive,
      rDiagramReset => rDiagramReset,
      aDiagramReset => aDiagramReset,
      rDerivedClockLostLockError => rDerivedClockLostLockError,
      rGatedBaseClksValid => rGatedBaseClksValid,
      aSafeToEnableGatedClks => aSafeToEnableGatedClks
    );

end architecture behavioral;
