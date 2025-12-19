------------------------------------------------------------------------------------------
--
-- File: SasquatchDram.vhd
-- Author: Rolando Ortega
-- Original Project: Macallan
-- Date: 12 February 2016
--
------------------------------------------------------------------------------------------
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
------------------------------------------------------------------------------------------
--
-- Purpose: This struct simply puts the two DRAM Banks under a single file, and manages
-- the signals going to each of them.
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

library work;
use work.PkgNiUtilities.all;
use work.PkgLvFpgaConst.all;

entity SasquatchDram is

  port (
    -------------------------------------------------------------------------------------
    -- Common pins
    -------------------------------------------------------------------------------------
    aDramPonReset         : in    boolean;
    -------------------------------------------------------------------------------------
    -- Reference Clocks
    -------------------------------------------------------------------------------------
    Dram0RefClk_p         : in    std_logic;
    Dram0RefClk_n         : in    std_logic;
    Dram1RefClk_p         : in    std_logic;
    Dram1RefClk_n         : in    std_logic;
    -------------------------------------------------------------------------------------
    -- Shared Diagram Clock
    -------------------------------------------------------------------------------------
    DramClkLvFpga         : out   std_logic;
    -------------------------------------------------------------------------------------
    -- Bank 0 Chip Interface
    -------------------------------------------------------------------------------------
    Dram0Clk_p            : out   std_logic;
    Dram0Clk_n            : out   std_logic;
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
    -- Bank 0 LV Interface
    -------------------------------------------------------------------------------------
    Dram0ClkUser          : out   std_logic;
    du0DramPhyInitDone    : out   std_logic;
    du0DramAddrFifoFull   : out   std_logic;
    du0DramAddrFifoAddr   : in    std_logic_vector (29 downto 0);
    du0DramAddrFifoCmd    : in    std_logic_vector (2 downto 0);
    du0DramAddrFifoWrEn   : in    std_logic;
    du0DramWrFifoFull     : out   std_logic;
    du0DramWrFifoWrEn     : in    std_logic;
    du0DramWrFifoDataIn   : in    std_logic_vector (639 downto 0);
    du0DramWrFifoMaskData : in    std_logic_vector (79 downto 0);
    du0DramRdDataValid    : out   std_logic;
    du0DramRdFifoDataOut  : out   std_logic_vector (639 downto 0);
    -------------------------------------------------------------------------------------
    -- Bank 1 Chip Interface
    -------------------------------------------------------------------------------------
    Dram1Clk_p            : out   std_logic;
    Dram1Clk_n            : out   std_logic;
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
    -- Bank 1 LV Interface
    -------------------------------------------------------------------------------------
    Dram1ClkUser          : out   std_logic;
    du1DramPhyInitDone    : out   std_logic;
    du1DramAddrFifoFull   : out   std_logic;
    du1DramAddrFifoAddr   : in    std_logic_vector (29 downto 0);
    du1DramAddrFifoCmd    : in    std_logic_vector (2 downto 0);
    du1DramAddrFifoWrEn   : in    std_logic;
    du1DramWrFifoFull     : out   std_logic;
    du1DramWrFifoWrEn     : in    std_logic;
    du1DramWrFifoDataIn   : in    std_logic_vector (639 downto 0);
    du1DramWrFifoMaskData : in    std_logic_vector (79 downto 0);
    du1DramRdDataValid    : out   std_logic;
    du1DramRdFifoDataOut  : out   std_logic_vector (639 downto 0)
    );


end entity SasquatchDram;

