-------------------------------------------------------------------------------
--
-- File: SingleClkFifo.vhd
-- Author: Paul Butler, Craig Conway
-- Original Project: NiCores
-- Date: 8 October 2008
--
-------------------------------------------------------------------------------
-- (c) 2008 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
-- SingleClkFifo creates a one clock-domain FIFO using
-- FifoFlagsSingleClk and DualPortRAM.  The main difference between this
-- FIFO and others at NI is that this one provides access to all the
-- storage rather than the usual 2^N - 1.
--
-- How to Use This Component
-- -------------------------
--
-- A much more thorough description can be found in SingleClkFifoFlags.vhd.
-- See below for a very basic description of usage:
--
-- Writing
--
-- To queue data in the FIFO, place the data in cWriteData and strobe cWrite.
-- cWrite can assert at the same time as cWriteData updates.  There is no need
-- to maintain the value of cWriteData after cWrite deasserts.
--
-- Do not queue data if cEmptyCount equals zero, as this will cause a FIFO
-- overflow.
--
-- Reading
--
-- cReadData always represents the data at the head of the queue.  To dequeue
-- this data to access the next value, strobe cRead and only capture the
-- data when cDataValid is asserted.
--
-- Do not dequeue data if cFullCount equals zero, as this will cause a FIFO
-- underflow.  When cFullCount equals zero the value of cReadData is invalid;
-- cReadData will update automatically if new data is written into an empty
-- FIFO.
--
-------------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity SingleClkFifo is
  generic (
    kAddressWidth : positive;
    kWidth : positive;
    kRamReadLatency : natural;
    kFifoAdditiveLatency : natural := 1
  );
  port (
    aReset : in boolean;
    Clk : in std_logic;

    cReset : in boolean := false;
    cClkEn : in boolean := true;

    -- FIFO Interface
    cWrite : in boolean;
    cDataIn : in std_logic_vector ( kWidth - 1 downto 0 );

    cRead : in boolean;
    cDataOut : out std_logic_vector ( kWidth - 1 downto 0 );

    cFullCount,
    cEmptyCount : out unsigned(kAddressWidth downto 0);

    cDataValid : out boolean

  );
end entity SingleClkFifo;

architecture rtl of SingleClkFifo is

  --vhook_sigstart
  signal cMemRdAddr: unsigned(kAddressWidth-1 downto 0);
  signal cMemWtAddr: unsigned(kAddressWidth-1 downto 0);
  --vhook_sigend
begin

  --vhook_e SingleClkFifoFlags
  --vhook_a kEnableErrorAssertions true
  --vhook_a aError open
  SingleClkFifoFlagsx: entity work.SingleClkFifoFlags (rtl)
    generic map (
      kAddressWidth          => kAddressWidth,         -- in  positive
      kWidth                 => kWidth,                -- in  positive
      kRamReadLatency        => kRamReadLatency,       -- in  natural
      kFifoAdditiveLatency   => kFifoAdditiveLatency,  -- in  natural range 0 to 1 := 1
      kEnableErrorAssertions => true)                  -- in  boolean := true
    port map (
      aReset      => aReset,       -- in  boolean
      Clk         => Clk,          -- in  std_logic
      cReset      => cReset,       -- in  boolean
      cWrite      => cWrite,       -- in  boolean
      cRead       => cRead,        -- in  boolean
      cClkEn      => cClkEn,       -- in  boolean
      cFullCount  => cFullCount,   -- out unsigned(kAddressWidth downto 0)
      cEmptyCount => cEmptyCount,  -- out unsigned(kAddressWidth downto 0)
      cDataValid  => cDataValid,   -- out boolean
      cMemWtAddr  => cMemWtAddr,   -- out unsigned(kAddressWidth-1 downto 0)
      cMemRdAddr  => cMemRdAddr,   -- out unsigned(kAddressWidth-1 downto 0)
      aError      => open);        -- out boolean := false

  --vhook_e DualPortRAM
  --vhook_a {^[IO]Clk} Clk
  --vhook_a {^[io]ClkEn$} cClkEn
  --vhook_a {^[io](.*)} c$1
  --vhook_a iAddr cMemWtAddr
  --vhook_a oAddr cMemRdAddr
  DualPortRAMx: entity work.DualPortRAM (rtl)
    generic map (
      kAddressWidth   => kAddressWidth,    -- in  integer := 8
      kWidth          => kWidth,           -- in  integer := 32
      kRamReadLatency => kRamReadLatency)  -- in  integer := 2
    port map (
      IClk     => Clk,         -- in  std_logic
      iClkEn   => cClkEn,      -- in  boolean := true
      iWrite   => cWrite,      -- in  boolean
      iAddr    => cMemWtAddr,  -- in  unsigned(kAddressWidth-1 downto 0)
      iDataIn  => cDataIn,     -- in  std_logic_vector(kWidth-1 downto 0)
      OClk     => Clk,         -- in  std_logic
      oClkEn   => cClkEn,      -- in  boolean := true
      oReset   => cReset,      -- in  boolean := false
      oAddr    => cMemRdAddr,  -- in  unsigned(kAddressWidth-1 downto 0)
      oDataOut => cDataOut);   -- out std_logic_vector(kWidth-1 downto 0)

end rtl;
