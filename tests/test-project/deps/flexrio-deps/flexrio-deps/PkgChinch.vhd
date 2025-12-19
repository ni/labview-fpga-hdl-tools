-------------------------------------------------------------------------------
--
-- File: PkgChinch.vhd
-- Author: Glen Sescila
-- Original Project: PCIExpress DFC
-- Date: 5 May 2008
--
-------------------------------------------------------------------------------
-- (c) 2003 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
-- This package provides types, functions, and constants used throughout the
-- Chinch source code.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package PkgChinch is

  -- The PkgChinchConfig package should provide a constant named kTargetType
  -- of the type Target_t.  The value of this constant is used to control
  -- technology-specific code.  RAM instantiation is the primary client of
  -- this constant.  Note that the kTargetType constant should be set to the
  -- appropriate target value for both simulation and synthesis.  The
  -- Simulation value is only used during early simulation before a target
  -- technology has been selected.

  type Target_t is (Simulation, Virtex2, Virtex4, Spartan3, Stratix, Stratix2,
                    Oki);



  -- The PkgChinchConfig package should provide a constant named
  -- kChinchConfig of the type ChinchCoreConfig_t.  The values in this record
  -- are used to optimize the Chinch core at synthesis time.

  type ChinchCoreConfig_t is record
    TwoClocks : boolean;          -- Setting this variable to true
                                  -- configures the core to use independant
                                  -- clocks for the host bus and IO port
                                  -- logic.  Setting the variable to false
                                  -- causes the entire core to operate
                                  -- within a single clock domain.

    DMA_TYPE : natural;           -- The type of Traditional DMA
                                  -- implemented.  legal values: 0

    DMA_ChannelsLog2 : natural;   -- Log2 of number of DMA channels.  Note
                                  -- that this also controls the number of
                                  -- streams supported.  legal values: 0-15

    LINKSZ_Log2 : natural;        -- Log2 of the maximum DMA link size
                                  -- supported.  legal values: 5-15

    IncludeInputDma : boolean;    -- Set this to true if you want Input DMA
                                  -- to work.

    IncludeOutputDma : boolean;   -- Set this to true if you want Output
                                  -- DMA to work.

    IncludeTtccr : boolean;       -- Set this to true if you want the DMA
                                  -- Total Transfer Count Compare interrupt
                                  -- to work.

    IncludeTimer : boolean;       -- Set this to true if you want the
                                  -- Elapsed Time Register and its
                                  -- associated interrupt to work.

    IncludeIntStatPush : boolean; -- Set this to true if you want Interrupt
                                  -- Status Pushing to work.

    IncludeMCU : boolean;         -- Set this to true to include the 8051
                                  -- microcontroller in the ChinchCore.

    ProgRomAddressWidth : natural;    -- Set the size of the 8051 program ram.
                                      -- A value of 12 means 4K bytes

    OnChipRamAddressWidth : natural;  -- Set the size of the 8051 internal data
                                      -- memory. The IP we use only use 7 bit address
                                      -- bus, so there's no need to have this number
                                      -- larger than 7.

    OffChipRamAddressWidth : natural; -- Set the size of the 8051 external data
                                      -- memory.  A value of 12 means 4K bytes

    RandomAccess : boolean;       -- the core logic implements the random
                                  -- access functionality when this
                                  -- variable is true.

    IO_MPS : natural;             -- IO maximum payload size.  This is the
                                  -- maximum size of data payload
                                  -- supported.  legal values: powers of
                                  -- two in the range 32-4096

    HB_MPS : natural;             -- HB maximum payload size.  This is the
                                  -- maximum size of data payload
                                  -- supported.  legal values: powers of
                                  -- two in the range 32-4096

    IO_MSIT : natural;            -- IO maximum simultaneous transactions
                                  -- legal values: 2-4095

    HB_MSIT : natural;            -- host bus maximum simultaneous
                                  -- transactions.  legal values: 2-4095

    IORXBE_MP : natural;          -- maximum packets in IORXBE FIFO
                                      -- legal values: 1-1024
    IORXBE_MW : natural;          -- maximum words in IORXBE FIFO
                                      -- legal values: 1-131072

    IOTXBE_MP : natural;          -- maximum packets in IOTXBE FIFO
                                      -- legal values: 1-1024
    IOTXBE_MW : natural;          -- maximum words in IOTXBE FIFO
                                      -- legal values: 1-131072

    HBRXBE_MP : natural;          -- maximum packets in HBRXBE FIFO
                                      -- legal values: 1-1024
    HBRXBE_MW : natural;          -- maximum words in HBRXBE FIFO
                                      -- legal values: 1-131072

    HBTXBE_MP : natural;          -- maximum packets in HBTXBE FIFO
                                      -- legal values: 1-1024
    HBTXBE_MW : natural;          -- maximum words in HBTXBE FIFO
                                      -- legal values: 1-131072

    IO_RegProgEndian : boolean;   -- when true enables programmable
                                  -- Endianess when accessing CHINCH
                                  -- registers from IO Port 2.

    IO_RegBigEndian : boolean;    -- when programmable Endianess is not
                                  -- enabled this controls IO Port 2's view
                                  -- of the CHINCH registers.  when
                                  -- programmable Endianess is enabled this
                                  -- is used as the default setting.

    HB_RegProgEndian : boolean;   -- when true enables programmable
                                  -- Endianess when accessing CHINCH
                                  -- registers from the host bus.

    HB_RegBigEndian : boolean;    -- when programmable Endianess is not
                                  -- enabled this controls the host bus
                                  -- view of the CHINCH registers.  when
                                  -- programmable Endianess is enabled this
                                  -- is used as the default setting.

    IO_BaggageWidth : natural;    -- IO baggage width in number of bits

    HB_BaggageWidth : natural;    -- HB baggage width in number of bits

    IO_Windows : natural;         -- number of IO Port windows

    CP_Windows : natural;         -- number of Configuration Port windows.
                                  -- this also controls the number of chip
                                  -- select outputs implemented on the
                                  -- Configuration Port.

    NumGpios : natural;           -- number of external GPIO pins to
                                  -- implement.  legal values: 1-32
  end record;



  -- Each Bus Interface Module provides a signal to the Chinch core of the
  -- type BIM_Config_t.  This record controls certain behaviors of the core.
  -- Each field of this record could be a constant or an active signal unless
  -- otherwise restricted in the field's comment.  When a field is driven by
  -- the BIM with a constant value the core may be optimized at synthesis
  -- time.

  type BIM_Config_t is record
    HBR_SIZE_Log2 : unsigned(4 downto 0);   -- defines the size of the BIM
                                  -- register region in local address
                                  -- space.  The size is 2 to the
                                  -- HBR_SIZE_Log2 power bytes.  Each BIM
                                  -- must drive this with a constant.  This
                                  -- is unused on the IO side of the core.

    HBR_BASE : unsigned(31 downto 0);   -- defines the base offset of the
                                  -- BIM registers in local address space.
                                  -- This must be on a boundary of the size
                                  -- indicated by HBR_SIZE_Log2.  Each BIM
                                  -- must drive this with a constant.  This
                                  -- is unused on the IO side of the core.

    TypeIdentification : std_logic_vector(31 downto 0);   -- this provides
                                  -- the value for the xxTIDR register.

    SingleResponse : boolean;

    MaxResponseSizeLog2 : unsigned(3 downto 0);

    MaxReadSizeLog2 : unsigned(3 downto 0);

    MaxWriteSizeLog2 : unsigned(3 downto 0);

    MaxTransacts : unsigned(11 downto 0);

    ReadReqAddressBoundaryLog2 : unsigned(3 downto 0);

    WriteReqAddressBoundaryLog2 : unsigned(3 downto 0);
  end record;



  -- The ChinchCore outputs a signal of the type ChinchCoreStatus_t.  This
  -- record reports various states, error events, and programmed operating
  -- modes.

  type ChinchCoreStatus_t is record

    PoscStatus : std_logic_vector(1 downto 0); -- The state of the POSC logic.

    InterruptViaMessages : boolean;  -- When this mode bit is true a Host Bus
                                     -- BIM should use ChinchCore transmitted
                                     -- Message packets to notify the host.
                                     -- When this bit is false the
                                     -- sHB_Interrupt output should be used
                                     -- instead.

    InterruptTrafficClass : std_logic_vector(5 downto 0);

    UnsolicitedCompletionPulse : boolean;  -- This asserts for a single state
                                           -- to report reception of an
                                           -- unsolicited completion.

    CompletionTimeOutPulse : boolean;  -- This asserts for a single state to
                                       -- report that we timed out waiting to
                                       -- receive a completion from the host
                                       -- bus.

    OutstandingTransactions : boolean;  -- This signal remains true while the
                                        -- ChinchCore is waiting to receive
                                        -- completions for at least one
                                        -- initiated transaction that was split
                                        -- by the host BIM.

    ApplicationSepecificMode : std_logic_vector(7 downto 0);

    DebugSelect : std_logic_vector(2 downto 0);
    DebugInfo : std_logic_vector(7 downto 0);
  end record;



  -- these types are used for the Chinch internal packet format.

  subtype ChinchPacketWord_t is std_logic_vector(63 downto 0);

  subtype ChinchPacketType_t is std_logic_vector(2 downto 0);

  subtype ChinchPacketSpc_t is std_logic_vector(1 downto 0);

  subtype ChinchPacketLabel_t is unsigned(11 downto 0);

  subtype ChinchPacketLength_t is unsigned(14 downto 0);

  subtype ChinchPacketAddress_t is unsigned(31 downto 0);

  subtype ChinchPacketCompletionStatus_t is std_logic_vector(1 downto 0);

  subtype ChinchPacketRemainingCount_t is unsigned(14 downto 0);

  subtype ChinchPacketUpperAddress_t is unsigned(31 downto 0);

  subtype ChinchPacketStream_t is unsigned(15 downto 0);



  -- these codes are used for the Chinch Packet Type field

  constant kChinchPacketTypeRequestSplitRead   : ChinchPacketType_t := "001";

  constant kChinchPacketTypeResponseWrite      : ChinchPacketType_t := "010";

  constant kChinchPacketTypeRequestPostedWrite : ChinchPacketType_t := "100";

  constant kChinchPacketTypeRequestSplitWrite  : ChinchPacketType_t := "101";

  constant kChinchPacketTypeResponseRead       : ChinchPacketType_t := "110";



  -- these codes are used for the Chinch Packet Spc field

  constant kChinchPacketSpcExtHeader : ChinchPacketSpc_t := "00";

  constant kChinchPacketSpcMemory    : ChinchPacketSpc_t := "01";

  constant kChinchPacketSpcMessage   : ChinchPacketSpc_t := "10";

  constant kChinchPacketSpcStream    : ChinchPacketSpc_t := "11";



  -- these codes are used for the Chinch Packet Completion Status field

  constant kChinchPacketComplStatUnused  : ChinchPacketCompletionStatus_t
                                                                 := "00";

  constant kChinchPacketComplStatSuccess : ChinchPacketCompletionStatus_t
                                                                 := "00";

  constant kChinchPacketComplStatFailure : ChinchPacketCompletionStatus_t
                                                                 := "01";

  constant kChinchPacketComplStatTermCnt : ChinchPacketCompletionStatus_t
                                                                 := "10";

  constant kChinchPacketComplStatDisconn : ChinchPacketCompletionStatus_t
                                                                 := "11";



  -- these constants are convenient when the fields aren't used

  constant kChinchPacketRemainingCountUnused : ChinchPacketRemainingCount_t
                                                        := (others => '0');

  constant kChinchPacketStreamUnused : ChinchPacketStream_t
                                                        := (others => '0');



  -- these codes are used for the destination bus on the receive interface

  constant kChinchDestinationLocal       : std_logic_vector := "00";

  constant kChinchDestinationBusSpecific : std_logic_vector := "01";

  constant kChinchDestinationIdentROM    : std_logic_vector := "10";

  constant kChinchDestinationFar         : std_logic_vector := "11";



  -- these codes are used for the data size field of the register interface

  constant kChinchDataSize64bit : std_logic_vector := "11";

  constant kChinchDataSize32bit : std_logic_vector := "10";

  constant kChinchDataSize16bit : std_logic_vector := "01";

  constant kChinchDataSize08bit : std_logic_vector := "00";



  -- This supplies the value for the CHINCH Identification Register (CHID)

  constant kCHID : std_logic_vector(31 downto 0) := X"C0107AD0";

  -- This supplies the value for the CHINCH Version Register (CHVERS)

  constant kChinchBuildCode : std_logic_vector(31 downto 0) := X"08050513";

  -- This supplies the value for the Register Map Version Register (RMVR)

  constant kRMV : std_logic_vector(31 downto 0) := X"00000002";



  -- used for the window registers

  subtype WindowSize_t is unsigned(4 downto 0);

  type WindowSizeArray_t is array(integer range<>) of WindowSize_t;

  type WindowBaseArray_t is array(integer range<>) of ChinchPacketAddress_t;



  -- basic utility function declarations

  function Pow2(Num : integer) return integer;

  function Pow2(Num : unsigned) return unsigned;

  function HowManyOnes(Vec : std_logic_vector) return natural;

  function AddressInWindow(WindowEnable : std_logic;
                           WindowSize : unsigned(4 downto 0);
                           WindowBase : unsigned(31 downto 0);
                           Address : unsigned(31 downto 0)) return boolean;

  function CropAddress(WindowSize : unsigned(4 downto 0);
                       Address : unsigned) return unsigned;

  function GetDecodeBits(WindowSize : unsigned(4 downto 0)) return unsigned;

  function PageAddress(WindowSize : unsigned(4 downto 0);
                       WindowPage : unsigned(31 downto 0);
                       Address : unsigned(31 downto 0)) return unsigned;

  function CalcSizeLimitFromAddress(Address : unsigned(15 downto 0);
                                    AddressBoundaryLog2 : unsigned(3 downto 0);
                                    ProgSizeLimit : unsigned(15 downto 0))
      return unsigned;

  function CalcCompletionLimit(Address : unsigned(15 downto 0);
                               ProgSizeLimit : unsigned(3 downto 0))
      return unsigned;



  -- these functions compute the Traditional DMA register map based on the
  -- DMA type and number of channels.

  function ChinchGetDMA_SPACE_Log2(DMA_Type : natural) return natural;

  function ChinchGetDMA_BASE(SpacePerLog2 : natural; NumChansLog2 : natural)
    return unsigned;



  -- these functions are used to parse and construct Chinch internal packets.

  function ChinchPacketGetType(Header : ChinchPacketWord_t)
    return ChinchPacketType_t;

  function ChinchPacketGetSpc(Header : ChinchPacketWord_t)
    return ChinchPacketSpc_t;

  function ChinchPacketGetLabel(Header : ChinchPacketWord_t)
    return ChinchPacketLabel_t;

  function ChinchPacketGetLength(Header : ChinchPacketWord_t)
    return ChinchPacketLength_t;

  function ChinchPacketGetAddress(Header : ChinchPacketWord_t)
    return ChinchPacketAddress_t;

  function ChinchPacketGetCompletionStatus(Header : ChinchPacketWord_t)
    return ChinchPacketCompletionStatus_t;

  function ChinchPacketGetRemainingCount(Header : ChinchPacketWord_t)
    return ChinchPacketRemainingCount_t;

  function ChinchPacketGetUpperAddress(Header : ChinchPacketWord_t)
    return ChinchPacketUpperAddress_t;

  function ChinchPacketGetStream(Header : ChinchPacketWord_t)
    return ChinchPacketStream_t;

  function ChinchPacketBuildHeader(
                   PktType : ChinchPacketType_t;
                   Spc : ChinchPacketSpc_t;
                   PktLabel : ChinchPacketLabel_t;
                   PktLength : ChinchPacketLength_t;
                   Address : ChinchPacketAddress_t;
                   CompletionStatus : ChinchPacketCompletionStatus_t;
                   RemainingCount : ChinchPacketRemainingCount_t;
                   Stream : ChinchPacketStream_t;
                   EndOfRecordFlag : boolean := false;
                   DoneFlag : boolean := false
                                  ) return ChinchPacketWord_t;

  function ChinchPacketBuildExtendedHeader(
                   Spc : ChinchPacketSpc_t;
                   UpperAddress : ChinchPacketUpperAddress_t
                                  ) return ChinchPacketWord_t;

  function ChinchPacketPayloadWords(PktLength : ChinchPacketLength_t;
                                    Address : unsigned;
                                    Width : natural) return unsigned;

  function ChinchPacketMaxPayloadWords(PayloadSize : natural) return natural;



  -- these functions can be used to test conditions of Chinch internal
  -- packets.

  function ChinchPacketRequest(PktType : ChinchPacketType_t) return boolean;

  function ChinchPacketResponse(PktType : ChinchPacketType_t) return boolean;

  function ChinchPacketHeaderExtended(Spc : ChinchPacketSpc_t
                                     ) return boolean;
  function ChinchPacketHasPayload(Header : ChinchPacketWord_t)
    return boolean;

  function ChinchPacketIncludesPayload(PktType : ChinchPacketType_t;
                                       PktLength : ChinchPacketLength_t
                                      ) return boolean;

  function ChinchPacketRequiresResponse(PktType : ChinchPacketType_t)
                                                           return boolean;

  function ChinchPacketReqWrite(PktType : ChinchPacketType_t)
                                                           return boolean;

  function ChinchPacketReqRead(PktType : ChinchPacketType_t)
                                                           return boolean;

  function ChinchPacketResWrite(PktType : ChinchPacketType_t)
                                                           return boolean;

  function ChinchPacketResRead(PktType : ChinchPacketType_t)
                                                           return boolean;

  function ChinchPacketEndOfRecord(Header : ChinchPacketWord_t)
                                                           return boolean;

  function ChinchPacketDoneFlag(Header : ChinchPacketWord_t)
                                                           return boolean;

