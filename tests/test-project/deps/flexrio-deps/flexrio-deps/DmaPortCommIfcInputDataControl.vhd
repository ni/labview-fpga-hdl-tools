-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcInputDataControl.vhd
-- Author: Paul Butler
-- Original Project: LV FPGA Dma Port Communication Interface
-- Date: 15 October 2014
--
-------------------------------------------------------------------------------
-- (c) 2014 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   The NI DMA IP also implements a single Input Data interface for all
--   the requesters in the application logic. The NI DMA IP will always
--   initiate the data transfer as a response to the request sent by the
--   communication interface.  The communication interface needs to be
--   ready to transfer the associated data whenever the NI DMA IP
--   desires. The Input Data Control needs to determine the number of
--   latency cycles between the Pop and valid Data based on the
--   kNiDmaDmaChannels constant and the read latency of DMA FIFO (two
--   clock cycles). The module generator will define the
--   kNiDmaInputDataReadLatency constant at compile time so that the NI
--   DMA IP to know what the read latency is. Pipeline stages could be
--   used for decoding and routing Pops to the various subsystems. The
--   FIFO read latency will be implemented using pipeline stages for
--   muxing data from the FIFO to the Input Data interface.  The sum of
--   all these states needs to match the read latency constant.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

  -- This package contains the definitions for the interface between the
  -- NI DMA IP and the application specific logic
  use work.PkgNiDma.all;

  use work.PkgDmaPortCommunicationInterface.all;
  use work.PkgDmaPortCommIfcInputDataControl.all;
  use work.PkgCommIntConfiguration.all;

entity DmaPortCommIfcInputDataControl is
  generic (

    ---------------------------------------------------------------------------
    --The number of input streams
    ---------------------------------------------------------------------------
    kNumOfInStrms : natural := 16;

    ---------------------------------------------------------------------------
    --The channel number to input stream number conversion
    ---------------------------------------------------------------------------
    kInStrmIndex  : StrmIndex_t);
  port (
    aReset              : in  boolean;
    BusClk              : in  std_logic;

    ---------------------------------------------------------------------------
    -- Input Data interface between NI DMA IP and the Commuication Interface
    ---------------------------------------------------------------------------
    bNiDmaInputDataFromDma   : in NiDmaInputDataFromDma_t;
    bNiDmaInputDataToDma     : out NiDmaInputDataToDma_t;

    ---------------------------------------------------------------------------
    -- The interface with the FIFOs
    ---------------------------------------------------------------------------
    bInputDataInterfaceFromFifoArray : in
      NiDmaInputDataToDmaArray_t(Larger(kNumOfInStrms,1)-1 downto 0);

    bInputDataInterfaceToFifoArray : out
      NiDmaInputDataFromDmaArray_t(Larger(kNumOfInStrms,1)-1 downto 0)
    );
end DmaPortCommIfcInputDataControl;

architecture rtl of DmaPortCommIfcInputDataControl is

  --vhook_sigstart
  --vhook_sigend
