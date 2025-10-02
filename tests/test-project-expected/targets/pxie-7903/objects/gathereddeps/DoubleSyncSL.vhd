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

entity DoubleSyncSL is
  port (
    aReset: in  boolean;

    IClk:   in  std_logic;
    iSig:   in  std_logic;

    OClk:   in  std_logic;
    oSig:   out std_logic
  );
end DoubleSyncSL;

architecture behavior of DoubleSyncSL is

begin

  
  
  
  
  
  
  
  DoubleSyncBasex: entity work.DoubleSyncBase (behavior)
    generic map (
      kResetVal => '0')  
    port map (
      aIReset => aReset,  
      IClk    => IClk,    
      iClkEn  => true,    
      iSigIn  => iSig,    
      iSigOut => open,    
      aOReset => aReset,  
      OClk    => OClk,    
      oClkEn  => true,    
      oSig    => oSig);   

end behavior;