-------------------------------------------------------------------------------
--
-- File: PkgBaRegPortConfig.vhd
-- Author: James Gorman
-- Original Project: NI DMA IP
-- Date: 11 Feburary 2015
--
-------------------------------------------------------------------------------
-- (c) 2015 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
-- Configures the with of the address and data on Reg Port.
-- Each design will modify this package based on the application requirements.
-------------------------------------------------------------------------------
--
-- vreview_group CommonFixedLogic
-- vreview_closed http://review-board.natinst.com/r/313040/
-- vreview_reviewers kygreen dhearn esalinas hrubio lboughal rcastro
--
------------------------------------------------------------------------------------------

package PkgBaRegPortConfig is

  --Allowing BaRegport to see the whole Local address space, including the
  -- ConfigMemoryWindow which has visibility of the whole configuration flash without
  -- windowing.

  -- The setting of 28 matches (at the time of this writing) the configuration for the
  -- Gen3 InchWorm.
  constant kBaRegPortAddressWidthConfig : natural := 28;
  constant kBaRegPortDataWidthConfig    : natural := 64;

end PkgBaRegPortConfig;
