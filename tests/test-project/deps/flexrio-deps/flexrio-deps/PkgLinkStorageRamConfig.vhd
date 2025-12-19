-------------------------------------------------------------------------------
--
-- File: PkgLinkStorageRamConfig.vhd
-- Author: Rolando Ortega
-- Original Project: NI Cores NiDmaIp
-- Date: 15 May 2019
--
-------------------------------------------------------------------------------
-- (c) 2019 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
-- This package provides PkgLinkStorageRam with the constants it needs to size itself
-- correctly. The reason it exists is because LVFPGA can (and does) have incorrect values
-- in PkgNiDmaConfig for kNiDmaMaxChunkyLinkSize. Because we can't rely on PkgNiDmaConfig,
-- we need to replicate some of its values (at this time, only kNiDmaMaxChunkyLinkSize) to
-- somewhere else that isn't owned by LVFPGA.
--
-- All of the currently available PCIe Inchworms use a value of kNiDmaMaxChunkyLinkSize of
-- 2048. Therefore, we can share this package amongst all of them, and export it directly
-- to our clients. If a new PCIe Inchworm is designed whose kNiDmaMaxChunkyLinkSize is
-- something different, it'll become necessary to branch this package and hard-code the
-- right value into it.
--
-----------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package PkgLinkStorageRamConfig is

  -- Chunky link size comes directly from PkgNiDmaConfig, but must be hard-coded correctly
  -- for LVFPGA targets.
  constant kChunkyLinkSize : natural := 2048;

end package PkgLinkStorageRamConfig;
