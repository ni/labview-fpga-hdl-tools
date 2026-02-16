------------------------------------------------------------------------------------------
--
-- File: PkgFlexRioTargetConfig.vhd
-- Author: Kyle Green
-- Original Project: 798x NextGen FlexRIO
-- Date: 13 February 2015
--
------------------------------------------------------------------------------------------
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- All rights reserved.
------------------------------------------------------------------------------------------
--
-- Purpose: This package contains configuration information that describes a given
-- FlexRIO backend in a way that allows a single IoModule CLIP to be compatible with
-- multiple backends.
--
------------------------------------------------------------------------------------------
--
-- githubvisible=true
--
-- vreview_group TargetConfig
-- vreview_closed http://review-board.natinst.com/r/328688/
-- vreview_reviewers kygreen dhearn esalinas hrubio lboughal rcastro
--
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package PkgFlexRioTargetConfig is

  ---------------------------------------------------------------------------------------
  -- Target Description
  ---------------------------------------------------------------------------------------
  constant kFlexRioIoModuleFormat : string := "48-MGT-USP";
  constant kFlexRioProductGroup : string := "7903-PXIe";

  ---------------------------------------------------------------------------------------
  -- MGT and RefClk Counts
  ---------------------------------------------------------------------------------------
  -- These constants indicate the number of MGT lanes that this particular backend
  -- implements. This allows the same CLIP design to be adaptable to a variety of
  -- back-ends. The MGT lanes will be grouped together in two signals, which will
  -- always be of the form:
  --
  -- signal MgtPortRx_p, MgtPortRx_n : std_logic_vector(kNumIoModRxMgtLanes-1 downto 0);
  constant kNumIoModRxMgtLanes : natural := 48;
  constant kNumIoModTxMgtLanes : natural := 48;
  constant kNumIoModRefClks : natural := 12;

  ---------------------------------------------------------------------------------------
  -- Polarity Control
  ---------------------------------------------------------------------------------------
  -- To simplify board layout, some of the MGT lanes and clocks have had their polarity
  -- inverted on the back-end. Three polarity control constants are provided: one for RX,
  -- one for TX, one for the Reference Clock vector. These constants indicate when a
  -- polarity inversion has occurred.
  --
  -- For every bit in these vectors, a '1' signifies that the
  -- corresponding MGT lane or Reference Clock is inverted, while a '0' means no
  -- inversion. This is the same convention used by Xilinx in the GTY primitives'
  -- RXPOLARITY and TXPOLARITY inputs, so the bits can be passed on to those primitives
  -- directly.
  --
  -- IO Module designers will likely find it convenient to also avail themselves of the
  -- possibility of inverting lanes on their IO Module designs, as it's preferable to
  -- invert the polarity of a lane than to compromise its signal integrity. The
  -- recommended way to do this is to create a new constant vector that follows the same
  -- convention as here. Then for each GTY primitive would receive the XOR of the
  -- corresponding bit in both vectors.
  -- TODO: These polarities need to be set once the layout is finalized
  constant kRxIoModRxMgtPolarity : std_logic_vector(kNumIoModRxMgtLanes-1 downto 0)  := b"0000_0000_0000_0000_0000_1111_0000_0000_0000_0000_0000_0000";
  constant kTxIoModTxMgtPolarity : std_logic_vector(kNumIoModTxMgtLanes-1 downto 0)  := b"0000_0000_0000_0000_1111_1111_0000_1111_0000_0000_0000_0000";
  constant kIoModRefClkPolarity  : std_logic_vector(kNumIoModRefClks-1 downto 0)     := "000000000000";



end package PkgFlexRioTargetConfig;
