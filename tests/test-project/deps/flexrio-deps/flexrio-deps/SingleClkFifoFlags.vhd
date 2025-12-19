-------------------------------------------------------------------------------
--
-- File: SingleClkFifoFlags.vhd
-- Author: Craig Conway, James Nicholson, Paul Butler
-- Original Project: NiCores
-- Date: 11 April 2003
--
-------------------------------------------------------------------------------
-- (c) 2003 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   This file implements FIFO management flags for a DualPortRAM block,
-- creating a configurable-depth FIFO.  While DualPortRAM might support
-- different input and output clock domains, this version of FifoFlags
-- supports only one shared clock domain for queue and dequeue.
--   The FIFO depth is 2**kAddressWidth, so the RAM is completely
-- used, unlike previous FIFO implementations where one element of the
-- RAM would be unusable.
--   This means that there is an extra bit for the address and
-- full/empty count adders and so timing will be slightly harder to
-- meet.
--
-- IMPORTANT NOTE 1:
--   You should use cFullCount to determine when to read the FIFO and
-- cEmptyCount to determine when to write the FIFO.
--   cFullCount and cEmptyCount update quickly after cWrite or cRead
-- assert.  This means that if you have an empty FIFO and perform a write,
-- cFullCount and cEmptyCount may update even though data won't actually
-- actually appear at the outputs until the read latencies are satisfied.
--   This is not a problem as long as you never take data from the FIFO
-- without qualifying it with the cDataValid signal, which can't assert
-- until you assert cRead.  Because you must assert cRead and wait for
-- cDataValid, it won't be possible for you to read data from the FIFO
-- before it's ready.
--
-- IMPORTANT NOTE 2:
-- This component does not contain the memory, but rather has
-- connections to the address and data ports of the external memory. The
-- memory is assumed to be synchronous single cycle read and write, with a
-- latency of kRamReadLatency.
--
-------------------------------------------------------------------------------
--
-- Theory of Operation
--
--   Previous FIFO versions had the depth as 2^AddressWidth-1, instead of
-- 2^AddressWidth, because full use of the memory would require an extra bit
-- in the pointers, increasing the size of the counters and potentially slowing
-- the circuit down.  We have opted to change this policy since the FIFO flags
-- are rarely the critical path in a circuit and it is probably overly wasteful
-- to skip one value on a very shallow FIFO.
--
--   This module maintains the read and write pointers separately from
-- the full and empty counts.  This allows all four values to update within
-- one clock of the assertion of read or write.  Another method of
-- maintaining the full/empty counts would be to perform math on the
-- current state of the read and write pointers.  Since that would add
-- additional latency, this module opts for the former approach.
--
-------------------------------------------------------------------------------
--
-- Ports
--
-- aReset
--   Asynchronous reset to all internal FFs
-- Clk
--   Clock to all internal FFs
-- cReset
--   Synchronous reset.
-- cWrite
--   Strobe to indicate when to write the memory
-- cRead
--   Strobe requesting to read the next element from the FIFO. This may not
--   be asserted at the same time as cReadRewind, nor may it be asserted
--   one clock after cReset or cReadRewind are deasserted.
-- cFullCount
--   Indicates the number of elements available to be read. This updates
--   one Clk cycle after a read.  If kRamReadLatency is 1, it updates
--   two cycles after a write.  If kRamReadLatency is > 1, it updates
--   only one cycle after a write.This should be used to determine when
--   to read the FIFO.
-- cEmptyCount
--   Indicates the number of spaces available to be written. This
--   updates one Clk cycle after a read or a write. This should be used
--   to determine when to write the FIFO.
-- cMemWtAddr
--   The write pointer into the memory.
-- cMemWt
--   Signal to indicate when to write into the data memory.
--   This may remain asserted for back to back writes.
--   Just passes through cWrite.
-- cMemRdAddr
--   The read pointer into the memory. By the time cFullCount is
--   non-zero, cMemRdAddr always points to the location of the first
--   read element. In this manner it is possible to "prefetch" the next
--   read data so as to allow a single-cycle read. If kSynchronousRead
--   is true, then cMemRdAddr will change to the next address
--   combinatorially from cRead, reducing the overall FIFO read
--   latency by one clock.
-- aError
--   This output is only used for simulation to let the fifo testbench know
-- when an overflow is detected.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

