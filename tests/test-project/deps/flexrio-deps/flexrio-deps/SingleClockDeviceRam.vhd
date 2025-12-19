-------------------------------------------------------------------------------
--
-- File: SingleClockDeviceRam.vhd
-- Author: Hector Rubio
-- Original Project: Device RAM Socketed CLIP
-- Date: 19 Feb 2020
--
-------------------------------------------------------------------------------
-- (c) 2020 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--    On-device RAM using XPM component
--    Port A Written with high speed sink port
--    Port B Read from direct I/O. Latency set to 2 which means data is valid
--     two clock cycles after the clock edge in which a new address is captured.
--
--    The read port has an address length that is one bit more than needed for
--     accessing the RAM. The upper half of the address space is used to implement
--     status registers that can be read from the FPGA side. The only register
--     implemented is a total transfer count register so it can be used for
--     polling to data to be written without the need for sentinels in the data written.
--
--
--    For reference, see UG974, e.g. at the moment of this writing:
--     https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_1/ug974-vivado-ultrascale-libraries.pdf
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;
  use work.PkgNiDma.all;
  use work.PkgNiDmaConfig.all;

library xpm;
  use xpm.VCOMPONENTS.all;

entity SingleClockDeviceRam is
  generic (
    kDevRamSizeInBytes        : natural := 16#1000#;  --4K
    --Default value is the typical location of the 63rd DMA Channel
    kDevRamSinkOffset         : natural := kNiDmaHighSpeedSinkBase + 16#1000#;
    kDevRamViAccessSizeInBits : natural := 256
  );
  port (

    adReset               : in boolean;
    dCoreReset            : in boolean;
    DmaClock              : in std_logic;
    dHighSpeedSinkFromDma : in NiDmaHighSpeedSinkFromDma_t;

    --Twice the address space needed for the memory. Upper half is for registers
    dLclAddr : in std_logic_vector(Log2(kDevRamSizeInBytes*8/kDevRamViAccessSizeInBits) downto 0);
    dLclDout : out std_logic_vector(kDevRamViAccessSizeInBits-1 downto 0);

    --Optional interface to shift register that matches the latency of the RAM
    --If pulse is strobed in LclRd, LclDataValid will strobe when dLclDout has data
    -- corresponding to address capture when dLclRd strobed
    dLclRd        : in  boolean;
    dLclDataValid : out boolean
  );
end entity; --SingleClockDeviceRam

architecture RTL of SingleClockDeviceRam is

  --vhook_warn This implementation assumes Read size larger than dma size always.
  constant kMemRdDataSize : natural := Smaller(kDevRamViAccessSizeInBits, 4*kNiDmaDataWidth);
  constant kPortRatio     : natural := kMemRdDataSize / kNiDmaDataWidth;
  constant kNumOfMemories : natural := kDevRamViAccessSizeInBits / kMemRdDataSize;

  constant kHssinkAddrLsb : natural := Log2(kNiDmaDataWidth/8);
  constant kTargetAddrLsb : natural := kHssinkAddrLsb + Log2(kPortRatio);
  constant kMemAddrLsb    : natural := kTargetAddrLsb + Log2(kNumOfMemories);

  signal dHssinkAddress: std_logic_vector(Log2(kDevRamSizeInBytes)-1 downto 0);
  signal dTargetMemory : unsigned(Log2(kNumOfMemories)-1 downto 0);
  signal dMemOut: std_logic_vector(kDevRamViAccessSizeInBits-1 downto 0);

  --vhook_sigstart
  signal dHostAddr: std_logic_vector(Log2(kDevRamSizeInBytes*8/(kNiDmaDataWidth*kNumOfMemories))-1 downto 0);
  signal dHostDin: std_logic_vector(kNiDmaDataWidth-1 downto 0);
  signal dHostEn: std_logic;
  signal dLclAddrL: std_logic_vector(Log2(kDevRamSizeInBytes*8/kDevRamViAccessSizeInBits)-1 downto 0);
  signal dLclEn: std_logic;
  --vhook_sigend

  signal dMemoryDecoded : boolean;

  constant kLatency : natural := 2;
  signal dDataValidSR : BooleanVector(1 to kLatency);

  signal dTransferCount : unsigned(31 downto 0);
  signal dReadRegister : boolean;
  signal dRegDataValid : boolean;
  signal dRegOut : std_logic_vector(kDevRamViAccessSizeInBits-1 downto 0);
  signal dHostWe: std_logic_vector(kNiDmaDataWidth/8-1 downto 0);

