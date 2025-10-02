------------------------------------------------------------------------------------------
--
-- File: PkgSasquatch.vhd
-- Author: Rolando Ortega
-- Original Project: The Macallan Next-Gen FlexRIO
-- Date: 13 February 2015
--
------------------------------------------------------------------------------------------
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
------------------------------------------------------------------------------------------
--
-- Purpose: Package in odds and ends
------------------------------------------------------------------------------------------
--
-- githubvisible=true
--
-- vreview_group TargetConfig
-- vreview_closed http://review-board.natinst.com/r/313041/
-- vreview_reviewers kygreen dhearn esalinas hrubio lboughal rcastro
--
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PkgBaRegPort.all;

package PkgSasquatch is

  -- Number of MGTs
  constant kMgtPortWidth : positive := 16;
  subtype MgtPort_t is std_logic_vector (kMgtPortWidth-1 downto 0);

  ---------------------------------------------------------------------------------------
  -- I2c
  ---------------------------------------------------------------------------------------
  -- Number of I2c Interfaces
  constant kNumI2cIfcs        : natural := 4;
  -- Indexes to assign each I2c interface to an element in a vector.
  constant kMezzSmbIndex      : natural := 0;
  constant kBaseSmbIndex      : natural := 1;
  constant kConfigI2cIndex    : natural := 2;
  constant kPwrSupplyPmbIndex : natural := 3;
  -- We don't use this one yet, hence the claim that there's only 4 I2c Interfaces.
  constant kSysMonI2cIndex    : natural := 4;

end package PkgSasquatch;
