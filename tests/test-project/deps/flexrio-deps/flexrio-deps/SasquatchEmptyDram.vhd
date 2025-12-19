------------------------------------------------------------------------------------------
--
-- File: SasquatchEmptyDram.vhd
-- Author: Rolando Ortega
-- Original Project: Macallan PXIe FlexRIO Carrier
-- Date: 15 October 2015
--
------------------------------------------------------------------------------------------
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
------------------------------------------------------------------------------------------
--
-- Purpose: This file is instantiated if a bank of DRAM is not used. This ties the
-- signals connected to the DRAM to constants to keep the DRAM in reset, as well as
-- instantiate a buffer on the DRAM clock to keep the termination on the line. It also
-- ties signals to LVFPGA to constants.
--
-- There are two sets of signals in here:
--
-- - The dr* signals can be considered synchronous to the (outgoing) DramClk, though DRAM
--   timing is of course more complicated than that. But ultimately they are all
--   connected to the physical DRAM chips on the board.
--
-- - The du* signals are internal to the chip, are synchronous to DramClkUser, and are
--   connected to the LVFPGA Window. Minor adaptations are done in this module to match
--   the interface that LV expects.
------------------------------------------------------------------------------------------
--
-- githubvisible=true
--
-- vreview_group SasquatchDram
-- vreview_closed http://review-board.natinst.com/r/313047/
-- vreview_reviewers kygreen dhearn esalinas hrubio lboughal rcastro
--
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

entity SasquatchEmptyDram is

  port (
    -------------------------------------------------------------------------------------
    -- System Reset and reference Clock
    -------------------------------------------------------------------------------------
    aDramPonReset        : in    boolean;
    DramRefClk_p         : in    std_logic;
    DramRefClk_n         : in    std_logic;
    -------------------------------------------------------------------------------------
    -- Outgoing Clock
    -------------------------------------------------------------------------------------
    DramClk_p            : out   std_logic;
    DramClk_n            : out   std_logic;
    -------------------------------------------------------------------------------------
    -- Chip Interface
    -------------------------------------------------------------------------------------
    drDramCs_n           : out   std_logic;
    drDramAct_n          : out   std_logic;
    drDramAddr           : out   std_logic_vector (16 downto 0);
    drDramBankAddr       : out   std_logic_vector (1 downto 0);
    drDramBg             : out   std_logic_vector (0 downto 0);
    drDramClkEn          : out   std_logic;
    drDramOdt            : out   std_logic;
    drDramReset_n        : out   std_logic;
    drDramDmDbi_n        : inout std_logic_vector (9 downto 0);
    drDramDq             : inout std_logic_vector (79 downto 0);
    drDramDqs_p          : inout std_logic_vector (9 downto 0);
    drDramDqs_n          : inout std_logic_vector (9 downto 0);
    drDramTestMode       : out   std_logic;
    -------------------------------------------------------------------------------------
    -- User Interface
    -------------------------------------------------------------------------------------
    -- Clocks and Resets
    DramClkUserLcl       : out   std_logic;
    aduReset             : out   std_logic;
    -- Status
    duDramPhyInitDone    : out   std_logic;
    -- Address Fifo
    duDramAddrFifoFull   : out   std_logic;
    duDramAddrFifoAddr   : in    std_logic_vector (29 downto 0);
    duDramAddrFifoCmd    : in    std_logic_vector (2 downto 0);
    duDramAddrFifoWrEn   : in    std_logic;
    -- Write Fifo
    duDramWrFifoFull     : out   std_logic;
    duDramWrFifoWrEn     : in    std_logic;
    duDramWrFifoDataIn   : in    std_logic_vector (639 downto 0);
    duDramWrFifoMaskData : in    std_logic_vector (79 downto 0);
    -- Read Fifo
    duDramRdDataValid    : out   std_logic;
    duDramRdFifoDataOut  : out   std_logic_vector (639 downto 0)
    );

end entity SasquatchEmptyDram;

architecture struct of SasquatchEmptyDram is

  --vhook_sigstart
  --vhook_sigend

