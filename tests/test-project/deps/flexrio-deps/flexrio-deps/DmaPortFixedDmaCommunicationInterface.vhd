-------------------------------------------------------------------------------
--
-- File: DmaPortFixedDmaCommunicationInterface.vhd
-- Author: Paul Butler
-- Original Project: LabVIEW FPGA
-- Date: 9 October 2014
--
-------------------------------------------------------------------------------
-- (c) 2007 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   This is the top level file for the DmaPort communication interface for LabVIEW FPGA.
--   It connects directly the NI DMA IP and the interface to TheWindow.
--
-- This is a version of DmaPortCommunicationInterface with additional 
-- ports for accessing the DmaPort from DMA or MasterPort channels in 
-- the fixed logic. 
-------------------------------------------------------------------------------

--StaticVHDL Component

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

  use work.PkgDmaPortCommIfcArbiter.all;

  -- The pkg that specifies several signals used by the user VI and register
  -- framework.
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;

  -- The pkg containing some configuration info on the communication interface,
  -- such as the number of DMA channels and size of the DMA FIFO's.
  use work.PkgCommIntConfiguration.all;

  -- The pkg containing information on the DmaPort configuration.
   use work.PkgNiDmaConfig.all;

  -- The pkg containing the definitions for the FIFO interface signals.
  use work.PkgDmaPortDmaFifos.all;
  use work.PkgDmaPortDmaFifosFlatTypes.all;

  -- This package contains the definitions for the interface between the NI DMA IP and
  -- the application specific logic
  use work.PkgNiDma.all;

  -- The package contain data types definitions needed to define Master Port interfaces.
  use work.PkgDmaPortCommIfcMasterPort.all;
  use work.PkgDmaPortCommIfcMasterPortFlatTypes.all;

  use work.PkgDmaPortCommIfcInputDataControl.all;

entity DmaPortFixedDmaCommunicationInterface is
  port(

    -- This is the asynchronous reset for the interface.
    aReset : in boolean;

    -- This is a synchronous reset for the interface.
    dReset : in boolean;

    -- PCIe slot.
    DmaClk : in std_logic;
    -- The clock on which the interrupts coming from the LvFpga VI are synchronized.
    IrqClk : in std_logic;

    ---------------------------------------------------------------------------
    -- NI DMA IP signals
    ---------------------------------------------------------------------------

    dNiDmaInputRequestToDma : out NiDmaInputRequestToDma_t;
    dNiDmaInputRequestFromDma : in NiDmaInputRequestFromDma_t;
    dNiDmaInputDataToDma : out NiDmaInputDataToDma_t;
    dNiDmaInputDataFromDma : in NiDmaInputDataFromDma_t;
    dNiDmaInputStatusFromDma : in NiDmaInputStatusFromDma_t;

    dNiDmaOutputRequestToDma : out NiDmaOutputRequestToDma_t;
    dNiDmaOutputRequestFromDma : in NiDmaOutputRequestFromDma_t;
    dNiDmaOutputDataFromDma : in NiDmaOutputDataFromDma_t;

    dNiDmaHighSpeedSinkFromDma : in NiDmaHighSpeedSinkFromDma_t;

    ---------------------------------------------------------------------------
    -- DMA FIFO signals
    ---------------------------------------------------------------------------

    -- These are the DMA ports used by LV FPGA.
    dInputStreamInterfaceFromFifo : in
      InputStreamInterfaceFromFifoArray_t(Larger(kNumberOfDmaChannels,1)-1 downto 0);
    dInputStreamInterfaceToFifo : out
      InputStreamInterfaceToFifoArray_t(Larger(kNumberOfDmaChannels,1)-1 downto 0);
    dOutputStreamInterfaceFromFifo : in
      OutputStreamInterfaceFromFifoArray_t(Larger(kNumberOfDmaChannels,1)-1 downto 0);
    dOutputStreamInterfaceToFifo : out
      OutputStreamInterfaceToFifoArray_t(Larger(kNumberOfDmaChannels,1)-1 downto 0);

    ---------------------------------------------------------------------------
    -- Master Port signals
    ---------------------------------------------------------------------------

    dNiFpgaMasterWriteRequestFromMasterArray : in
      NiFpgaMasterWriteRequestFromMasterArray_t (Larger(kNumberOfMasterPorts,1)-1 downto 0);
    dNiFpgaMasterWriteRequestToMasterArray : out
      NiFpgaMasterWriteRequestToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
    dNiFpgaMasterWriteDataFromMasterArray : in
      NiFpgaMasterWriteDataFromMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
    dNiFpgaMasterWriteDataToMasterArray : out
      NiFpgaMasterWriteDataToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
    dNiFpgaMasterWriteStatusToMasterArray : out
      NiFpgaMasterWriteStatusToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);

    dNiFpgaMasterReadRequestFromMasterArray : in
      NiFpgaMasterReadRequestFromMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
    dNiFpgaMasterReadRequestToMasterArray : out
      NiFpgaMasterReadRequestToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
    dNiFpgaMasterReadDataToMasterArray : out
      NiFpgaMasterreadDataToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);

    ---------------------------------------------------------------------------
    -- Fixed Logic Channels
    ---------------------------------------------------------------------------

    dNiFpgaInputRequestToDmaArray: in 
      NiDmaInputRequestToDmaArray_t (kNiFpgaFixedInputPorts-1 downto 0);
    dNiFpgaInputRequestFromDmaArray: out 
      NiDmaInputRequestFromDmaArray_t (kNiFpgaFixedInputPorts-1 downto 0);
    dNiFpgaInputDataToDmaArray: in 
      NiDmaInputDataToDmaArray_t (kNiFpgaFixedInputPorts-1 downto 0);
    dNiFpgaInputDataFromDmaArray: out 
      NiDmaInputDataFromDmaArray_t (kNiFpgaFixedInputPorts-1 downto 0);
    dNiFpgaInputStatusFromDmaArray: out 
      NiDmaInputStatusFromDmaArray_t (kNiFpgaFixedInputPorts-1 downto 0);

    dNiFpgaOutputRequestToDmaArray: in 
      NiDmaOutputRequestToDmaArray_t (kNiFpgaFixedOutputPorts-1 downto 0);
    dNiFpgaOutputRequestFromDmaArray: out 
      NiDmaOutputRequestFromDmaArray_t (kNiFpgaFixedOutputPorts-1 downto 0);
    dNiFpgaOutputDataFromDmaArray: out 
      NiDmaOutputDataFromDmaArray_t (kNiFpgaFixedOutputPorts-1 downto 0);

    dNiFpgaInputArbReq : in 
      NiDmaArbReqArray_t(kNiFpgaFixedInputPorts-1 downto 0);
    dNiFpgaInputArbGrant : out 
      NiDmaArbGrantArray_t(kNiFpgaFixedInputPorts-1 downto 0);
    dNiFpgaOutputArbReq : in 
      NiDmaArbReqArray_t(kNiFpgaFixedOutputPorts-1 downto 0);
    dNiFpgaOutputArbGrant : out 
      NiDmaArbGrantArray_t(kNiFpgaFixedOutputPorts-1 downto 0);

    ---------------------------------------------------------------------------
    -- IRQ signals
    ---------------------------------------------------------------------------

    -- The signals coming from the LvFpga VI.
    iLvFpgaIrq : in IrqToInterfaceArray_t(Larger(kNumberOfIrqs,1)-1 downto 0);

    -- Typically, there will be one entry in this array for each DMA 
    -- channel implemented in the fixed logic. For flexibility, we do 
    -- not require the size of this array to be the sum of 
    -- kNiFpgaFixedInputPorts + kNiFpgaFixedOutputPorts.
    dFixedLogicDmaIrq : in IrqStatusArray_t;

    -- The level interrupt line(s)
    dIrq : out std_logic_vector(kNumberOfIrqs-1 downto 0);


    ---------------------------------------------------------------------------
    -- Register Port signals
    ---------------------------------------------------------------------------

    -- The signals from the register access component advertising reads and
    -- writes.
    dRegPortIn   : in RegPortIn_t;

    -- The signals going to the register access component to indicate read
    -- responses and readiness.
    dRegPortOut  : out  RegPortOut_t

  );
end DmaPortFixedDmaCommunicationInterface;

