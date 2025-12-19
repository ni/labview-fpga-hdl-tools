-------------------------------------------------------------------------------
--
-- File: DFlopSLV.vhd
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
--    Instantiates an array flip-flops with a "hard" syn_hier attribute so
-- that the enable logic won't get merged with the D logic.
--    This file does not synthesize under XST in ISE 10.1 or earlier
-- because of a bug where XST does not support using the 'length attribute
-- of a generic.  You can use DFlopSlvResetVal for XST instead.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

entity DFlopSLV is
  generic (kResetVal : std_logic_vector;
           kAsyncReg : string := "false");
  port (
    aReset, cEn  : in boolean;
    Clk : in std_logic;
    cD   : in std_logic_vector(kResetVal'length-1 downto 0);
    cQ   : out std_logic_vector(kResetVal'length-1 downto 0) := kResetVal
  );
end DFlopSLV;

architecture rtl of DFlopSLV is

  constant kRstVec : std_logic_vector(kResetVal'length-1 downto 0) := kResetVal;

begin

  GenFlops: for i in 0 to kResetVal'length-1 generate

    --vhook_e DFlop
    --vhook_a kResetVal kRstVec(i)
    --vhook_a cD cD(i)
    --vhook_a cQ cQ(i)
    DFlopx: entity work.DFlop (rtl)
      generic map (
        kResetVal => kRstVec(i),
        kAsyncReg => kAsyncReg)
      port map (
        aReset => aReset,
        cEn    => cEn,
        Clk    => Clk,
        cD     => cD(i),
        cQ     => cQ(i));

  end generate;

end rtl;

-- The following comment is a checksum VScan uses to determine whether this
-- file has been modified.  Please don't try to get around it.  It's there
-- for a reason.
--VScan_CS 5302020
