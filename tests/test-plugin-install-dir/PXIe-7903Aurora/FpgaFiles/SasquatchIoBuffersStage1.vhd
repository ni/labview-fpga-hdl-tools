------------------------------------------------------------------------------------------
--
-- File: SasquatchIoBuffersStage1.vhd
-- Author: Rolando Ortega
-- Original Project: Macallan Next FlexRIO
-- Date: 18 September 2017
--
------------------------------------------------------------------------------------------
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
------------------------------------------------------------------------------------------
--
-- Purpose: This module groups together IO Buffer blocks that need to be applied to Stage 2
-- signals which have their ports in a bank that includes Stage 1 signals. The IO Buffers
-- for such signals need to be in Stage 1.
--
-- We ran into an issue with Vivado 2015.4 whereby the HD.TANDEM property was being
-- applied incorrectly when we tried to use some clever tcl-crafting to find the
-- (auto-generated) IBUF cells, so we're packing them all explicitly in this module
-- instead, and will use a simpler tcl constraint.
------------------------------------------------------------------------------------------
--
-- githubvisible=true
-- vreview_group AppletonIoBuffers
-- vreview_closed http://review-board.natinst.com/r/329181/
-- vreview_closed http://review-board.natinst.com/r/313063/
-- vreview_reviewers kygreen dhearn esalinas hrubio lboughal rcastro
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library work;
use work.PkgNiUtilities.all;

entity SasquatchIoBuffersStage1 is
  port (
    -- Control signal to avoid pins turning on unnecessarily.
    aStage2Enabled  : in    boolean;

    -- Authentication
    aAuthSda            : inout std_logic;

    aAuthSdaInBuf      : out   std_logic;
    aAuthSdaOutBuf     : in    std_logic;

    -- PXI GA
    aPxiGa               : in    std_logic_vector(4 downto 0);
    aGa                  : out   std_logic_vector(4 downto 0);

    -- PCIe Reset
    aPcieRst_n      : in    std_logic;
    aPcieRst        : out   std_logic
  );
end entity SasquatchIoBuffersStage1;

architecture struct of SasquatchIoBuffersStage1 is

  --vhook_sigstart
  signal aAuthSdaTristate: std_ulogic;
  signal aPcieRstIBuf_n: std_ulogic;
  --vhook_sigend

  -- Global tristate enable
  signal aDisableOutputs : std_logic;

begin  -- architecture struct

  aDisableOutputs <= not to_StdLogic(aStage2Enabled);

  ---------------------------------------------------------------------------------------
  -- Authentication
  ---------------------------------------------------------------------------------------

  -- Single Wire interface is open-collector, has external pull-up. So we drive 'Z' when
  -- aAuthSdaOut is '1', and '0' otherwise.

  --vhook_i IOBUF       AuthSdaBuf      hidegeneric=true
  --vhook_a IO          aAuthSda
  --vhook_a I           '0'
  --vhook_a O           aAuthSdaInBuf
  --vhook_a T           aAuthSdaTristate
  AuthSdaBuf: IOBUF
    port map (
      O  => aAuthSdaInBuf,     --out std_ulogic
      IO => aAuthSda,          --inout std_ulogic
      I  => '0',               --in  std_ulogic
      T  => aAuthSdaTristate); --in  std_ulogic

  -- Keep the buffer tristated until the Stage 2 is enabled. We hope the resulting LUT is
  -- 1) Glitch-free
  -- 2) Inside Stage 1
  aAuthSdaTristate <= aAuthSdaOutBuf when aStage2Enabled else '1';

  ---------------------------------------------------------------------------------------
  -- PXI
  ---------------------------------------------------------------------------------------

  -- IOBUF ports
  -- I:  data to drive to the pad
  -- O:  data received from the pad
  -- IO: the pad
  GenPxiGaBufs: for i in aPxiGa'range generate

    --vhook_i IBUF        PxiGaIbuf     hidegeneric=true
    --vhook_a I           aPxiGa(i)
    --vhook_a O           aGa(i)
    PxiGaIbuf: IBUF
      port map (
        O => aGa(i),     --out std_ulogic
        I => aPxiGa(i)); --in  std_ulogic

  end generate GenPxiGaBufs;

  ---------------------------------------------------------------------------------------
  -- PCIe Reset
  ---------------------------------------------------------------------------------------
  -- Despite being part of the PCIe endpoint, we need for this IBUF to land in the IO
  -- Buffer PBlock rather than inside the PCIe Pblock. So we put it in this module.

  --vhook_i IBUF      PcieRstIBuf       hidegeneric=true
  --vhook_a I         aPcieRst_n
  --vhook_a O         aPcieRstIBuf_n
  PcieRstIBuf: IBUF
    port map (
      O => aPcieRstIBuf_n,  --out std_ulogic
      I => aPcieRst_n);     --in  std_ulogic

  aPcieRst <= not aPcieRstIBuf_n;

end architecture struct;