begin  -- architecture struct

  -------------------------------------------------------------------------------------
  -- LVFPGA Interface
  -------------------------------------------------------------------------------------
  DramClkUserLcl      <= '0';
  -- Tell everyone that the PHY is done init'ing, in case something else is waiting on
  -- this.
  duDramPhyInitDone   <= '1';
  -- There should be no DRAM logic inside the window if the DRAM isn't getting
  -- instantiated, but we'll still choose values that communicate "I'm busy" rather
  -- than "I'm ready" whenever possible.
  duDramAddrFifoFull  <= '1';
  duDramWrFifoFull    <= '1';
  duDramRdDataValid   <= '0';
  duDramRdFifoDataOut <= (others => '0');
  aduReset            <= '1';

  -- We leave all other inputs floating
  --vhook_nowarn du*
  --vhook_nowarn aDramPonReset

  -------------------------------------------------------------------------------------
  -- Single-Ended DRAM I/O
  -------------------------------------------------------------------------------------
  -- Keep the part in reset, out of Chip-Select, and without ClkEn
  drDramReset_n  <= '0';
  drDramCs_n     <= '1';
  drDramClkEn    <= '0';
  -- Other settings don't really matter given the above, so set them to 0. It's better
  -- power-wise to drive floating inouts to 0 than to have input buffers with floating
  -- inputs (which is what happens if we do nothing).
  drDramAct_n    <= '0';
  drDramAddr     <= (others => '0');
  drDramBankAddr <= (others => '0');
  drDramBg       <= (others => '0');
  drDramOdt      <= '0';
  drDramDmDbi_n  <= (others => '0');
  drDramDq       <= (others => '0');

  -- Regardless of whether we generate the memory controller or not, the Test Enable (TEN)
  -- pin on the DRAM needs to be tied to '0' so it doesn't go into test mode. We'll set it
  -- to 1 only during boundary scan testing.
  drDramTestMode <= '0';

  -- We leave all non-diff inputs floating
  --vhook_nowarn dr*

  -------------------------------------------------------------------------------------
  -- Diff I/O
  -------------------------------------------------------------------------------------
  -- Vivado will complain if we drive differential IO Standard pins as single-ended. It
  -- also complains if our differential clock input isn't tied to a differential IOB.

  -- Input RefClk

  --vhook_i IBUFDS            DramRefClkIBuf hidegeneric=open
  --vhook_a I                 DramRefClk_p
  --vhook_a IB                DramRefClk_n
  --vhook_a O                 open
  --vhook_g IBUF_LOW_PWR      true
  --vhook_g *                 open
  DramRefClkIBuf: IBUFDS
    generic map (IBUF_LOW_PWR => true)  --boolean:=TRUE
    port map (
      O  => open,          --out std_ulogic
      I  => DramRefClk_p,  --in  std_ulogic
      IB => DramRefClk_n); --in  std_ulogic


  -- Will drive the clock to a solid '0', because that should be better than having a
  -- floating clock.

  --vhook_i OBUFDS            DramClkOBuf hidegeneric=true
  --vhook_a I                 '0'
  --vhook_a O                 DramClk_p
  --vhook_a OB                DramClk_n
  DramClkOBuf: OBUFDS
    port map (
      O  => DramClk_p,  --out std_ulogic
      OB => DramClk_n,  --out std_ulogic
      I  => '0');       --in  std_ulogic

  DqsObufs : for i in drDramDqs_p'range generate
    -- Although DQS's are technically clocks, given that they are bi-directional we're
    -- going to leave them floated to be extra safe.

    --vhook_i OBUFTDS         DqsObuf hidegeneric=true
    --vhook_a I               '0'
    --vhook_a O               drDramDqs_p(i)
    --vhook_a OB              drDramDqs_n(i)
    --vhook_a T               '1'
    DqsObuf: OBUFTDS
      port map (
        O  => drDramDqs_p(i),  --out std_ulogic
        OB => drDramDqs_n(i),  --out std_ulogic
        I  => '0',             --in  std_ulogic
        T  => '1');            --in  std_ulogic

  end generate DqsObufs;

end architecture struct;
