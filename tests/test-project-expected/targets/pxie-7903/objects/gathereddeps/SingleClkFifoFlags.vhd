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

library work;
  use work.PkgNiUtilities.all;

entity SingleClkFifoFlags is
  generic (
    kAddressWidth : positive;
    kWidth : positive;
    kRamReadLatency : natural;
    kFifoAdditiveLatency : natural range 0 to 1 := 1;
    kEnableErrorAssertions : boolean := true
  );
  port (
    aReset : in boolean;
    Clk : in std_logic;

    cReset : in boolean;

    
    cWrite,
    cRead,
    cClkEn : in boolean;

    cFullCount,
    cEmptyCount : out unsigned(kAddressWidth downto 0);

    cDataValid : out boolean;

    
    cMemWtAddr,
    cMemRdAddr : out unsigned(kAddressWidth-1 downto 0);

    aError : out boolean := false
  );

end SingleClkFifoFlags;

architecture rtl of SingleClkFifoFlags is

  constant kFullWidth : positive := kAddressWidth + 1;
  constant kFifoDepth : unsigned(kAddressWidth downto 0)
                             := To_Unsigned(2**kAddressWidth, kFullWidth);

  constant kResetVal : unsigned(kAddressWidth-1 downto 0) := (others => '0');
  constant kResetValC : unsigned(kAddressWidth downto 0) := (others => '0');

begin

  
  
  
  BlkAddr: block
    signal cNxWAddr, cWAddr, cNxRAddr, cRAddr : unsigned (kAddressWidth-1 downto 0);
  begin

    cNxWAddr <= (others => '0') when cReset else
                cWAddr + 1 when cWrite else
                cWAddr;

    
    
    
    
    cWAddrx: entity work.DFlopUnsigned (rtl)
      generic map (
        kResetVal => kResetVal)  
      port map (
        aReset => aReset,    
        cEn    => cClkEn,    
        Clk    => Clk,       
        cD     => cNxWAddr,  
        cQ     => cWAddr);   

    cNxRAddr <= (others => '0') when cReset else
                cRAddr + 1 when cRead else
                cRAddr;

    
    
    
    
    cRAddrx: entity work.DFlopUnsigned (rtl)
      generic map (
        kResetVal => kResetVal)  
      port map (
        aReset => aReset,    
        cEn    => cClkEn,    
        Clk    => Clk,       
        cD     => cNxRAddr,  
        cQ     => cRAddr);   

    
    cMemWtAddr <= cWAddr;
    cMemRdAddr <= cNxRAddr when kFifoAdditiveLatency=0 else cRAddr;

  end block BlkAddr;

  
  
  

  
  GenDataValidx: entity work.GenDataValid (rtl)
    generic map (
      kRamReadLatency      => kRamReadLatency,       
      kFifoAdditiveLatency => kFifoAdditiveLatency)  
    port map (
      aReset     => aReset,      
      Clk        => Clk,         
      cRead      => cRead,       
      cReset     => cReset,      
      cClkEn     => cClkEn,      
      cDataValid => cDataValid); 

  
  
  
  
  BlkFlags: block
    signal cNxFullCount, cLclFullCount,
           cNxEmptyCount, cLclEmptyCount : unsigned(kAddressWidth downto 0);
    signal cOverflow, cUnderflow, cDoWrite, cDlyRead, cRdForEmpty : boolean := false;

    
            
            
    
    
    
    
    
    
    
    constant kRamWriteLatency : natural := 2;
            
    
    
    
    signal cWriteArray : BooleanVector(1 to kRamWriteLatency);
  begin

    WriteArrayShiftRegister: process ( aReset, Clk ) is
    begin
      if aReset then
        cWriteArray <= (others => false);
      elsif rising_edge ( Clk ) then
        cWriteArray <= cWrite & cWriteArray ( 1 to kRamWriteLatency - 1 );
      end if;
    end process WriteArrayShiftRegister;

    
    
    cDoWrite <= cWriteArray(kRamWriteLatency);
    cNxFullCount <= (others => '0') when cReset else
                    cLclFullCount + 1 when cDoWrite and not cRead else
                    cLclFullCount - 1 when cRead and not cDoWrite else
                    cLclFullCount;

    
    
    
    
    
    cFullCountx: entity work.DFlopUnsigned (rtl)
      generic map (
        kResetVal => kResetValC)  
      port map (
        aReset => aReset,         
        cEn    => cClkEn,         
        Clk    => Clk,            
        cD     => cNxFullCount,   
        cQ     => cLclFullCount); 
    
    process (aReset, Clk)
    begin
      if aReset then
        cDlyRead <= false;
      elsif rising_edge(Clk) then
        cDlyRead <= cRead;
      end if;
    end process;

    cRdForEmpty <= cRead when kFifoAdditiveLatency=0 else cDlyRead;

    cNxEmptyCount <= kFifoDepth when cReset else
                     cLclEmptyCount - 1 when cWrite and not cRdForEmpty else
                     cLclEmptyCount + 1 when cRdForEmpty and not cWrite else
                     cLclEmptyCount;

    
    
    
    
    
    cEmptyCountx: entity work.DFlopUnsigned (rtl)
      generic map (
        kResetVal => kFifoDepth)  
      port map (
        aReset => aReset,          
        cEn    => cClkEn,          
        Clk    => Clk,             
        cD     => cNxEmptyCount,   
        cQ     => cLclEmptyCount); 

    cFullCount <= cLclFullCount;
    cEmptyCount <= cLclEmptyCount;

    
    process (aReset, Clk)
    begin
      if aReset then
        cOverflow <= false;
        cUnderflow <= false;
      elsif rising_edge(Clk) then
        cOverflow <= cWrite and cClkEn and cLclEmptyCount=0;
        cUnderflow <= cRead and cClkEn and cLclFullCount=0;
      end if;
    end process;

    assert not cUnderflow report "Underflow error" severity error;
    assert not cOverflow report "Overflow error" severity error;
    aError <= cUnderflow or cOverflow;
    

  end block BlkFlags;

end rtl;