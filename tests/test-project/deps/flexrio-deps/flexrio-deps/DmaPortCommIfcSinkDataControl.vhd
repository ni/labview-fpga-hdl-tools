-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcSinkDataControl.vhd
-- Author: Florin Hurgoi, Tamas Gyorfi
-- Original Project: LV FPGA Dma Port Communication Interface
-- Date: 15 June 2011
--
-------------------------------------------------------------------------------
-- (c) 2007 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   The NI DMA IP also implements a single Input Data interface for all the requesters
--   in the application logic. The NI DMA IP will always initiate the data transfer
--   as a response to the request sent by the communication interface. The communication
--   interface needs to be ready to transfer the associated data whenever
--   the NI DMA IP desires. The Sink Data Control introduce a data latency based on
--   the number of pipeline stages needed to multiplex Input Data interfaces coming
--   from Sink Stream circuits. The module generator will define the
--   kNiDmaInputDataReadLatency constant at compile time so that the NI DMA IP to know
--   what the read latency is.
--   The Sink Data Control component needs to introduce the same read data latency as 
--   Input Data Control component. The read latency is set by the 'kInputDataDelay' 
--   constant defined in PkgDmaPortCommIfcInputDataControl. Both the Sink Data Control
--   and Input Data Control components set the read latency based on this constant.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

  -- This package contains the definitions for the interface between the NI DMA IP and
  -- the application specific logic
  use work.PkgNiDma.all;
  use work.PkgNiDmaConfig.all;

  use work.PkgDmaPortCommunicationInterface.all;
  use work.PkgDmaPortCommIfcInputDataControl.all;
  use work.PkgCommIntConfiguration.all;

entity DmaPortCommIfcSinkDataControl is
  generic (
    -------------------------------------------------------------------------------------
    --The number of sink streams
    -------------------------------------------------------------------------------------
    kNumOfSinkStrms : natural := 16
  );

  port (
    aReset : in  boolean;
    BusClk : in  std_logic;

    -------------------------------------------------------------------------------------
    -- Input Data interface between the DMA controller and the Communication Interface
    -------------------------------------------------------------------------------------
    bNiDmaInputDataToDma : out NiDmaInputDataToDma_t;

    -- This signal indicates when data on the bNiDmaInputDataToDma is valid.
    -- This signal will be asserted irrespective of the DMA channel and it will be
    -- used in the DmaPortCommunicationInterface to further multiplex the data coming
    -- from this module.
    bNiDmaInputDataToDmaValid : out boolean;

    -------------------------------------------------------------------------------------
    -- The interface with the Sink Stream circuits
    -------------------------------------------------------------------------------------
    bInputDataFromSinkStreamArray : in
      NiDmaInputDataToDmaArray_t(Larger(kNumOfSinkStrms,1)-1 downto 0);

    -- This vector must be a one-hot or none-hot vector for the correct operations
    -- of the multiplexer.
    bInputDataFromSinkStreamValidArray : in
      BooleanVector(Larger(kNumOfSinkStrms,1)-1 downto 0)
    );
end DmaPortCommIfcSinkDataControl;


architecture rtl of DmaPortCommIfcSinkDataControl is
  
  signal bNiDmaInputDataToDmaLocArray : NiDmaInputDataToDmaArray_t(Larger(kNumOfSinkStrms,1)-1 downto 0) := (others => kNiDmaInputDataToDmaZero);
  
  signal bDataValidDelayedArray : BooleanVector(0 to kInputDataDelay);
  signal bNiDmaInputDataToDmaShiftReg : NiDmaInputDataToDmaArray_t ( 0 to kInputDataDelay ) := (others => kNiDmaInputDataToDmaZero);
  
  -- SelectData returns a copy of InputDataToDma where all but the
  -- selected channel is set to "zero". The multiplexor can be completed
  -- by simply "or"ing the array elements using the OrArray function. It
  -- is crucial for this function to return "zero" if no channel is
  -- selected.
  --
  -- For correct operations of the multiplexer, the Selector argument is 
  -- expected to be a one-hot vector or none-hot vector.
  function SelectData ( InputDataToDma : NiDmaInputDataToDmaArray_t;
                        Selector : BooleanVector(Larger(kNumOfSinkStrms,1)-1 downto 0) ) return
                        NiDmaInputDataToDmaArray_t is
    variable rval : NiDmaInputDataToDmaArray_t ( InputDataToDma'range ) :=
                    (others => kNiDmaInputDataToDmaZero);
  begin
    for i in rval'range loop
      if Selector ( i ) then
        rval ( i ) := InputDataToDma ( i );
      end if;
    end loop;

    return rval;
  end function SelectData;


begin

  bNiDmaInputDataToDmaLocArray <= SelectData(
    bInputDataFromSinkStreamArray,
    bInputDataFromSinkStreamValidArray);

  -- Computing the data valid array coming from the sink stream circuits.
  bDataValidDelayedArray(0) <= OrVector(bInputDataFromSinkStreamValidArray);
  bNiDmaInputDataToDmaShiftReg(0) <= OrArray(bNiDmaInputDataToDmaLocArray);
  
  DataValidDelay: process (aReset, BusClk) is
  begin
    if aReset then
      bDataValidDelayedArray(1 to kInputDataDelay) <= (others => false);
      bNiDmaInputDataToDmaShiftReg(1 to kInputDataDelay) <= (others => kNiDmaInputDataToDmaZero);
    elsif rising_edge(BusClk) then
      bDataValidDelayedArray(1 to kInputDataDelay) <= bDataValidDelayedArray(0 to kInputDataDelay - 1);
      bNiDmaInputDataToDmaShiftReg(1 to kInputDataDelay) <= bNiDmaInputDataToDmaShiftReg(0 to kInputDataDelay - 1);
    end if;
  end process;
  bNiDmaInputDataToDmaValid <= bDataValidDelayedArray(kInputDataDelay);
  bNiDmaInputDataToDma <= bNiDmaInputDataToDmaShiftReg(kInputDataDelay);
  
  --synthesis translate_off
  CheckForOneOrNoneHotVector: process(BusClk)
  begin
    if rising_edge(BusClk) then
      for i in 0 to bInputDataFromSinkStreamValidArray'length-1 loop
        if bInputDataFromSinkStreamValidArray(i) then
          for j in i+1 to bInputDataFromSinkStreamValidArray'length-1 loop
            assert not bInputDataFromSinkStreamValidArray(j)
              report "Sink streams #" & integer'image(i) & "and #" & integer'image(j) & " are both selected in Sink Data Control multiplexer."
              severity Error;
          end loop;
        end if;
      end loop;
    end if;
  end process CheckForOneOrNoneHotVector;
  --synthesis translate_on

end rtl;
