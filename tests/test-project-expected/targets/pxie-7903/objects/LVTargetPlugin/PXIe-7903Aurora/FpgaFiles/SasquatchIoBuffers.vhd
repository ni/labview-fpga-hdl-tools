------------------------------------------------------------------------------------------
--
-- File: SasquatchIoBuffers.vhd
-- Author: Rolando Ortega
-- Original Project: Macallan
-- Date: 09 January 2017
--
------------------------------------------------------------------------------------------
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- All rights reserved.
------------------------------------------------------------------------------------------
--
-- Purpose: This module holds the IO buffers for the Macallan carrier to keep them off
-- the top level.
--
-- vreview_group SasquatchIoBuffers
-- vreview_closed http://review-board.natinst.com/r/237885/
-- vreview_closed http://review-board.natinst.com/r/223438/
-- vreview_reviewers kygreen dhearn esalinas hrubio lboughal rcastro
------------------------------------------------------------------------------------------
--
-- githubvisible=true

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library work;
use work.PkgNiUtilities.all;

entity SasquatchIoBuffers is

  generic (
    kNumI2cIfcs   : natural := 5);

  port (
    -------------------------------------------------------------------------------------
    -- I2C
    -------------------------------------------------------------------------------------
    aI2cSclIn             : out   std_logic_vector(kNumI2cIfcs-1 downto 0);
    aI2cSclOut            : in    std_logic_vector(kNumI2cIfcs-1 downto 0);
    aI2cSclTri            : in    std_logic_vector(kNumI2cIfcs-1 downto 0);
    aI2cScl               : inout std_logic_vector(kNumI2cIfcs-1 downto 0);
    -- SDA
    aI2cSdaIn             : out   std_logic_vector(kNumI2cIfcs-1 downto 0);
    aI2cSdaOut            : in    std_logic_vector(kNumI2cIfcs-1 downto 0);
    aI2cSdaTri            : in    std_logic_vector(kNumI2cIfcs-1 downto 0);
    aI2cSda               : inout std_logic_vector(kNumI2cIfcs-1 downto 0);
    -------------------------------------------------------------------------------------
    -- Triggers
    -------------------------------------------------------------------------------------
    -- The Window Interface
    aPxiTrigDataIn        : out   std_logic_vector(7 downto 0);
    aPxiTrigDataOut       : in    std_logic_vector(7 downto 0);
    aPxiTrigDataTri       : in    std_logic_vector(7 downto 0);
    -- Top-level interface
    aPxiTrigData          : inout std_logic_vector(7 downto 0);
    -------------------------------------------------------------------------------------
    -- DStar
    -------------------------------------------------------------------------------------
    -- B
    aPxieDStarB           : out   std_logic;
    aPxieDStarB_p         : in    std_logic;
    aPxieDStarB_n         : in    std_logic;
    -- C
    aPxieDStarC           : in    std_logic;
    aPxieDStarCEn_n       : in    std_logic;
    aPxieDStarC_p         : out   std_logic;
    aPxieDStarC_n         : out   std_logic;
    -------------------------------------------------------------------------------------
    -- CPLD Sideband
    -------------------------------------------------------------------------------------
    SidebandClk         : out   std_logic;
    sSidebandDataOut    : out   std_logic_vector(3 downto 0);
    aSidebandDataIn     : in    std_logic;
    aSidebandFifoFull     : in    std_logic;

    SidebandClkBuf     : in    std_logic;
    sSidebandDataOutBuf: in    std_logic_vector(3 downto 0);
    aSidebandDataInBuf : out   std_logic;
    aSidebandFifoFullBuf : out   std_logic;
    -------------------------------------------------------------------------------------
    -- Fpga Done
    -------------------------------------------------------------------------------------
    aFpgaStage2Done : out   std_logic
  );
end entity SasquatchIoBuffers;

architecture struct of SasquatchIoBuffers is

  --vhook_sigstart
  --vhook_sigend

  attribute iob : boolean;