architecture struct of SasquatchDram is

  component SasquatchBank1Dram
    port (
      aDramPonResetSl       : in  std_logic;
      Dram1RefClk_p         : in  std_logic;
      Dram1RefClk_n         : in  std_logic;
      Dram1Clk_p            : out std_logic;
      Dram1Clk_n            : out std_logic;
      dr1DramCs_n           : out std_logic;
      dr1DramAct_n          : out std_logic;
      dr1DramAddr           : out std_logic_vector(16 downto 0);
      dr1DramBankAddr       : out std_logic_vector(1 downto 0);
      dr1DramBg             : out std_logic_vector(0 downto 0);
      dr1DramClkEn          : out std_logic;
      dr1DramOdt            : out std_logic;
      dr1DramReset_n        : out std_logic;
      dr1DramDmDbi_n        : inout std_logic_vector(9 downto 0);
      dr1DramDq             : inout std_logic_vector(79 downto 0);
      dr1DramDqs_p          : inout std_logic_vector(9 downto 0);
      dr1DramDqs_n          : inout std_logic_vector(9 downto 0);
      dr1DramTestMode       : out std_logic;
      Dram1ClkUserLcl       : out std_logic;
      adu1Reset             : out std_logic;
      du1DramPhyInitDone    : out std_logic;
      du1DramAddrFifoFull   : out std_logic;
      du1DramAddrFifoAddr   : in  std_logic_vector(29 downto 0);
      du1DramAddrFifoCmd    : in  std_logic_vector(2 downto 0);
      du1DramAddrFifoWrEn   : in  std_logic;
      du1DramWrFifoFull     : out std_logic;
      du1DramWrFifoWrEn     : in  std_logic;
      du1DramWrFifoDataIn   : in  std_logic_vector(639 downto 0);
      du1DramWrFifoMaskData : in  std_logic_vector(79 downto 0);
      du1DramRdDataValid    : out std_logic;
      du1DramRdFifoDataOut  : out std_logic_vector(639 downto 0));
  end component;
  component SasquatchBank0Dram
    port (
      aDramPonResetSl       : in  std_logic;
      Dram0RefClk_p         : in  std_logic;
      Dram0RefClk_n         : in  std_logic;
      Dram0Clk_p            : out std_logic;
      Dram0Clk_n            : out std_logic;
      dr0DramCs_n           : out std_logic;
      dr0DramAct_n          : out std_logic;
      dr0DramAddr           : out std_logic_vector(16 downto 0);
      dr0DramBankAddr       : out std_logic_vector(1 downto 0);
      dr0DramBg             : out std_logic_vector(0 downto 0);
      dr0DramClkEn          : out std_logic;
      dr0DramOdt            : out std_logic;
      dr0DramReset_n        : out std_logic;
      dr0DramDmDbi_n        : inout std_logic_vector(9 downto 0);
      dr0DramDq             : inout std_logic_vector(79 downto 0);
      dr0DramDqs_p          : inout std_logic_vector(9 downto 0);
      dr0DramDqs_n          : inout std_logic_vector(9 downto 0);
      dr0DramTestMode       : out std_logic;
      Dram0ClkUserLcl       : out std_logic;
      adu0Reset             : out std_logic;
      du0DramPhyInitDone    : out std_logic;
      du0DramAddrFifoFull   : out std_logic;
      du0DramAddrFifoAddr   : in  std_logic_vector(29 downto 0);
      du0DramAddrFifoCmd    : in  std_logic_vector(2 downto 0);
      du0DramAddrFifoWrEn   : in  std_logic;
      du0DramWrFifoFull     : out std_logic;
      du0DramWrFifoWrEn     : in  std_logic;
      du0DramWrFifoDataIn   : in  std_logic_vector(639 downto 0);
      du0DramWrFifoMaskData : in  std_logic_vector(79 downto 0);
      du0DramRdDataValid    : out std_logic;
      du0DramRdFifoDataOut  : out std_logic_vector(639 downto 0));
  end component;

  --vhook_sigstart
  signal Dram0ClkUserLcl: std_logic;
  signal Dram1ClkUserLcl: std_logic;
  --vhook_sigend

  -- Std_logic version of reset
  signal aDramPonResetSl : std_logic := '1';

