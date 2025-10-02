------------------------------------------------------------------------------------------
--
-- File: IoRefClkSelect.vhd
-- Author: Rolando Ortega
-- Original Project: Macallan Next Generation FlexRIO
-- Date: 29 November 2017
--
------------------------------------------------------------------------------------------
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
------------------------------------------------------------------------------------------
--
-- Purpose: These flops are place outside the fixedlogic because their reset values are
-- set by scripted constants defined in PkgLvFpgaConst. Since we pre-synthesize the
-- Fixedlogic it might not be possible to properly optimize their reset values.
--
-- This module would be perfectly at home (and would perhaps take up less vertical space)
-- living on the top-level directly. But we get better code reuse by modularizing this
-- functionality.
-------------------------------------------------------------------------------------------
--
-- githubvisible=true
--
-- vreview_group CommonFixedLogic
-- vreview_closed http://review-board.natinst.com/r/313040/
-- vreview_closed http://review-board.natinst.com/r/266932/
-- vreview_closed http://review-board.natinst.com/r/217971/
-- vreview_reviewers kygreen dhearn esalinas hrubio lboughal rcastro
-- 
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.PkgLvFpgaConst.all;

entity IoRefClkSelect is

  port (
    BusClk                   : in  std_logic;
    abDiagramReset           : in  boolean;
    -- Fixed-logic controls
    bdSetIoRefClk100Enable   : in  std_logic;
    bdClearIoRefClk100Enable : in  std_logic;
    bdSetIoRefClk10Enable    : in  std_logic;
    bdClearIoRefClk10Enable  : in  std_logic;
    bdSelectIoRefClk100      : in  std_logic;
    bdSelectIoRefClk10       : in  std_logic;
    -- Enable/Disable outputs.
    bdIoRefClk100Enabled     : out std_logic;
    bdIoRefClk10Enabled      : out std_logic;
    bdIoRefClkSwitch         : out std_logic;
    -- Static values that are pushed out to the top level to be consumed by the fixed
    -- logic.
    stEnableIoRefClk10       : out std_logic;
    stEnableIoRefClk100      : out std_logic
    );


end entity IoRefClkSelect;

architecture rtl of IoRefClkSelect is

  constant kEnableIoRefClk10  : std_logic := kEnableFamClockSync and (not kFamClockSrcSel);
  constant kEnableIoRefClk100 : std_logic := kEnableFamClockSync and kFamClockSrcSel;

  -- Enable/Disable Locals (with default assignments)
  signal bdIoRefClk100EnabledLcl : std_logic := kEnableIoRefClk100;
  signal bdIoRefClk10EnabledLcl  : std_logic := kEnableIoRefClk10;
  signal bdIoRefClkSwitchLcl     : std_logic := kFamClockSrcSel;

begin  -- architecture rtl

  RefClkSelect : process(abDiagramReset, BusClk) is
  begin
    if abDiagramReset then
      bdIoRefClk100EnabledLcl <= kEnableIoRefClk100;
      bdIoRefClk10EnabledLcl  <= kEnableIoRefClk10;
      bdIoRefClkSwitchLcl     <= kFamClockSrcSel;
    elsif rising_edge(BusClk) then
      -- Simple set/resets.
      bdIoRefClk100EnabledLcl <= (bdIoRefClk100EnabledLcl or bdSetIoRefClk100Enable)
                                 and (not bdClearIoRefClk100Enable);
      bdIoRefClk10EnabledLcl <= (bdIoRefClk10EnabledLcl or bdSetIoRefClk10Enable)
                                and (not bdClearIoRefClk10Enable);
      bdIoRefClkSwitchLcl <= (bdIoRefClkSwitchLcl or bdSelectIoRefClk100)
                             and (not bdSelectIoRefClk10);
    end if;
  end process RefClkSelect;

  bdIoRefClk100Enabled <= bdIoRefClk100EnabledLcl;
  bdIoRefClk10Enabled  <= bdIoRefClk10EnabledLcl;
  bdIoRefClkSwitch     <= bdIoRefClkSwitchLcl;

  stEnableIoRefClk10  <= kEnableIoRefClk10;
  stEnableIoRefClk100 <= kEnableIoRefClk100;

end architecture rtl;
