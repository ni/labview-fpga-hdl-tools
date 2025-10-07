-- 
-- This file was automatically processed for release on GitHub
-- All comments were removed and this header was added
-- 
-- 
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- All rights reserved.
-- 
-- 























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




