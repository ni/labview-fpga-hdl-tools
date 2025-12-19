-----------------------------------------------------------------------------
--
-- File: LinkStorageRamXilinx.vhd
-- Author: Rolando Ortega
-- Original Project: NI Cores NiDmaIp
-- Date: 10 May 2019
--
-------------------------------------------------------------------------------
-- (c) 2019 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
-- See PkgLinkStorageRam for details on the logic behind separating LinkStorageRam* from
-- the NiDmaIp generally. This is a Xilinx-specific implementation of that general idea.
--
-- This module instantiates an Asymmetric Xilinx BlockRAM to store the chunky links used
-- by the NiDmaLinkProcessor to support Full Hardware Link Chaining Mode DMA. This version
-- of the LinkStorage Ram is, as the name implies, Xilinx-specific, in that it makes use
-- of special Xilinx primitives. Furthermore, it can only be used by Vivado 2016.2+,
-- because it uses the xpm library to implement the memory.
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgNiUtilities.all;
use work.PkgNiDma.all;
use work.PkgLinkStorageRam.all;
use work.PkgLinkStorageRamConfig.all;

library xpm;
use xpm.vcomponents.all;

entity LinkStorageRamXilinx is
  generic (
    kEnabledChannels : in NiDmaDmaChannelOneHot_t);
  port (
    DmaClock : in std_logic;
    -- Write
    dLinkStorageRamWrite     : in boolean;
    dLinkStorageRamWriteAddr : in unsigned(kLinkStorageRamAddrWidth-1 downto 0);
    dLinkStorageRamWriteData : in std_logic_vector(kLinkStorageRamDataWidth-1 downto 0);
    -- Read
    dLinkStorageRamReadAddr : in  unsigned(kLinkStorageRamRdAddrWidth-1 downto 0);
    dLinkStorageRamReadData : out std_logic_vector(kLinkStorageRamRdDataWidth-1 downto 0)
  );

end entity LinkStorageRamXilinx;

architecture struct of LinkStorageRamXilinx is

  ------------------------------------------------------------------------------
  -- Address Mapping
  ------------------------------------------------------------------------------

  -- The ChunkyLinkSize is given in bytes per DMA channel, so we multiply by 8 (to get it
  -- to bits), then by the number of (enabled) channels, and then finally by 2, because we
  -- double-buffer the Chunky Links. This gives us the memory size.
  constant kMemorySizeInBits : natural :=
    kChunkyLinkSize * 8 * NumEnabledChannels(kEnabledChannels) * 2;

  -- The memory's addresses are simply derived from the memory size. We divide by the data
  -- width to achieve the depth as seen from each side. We use Larger because it's
  -- possible that kMemorySizeInBits is 0, and Log2 isn't defined for 0. There's a special
  -- "generate" case below for the case where there are 0 channels enabled anyway.
  constant kMemoryWtAddrWidth : natural := Log2(Larger(kMemorySizeInBits / kLinkStorageRamDataWidth,1));
  constant kMemoryRdAddrWidth : natural := Log2(Larger(kMemorySizeInBits / kLinkStorageRamRdDataWidth,1));

  ------------------------------------------------------------------------------
  -- BRAM Configuration
  ------------------------------------------------------------------------------
  -- The byte width for the write can be set to 8, 9 bits or to the data width. We use the
  -- data width since we don't need byte enables. See definition of BYTE_WRITE_WIDTH_A
  -- under XPM_MEMORY_SDPRAM in UG974 for more info.
  constant kLinkStorageRamByteWriteWidth : natural := kLinkStorageRamDataWidth;

  -- As a result, the write enables are a vector with a width that is the number of
  -- enables (DataWidth/ByteWriteWidth), which in our case is a one-wide vector. We will
  -- control all write enables with the same write signal, which we'll tie to 1. We'll use
  -- 'ena' as write enable because it leads to less power consumption, as per UG974.
  constant kLinkStorageRamWriteEn : std_logic_vector(kLinkStorageRamDataWidth/kLinkStorageRamByteWriteWidth-1 downto 0) := (others => '1');

  --vhook_sigstart
  signal dNewRamRdAddr: unsigned(kMemoryRdAddrWidth-1 downto 0);
  signal dNewRamWtAddr: unsigned(kMemoryWtAddrWidth-1 downto 0);
  --vhook_sigend

