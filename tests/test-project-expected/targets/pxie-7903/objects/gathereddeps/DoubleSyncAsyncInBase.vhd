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

entity DoubleSyncAsyncInBase is
  generic (
    kResetVal : std_logic := '0'
  );
  port (
    aSig:    in  std_logic;     

    aOReset: in  boolean;     
    OClk:    in  std_logic;
    oClkEn:  in  boolean := true;
    oSig:    out std_logic := kResetVal
  );
end DoubleSyncAsyncInBase;

architecture rtl of DoubleSyncAsyncInBase is

  signal oSig_ms : std_logic := kResetVal;  

begin
 
  
  
  

  
  
  
  
  
  
  
  oSig_msx: entity work.DFlop (rtl)
    generic map (
      kResetVal => kResetVal,  
      kAsyncReg => "true")     
    port map (
      aReset => aOReset,  
      cEn    => oClkEn,   
      Clk    => OClk,     
      cD     => aSig,     
      cQ     => oSig_ms); 

  
  
  
  
  
  
  
  oSigx: entity work.DFlop (rtl)
    generic map (
      kResetVal => kResetVal,  
      kAsyncReg => "true")     
    port map (
      aReset => aOReset,  
      cEn    => oClkEn,   
      Clk    => OClk,     
      cD     => oSig_ms,  
      cQ     => oSig);    

end rtl;




