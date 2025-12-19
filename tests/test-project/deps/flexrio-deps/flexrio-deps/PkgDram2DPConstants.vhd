-------------------------------------------------------------------------------
--
-- File: PkgDram2DPConstants.vhd
-- Author: Neil Turley
-- Original Project: Dram2DP
-- Date: 31 Oct 2016
--
-------------------------------------------------------------------------------
-- (c) 2016 Copyright National Instruments.
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
-- PkgDram2DP has some constants for Dram2DP
--
-------------------------------------------------------------------------------
library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
library work;
  use work.PkgNiUtilities.all;
  use work.PkgNiDma.all;

package PkgDram2DPConstants is
  -- Start our core version with a magic number to make it more recognizable
  constant kCoreVersion : std_logic_vector(31 downto 0) := X"DEBB_B0FF";

  -- Defined by DmaPort Interface
  constant kReadCmd : std_logic_vector (2 downto 0) := B"001";
  constant kWriteCmd : std_logic_vector (2 downto 0) := B"000";

  -- 4 registers, 32 bits of data in a register, byte addressable
  -- 4*32/8 = 16
  constant kRegPortAddressesPerBuffer : integer := 16;

  -- The application is given 32 bits of addressibility
  constant kDramInterfaceAddressWidth : integer := 32;

  -- The DRAM interface in LabVIEW FPGA should default to 64-bits
  constant kDefaultDramInterfaceDataWidth : integer := 64;

  -- Type of the baggage to be passed to Dram2DP
  type NiD2DBaggageArr_t is array (integer range <>) of NiDmaBaggage_t;

end package PkgDram2DPConstants;