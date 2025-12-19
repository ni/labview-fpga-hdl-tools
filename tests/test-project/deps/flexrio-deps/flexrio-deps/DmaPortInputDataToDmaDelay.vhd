-------------------------------------------------------------------------------
--
-- File: DmaPortInputDataToDmaDelay.vhd
-- Author: Paul Butler
-- Original Project: LV FPGA Dma Port Communication Interface
-- Date: 16 Oct 2014
--
-------------------------------------------------------------------------------
-- (c) 2014 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
-- This simple component will delay the input by kDelay clock cycles. 
-- kDelay can have any natural value, including 0.
--

library IEEE;
  use IEEE.std_logic_1164.all;

library WORK;
  use WORK.PkgNiUtilities.all;

  use work.PkgNiDma.all;

  use work.PkgDmaPortCommunicationInterface.all;
  use work.PkgDmaPortCommIfcInputDataControl.all;
  use work.PkgCommIntConfiguration.all;

entity DmaPortInputDataToDmaDelay is
  generic (
    kDelay : natural := 0
          );
  port (
    Clk                             : in  std_logic;
    cNiDmaInputDataToDma            : in  NiDmaInputDataToDma_t;
    cNiDmaInputDataToDmaDelayed     : out NiDmaInputDataToDma_t
       );
end entity DmaPortInputDataToDmaDelay;

architecture RTL of DmaPortInputDataToDmaDelay is

  -- The index corresponds to the number of state delays applied to each 
  -- element of the array. Index 0 has not been delayed at all and index 
  -- kDelay has been delayed by exactly that many clock cycles.
  -- I declared the array using an increasing range because I think it 
  -- felt natural to me to shift from left to right. I could shift left 
  -- to right using a decreasing range, but then the index would not 
  -- correspond to the amount of delay.
  signal cDataShiftReg : NiDmaInputDataToDmaArray_t ( 0 to kDelay ) :=
         (others => kNiDmaInputDataToDmaZero);

begin

  cDataShiftReg ( 0 ) <= cNiDmaInputDataToDma;

  -- I intentionally omitted a reset because this shift register is only 
  -- used for data, not control signals. When the control logic is being 
  -- reset, the data is undefined and it remains undefined until the 
  -- control logic has shifted meaningful data through these registers. 
  -- For those reasons, we have no functional requirement to reset these 
  -- registers.
  --
  -- When the corresponding control logic enters the reset state, it 
  -- might conceivably cause the first register in this chain to become 
  -- metastable (we have a boundary from the control logic's reset 
  -- domain into a domain with no reset). However, none of the data in 
  -- this shift register has any meaning at that time and we cannot 
  -- transfer any data until well after the control logic exits the 
  -- reset state. For those reasons, I claim that metastability on these 
  -- registers is safe.
  --
  -- By not resetting registers unnecessarily, I preserve routing 
  -- resources and I simplify timing closure on the reset net in case we 
  -- elect to use a synchronous reset or a reset with an asynchronous 
  -- assertion, synchhronous deassertion.
  cDataShiftReg ( 1 to kDelay ) <= cDataShiftReg ( 0 to kDelay - 1 ) 
                                   when rising_edge ( Clk );

  cNiDmaInputDataToDmaDelayed <= cDataShiftReg ( kDelay );

end RTL;


