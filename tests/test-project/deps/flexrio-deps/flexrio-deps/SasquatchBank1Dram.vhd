------------------------------------------------------------------------------------------
--
-- File: SasquatchBank1Dram.vhd
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
-- Purpose: This is a wrapper to prettify the signals coming from the UltrascaleDdr4
-- block.
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
--
-- Note: The main difference between SasquatchBank0Dram and SasquatchBank1Dram is the signal
-- names. In the future these could be combined into a single file, or just directly
-- instantiate the wrapper in SasquatchDram.
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

entity SasquatchBank1Dram is

  port (
    -------------------------------------------------------------------------------------
    -- System Reset and reference Clock
    -------------------------------------------------------------------------------------
    aDramPonResetSl       : in    std_logic;
    Dram1RefClk_p         : in    std_logic;
    Dram1RefClk_n         : in    std_logic;
    -------------------------------------------------------------------------------------
    -- Outgoing Clock
    -------------------------------------------------------------------------------------
    Dram1Clk_p            : out   std_logic;
    Dram1Clk_n            : out   std_logic;
    -------------------------------------------------------------------------------------
    -- Chip Interface
    -------------------------------------------------------------------------------------
    dr1DramCs_n           : out   std_logic;
    dr1DramAct_n          : out   std_logic;
    dr1DramAddr           : out   std_logic_vector (16 downto 0);
    dr1DramBankAddr       : out   std_logic_vector (1 downto 0);
    dr1DramBg             : out   std_logic_vector (0 downto 0);
    dr1DramClkEn          : out   std_logic;
    dr1DramOdt            : out   std_logic;
    dr1DramReset_n        : out   std_logic;
    dr1DramDmDbi_n        : inout std_logic_vector (9 downto 0);
    dr1DramDq             : inout std_logic_vector (79 downto 0);
    dr1DramDqs_p          : inout std_logic_vector (9 downto 0);
    dr1DramDqs_n          : inout std_logic_vector (9 downto 0);
    dr1DramTestMode       : out   std_logic;
    -------------------------------------------------------------------------------------
    -- User Interface
    -------------------------------------------------------------------------------------
    -- Clocks and Resets
    Dram1ClkUserLcl       : out   std_logic;
    adu1Reset             : out   std_logic;
    -- Status
    du1DramPhyInitDone    : out   std_logic;
    -- Address Fifo
    du1DramAddrFifoFull   : out   std_logic;
    du1DramAddrFifoAddr   : in    std_logic_vector (29 downto 0);
    du1DramAddrFifoCmd    : in    std_logic_vector (2 downto 0);
    du1DramAddrFifoWrEn   : in    std_logic;
    -- Write Fifo
    du1DramWrFifoFull     : out   std_logic;
    du1DramWrFifoWrEn     : in    std_logic;
    du1DramWrFifoDataIn   : in    std_logic_vector (639 downto 0);
    du1DramWrFifoMaskData : in    std_logic_vector (79 downto 0);
    -- Read Fifo
    du1DramRdDataValid    : out   std_logic;
    du1DramRdFifoDataOut  : out   std_logic_vector (639 downto 0)
    );

end entity SasquatchBank1Dram;

architecture struct of SasquatchBank1Dram is

  --vhook_sigstart
  --vhook_sigend

begin  -- architecture struct

  --vhook_e SasquatchDramWrapper         Bank1Dram
  --vhook_a {^(a?du|dr)(.*)}            $11$2
  --vhook_a {DramClk}                   Dram1Clk
  --vhook_a {DramRefClk}                Dram1RefClk
  Bank1Dram: entity work.SasquatchDramWrapper (struct)
    port map (
      aDramPonResetSl      => aDramPonResetSl,        --in  std_logic
      DramRefClk_p         => Dram1RefClk_p,          --in  std_logic
      DramRefClk_n         => Dram1RefClk_n,          --in  std_logic
      DramClk_p            => Dram1Clk_p,             --out std_logic
      DramClk_n            => Dram1Clk_n,             --out std_logic
      drDramCs_n           => dr1DramCs_n,            --out std_logic
      drDramAct_n          => dr1DramAct_n,           --out std_logic
      drDramAddr           => dr1DramAddr,            --out std_logic_vector(16:0)
      drDramBankAddr       => dr1DramBankAddr,        --out std_logic_vector(1:0)
      drDramBg             => dr1DramBg,              --out std_logic_vector(0:0)
      drDramClkEn          => dr1DramClkEn,           --out std_logic
      drDramOdt            => dr1DramOdt,             --out std_logic
      drDramReset_n        => dr1DramReset_n,         --out std_logic
      drDramDmDbi_n        => dr1DramDmDbi_n,         --inout std_logic_vector(9:0)
      drDramDq             => dr1DramDq,              --inout std_logic_vector(79:0)
      drDramDqs_p          => dr1DramDqs_p,           --inout std_logic_vector(9:0)
      drDramDqs_n          => dr1DramDqs_n,           --inout std_logic_vector(9:0)
      drDramTestMode       => dr1DramTestMode,        --out std_logic
      DramClkUserLcl       => Dram1ClkUserLcl,        --out std_logic
      aduReset             => adu1Reset,              --out std_logic
      duDramPhyInitDone    => du1DramPhyInitDone,     --out std_logic
      duDramAddrFifoFull   => du1DramAddrFifoFull,    --out std_logic
      duDramAddrFifoAddr   => du1DramAddrFifoAddr,    --in  std_logic_vector(29:0)
      duDramAddrFifoCmd    => du1DramAddrFifoCmd,     --in  std_logic_vector(2:0)
      duDramAddrFifoWrEn   => du1DramAddrFifoWrEn,    --in  std_logic
      duDramWrFifoFull     => du1DramWrFifoFull,      --out std_logic
      duDramWrFifoWrEn     => du1DramWrFifoWrEn,      --in  std_logic
      duDramWrFifoDataIn   => du1DramWrFifoDataIn,    --in  std_logic_vector(639:0)
      duDramWrFifoMaskData => du1DramWrFifoMaskData,  --in  std_logic_vector(79:0)
      duDramRdDataValid    => du1DramRdDataValid,     --out std_logic
      duDramRdFifoDataOut  => du1DramRdFifoDataOut);  --out std_logic_vector(639:0)

end architecture struct;