architecture struct of DmaPortFixedDmaCommunicationInterface is

  constant kNumOfInStrms : natural := NumOfInStrms(kDmaFifoConfArray);
  constant kNumOfOutStrms : natural := NumOfOutStrms(kDmaFifoConfArray);
  constant kNumOfSinkStrms : natural := NumOfSinkStrms(kDmaFifoConfArray);
  constant kNumOfWriteMasterPorts : natural := NumOfWriteMasterPorts(kMasterPortConfArray);
  constant kNumOfReadMasterPorts : natural := NumOfReadMasterPorts(kMasterPortConfArray);

  -- The eviction timeout value for an input stream is the number of clock cycles to
  -- wait on a FIFO push before concluding that a decent sized packet is going to
  -- be built up.  If a packet doesn't seem to be building but data is available in
  -- the FIFO, we'll settle for sending a sub-optimally sized packet.  Ideally, the
  -- amount of time to wait would be a function of the sample rate (or push rate), but
  -- since we don't know this value a priori, we'll set it to a large value so that
  -- it only generally sends sub-optimal packets if the sample rate is very slow.
  -- In this case, performance should not be a big concern anyway.  With a bus clock
  -- rate of 125MHz, 1us is approximately 128 DmaClk cycles.  Rounding this to a power
  -- of 2 value simplifies the timeout comparison.
  constant kInputStreamEvictionTimeout : natural := 128;


  -- Obtain the FIFO depths in samples.
  constant kFifoDepthInSamples : DmaChannelConfArray_t(kDmaFifoConfArray'range)
     := GetFifoDepthsInSamples(kDmaFifoConfArray);

  signal dInStrmsRegPortOut: RegPortOutArray_t(ArbVecMSB(kNumOfInStrms) downto 0);
  signal dOutStrmsRegPortOut: RegPortOutArray_t(ArbVecMSB(kNumOfOutStrms) downto 0);
  signal dSinkStrmsRegPortOut: RegPortOutArray_t(ArbVecMSB(kNumOfSinkStrms) downto 0);
  signal dDmaIrq: IrqStatusArray_t(Larger(kNumberOfDmaChannels, 1)-1 downto 0);

  signal dMasterWriteAccDoneStrbArray:
    AccDoneStrbArray_t(ArbVecMSB(kNumOfWriteMasterPorts) downto 0);
  signal dMasterReadAccDoneStrbArray:
    AccDoneStrbArray_t(ArbVecMSB(kNumOfReadMasterPorts) downto 0);

  signal dInStrmsAccDoneStrbArray:
    AccDoneStrbArray_t(ArbVecMSB(kNumOfInStrms) downto 0);
  signal dOutStrmsAccDoneStrbArray:
    AccDoneStrbArray_t(ArbVecMSB(kNumOfOutStrms) downto 0);
  signal dSinkStrmsAccDoneStrbArray:
    AccDoneStrbArray_t(ArbVecMSB(kNumOfSinkStrms) downto 0);

  signal dNiFpgaMasterWriteRequestToDmaArray: NiDmaInputRequestToDmaArray_t
    (Larger(kNumOfWriteMasterPorts,1)-1 downto 0);
  signal dNiFpgaMasterReadRequestToDmaArray: NiDmaOutputRequestToDmaArray_t
    (Larger(kNumOfReadMasterPorts,1)-1 downto 0);

  signal dNiDmaInputRequestToDmaArray: NiDmaInputRequestToDmaArray_t
    (Larger(kNumOfInStrms,1)-1 downto 0);
  signal dNiDmaOutputRequestToDmaArray: NiDmaOutputRequestToDmaArray_t
    (Larger(kNumOfOutStrms,1)-1 downto 0);
  signal dNiDmaSinkRequestToDmaArray: NiDmaInputRequestToDmaArray_t
    (Larger(kNumOfSinkStrms,1)-1 downto 0);

  signal dNiDmaOutputDataFromDmaArray: NiDmaOutputDataFromDmaArray_t
    (Larger(kNumOfOutStrms,1)-1 downto 0);

    signal dNiFpgaMasterWriteDataToDmaArray: NiDmaInputDataToDmaArray_t
    (Larger(kNumOfWriteMasterPorts,1)-1 downto 0);

  signal dInStrmsAccEmergencyReq: std_logic_vector(ArbVecMSB(kNumOfInStrms)downto 0);
  signal dOutStrmsAccEmergencyReq: std_logic_vector(ArbVecMSB(kNumOfOutStrms)downto 0);
  signal dSinkStrmsAccEmergencyReq: std_logic_vector(ArbVecMSB(kNumOfSinkStrms)downto 0);
  signal dInStrmsAccNormalReq: std_logic_vector(ArbVecMSB(kNumOfInStrms)downto 0);
  signal dOutStrmsAccNormalReq: std_logic_vector(ArbVecMSB(kNumOfOutStrms)downto 0);
  signal dSinkStrmsAccNormalReq: std_logic_vector(ArbVecMSB(kNumOfSinkStrms)downto 0);
  signal dMasterWriteAccEmergencyReq: std_logic_vector(ArbVecMSB(kNumOfWriteMasterPorts)downto 0);
  signal dMasterReadAccEmergencyReq: std_logic_vector(ArbVecMSB(kNumOfReadMasterPorts)downto 0);
  signal dMasterWriteAccGrant: std_logic_vector(ArbVecMSB(kNumOfWriteMasterPorts)downto 0);
  signal dMasterReadAccGrant: std_logic_vector(ArbVecMSB(kNumOfReadMasterPorts)downto 0);
  signal dNiFpgaMasterWriteDataToDmaValidArray: BooleanVector(ArbVecMSB(kNumOfWriteMasterPorts)downto 0);
  signal dRegPortOutArray : RegPortOutArray_t(2 downto 0);
  signal dSinkStreamDataToDmaValid : boolean;
  signal dSinkArbAccGrant : std_logic_vector(ArbVecMSB(kNumOfSinkStrms)downto 0);
  signal dRegPortInReg : RegPortIn_t;
  signal dRegPortInReg2 : RegPortIn_t;
  signal dRegPortOutToReg : RegPortOut_t;
  signal dNiDmaOutputDataFromDmaReg : NiDmaOutputDataFromDma_t;
  signal dNiDmaInputStatusFromDmaReg : NiDmaInputStatusFromDma_t;
  signal dNiDmaHighSpeedSinkFromDmaReg : NiDmaHighSpeedSinkFromDma_t;
  signal dInArbAccDoneStrb: std_logic;
  signal dOutArbAccDoneStrb: std_logic;

  signal dInArbAccEmergencyReq: std_logic_vector(ArbVecMSB(
                                kNiFpgaFixedInputPorts
                              + Larger(kNumOfInStrms,1)
                              + Larger(kNumOfWriteMasterPorts,1)
                              + Larger(kNumOfSinkStrms,1))
                              downto 0);

  signal dInArbAccGrant: std_logic_vector(ArbVecMSB(
                                kNiFpgaFixedInputPorts
                              + Larger(kNumOfInStrms,1)
                              + Larger(kNumOfWriteMasterPorts,1)
                              + Larger(kNumOfSinkStrms,1))
                              downto 0);

  signal dInArbAccNormalReq: std_logic_vector(ArbVecMSB(
                                kNiFpgaFixedInputPorts
                              + Larger(kNumOfInStrms,1)
                              + Larger(kNumOfWriteMasterPorts,1)
                              + Larger(kNumOfSinkStrms,1))
                              downto 0);

  signal dOutArbAccEmergencyReq: std_logic_vector(ArbVecMSB(
                                kNiFpgaFixedOutputPorts 
                              + Larger(kNumOfOutStrms,1)
                              + Larger(kNumOfReadMasterPorts,1))
                              downto 0);

  signal dOutArbAccNormalReq: std_logic_vector(ArbVecMSB(
                                kNiFpgaFixedOutputPorts 
                              + Larger(kNumOfOutStrms,1)
                              + Larger(kNumOfReadMasterPorts,1))
                              downto 0);

  signal dOutArbAccGrant: std_logic_vector(ArbVecMSB(
                                kNiFpgaFixedOutputPorts 
                              + Larger(kNumOfOutStrms,1)
                              + Larger(kNumOfReadMasterPorts,1))
                              downto 0);

  --vhook_sigstart
  signal dInputDataFromSinkStreamArray: NiDmaInputDataToDmaArray_t(Larger(kNumOfSinkStrms,1)-1 downto 0);
  signal dInputDataFromSinkStreamValidArray: BooleanVector(Larger(kNumOfSinkStrms,1)-1 downto 0);
  signal dInputDataInterfaceFromFifoArray: NiDmaInputDataToDmaArray_t(Larger(kNumOfInStrms,1)-1 downto 0);
  signal dInputDataInterfaceToFifoArray: NiDmaInputDataFromDmaArray_t(Larger(kNumOfInStrms,1)-1 downto 0);
  signal dInputStreamDataFromDma: NiDmaInputDataFromDma_t;
  signal dInputStreamDataToDma: NiDmaInputDataToDma_t;
  signal dNiFpgaInputDataToDmaDelayed: NiDmaInputDataToDma_t ;
  signal dSinkStreamDataToDma: NiDmaInputDataToDma_t;
  --vhook_sigend

  -----------------------------------------------------------------------------
  -- Note: The following functions are placed directly in this file instead of
  --       placing them in a pkg because Xilinx will complain if they are
  --       in a pkg.
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- GetInStrmIndex
  --
  -- This function builds an array containing the index of each used DMA input
  -- stream.  For example, if there are 4 DMA channels, and channels 1 and 3
  -- are input streams while channels 0 and 2 are unused, then the index for
  -- channel 1 is 0 and the index for channel 3 is 1.  The indexes for unused
  -- channels or output channels are ignored.
  --
  -- The purpose of doing this is to map the signals from a channel to
  -- corresponding signals to the arbiter, since the arbiter is only
  -- instantiated with the actual number of used DMA channels, not the total
  -- number of channels.
  -----------------------------------------------------------------------------
  function GetInStrmIndex return StrmIndex_t is
    variable rVal : StrmIndex_t(kNumberOfDmaChannels-1 downto 0);
    variable StrmCount : natural;
  begin

    -- Each stream count value is the total number of input streams in the array before
    -- that stream.
    for i in kNumberOfDmaChannels-1 downto 0 loop
      StrmCount := 0;
      for j in i-1 downto 0 loop
        if kDmaFifoConfArray(j).Mode = NiFpgaTargetToHost or kDmaFifoConfArray(j).Mode
           = NiFpgaPeerToPeerWriter then
          StrmCount := StrmCount + 1;
        end if;
      end loop;
      rVal(i) := StrmCount;
    end loop;

    return rVal;

  end GetInStrmIndex;

  -----------------------------------------------------------------------------
  -- GetOutStrmIndex
  --
  -- This function builds an array containing the index of each used DMA out
  -- stream.  For example, if there are 4 DMA channels, and channels 1 and 3
  -- are output streams while channels 0 and 2 are unused, then the index for
  -- channel 1 is 0 and the index for channel 3 is 1.  The indexes for unused
  -- channels or input channels are ignored.
  --
  -- The purpose of doing this is to map the signals from a channel to
  -- corresponding signals to the arbiter, since the arbiter is only
  -- instantiated with the actual number of used DMA channels, not the total
  -- number of channels available.
  -----------------------------------------------------------------------------
  function GetOutStrmIndex return StrmIndex_t is
    variable rVal : StrmIndex_t(kNumberOfDmaChannels-1 downto 0);
    variable StrmCount : natural;
  begin

    for i in kNumberOfDmaChannels-1 downto 0 loop
      StrmCount := 0;
      for j in i-1 downto 0 loop
        if kDmaFifoConfArray(j).Mode = NiFpgaHostToTarget then
          StrmCount := StrmCount + 1;
        end if;
      end loop;
      rVal(i) := StrmCount;
    end loop;

    return rVal;

  end GetOutStrmIndex;

  -----------------------------------------------------------------------------
  -- GetSinkStrmIndex
  --
  -- This function builds an array containing the index of each used DMA input
  -- stream.  For example, if there are 4 DMA channels, and channels 1 and 3
  -- are input streams while channels 0 and 2 are unused, then the index for
  -- channel 1 is 0 and the index for channel 3 is 1.  The indexes for unused
  -- channels or output channels are ignored.
  --
  -- The purpose of doing this is to map the signals from a channel to
  -- corresponding signals to the arbiter, since the arbiter is only
  -- instantiated with the actual number of used DMA channels, not the total
  -- number of channels.
  -----------------------------------------------------------------------------
  function GetSinkStrmIndex return StrmIndex_t is
    variable rVal : StrmIndex_t(kNumberOfDmaChannels-1 downto 0);
    variable StrmCount : natural;
  begin

    -- Each stream count value is the total number of input streams in the array before
    -- that stream.
    for i in kNumberOfDmaChannels-1 downto 0 loop
      StrmCount := 0;
      for j in i-1 downto 0 loop
        if kDmaFifoConfArray(j).Mode = NiFpgaPeerToPeerReader then
          StrmCount := StrmCount + 1;
        end if;
      end loop;
      rVal(i) := StrmCount;
    end loop;

    return rVal;

  end GetSinkStrmIndex;


  -----------------------------------------------------------------------------
  -- GetWriteMasterPortIndex
  --
  -- This function builds an array containing the index of each Write Master
  -- Port used.  For example, if there are 4 Master Ports, and channels
  -- 1 and 3 are Write Master Ports while channels 0 and 2 are Read Master Ports,
  --  then the index for channel 1 is 0 and the index for channel 3 is 1.
  -- The indexes for Read Master Ports are ignored.
  --
  -- The purpose of doing this is to map the signals from a channel to
  -- corresponding signals to the arbiter, since the arbiter is only
  -- instantiated with the actual number of used DMA channels, not the total
  -- number of channels available.
  -----------------------------------------------------------------------------

  function GetWriteMasterPortIndex return StrmIndex_t is
    variable rVal : StrmIndex_t(kNumberOfMasterPorts-1 downto 0);
    variable MasterPortCount : natural;
  begin

    for i in kNumberOfMasterPorts-1 downto 0 loop
      MasterPortCount := 0;
      for j in i-1 downto 0 loop
        if kMasterPortConfArray(j).Mode = NiFpgaMasterPortWriteRead or
           kMasterPortConfArray(j).Mode = NiFpgaMasterPortWrite then

          MasterPortCount := MasterPortCount + 1;
        end if;
      end loop;
      rVal(i) := MasterPortCount;
    end loop;

    return rVal;

  end GetWriteMasterPortIndex;

  -----------------------------------------------------------------------------
  -- GetReadMasterPortIndex
  --
  -- This function builds an array containing the index of each Read Master
  -- Port used.  For example, if there are 4 Master Ports, and channels
  -- 1 and 3 are Read Master Ports while channels 0 and 2 are Write Master Ports,
  --  then the index for channel 1 is 0 and the index for channel 3 is 1.
  -- The indexes for Write Master Ports are ignored.
  --
  -- The purpose of doing this is to map the signals from a channel to
  -- corresponding signals to the arbiter, since the arbiter is only
  -- instantiated with the actual number of used DMA channels, not the total
  -- number of channels available.
  -----------------------------------------------------------------------------

  function GetReadMasterPortIndex return StrmIndex_t is
    variable rVal : StrmIndex_t(kNumberOfMasterPorts-1 downto 0);
    variable MasterPortCount : natural;
  begin

    for i in kNumberOfMasterPorts-1 downto 0 loop
      MasterPortCount := 0;
      for j in i-1 downto 0 loop
        if kMasterPortConfArray(j).Mode = NiFpgaMasterPortWriteRead or
           kMasterPortConfArray(j).Mode = NiFpgaMasterPortRead then

          MasterPortCount := MasterPortCount + 1;
        end if;
      end loop;
      rVal(i) := MasterPortCount;
    end loop;

    return rVal;

  end GetReadMasterPortIndex;

  constant kInStrmIndex : StrmIndex_t(kNumberOfDmaChannels-1 downto 0) := GetInStrmIndex;
  constant kOutStrmIndex : StrmIndex_t(kNumberOfDmaChannels-1 downto 0) :=
    GetOutStrmIndex;
  constant kSinkStrmIndex : StrmIndex_t(kNumberOfDmaChannels-1 downto 0) :=
    GetSinkStrmIndex;
  constant kMasterWriteIndex : StrmIndex_t(kNumberOfMasterPorts-1 downto 0) :=
    GetWriteMasterPortIndex;
  constant kMasterReadIndex : StrmIndex_t(kNumberOfMasterPorts-1 downto 0) :=
    GetReadMasterPortIndex;

begin

  -- We just split the combinatorial path that starts in the DmaPortBIM and continues
  -- in the DmaPortCommIfcRegisters. By adding this register we should make the timing
  -- closure much easier.
  -- Because of the extra delay cycle inferred by the additional register, we have
  -- to ensure that Ready is deasserted the cycle after Rd or Wt fields assert.
  -- NOTE: the Address field of the RegPortIn is not registered in this component.
  -- Instead of registering the Address field, we add a register on the control signals
  -- that are output of the address decoding (see DmaPortCommIfcRegs).
  RegPort: process (aReset, DmaClk)
  begin
    if aReset then
      dRegPortInReg2.Data <= kRegPortInZero.Data;
      dRegPortInReg2.Rd <= kRegPortInZero.Rd;
      dRegPortInReg2.Wt <= kRegPortInZero.Wt;
      dRegPortInReg <= kRegPortInZero;
      dRegPortOut <= kRegPortOutZero;
    elsif rising_edge(DmaClk) then
      dRegPortInReg2.Data <= dRegPortInReg.Data;
      dRegPortInReg2.Rd <= dRegPortInReg.Rd;
      dRegPortInReg2.Wt <= dRegPortInReg.Wt;
      
      dRegPortInReg <= dRegPortIn;
      
      dRegPortOut.Data <= dRegPortOutToReg.Data;
      dRegPortOut.DataValid <= dRegPortOutToReg.DataValid;
      dRegPortOut.Ready <= dRegPortOutToReg.Ready and (not dRegPortInReg.Wt) and (not dRegPortInReg.Rd)
                                                  and (not dRegPortInReg2.Wt) and (not dRegPortInReg2.Rd);
    end if;
  end process;
  
  -- Address registered after decoding
  dRegPortInReg2.Address <= dRegPortInReg.Address;

  -- We add a register on the dNiDmaOutputDataFromDma because Xilinx tools cannot meet
  -- timing on the data path from CHInCh2 to the Output DMA FIFOs. Because the CHInCh2
  -- is implemented in the small area we could have long routes to the BRAMs
  -- especially when we use a good procentage of the BRAMs available.
  RegOutputDataFromDma: process (aReset, DmaClk)
  begin
    if aReset then
      dNiDmaOutputDataFromDmaReg <= kNiDmaOutputDataFromDmaZero;
    elsif rising_edge(DmaClk) then
      dNiDmaOutputDataFromDmaReg <= dNiDmaOutputDataFromDma;
    end if;
  end process;
  
  -- DmaInputStatusRegProc : ------------------------------------------------------------------
  -- We add a register on the dNiDmaInputStatusFromDmaReg to split the combinatorial path
  -- between the Chinch2 and the Input DMA FIFOs logic.
  DmaInputStatusRegProc : process (aReset, DmaClk)
  begin
    if aReset then
      dNiDmaInputStatusFromDmaReg <= kNiDmaInputStatusFromDmaZero;
    elsif rising_edge(DmaClk) then
      dNiDmaInputStatusFromDmaReg <= dNiDmaInputStatusFromDma;
    end if;
  end process DmaInputStatusRegProc;

  -- DmaHighSpeedSinkRegProc : ----------------------------------------------------------------
  -- We add a register on the dNiDmaHighSpeedSinkFromDmaReg to split the combinatorial path
  -- between the Chinch2 and the Input DMA FIFOs logic.
  DmaHighSpeedSinkRegProc : process (aReset, DmaClk)
  begin
    if aReset then
      dNiDmaHighSpeedSinkFromDmaReg <= kNiDmaHighSpeedSinkFromDmaZero;
    elsif rising_edge(DmaClk) then
      dNiDmaHighSpeedSinkFromDmaReg <= dNiDmaHighSpeedSinkFromDma;
    end if;
  end process DmaHighSpeedSinkRegProc;

  -- DMA COMPONENTS
  -- Instantiate a DMA component for each channel
  DmaBlk:block
  begin

    NoInStrms: if kNumOfInStrms = 0 generate

      dNiDmaInputRequestToDmaArray(0) <= kNiDmaInputRequestToDmaZero;
      dInputDataInterfaceFromFifoArray(0) <= kNiDmaInputDataToDmaZero;
      dInStrmsRegPortOut(0) <= kRegPortOutZero;
      dInStrmsAccDoneStrbArray(0) <= '0';
      dInStrmsAccNormalReq(0) <= '0';
      dInStrmsAccEmergencyReq(0) <= '0';

    end generate; --NoInStrms

    NoOutStrms: if kNumOfOutStrms = 0 generate

      dNiDmaOutputRequestToDmaArray(0) <= kNiDmaOutputRequestToDmaZero;
      dOutStrmsRegPortOut(0) <= kRegPortOutZero;
      dOutStrmsAccDoneStrbArray(0) <= '0';
      dOutStrmsAccNormalReq(0) <= '0';
      dOutStrmsAccEmergencyReq(0) <= '0';

    end generate; --NoOutStrms

    NoSinkStrms: if kNumOfSinkStrms = 0 generate

      dNiDmaSinkRequestToDmaArray(0) <= kNiDmaInputRequestToDmaZero;
      dInputDataFromSinkStreamValidArray(0) <= false;
      dSinkStrmsRegPortOut(0) <= kRegPortOutZero;
      dSinkStrmsAccDoneStrbArray(0) <= '0';
      dSinkStrmsAccNormalReq(0) <= '0';
      dSinkStrmsAccEmergencyReq(0) <= '0';

    end generate; --NoInStrms

    NoDmaPorts: if kNumberOfDmaChannels = 0 generate
      dDmaIrq(0) <= kIrqStatusToInterfaceZero;
    end generate; --NoDmaPorts

    DmaComponents: for i in 0 to kNumberOfDmaChannels - 1 generate

      DmaInput: if kDmaFifoConfArray(i).Mode = NiFpgaTargetToHost or
                   kDmaFifoConfArray(i).Mode = NiFpgaPeerToPeerWriter generate

        --vhook_e DmaPortCommIfcInputStream
        --vhook_a kFifoDepth kFifoDepthInSamples(i).FifoDepth
        --vhook_a kSampleWidth kDmaFifoConfArray(i).FifoWidth
        --vhook_a kBaseOffset kDmaFifoConfArray(i).BaseAddress
        --vhook_a kFxpType kDmaFifoConfArray(i).FxpType
        --vhook_a kStreamNumber i
        --vhook_a kEvictionTimeout kInputStreamEvictionTimeout
        --vhook_a kPeerToPeerStream (kDmaFifoConfArray(i).Mode = NiFpgaPeerToPeerWriter)
        --vhook_a bReset dReset
        --vhook_a BusClk DmaClk
        --vhook_a bNiDmaInputRequestToDma dNiDmaInputRequestToDmaArray(kInStrmIndex(i))
        --vhook_a bNiDmaInputRequestFromDma dNiDmaInputRequestFromDma
        --vhook_a bNiDmaInputStatusFromDma dNiDmaInputStatusFromDmaReg
        --vhook_a bInputDataInterfaceFromFifo dInputDataInterfaceFromFifoArray(kInStrmIndex(i))
        --vhook_a bInputDataInterfaceToFifo dInputDataInterfaceToFifoArray(kInStrmIndex(i))
        --vhook_a bArbiterNormalReq dInStrmsAccNormalReq(kInStrmIndex(i))
        --vhook_a bArbiterEmergencyReq dInStrmsAccEmergencyReq(kInStrmIndex(i))
        --vhook_a bArbiterDone dInStrmsAccDoneStrbArray(kInStrmIndex(i))
        --vhook_a bArbiterGrant dInArbAccGrant(kInStrmIndex(i))
        --vhook_a bRegPortIn dRegPortInReg2
        --vhook_a bRegPortOut dInStrmsRegPortOut(kInStrmIndex(i))
        --vhook_a bInputStreamInterfaceToFifo dInputStreamInterfaceToFifo(i)
        --vhook_a bInputStreamInterfaceFromFifo dInputStreamInterfaceFromFifo(i)
        --vhook_a bIrq dDmaIrq(i)
        DmaPortCommIfcInputStreamx: entity work.DmaPortCommIfcInputStream (structure)
          generic map (
            kFifoDepth        => kFifoDepthInSamples(i).FifoDepth,
            kSampleWidth      => kDmaFifoConfArray(i).FifoWidth,
            kBaseOffset       => kDmaFifoConfArray(i).BaseAddress,
            kStreamNumber     => i,
            kEvictionTimeout  => kInputStreamEvictionTimeout,
            kPeerToPeerStream => (kDmaFifoConfArray(i).Mode = NiFpgaPeerToPeerWriter),
            kFxpType          => kDmaFifoConfArray(i).FxpType)
          port map (
            aReset                        => aReset,                                     
            bReset                        => dReset,                                     
            BusClk                        => DmaClk,                                     
            bNiDmaInputRequestToDma       => dNiDmaInputRequestToDmaArray(kInStrmIndex(i)),
            bNiDmaInputRequestFromDma     => dNiDmaInputRequestFromDma,                  
            bNiDmaInputStatusFromDma      => dNiDmaInputStatusFromDmaReg,                
            bInputDataInterfaceFromFifo   => dInputDataInterfaceFromFifoArray(kInStrmIndex(i)),
            bInputDataInterfaceToFifo     => dInputDataInterfaceToFifoArray(kInStrmIndex(i)),
            bArbiterNormalReq             => dInStrmsAccNormalReq(kInStrmIndex(i)),      
            bArbiterEmergencyReq          => dInStrmsAccEmergencyReq(kInStrmIndex(i)),
            bArbiterDone                  => dInStrmsAccDoneStrbArray(kInStrmIndex(i)),
            bArbiterGrant                 => dInArbAccGrant(kInStrmIndex(i)),            
            bRegPortIn                    => dRegPortInReg2,                             
            bRegPortOut                   => dInStrmsRegPortOut(kInStrmIndex(i)),        
            bInputStreamInterfaceToFifo   => dInputStreamInterfaceToFifo(i),             
            bInputStreamInterfaceFromFifo => dInputStreamInterfaceFromFifo(i),           
            bIrq                          => dDmaIrq(i));                                


        dOutputStreamInterfaceToFifo(i) <= kOutputStreamInterfaceToFifoZero;

      end generate; --DmaInput

      DmaOutputP2P: if kDmaFifoConfArray(i).Mode = NiFpgaPeerToPeerReader generate

        --vhook_e DmaPortCommIfcSinkStream
        --vhook_a kFifoDepth kFifoDepthInSamples(i).FifoDepth
        --vhook_a kSampleWidth kDmaFifoConfArray(i).FifoWidth
        --vhook_a kBaseOffset kDmaFifoConfArray(i).BaseAddress
        --vhook_a kFifoBaseOffset kDmaFifoConfArray(i).WriteWindowOffset
        --vhook_a kFxpType kDmaFifoConfArray(i).FxpType
        --vhook_a kStreamNumber i
        --vhook_a kWriteWindow kFifoWriteWindow       
        --vhook_a bReset dReset
        --vhook_a BusClk DmaClk
        --vhook_a bNiDmaInputRequestToDma dNiDmaSinkRequestToDmaArray(kSinkStrmIndex(i))
        --vhook_a bNiDmaInputRequestFromDma dNiDmaInputRequestFromDma
        --vhook_a bNiDmaInputDataFromDma dNiDmaInputDataFromDma
        --vhook_a bNiDmaInputDataToDma dInputDataFromSinkStreamArray(kSinkStrmIndex(i))
        --vhook_a bNiDmaHighSpeedSinkFromDma dNiDmaHighSpeedSinkFromDmaReg
        --vhook_a bNiDmaInputDataToDmaValid dInputDataFromSinkStreamValidArray(kSinkStrmIndex(i))
        --vhook_a bArbiterNormalReq dSinkStrmsAccNormalReq(kSinkStrmIndex(i))
        --vhook_a bArbiterEmergencyReq dSinkStrmsAccEmergencyReq(kSinkStrmIndex(i))
        --vhook_a bArbiterDone dSinkStrmsAccDoneStrbArray(kSinkStrmIndex(i))
        --vhook_a bArbiterGrant dSinkArbAccGrant(kSinkStrmIndex(i))
        --vhook_a bRegPortIn dRegPortInReg2
        --vhook_a bRegPortOut dSinkStrmsRegPortOut(kSinkStrmIndex(i))
        --vhook_a bOutputStreamInterfaceToFifo dOutputStreamInterfaceToFifo(i)
        --vhook_a bOutputStreamInterfaceFromFifo dOutputStreamInterfaceFromFifo(i)
        --vhook_a bIrq dDmaIrq(i)
        DmaPortCommIfcSinkStreamx: entity work.DmaPortCommIfcSinkStream (structure)
          generic map (
            kFifoDepth      => kFifoDepthInSamples(i).FifoDepth,        -- in  natural :=
            kFifoBaseOffset => kDmaFifoConfArray(i).WriteWindowOffset,  -- in  natural :=
            kWriteWindow    => kFifoWriteWindow,                        -- in  natural :=
            kSampleWidth    => kDmaFifoConfArray(i).FifoWidth,          -- in  positive :
            kBaseOffset     => kDmaFifoConfArray(i).BaseAddress,        -- in  natural :=
            kStreamNumber   => i,                                       -- in  natural :=
            kFxpType        => kDmaFifoConfArray(i).FxpType)            -- in  boolean :=
          port map (
            aReset                         => aReset,                                    
            bReset                         => dReset,                                    
            BusClk                         => DmaClk,                                    
            bNiDmaInputRequestToDma        => dNiDmaSinkRequestToDmaArray(kSinkStrmIndex(i)),
            bNiDmaInputRequestFromDma      => dNiDmaInputRequestFromDma,                 
            bNiDmaInputDataFromDma         => dNiDmaInputDataFromDma,                    
            bNiDmaInputDataToDma           => dInputDataFromSinkStreamArray(kSinkStrmIndex(i)),
            bNiDmaHighSpeedSinkFromDma     => dNiDmaHighSpeedSinkFromDmaReg,             
            bNiDmaInputDataToDmaValid      => dInputDataFromSinkStreamValidArray(kSinkStrmIndex(i)),
            bArbiterNormalReq              => dSinkStrmsAccNormalReq(kSinkStrmIndex(i)),
            bArbiterEmergencyReq           => dSinkStrmsAccEmergencyReq(kSinkStrmIndex(i)),
            bArbiterDone                   => dSinkStrmsAccDoneStrbArray(kSinkStrmIndex(i)),
            bArbiterGrant                  => dSinkArbAccGrant(kSinkStrmIndex(i)),       
            bRegPortIn                     => dRegPortInReg2,                            
            bRegPortOut                    => dSinkStrmsRegPortOut(kSinkStrmIndex(i)),
            bOutputStreamInterfaceToFifo   => dOutputStreamInterfaceToFifo(i),           
            bOutputStreamInterfaceFromFifo => dOutputStreamInterfaceFromFifo(i),         
            bIrq                           => dDmaIrq(i));                               

        dInputStreamInterfaceToFifo(i) <= kInputStreamInterfaceToFifoZero;

      end generate;


      HostOutputStream: if kDmaFifoConfArray(i).Mode = NiFpgaHostToTarget generate

        --vhook_e DmaPortCommIfcOutputStream
        --vhook_a kFifoDepth kFifoDepthInSamples(i).FifoDepth
        --vhook_a kSampleWidth kDmaFifoConfArray(i).FifoWidth
        --vhook_a kBaseOffset kDmaFifoConfArray(i).BaseAddress
        --vhook_a kStreamNumber i
        --vhook_a kFxpType kDmaFifoConfArray(i).FxpType
        --vhook_a bReset dReset
        --vhook_a BusClk DmaClk
        --vhook_a bNiDmaOutputRequestToDma dNiDmaOutputRequestToDmaArray(kOutStrmIndex(i))
        --vhook_a bNiDmaOutputRequestFromDma dNiDmaOutputRequestFromDma
        --vhook_a bNiDmaOutputDataFromDma dNiDmaOutputDataFromDmaArray(kOutStrmIndex(i))
        --vhook_a bArbiterNormalReq dOutStrmsAccNormalReq(kOutStrmIndex(i))
        --vhook_a bArbiterEmergencyReq dOutStrmsAccEmergencyReq(kOutStrmIndex(i))
        --vhook_a bArbiterDone dOutStrmsAccDoneStrbArray(kOutStrmIndex(i))
        --vhook_a bArbiterGrant dOutArbAccGrant(kOutStrmIndex(i))
        --vhook_a bRegPortIn dRegPortInReg2
        --vhook_a bRegPortOut dOutStrmsRegPortOut(kOutStrmIndex(i))
        --vhook_a bOutputStreamInterfaceToFifo dOutputStreamInterfaceToFifo(i)
        --vhook_a bOutputStreamInterfaceFromFifo dOutputStreamInterfaceFromFifo(i)
        --vhook_a bIrq dDmaIrq(i)
        DmaPortCommIfcOutputStreamx: entity work.DmaPortCommIfcOutputStream (structure)
          generic map (
            kSampleWidth  => kDmaFifoConfArray(i).FifoWidth,    -- in  positive := 32
            kFifoDepth    => kFifoDepthInSamples(i).FifoDepth,  -- in  natural := 1024
            kBaseOffset   => kDmaFifoConfArray(i).BaseAddress,  -- in  natural := 0
            kStreamNumber => i,                                 -- in  natural := 0
            kFxpType      => kDmaFifoConfArray(i).FxpType)      -- in  boolean := false
          port map (
            aReset                         => aReset,                                    
            bReset                         => dReset,                                    
            BusClk                         => DmaClk,                                    
            bNiDmaOutputRequestToDma       => dNiDmaOutputRequestToDmaArray(kOutStrmIndex(i)),
            bNiDmaOutputRequestFromDma     => dNiDmaOutputRequestFromDma,                
            bNiDmaOutputDataFromDma        => dNiDmaOutputDataFromDmaArray(kOutStrmIndex(i)),
            bArbiterNormalReq              => dOutStrmsAccNormalReq(kOutStrmIndex(i)),
            bArbiterEmergencyReq           => dOutStrmsAccEmergencyReq(kOutStrmIndex(i)),
            bArbiterDone                   => dOutStrmsAccDoneStrbArray(kOutStrmIndex(i)),
            bArbiterGrant                  => dOutArbAccGrant(kOutStrmIndex(i)),         
            bRegPortIn                     => dRegPortInReg2,                            
            bRegPortOut                    => dOutStrmsRegPortOut(kOutStrmIndex(i)),     
            bOutputStreamInterfaceToFifo   => dOutputStreamInterfaceToFifo(i),           
            bOutputStreamInterfaceFromFifo => dOutputStreamInterfaceFromFifo(i),         
            bIrq                           => dDmaIrq(i));                               

        dInputStreamInterfaceToFifo(i) <= kInputStreamInterfaceToFifoZero;

      end generate; --HostOutputStream

      DmaUnused: if kDmaFifoConfArray(i).Mode = Disabled generate

        dOutputStreamInterfaceToFifo(i) <= kOutputStreamInterfaceToFifoZero;
        dInputStreamInterfaceToFifo(i) <= kInputStreamInterfaceToFifoZero;
        dDmaIrq(i) <= kIrqStatusToInterfaceZero;

      end generate; --DmaUnused

    end generate; --DmaComponents

  end block DmaBlk;


  MasterPortBlk: block
  begin

    NoWriteMasterPort: if kNumOfWriteMasterPorts = 0 generate

      dNiFpgaMasterWriteRequestToDmaArray(0) <= kNiDmaInputRequestToDmaZero;
      dNiFpgaMasterWriteDataToDmaArray(0) <= kNiDmaInputDataToDmaZero;
      dMasterWriteAccDoneStrbArray(0) <= '0';
      dMasterWriteAccEmergencyReq(0) <= '0';

    end generate; --NoWriteMasterPort

    NoReadMasterPort: if kNumOfReadMasterPorts = 0 generate

      dNiFpgaMasterReadRequestToDmaArray(0) <= kNiDmaOutputRequestToDmaZero;
      dMasterReadAccDoneStrbArray(0) <= '0';
      dMasterReadAccEmergencyReq(0) <= '0';

    end generate; --NoReadMasterPort

    MasterPortComponents: for i in 0 to kNumberOfMasterPorts - 1 generate

      WriteMasterPorts: if kMasterPortConfArray(i).Mode = NiFpgaMasterPortWriteRead or 
                           kMasterPortConfArray(i).Mode = NiFpgaMasterPortWrite generate

        --vhook_e DmaPortCommIfcMasterWriteInterface
        --vhook_c kWriteMasterPortNumber kNumberOfDmaChannels+i
        --vhook_a BusClk DmaClk
        --vhook_a bNiFpgaMasterWriteRequestToDma dNiFpgaMasterWriteRequestToDmaArray(kMasterWriteIndex(i))
        --vhook_a bNiFpgaMasterWriteRequestFromDma dNiDmaInputRequestFromDma
        --vhook_a bNiFpgaMasterWriteDataFromDma dNiDmaInputDataFromDma
        --vhook_a bNiFpgaMasterWriteDataToDma dNiFpgaMasterWriteDataToDmaArray(kMasterWriteIndex(i))
        --vhook_a bNiFpgaMasterWriteStatusFromDma dNiDmaInputStatusFromDmaReg
        --vhook_a bNiFpgaMasterWriteDataToDmaValid dNiFpgaMasterWriteDataToDmaValidArray(kMasterWriteIndex(i))
        --vhook_a bNiFpgaMasterWriteRequestFromMaster dNiFpgaMasterWriteRequestFromMasterArray(i)
        --vhook_a bNiFpgaMasterWriteRequestToMaster dNiFpgaMasterWriteRequestToMasterArray(i)
        --vhook_a bNiFpgaMasterWriteDataFromMaster dNiFpgaMasterWriteDataFromMasterArray(i)
        --vhook_a bNiFpgaMasterWriteDataToMaster dNiFpgaMasterWriteDataToMasterArray(i)
        --vhook_a bNiFpgaMasterWriteStatusToMaster dNiFpgaMasterWriteStatusToMasterArray(i)
        --vhook_a bMasterWriteArbiterReq dMasterWriteAccEmergencyReq(kMasterWriteIndex(i))
        --vhook_a bMasterWriteArbiterDone dMasterWriteAccDoneStrbArray(kMasterWriteIndex(i))
        --vhook_a bMasterWriteArbiterGrant dMasterWriteAccGrant(kMasterWriteIndex(i))
        DmaPortCommIfcMasterWriteInterfacex: entity work.DmaPortCommIfcMasterWriteInterface (rtl)
          generic map (
            kWriteMasterPortNumber => kNumberOfDmaChannels+i)  -- in  natural := 1
          port map (
            aReset                              => aReset,                               
            BusClk                              => DmaClk,                               
            bNiFpgaMasterWriteRequestToDma      => dNiFpgaMasterWriteRequestToDmaArray(kMasterWriteIndex(i)),
            bNiFpgaMasterWriteRequestFromDma    => dNiDmaInputRequestFromDma,            
            bNiFpgaMasterWriteDataFromDma       => dNiDmaInputDataFromDma,               
            bNiFpgaMasterWriteDataToDma         => dNiFpgaMasterWriteDataToDmaArray(kMasterWriteIndex(i)),
            bNiFpgaMasterWriteStatusFromDma     => dNiDmaInputStatusFromDmaReg,          
            bNiFpgaMasterWriteDataToDmaValid    => dNiFpgaMasterWriteDataToDmaValidArray(kMasterWriteIndex(i)),
            bNiFpgaMasterWriteRequestFromMaster => dNiFpgaMasterWriteRequestFromMasterArray(i),
            bNiFpgaMasterWriteRequestToMaster   => dNiFpgaMasterWriteRequestToMasterArray(i),
            bNiFpgaMasterWriteDataFromMaster    => dNiFpgaMasterWriteDataFromMasterArray(i),
            bNiFpgaMasterWriteDataToMaster      => dNiFpgaMasterWriteDataToMasterArray(i),
            bNiFpgaMasterWriteStatusToMaster    => dNiFpgaMasterWriteStatusToMasterArray(i),
            bMasterWriteArbiterReq              => dMasterWriteAccEmergencyReq(kMasterWriteIndex(i)),
            bMasterWriteArbiterDone             => dMasterWriteAccDoneStrbArray(kMasterWriteIndex(i)),
            bMasterWriteArbiterGrant            => dMasterWriteAccGrant(kMasterWriteIndex(i)));


        NullReadMasterPort: if kMasterPortConfArray(i).Mode = NiFpgaMasterPortWrite generate
          dNiFpgaMasterReadRequestToMasterArray(i) <= kNiFpgaMasterReadRequestToMasterZero;
          dNiFpgaMasterReadDataToMasterArray(i) <= kNiFpgaMasterReadDataToMasterZero;
        end generate;

      end generate; -- WriteMasterPorts

      ReadMasterPorts: if kMasterPortConfArray(i).Mode = NiFpgaMasterPortWriteRead or 
                          kMasterPortConfArray(i).Mode = NiFpgaMasterPortRead generate

        --vhook_e DmaPortCommIfcMasterReadInterface
        --vhook_c kReadMasterPortNumber kNumberOfDmaChannels+i
        --vhook_a BusClk DmaClk
        --vhook_a bNiFpgaMasterReadRequestToDma dNiFpgaMasterReadRequestToDmaArray(kMasterReadIndex(i))
        --vhook_a bNiFpgaMasterReadRequestFromDma dNiDmaOutputRequestFromDma
        --vhook_a bNiFpgaMasterReadDataFromDma dNiDmaOutputDataFromDmaReg
        --vhook_a bNiFpgaMasterReadRequestFromMaster dNiFpgaMasterReadRequestFromMasterArray(i)
        --vhook_a bNiFpgaMasterReadRequestToMaster dNiFpgaMasterReadRequestToMasterArray(i)
        --vhook_a bNiFpgaMasterReadDataToMaster dNiFpgaMasterReadDataToMasterArray(i)
        --vhook_a bMasterReadArbiterReq dMasterReadAccEmergencyReq(kMasterReadIndex(i))
        --vhook_a bMasterReadArbiterDone dMasterReadAccDoneStrbArray(kMasterReadIndex(i))
        --vhook_a bMasterReadArbiterGrant dMasterReadAccGrant(kMasterReadIndex(i))
        DmaPortCommIfcMasterReadInterfacex: entity work.DmaPortCommIfcMasterReadInterface (rtl)
          generic map (
            kReadMasterPortNumber => kNumberOfDmaChannels+i)  -- in  natural := 1
          port map (
            aReset                             => aReset,                                
            BusClk                             => DmaClk,                                
            bNiFpgaMasterReadRequestToDma      => dNiFpgaMasterReadRequestToDmaArray(kMasterReadIndex(i)),
            bNiFpgaMasterReadRequestFromDma    => dNiDmaOutputRequestFromDma,            
            bNiFpgaMasterReadDataFromDma       => dNiDmaOutputDataFromDmaReg,            
            bNiFpgaMasterReadRequestFromMaster => dNiFpgaMasterReadRequestFromMasterArray(i),
            bNiFpgaMasterReadRequestToMaster   => dNiFpgaMasterReadRequestToMasterArray(i),
            bNiFpgaMasterReadDataToMaster      => dNiFpgaMasterReadDataToMasterArray(i),
            bMasterReadArbiterReq              => dMasterReadAccEmergencyReq(kMasterReadIndex(i)),
            bMasterReadArbiterDone             => dMasterReadAccDoneStrbArray(kMasterReadIndex(i)),
            bMasterReadArbiterGrant            => dMasterReadAccGrant(kMasterReadIndex(i)));


        NullWriteMasterPort: if kMasterPortConfArray(i).Mode = NiFpgaMasterPortRead generate
          dNiFpgaMasterWriteRequestToMasterArray(i) <= kNiFpgaMasterWriteRequestToMasterZero;
          dNiFpgaMasterWriteDataToMasterArray(i) <= kNiFpgaMasterWriteDataToMasterZero;
          dNiFpgaMasterWriteStatusToMasterArray(i) <=kNiFpgaMasterWriteStatusToMasterZero;
        end generate;

      end generate; -- ReadMasterPorts

      MasterPortsUnused: if kMasterPortConfArray(i).Mode = Disabled generate

        dNiFpgaMasterWriteRequestToMasterArray(i) <= kNiFpgaMasterWriteRequestToMasterZero;
        dNiFpgaMasterWriteDataToMasterArray(i) <= kNiFpgaMasterWriteDataToMasterZero;
        dNiFpgaMasterWriteStatusToMasterArray(i) <=kNiFpgaMasterWriteStatusToMasterZero;

        dNiFpgaMasterReadRequestToMasterArray(i) <= kNiFpgaMasterReadRequestToMasterZero;
        dNiFpgaMasterReadDataToMasterArray(i) <= kNiFpgaMasterReadDataToMasterZero;

      end generate; --MasterPortsUnused

    end generate; -- MasterPortComponents

  end block MasterPortBlk;


  -- Ensure that the number of IRQs used by the target is no greater than 1, since
  -- only 1 IRQ is supported by LV FPGA at this time.
  assert kNumberOfIrqs <= 1
    report "A maximum of 1 IRQ is supported by this communication interface." & LF &
           "Number of requested IRQs = " & integer'image(kNumberOfIrqs)
    severity error;

  IrqUsed: if kNumberOfIrqs = 1 generate

    --vhook_e DmaPortCommIfcIrqInterface
    --vhook_a kNumDmaIrqPorts kNumberOfDmaChannels
    --vhook_a bReset dReset
    --vhook_a BusClk DmaClk
    --vhook_a bIrq dIrq(0)
    --vhook_a bFixedLogicDmaIrq dFixedLogicDmaIrq
    --vhook_a bDmaIrq dDmaIrq
    DmaPortCommIfcIrqInterfacex: entity work.DmaPortCommIfcIrqInterface (rtl)
      generic map (
        kNumDmaIrqPorts => kNumberOfDmaChannels)  -- in  natural := 0
      port map (
        aReset            => aReset,             -- in  boolean
        bReset            => dReset,             -- in  boolean
        BusClk            => DmaClk,             -- in  std_logic
        IrqClk            => IrqClk,             -- in  std_logic
        bIrq              => dIrq(0),            -- out std_logic
        iLvFpgaIrq        => iLvFpgaIrq,         -- in  IrqToInterfaceArray_t(Larger(kNum
        bFixedLogicDmaIrq => dFixedLogicDmaIrq,  -- in  IrqStatusArray_t
        bDmaIrq           => dDmaIrq);           -- in  IrqStatusArray_t(Larger(kNumDmaIr


  end generate; --IrqUsed

  IrqUnused: if kNumberOfIrqs = 0 generate
    dIrq(0) <= '0';
  end generate; --IrqUnused

  -- The Master Ports arbitration requests will be treated with Emergency priority.
  -- The Emergency requests comming from Write Master Ports will sit in top of DMA streams
  -- Emergency requests.
  dInArbAccEmergencyReq <= GetEmergencyReq(dNiFpgaInputArbReq) 
                         & dMasterWriteAccEmergencyReq 
                         & dSinkStrmsAccEmergencyReq 
                         & dInStrmsAccEmergencyReq ;

  dInArbAccNormalReq <= GetNormalReq(dNiFpgaInputArbReq)
                      & Zeros(Larger(kNumOfWriteMasterPorts,1)) 
                      & dSinkStrmsAccNormalReq 
                      & dInStrmsAccNormalReq ;

  --vhook_e DmaPortCommIfcInputArbiter
  --vhook_a kNumOfInStrms Larger(kNumOfInStrms,1) + Larger(kNumOfWriteMasterPorts,1) + Larger(kNumOfSinkStrms,1) + kNiFpgaFixedInputPorts
  --vhook_a BusClk DmaClk
  --vhook_a bReset dReset
  --vhook_a bInStrmsAccNormalReq dInArbAccNormalReq
  --vhook_a bInStrmsAccEmergencyReq dInArbAccEmergencyReq
  --vhook_a bInStrmsAccDoneStrb to_boolean(dInArbAccDoneStrb)
  --vhook_a bInStrmsAccGrant dInArbAccGrant
  DmaPortCommIfcInputArbiterx: entity work.DmaPortCommIfcInputArbiter (rtl)
    generic map (
      kNumOfInStrms => Larger(kNumOfInStrms,1) + Larger(kNumOfWriteMasterPorts,1) + Larger(kNumOfSinkStrms,1) + kNiFpgaFixedInputPorts)
    port map (
      aReset                  => aReset,                         -- in  boolean
      BusClk                  => DmaClk,                         -- in  std_logic
      bReset                  => dReset,                         -- in  boolean
      bInStrmsAccNormalReq    => dInArbAccNormalReq,             -- in  std_logic_vector(
      bInStrmsAccEmergencyReq => dInArbAccEmergencyReq,          -- in  std_logic_vector(
      bInStrmsAccDoneStrb     => to_boolean(dInArbAccDoneStrb),  -- in  boolean
      bInStrmsAccGrant        => dInArbAccGrant);                -- out std_logic_vector(

  dNiFpgaInputArbGrant <= 
    to_NiDmaArbGrantArray_t (
    dInArbAccGrant( kNiFpgaFixedInputPorts
                  + Larger(kNumOfWriteMasterPorts,1) 
                  + Larger(kNumOfSinkStrms,1) 
                  + Larger(kNumOfInStrms,1) - 1
                   downto 
                   Larger(kNumOfWriteMasterPorts,1) 
                 + Larger(kNumOfSinkStrms,1) 
                 + Larger(kNumOfInStrms,1) ) );

  -- The Grants coresponding to the Write Master Ports are selected.
  dMasterWriteAccGrant <= (others => '0') when kNumOfWriteMasterPorts = 0 else
    dInArbAccGrant( Larger(kNumOfWriteMasterPorts,1) 
                  + Larger(kNumOfSinkStrms,1) 
                  + Larger(kNumOfInStrms,1) - 1
                  downto 
                  Larger(kNumOfSinkStrms,1) 
                + Larger(kNumOfInStrms,1) );

  -- The Grants coresponding to the Sink Streams are selected.
  dSinkArbAccGrant <= (others => '0') when kNumOfSinkStrms = 0 else
    dInArbAccGrant( Larger(kNumOfSinkStrms,1) 
                  + Larger(kNumOfInStrms,1) - 1  
                  downto 
                  Larger(kNumOfInStrms,1) );

  -- The components driving these input requests must drive zero unless 
  -- they have been granted access to the DMA Port by the arbiter. As 
  -- long as the components follow that protocol requirement, the input 
  -- request arrays can be merged with a simple OR gate:
  dNiDmaInputRequestToDma <= OrArray (  dNiDmaInputRequestToDmaArray 
                                      & dNiFpgaMasterWriteRequestToDmaArray
                                      & dNiDmaSinkRequestToDmaArray 
                                      & dNiFpgaInputRequestToDmaArray
                                     );

  dInputStreamDataFromDma <= dNiDmaInputDataFromDma;

  --vhook_e DmaPortCommIfcInputDataControl
  --vhook_a BusClk DmaClk
  --vhook_a bNiDmaInputDataFromDma dInputStreamDataFromDma
  --vhook_a bNiDmaInputDataToDma dInputStreamDataToDma
  --vhook_a bInputDataInterfaceFromFifoArray dInputDataInterfaceFromFifoArray
  --vhook_a bInputDataInterfaceToFifoArray dInputDataInterfaceToFifoArray
  DmaPortCommIfcInputDataControlx: entity work.DmaPortCommIfcInputDataControl (rtl)
    generic map (
      kNumOfInStrms => kNumOfInStrms,  -- in  natural := 16
      kInStrmIndex  => kInStrmIndex)   -- in  StrmIndex_t
    port map (
      aReset                           => aReset,                            -- in  boole
      BusClk                           => DmaClk,                            -- in  std_l
      bNiDmaInputDataFromDma           => dInputStreamDataFromDma,           -- in  NiDma
      bNiDmaInputDataToDma             => dInputStreamDataToDma,             -- out NiDma
      bInputDataInterfaceFromFifoArray => dInputDataInterfaceFromFifoArray,  -- in  NiDma
      bInputDataInterfaceToFifoArray   => dInputDataInterfaceToFifoArray);   -- out NiDma

  --vhook_e DmaPortCommIfcSinkDataControl
  --vhook_a BusClk DmaClk
  --vhook_a bNiDmaInputDataToDma dSinkStreamDataToDma
  --vhook_a bNiDmaInputDataToDmaValid dSinkStreamDataToDmaValid
  --vhook_a bInputDataFromSinkStreamArray dInputDataFromSinkStreamArray
  --vhook_a bInputDataFromSinkStreamValidArray dInputDataFromSinkStreamValidArray
  DmaPortCommIfcSinkDataControlx: entity work.DmaPortCommIfcSinkDataControl (rtl)
    generic map (
      kNumOfSinkStrms => kNumOfSinkStrms)  -- in  natural := 16
    port map (
      aReset                             => aReset,                              -- in  b
      BusClk                             => DmaClk,                              -- in  s
      bNiDmaInputDataToDma               => dSinkStreamDataToDma,                -- out N
      bNiDmaInputDataToDmaValid          => dSinkStreamDataToDmaValid,           -- out b
      bInputDataFromSinkStreamArray      => dInputDataFromSinkStreamArray,       -- in  N
      bInputDataFromSinkStreamValidArray => dInputDataFromSinkStreamValidArray); -- in  B


  --dNiFpgaInputDataToDmaArray is actually read by 
  --DmaPortInputDataToDmaDelayx, but vsmake cannot detect it.
  --vhook_nowarn dNiFpgaInputDataToDmaArray

  --vhook_e DmaPortInputDataToDmaDelay
  --vhook_a kDelay kInputDataDelay
  --vhook_a Clk DmaClk
  --vhook_c cNiDmaInputDataToDma OrArray ( dNiFpgaInputDataToDmaArray )
  --vhook_a cNiDmaInputDataToDmaDelayed dNiFpgaInputDataToDmaDelayed
  DmaPortInputDataToDmaDelayx: entity work.DmaPortInputDataToDmaDelay (RTL)
    generic map (
      kDelay => kInputDataDelay)  -- in  natural := 0
    port map (
      Clk                         => DmaClk,                                  -- in  std_
      cNiDmaInputDataToDma        => OrArray ( dNiFpgaInputDataToDmaArray ),  -- in  NiDm
      cNiDmaInputDataToDmaDelayed => dNiFpgaInputDataToDmaDelayed);           -- out NiDm


  -- The following process is multiplexing the data buses comming from Write Master Ports,
  -- Sink Streams and the data bus comming from Input Data Control component;
  InputDataToDma: process (dNiFpgaMasterWriteDataToDmaArray,
                           dNiFpgaMasterWriteDataToDmaValidArray, dInputStreamDataToDma,
                           dSinkStreamDataToDma, dSinkStreamDataToDmaValid,
                           dNiFpgaInputDataToDmaDelayed)
    variable MasterWriteDataToDmaVar : NiDmaInputDataToDma_t;
    variable MasterWriteDataToDmaValidVar : boolean;

  begin

    MasterWriteDataToDmaVar := kNiDmaInputDataToDmaZero;
    MasterWriteDataToDmaValidVar := false;

    for i in 0 to kNumOfWriteMasterPorts-1 loop
      if dNiFpgaMasterWriteDataToDmaValidArray(i) then
        MasterWriteDataToDmaVar := dNiFpgaMasterWriteDataToDmaArray(i);
      end if;

      MasterWriteDataToDmaValidVar := MasterWriteDataToDmaValidVar or
                                      dNiFpgaMasterWriteDataToDmaValidArray(i);

    end loop;

    if MasterWriteDataToDmaValidVar then
      dNiDmaInputDataToDma <= MasterWriteDataToDmaVar;
    elsif dSinkStreamDataToDmaValid then
      dNiDmaInputDataToDma <= dSinkStreamDataToDma;
    else
      dNiDmaInputDataToDma <= OrArray (
                              dInputStreamDataToDma
                            & dNiFpgaInputDataToDmaDelayed
                          );
    end if;
  end process InputDataToDma;

  -- The Master Ports arbitration requests will be treated with Emergency priority.
  -- The Emergency requests comming from Read Master Ports will sit in top of DMA streams
  -- Emergency requests.
  dOutArbAccEmergencyReq <= GetEmergencyReq(dNiFpgaOutputArbReq)
                          & dMasterReadAccEmergencyReq 
                          & dOutStrmsAccEmergencyReq;

  dOutArbAccNormalReq <= GetNormalReq(dNiFpgaOutputArbReq)
                       & Zeros(Larger(kNumOfReadMasterPorts,1)) 
                       & dOutStrmsAccNormalReq;

  --vhook_e DmaPortCommIfcOutputArbiter
  --vhook_a kNumOfOutStrms Larger(kNumOfOutStrms,1) + Larger(kNumOfReadMasterPorts,1) + kNiFpgaFixedOutputPorts
  --vhook_a BusClk DmaClk
  --vhook_a bReset dReset
  --vhook_a bOutStrmsAccNormalReq dOutArbAccNormalReq
  --vhook_a bOutStrmsAccEmergencyReq dOutArbAccEmergencyReq
  --vhook_a bOutStrmsAccDoneStrb to_boolean(dOutArbAccDoneStrb)
  --vhook_a bOutStrmsAccGrant dOutArbAccGrant
  DmaPortCommIfcOutputArbiterx: entity work.DmaPortCommIfcOutputArbiter (rtl)
    generic map (
      kNumOfOutStrms => Larger(kNumOfOutStrms,1) + Larger(kNumOfReadMasterPorts,1) + kNiFpgaFixedOutputPorts)
    port map (
      aReset                   => aReset,                          -- in  boolean
      BusClk                   => DmaClk,                          -- in  std_logic
      bReset                   => dReset,                          -- in  boolean
      bOutStrmsAccNormalReq    => dOutArbAccNormalReq,             -- in  std_logic_vecto
      bOutStrmsAccEmergencyReq => dOutArbAccEmergencyReq,          -- in  std_logic_vecto
      bOutStrmsAccDoneStrb     => to_boolean(dOutArbAccDoneStrb),  -- in  boolean
      bOutStrmsAccGrant        => dOutArbAccGrant);                -- out std_logic_vecto


  -- The Grants coresponding to the Read Master Ports are selected.
  dMasterReadAccGrant <= (others => '0') when kNumOfReadMasterPorts = 0 else
    dOutArbAccGrant((Larger(kNumOfOutStrms,1) 
                   + Larger(kNumOfReadMasterPorts,1) - 1) 
                    downto 
                     Larger(kNumOfOutStrms,1));

  dNiFpgaOutputArbGrant <=
    to_NiDmaArbGrantArray_t (
    dOutArbAccGrant((kNiFpgaFixedOutputPorts
                   + Larger(kNumOfOutStrms,1) 
                   + Larger(kNumOfReadMasterPorts,1) - 1) 
                    downto 
                     Larger(kNumOfOutStrms,1) 
                   + Larger(kNumOfReadMasterPorts,1)));

  -- The components driving these output requests must drive zero unless 
  -- they have been granted access to the DMA Port by the arbiter. As 
  -- long as the components follow that protocol requirement, the output 
  -- request arrays can be merged with a simple OR gate:
  dNiDmaOutputRequestToDma <= OrArray (  dNiDmaOutputRequestToDmaArray
                                       & dNiFpgaMasterReadRequestToDmaArray 
                                       & dNiFpgaOutputRequestToDmaArray
                                      );

  GenerateOutputDataArray: for i in 0 to kNumOfOutStrms-1 generate
    dNiDmaOutputDataFromDmaArray(i)  <= dNiDmaOutputDataFromDmaReg;
  end generate GenerateOutputDataArray;


  -- Or the register port signals from all downstream components to a single
  -- register port signal feeding the register access piece.
  dRegPortOutArray(0) <= SelectPort(dInStrmsRegPortOut);
  dRegPortOutArray(1) <= SelectPort(dOutStrmsRegPortOut);
  dRegPortOutArray(2) <= SelectPort(dSinkStrmsRegPortOut);
  dRegPortOutToReg <= SelectPort(dRegPortOutArray);


  OrInDoneStrobes:
  dInArbAccDoneStrb <= OrVector ( 
                       GetDoneStrb(dNiFpgaInputArbReq ) 
                     & dMasterWriteAccDoneStrbArray 
                     & dSinkStrmsAccDoneStrbArray 
                     & dInStrmsAccDoneStrbArray 
                     );

  OrOutDoneStrobes:
  dOutArbAccDoneStrb <= OrVector (
                        GetDoneStrb ( dNiFpgaOutputArbReq )
                      & dMasterReadAccDoneStrbArray
                      & dOutStrmsAccDoneStrbArray
                        );

  dNiFpgaInputStatusFromDmaArray <= (others => dNiDmaInputStatusFromDmaReg);
  dNiFpgaInputRequestFromDmaArray <= (others => dNiDmaInputRequestFromDma);
  dNiFpgaOutputRequestFromDmaArray <= (others => dNiDmaOutputRequestFromDma);
  dNiFpgaInputDataFromDmaArray <= (others => dNiDmaInputDataFromDma);
  dNiFpgaOutputDataFromDmaArray <= (others => dNiDmaOutputDataFromDma);

end struct;
