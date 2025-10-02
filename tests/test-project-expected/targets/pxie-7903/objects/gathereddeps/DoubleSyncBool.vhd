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

entity DoubleSyncBool is
  port (
    aReset: in  boolean;

    IClk:   in  std_logic;
    iSig:   in  boolean;

    OClk:   in  std_logic;
    oSig:   out boolean
  );
end DoubleSyncBool;

architecture behavior of DoubleSyncBool is

  signal iSigIn, oSigSL : std_logic;

begin

  
  iSigIn <= '1' when iSig else '0';

  
  
  
  
  
  
  
  DoubleSyncBasex: entity work.DoubleSyncBase (behavior)
    generic map (
      kResetVal => '0')  
    port map (
      aIReset => aReset,  
      IClk    => IClk,    
      iClkEn  => true,    
      iSigIn  => iSigIn,  
      iSigOut => open,    
      aOReset => aReset,  
      OClk    => OClk,    
      oClkEn  => true,    
      oSig    => oSigSL); 

  
  oSig <= oSigSL='1';

end behavior;