begin

  dMemoryDecoded <= dHighSpeedSinkFromDma.Address >= kDevRamSinkOffset and
                    dHighSpeedSinkFromDma.Address <= kDevRamSinkOffset + kDevRamSizeInBytes - 1;
  dHostEn <= '1';

  --Decoding Host accesses
  dHostDin      <= dHighSpeedSinkFromDma.Data;
  dHostWe       <= to_StdLogicVector(dHighSpeedSinkFromDma.ByteEnable) when dHighSpeedSinkFromDma.Push and dMemoryDecoded else (others => '0');

  dHssinkAddress <= std_logic_vector(resize(dHighSpeedSinkFromDma.Address, dHssinkAddress'length));
  dHostAddr      <= dHssinkAddress(dHssinkAddress'high downto kMemAddrLsb) &
                    dHssinkAddress(kTargetAddrLsb-1 downto kHssinkAddrLsb);
  dTargetMemory  <= unsigned(dHssinkAddress(kMemAddrLsb-1 downto kTargetAddrLsb));

  --Memory always active
  dLclEn  <= '1';

  DataValid : process(adReset, DmaClock)
  begin -- DataValid
    if adReset then
      dDataValidSR <= (others => false);
    elsif rising_edge(DmaClock) then
      dDataValidSR(1)             <= dLclRd;
      dDataValidSR(2 to kLatency) <= dDataValidSR(1 to kLatency-1);
    end if;
  end process DataValid;

  dLclDataValid <= dDataValidSR(kLatency);

  TransferCount : process(adReset, DmaClock)
  begin -- DataValid
    if adReset then
      dTransferCount <= (others => '0');
      dReadRegister  <= false;
      dRegDataValid  <= false;
    elsif rising_edge(DmaClock) then
      if dCoreReset then
        dTransferCount <= (others => '0');
      elsif dHighSpeedSinkFromDma.Push and dMemoryDecoded then
        dTransferCount <= dTransferCount + CountOnes(dHostWe);
      end if;

      dReadRegister <= false;
      if dLclRd then
        dReadRegister <= to_Boolean(dLclAddr(dLclAddr'high));
        --If more than one register, store address range here.
      end if;

      --If more than one register, use dReadRegiter and stored address to
      -- drive dRegOut here
      dRegDataValid <= dReadRegister;
    end if;
  end process TransferCount;

  --Since there is only one register, no need for reg decoding
  dRegOut <= std_logic_vector(resize(dTransferCount,kDevRamViAccessSizeInBits));

  ------------------------------------------------------------------------------
  -- Memory instantiation
  -- True Dual Port RAM not needed, but this was easy to copy from other code.
  -- Can be optimized later if synthesis results are different
  ------------------------------------------------------------------------------
  dLclAddrL <= dLclAddr(dLclAddrL'range);

  Memories: for i in 0 to kNumOfMemories-1 generate
    signal dHostWeL: std_logic_vector(kNiDmaDataWidth/8-1 downto 0);
    signal dLclDoutL: std_logic_vector(kMemRdDataSize-1 downto 0);
  begin
    dHostWeL  <= dHostWe when kNumOfMemories = 1 or dTargetMemory = i else (others => '0');

    --vhook_i xpm_memory_sdpram
    --vhook_#  === Common Parameters ===
    --vhook_g    MEMORY_SIZE        kDevRamSizeInBytes*8/kNumOfMemories
    --vhook_g    MEMORY_PRIMITIVE   "auto"
    --vhook_g    USE_MEM_INIT       0
    --vhook_g    MESSAGE_CONTROL    0
    --vhook_g    CLOCKING_MODE      "independent_clock"
    --vhook_#  === Host Bus Side (A) Write one memory at a time ===
    --vhook_g    WRITE_DATA_WIDTH_A kNiDmaDataWidth
    --vhook_g    BYTE_WRITE_WIDTH_A 8
    --vhook_g    ADDR_WIDTH_A       Log2(kDevRamSizeInBytes*8/(kNiDmaDataWidth*kNumOfMemories))
    --vhook_#   -- ports --
    --vhook_a    clka                       DmaClock
    --vhook_a    wea                        dHostWeL
    --vhook_a    {^(en|we|addr|din|dout)a$} {dHost_\1} convertcase=_
    --vhook_#  === VI Side (B) REad all memories at once =========
    --vhook_g    *_WIDTH_B          kMemRdDataSize
    --vhook_g    ADDR_WIDTH_B       Log2(kDevRamSizeInBytes*8/kDevRamViAccessSizeInBits)
    --vhook_g    READ_LATENCY_B     kLatency
    --vhook_g    WRITE_MODE_B       "read_first"
    --vhook_#   -- ports --
    --vhook_a    clkb               DmaClock
    --vhook_a    addrb              dLclAddrL
    --vhook_a    doutb              dLclDoutL
    --vhook_a    {^(en|we|addr|din|dout)b$} {dLcl_\1} convertcase=_
    --vhook_#  === Unused / Static =====
    --vhook_gh   *
    --vhook_a    rst?               '0'
    --vhook_a    sleep              '0'
    --vhook_a    inject?biterr*     '0'
    --vhook_a    regce?             '1'
    --vhook_a    ?biterr?           open
    xpm_memory_sdpramx: xpm_memory_sdpram
      generic map (
        MEMORY_SIZE        => kDevRamSizeInBytes*8/kNumOfMemories,                          --integer:=2048
        MEMORY_PRIMITIVE   => "auto",                                                       --string:="auto"
        CLOCKING_MODE      => "independent_clock",                                          --string:="common_clock"
        USE_MEM_INIT       => 0,                                                            --integer:=1
        MESSAGE_CONTROL    => 0,                                                            --integer:=0
        WRITE_DATA_WIDTH_A => kNiDmaDataWidth,                                              --integer:=32
        BYTE_WRITE_WIDTH_A => 8,                                                            --integer:=32
        ADDR_WIDTH_A       => Log2(kDevRamSizeInBytes*8/(kNiDmaDataWidth*kNumOfMemories)),  --integer:=6
        READ_DATA_WIDTH_B  => kMemRdDataSize,                                               --integer:=32
        ADDR_WIDTH_B       => Log2(kDevRamSizeInBytes*8/kDevRamViAccessSizeInBits),         --integer:=6
        READ_LATENCY_B     => kLatency,                                                     --integer:=2
        WRITE_MODE_B       => "read_first")                                                 --string:="no_change"
      port map (
        sleep          => '0',        --in  std_logic
        clka           => DmaClock,   --in  std_logic
        ena            => dHostEn,    --in  std_logic
        wea            => dHostWeL,   --in  std_logic_vector((WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A)-1:0)
        addra          => dHostAddr,  --in  std_logic_vector(ADDR_WIDTH_A-1:0)
        dina           => dHostDin,   --in  std_logic_vector(WRITE_DATA_WIDTH_A-1:0)
        injectsbiterra => '0',        --in  std_logic
        injectdbiterra => '0',        --in  std_logic
        clkb           => DmaClock,   --in  std_logic
        rstb           => '0',        --in  std_logic
        enb            => dLclEn,     --in  std_logic
        regceb         => '1',        --in  std_logic
        addrb          => dLclAddrL,  --in  std_logic_vector(ADDR_WIDTH_B-1:0)
        doutb          => dLclDoutL,  --out std_logic_vector(READ_DATA_WIDTH_B-1:0)
        sbiterrb       => open,       --out std_logic
        dbiterrb       => open);      --out std_logic

    dMemOut((i+1)*kMemRdDataSize-1 downto i*kMemRdDataSize) <= dLclDoutL;
  end generate;

  dLclDout <= dRegOut when dRegDataValid else dMemOut;

end RTL;