begin  -- architecture struct

  aDramPonResetSl <= to_StdLogic(aDramPonReset);

  ---------------------------------------------------------------------------------------
  -- Bank 0
  ---------------------------------------------------------------------------------------

  GenBank0 : if kInsertBank0Mig generate


    --vhook   SasquatchBank0Dram         Bank0Dram
    --vhook_a adu0Reset                 open
    Bank0Dram: SasquatchBank0Dram
      port map (
        aDramPonResetSl       => aDramPonResetSl,        --in  std_logic
        Dram0RefClk_p         => Dram0RefClk_p,          --in  std_logic
        Dram0RefClk_n         => Dram0RefClk_n,          --in  std_logic
        Dram0Clk_p            => Dram0Clk_p,             --out std_logic
        Dram0Clk_n            => Dram0Clk_n,             --out std_logic
        dr0DramCs_n           => dr0DramCs_n,            --out std_logic
        dr0DramAct_n          => dr0DramAct_n,           --out std_logic
        dr0DramAddr           => dr0DramAddr,            --out std_logic_vector(16:0)
        dr0DramBankAddr       => dr0DramBankAddr,        --out std_logic_vector(1:0)
        dr0DramBg             => dr0DramBg,              --out std_logic_vector(0:0)
        dr0DramClkEn          => dr0DramClkEn,           --out std_logic
        dr0DramOdt            => dr0DramOdt,             --out std_logic
        dr0DramReset_n        => dr0DramReset_n,         --out std_logic
        dr0DramDmDbi_n        => dr0DramDmDbi_n,         --inout std_logic_vector(9:0)
        dr0DramDq             => dr0DramDq,              --inout std_logic_vector(79:0)
        dr0DramDqs_p          => dr0DramDqs_p,           --inout std_logic_vector(9:0)
        dr0DramDqs_n          => dr0DramDqs_n,           --inout std_logic_vector(9:0)
        dr0DramTestMode       => dr0DramTestMode,        --out std_logic
        Dram0ClkUserLcl       => Dram0ClkUserLcl,        --out std_logic
        adu0Reset             => open,                   --out std_logic
        du0DramPhyInitDone    => du0DramPhyInitDone,     --out std_logic
        du0DramAddrFifoFull   => du0DramAddrFifoFull,    --out std_logic
        du0DramAddrFifoAddr   => du0DramAddrFifoAddr,    --in  std_logic_vector(29:0)
        du0DramAddrFifoCmd    => du0DramAddrFifoCmd,     --in  std_logic_vector(2:0)
        du0DramAddrFifoWrEn   => du0DramAddrFifoWrEn,    --in  std_logic
        du0DramWrFifoFull     => du0DramWrFifoFull,      --out std_logic
        du0DramWrFifoWrEn     => du0DramWrFifoWrEn,      --in  std_logic
        du0DramWrFifoDataIn   => du0DramWrFifoDataIn,    --in  std_logic_vector(639:0)
        du0DramWrFifoMaskData => du0DramWrFifoMaskData,  --in  std_logic_vector(79:0)
        du0DramRdDataValid    => du0DramRdDataValid,     --out std_logic
        du0DramRdFifoDataOut  => du0DramRdFifoDataOut);  --out std_logic_vector(639:0)


    Dram0ClkUser <= Dram0ClkUserLcl;

  end generate GenBank0;

  NoBank0 : if not kInsertBank0Mig generate

    --vhook_e SasquatchEmptyDram         Bank0NoDram
    --vhook_a aduReset                  open
    --vhook_a {^(a?du|dr)(.*)}          $10$2
    --vhook_a {DramClk}                 Dram0Clk
    --vhook_a {DramRefClk}              Dram0RefClk
    Bank0NoDram: entity work.SasquatchEmptyDram (struct)
      port map (
        aDramPonReset        => aDramPonReset,          --in  boolean
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
        aduReset             => open,                   --out std_logic
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

  end generate NoBank0;

  ---------------------------------------------------------------------------------------
  -- Bank 1
  ---------------------------------------------------------------------------------------

  GenBank1 : if kInsertBank1Mig generate


    --vhook   SasquatchBank1Dram          Bank1Dram
    --vhook_a adu1Reset                  open
    Bank1Dram: SasquatchBank1Dram
      port map (
        aDramPonResetSl       => aDramPonResetSl,        --in  std_logic
        Dram1RefClk_p         => Dram1RefClk_p,          --in  std_logic
        Dram1RefClk_n         => Dram1RefClk_n,          --in  std_logic
        Dram1Clk_p            => Dram1Clk_p,             --out std_logic
        Dram1Clk_n            => Dram1Clk_n,             --out std_logic
        dr1DramCs_n           => dr1DramCs_n,            --out std_logic
        dr1DramAct_n          => dr1DramAct_n,           --out std_logic
        dr1DramAddr           => dr1DramAddr,            --out std_logic_vector(16:0)
        dr1DramBankAddr       => dr1DramBankAddr,        --out std_logic_vector(1:0)
        dr1DramBg             => dr1DramBg,              --out std_logic_vector(0:0)
        dr1DramClkEn          => dr1DramClkEn,           --out std_logic
        dr1DramOdt            => dr1DramOdt,             --out std_logic
        dr1DramReset_n        => dr1DramReset_n,         --out std_logic
        dr1DramDmDbi_n        => dr1DramDmDbi_n,         --inout std_logic_vector(9:0)
        dr1DramDq             => dr1DramDq,              --inout std_logic_vector(79:0)
        dr1DramDqs_p          => dr1DramDqs_p,           --inout std_logic_vector(9:0)
        dr1DramDqs_n          => dr1DramDqs_n,           --inout std_logic_vector(9:0)
        dr1DramTestMode       => dr1DramTestMode,        --out std_logic
        Dram1ClkUserLcl       => Dram1ClkUserLcl,        --out std_logic
        adu1Reset             => open,                   --out std_logic
        du1DramPhyInitDone    => du1DramPhyInitDone,     --out std_logic
        du1DramAddrFifoFull   => du1DramAddrFifoFull,    --out std_logic
        du1DramAddrFifoAddr   => du1DramAddrFifoAddr,    --in  std_logic_vector(29:0)
        du1DramAddrFifoCmd    => du1DramAddrFifoCmd,     --in  std_logic_vector(2:0)
        du1DramAddrFifoWrEn   => du1DramAddrFifoWrEn,    --in  std_logic
        du1DramWrFifoFull     => du1DramWrFifoFull,      --out std_logic
        du1DramWrFifoWrEn     => du1DramWrFifoWrEn,      --in  std_logic
        du1DramWrFifoDataIn   => du1DramWrFifoDataIn,    --in  std_logic_vector(639:0)
        du1DramWrFifoMaskData => du1DramWrFifoMaskData,  --in  std_logic_vector(79:0)
        du1DramRdDataValid    => du1DramRdDataValid,     --out std_logic
        du1DramRdFifoDataOut  => du1DramRdFifoDataOut);  --out std_logic_vector(639:0)


    Dram1ClkUser <= Dram1ClkUserLcl;

  end generate GenBank1;

  NoBank1 : if not kInsertBank1Mig generate

    --vhook_e SasquatchEmptyDram         Bank1NoDram
    --vhook_a aduReset                  open
    --vhook_a {^(a?du|dr)(.*)}          $11$2
    --vhook_a {DramClk}                 Dram1Clk
    --vhook_a {DramRefClk}              Dram1RefClk
    Bank1NoDram: entity work.SasquatchEmptyDram (struct)
      port map (
        aDramPonReset        => aDramPonReset,          --in  boolean
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
        aduReset             => open,                   --out std_logic
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

  end generate NoBank1;

  ---------------------------------------------------------------------------------------
  -- Choose Clock for LVFPGA-facing interface
  ---------------------------------------------------------------------------------------

  GenLvFpgaClk0 : if kInsertBank0Mig generate
    DramClkLvFpga <= Dram0ClkUserLcl;
  end generate GenLvFpgaClk0;


  GenLvFpgaClk1 : if not kInsertBank0Mig generate
    DramClkLvFpga <= Dram1ClkUserLcl;
  end generate GenLvFpgaClk1;

end architecture struct;
