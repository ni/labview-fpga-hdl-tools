-------------------------------------------------------------------------------
--
-- File: DualPortRAM_Vivado.vhd
-- Author: Craig Conway, Jeff Bergeron, Siddharth Sethi, Vikram Raj
-- Original Project: NiCores
-- Date: 16 February 2009
--
-------------------------------------------------------------------------------
-- (c) 2009 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--  This module provides code that synthesis tools can use to infer
-- block RAMs.  You specify the number of address bits and the width.  This
-- model should also simulate the block RAMs correctly.
--
-- This model is specifically meant for Vivado and has only been tested with
-- Vivado and 7 Series FPGAs. It may or may not work with other tools and targets.
--
--  kAddrWidth is the number of address bits.  2^kAddrWidth is the depth
-- of the RAM.
--
--  kWidth is the width of the input and output data buses.
--
--  kRamReadLatency specifies the delay in oClk cycles from when oRead
-- is asserted to when the data is valid.  A value of 2 is default.  This
-- causes the address and data to be registered twice internally in the RAM. 
-- Note that the internal address register is inferred from oDataOut0.
-- A value of 3 causes the address to be registered within the fabric.
--
--  Note that with a read latency of 1, you can end up with a clock crossing through
-- the RAM because you will have asynchronous access to memory contents. In many cases,
-- this is fine but a careful analysis of the circuit should be done to ensure it is.
--
--  This model infers WRITE_MODE_A=NO_CHANGE, WRITE_MODE_B=WRITE_FIRST, with port A
-- being the write side and port B being the read side.
--
--  See Xilinx UG901 for more info on the template.
--  http://www.xilinx.com/support/documentation/sw_manuals/xilinx2014_3/ug901-vivado-synthesis.pdf
--  Page 97, "Simple Dual-Port Block RAM with Dual Clocks VHDL Coding Example"
--
--  What has been tested in actual hardware:
--  * Vivado 2014.1 - Zynq
--
--  What has been specifically verified to synthesize a Block RAM:
--  * Vivado 2014.1 - Zynq, Artix7
--  * Vivado 2014.2 - Kintex7 325 fbg900
--       This was tested in three scenarios: dual clock connected directly to top level,
--       dual clock in FIFO, and single clock in FIFO. In all cases, this produced
--       a RAMB18E1 with WRITE_MODE_A=NO_CHANGE and WRITE_MODE_B=WRITE_FIRST
--  * Vivado 2014.3 - Kintex7 325 fbg900
--       Same scenario as above with 2014.2
--
--  What has not been verified:
--  * Any other synthesis tool
--  * Any other FPGA
--
--  What does not work:
--
--   * Nothing so far
--
--  If you try other synthesis tools, fpga vendors, or devices, please
-- let Craig Conway know so the above lists can be updated.
--
-- vreview_group rams
-- vreview_closed http://review-board.natinst.com/r/79838/
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library unisim;
  use unisim.vcomponents.all;

entity DualPortRAM_Vivado is
  generic (
    kAddressWidth : integer := 8;
    kWidth : integer := 32;
    kRamReadLatency : integer range 1 to 3 := 2
  );
  port (
    IClk : in std_logic;
    iClkEn : in boolean;
    iWrite : in boolean;
    iAddr : in unsigned(kAddressWidth-1 downto 0);
    iDataIn : in std_logic_vector(kWidth-1 downto 0);

    OClk : in std_logic;
    oReset : in boolean;
    oClkEn : in boolean;
    oAddr : in unsigned(kAddressWidth-1 downto 0);
    oDataOut : out std_logic_vector(kWidth-1 downto 0)
  );
end DualPortRAM_Vivado;

architecture rtl of DualPortRAM_Vivado is

  -- The Xilinx documentation recommends using a shared variable for many of the
  -- templates, but for the simple dual port, using a signal for iRAM synthesizes
  -- correctly (2014.1, 2014.2).
  type ram_type is array ((2**kAddressWidth)-1 downto 0)
                            of std_logic_vector (kWidth-1 downto 0);
  signal iRAM : ram_type := (others => (others => '0'));

  signal oDataOut0, oDataOut1 : std_logic_vector(kWidth-1 downto 0) := (others => '0');
  signal oXAddr, oDlyAddr : unsigned(kAddressWidth-1 downto 0) := (others => '0');

  -- Vivado/XST attribute
  attribute ram_style : string;
  attribute ram_style of iRAM : signal is "block";

begin

  -- For Vivado 2014.1 and earlier, a workaround was required for a data corruption issue. This
  -- workaround inserted a LUT1 in the data path (see CARs 459965, 469277, 461282). This issue
  -- has been verified as fixed in 2014.2 by Kristin Hampsten, so the LUT workaround is removed.

  -- This process writes the value on iDataIn into iRAM.
  -- Xilinx 7 Series: iClkEn and iWrite are separate inputs to the Block RAM.
  -- In Vivado 2014.1 and 2014.2, this synthesizes as a WRITE_FIRST BRAM.
  -- That may not be true in future versions and should be verified.
  -- This port is Write only so synthesizes as a simple dual port and makes
  -- more efficient use of the BRAMs.
  P1: process(IClk)
  begin
    if rising_edge(IClk) then
      if iClkEn then
        if iWrite then
          iRAM(To_Integer(iAddr)) <= iDataIn;
        end if;
      end if;
    end if;
  end process P1;

  -- This process delays the read address by one clock.  This is only used if we
  -- need to provide 3 cycle read latency.  The flip-flops will be inferred in the
  -- fabric and not as part of the BRAM.
  P2: process(OClk)
  begin
    if rising_edge(OClk) then
      if oClkEn then
        oDlyAddr <= oAddr;
      end if;
    end if;
  end process P2;

  -- oXAddr is the address actually used to select the Block ram contents on
  -- a read.  It is only used if we need read latency of 3.
  oXAddr <= oDlyAddr when kRamReadLatency=3 else
            oAddr;

  -- This process creates the RAM read circuitry.
  -- Xilinx 7 Series: oClkEn and oReset are separate inputs to the Block RAM.
  -- This port is Read only so synthesizes as a simple dual port and makes
  -- more efficient use of the BRAMs.
  P3: process(OClk)
  begin
    if rising_edge(OClk) then
      if oClkEn then
        oDataOut0 <= iRAM(To_Integer(oXAddr));
      end if;
    end if;
  end process P3;

  -- This process creates the optional Output Register (part of the 7 Series BRAM).
  -- Xilinx 7 Series: oClkEn and oReset are separate inputs to the Block RAM.
  P4: process(OClk)
  begin
    if rising_edge(OClk) then
      if oClkEn then
        if oReset then
          oDataOut1 <= (others => '0');
        else
          oDataOut1 <= oDataOut0;
        end if;
      end if;
    end if;
  end process P4;

  -- Select whether to use the Latch output or Register output based on ReadLatency
  oDataOut <= oDataOut0 when kRamReadLatency=1 else
              oDataOut1;

end rtl;
