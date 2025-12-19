-------------------------------------------------------------------------------
--
-- File: DFlopUnsigned.vhd
-- Author: Craig Conway
-- Original Project: SMC4
-- Date: 28 November 2006
--
-------------------------------------------------------------------------------
-- (c) 2006 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--    Instantiates an array of DFlop components.  These components
-- have a "hard" syn_hier attribute so that the enable logic won't
-- get merged with the D logic.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity DFlopUnsigned is
  generic (kResetVal : unsigned);
  port (
    aReset, cEn  : in boolean;
    Clk : in std_logic;
    cD   : in unsigned(kResetVal'length-1 downto 0);
    cQ   : out unsigned(kResetVal'length-1 downto 0) := kResetVal
  );
end DFlopUnsigned;

architecture rtl of DFlopUnsigned is

begin

  GenFlops: for i in 0 to kResetVal'length-1 generate

    --vhook_e DFlop
    --vhook_a kResetVal kResetVal(i)
    --vhook_a kAsyncReg "false"
    --vhook_a cD cD(i)
    --vhook_a cQ cQ(i)
    DFlopx: entity work.DFlop (rtl)
      generic map (
        kResetVal => kResetVal(i),  --std_logic:='0'
        kAsyncReg => "false")       --string:="false"
      port map (
        aReset => aReset,  --in  boolean
        cEn    => cEn,     --in  boolean
        Clk    => Clk,     --in  std_logic
        cD     => cD(i),   --in  std_logic
        cQ     => cQ(i));  --out std_logic:=kResetVal

  end generate;

end rtl;

-- The following comment is a checksum VScan uses to determine whether this
-- file has been modified.  Please don't try to get around it.  It's there
-- for a reason.
--VScan_CS 4791120
