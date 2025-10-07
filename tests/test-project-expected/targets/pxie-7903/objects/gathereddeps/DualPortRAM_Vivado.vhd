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
  use ieee.numeric_std.all;

library unisim;
  use unisim.vcomponents.all;

entity DualPortRAM_Vivado is
  generic (
    kAddressWidth : integer := 8;
    kWidth : integer := 32;
    kRamReadLatency : integer range 1 to 3 := 2
  );
  port (
    IClk : in std_logic;
    iClkEn : in boolean;
    iWrite : in boolean;
    iAddr : in unsigned(kAddressWidth-1 downto 0);
    iDataIn : in std_logic_vector(kWidth-1 downto 0);

    OClk : in std_logic;
    oReset : in boolean;
    oClkEn : in boolean;
    oAddr : in unsigned(kAddressWidth-1 downto 0);
    oDataOut : out std_logic_vector(kWidth-1 downto 0)
  );
end DualPortRAM_Vivado;

architecture rtl of DualPortRAM_Vivado is

  
  
  
  type ram_type is array ((2**kAddressWidth)-1 downto 0)
                            of std_logic_vector (kWidth-1 downto 0);
  signal iRAM : ram_type := (others => (others => '0'));

  signal oDataOut0, oDataOut1 : std_logic_vector(kWidth-1 downto 0) := (others => '0');
  signal oXAddr, oDlyAddr : unsigned(kAddressWidth-1 downto 0) := (others => '0');

  
  attribute ram_style : string;
  attribute ram_style of iRAM : signal is "block";

begin

  
  
  

  
  
  
  
  
  
  P1: process(IClk)
  begin
    if rising_edge(IClk) then
      if iClkEn then
        if iWrite then
          iRAM(To_Integer(iAddr)) <= iDataIn;
        end if;
      end if;
    end if;
  end process P1;

  
  
  
  P2: process(OClk)
  begin
    if rising_edge(OClk) then
      if oClkEn then
        oDlyAddr <= oAddr;
      end if;
    end if;
  end process P2;

  
  
  oXAddr <= oDlyAddr when kRamReadLatency=3 else
            oAddr;

  
  
  
  
  P3: process(OClk)
  begin
    if rising_edge(OClk) then
      if oClkEn then
        oDataOut0 <= iRAM(To_Integer(oXAddr));
      end if;
    end if;
  end process P3;

  
  
  P4: process(OClk)
  begin
    if rising_edge(OClk) then
      if oClkEn then
        if oReset then
          oDataOut1 <= (others => '0');
        else
          oDataOut1 <= oDataOut0;
        end if;
      end if;
    end if;
  end process P4;

  
  oDataOut <= oDataOut0 when kRamReadLatency=1 else
              oDataOut1;

end rtl;