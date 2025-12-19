------------------------------------------------------------------------------------------
--
-- File: IwCompanion.vhd
-- Author: Rolando Ortega
-- Original Project: The Macallan Next FlexRIO
-- Date: 12 October 2018
--
------------------------------------------------------------------------------------------
-- (c) 2018 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
------------------------------------------------------------------------------------------
--
-- Purpose: Wrapper for the Inchworm Companion
------------------------------------------------------------------------------------------
--
-- vreview_group IwCompanion
-- vreview_closed http://review-board.natinst.com/r/317141/
-- vreview_reviewers kygreen dhearn esalinas hrubio lboughal rcastro
--
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgNiUtilities.all;

library work;
use work.PkgNiUtilities.all;
use work.PkgBaRegPort.all;  --Fixed Logic RegPort
use work.PkgCommunicationInterface.all;  --LabVIEW RegPorts
use work.PkgNiDma.all;                   --DmaPort
use work.PkgDmaPortRecordFlattening.all; --Flattening and unflattening
use work.PkgSwitchedChinch.all;

--synthesis translate_off
--frmake_addlibrary
--synthesis translate_on

entity IwCompanion is
  port (
    -- Reset with asynchronous deassertion (as far as Timing Analysis is concerned).
    aBusReset               : in  boolean;
    -- Main bus clock. 125 or 250 MHz
    DmaClock                : in  std_logic;
    -- Main regport from InChWORM Netlist
    dBaRegPortIn            : in  BaRegPortIn_t;
    dBaRegPortOut           : out BaRegPortOut_t;
    dLvUserMappable         : out std_logic;
    --------------------------------------
    -- LabVIEW RegPort on BusClk (typically 80 MHz clock)
    -- Expected to be exclusive for LabVIEW Window
    -- Note that this and the DmaRegport (below) need to form a Fixed IO Window
    --   (mapped to the beginning of IO space) for NI RIO compatibility
    ----------------------------------------
    BusClk                  : in  std_logic;
    --Using types and constants and flattening/unflattening functions provided by
    -- LabVIEW in PkgCommunicationInterface
    bLvWindowRegPortIn      : out RegPortIn_t;
    bLvWindowRegPortOut     : in  RegPortOut_t;
    bLvWindowRegPortTimeOut : out boolean;
    --------------------------------------
    -- DMA RegPort on DmaClock
    -- Expected to be exclusively connected to the DmaPortCommunicationInterface module
    ----------------------------------------
    --Using types and constants and flattening/unflattening functions provided by
    -- LabVIEW in PkgCommunicationInterface
    dDmaCommIfcRegPortIn    : out RegPortIn_t;
    dDmaCommIfcRegPortOut   : in  RegPortOut_t;
    --------------------------------------
    -- Fixed Logic Register Port (Byte Addressable RegPort for Fixed Logic).
    --  Fixed logic can instantiate a BaRegPortToLvFpgaRegPort module outside the wrapper
    --  if LabVEIW regport interface is required (or modify this module).
    -- Note that this is not part of the LabVIEW IO Window. By default these addresses
    --  are not translated to a different IO space, although the fixed logic designer
    --  can do the translation if desired for compatibility purposes.
    ----------------------------------------
    dFixedLogicBaRegPortIn  : out BaRegPortIn_t;
    dFixedLogicBaRegPortOut : in  BaRegPortOut_t;
    -------------------------------------------------------------------------------------
    -- Geographic Addressing
    -------------------------------------------------------------------------------------
    aGa                     : in  std_logic_vector(4 downto 0)
    );

end entity;  --IwCompanion

