------------------------------------------------------------------------------------------
--
-- File: SasquatchBank0Dram.vhd
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

entity SasquatchBank0Dram is

  port (
    -------------------------------------------------------------------------------------
    -- System Reset and reference Clock
    -------------------------------------------------------------------------------------
    aDramPonResetSl       : in    std_logic;
    Dram0RefClk_p         : in    std_logic;
    Dram0RefClk_n         : in    std_logic;
    -------------------------------------------------------------------------------------
    -- Outgoing Clock
    -------------------------------------------------------------------------------------
    Dram0Clk_p            : out   std_logic;
    Dram0Clk_n            : out   std_logic;
    -------------------------------------------------------------------------------------
    -- Chip Interface
    -------------------------------------------------------------------------------------
    dr0DramCs_n           : out   std_logic;
    dr0DramAct_n          : out   std_logic;
    dr0DramAddr           : out   std_logic_vector (16 downto 0);
    dr0DramBankAddr       : out   std_logic_vector (1 downto 0);
    dr0DramBg             : out   std_logic_vector (0 downto 0);
    dr0DramClkEn          : out   std_logic;
    dr0DramOdt            : out   std_logic;
    dr0DramReset_n        : out   std_logic;
    dr0DramDmDbi_n        : inout std_logic_vector (9 downto 0);
    dr0DramDq             : inout std_logic_vector (79 downto 0);
    dr0DramDqs_p          : inout std_logic_vector (9 downto 0);
    dr0DramDqs_n          : inout std_logic_vector (9 downto 0);
    dr0DramTestMode       : out   std_logic;
    -------------------------------------------------------------------------------------
    -- User Interface
    -------------------------------------------------------------------------------------
    -- Clocks and Resets
    Dram0ClkUserLcl       : out   std_logic;
    adu0Reset             : out   std_logic;
    -- Status
    du0DramPhyInitDone    : out   std_logic;
    -- Address Fifo
    du0DramAddrFifoFull   : out   std_logic;
    du0DramAddrFifoAddr   : in    std_logic_vector (29 downto 0);
    du0DramAddrFifoCmd    : in    std_logic_vector (2 downto 0);
    du0DramAddrFifoWrEn   : in    std_logic;
    -- Write Fifo
    du0DramWrFifoFull     : out   std_logic;
    du0DramWrFifoWrEn     : in    std_logic;
    du0DramWrFifoDataIn   : in    std_logic_vector (639 downto 0);
    du0DramWrFifoMaskData : in    std_logic_vector (79 downto 0);
    -- Read Fifo
    du0DramRdDataValid    : out   std_logic;
    du0DramRdFifoDataOut  : out   std_logic_vector (639 downto 0)
    );

end entity SasquatchBank0Dram;

architecture struct of SasquatchBank0Dram is

begin  -- architecture struct

  --vhook_e SasquatchDramWrapper         Bank0Dram
  --vhook_a {^(a?du|dr)(.*)}            $10$2
  --vhook_a {DramClk}                   Dram0Clk
  --vhook_a {DramRefClk}                Dram0RefClk
  Bank0Dram: entity work.SasquatchDramWrapper (struct)
    port map (
      aDramPonResetSl      => aDramPonResetSl,        --in  std_logic
      DramRefClk_p         => Dram0RefClk_p,          --in  std_logic
      DramRefClk_n         => Dram0RefClk_n,          --in  std_logic
      DramClk_p            => Dram0Clk_p,             --out std_logic
      DramClk_n            => Dram0Clk_n,             --out std_logic
      drDramCs_n           => dr0DramCs_n,            --out std_logic
      drDramAct_n          => dr0DramAct_n,           --out std_logic
      drDramAddr           => dr0DramAddr,            --out std_logic_vector(16:0)
      drDramBankAddr       => dr0DramBankAddr,        --out std_logic_vector(1:0)
      drDramBg             => dr0DramBg,              --out std_logic_vector(0:0)
      drDramClkEn          => dr0DramClkEn,           --out std_logic
      drDramOdt            => dr0DramOdt,             --out std_logic
      drDramReset_n        => dr0DramReset_n,         --out std_logic
      drDramDmDbi_n        => dr0DramDmDbi_n,         --inout std_logic_vector(9:0)
      drDramDq             => dr0DramDq,              --inout std_logic_vector(79:0)
      drDramDqs_p          => dr0DramDqs_p,           --inout std_logic_vector(9:0)
      drDramDqs_n          => dr0DramDqs_n,           --inout std_logic_vector(9:0)
      drDramTestMode       => dr0DramTestMode,        --out std_logic
      DramClkUserLcl       => Dram0ClkUserLcl,        --out std_logic
      aduReset             => adu0Reset,              --out std_logic
      duDramPhyInitDone    => du0DramPhyInitDone,     --out std_logic
      duDramAddrFifoFull   => du0DramAddrFifoFull,    --out std_logic
      duDramAddrFifoAddr   => du0DramAddrFifoAddr,    --in  std_logic_vector(29:0)
      duDramAddrFifoCmd    => du0DramAddrFifoCmd,     --in  std_logic_vector(2:0)
      duDramAddrFifoWrEn   => du0DramAddrFifoWrEn,    --in  std_logic
      duDramWrFifoFull     => du0DramWrFifoFull,      --out std_logic
      duDramWrFifoWrEn     => du0DramWrFifoWrEn,      --in  std_logic
      duDramWrFifoDataIn   => du0DramWrFifoDataIn,    --in  std_logic_vector(639:0)
      duDramWrFifoMaskData => du0DramWrFifoMaskData,  --in  std_logic_vector(79:0)
      duDramRdDataValid    => du0DramRdDataValid,     --out std_logic
      duDramRdFifoDataOut  => du0DramRdFifoDataOut);  --out std_logic_vector(639:0)

end architecture struct;
