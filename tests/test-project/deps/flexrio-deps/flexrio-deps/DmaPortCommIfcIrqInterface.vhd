-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcIrqInterface.vhd
-- Author: Matthew Koenn
-- Original Project: LvFpga Communication Interface
-- Date: 26 June 2008
--
-------------------------------------------------------------------------------
-- (c) 2008 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   This is the IRQ component that lives in the Pele communication
--   interface in the top level (external to TheWindow). It simply OR's the 
--   status bits from the virtual IRQs to set a single level interrupt line.
--   The Clear bit from the virtual IRQs is ignored, since we are only supporting
--   level interrupts.  The Clear is only needed when message based interrupts 
--   are used.
--
-------------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;
  use work.PkgCommIntConfiguration.all;
  
entity DmaPortCommIfcIrqInterface is
  generic (
    
    -- The number of IRQ ports used by DMA channels
    kNumDmaIrqPorts : natural := 0
  
  );
  port (
  
    aReset           : in boolean;
    
    -- This synchronously resets the entire component.
    bReset           : in boolean;
    
    BusClk           : in std_logic;
    
    IrqClk           : in std_logic;

    -- This is the actual interrupt line going to the Host.
    bIrq             : out std_logic;
    
    -- These are the signals from rvi_foo indicating the status of the IRQs.
    iLvFpgaIrq       : in IrqToInterfaceArray_t(Larger(kNumberOfIrqs,1)-1 downto 0);
    
    -- These are the IRQ signals from the fixed-logic DMA components
    bFixedLogicDmaIrq: in IrqStatusArray_t;

    -- These are the IRQ signals from the DMA components.
    bDmaIrq          : in IrqStatusArray_t(Larger(kNumDmaIrqPorts-1,0) downto 0)
    
  );
end DmaPortCommIfcIrqInterface;

architecture rtl of DmaPortCommIfcIrqInterface is

  signal bLvFpgaIrqSet, bDmaIrqSet : std_logic;
  signal iLvFpgaIrqSet : std_logic;

  --vhook_sigstart
  --vhook_sigend

begin
  
  -- This sets the reset signal going out of the device.  This is registered
  -- so that it is not glitchy.
  SetIrq: process(aReset, BusClk)
  begin
  
    if aReset then
    
      bIrq <= '0';
      
    elsif rising_edge(BusClk) then
      
      if bReset then
        bIrq <= '0';
      else
        -- Set the IRQ whenever a LvFpga IRQ is set or a DMA IRQ is set.
        bIrq <= bLvFpgaIrqSet or bDmaIrqSet;
      end if;
      
    end if;
  
  end process SetIrq;
  
  --vhook_e DoubleSyncSL
  --vhook_a IClk IrqClk
  --vhook_a iSig iLvFpgaIrqSet
  --vhook_a OClk BusClk
  --vhook_a oSig bLvFpgaIrqSet
  DoubleSyncSLx: entity work.DoubleSyncSL (behavior)
    port map (
      aReset => aReset,         -- in  boolean
      IClk   => IrqClk,         -- in  std_logic
      iSig   => iLvFpgaIrqSet,  -- in  std_logic
      OClk   => BusClk,         -- in  std_logic
      oSig   => bLvFpgaIrqSet); -- out std_logic
  
  -- Determine if there is a LV FPGA IRQ set.
  SetLvFpgaIrq: process(iLvFpgaIrq)
  begin
    iLvFpgaIrqSet <= '0';
    for VectorIndex in 0 to iLvFpgaIrq'length-1 loop
      for IrqIndex in 0 to iLvFpgaIrq(VectorIndex)'length -1 loop
        if iLvFpgaIrq(VectorIndex)(IrqIndex).Status = '1' then
          iLvFpgaIrqSet <= '1';
        end if;
      end loop; --IrqIndex
    end loop; --VectorIndex
  end process SetLvFpgaIrq;
  
  -- Determine if the client has set an IRQ. This simply OR's the status 
  -- field from all the DMA components (both the LV DMA channels and the 
  -- fixed-logic DMA channels).
  SetDmaIrq: process(bDmaIrq, bFixedLogicDmaIrq)
  begin
    bDmaIrqSet <= '0';
    for IrqIndex in 0 to bDmaIrq'length-1 loop
      if bDmaIrq(IrqIndex).Status = '1' then
        bDmaIrqSet <= '1';
      end if;
    end loop; --IrqIndex

    for i in bFixedLogicDmaIrq'range loop
      if bFixedLogicDmaIrq(i).Status = '1' then
        bDmaIrqSet <= '1';
      end if;
    end loop;

  end process SetDmaIrq;
   
  
end rtl;
