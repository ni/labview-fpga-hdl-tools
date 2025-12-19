-------------------------------------------------------------------------------
--
-- File: PkgChinchConfig.vhd
-- Author: Glen Sescila
-- Original Project: Sheltie
-- Date: 24 February 2007
--
-------------------------------------------------------------------------------
-- (c) 2005 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
-- This package configures the core logic for the x1 PIPE FPGA version of the
-- Chinch.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgChinch.all;

package PkgChinchConfig is

  -- The kTargetType constant is used to control technology-specific code.
  -- RAM instantiation is the primary client of this constant.  Note that the
  -- kTargetType constant should be set to the appropriate target value for
  -- both simulation and synthesis.  The Simulation value is only used during
  -- early simulation before a target technology has been selected.  Legal
  -- values: Simulation, Virtex, Virtex2, Spartan3, Stratix, Stratix2

  constant kTargetType : Target_t := Oki;
  constant kUseInferredMemory : boolean := false;



  -- The values in this record are used to optimize the Chinch core at
  -- synthesis time.

  constant kChinchConfig : ChinchCoreConfig_t := (
    TwoClocks => false,           -- Setting this variable to true
                                  -- configures the core to use independant
                                  -- clocks for the host bus and IO port
                                  -- logic.  Setting the variable to false
                                  -- causes the entire core to operate
                                  -- within a single clock domain.

    DMA_TYPE => 16#50#,           -- The type of Traditional DMA
                                  -- implemented.  legal values: 0

    DMA_ChannelsLog2 => 4,        -- Log2 of number of DMA channels.  Note
                                  -- that this also controls the number of
                                  -- streams supported.  legal values: 0-15

    LINKSZ_Log2 =>  9,            -- Log2 of the maximum DMA link size
                                  -- supported.  legal values: 5-15

    IncludeInputDma => true,      -- Set this to true if you want Input DMA
                                  -- to work.

    IncludeOutputDma => true,     -- Set this to true if you want Output
                                  -- DMA to work.

    IncludeTtccr => true,         -- Set this to true if you want the DMA
                                  -- Total Transfer Count Compare interrupt
                                  -- to work.

    IncludeTimer => true,         -- Set this to true if you want the
                                  -- Elapsed Time Register and its
                                  -- associated interrupt to work.

    IncludeIntStatPush => true,   -- Set this to true if you want Interrupt
                                  -- Status Pushing to work.

    IncludeMCU => true,           -- Set this to true to include the 8051
                                  -- microcontroller in the ChinchCore.

    RandomAccess => false,        -- the core logic implements the random
                                  -- access functionality when this
                                  -- variable is true.

    IO_MPS => 512,                -- IO maximum payload size.  This is the
                                  -- maximum size of data payload
                                  -- supported.  legal values: powers of
                                  -- two in the range 32-16384

    HB_MPS => 512,                -- HB maximum payload size.  This is the
                                  -- maximum size of data payload
                                  -- supported.  legal values: powers of
                                  -- two in the range 32-16384

    IO_MSIT => 4,                 -- IO maximum simultaneous transactions
                                  -- legal values: 2-4095

    HB_MSIT => 16,                -- host bus maximum simultaneous
                                  -- transactions.  legal values: 2-4095

    IORXBE_MP => 8,               -- maximum packets in IORXBE FIFO
                                      -- legal values: 1-1024
    IORXBE_MW =>  256,            -- maximum words in IORXBE FIFO
                                      -- legal values: 1-131072

    IOTXBE_MP => 8,               -- maximum packets in IOTXBE FIFO
                                      -- legal values: 1-1024
    IOTXBE_MW => 256,             -- maximum words in IOTXBE FIFO
                                      -- legal values: 1-131072

    HBRXBE_MP => 8,               -- maximum packets in HBRXBE FIFO
                                      -- legal values: 1-1024
    HBRXBE_MW => 256,             -- maximum words in HBRXBE FIFO
                                      -- legal values: 1-131072

    HBTXBE_MP => 8,               -- maximum packets in HBTXBE FIFO
                                      -- legal values: 1-1024
    HBTXBE_MW => 256,             -- maximum words in HBTXBE FIFO
                                      -- legal values: 1-131072

    IO_RegProgEndian => false,    -- when true enables programmable
                                  -- Endianess when accessing CHINCH
                                  -- registers from IO Port 2.

    IO_RegBigEndian => false,     -- when programmable Endianess is not
                                  -- enabled this controls IO Port 2's view
                                  -- of the CHINCH registers.  when
                                  -- programmable Endianess is enabled this
                                  -- is used as the default setting.

    HB_RegProgEndian => false,    -- when true enables programmable
                                  -- Endianess when accessing CHINCH
                                  -- registers from the host bus.

    HB_RegBigEndian => false,     -- when programmable Endianess is not
                                  -- enabled this controls the host bus
                                  -- view of the CHINCH registers.  when
                                  -- programmable Endianess is enabled this
                                  -- is used as the default setting.

    IO_BaggageWidth => 1,         -- IO baggage width in number of bits

    HB_BaggageWidth => 23,        -- HB baggage width in number of bits

    IO_Windows => 2,              -- number of IO Port windows

    CP_Windows => 4,              -- number of Configuration Port windows.
                                  -- this also controls the number of chip
                                  -- select outputs implemented on the    
                                  -- Configuration Port.

    ProgRomAddressWidth => 12,        -- Set the size of the 8051 program ram.
                                      -- A value of 12 means 4K bytes

    OnChipRamAddressWidth => 7,       -- Set the size of the 8051 internal data
                                      -- memory. The IP we use only use 7 bit address
                                      -- bus, so there's no need to have this number
                                      -- larger than 7.

    OffChipRamAddressWidth => 12,     -- Set the size of the 8051 external data
                                      -- memory.  A value of 12 means 4K bytes 

    NumGpios => 13                -- number of external GPIO pins to
                                  -- implement.  legal values: 1-32
                                --
  );



  -- This controls the amount of address space used for each Traditional DMA
  -- channel.  The amount of space is 2 to the kDMA_SPACE_Log2 power bytes.

  constant kDMA_SPACE_Log2 : natural :=
    ChinchGetDMA_SPACE_Log2(kChinchConfig.DMA_TYPE);



  -- This controls the base offset for the Traditional DMA register group.
  -- This must be set to a boundary of the total space required by this
  -- group.  The total space required by the group is the number of DMA
  -- channels times the space required by each channel.

  constant kDMA_BASE : unsigned(31 downto 0) :=
    ChinchGetDMA_BASE(kDMA_SPACE_Log2, kChinchConfig.DMA_ChannelsLog2);



  -- This controls the number of states to wait after the unassertion of the
  -- asynchronous reset signal before allowing state machines to start.
  -- This provides a general solution to the state machine start up problem.

  constant kResetWaitStates : natural := 13;

  -- This specifies the number of SysClock states required to time 10ms.  It is
  -- used for the split completion timers.

  constant kSplitTimeStates : natural := 1250000;

end PkgChinchConfig;

package body PkgChinchConfig is
end PkgChinchConfig;
