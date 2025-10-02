-- 
-- This file was automatically processed for release on GitHub
-- All comments were removed and this header was added
-- 
-- 
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
-- 
-- 





















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

    
    
    
    
    
    DFlopx: entity work.DFlop (rtl)
      generic map (
        kResetVal => kResetVal(i),  
        kAsyncReg => "false")       
      port map (
        aReset => aReset,  
        cEn    => cEn,     
        Clk    => Clk,     
        cD     => cD(i),   
        cQ     => cQ(i));  

  end generate;

end rtl;




