------------------------------------------------------------------------------------------
--
-- File: PkgSysMonConfig.vhd
-- Author: Rolando Ortega
-- Original Project: Buffalo Trace FlexRIO Carrier
-- Date: 23 September 2018
--
------------------------------------------------------------------------------------------
-- (c) 2025 Copyright National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
------------------------------------------------------------------------------------------
--
-- Purpose: Enumerate the number of Analog Channels, and name each of them.
------------------------------------------------------------------------------------------
--
-- githubvisible=true
--
-- vreview_group CorubaFixedLogic
-- vreview_reviewers kygreen dhearn esalinas hrubio lboughal rcastro
--
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgNiUtilities.all;

package PkgSysMonConfig is

  -- Number of total (used and unused) SysMon Channels
  constant kNumSysMonChannels : natural := 16;

  -- First, we enumerate the assignment of each of the channels. Note that this has to
  -- match the schematic (i.e. the voltage monitor connected to ADxP/ADxN needs to be
  -- assigned index x.
  constant kSysMon_DramVpp_Divided      : natural := 0;
  constant kSysMon_DramVref_Sense       : natural := 1;
  constant kSysMon_3v3A_Divided         : natural := 2;
  constant kSysMon_1v8A_Divided         : natural := 3;
  constant kSysMon_3v3VDMezz_Divided    : natural := 4;
  constant kSysMon_3v3AMezz_Divided     : natural := 5;
  constant kSysMon_0v9MgtAvcc_Divided   : natural := 6;
  constant kSysMon_Dram0Vtt_Sense       : natural := 8;
  constant kSysMon_3v3D_Divided         : natural := 9;
  constant kSysMon_1v8MgtVccaux_Divided : natural := 10;
  constant kSysMon_3v8_Divided          : natural := 11;
  constant kSysMon_VccioMezz_Divided    : natural := 12;
  constant kSysMon_1v2MgtAvtt_Divided   : natural := 13;
  constant kSysMon_1v2_Divided          : natural := 14;

  -- Now we need to create a constant that tells us which of the sysmon pins are actually
  -- used. These are all the pins we've enumerated above, so we just create an array that
  -- contains all of them:
  constant kSysMonChannelsUsed : NaturalVector :=
    (kSysMon_DramVref_Sense,
     kSysMon_Dram0Vtt_Sense,
     kSysMon_DramVpp_Divided,
     kSysMon_3v8_Divided,
     kSysMon_VccioMezz_Divided,
     kSysMon_3v3AMezz_Divided,
     kSysMon_1v2MgtAvtt_Divided,
     kSysMon_1v8MgtVccaux_Divided,
     kSysMon_1v8A_Divided,
     kSysMon_3v3D_Divided,
     kSysMon_3v3A_Divided,
     kSysMon_3v3VDMezz_Divided,
     kSysMon_0v9MgtAvcc_Divided,
     kSysMon_1v2_Divided);

end package PkgSysMonConfig;