entity SingleClkFifoFlags is
  generic (
    kAddressWidth : positive;
    kWidth : positive;
    kRamReadLatency : natural;
    kFifoAdditiveLatency : natural range 0 to 1 := 1;
    kEnableErrorAssertions : boolean := true
  );
  port (
    aReset : in boolean;
    Clk : in std_logic;

    cReset : in boolean;

    -- FIFO Interface
    cWrite,
    cRead,
    cClkEn : in boolean;

    cFullCount,
    cEmptyCount : out unsigned(kAddressWidth downto 0);

    cDataValid : out boolean;

    -- Memory Interface
    cMemWtAddr,
    cMemRdAddr : out unsigned(kAddressWidth-1 downto 0);

    aError : out boolean := false
  );

end SingleClkFifoFlags;

architecture rtl of SingleClkFifoFlags is

  constant kFullWidth : positive := kAddressWidth + 1;
  constant kFifoDepth : unsigned(kAddressWidth downto 0)
                             := To_Unsigned(2**kAddressWidth, kFullWidth);

  constant kResetVal : unsigned(kAddressWidth-1 downto 0) := (others => '0');
  constant kResetValC : unsigned(kAddressWidth downto 0) := (others => '0');

begin

  -----------------------------------------------------------------------------
  -- This block maintains the read and write addresses to the RAM.
  -----------------------------------------------------------------------------
  BlkAddr: block
    signal cNxWAddr, cWAddr, cNxRAddr, cRAddr : unsigned (kAddressWidth-1 downto 0);
  begin

    cNxWAddr <= (others => '0') when cReset else
                cWAddr + 1 when cWrite else
                cWAddr;

    --vhook_e DFlopUnsigned cWAddrx
    --vhook_a cEn cClkEn
    --vhook_a cD cNxWAddr
    --vhook_a cQ cWAddr
    cWAddrx: entity work.DFlopUnsigned (rtl)
      generic map (
        kResetVal => kResetVal)  -- in  unsigned
      port map (
        aReset => aReset,    -- in  boolean
        cEn    => cClkEn,    -- in  boolean
        Clk    => Clk,       -- in  std_logic
        cD     => cNxWAddr,  -- in  unsigned(kResetVal'length-1 downto 0)
        cQ     => cWAddr);   -- out unsigned(kResetVal'length-1 downto 0) := kResetVal

    cNxRAddr <= (others => '0') when cReset else
                cRAddr + 1 when cRead else
                cRAddr;

    --vhook_e DFlopUnsigned cRAddrx
    --vhook_a cEn cClkEn
    --vhook_a cD cNxRAddr
    --vhook_a cQ cRAddr
    cRAddrx: entity work.DFlopUnsigned (rtl)
      generic map (
        kResetVal => kResetVal)  -- in  unsigned
      port map (
        aReset => aReset,    -- in  boolean
        cEn    => cClkEn,    -- in  boolean
        Clk    => Clk,       -- in  std_logic
        cD     => cNxRAddr,  -- in  unsigned(kResetVal'length-1 downto 0)
        cQ     => cRAddr);   -- out unsigned(kResetVal'length-1 downto 0) := kResetVal

    -- Memory Interface
    cMemWtAddr <= cWAddr;
    cMemRdAddr <= cNxRAddr when kFifoAdditiveLatency=0 else cRAddr;

  end block BlkAddr;

  -----------------------------------------------------------------------------
  -- Generate the data valid signal
  -----------------------------------------------------------------------------

  --vhook_e GenDataValid
  GenDataValidx: entity work.GenDataValid (rtl)
    generic map (
      kRamReadLatency      => kRamReadLatency,       -- in  natural
      kFifoAdditiveLatency => kFifoAdditiveLatency)  -- in  natural
    port map (
      aReset     => aReset,      -- in  boolean
      Clk        => Clk,         -- in  std_logic
      cRead      => cRead,       -- in  boolean
      cReset     => cReset,      -- in  boolean
      cClkEn     => cClkEn,      -- in  boolean
      cDataValid => cDataValid); -- out boolean

  -----------------------------------------------------------------------------
  -- This block creates the Full and Empty counts and the Overflow/Underflow
  -- signals.
  -----------------------------------------------------------------------------
  BlkFlags: block
    signal cNxFullCount, cLclFullCount,
           cNxEmptyCount, cLclEmptyCount : unsigned(kAddressWidth downto 0);
    signal cOverflow, cUnderflow, cDoWrite, cDlyRead, cRdForEmpty : boolean := false;

    -- kRamWriteLatency is the number of cycles from the write port to the internal data array.
            -- The inferred memory can be configured as WRITE_FIRST so we need to take into account
            -- the collision possibility of read and write addresses - in which case the read needs
    -- to be delayed by updating the FullCount later.
    -- This is described in Xilinx UG473 (v1.10.1) May 9, 2014
    -- http://www.xilinx.com/support/documentation/user_guides/ug473_7Series_Memory_Resources.pdf
    -- Page 16 Write Modes
    --   esp pp 18-19 : Conflict Avoidance, Synchronous Clocking
    -- Page 31 Block RAM Attributes
    --   esp p 34 : Write Mode - WRITE_MODE_[A|B]
    constant kRamWriteLatency : natural := 2;
            
    -- The array is defined as a shift register which should delay the change of the FullCount flag
    -- by the necessary number of registers such that we don't get a collision problem. 
    -- For readability purposes the ranging was set for using "to" instead of "downto"
    signal cWriteArray : BooleanVector(1 to kRamWriteLatency);
  begin

    WriteArrayShiftRegister: process ( aReset, Clk ) is
    begin
      if aReset then
        cWriteArray <= (others => false);
      elsif rising_edge ( Clk ) then
        cWriteArray <= cWrite & cWriteArray ( 1 to kRamWriteLatency - 1 );
      end if;
    end process WriteArrayShiftRegister;

    -- Since the array is ranged using "to" we need to take the last element of it (which is situated
    -- to the right).
    cDoWrite <= cWriteArray(kRamWriteLatency);
    cNxFullCount <= (others => '0') when cReset else
                    cLclFullCount + 1 when cDoWrite and not cRead else
                    cLclFullCount - 1 when cRead and not cDoWrite else
                    cLclFullCount;

    --vhook_e DFlopUnsigned cFullCountx
    --vhook_a kResetVal kResetValC
    --vhook_a cEn cClkEn
    --vhook_a cD cNxFullCount
    --vhook_a cQ cLclFullCount
    cFullCountx: entity work.DFlopUnsigned (rtl)
      generic map (
        kResetVal => kResetValC)  -- in  unsigned
      port map (
        aReset => aReset,         -- in  boolean
        cEn    => cClkEn,         -- in  boolean
        Clk    => Clk,            -- in  std_logic
        cD     => cNxFullCount,   -- in  unsigned(kResetVal'length-1 downto 0)
        cQ     => cLclFullCount); -- out unsigned(kResetVal'length-1 downto 0) := kResetV
    
    process (aReset, Clk)
    begin
      if aReset then
        cDlyRead <= false;
      elsif rising_edge(Clk) then
        cDlyRead <= cRead;
      end if;
    end process;

    cRdForEmpty <= cRead when kFifoAdditiveLatency=0 else cDlyRead;

    cNxEmptyCount <= kFifoDepth when cReset else
                     cLclEmptyCount - 1 when cWrite and not cRdForEmpty else
                     cLclEmptyCount + 1 when cRdForEmpty and not cWrite else
                     cLclEmptyCount;

    --vhook_e DFlopUnsigned cEmptyCountx
    --vhook_a kResetVal kFifoDepth
    --vhook_a cEn cClkEn
    --vhook_a cD cNxEmptyCount
    --vhook_a cQ cLclEmptyCount
    cEmptyCountx: entity work.DFlopUnsigned (rtl)
      generic map (
        kResetVal => kFifoDepth)  -- in  unsigned
      port map (
        aReset => aReset,          -- in  boolean
        cEn    => cClkEn,          -- in  boolean
        Clk    => Clk,             -- in  std_logic
        cD     => cNxEmptyCount,   -- in  unsigned(kResetVal'length-1 downto 0)
        cQ     => cLclEmptyCount); -- out unsigned(kResetVal'length-1 downto 0) := kReset

    cFullCount <= cLclFullCount;
    cEmptyCount <= cLclEmptyCount;

    --synthesis translate_off
    process (aReset, Clk)
    begin
      if aReset then
        cOverflow <= false;
        cUnderflow <= false;
      elsif rising_edge(Clk) then
        cOverflow <= cWrite and cClkEn and cLclEmptyCount=0;
        cUnderflow <= cRead and cClkEn and cLclFullCount=0;
      end if;
    end process;

    assert not cUnderflow report "Underflow error" severity error;
    assert not cOverflow report "Overflow error" severity error;
    aError <= cUnderflow or cOverflow;
    --synthesis translate_on

  end block BlkFlags;

end rtl;