end PkgChinch;

package body PkgChinch is

  -- raises 2 to the power passed to the function.
  function Pow2(Num : integer) return integer is
    variable temp, pow : integer;
  begin
    temp := Num;
    pow := 1;
    while (temp /= 0) loop
      temp := temp - 1;
      pow := pow * 2;
    end loop;
    return pow;
  end Pow2;



  -- a synthesizable power of 2 function
  function Pow2(Num : unsigned) return unsigned is
    variable ReturnVal : unsigned(Pow2(Num'length) - 1 downto 0);
  begin
    for i in ReturnVal'range loop
      if i = to_integer(Num) then
        ReturnVal(i) := '1';
      else
        ReturnVal(i) := '0';
      end if;
    end loop;
    return ReturnVal;
  end Pow2;



  -- Says how many 1's are in a std_logic_vector.
  function HowManyOnes(Vec : std_logic_vector) return natural is
    variable ReturnVal : natural := 0;
  begin
    for i in Vec'range loop
      if Vec(i) = '1' then
        ReturnVal := ReturnVal + 1;
      end if;
    end loop;
    return ReturnVal;
  end HowManyOnes;



  -- address window decoder
  function AddressInWindow(WindowEnable : std_logic;
                           WindowSize : unsigned(4 downto 0);
                           WindowBase : unsigned(31 downto 0);
                           Address : unsigned(31 downto 0)) return boolean is
    variable SizeMask, ModAddress, ModWindowBase : unsigned(31 downto 3);
  begin
    for i in 31 downto 3 loop
      if i >= to_integer(WindowSize) then
        SizeMask(i) := '1';
      else
        SizeMask(i) := '0';
      end if;
    end loop;
    ModAddress := Address(31 downto 3) and SizeMask;
    ModWindowBase := WindowBase(31 downto 3) and SizeMask;
    return (WindowEnable = '1' and
            ModAddress = ModWindowBase);
  end AddressInWindow;



  function CropAddress(WindowSize : unsigned(4 downto 0);
                       Address : unsigned) return unsigned is
    variable SizeMask, ReturnVal : unsigned(Address'range);
  begin
    for i in SizeMask'range loop
      if i >= to_integer(WindowSize) then
        SizeMask(i) := '0';
      else
        SizeMask(i) := '1';
      end if;
    end loop;
    ReturnVal := Address and SizeMask;
    return ReturnVal;
  end CropAddress;



  function GetDecodeBits(WindowSize : unsigned(4 downto 0))
                                           return unsigned is
    variable SizeMask : unsigned(31 downto 0);
  begin
    for i in 31 downto 0 loop
      if i >= to_integer(WindowSize) then
        SizeMask(i) := '1';
      else
        SizeMask(i) := '0';
      end if;
    end loop;
    return SizeMask;
  end GetDecodeBits;



  function PageAddress(WindowSize : unsigned(4 downto 0);
                       WindowPage : unsigned(31 downto 0);
                       Address : unsigned(31 downto 0)) return unsigned is
    variable ReturnVal : unsigned(Address'range);
  begin
    for i in Address'range loop
      if (i > 7) and (i >= to_integer(WindowSize)) then
        ReturnVal(i) := WindowPage(i);
      else
        ReturnVal(i) := Address(i);
      end if;
    end loop;
    return ReturnVal;
  end PageAddress;



  function CalcSizeLimitFromAddress(Address : unsigned(15 downto 0);
                                    AddressBoundaryLog2 : unsigned(3 downto 0);
                                    ProgSizeLimit : unsigned(15 downto 0))
           return unsigned is
    variable CroppedAddress : unsigned(15 downto 0);
    variable ProgLimit, BoundLimit, ReturnVal : unsigned(15 downto 0);
  begin
    -- Although the Max_Payload_Size field on PCI Express is defined to limit
    -- the number of bytes transferred in a payload what it really means is you
    -- shouldn't transfer more than Max_Payload_Size / 4 Dwords in a packet.
    -- With an unaligned address the CHInCh could generate a packet with one
    -- too many Dwords even though the number of transferred bytes matched
    -- Max_Payload_Size.  The calculation below ensures we limit ourselves to
    -- Max_Payload_Size / 4 Dwords.
    ProgLimit := ProgSizeLimit - resize(Address(1 downto 0), ProgLimit'length);
    -- This calculates the maximum transfer size based on the starting address
    -- and the allowable address boundary.  By cropping the address the result
    -- of the subtraction is guaranteed to be positive and accurate.
    CroppedAddress := CropAddress(resize(AddressBoundaryLog2, 5), Address);
    BoundLimit := Pow2(AddressBoundaryLog2) - CroppedAddress;
    if ProgLimit < BoundLimit then
      ReturnVal := ProgLimit;
    else
      ReturnVal := BoundLimit;
    end if;
    return ReturnVal;
  end CalcSizeLimitFromAddress;



  function CalcCompletionLimit(Address : unsigned(15 downto 0);
                               ProgSizeLimit : unsigned(3 downto 0))
      return unsigned is
    variable CroppedAddress, ReturnVal : unsigned(15 downto 0);
  begin
    CroppedAddress := CropAddress(resize(ProgSizeLimit, 5), Address);
    ReturnVal := Pow2(ProgSizeLimit) - CroppedAddress;
    return ReturnVal;
  end CalcCompletionLimit;



  -- computes the address space required by each Traditional DMA channel
  -- based on the type of DMA implemented.
  function ChinchGetDMA_SPACE_Log2(DMA_Type : natural) return natural is
  begin
    return 8;
  end ChinchGetDMA_SPACE_Log2;



  -- computes the base offset of the Traditional DMA register group based on
  -- the space required by each channel and the number of channels.
  function ChinchGetDMA_BASE(SpacePerLog2 : natural; NumChansLog2 : natural)
    return unsigned is
    variable ReturnVal : unsigned(31 downto 0);
  begin
    ReturnVal := X"00002000";
    return ReturnVal;
  end ChinchGetDMA_BASE;



  -- Chinch Packet: extracts the Type field from the header
  function ChinchPacketGetType(Header : ChinchPacketWord_t)
    return ChinchPacketType_t is
    variable ReturnVal : ChinchPacketType_t;
  begin
    ReturnVal := Header(2 downto 0);
    return ReturnVal;
  end ChinchPacketGetType;



  -- Chinch Packet: extracts the Spc field from the header
  function ChinchPacketGetSpc(Header : ChinchPacketWord_t)
    return ChinchPacketSpc_t is
    variable ReturnVal : ChinchPacketSpc_t;
  begin
    ReturnVal := Header(4 downto 3);
    return ReturnVal;
  end ChinchPacketGetSpc;



  -- Chinch Packet: extracts the Label field from the header
  function ChinchPacketGetLabel(Header : ChinchPacketWord_t)
    return ChinchPacketLabel_t is
    variable ReturnVal : ChinchPacketLabel_t;
  begin
    ReturnVal := unsigned(Header(16 downto 5));
    return ReturnVal;
  end ChinchPacketGetLabel;



  -- Chinch Packet: extracts the Length field from the header
  function ChinchPacketGetLength(Header : ChinchPacketWord_t)
    return ChinchPacketLength_t is
    variable ReturnVal : ChinchPacketLength_t;
  begin
    ReturnVal := unsigned(Header(31 downto 17));
    return ReturnVal;
  end ChinchPacketGetLength;



  -- Chinch Packet: extracts the Address field from the header
  function ChinchPacketGetAddress(Header : ChinchPacketWord_t)
    return ChinchPacketAddress_t is
    variable ReturnVal : ChinchPacketAddress_t;
  begin
    ReturnVal := unsigned(Header(63 downto 32));
    return ReturnVal;
  end ChinchPacketGetAddress;



  -- Chinch Packet: extracts the Completion Status field from the header
  function ChinchPacketGetCompletionStatus(Header : ChinchPacketWord_t)
    return ChinchPacketCompletionStatus_t is
    variable ReturnVal : ChinchPacketCompletionStatus_t;
  begin
    ReturnVal := Header(63 downto 62);
    return ReturnVal;
  end ChinchPacketGetCompletionStatus;



  -- Chinch Packet: extracts the Remaining Count field from the header
  function ChinchPacketGetRemainingCount(Header : ChinchPacketWord_t)
    return ChinchPacketRemainingCount_t is
    variable ReturnVal : ChinchPacketRemainingCount_t;
  begin
    ReturnVal := unsigned(Header(58 downto 44));
    return ReturnVal;
  end ChinchPacketGetRemainingCount;



  -- Chinch Packet: extracts the Upper Address field from the extended header
  function ChinchPacketGetUpperAddress(Header : ChinchPacketWord_t)
    return ChinchPacketUpperAddress_t is
    variable ReturnVal : ChinchPacketUpperAddress_t;
  begin
    ReturnVal := unsigned(Header(63 downto 32));
    return ReturnVal;
  end ChinchPacketGetUpperAddress;



  -- Chinch Packet: extracts the Stream field from the header
  function ChinchPacketGetStream(Header : ChinchPacketWord_t)
    return ChinchPacketStream_t is
    variable ReturnVal : ChinchPacketStream_t;
  begin
    ReturnVal := unsigned(Header(59 downto 44));
    return ReturnVal;
  end ChinchPacketGetStream;



  -- Chinch Packet: build the header
  function ChinchPacketBuildHeader(
                   PktType : ChinchPacketType_t;
                   Spc : ChinchPacketSpc_t;
                   PktLabel : ChinchPacketLabel_t;
                   PktLength : ChinchPacketLength_t;
                   Address : ChinchPacketAddress_t;
                   CompletionStatus : ChinchPacketCompletionStatus_t;
                   RemainingCount : ChinchPacketRemainingCount_t;
                   Stream : ChinchPacketStream_t;
                   EndOfRecordFlag : boolean := false;
                   DoneFlag : boolean := false
                                  ) return ChinchPacketWord_t is
    variable ReturnVal : ChinchPacketWord_t;
  begin
    ReturnVal := (others => '0');
    ReturnVal(2 downto 0) := PktType;
    ReturnVal(4 downto 3) := Spc;
    ReturnVal(16 downto 5) := std_logic_vector(PktLabel);
    ReturnVal(31 downto 17) := std_logic_vector(PktLength);
    if ChinchPacketRequest(PktType) then
      if Spc = kChinchPacketSpcStream then
        ReturnVal(41 downto 32) :=
                          std_logic_vector(Address(9 downto 0));
        if DoneFlag then
          ReturnVal(42) := '1';   -- Done Flag
        else
          ReturnVal(42) := '0';
        end if;
        if EndOfRecordFlag then
          ReturnVal(43) := '1';   -- End Of Record
        else
          ReturnVal(43) := '0';
        end if;
        ReturnVal(59 downto 44) := std_logic_vector(Stream);
        ReturnVal(63 downto 60) :=
                          std_logic_vector(Address(31 downto 28));
      else
        ReturnVal(63 downto 32) := std_logic_vector(Address);
      end if;
    else
      if Spc = kChinchPacketSpcStream then
        ReturnVal(43 downto 32) :=
                          std_logic_vector(Address(11 downto 0));
        ReturnVal(59 downto 44) := std_logic_vector(Stream);
        ReturnVal(63 downto 62) := CompletionStatus;
      else
        ReturnVal(43 downto 32) :=
                          std_logic_vector(Address(11 downto 0));
        ReturnVal(58 downto 44) := std_logic_vector(RemainingCount);
        ReturnVal(63 downto 62) := CompletionStatus;
      end if;
    end if;
    return ReturnVal;
  end ChinchPacketBuildHeader;



  -- Chinch Packet: build the extended header
  function ChinchPacketBuildExtendedHeader(
                   Spc : ChinchPacketSpc_t;
                   UpperAddress : ChinchPacketUpperAddress_t
                                          ) return ChinchPacketWord_t is
    variable ReturnVal : ChinchPacketWord_t;
  begin
    ReturnVal := (others => '0');
    ReturnVal(4 downto 3) := Spc;
    ReturnVal(63 downto 32) := std_logic_vector(UpperAddress);
    return ReturnVal;
  end ChinchPacketBuildExtendedHeader;



  -- compute the number of words in the data payload.  This function does not
  -- return an accurate result for packets with a length of 0.  Packet
  -- processing typically must take special action for length of 0 packets
  -- anyway and this function is simplified by not supporting such packets.
  function ChinchPacketPayloadWords(PktLength : ChinchPacketLength_t;
                                    Address : unsigned;
                                    Width : natural) return unsigned is
    variable ReturnVal : unsigned(Width - 1 downto 0);
  begin
    ReturnVal := PktLength(Width + 2 downto 3);   -- divide by 8
    if (PktLength(2 downto 0) /= "000") or
       (Address(2 downto 0) /= "000") then
      ReturnVal := ReturnVal + 1;
    end if;
    if (resize(PktLength(2 downto 0), 4) +
        resize(Address(2 downto 0), 4)) > 8 then
      ReturnVal := ReturnVal + 1;
    end if;
    return ReturnVal;
  end ChinchPacketPayloadWords;



  -- based on a data payload size, compute the maximum number of words in a
  -- Chinch data payload.  This function only supports powers of two.
  function ChinchPacketMaxPayloadWords(PayloadSize : natural)
                                        return natural is
  begin
    if PayloadSize < 2 then
      return 1;
    elsif PayloadSize < 10 then
      return 2;
    else
      return (PayloadSize / 8) + 1;
    end if;
  end ChinchPacketMaxPayloadWords;



  -- Chinch Packet: test for any request type
  function ChinchPacketRequest(PktType : ChinchPacketType_t)
                                            return boolean is
  begin
    return (PktType(1) = '0');
  end ChinchPacketRequest;



  -- Chinch Packet: test for any response type
  function ChinchPacketResponse(PktType : ChinchPacketType_t)
                                            return boolean is
  begin
    return (PktType(1) = '1');
  end ChinchPacketResponse;



  -- Chinch Packet: test for an extended header
  function ChinchPacketHeaderExtended(Spc : ChinchPacketSpc_t
                                     ) return boolean is
  begin
    return (Spc = kChinchPacketSpcExtHeader);
  end ChinchPacketHeaderExtended;


  function ChinchPacketHasPayload(Header : ChinchPacketWord_t)
    return boolean is
  begin
    return (ChinchPacketGetType(Header)(2) = '1' and
            ChinchPacketGetLength(Header) > 0);
  end ChinchPacketHasPayload;

  -- Chinch Packet: test for a data payload in the packet
  function ChinchPacketIncludesPayload(PktType : ChinchPacketType_t;
                                       PktLength : ChinchPacketLength_t
                                      ) return boolean is
  begin
    return (PktType(2) = '1' and
            PktLength > 0);
  end ChinchPacketIncludesPayload;



  -- Chinch Packet: test if the packet will require a response
  function ChinchPacketRequiresResponse(PktType : ChinchPacketType_t)
                                           return boolean is
  begin
    return (PktType(0) = '1');
  end ChinchPacketRequiresResponse;



  -- Chinch Packet: test if a request packet is a write
  function ChinchPacketReqWrite(PktType : ChinchPacketType_t)
                                           return boolean is
  begin
    return (PktType(2) = '1');
  end ChinchPacketReqWrite;



  -- Chinch Packet: test if a request packet is a read
  function ChinchPacketReqRead(PktType : ChinchPacketType_t)
                                           return boolean is
  begin
    return (PktType(2) = '0');
  end ChinchPacketReqRead;



  -- Chinch Packet: test if a response packet is a write
  function ChinchPacketResWrite(PktType : ChinchPacketType_t)
                                           return boolean is
  begin
    return (PktType(2) = '0');
  end ChinchPacketResWrite;



  -- Chinch Packet: test if a response packet is a read
  function ChinchPacketResRead(PktType : ChinchPacketType_t)
                                           return boolean is
  begin
    return (PktType(2) = '1');
  end ChinchPacketResRead;



  -- Chinch Packet: test if a stream request packet is the end of a record
  function ChinchPacketEndOfRecord(Header : ChinchPacketWord_t)
                                           return boolean is
  begin
    return (Header(43) = '1');
  end ChinchPacketEndOfRecord;



  -- Chinch Packet: test if a stream request packet has the Done Flag set
  function ChinchPacketDoneFlag(Header : ChinchPacketWord_t)
                                           return boolean is
  begin
    return (Header(42) = '1');
  end ChinchPacketDoneFlag;

end PkgChinch;
