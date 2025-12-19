-------------------------------------------------------------------------------
--
-- File: DualPortRAM.vhd
-- Author: Craig Conway, Siddharth Sethi
-- Original Project: SMC5
-- Date: 7 July 2008
--
-------------------------------------------------------------------------------
-- (c) 2008 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--   Wrapper for Vivado inferred version of Dual Port RAM
--   Should implement a block RAM of the specified width/depth.
--
-- vreview_group rams
-- vreview_closed http://review-board.natinst.com/r/79823/
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity DualPortRAM is
  generic (
    kAddressWidth : integer := 8;
    kWidth : integer := 32;
    kRamReadLatency : integer := 2
  );
  port (
    IClk : in std_logic;
    iClkEn : in boolean := true;
    iWrite : in boolean;
    iAddr : in unsigned(kAddressWidth-1 downto 0);
    iDataIn : in std_logic_vector(kWidth-1 downto 0);

    OClk : in std_logic;
    oClkEn : in boolean := true;
    oReset : in boolean := false;
    oAddr : in unsigned(kAddressWidth-1 downto 0);
    oDataOut : out std_logic_vector(kWidth-1 downto 0)
  );
end DualPortRAM;

architecture rtl of DualPortRAM is

begin

  --vhook_e DualPortRAM_Vivado InferredRamx
  InferredRamx: entity work.DualPortRAM_Vivado (rtl)
    generic map (
      kAddressWidth   => kAddressWidth,    --integer:=8
      kWidth          => kWidth,           --integer:=32
      kRamReadLatency => kRamReadLatency)  --integer range 1:3 :=2
    port map (
      IClk     => IClk,      --in  std_logic
      iClkEn   => iClkEn,    --in  boolean
      iWrite   => iWrite,    --in  boolean
      iAddr    => iAddr,     --in  unsigned(kAddressWidth-1:0)
      iDataIn  => iDataIn,   --in  std_logic_vector(kWidth-1:0)
      OClk     => OClk,      --in  std_logic
      oReset   => oReset,    --in  boolean
      oClkEn   => oClkEn,    --in  boolean
      oAddr    => oAddr,     --in  unsigned(kAddressWidth-1:0)
      oDataOut => oDataOut); --out std_logic_vector(kWidth-1:0)

end rtl;