architecture wrapper of IwCompanion is

  component IwCompanionN
    port (
      aBusReset                   : in  boolean;
      DmaClock                    : in  std_logic;
      dFlatBaRegPortIn            : in  FlatBaRegPortIn_t;
      dFlatBaRegPortOut           : out FlatBaRegPortOut_t;
      dLvUserMappable             : out std_logic;
      BusClk                      : in  std_logic;
      bFlatLvWindowRegPortIn      : out std_logic_vector(kRegPortInSize-1 downto 0);
      bFlatLvWindowRegPortOut     : in  std_logic_vector(kRegPortOutSize-1 downto 0);
      bLvWindowRegPortTimeOut     : out boolean;
      dFlatDmaCommIfcRegPortIn    : out std_logic_vector(kRegPortInSize-1 downto 0);
      dFlatDmaCommIfcRegPortOut   : in  std_logic_vector(kRegPortOutSize-1 downto 0);
      dFlatFixedLogicBaRegPortIn  : out FlatBaRegPortIn_t;
      dFlatFixedLogicBaRegPortOut : in  FlatBaRegPortOut_t;
      aGa                         : in  std_logic_vector(4 downto 0));
  end component;

  --vhook_sigstart
  signal bFlatLvWindowRegPortIn: std_logic_vector(kRegPortInSize-1 downto 0);
  signal bFlatLvWindowRegPortOut: std_logic_vector(kRegPortOutSize-1 downto 0);
  signal dFlatBaRegPortIn: FlatBaRegPortIn_t;
  signal dFlatBaRegPortOut: FlatBaRegPortOut_t;
  signal dFlatDmaCommIfcRegPortIn: std_logic_vector(kRegPortInSize-1 downto 0);
  signal dFlatDmaCommIfcRegPortOut: std_logic_vector(kRegPortOutSize-1 downto 0);
  signal dFlatFixedLogicBaRegPortIn: FlatBaRegPortIn_t;
  signal dFlatFixedLogicBaRegPortOut: FlatBaRegPortOut_t;
  --vhook_sigend

begin  -- architecture wrapper

  --vhook IwCompanionN IwCompanionNx
  IwCompanionNx: IwCompanionN
    port map (
      aBusReset                   => aBusReset,                    --in  boolean
      DmaClock                    => DmaClock,                     --in  std_logic
      dFlatBaRegPortIn            => dFlatBaRegPortIn,             --in  FlatBaRegPortIn_t
      dFlatBaRegPortOut           => dFlatBaRegPortOut,            --out FlatBaRegPortOut_t
      dLvUserMappable             => dLvUserMappable,              --out std_logic
      BusClk                      => BusClk,                       --in  std_logic
      bFlatLvWindowRegPortIn      => bFlatLvWindowRegPortIn,       --out std_logic_vector(kRegPortInSize-1:0)
      bFlatLvWindowRegPortOut     => bFlatLvWindowRegPortOut,      --in  std_logic_vector(kRegPortOutSize-1:0)
      bLvWindowRegPortTimeOut     => bLvWindowRegPortTimeOut,      --out boolean
      dFlatDmaCommIfcRegPortIn    => dFlatDmaCommIfcRegPortIn,     --out std_logic_vector(kRegPortInSize-1:0)
      dFlatDmaCommIfcRegPortOut   => dFlatDmaCommIfcRegPortOut,    --in  std_logic_vector(kRegPortOutSize-1:0)
      dFlatFixedLogicBaRegPortIn  => dFlatFixedLogicBaRegPortIn,   --out FlatBaRegPortIn_t
      dFlatFixedLogicBaRegPortOut => dFlatFixedLogicBaRegPortOut,  --in  FlatBaRegPortOut_t
      aGa                         => aGa);                         --in  std_logic_vector(4:0)

  ---------------------------------------------------------------------------------------
  -- Flatten / Unflatten
  ---------------------------------------------------------------------------------------
  -- Incoming BaRegPort from Inchworm
  dFlatBaRegPortIn            <= Flatten(dBaRegPortIn);
  dBaRegPortOut               <= Unflatten(dFlatBaRegPortOut);
  -- LV Window RegPort
  bLvWindowRegPortIn          <= BuildRegPortIn(bFlatLvWindowRegPortIn);
  bFlatLvWindowRegPortOut     <= to_StdLogicVector(bLvWindowRegPortOut);
  -- DmaPort LV RegPort
  dDmaCommIfcRegPortIn        <= BuildRegPortIn(dFlatDmaCommIfcRegPortIn);
  dFlatDmaCommIfcRegPortOut   <= to_StdLogicVector(dDmaCommIfcRegPortOut);
  -- FixedLogic BaRegPOrt
  dFixedLogicBaRegPortIn      <= Unflatten(dFlatFixedLogicBaRegPortIn);
  dFlatFixedLogicBaRegPortOut <= Flatten(dFixedLogicBaRegPortOut);

end architecture wrapper;