begin  -- architecture struct

  ---------------------------------------------------------------------------------------
  -- I2C
  ---------------------------------------------------------------------------------------

  GenI2c : for i in aI2cScl'range generate

    aI2cScl(i)   <= aI2cSclOut(i) when aI2cSclTri(i) = '0' else 'Z';
    aI2cSclIn(i) <= aI2cScl(i);

    aI2cSda(i)   <= aI2cSdaOut(i) when aI2cSdaTri(i) = '0' else 'Z';
    aI2cSdaIn(i) <= aI2cSda(i);

  end generate GenI2c;

  ---------------------------------------------------------------------------------------
  -- Triggers
  ---------------------------------------------------------------------------------------

  GenTriggers : for i in aPxiTrigDataIn'range generate

    --vhook_i IOBUF     PxiTrigBuf      hidegeneric=true
    --vhook_a O         aPxiTrigDataIn(i)
    --vhook_a I         aPxiTrigDataOut(i)
    --vhook_a IO        aPxiTrigData(i)
    --vhook_a T         aPxiTrigDataTri(i)
    PxiTrigBuf: IOBUF
      port map (
        O  => aPxiTrigDataIn(i),   --out std_ulogic
        IO => aPxiTrigData(i),     --inout std_ulogic
        I  => aPxiTrigDataOut(i),  --in  std_ulogic
        T  => aPxiTrigDataTri(i)); --in  std_ulogic

  end generate GenTriggers;

  -------------------------------------------------------------------------------------
  -- DStar
  -------------------------------------------------------------------------------------

  -- Need to instantiate some output buffers for output differential signals, lest they
  -- give us trouble in bitgen.

  --vhook_i OBUFTDS     PxieDStarCBuf           hidegeneric=true
  --vhook_a I           aPxieDStarC
  --vhook_a O           aPxieDStarC_p
  --vhook_a OB          aPxieDStarC_n
  --vhook_a T           aPxieDStarCEn_n
  PxieDStarCBuf: OBUFTDS
    port map (
      O  => aPxieDStarC_p,    --out std_ulogic
      OB => aPxieDStarC_n,    --out std_ulogic
      I  => aPxieDStarC,      --in  std_ulogic
      T  => aPxieDStarCEn_n); --in  std_ulogic

  --vhook_i IBUFDS      PxieDStarBBuf           hidegeneric=true
  --vhook_a I           aPxieDStarB_p
  --vhook_a IB          aPxieDStarB_n
  --vhook_a O           aPxieDStarB
  PxieDStarBBuf: IBUFDS
    port map (
      O  => aPxieDStarB,    --out std_ulogic
      I  => aPxieDStarB_p,  --in  std_ulogic
      IB => aPxieDStarB_n); --in  std_ulogic

  ---------------------------------------------------------------------------------------
  -- CPLD Sideband
  ---------------------------------------------------------------------------------------
  --vhook_i OBUF        SidebandClkObuf  hidegeneric=true
  --vhook_a I           SidebandClkBuf
  --vhook_a O           SidebandClk
  SidebandClkObuf: OBUF
    port map (
      O => SidebandClk,     --out std_ulogic
      I => SidebandClkBuf); --in  std_ulogic

  GenSidebandDataOut: for i in sSidebandDataOut'range generate
    --vhook_i OBUF        SidebandDataOutObuf  hidegeneric=true
    --vhook_a I           sSidebandDataOutBuf(i)
    --vhook_a O           sSidebandDataOut(i)
    SidebandDataOutObuf: OBUF
      port map (
        O => sSidebandDataOut(i),     --out std_ulogic
        I => sSidebandDataOutBuf(i)); --in  std_ulogic
  end generate GenSidebandDataOut;

  --vhook_i IBUF        SidebandDataInIbuf  hidegeneric=true
  --vhook_a I           aSidebandDataIn
  --vhook_a O           aSidebandDataInBuf
  SidebandDataInIbuf: IBUF
    port map (
      O => aSidebandDataInBuf,  --out std_ulogic
      I => aSidebandDataIn);    --in  std_ulogic

  --vhook_i IBUF        SidebandRxFullIbuf  hidegeneric=true
  --vhook_a I           aSidebandFifoFull
  --vhook_a O           aSidebandFifoFullBuf
  SidebandRxFullIbuf: IBUF
    port map (
      O => aSidebandFifoFullBuf,  --out std_ulogic
      I => aSidebandFifoFull);    --in  std_ulogic

  ---------------------------------------------------------------------------------------
  -- Stage 2 Done
  ---------------------------------------------------------------------------------------
  -- Stage 2 done has been renamed to Fpga_Cpld_Spare on schematic, because it's not actually
  -- being used. We can just tristate this.
  aFpgaStage2Done <= 'Z';

end architecture struct;