begin

  InstMemory : if NumEnabledChannels(kEnabledChannels) > 0 generate

    ------------------------------------------------------------------------------
    -- Address Mapping
    ------------------------------------------------------------------------------
    --vhook_e LinkStorageRamAddrMapper
    LinkStorageRamAddrMapperx: entity work.LinkStorageRamAddrMapper (rtl)
      generic map (
        kEnabledChannels   => kEnabledChannels,    --NiDmaDmaChannelOneHot_t
        kMemoryWtAddrWidth => kMemoryWtAddrWidth,  --natural
        kMemoryRdAddrWidth => kMemoryRdAddrWidth)  --natural
      port map (
        dLinkStorageRamWriteAddr => dLinkStorageRamWriteAddr,  --in  unsigned(kLinkStorageRamAddrWidth-1:0)
        dLinkStorageRamReadAddr  => dLinkStorageRamReadAddr,   --in  unsigned(kLinkStorageRamRdAddrWidth-1:0)
        dNewRamWtAddr            => dNewRamWtAddr,             --out unsigned(kMemoryWtAddrWidth-1:0)
        dNewRamRdAddr            => dNewRamRdAddr);            --out unsigned(kMemoryRdAddrWidth-1:0)

    ------------------------------------------------------------------------------
    -- Memory instantiation
    ------------------------------------------------------------------------------
    --vhook_i  xpm_memory_sdpram LinkStorageBramx
    --vhook_#  Parameters
    --vhook_#  ------------------------------------------------------
    --vhook_#  Memory_size is the overall size of the memory in bits.
    --vhook_g  MEMORY_SIZE        kMemorySizeInBits
    --vhook_g  WRITE_DATA_WIDTH_A kLinkStorageRamDataWidth
    --vhook_g  ADDR_WIDTH_A       kMemoryWtAddrWidth
    --vhook_g  READ_DATA_WIDTH_B  kLinkStorageRamRdDataWidth
    --vhook_g  ADDR_WIDTH_B       kMemoryRdAddrWidth
    --vhook_g  BYTE_WRITE_WIDTH_A kLinkStorageRamByteWriteWidth
    --vhook_g  READ_LATENCY_B     kLinkStorageRamReadLatency
    --vhook_g  MEMORY_PRIMITIVE   "auto"
    --vhook_g  WRITE_MODE_B       "read_first"
    --vhook_#  Set this to 0 because the test reports are a nuisance.
    --vhook_g  MESSAGE_CONTROL    0
    --vhook_#  Set this to 0 because we realize we're not initializing the memory.
    --vhook_g  USE_MEM_INIT       0
    --vhook_#  Everything else can keep defaults.
    --vhook_gh *
    --vhook_#  Signals
    --vhook_#  ----------------------------------------------
    --vhook_a  clk*               DmaClock
    --vhook_#  We don't use the reset because it needs to be synchronous.
    --vhook_a  rstb               '0'
    --vhook_#  Write
    --vhook_a  ena                to_StdLogic(dLinkStorageRamWrite)
    --vhook_a  addra              std_logic_vector(dNewRamWtAddr)
    --vhook_a  dina               dLinkStorageRamWriteData
    --vhook_a  wea                kLinkStorageRamWriteEn
    --vhook_#  Read
    --vhook_a  addrb              std_logic_vector(dNewRamRdAddr)
    --vhook_a  doutb              dLinkStorageRamReadData
    --vhook_#  Unused / Static
    --vhook_a  enb                '1'
    --vhook_a  sleep              '0'
    --vhook_a  inject?biterr*     '0'
    --vhook_a  regceb             '1'
    --vhook_a  ?biterr?           open
    LinkStorageBramx: xpm_memory_sdpram
      generic map (
        MEMORY_SIZE        => kMemorySizeInBits,              --integer:=2048
        MEMORY_PRIMITIVE   => "auto",                         --string:="auto"
        USE_MEM_INIT       => 0,                              --integer:=1
        MESSAGE_CONTROL    => 0,                              --integer:=0
        WRITE_DATA_WIDTH_A => kLinkStorageRamDataWidth,       --integer:=32
        BYTE_WRITE_WIDTH_A => kLinkStorageRamByteWriteWidth,  --integer:=32
        ADDR_WIDTH_A       => kMemoryWtAddrWidth,             --integer:=6
        READ_DATA_WIDTH_B  => kLinkStorageRamRdDataWidth,     --integer:=32
        ADDR_WIDTH_B       => kMemoryRdAddrWidth,             --integer:=6
        READ_LATENCY_B     => kLinkStorageRamReadLatency,     --integer:=2
        WRITE_MODE_B       => "read_first")                   --string:="no_change"
      port map (
        sleep          => '0',                                --in  std_logic
        clka           => DmaClock,                           --in  std_logic
        ena            => to_StdLogic(dLinkStorageRamWrite),  --in  std_logic
        wea            => kLinkStorageRamWriteEn,             --in  std_logic_vector((WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A)-1:0)
        addra          => std_logic_vector(dNewRamWtAddr),    --in  std_logic_vector(ADDR_WIDTH_A-1:0)
        dina           => dLinkStorageRamWriteData,           --in  std_logic_vector(WRITE_DATA_WIDTH_A-1:0)
        injectsbiterra => '0',                                --in  std_logic
        injectdbiterra => '0',                                --in  std_logic
        clkb           => DmaClock,                           --in  std_logic
        rstb           => '0',                                --in  std_logic
        enb            => '1',                                --in  std_logic
        regceb         => '1',                                --in  std_logic
        addrb          => std_logic_vector(dNewRamRdAddr),    --in  std_logic_vector(ADDR_WIDTH_B-1:0)
        doutb          => dLinkStorageRamReadData,            --out std_logic_vector(READ_DATA_WIDTH_B-1:0)
        sbiterrb       => open,                               --out std_logic
        dbiterrb       => open);                              --out std_logic

  end generate InstMemory;

  NoMemory : if NumEnabledChannels(kEnabledChannels) = 0 generate

    -- If there are no enabled channels, we don't need a memory at all. Read data is just
    -- 0s.
    dLinkStorageRamReadData <= (others => '0');

  end generate NoMemory;

end architecture struct;
