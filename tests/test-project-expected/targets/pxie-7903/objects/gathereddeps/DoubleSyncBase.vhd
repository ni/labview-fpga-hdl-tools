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

entity DoubleSyncBase is
  generic (
    kResetVal : std_logic := '0'
  );
  port (
    aIReset: in  boolean;
    IClk:    in  std_logic;
    iClkEn:  in  boolean;
    iSigIn:  in  std_logic;
    iSigOut: out std_logic;

    aOReset: in  boolean;
    OClk:    in  std_logic;
    oClkEn:  in  boolean;
    oSig:    out std_logic
  );
end DoubleSyncBase;

architecture behavior of DoubleSyncBase is

  signal iDlySig : std_logic;

  
  
  attribute keep : string;
  attribute keep of iDlySig : signal is "true";

begin

  
  
  
  
  
  

  
  
  
  
  
  
  
  iDlySigx: entity work.DFlop (rtl)
    generic map (
      kResetVal => kResetVal,  
      kAsyncReg => "false")    
    port map (
      aReset => aIReset,  
      cEn    => iClkEn,   
      Clk    => IClk,     
      cD     => iSigIn,   
      cQ     => iDlySig); 

  iSigOut <= iDlySig;

  

  
  
  DoubleSyncAsyncInBasex: entity work.DoubleSyncAsyncInBase (rtl)
    generic map (kResetVal => kResetVal)  
    port map (
      aSig    => iDlySig,  
      aOReset => aOReset,  
      OClk    => OClk,     
      oClkEn  => oClkEn,   
      oSig    => oSig);    


end behavior;