------------------------------------------------------------------------
-- Theory of operation:
--
--   This component implements a pipelined and-or mux. The "and" stage
--   (implemented by the SelectData function) will be implemented in a
--   single LUT level, so it should not contribute a timing closure
--   problem (The channel decode comes from a register in the DMA IP and
--   the data that's being selected should come from a register in the
--   FIFO). The second stage simply "or"'s all the first stage
--   elements together. We can implement a 32 input "or" gate in two LUT
--   levels (using 6-input LUT's). We can build a 64 input "or" in three
--   levels. I think the "or" logic is unlikely to become a timing
--   bottleneck, but we'll see after some testing.
--
--   This component will compile and behave correctly as long as
--   kInputDataDelay is at least 1. However, if the kInputDataDelay
--   is set to exactly 1, the output data will not be registered,
--   possibly leading to the accumulation of a critical path through
--   multiple entities.
--
------------------------------------------------------------------------

  -- kMaxNumOfStrms computes the maximum number of streams that will
  -- determine the total number of read data latency clocks that this
  -- component need to meet.  This constant is nedeed for matching the
  -- latency introduced by this component with the latency introduced by
  -- a similar component used to multiplex the sink streams.
  constant kMaxNumOfStrms : natural := kNumberOfDmaChannels;

  -- These types and the corresponding "*ShiftReg" signal are for
  -- delaying the bNiDmaInputDataFromDma.DmaChannel the same amount as
  -- the read latency inherent to the DMA FIFO.
  type DmaChannelOneHotArray_t is array ( natural range<> )
       of NiDmaDmaChannelOneHot_t;
  subtype DmaChannelOneHotShiftReg_t is DmaChannelOneHotArray_t
          ( kFifoReadLatency downto 1 );
  signal bChannelOneHotShiftReg : DmaChannelOneHotShiftReg_t
         := (others => (others => false));

  -- ChannelOrderedDataFromFifo accepts the NiDmaInputDataToDmaArray_t
  -- which is passed into DmaPortCommIfcInputDataControl. That array has
  -- all of the input channels arranged into the lowest indice of the
  -- array -- their indices do not match their channel numbers. Since
  -- the DMA IP provides DmaChannelOneHotArray_t arranged where the
  -- array index corresponds to the channel number, we need to
  -- reconstruct an NiDmaInputDataToDmaArray_t that is organize the same
  -- way. The generic kInStrmIndex translates indices into channel
  -- numbers, so this function uses that constant to construct a new
  -- NiDmaInputDataToDmaArray_t return value in which the indices match
  -- the channel number. That simplifies the construction of the and/or
  -- mux.
  -- Since kInStrmIndex is a constant, this function should be
  -- implemented with no logic -- it's simply a constant rearrangement
  -- of the input array. On the other hand, the returned array will be
  -- larger than the input array. The returned array will always match
  -- the size of the DmaChannelOneHotArray_t, which is a fixed size that
  -- matches the number of DMA channels implemented by the DMA IP. Many
  -- of the entries in the returned array will be constant, so the
  -- synthesizer should perform substantial optimization.
  function ChannelOrderedDataFromFifo ( val : NiDmaInputDataToDmaArray_t )
           return NiDmaInputDataToDmaArray_t is
    variable rval : NiDmaInputDataToDmaArray_t ( NiDmaDmaChannelOneHot_t'range )
                  := (others => kNiDmaInputDataToDmaZero);
    variable StrmCount : natural;
  begin

    -- rval has an entry for every DMA channel, even if that channel is
    -- unused or is allocated to an output channel. kInStrmIndex is a
    -- list of the channel numbers that are actually used for input DMA.
    -- rval is initialized to contain all "zero". For each of the
    -- mappings in kInStrmIndex, copy the indexed value from val into
    -- the channel numbered index in rval.
    --
    -- val will have an entry for each utilized DMA channel, which will
    -- often cause val to be shorter than rval or kInStrmIndex. For that
    -- reason, the loop only iterates over the values in the shortest
    -- array to avoid using an out-of-range index for the "val(i)"
    -- expression. The default value of rval will ensure that any unused
    -- channels have a "zero" value.
    --
    -- This function could be simplified by removing the "if" logic.
    -- That would put non-zero data in the unused slots, but that data
    -- would never be selected by the DMA Port. I've elected to add the
    -- extra complexity (the if-statement) to keep the unused and output
    -- channels zeroed. This will give the synthesizer a better chance
    -- to optimize around channels that are stuck at zero. Since the
    -- if-statement only examines a constant, I don't expect this logic
    -- to consume resources or interfere with timing closure.
    for i in rval'range loop
      if    kDmaFifoConfArray(i).Mode = NiFpgaTargetToHost
         or kDmaFifoConfArray(i).Mode = NiFpgaPeerToPeerWriter then
        rval ( i ) := val ( kInStrmIndex ( i ) );
      end if;
    end loop;

    return rval;
  end function ChannelOrderedDataFromFifo;

  signal bChannelOrderedData : NiDmaInputDataToDmaArray_t ( NiDmaDmaChannelOneHot_t'range );

  -- SelectData returns a copy of InputDataToDma where all but the
  -- selected channel is set to "zero". The multiplexor can be completed
  -- by simply "or"ing the array elements using the OrArray function. It
  -- is crucial for this function to return "zero" if no channel is
  -- selected.
  --
  -- This function accepts the one-hot channel field so that the
  -- returned data will be all "zero" if the Dma IP is responding to the
  -- same channel in non-stream space. An alternative would be to decode
  -- the channel field and the space field.
  --
  -- It's important to note that this function assumes that
  -- InputDataToDma is organized according to the channel number. The
  -- entity input "bInputDataInterfaceFromFifoArray" is the correct data
  -- type, but it is a contiguously arranged list of input data so that
  -- it can easily be associated with the arbiter's request/grant/done
  -- arrays. Passing that input directly to SelectData will often
  -- produce undesirable results. My expectation is that InputDataToDma
  -- will be formatted by the ChannelOrderedDataFromFifo function.
  function SelectData ( InputDataToDma : NiDmaInputDataToDmaArray_t;
                        Channel : NiDmaDmaChannelOneHot_t ) return
                        NiDmaInputDataToDmaArray_t is
    variable rval : NiDmaInputDataToDmaArray_t ( InputDataToDma'range ) :=
                    (others => kNiDmaInputDataToDmaZero);
  begin

    -- Since Channel'length may be larger than rval'length, we only
    -- iterate over rval'range to avoid an out-of-bounds index.
    for i in rval'range loop
      if Channel ( i ) then
        rval ( i ) := InputDataToDma ( i );
      end if;
    end loop;

    return rval;
  end function SelectData;

  --vhook_nowarn bSelectedInputDataToDmaArray
  signal bSelectedInputDataToDmaArray :
         NiDmaInputDataToDmaArray_t ( NiDmaDmaChannelOneHot_t'range ) :=
         (others => kNiDmaInputDataToDmaZero);

  --vhook_nowarn aReset
  -- I have intentionally removed the reset signal from this component
  -- because there is no functional requirement to reset the registers
  -- in this component. In the case where the DMA IP is entering a reset
  -- state, the registers in this component that hold old values of
  -- outputs from the DMA IP become meaningless -- the DMA IP will
  -- "forget" any previous requests to transfer data, so all the control
  -- signals (like bNiDmaInputDataFromDma.DmaChannel) may select data
  -- from one of the input DMA channels, but when that data arrives at
  -- the input to the DMA IP, it will be ignored. In other words,
  -- because the DMA IP is designed to expect a precise delay through
  -- this component, when the DMA IP enters the reset state we can be
  -- certain that it will ignore any output values from this component
  -- until enough time has passed for these registers to be reloaded
  -- with valid values.
  --
  -- There is a risk that some of these registers can enter a metastable
  -- state if the registers driving the inputs are reset asynchronously.
  -- Because we know that all the outputs of this component will be
  -- ignored until well after reset has deasserted (as described in the
  -- previous paragraph), the metastability here can not cause other
  -- components to enter an undefined state.
  --
begin

  assert kInputDataDelay > 0
    report "This architecture adds at least one stage of delay on the data path"
    severity failure;

  -- The DmaPort communication interface has been tested for 16
  -- (InchWorm) and 32 (Chinch2) DMA channels. Currently there are no
  -- targets that support more than 32 channels - if that changes in the
  -- future, this c0mponent needs further testing.
--  assert kNumberOfDmaChannels<=32
--    report "DmaPortCommIfcInputDataControl: this c0mponent was tested "
--         & "with up to 32 channels only - configuring it with more than "
--         & "32 channels requires validation."
--    severity Error;

  -- This delays the channel selector field to correspond to the FIFO
  -- read latency. The output of this delay provides a channel selection
  -- field that is appropriate for multiplexing the data arriving from
  -- the FIFO.
  OneHotChannelShifter:
  Process ( BusClk ) is
  begin
    if rising_edge ( BusClk ) then
      bChannelOneHotShiftReg <=
         bChannelOneHotShiftReg ( kFifoReadLatency - 1 downto 1 )
       & bNiDmaInputDataFromDma.DmaChannel;
    end if;
  end Process OneHotChannelShifter;

  -- The SelectRegister process "and"s the incoming data with the
  -- one-hot channel decode to select at most one valid input data.
  -- This one-hot enable signal can be none-hot if the DMA IP is reading
  -- data from a non-stream space. This property ensures that the mux
  -- output is "zero" when no channel is selected.
  bChannelOrderedData <=
    ChannelOrderedDataFromFifo ( bInputDataInterfaceFromFifoArray );
  SelectRegister:
  Process ( BusClk ) is
  begin
    if rising_edge ( BusClk ) then
      bSelectedInputDataToDmaArray <= SelectData (
        bChannelOrderedData,
        bChannelOneHotShiftReg ( kFifoReadLatency ));
    end if;
  end process SelectRegister;

  -- DmaPortInputDataToDmaDelayx is configured to delay the data one
  -- state less than kInputDataDelay because the first delay state is
  -- implemented by the SelectRegister process.
  --
  -- This delays the data to match the expectations of the DMA IP. A
  -- larger delay also provides more placement flexibility in case the
  -- data needs to travel across a large portion of the die (it has
  -- multiple clock cycles to get to its destination).

  --vhook_e DmaPortInputDataToDmaDelay
  --vhook_a kDelay kInputDataDelay-1
  --vhook_a Clk BusClk
  --vhook_c cNiDmaInputDataToDma OrArray ( bSelectedInputDataToDmaArray )
  --vhook_c cNiDmaInputDataToDmaDelayed bNiDmaInputDataToDma
  DmaPortInputDataToDmaDelayx: entity work.DmaPortInputDataToDmaDelay (RTL)
    generic map (kDelay => kInputDataDelay-1)  --natural:=0
    port map (
      Clk                         => BusClk,                                    --in  std_logic
      cNiDmaInputDataToDma        => OrArray ( bSelectedInputDataToDmaArray ),  --in  NiDmaInputDataToDma_t
      cNiDmaInputDataToDmaDelayed => bNiDmaInputDataToDma);                     --out NiDmaInputDataToDma_t

  -- We copy bNiDmaInputDataFromDma to every DMA stream circuit. This
  -- introduces a risk of too much fanout on this signal, but Vivado
  -- does try hard to replicate overloaded registers.
  bInputDataInterfaceToFifoArray <= (others => bNiDmaInputDataFromDma );

end rtl;
