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

library work;
  use work.PkgNiUtilities.all;

library UNISIM;
  use UNISIM.vcomponents.all;

entity DFlop is

  generic (kResetVal : std_logic := '0';
           kAsyncReg : string := "false");
  port (
    aReset, cEn  : in boolean;
    Clk, cD   : in std_logic;
    cQ   : out std_logic := kResetVal
  );
end DFlop;

architecture rtl of DFlop is
  attribute ASYNC_REG : string;
begin

  
  
  GenVScanModel: if false generate
    process (aReset, Clk)
    begin
      if aReset then
        cQ <= '0';
      elsif rising_edge(Clk) then
        if cEn then cQ <= cD; end if;
      end if;
    end process;
  end generate GenVScanModel;

  

  
  
  

  GenClr: if kResetVal='0' generate
    attribute ASYNC_REG of ClearFDCPEx : label is kAsyncReg;
    begin
    

    
    
    
    
    
    
    
    
    
    
    ClearFDCPEx: FDCE
      generic map (
        INIT            => '0',  
        IS_CLR_INVERTED => '0',  
        IS_C_INVERTED   => '0',  
        IS_D_INVERTED   => '0')  
      port map (
        Q   => cQ,                   
        C   => Clk,                  
        CE  => To_StdLogic(cEn),     
        CLR => To_StdLogic(aReset),  
        D   => cD);                  

  end generate GenClr;

  GenSet: if kResetVal='1' generate
    attribute ASYNC_REG of PresetFDCPEx : label is kAsyncReg;
    begin
    

    
    
    
    
    
    
    
    
    
    
    
    PresetFDCPEx: FDPE
      generic map (
        INIT            => '1',  
        IS_C_INVERTED   => '0',  
        IS_D_INVERTED   => '0',  
        IS_PRE_INVERTED => '0')  
      port map (
        Q   => cQ,                   
        C   => Clk,                  
        CE  => To_StdLogic(cEn),     
        D   => cD,                   
        PRE => To_StdLogic(aReset)); 

  end generate GenSet;

  

end rtl;