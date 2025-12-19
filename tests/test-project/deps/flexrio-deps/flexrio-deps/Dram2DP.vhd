-------------------------------------------------------------------------------
--
-- File: Dram2DP.vhd
-- Author: Neil Turley
-- Original Project: Dram2DP Project
-- Date: 15 June 2016
--
-------------------------------------------------------------------------------
-- (c) 2016 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
-- The Dram2DP translates read/write requests from the DRAM MIG interface
-- into DmaPort reads/writes configured for direct system memory access.
-- That way, we can present a DRAM-like interface to LV FPGA and redirect it
-- to system memory.
--
-- This core is capable of breaking up the application's memory into blocks of
-- physical memory that are all the same size. The core adds a different address
-- offset to each region. These offsets are held in an address table
-- in the configuration registers. The number of bits to address which region and
-- the number of bits to address all of the memory within a region is defined by
-- generics.
--
-- information about DRAM Interface and DMAPort Interface is here
-- DMAPort Interface:
-- Penguin://lvfpga/fpga/digitalDesigns/trunk/9.2/source/fpgaIseDigitalDesigns/rvi/ISE
-- /HDL/CommonFiles/InChWORM/documentation/NiDmaIp.docx
-- MIG Interface:
-- http://www.xilinx.com/support/documentation/ip_documentation/ug586_7Series_MIS.pdf
--
-- On version 3.9 a new feature was added in the form of a new type of memory called
-- Low Latency Buffer or LLB. To the FPGA user it is presented as a different kind
-- of memory that can be added to a project. The difference with Host Memory Buffer
-- (HMB) is that reads from the FPGA are not directed to the host, but to a local
-- memory on the FPGA that can be written from the host via the High Speed Sink
-- interface (the one used for Peer to Peer reader FIFOs) so it can be written
-- with high throughput and low latency (specially if CPU uses large data width
-- instructions). Writes from FPGA to these kind of memory are arbitrated with
-- the HMB port and destined to the Host via DMA Port.
--
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library work;
  use work.PkgNiUtilities.all;
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommIfcArbiter.all;
  use work.PkgNiDma.all;
  use work.PkgNiDmaConfig.all;
  use work.PkgDram2DP.all;
  use work.PkgDram2DPConstants.all;

