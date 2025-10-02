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

library work;
  use work.PkgNiUtilities.all;

entity DFlopBoolVec is
  generic (kResetVal : BooleanVector);
  port (
    aReset, cEn  : in boolean;
    Clk : in std_logic;
    cD   : in BooleanVector(kResetVal'length-1 downto 0);
    cQ   : out BooleanVector(kResetVal'length-1 downto 0) := kResetVal
  );
end DFlopBoolVec;

architecture rtl of DFlopBoolVec is

  signal cQ_SLV: std_logic_vector(kResetVal'length-1 downto 0);

begin

  
  
  
  
  DFlopSLVx: entity work.DFlopSLV (rtl)
    generic map (
      kResetVal => To_StdLogicVector(kResetVal))  
    port map (
      aReset => aReset,                 
      cEn    => cEn,                    
      Clk    => Clk,                    
      cD     => To_StdLogicVector(cD),  
      cQ     => cQ_SLV);                

  cQ <= to_BooleanVector(cQ_SLV);

end rtl;