entity Dram2DP is
  generic (
    -- There are 2^kSizeOfMemBuffers bytes per buffer
    kSizeOfMemBuffers : positive := 22;
    -- There are 2^kSizeOfLlbMemBuffer bytes in the LLB buffer. Note that there is only
    -- one buffer in the host for the LLB interface. And that the size of the device
    -- memory that is written from the host and read from the VI is fixed to 4096 bytes
    -- and not affected by this
    kSizeOfLlbMemBuffer : positive := 20;
    -- There are 2^kMaxNumOfMemBuffers address slots in the base address table
    kMaxNumOfMemBuffers : natural range 0 to 5 := 2;
    -- This should be reserved in the resource.xml and not interfere with status pushing, ififo, etc.
    kDmaChannelNum : NiDmaGeneralChannel_t :=
      to_unsigned(kNiDmaDmaChannels - 1, NiDmaGeneralChannel_t'length);
    -- This feature is used in the window. If not, generate default signals
    kHmbInUse : boolean := true;
    -- This feature is used in the window. If not, generate default signals
    kLlbInUse : boolean := true;
    -- Default value is only for compatibility of some testbenches. Any power of two
    --  greater or equal to 32 is expected to work.
    kDramInterfaceDataWidth : positive := kDefaultDramInterfaceDataWidth;
    -- Reset value of all config registers (regular or LLB)  that define the
    -- baggage bits used for accessing the bus.
    -- Typically this will have the required baggage for accessing the host memory
    -- coherently for a given bus, but SW can still configure different buffers
    -- differently in case they are accessing different memory spaces.
    -- This default value corresponds to the right baggage to access host memory space
    -- in a Zynq based cRIO
    kDefaultBaggage : NiDmaBaggage_t := SetField(0, 16#1A#, kNiDmaBaggageWidth);
    -- Base address to be decoded in dHighSpeedSinkFromDma to target local RAM
    -- used for Low Latency Buffer feature.
    -- Depending on the size of the DmaHighSpeedSink window in the bus interface
    -- IP, one or more DMA Channels may need to be reserved in the LabVIEW
    -- plugin to make sure that the decoding address window cannot collide with a
    -- P2P reader FIFO in the LabVIEW FPGA VI.
    -- The default value should work on FlexRIO products (PCIe InChWORM based) and
    -- would correspond to P2P Channel 62 (63 is typically reserved for instruction FIFO)
    kDevRamSinkOffset : natural  := kNiDmaHighSpeedSinkBase + 4096;
    -- Address of the local RAM reported to SW. SW accesses to this address
    -- should be routed to kDevRamSinkOffset in the HighSpeedSink interface.
    -- This offset needs to take into account any difference between the
    -- address space that the driver uses to access the FPGA and the address space that
    -- this module uses to decode accesses on the dHighSpeedSinkFromDma interface.
    -- Note that different bus interfaces (e.g. DmaPortShim vs InChWORM) may define those
    -- two address spaces differently and they may be related to the LabVIEW FPGA regport
    -- address space which may be  created in fixed logic. That relationship may end
    -- up requiring a negative offset.
    -- This default value works for NextGen FlexRIO. The x40000 comes from
    -- kLabViewRegPortBase in PkgLvFpgaRegPortConfig which is how FlexRIO typically
    -- defines the base of the LabVIEW FPGA regport.
    kDevRamSWOffset   : integer  := kNiDmaHighSpeedSinkBase + 4096 - 16#40000#
  );
  port (
    aBusReset:                   in std_logic;
    BusClk:                      in std_logic;

    -- Register Access/ PIO Ports
    bRegPortIn:                  in RegPortIn_t;
    bRegPortOut:                 out RegPortOut_t;

    --For DeviceRAM access
    dHighSpeedSinkFromDma:       in NiDmaHighSpeedSinkFromDma_t;

    -- CLIP Socket ports (DRAM Socket)
    -- Note. Address is interpreted consistent with a Socket configuration of
    --   <DramAddressBitAlignment>3</DramAddressBitAlignment>
    -- i.e. the address will be a word address (of size kDramInterfaceDataWidth)
    -- multiplied by 8 (i.e. 2**3), regardless of the data width.

    -- These ports keeping the original naming convention correspond to the
    --  accesses to memories of the "Host Memory Buffer (HMB)" type
    dDramAddrFifoAddr:           in std_logic_vector(kDramInterfaceAddressWidth-1 downto 0);
    dDramAddrFifoCmd:            in std_logic_vector(2 downto 0);
    dDramAddrFifoFull:           out std_logic;
    dDramAddrFifoWrEn:           in std_logic;
    dDramRdDataValid:            out std_logic;
    dDramRdFifoDataOut:          out std_logic_vector(kDramInterfaceDataWidth-1 downto 0);
    dDramWrFifoDataIn:           in std_logic_vector(kDramInterfaceDataWidth-1 downto 0);
    dDramWrFifoFull:             out std_logic;
    --vhook_nowarn dDramWrFifoMaskData
    dDramWrFifoMaskData:         in std_logic_vector(kDramInterfaceDataWidth/8-1 downto 0);
    dDramWrFifoWrEn:             in std_logic;
    dPhyInitDoneForLvfpga:       out std_logic;

    -- These ports correspond to the accesses to memories of the "Low Latency Buffer (LLB)" type
    dLlbDramAddrFifoAddr:          in std_logic_vector(kDramInterfaceAddressWidth-1 downto 0);
    dLlbDramAddrFifoCmd:           in std_logic_vector(2 downto 0);
    dLlbDramAddrFifoFull:          out std_logic;
    dLlbDramAddrFifoWrEn:          in std_logic;
    dLlbDramRdDataValid:           out std_logic;
    dLlbDramRdFifoDataOut:         out std_logic_vector(kDramInterfaceDataWidth-1 downto 0);
    dLlbDramWrFifoDataIn:          in std_logic_vector(kDramInterfaceDataWidth-1 downto 0);
    dLlbDramWrFifoFull:            out std_logic;
    --vhook_nowarn dLlbDramWrFifoMaskData
    dLlbDramWrFifoMaskData:        in std_logic_vector(kDramInterfaceDataWidth/8-1 downto 0);
    dLlbDramWrFifoWrEn:            in std_logic;
    dLlbPhyInitDoneForLvfpga:      out std_logic;

    ---------------------------------------------------------------------------
    -- Fixed Logic Channels for FPGA Inputs and Outputs Signals
    ---------------------------------------------------------------------------
    -- The DMA clock has to be the same as DramClkSocket in Window to synchronize the input/output
    -- signals between DRAM interface and DMAPort interface.
    DMAClk : in std_logic;
    -- Inputs Signals
    dNiFpgaInputRequestToDma:    out NiDmaInputRequestToDma_t;
    dNiFpgaInputRequestFromDma:  in NiDmaInputRequestFromDma_t;
    dNiFpgaInputDataToDma:       out NiDmaInputDataToDma_t;
    dNiFpgaInputDataFromDma:     in NiDmaInputDataFromDma_t;
    --vhook_nowarn dNiFpgaInputStatusFromDma
    dNiFpgaInputStatusFromDma:   in NiDmaInputStatusFromDma_t;

    -- Outputs Signals
    dNiFpgaOutputRequestToDma:   out NiDmaOutputRequestToDma_t;
    dNiFpgaOutputRequestFromDma: in NiDmaOutputRequestFromDma_t;
    dNiFpgaOutputDataFromDma:    in NiDmaOutputDataFromDma_t;

    -- Arbiter Signals
    dNiFpgaInputArbReq:          out NiDmaArbReq_t;
    dNiFpgaInputArbGrant:        in NiDmaArbGrant_t;
    dNiFpgaOutputArbReq:         out NiDmaArbReq_t;
    dNiFpgaOutputArbGrant:       in NiDmaArbGrant_t
  );
end Dram2DP;

architecture rtl of Dram2DP is

  --vhook_sigstart
  signal dCoreReset: boolean;
  signal dPushValidWrite: boolean;
  signal dValidWriteWord: std_logic_vector(kNiDmaDataWidth-1 downto 0);
  --vhook_sigend

  constant kLocalMemSizeInBytes : natural := 4096;
  signal dLclAddr: std_logic_vector(Log2(kLocalMemSizeInBytes*8/kDramInterfaceDataWidth) downto 0);

  type ArbiterIfcState is (IDLE, REQ, GRANT, DONE);
  signal dArbiterIfcRdState : ArbiterIfcState;
  signal dArbiterIfcRdStateNxt : ArbiterIfcState;
  signal dArbiterIfcWrState : ArbiterIfcState;
  signal dArbiterIfcWrStateNxt : ArbiterIfcState;

  constant kByteCountLength : integer := dNiFpgaOutputRequestToDma.ByteCount'length;

  -- This is used to validate that physical addresses are in range
  constant kSizeOfMemBufferinBytes: integer := 2**kSizeOfMemBuffers;
  constant kSizeOfLlbMemBufferinBytes: integer := 2**kSizeOfLlbMemBuffer;

  -- This specifies how many 32-bit registers are used by the base address table
  constant kSizeOfBaseAddressTable: integer := 2**kMaxNumOfMemBuffers;

  -- data from the DmaPort component
  signal dDataOut: std_logic_vector(kNiDmaDataWidth-1 downto 0);

  -- Queue slots. An address size of 5 (depth of 32) is plenty to absorb the NI DMA latency
  -- and extra delay of routing the request. Any smaller size would not make a big difference
  -- in resources anyway regardless of how the synthesizer chooses to implement the memory.
  constant kDataFifoAddrW : natural := 5;
  signal dEmptyCount: unsigned(kDataFifoAddrW downto 0);
  signal dFullCount: unsigned(kDataFifoAddrW downto 0);

  -- controls to Queue
  signal dDequeue: boolean;

  -- Shift register from pop to dequeue
  signal dDequeueDelay : std_logic_vector (kNiDmaInputDataReadLatency-2 downto 0);

  -------------------------------------------------
  -- RegPort Registers (Configuration Registers) --
  -------------------------------------------------
  -- Enable register for the Core.
  signal bHmbCoreEnabled : boolean;
  signal bLlbCoreEnabled : boolean;
  -- clock-crossed version of enables
  signal dHmbCoreEnabled : boolean;
  signal dLlbCoreEnabled : boolean;
  signal dLocalCoreEnabled : boolean;
  -- The core will only use this number of buffers (signal must be able to
  -- hold numbers from 0 to 2**kMaxNumOfMemBuffers inclusive)
  signal bNumOfMemBuffers : std_logic_vector(kMaxNumOfMemBuffers downto 0);
  -- We make an address table type
  type AddressTable_t is array ( natural range<> ) of std_logic_vector(31 downto 0);
  -- these registers specify the starting addresses of each buffer
  signal bBaseAddrTableLo : AddressTable_t(kSizeOfBaseAddressTable-1 downto 0);
  signal bBaseAddrTableHi : AddressTable_t(kSizeOfBaseAddressTable-1 downto 0);

  signal bLowLatencyBufferLo : std_logic_vector(31 downto 0);
  signal bLowLatencyBufferHi : std_logic_vector(31 downto 0);

  signal bBaggageBits : NiD2DBaggageArr_t(0 to 2**kMaxNumOfMemBuffers-1) := (others => kDefaultBaggage);
  signal bLlbBaggageBits : NiDmaBaggage_t := kDefaultBaggage;
  signal dMappedBaggage : NiDmaBaggage_t;

  -- currently selected base address index
  signal dBufferIndex : natural range 0 to kSizeOfBaseAddressTable - 1;

  -- currently selected base address
  signal dBaseAddr : std_logic_vector(kNiDmaAddressWidth - 1 downto 0);
  -- Address value after address translation
  signal dMappedAddr : unsigned(kNiDmaAddressWidth - 1 downto 0);

  signal dWrAddressReady        : boolean;
  signal dLatchedAddress        : unsigned(kNiDmaAddressWidth - 1 downto 0);
  signal dLatchedBaggage        : NiDmaBaggage_t;
  signal dLatchedData           : std_logic_vector(dDramWrFifoDataIn'range);
  signal dSerializingData       : boolean;
  signal dConsumeLatchedAddress : boolean;

  signal dLatchedRdAddress        : unsigned(kNiDmaAddressWidth - 1 downto 0);
  signal dLatchedRdBaggage        : NiDmaBaggage_t;

  -- OutOfRange is asserted when the address doesn't meet the configuration of RegPort Regs
  signal dOutOfRange : boolean := false;

  signal dAcceptRead : boolean := false;
  signal dAcceptWrite : boolean := false;
  signal dAcceptWriteData : boolean := false;

  signal dReadyToRead : boolean := false;
  signal dReadyForValidReadDmaPort : boolean := false;
  signal dAcceptValidReadDmaPort : boolean := false;
  signal dReadyForValidReadLlb : boolean;
  signal dValidReadIsNewLlb : boolean := true;
  signal dAcceptValidReadLlb : boolean := false;

  signal dReadyToWrite : boolean := false;
  signal dReadyForValidWrite : boolean := false;
  signal dAcceptValidWrite : boolean := false;

  signal dDmaDataValid : std_logic := '0';
  signal dMyPop : boolean := false;

  signal dConsumeBadRead: boolean := false;
  signal dConsumeBadWrite: boolean := false;

  -- DRAM Input signals from the Window that we may need to default if they are not implemented there.
  signal dLocalDramAddrFifoAddrRaw : std_logic_vector(dDramAddrFifoAddr'range);
  signal dLocalDramAddrFifoAddr    : std_logic_vector(dDramAddrFifoAddr'range);
  signal dLocalDramAddrFifoCmd     : std_logic_vector(dDramAddrFifoCmd'range);
  signal dLocalDramAddrFifoWrEn    : std_logic;
  signal dLocalDramWrFifoDataIn    : std_logic_vector(dDramWrFifoDataIn'range);
  signal dLocalDramWrFifoMaskData  : std_logic_vector(dDramWrFifoMaskData'range);
  signal dLocalDramWrFifoWrEn      : std_logic;
  signal dLocalAccessIsLlb         : boolean;

  constant kLastWrWord  : natural := Larger(kDramInterfaceDataWidth, kNiDmaDataWidth) / kNiDmaDataWidth - 1;
  signal dCurrentWrWord : natural range 0 to kLastWrWord;

  signal dDramAcceptCmd      : boolean;
  signal dLlbDramAcceptCmd   : boolean;

  -- Returns true when address given is within the valid range
  function ValidAddress (Addr : std_logic_vector;
                         NumOfMemBuffers : std_logic_vector;
                         LocalAccessIsLlb : boolean)
                   return boolean is
  begin
    --Should be a variable shift-left (with the control the size of NumOfMemBuffers) and a comparator
    if LocalAccessIsLlb then
      return kSizeOfLlbMemBufferinBytes  > unsigned(Addr);
    else
      return kSizeOfMemBufferinBytes * resize(unsigned(NumOfMemBuffers), Addr'length) > unsigned(Addr);
    end if;
  end ValidAddress;

  -- given an input address, returns the offset within the addressed buffer
  function getOffsetWithinBuffer(Addr : std_logic_vector(kDramInterfaceAddressWidth-1 downto 0))
    return unsigned is
  begin
    return unsigned(Addr(kSizeOfMemBuffers-1 downto 0));
  end getOffsetWithinBuffer;

  -- given an input address, returns which buffer we are accessing
  function getBufferNumber(Addr : std_logic_vector(kDramInterfaceAddressWidth-1 downto 0))
    return integer is
  begin
    return to_integer(unsigned(Addr(kMaxNumOfMemBuffers+kSizeOfMemBuffers-1 downto kSizeOfMemBuffers)));
  end getBufferNumber;

  -- given a register address, returns an index into the base address table
  function getBaseAddressIndex(regPortAddress : unsigned)
    return natural is
  begin
    return ((to_integer(regPortAddress/4) * 16) - kBufferAddressLo(0)) / kRegPortAddressesPerBuffer;
  end getBaseAddressIndex;

  --vhook_warn Hard coding address alignment of 8 bytes (64 bits)
  function WordSwap(Data : std_logic_vector(kDramInterfaceDataWidth-1 downto 0)) return std_logic_vector is
    variable j : natural;
    variable RetVal : std_logic_vector(kDramInterfaceDataWidth-1 downto 0);
  begin
    if kDramInterfaceDataWidth >= 64 then
      for i in 0 to kDramInterfaceDataWidth/64 -  1 loop
        j := kDramInterfaceDataWidth/64 - 1 - i;
        RetVal(i*64 + 63 downto i*64) := Data(j*64 + 63 downto j*64);
      end loop;
    else
      RetVal := Data;
    end if;
    return RetVal;
  end function WordSwap;

begin

  --synopsys translate_off
  assert kNiDmaInputDataReadLatency < 2**(kDataFifoAddrW-1)
    report "Too high DMA Input read latency configured"
    severity failure;
  --synopsys translate_on

  LocalArbq : process(DMAClk, aBusReset)
  begin -- LocalArbq
    if aBusReset = '1' then
      dLocalAccessIsLlb <= false;
    elsif rising_edge(DMAClk) then
      --We give access to a requester if it wants the interface (valid = '1') and either
      -- the other requester is not using it or is just releasing it. This allows
      -- contiguous accesses when there is no interface conflict.
      if dDramAddrFifoWrEn = '1' and
         (dLlbDramAcceptCmd or dLlbDramAddrFifoWrEn = '0') then
        dLocalAccessIsLlb <= false;
      elsif dLlbDramAddrFifoWrEn = '1' and
           (dDramAcceptCmd or dDramAddrFifoWrEn = '0') then
        dLocalAccessIsLlb <= true;
      end if;
    end if;
  end process LocalArbq;

  WrBufferState : process(DMAClk, aBusReset)
  begin -- WrBufferSTate
    if aBusReset = '1' then
      dWrAddressReady       <= false;
      dAcceptValidWrite     <= false;
      dLatchedAddress       <= (others => '0');
      dLatchedBaggage       <= (others => '0');
      dLatchedData          <= (others => '0');
      dSerializingData      <= false;
      dCurrentWrWord        <= 0;
    elsif rising_edge(DMAClk) then
      dAcceptValidWrite     <= false;

      if not dWrAddressReady  then
        if  dReadyForValidWrite and not dSerializingData then
          --Accept write and latch info prepared for DmaPort (mapped address and
          -- swapped data)
          dAcceptValidWrite <= true;
          dLatchedAddress   <= dMappedAddr;
          dLatchedData      <= WordSwap(dLocalDramWrFifoDataIn);
          dLatchedBaggage   <= dMappedBaggage;
          dWrAddressReady   <= true;

          dSerializingData  <= true;
        end if;
      else
        if dConsumeLatchedAddress then
          dWrAddressReady  <= false;
        end if;
      end if;

      if dSerializingData then
        if dEmptyCount > 0 then
          if dCurrentWrWord = kLastWrWord then
            dSerializingData <= false;
          else
            dCurrentWrWord <= dCurrentWrWord + 1;
          end if;
        end if;
      else
        dCurrentWrWord    <= 0;
      end if;

    end if;
  end process WrBufferState;

  --These muxes take care of arbitrating the two DRAM interfaces as well as
  -- driving the signals with valid values when they are not driven by LabVIEW

  --NOTE! Same MUX structure repeated over and over. Keep consistency if modified.
  dLocalDramAddrFifoAddrRaw <= dDramAddrFifoAddr      when kHmbInUse and not dLocalAccessIsLlb else
                               dLlbDramAddrFifoAddr   when kLlbInUse and     dLocalAccessIsLlb else
                               (others => '0');
  dLocalDramAddrFifoCmd     <= dDramAddrFifoCmd       when kHmbInUse and not dLocalAccessIsLlb else
                               dLlbDramAddrFifoCmd    when kLlbInUse and     dLocalAccessIsLlb else
                               (others => '0');
  dLocalDramAddrFifoWrEn    <= dDramAddrFifoWrEn      when kHmbInUse and not dLocalAccessIsLlb else
                               dLlbDramAddrFifoWrEn   when kLlbInUse and     dLocalAccessIsLlb else
                               '0';
  dLocalDramWrFifoDataIn    <= dDramWrFifoDataIn      when kHmbInUse and not dLocalAccessIsLlb else
                               dLlbDramWrFifoDataIn   when kLlbInUse and     dLocalAccessIsLlb else
                               (others => '0');
  --Byte enables (MaskData) can be a future improvement. Not implemented.
  --vhook_nowarn dLocalDramWrFifoMaskData
  dLocalDramWrFifoMaskData  <= dDramWrFifoMaskData    when kHmbInUse and not dLocalAccessIsLlb else
                               dLlbDramWrFifoMaskData when kLlbInUse and     dLocalAccessIsLlb else
                               (others => '0');
  dLocalDramWrFifoWrEn      <= dDramWrFifoWrEn        when kHmbInUse and not dLocalAccessIsLlb else
                               dLlbDramWrFifoWrEn     when kLlbInUse and     dLocalAccessIsLlb else
                               '0';

  dLocalCoreEnabled         <= dHmbCoreEnabled        when kHmbInUse and not dLocalAccessIsLlb else
                               dLlbCoreEnabled        when kLlbInUse and     dLocalAccessIsLlb else
                               false;


  ConsumeInvalidRequest: process (aBusReset, DMAClk) is
  begin
    if aBusReset = '1' then  -- Initialize signal values
      dConsumeBadRead <= false;
      dConsumeBadWrite <= false;
    elsif rising_edge(DMAClk) then
      dConsumeBadRead <= dReadyToRead and dOutOfRange;
      dConsumeBadWrite <= dReadyToWrite and dLocalDramWrFifoWrEn = '1' and dOutOfRange;
    end if;
  end process;

  -- Incoming address needs to be divided by 8 and multiplied by the number of bytes on
  --  the DRAM interface. Result created with shift, but direction of the shift depends
  --  on the relationship of the constants involved.
  process(dLocalDramAddrFifoAddrRaw)
    constant kTotalLeftShift : integer := log2(kDramInterfaceDataWidth / 8) - 3;
  begin
    if kTotalLeftShift < 0 then
      dLocalDramAddrFifoAddr <= std_logic_vector(shift_right(unsigned(dLocalDramAddrFifoAddrRaw), -kTotalLeftShift));
    else
      dLocalDramAddrFifoAddr <= std_logic_vector(shift_left(unsigned(dLocalDramAddrFifoAddrRaw), kTotalLeftShift));
    end if;
  end process;

  -- indicates this is beyond the buffer limit
  -- !CLOCK BOUNDARY CROSSING!
  -- This is okay because SW promises to not change NumOfMemBuffers
  -- while the core is enabled.
  dOutOfRange <= not ValidAddress(dLocalDramAddrFifoAddr, bNumOfMemBuffers, dLocalAccessIsLlb);


  ---------------------------------------------------
  -- READ
  ---------------------------------------------------
  -- Application has something that is ready to be read
  dReadyToRead <= dLocalDramAddrFifoCmd = kReadCmd and
                  dLocalDramAddrFifoWrEn = '1' and
                  dLocalCoreEnabled; -- This comes from a regport register

  -- the read is valid
  dReadyForValidReadDmaPort <= dReadyToRead and not dOutOfRange and not dLocalAccessIsLlb;
  dReadyForValidReadLlb     <= dReadyToRead and not dOutOfRange and     dLocalAccessIsLlb;

  -- accept dead addresses or real ones
  dAcceptRead <= dConsumeBadRead or dAcceptValidReadDmaPort or dAcceptValidReadLlb;

  ---------------------------------------------------
  -- WRITE
  ---------------------------------------------------

  -- Application has something that is ready to be written
  dReadyToWrite <= dLocalDramAddrFifoCmd = kWriteCmd and -- they are doing a write
                   dLocalDramAddrFifoWrEn = '1' and      -- they have an address for me
                   dLocalDramWrFifoWrEn = '1' and        -- they have data for me
                   dLocalCoreEnabled;                    -- Host enabled me

  -- Make an Arbiter request if application has a valid write
  dReadyForValidWrite <= dReadyToWrite and not dOutOfRange;

  -- Consume this write request, because it's invalid or the Dma is ready
  dAcceptWrite <= dConsumeBadWrite or dAcceptValidWrite;

  dAcceptWriteData <= dConsumeBadWrite or dAcceptValidWrite;

  --------------------------------------------------------

  -- consume address for a read or write
  dDramAcceptCmd    <= (dAcceptRead or dAcceptWrite) and not dLocalAccessIsLlb;
  dLlbDramAcceptCmd <= (dAcceptRead or dAcceptWrite) and     dLocalAccessIsLlb;

  dDramAddrFifoFull    <= to_StdLogic(not dDramAcceptCmd);
  dLlbDramAddrFifoFull <= to_StdLogic(not dLlbDramAcceptCmd);

  -- consume data for a write
  dDramWrFifoFull    <= to_StdLogic(not dAcceptWriteData or     dLocalAccessIsLlb);
  dLlbDramWrFifoFull <= to_StdLogic(not dAcceptWriteData or not dLocalAccessIsLlb);

  -- Conditions for not letting anything through
  dPhyInitDoneForLvfpga    <= to_StdLogic(dHmbCoreEnabled);
  dLlbPhyInitDoneForLvfpga <= to_StdLogic(dLlbCoreEnabled);

  ------------------------------------------------------
  -- Remap Address

  -- Index for tables that store info per-buffer
  dBufferIndex <= getBufferNumber(dLocalDramAddrFifoAddr);

  -- !CLOCK BOUNDARY CROSSING!
  -- This is okay because SW promises to not change the base address
  -- table while the core is enabled.

  -- This is the selected address from the table
  Assign32: if kNiDmaAddressWidth = 32 generate
    dBaseAddr <= bLowLatencyBufferLo when dLocalAccessIsLlb else
                 bBaseAddrTableLo(dBufferIndex);
  end generate;
  Assign64: if kNiDmaAddressWidth = 64 generate
    -- The regport width is always 32 bits. but the physical
    -- address may be 64 bits, so we use two entries
    dBaseAddr <= bLowLatencyBufferHi & bLowLatencyBufferLo when dLocalAccessIsLlb else
                 bBaseAddrTableHi(dBufferIndex) & bBaseAddrTableLo(dBufferIndex);
  end generate;

  -- !CLOCK BOUNDARY CROSSING!
  -- Similarly, this is okay because SW promises to not change Baggage registers
  -- while the core is enabled.
  dMappedBaggage <= bBaggageBits(dBufferIndex) when not dLocalAccessIsLlb else
                    bLlbBaggageBits;
  -- physical address = base address + buffer offset
  dMappedAddr <= unsigned(dBaseAddr) + getOffsetWithinBuffer(dLocalDramAddrFifoAddr);

  --The delay in the signals is fine because the state machine takes at least one cycle
  -- between dReadyToRead (coherent with dMapped*) and using the address and baggage
  LatchRdMuxes : process(DMAClk, aBusReset)
  begin -- LatchRdMuxes
    if to_Boolean(aBusReset) then
      dLatchedRdAddress  <= (others => '0');
      dLatchedRdBaggage  <= (others => '0');
    elsif rising_edge(DMAClk) then
      dLatchedRdAddress  <= dMappedAddr;
      dLatchedRdBaggage  <= dMappedBaggage;
    end if;
  end process LatchRdMuxes;



  -- Connect the data output of the fifo to DMAPort Input data
  dNiFpgaInputDataToDma.Data <= dDataOut when dDmaDataValid = '1'
                                else (others => '0');


  --------------------------------------------
  -- Read Data
  WidePath: if kDramInterfaceDataWidth > kNiDmaDataWidth generate
    constant kLastRdWord  : natural := Larger(kDramInterfaceDataWidth, kNiDmaDataWidth) / kNiDmaDataWidth - 1;
    type DmaDataArray_t is array (natural range <>) of NiDmaData_t;
    signal dDmaDataHistory : DmaDataArray_t(0 to kLastRdWord-1);
    signal dDramRdFifoDataOutLcl : std_logic_vector(dDramRdFifoDataOut'range);
  begin

    ReadDeserializer : process(DMAClk, aBusReset)
    begin -- ReadDeserializer
      if aBusReset = '1' then
        dDmaDataHistory <= (others => (others => '0'));
      elsif rising_edge(DMAClk) then
        if dNiFpgaOutputDataFromDma.Push and
              (dNiFpgaOutputDataFromDma.Space = kNiDmaSpaceDirectSysMem) and
              (dNiFpgaOutputDataFromDma.Channel = kDmaChannelNum) then
          --Shifiting data top down so earliest data ends up at the bottom (little endian)
          dDmaDataHistory(kLastRdWord-1) <= dNiFpgaOutputDataFromDma.Data;
          for i in 0 to kLastRdWord - 2 loop
            dDmaDataHistory(i) <= dDmaDataHistory(i + 1);
          end loop;
        end if;
      end if;
    end process ReadDeserializer;

    ReadWordAggregation : process(dNiFpgaOutputDataFromDma.Data, dDmaDataHistory)
    begin
      dDramRdFifoDataOutLcl((kLastRdWord+1)*kNiDmaDataWidth-1 downto kLastRdWord*kNiDmaDataWidth) <=
          dNiFpgaOutputDataFromDma.Data;
      for i in 0 to kLastRdWord - 1 loop
        dDramRdFifoDataOutLcl((i+1)*kNiDmaDataWidth-1 downto i*kNiDmaDataWidth) <=
          dDmaDataHistory(i);
      end loop;
    end process;

    dDramRdFifoDataOut <= WordSwap(dDramRdFifoDataOutLcl);
  end generate;

  NarrowPath: if kDramInterfaceDataWidth <= kNiDmaDataWidth generate
  begin

    dDramRdFifoDataOut <= dNiFpgaOutputDataFromDma.Data(kDramInterfaceDataWidth-1 downto 0);

  end generate;

  -- Asserted Push signal means that the data is valid to be read by the DRAM interface
  dDramRdDataValid <= to_StdLogic(dNiFpgaOutputDataFromDma.Push and
                                  dNiFpgaOutputDataFromDma.TransferEnd and
                                  (dNiFpgaOutputDataFromDma.Space = kNiDmaSpaceDirectSysMem) and
                                  (dNiFpgaOutputDataFromDma.Channel = kDmaChannelNum));

  ---------------------------------
  -- Write Data

  -- Write the Input data to FIFO until DMAPort is ready to read the data

  dDequeue <= dDequeueDelay(kNiDmaInputDataReadLatency-2) = '1' and dFullCount /= 0;
  dDmaDataValid <= dDequeueDelay(kNiDmaInputDataReadLatency-2);

  -- DmaPort has a read latency, and our queue has a maximum latency of 1
  -- so delay the pop signal before we dequeue

  dMyPop <= dNiFpgaInputDataFromDma.Pop and
            (dNiFpgaInputDataFromDma.Space = kNiDmaSpaceDirectSysMem) and
            (dNiFpgaInputDataFromDma.Channel = kDmaChannelNum);

  PopDelayShiftRegister: process (aBusReset, DMAClk) is
  begin
    if aBusReset = '1' then  -- Initialize signal values
      dDequeueDelay <= (others => '0');
    elsif rising_edge(DMAClk) then
      dDequeueDelay <= std_logic_vector(shift_left(unsigned(dDequeueDelay), 1));
      dDequeueDelay(0) <= to_StdLogic(dMyPop);
    end if;
  end process PopDelayShiftRegister;



-- !STATE MACHINE STARTUP! This state machine cannot start
-- immediately after aBusReset deasserts because enable resets
-- to false; thus, the asynchronous reset is safe.
  ArbiterStateRegs : process (aBusReset, DMAClk) is
  begin
    if aBusReset = '1' then
      dArbiterIfcRdState <= IDLE;
      dArbiterIfcWrState <= IDLE;
    elsif rising_edge(DMAClk) then
      dArbiterIfcRdState <= dArbiterIfcRdStateNxt;
      dArbiterIfcWrState <= dArbiterIfcWrStateNxt;
    end if;
  end process;

  ArbiterNextRdState : process (dArbiterIfcRdState,
                                dReadyForValidReadDmaPort,
                                dLatchedRdAddress,
                                dLatchedRdBaggage,
                                dNiFpgaOutputArbGrant,
                                dNiFpgaOutputRequestFromDma) is
  begin
    dNiFpgaOutputArbReq <= kNiDmaArbReqZero;
    dArbiterIfcRdStateNxt <= dArbiterIfcRdState;
    dNiFpgaOutputRequestToDma <= kNiDmaOutputRequestToDmaZero;
    dAcceptValidReadDmaPort <= False;

    case dArbiterIfcRdState is
      when IDLE =>
        -- wait until we have a valid read request
        if dReadyForValidReadDmaPort then
          dArbiterIfcRdStateNxt <= REQ;
        end if;
      when REQ =>

        -- signal the arbiter, we would like to make a request
        dNiFpgaOutputArbReq.NormalReq <= '1';

        -- move to the next state as soon as this request is granted
        if dNiFpgaOutputArbGrant.Grant = '1' then
          dArbiterIfcRdStateNxt <= GRANT;
        end if;
      when GRANT =>

        -- We have access to the DMA, make the request
        dNiFpgaOutputRequestToDma.Request <= True;
        dNiFpgaOutputRequestToDma.Space <= kNiDmaSpaceDirectSysMem;
        dNiFpgaOutputRequestToDma.Channel <= kDmaChannelNum;
        dNiFpgaOutputRequestToDma.Baggage <= dLatchedRdBaggage;
        dNiFpgaOutputRequestToDma.ByteCount <=
          to_unsigned(kDramInterfaceDataWidth/8, kByteCountLength);
        dNiFpgaOutputRequestToDma.Address <= unsigned(dLatchedRdAddress);

        -- move to next state as soon as this request is granted
        if dNiFpgaOutputRequestFromDma.Acknowledge then
          dArbiterIfcRdStateNxt <= DONE;
          dAcceptValidReadDmaPort <= True;
        end if;
      when DONE =>
        dNiFpgaOutputArbReq.DoneStrb <= '1';
        dArbiterIfcRdStateNxt <= IDLE;
    end case;
  end process;

  ArbiterNextWrState : process (dArbiterIfcWrState,
                                dWrAddressReady,
                                dLatchedAddress,
                                dLatchedBaggage,
                                dFullCount,
                                dNiFpgaInputArbGrant,
                                dNiFpgaInputRequestFromDma) is
  begin
    dArbiterIfcWrStateNxt <= dArbiterIfcWrState;
    dNiFpgaInputArbReq <= kNiDmaArbReqZero;
    dNiFpgaInputRequestToDma <= kNiDmaInputRequestToDmaZero;
    dConsumeLatchedAddress <= False;
    case dArbiterIfcWrState is
      when IDLE =>
        -- wait until we have a valid write request
        -- And we are close enough to serializing all the data (but we have started)
        if dWrAddressReady and dFullCount > Larger(0, kLastWrWord - kNiDmaInputDataReadLatency) then
          dArbiterIfcWrStateNxt <= REQ;
        end if;
      when REQ =>

        -- signal the arbiter, we would like to make a request
        dNiFpgaInputArbReq.NormalReq <= '1';

        -- move to the next state as soon as this request is granted
        if dNiFpgaInputArbGrant.Grant = '1' then
          dArbiterIfcWrStateNxt <= GRANT;
        end if;
      when GRANT =>

        -- We have access to the DMA, make the request
        dNiFpgaInputRequestToDma.Request <= True;
        dNiFpgaInputRequestToDma.Space <= kNiDmaSpaceDirectSysMem;
        dNiFpgaInputRequestToDma.Channel <= kDmaChannelNum;
        dNiFpgaInputRequestToDma.Baggage <= dLatchedBaggage;
        dNiFpgaInputRequestToDma.ByteCount <=
          to_unsigned(kDramInterfaceDataWidth/8, kByteCountLength);
        dNiFpgaInputRequestToDma.Address <= unsigned(dLatchedAddress);

        -- move to next state as soon as this request is granted
        if dNiFpgaInputRequestFromDma.Acknowledge then
          dConsumeLatchedAddress <= True;
          dArbiterIfcWrStateNxt <= DONE;
        end if;
      when DONE =>
        dNiFpgaInputArbReq.DoneStrb <= '1';
        dArbiterIfcWrStateNxt <= IDLE;
    end case;
  end process;


  -- Write the Input data from the FIFO to DMAPort by serializing it.
  dPushValidWrite <= dSerializingData and dEmptyCount > 0;

  --Muxing of serialized value depends on the relative widths of the interfaces.
  process ( dCurrentWrWord, dLatchedData)
  begin
    if kDramInterfaceDataWidth >= kNiDmaDataWidth then
      --Deconstruct large DRAM data into many small DMA words.
      for i in 0 to kNiDmaDataWidth -1 loop
        dValidWriteWord(i) <= dLatchedData(dCurrentWrWord * kNiDmaDataWidth + i);
      end loop;
    else
      --Fill large DMA word with small DRAM data.
      dValidWriteWord <= std_logic_vector(resize(unsigned(dLatchedData), kNiDmaDataWidth));
    end if;
  end process;

  --vhook_e SingleClkFifo
  --vhook_a kAddressWidth kDataFifoAddrW
  --vhook_a kWidth kNiDmaDataWidth
  --vhook_a kRamReadLatency 1
  --vhook_a kFifoAdditiveLatency  0
  --vhook_a aReset to_boolean(aBusReset)
  --vhook_a Clk DMAClk
  --vhook_a cReset false
  --vhook_a cClkEn true
  --vhook_a cWrite dPushValidWrite
  --vhook_a cDataIn dValidWriteWord
  --vhook_a cRead dDequeue
  --vhook_a cDataOut dDataOut
  --vhook_a cFullCount dFullCount
  --vhook_a cEmptyCount dEmptyCount
  --vhook_a cDataValid open
  SingleClkFifox: entity work.SingleClkFifo (rtl)
    generic map (
      kAddressWidth        => kDataFifoAddrW,   --positive
      kWidth               => kNiDmaDataWidth,  --positive
      kRamReadLatency      => 1,                --natural:=2
      kFifoAdditiveLatency => 0)                --natural:=1
    port map (
      aReset      => to_boolean(aBusReset),  --in  boolean
      Clk         => DMAClk,                 --in  std_logic
      cReset      => false,                  --in  boolean:=false
      cClkEn      => true,                   --in  boolean:=true
      cWrite      => dPushValidWrite,        --in  boolean
      cDataIn     => dValidWriteWord,        --in  std_logic_vector(kWidth-1:0)
      cRead       => dDequeue,               --in  boolean
      cDataOut    => dDataOut,               --out std_logic_vector(kWidth-1:0)
      cFullCount  => dFullCount,             --out unsigned(kAddressWidth:0)
      cEmptyCount => dEmptyCount,            --out unsigned(kAddressWidth:0)
      cDataValid  => open);                  --out boolean


  ---------------------------------------------------
  -- Regport Registers
  --XmlParse xml_on
  --<regmap name="Dram2DP" readablestrobes="false">
  --  <group name="Configuration Registers">
  --    <info> The configuration registers are used to control how the core operates.
  --      The registers hold values for version, enable, number of memory buffers, and
  --      addresses of all memory buffers. The core validates transactions from the DRAM
  --      interface from the information in the configuration registers. Each register is
  --      32 bit width (4 bytes) so the addresses are 4 bytes away from each other. The
  --      length of the table of addresses depends on a generic (kMaxNumOfMemBuffers)
  --      whose default value is 2 (meaning 2**2 = 4 buffers).
  --      Additionally, there is a register that sets a limit on how many memory buffers
  --      are allowed to be used </info>
  --    <register name="VersionRegister" offset="0x0" writable="false">
  --      <info>Version Register, each export of this core should have a different version</info>
  --    </register>
  --    <register name="CoreEnabled" offset="0x4">
  --      <info>Enable/Disable core</info>
  --      <bitfield name="Enable" range="0" initialvalue="0">
  --        <info>Enable/disable accesses from the HMB memory interface to host memory.</info>
  --      </bitfield>
  --    </register>
  --    <register name="NumberOfBuffers" offset="0x8">
  --      <bitfield name="NumOfBuffers" range="15..0" initialvalue="0">
  --        <info>The limit for the number of memory buffers the core is allowed to make use of. Reads outside of this limit will return 0xDEAD0000, Writes outside this limit will no-op.
  --              The max value that can be  written to this field is 2**(kMaxNumOfMemBuffers).</info>
  --      </bitfield>
  --    </register>
  --    <regtype name="32BitAddress"></regtype>
  --    <regtype name="BufferBaggageRegType">
  --      <bitfield name="Baggage"
  --                range='31..0'
  --                initialvalue='0'>
  --        <info>Value passed to DmaPort as baggage. Number of bits implemented depends on actual DmaPort config. See corresponding NI DMA
  --              (e.g. InChWORM documentation) for information about how this field is interpreted by the Host Bus Interface. The reset
  --              value of this register depends on the target and is passed as a generic. The fixed logic design engineer should be able to
  --              define that reset value to correspond to the right value for cache coherent accesses to host system memory given the target
  --              host bus interface. </info>
  --      </bitfield>
  --    </regtype>
  --    <register name="BufferAddressLoZero" offset="0xC" typename="32BitAddress" initialvalue="0">
  --      <info>This legacy offset is just an alias to the same register implemented as the first element of the @.BufferAddressLo register array.
  --            It is needed for backwards compatibility purposes. </info>
  --    </register>
  --    <register name="BufferAddressHiZero" offset="0x10" typename="32BitAddress" initialvalue="0">
  --      <info>This legacy offset is just an alias to the same register implemented as the first element of the @.BufferAddressHi register array.
  --            It is needed for backwards compatibility purposes. </info>
  --    </register>
  --    <register name="CoreEnabled2" offset="0x14">
  --      <info>The @.CoreEnabled register is a legacy register that can only enable the HMB memory interface. To keep backwards compatibility
  --            that register keeps its original function and this one allows independent enable and disable of both HMB and LLB memory
  --            interfaces. </info>
  --      <bitfield name="HmbEnable"  range="0" strobe="true">
  --        <info>Enable accesses from the HMB memory interface to host memory.</info>
  --      </bitfield>
  --      <bitfield name="HmbDisable" range="1" strobe="true">
  --        <info>Disable accesses from the HMB memory interface to host memory.</info>
  --      </bitfield>
  --      <bitfield name="HmbEnabled" range="2" writable="false">
  --        <info>Reports if HMB memory interface is enabled.</info>
  --      </bitfield>
  --      <bitfield name="LlbEnable"  range="4" strobe="true">
  --        <info>Enable accesses from the LLB memory interface to host memory.</info>
  --      </bitfield>
  --      <bitfield name="LlbDisable" range="5" strobe="true">
  --        <info>Disable accesses from the LLB memory interface to host memory.</info>
  --      </bitfield>
  --      <bitfield name="LlbEnabled" range="6" writable="false">
  --        <info>Reports if LLB memory interface is enabled.</info>
  --      </bitfield>
  --    </register>
  --    <register name="CoreCapabilities" offset="0x18" writable="false">
  --      <info>Report the capabilities of the Core that are fixed at synthesis.</info>
  --      <bitfield name="CapMaxNumOfMemBuffers" range="3..0" initialvalue="0">
  --        <info>Maximum value that can be set to @.NumOfBuffers</info>
  --      </bitfield>
  --      <bitfield name="CapSizeOfMemBuffers"   range="12..8" initialvalue="0">
  --        <info>Size of each memory buffer in host memory in bytes. The actual value is 2 raised to the power of the value of this field.</info>
  --      </bitfield>
  --      <bitfield name="CapSizeOfLlbMemBuffer"   range="20..16" initialvalue="0">
  --        <info>Size of the LLB memory buffer in host memory in bytes. The actual value is 2 raised to the power of the value of this field.</info>
  --      </bitfield>
  --      <bitfield name="CapHmbInUse"   range="24" initialvalue="0">
  --        <info>Report if the HMB buffer functionality is enabled at synthesis time. This can be tied to a value generated in LabVIEW to detect
  --              if the LabVIEW project configured a memory of this socket type in the FPGA VI. Or it can be tied to a constant to permanently
  --              enable or disable the feature (e.g. if not compatible with a given target or if core is presynthesized).</info>
  --      </bitfield>
  --      <bitfield name="CapLlbInUse"   range="25" initialvalue="0">
  --        <info>Report if the LLB buffer functionality is enabled at synthesis time. This can be tied to a value generated in LabVIEW to detect
  --              if the LabVIEW project configured a memory of this socket type in the FPGA VI. Or it can be tied to a constant to permanently
  --              enable or disable the feature (e.g. if not compatible with a given target or if core is presynthesized).</info>
  --      </bitfield>
  --    </register>
  --    <register name="LlbCapabilities" offset="0x1C" writable="false">
  --      <info>Report more capabilities of the Low Latency Buffer feature that are fixed at synthesis.</info>
  --      <bitfield name="DevRamSwBaseOffset" range="27..0" initialvalue="0">
  --        <info>Base address of the window where accesses will be routed to the local RAM. The window is always 4096 bytes. The fixed
  --              logic design engineer should be able to control the address reported in this field so it corresponds to the address in the
  --              FPGA address space available to the driver which is not necessarily the same as the address space locally decoded by the
  --              interface to the RAM itself. Note that because the window may be at a lower address, in device address space, than the
  --              LabVIEW FPGA Regport base address, this offset may be negative. The field should be interpreted as a signed value. </info>
  --      </bitfield>
  --    </register>
  --    <register name="LowLatencyBufferLo" offset="0x20" typename="32BitAddress" initialvalue="0">
  --      <info>Base address in system memory where LabVIEW FPGA write accesses will be routed for the Low Latency Memory buffer. On 64 bit systems, address is composed by combining this register and the @.LowLatencyBufferHi register</info>
  --    </register>
  --    <register name="LowLatencyBufferHi" offset="0x24" typename="32BitAddress" initialvalue="0">
  --      <info>Only used in 64 bit systems. Higher bits of the 64 bit address formed with the corresponding element of the @.LowLatencyBufferLo register. </info>
  --    </register>
  --    <register name="LowLatencyBufferBaggage" offset="0x28" typename="BufferBaggageRegType" initialvalue="0"></register>
  --    <register name="BufferAddressLo" offset="0x100" count="32" step="16" typename="32BitAddress" initialvalue="0">
  --      <info>Base address in system memory where LabVIEW FPGA accesses will be routed for the corresponding buffer. On 64 bit systems, address is composed by corresponding elements in this table and the @.BufferAddressHi table.</info>
  --    </register>
  --    <register name="BufferAddressHi" offset="0x104" count="32" step="16" typename="32BitAddress" initialvalue="0">
  --      <info>Only used in 64 bit systems. Higher bits of the 64 bit address formed with the corresponding element of the @.BufferAddressLo register table</info>
  --    </register>
  --    <register name="BufferBaggage" offset="0x108" count="32" step="16" typename="BufferBaggageRegType" initialvalue="0"></register>
  --  </group>
  --</regmap>
  --XmlParse xml_off

  RegPortRegisters: process (aBusReset, BusClk) is
    variable vRegPortOut : RegPortOut_t := kRegPortOutZero;
    procedure DriveRegPortOut(RegPortIn : RegPortIn_t; RegPortOut : inout RegPortOut_t; ReadOnly : boolean := false) is
    begin
      RegPortOut.Data      := RegPortOut.Data; --Not doing anything, just cleaning linting message
      RegPortOut.Ready     := RegPortOut.Ready and not (RegPortIn.Rd or (RegPortIn.Wt and not ReadOnly));
      RegPortOut.DataValid := RegPortOut.DataValid or RegPortIn.Rd;
    end procedure DriveRegPortOut;
  begin
    if aBusReset = '1' then
      bHmbCoreEnabled <= false;
      bLlbCoreEnabled <= false;
      bBaseAddrTableLo <= (others => Zeros(32));
      bBaseAddrTableHi <= (others => Zeros(32));
      bLowLatencyBufferLo <= Zeros(32);
      bLowLatencyBufferHi <= Zeros(32);
      bLlbBaggageBits <= kDefaultBaggage;
      bBaggageBits <= (others => kDefaultBaggage);
      bNumOfMemBuffers <= (others=>'0');
      bRegPortOut <= kRegPortOutZero;
    elsif rising_edge(BusClk) then

      -- default values for regportout
      vRegPortOut.DataValid := false;
      vRegPortOut.Ready     := true;
      vRegPortOut.Data      := (others => '0');

      if bRegPortIn.address = (kVersionRegister / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut, ReadOnly => true);
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or kCoreVersion;
        end if;
      end if;

      if bRegPortIn.address = (kCoreEnabled / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          bHmbCoreEnabled <= to_boolean(bRegPortIn.Data(kEnable));
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or SetBit(kEnable, bHmbCoreEnabled);
        end if;
      end if;

      if bRegPortIn.address = (kCoreEnabled2 / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          if to_boolean(bRegPortIn.Data(kHmbEnable)) then
            bHmbCoreEnabled <= true;
          elsif to_boolean(bRegPortIn.Data(kHmbDisable)) then
            bHmbCoreEnabled <= false;
          end if;
          if to_boolean(bRegPortIn.Data(kLlbEnable)) then
            bLlbCoreEnabled <= true;
          elsif to_boolean(bRegPortIn.Data(kLlbDisable)) then
            bLlbCoreEnabled <= false;
          end if;
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or SetBit(kHmbEnabled, bHmbCoreEnabled);
          vRegPortOut.Data := vRegPortOut.Data or SetBit(kLlbEnabled, bLlbCoreEnabled);
        end if;
      end if;

      if bRegPortIn.address = (kNumberOfBuffers / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          bNumOfMemBuffers <= bRegPortIn.Data(kNumOfBuffers+bNumOfMemBuffers'length-1 downto kNumOfBuffers);
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or SetField(kNumOfBuffers, bNumOfMemBuffers);
        end if;
      end if;

      if bRegPortIn.address = (kBufferAddressLoZero / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          bBaseAddrTableLo(0) <= bRegPortIn.Data;
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or bBaseAddrTableLo(0);
        end if;
      end if;

      if bRegPortIn.address = (kBufferAddressHiZero / 4) and kNiDmaAddressWidth = 64 then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          bBaseAddrTableHi(0) <= bRegPortIn.Data;
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or bBaseAddrTableHi(0);
        end if;
      end if;

      if bRegPortIn.address = (kCoreCapabilities / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut, ReadOnly => true);
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or SetField(kCapMaxNumOfMemBuffers, kMaxNumOfMemBuffers);
          vRegPortOut.Data := vRegPortOut.Data or SetField(kCapSizeOfMemBuffers,   kSizeOfMemBuffers);
          vRegPortOut.Data := vRegPortOut.Data or SetField(kCapSizeOfLlbMemBuffer, kSizeOfLlbMemBuffer);
          vRegPortOut.Data := vRegPortOut.Data or SetBit  (kCapHmbInUse,           kHmbInUse);
          vRegPortOut.Data := vRegPortOut.Data or SetBit  (kCapLlbInUse,           kLlbInUse);
        end if;
      end if;

      if bRegPortIn.address = (kLlbCapabilities / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut, ReadOnly => true);
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or SetField(kDevRamSwBaseOffset,
                                                    unsigned(to_signed(kDevRamSWOffset, kDevRamSwBaseOffsetSize)));
        end if;
      end if;

      if bRegPortIn.address = (kLowLatencyBufferLo / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          bLowLatencyBufferLo <= bRegPortIn.Data;
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or bLowLatencyBufferLo;
        end if;
      end if;

      if bRegPortIn.address = (kLowLatencyBufferHi / 4) and kNiDmaAddressWidth = 64 then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          bLowLatencyBufferHi <= bRegPortIn.Data;
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or bLowLatencyBufferHi;
        end if;
      end if;

      if bRegPortIn.address = (kLowLatencyBufferBaggage / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          bLlbBaggageBits <= bRegPortIn.Data(kNiDmaBaggageWidth-1 downto 0);
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or SetField(0, bLlbBaggageBits);
        end if;
      end if;

      for index in 0 to 2**kMaxNumOfMemBuffers-1 loop
        if bRegPortIn.address = (kBufferAddressLo(index) / 4) then
          DriveRegPortOut(bRegPortIn, vRegPortOut);
          if bRegPortIn.Wt then
            bBaseAddrTableLo(index) <= bRegPortIn.Data;
          end if;
          if bRegPortIn.Rd then
            vRegPortOut.Data := vRegPortOut.Data or bBaseAddrTableLo(index);
          end if;
        end if;

        if bRegPortIn.address = (kBufferAddressHi(index) / 4) and kNiDmaAddressWidth = 64 then
          DriveRegPortOut(bRegPortIn, vRegPortOut);
          if bRegPortIn.Wt then
            bBaseAddrTableHi(index) <= bRegPortIn.Data;
          end if;
          if bRegPortIn.Rd then
            vRegPortOut.Data := vRegPortOut.Data or bBaseAddrTableHi(index);
          end if;
        end if;

        if bRegPortIn.address = (kBufferBaggage(index) / 4) then
          DriveRegPortOut(bRegPortIn, vRegPortOut);
          if bRegPortIn.Wt then
            bBaggageBits(index) <= bRegPortIn.Data(kNiDmaBaggageWidth-1 downto 0);
          end if;
          if bRegPortIn.Rd then
            vRegPortOut.Data := vRegPortOut.Data or SetField(0, bBaggageBits(index));
          end if;
        end if;

      end loop;

      bRegPortOut <= vRegPortOut;
    end if;
  end process RegPortRegisters;

  -- !CLOCK BOUNDARY CROSSING!
  -- Double syncs are ok because the Enable signals don't need to be correlated
  -- with any other signal crossing these clocks at the same time.
  DoubleSyncBoolHmb: entity work.DoubleSyncBool (behavior)
    port map (
      aReset => to_boolean(aBusReset),  --in  boolean
      iClk   => BusClk,                 --in  std_logic
      iSig   => bHmbCoreEnabled,                    --in  boolean
      oClk   => DMAClk,                 --in  std_logic
      oSig   => dHmbCoreEnabled);                   --out boolean

  DoubleSyncBoolLlb: entity work.DoubleSyncBool (behavior)
    port map (
      aReset => to_boolean(aBusReset),  --in  boolean
      iClk   => BusClk,                 --in  std_logic
      iSig   => bLlbCoreEnabled,                    --in  boolean
      oClk   => DMAClk,                 --in  std_logic
      oSig   => dLlbCoreEnabled);                   --out boolean

  LlbReadDly : process(DMAClk, aBusReset)
  begin -- LlbReadDly
    if aBusReset = '1' then
      dValidReadIsNewLlb <= true;
    elsif rising_edge(DMAClk) then
      --Deassert with dReadyForValidReadLlb (no longer new)
      --Assert again with not dReadyForValidReadLlb (next is new again) or with
      -- dAcceptValidReadLlb (if read stays asserted, it is new)
      dValidReadIsNewLlb <= not dReadyForValidReadLlb or dAcceptValidReadLlb;
    end if;
  end process LlbReadDly;

  --New read is
  dAcceptValidReadLlb   <= dReadyForValidReadLlb and dValidReadIsNewLlb;

  --vhook_warn Address alignment is hard coded.
  dLclAddr   <= dLocalDramAddrFifoAddr(Log2(kDramInterfaceDataWidth/8) + dLclAddr'length - 1 downto Log2(kDramInterfaceDataWidth/8));
  dCoreReset <= not dLlbCoreEnabled;

  --Save the memory if not used, or if target not interested in feature.

  DevMem : if kLlbInUse generate
    signal dLclDataValid: boolean;
    signal dLclDout: std_logic_vector(kDramInterfaceDataWidth-1 downto 0);
  begin

    --vhook_e SingleClockDeviceRam
    --vhook_g kDevRamSizeInBytes        kLocalMemSizeInBytes
    --vhook_g kDevRamViAccessSizeInBits kDramInterfaceDataWidth
    --vhook_a adReset                   to_Boolean(aBusReset)
    --vhook_a DmaClock                  DMAClk
    --vhook_a dLclRd                    dAcceptValidReadLlb
    SingleClockDeviceRamx: entity work.SingleClockDeviceRam (RTL)
      generic map (
        kDevRamSizeInBytes        => kLocalMemSizeInBytes,     --natural:=16#1000#
        kDevRamSinkOffset         => kDevRamSinkOffset,        --natural:=kNiDmaHighSpeedSinkBase+16#1000#
        kDevRamViAccessSizeInBits => kDramInterfaceDataWidth)  --natural:=256
      port map (
        adReset               => to_Boolean(aBusReset),  --in  boolean
        dCoreReset            => dCoreReset,             --in  boolean
        DmaClock              => DMAClk,                 --in  std_logic
        dHighSpeedSinkFromDma => dHighSpeedSinkFromDma,  --in  NiDmaHighSpeedSinkFromDma_t
        dLclAddr              => dLclAddr,               --in  std_logic_vector(Log2(kDevRamSizeInBytes*8/kDevRamViAccessSizeInBits):0)
        dLclDout              => dLclDout,               --out std_logic_vector(kDevRamViAccessSizeInBits-1:0)
        dLclRd                => dAcceptValidReadLlb,    --in  boolean
        dLclDataValid         => dLclDataValid);         --out boolean

    dLlbDramRdDataValid   <= to_StdLogic(dLclDataValid);
    dLlbDramRdFifoDataOut <= WordSwap(dLclDout);

  end generate;

  NoDevMem : if not kLlbInUse generate
  begin

    dLlbDramRdDataValid   <= '0';
    dLlbDramRdFifoDataOut <= (others => '0');

  end generate;

end rtl;
