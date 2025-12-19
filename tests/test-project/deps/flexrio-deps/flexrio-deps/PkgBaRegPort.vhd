-------------------------------------------------------------------------------
--
-- File: PkgBaRegPort.vhd
-- Author: Glen Sescila
-- Original Project: NI DMA IP
-- Date: 19 July 2010
--
-------------------------------------------------------------------------------
-- (c) 2015 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
-- This RegPort implementation is byte addressable.  It is also designed for
-- both minimal gate count and pipelining.  Since data is not justified on the
-- data bus each register always connects to the same set of byte lanes.  This
-- eliminates the need for byte steering logic and reduces gate count compared
-- to the PkgRegPort nicore.  To facilitate pipelining this implementation uses
-- Strobe and Acknowledge pulses rather than the Holdoff signal from the
-- PkgRegPort nicore.  With the Holdoff signal the addressed register has a
-- bounded amount of time to assert Holdoff once it is accessed and the Holdoff
-- signals from all registers need to be OR'ed together.  The sum of pipeline
-- stages used to complete both of these operations cannot exceed the limited
-- amount of time.  With the Strobe and Acknowledge scheme it is easy to add
-- pipeline stages for decoding the address, OR'ing the Acknowledges, and
-- muxing the read data.  The number of pipeline stages for OR'ing the
-- Acknowledges needs to match the number used for muxing the read data.  The
-- number of pipeline stages can vary on a per-register or per-register group
-- basis.  Pipeline stages can optionally be added to the write data up to the
-- number used for address decoding on a per-register or group basis.
-- Pipelining is optional for write data and doesn't have to match the number
-- of stages used for address decoding exactly since the master is required to
-- keep write data stable from the state that WtStrobe asserts until the state
-- after Acknowledge.  The register is allowed to sample write data on any of
-- those states.
--
-- Note that care should be taken when pipelining address decodes.  Even though
-- the master is required to keep address valid until acknowledged, when the
-- access doesn't belong to you it could be acknowledged by someone else as
-- soon as the same state that strobes are asserted and you don't have
-- visibility of acknowledges from others.  When the access is yours you can
-- take advantage of the stable address but when it is someone else's your
-- pipeline stages should not inadvertently take action from the access.
-- Typically some form of the strobes should be pipelined along with the
-- address to ensure the address from the original strobe state is what's being
-- decoded.
--
-- The data width is configurable in this implementation.  With enough care a
-- design could be implemented in a data width agnostic way.  When the data bus
-- is narrower than the accessed register the hardware design should take care
-- to allow access to sub-portions of the register.  Note that the RegPort data
-- bus width doesn't necessarily limit the size of access that software can
-- perform natively.  If software initiates an access wider than the RegPort
-- data bus the access will be broken down into multiple cycles to increasing
-- address offsets by either the RegPort master circuitry or the system bus
-- itself.  When the data is wider than the accessed registers it may be
-- necessary for hardware to allow access to more than one register at a time.
-- In certain cases hardware is designed to expect that two particular
-- registers can't be written in the same state.  In such situations the
-- hardware should prevent such accesses through the definition of a
-- programming model that makes it illegal for software to perform such
-- accesses.  The functions in this package provide data and byte enable
-- interfaces that match the register size rather than the data bus width.
-- This should simplify implementing designs in a data bus width agnostic way.
--
-- It should be trivial to create a shim to interface other RegPort protocols
-- to this one if necessary.
--
-- It is important to only drive BaRegPortOut.Data in the state that
-- BaRegPortOut.Acknowledge is driven.  The reason for this is illustrated
-- below.  There are two registers (Reg1 and Reg2) at different depths
-- of pipelining.  Each register drives its RpOut.Ack 1 state after RpIn.Strobe.
-- If the registers drive RpOut.Data when their address is on the bus, the
-- following will occur.
--                  |-----|
--      RpIn -------|D  Q |---- RpIn2
--              |   |     |  |
--              |   |>    |  |
--              |   |_____|  |
--              |            |
--             Reg1         Reg2
--              |            |
--              |   |-----|  |
--      RpOut ------|Q   D|----- RpOut2
--                  |     |
--                  |    <|
--                  |_____|
--
--  Clock         __|--|__|--|__|--|__|--|__|--|__
--  RpIn.Strobe   ___|-----|_________________|-----|____________
--  RpIn.Addr     XXX| A2                    | A1              |XXX
--  RpIn2.Strobe  _________|-----|_________________|-----|______
--  RpIn2.Addr    XXXXXXXXX| A2                    | A1
--  RpOut2.Data   XXXXXXXXXXXXXXX| D2                    | 0
--  RpOut2.Ack    _______________|-----|____________________________
--  RpOut.Data    XXXXXXXXXXXXXXXXXXXXX| D2              | D1/2| 0
--  RpOut.Ack     _____________________|-----|___________|-----|______
--
-- Since the data from the access to Reg2 is still around during the access to
-- Reg1, the access to Reg1 is corrupted by Reg2's data being ORed in.
--
-- vreview_group NiDmaIp
-- vreview_closed http://review-board.natinst.com/r/218403/
-- vreview_closed http://review-board.natinst.com/r/154081/
-- vreview_closed http://review-board.natinst.com/r/151571/
-- vreview_closed http://review-board.natinst.com/r/149659/
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;
  use work.PkgXReg.all;
  use work.PkgBaRegPortConfig.all;

package PkgBaRegPort is

  -- Make a package called PkgBaRegPortConfig that provides 2 constants of type
  -- natural named kBaRegPortAddressWidthConfig and kBaRegPortDataWidthConfig.
  -- This is how you configure the width of the address and data buses on
  -- BaRegPort.  An example of this package can be found in the sample project.
  -- Here is a P4 link:
  -- //ASIC/NiGuidelines/ProjectSetup/vsmake3/dev/1.0/username/FpgaName/Source/VHDL/Packages/PkgBaRegPortConfig.vhd

  -- These constants are just here to isolate the rest of the code in the design
  -- from PkgBaRegPortConfig.
  constant kBaRegPortAddressWidth : natural := kBaRegPortAddressWidthConfig;
  constant kBaRegPortDataWidth : natural := kBaRegPortDataWidthConfig;

  -- Derived constants.

  constant kBaRegPortDataWidthInBytes : positive := kBaRegPortDataWidth / 8;
  constant kBaRegPortByteWidthLog2 : natural := Log2(kBaRegPortDataWidthInBytes);


  -- Base types.

  subtype BaRegPortAddress_t is unsigned(kBaRegPortAddressWidth - 1 downto 0);

  subtype BaRegPortData_t is std_logic_vector(kBaRegPortDataWidth - 1 downto 0);

  subtype BaRegPortStrobe_t is BooleanVector(kBaRegPortDataWidthInBytes - 1 downto 0);

  -- BaRegPort port types.  WtStrobe, RdStrobe, and Acknowledge are one-state
  -- pulses.  The RegPort master must keep Address (and write Data during
  -- writes) valid from the state in which *Strobe asserts until the state
  -- after Acknowledge asserts as shown in the diagram below.  Acknowledge can
  -- be asserted in the same state as *Strobe or any time later.  Read Data
  -- should only be driven non zero in the state that Acknowledge asserts.  The
  -- earliest that *Strobe can assert for an access is the state after
  -- Acknowledge from the previous access.
  --                __    __    __    __    __    __    __    __    __
  --        clock _|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |_
  --                      _________________ _________________
  --      Address -------|_________________|_________________|----------
  --                      _________________
  --   write Data -------|_________________|----------------------------
  --                      _____
  --     WtStrobe _______|_____|________________________________________
  --                                        _____
  --     RdStrobe _________________________|_____|______________________
  --                                                    _____
  --    read Data -------------------------------------|_____|----------
  --                                  _____             _____
  --  Acknowledge ___________________|     |___________|     |__________

  type BaRegPortIn_t is record
    Address : BaRegPortAddress_t;
    Data : BaRegPortData_t;
    WtStrobe : BaRegPortStrobe_t;
    RdStrobe : BaRegPortStrobe_t;
  end record;

  constant kBaRegPortInZero : BaRegPortIn_t := (
    Address => (others => '0'),
    Data => (others => '0'),
    WtStrobe => (others => false),
    RdStrobe => (others => false)
  );

  type BaRegPortInArray_t is array (natural range <>) of BaRegPortIn_t;

  type BaRegPortOut_t is record
    Data : BaRegPortData_t;
    Ack : boolean;
  end record;

  constant kBaRegPortOutZero : BaRegPortOut_t := (
    Data => (others => '0'),
    Ack => false
  );

  type BaRegPortOutArray_t is array (natural range <>) of BaRegPortOut_t;

  function SizeOf(Var : BaRegPortIn_t) return integer;
  function SizeOf(Var : BaRegPortOut_t) return integer;

  -- Use RegAccess to drive ack, this function only looks at the address.
  -- Decodes the address for a particular register.  Will be true if any data
  -- bus word within the register is addressed.
  function RegSelected(RegOffset : integer;
                       RegSize : integer;
                       BaRegPortIn : BaRegPortIn_t) return boolean;

  -- Returns true when the address of the current access matches any value between
  -- AddrLo and AddrHi (including AddrLo and AddrHi)
  function RangeSelected (AddrLo, AddrHi : integer; RPI : BaRegPortIn_t) return boolean;

  -- Creates per-byte write enables for a particular register.  Output matches
  -- register size regardless of data bus width.
  function RegWriteEnables(RegOffset : integer;
                           RegSize : integer;
                           BaRegPortIn : BaRegPortIn_t) return BooleanVector;
  -- Behaves the same as the function above but takes advantage of PkgXReg
  function RegWriteEnables(RegInfo : XReg2_t;
                           BaRegPortIn : BaRegPortIn_t;
                           BaseAddr : natural := 0) return BooleanVector;

  -- Creates write data for a particular register.  Output matches register
  -- size regardless of data bus width.  This function needs to be qualified with
  -- the write strobes by using RegWriteEnables.
  function RegWriteData(RegOffset : integer;
                        RegSize : integer;
                        BaRegPortIn : BaRegPortIn_t) return std_logic_vector;
  -- Creates updated write data for a register.  Takes in the old register data, and
  -- only updates the bytes that were written.  The return value only differs from
  -- OldData for each byte lane whose write strobe is asserted.
  function RegWriteData(RegOffset : integer;
                        RegSize : integer;
                        OldData : std_logic_vector;
                        BaRegPortIn : BaRegPortIn_t) return std_logic_vector;
  -- Behaves the same as the function above but takes advantage of PkgXReg.
  -- Note that if the register is not marked as writable by RegInfo this
  -- function just always returns OldData.
  -- Also this implements a special behavior for strobe bitfields (data is cleared if
  --  register is not written).
  -- Note for bitfields with clearable attribute: regmap constants created with older
  --  versions of XmlParse or PkgXReg will not have information to identify a bitfield
  --  as clearable. For newer versions, those bitfields will be considered strobes here.
  function RegWriteData(RegInfo : XReg2_t;
                        OldData : std_logic_vector;
                        BaRegPortIn : BaRegPortIn_t;
                        BaseAddr : natural := 0) return std_logic_vector;

  -- Creates per-byte read enables for a particular register.  Output matches
  -- register size regardless of data bus width.
  function RegReadEnables(RegOffset : integer;
                          RegSize : integer;
                          BaRegPortIn : BaRegPortIn_t) return BooleanVector;
  -- Behaves the same as the function above but takes advantage of PkgXReg
  function RegReadEnables(RegInfo : XReg2_t;
                          BaRegPortIn : BaRegPortIn_t;
                          BaseAddr : natural := 0) return BooleanVector;

  -- Creates read data for a particular register.  The data input to this
  -- function is the size of the register while the output is sized to match
  -- the data bus.  The output is appropriate for use in a BaRegPortOut_t
  -- signal since it is forced to 0 when the register is not addressed.
  function RegReadData(RegOffset : integer;
                       RegSize : integer;
                       RegReadValue : std_logic_vector;
                       BaRegPortIn : BaRegPortIn_t) return BaRegPortData_t;
  -- Behaves the same as the function above but takes advantage of PkgXReg.
  -- Note that if the register is not marked as readable by RegInfo this
  -- function just always returns 0.
  function RegReadData(RegInfo : XReg2_t;
                       RegReadValue : std_logic_vector;
                       BaRegPortIn : BaRegPortIn_t;
                       BaseAddr : natural := 0) return BaRegPortData_t;

  -- This function returns true if any read or write strobe to the register is
  -- asserted.  Note that this function will return true if a read-only
  -- register is written or a write only register is read.
  function RegAccess(RegOffset : integer;
                     RegSize : integer;
                     BaRegPortIn : BaRegPortIn_t) return boolean;
  -- This function returns true if any strobe to the register is asserted,
  -- taking into account whether the register is marked as readable and/or
  -- writable by the RegInfo parameter.
  function RegAccess(RegInfo : XReg2_t;
                     BaRegPortIn : BaRegPortIn_t;
                     BaseAddr : natural := 0) return boolean;

  -- This function can be used to drive BaRegPortOut directly for a particular
  -- register.  When driving Ack this function takes into account whether the
  -- register is marked as readable and/or writable by the RegInfo parameter.
  -- The RegReadValue parameter is unused for write-only registers.
  function DriveRegPortOut(RegInfo : XReg2_t;
                           RegReadValue : std_logic_vector;
                           BaRegPortIn : BaRegPortIn_t;
                           BaseAddr : natural := 0) return BaRegPortOut_t;
  -- This function is the same as the one above but is more convenient for
  -- write-only registers (no RegReadValue parameter).
  function DriveRegPortOut(RegInfo : XReg2_t;
                           BaRegPortIn : BaRegPortIn_t;
                           BaseAddr : natural := 0) return BaRegPortOut_t;

  -- The two functions below combine multiple BaRegPortOut_t records into one.
  function "or" (L, R : BaRegPortOut_t) return BaRegPortOut_t;
  function OrArray(BaRegPortOutArray : BaRegPortOutArray_t) return BaRegPortOut_t;
  
  -- Resize unsigned to BaRegPortAddress_t
  function BaAddrResize(Offset : unsigned) return BaRegPortAddress_t;

  -- Return a modified BaRegPortIn_t that has its address adjusted according to
  -- the base address and disables WtStrobe and RdStrobe if the incoming address
  -- is outside of the Base/Size range.
  function WindowBaRegPortIn (kBase, kSize : natural;
                              BaRegPortIn : BaRegPortIn_t) return BaRegPortIn_t;
  function WindowBaRegPortIn (RegInfo : XReg2_t;
                              BaRegPortIn : BaRegPortIn_t) return BaRegPortIn_t;

end PkgBaRegPort;

package body PkgBaRegPort is

  function SizeOf(Var : BaRegPortIn_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + Var.Address'length;   -- Address
    RetVal := RetVal + Var.Data'length;      -- Data
    RetVal := RetVal + Var.WtStrobe'length;  -- WtStrobe
    RetVal := RetVal + Var.RdStrobe'length;  -- RdStrobe
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : BaRegPortOut_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + Var.Data'length;  -- Data
    RetVal := RetVal + 1;                -- Ack
    return RetVal;
  end function SizeOf;

  -- Return the equivalent of Offset mod kBaRegPortDataWidthInBytes, but
  -- without converting Offset to integer first. This allows values bigger
  -- than 2^31 to work.
  function OffsetMod (Offset : BaRegPortAddress_t) return integer is
  begin
    return To_Integer(Offset(kBaRegPortByteWidthLog2-1 downto 0));
  end function OffsetMod;

  -- Return unsigned version of a natural/integer offset
  function To_BaAddr(Offset : natural) return BaRegPortAddress_t is
  begin
    return To_Unsigned(Offset, kBaRegPortAddressWidth);
  end function To_BaAddr;

  -- Return resized offset
  function BaAddrResize(Offset : unsigned) return BaRegPortAddress_t is
  begin
    return resize(Offset, kBaRegPortAddressWidth);
  end function BaAddrResize;

  -- Returns true when the address is accessing a bus data word that contains
  -- at least one byte of the register in question.  Since we have a separate
  -- strobe for each byte lane we don't particularly care about the least
  -- significant address bits.
  function RegSelected(RegOffset : BaRegPortAddress_t;
                       RegSize : integer;
                       BaRegPortIn : BaRegPortIn_t) return boolean is
    -- There are two cases.  If the register size is less than or equal to the
    -- data bus width we check that the address is accessing the data bus word
    -- that contains the register.  The strobes will then determine if the
    -- actual portion of the data bus where the register is located is being
    -- accessed.  If the register size is larger than the data bus width this
    -- function has to decode the address based on the register size.  In this
    -- case the decode is indicating that one of the data words that are part
    -- of the register is being accessed.  Subsequent functions will have to
    -- look at the least significant address bits to determine which word is
    -- being accessed.
    constant kUseWidth : integer := Larger(kBaRegPortDataWidthInBytes,
                                           (RegSize / 8));
  begin
    --synopsys translate_off
    assert (RegSize >= 8) and ((RegSize mod 8) = 0) and IsPowerOf2(RegSize)
      report "Register size must be a power-of-two multiple of eight."
      severity FAILURE;
    assert (RegOffset mod (RegSize / 8)) = 0
      report "Register offset must be naturally aligned to the register size."
      severity FAILURE;
    --synopsys translate_on
    return (BaRegPortIn.Address(BaRegPortIn.Address'high downto Log2(kUseWidth)) =
            (RegOffset / kUseWidth));
  end function RegSelected;

  -- Integer version of RegSelected
  function RegSelected(RegOffset : integer;
                       RegSize : integer;
                       BaRegPortIn : BaRegPortIn_t) return boolean is
  begin
    return RegSelected(To_BaAddr(RegOffset), RegSize, BaRegPortIn);
  end function RegSelected;

  -- Returns true when the address of the current access matches any value between
  -- AddrLo and AddrHi (including AddrLo and AddrHi)
  function RangeSelected (AddrLo, AddrHi : BaRegPortAddress_t;
                          RPI : BaRegPortIn_t) return boolean is
  begin
    --synopsys translate_off
    assert (AddrHi > AddrLo) and (OffsetMod(AddrLo) = 0) and (OffsetMod(AddrHi + 1) = 0)
      report "Range cannot cross data bus word boundaries."
      severity FAILURE;
    --synopsys translate_on
    return (RPI.Address >= AddrLo) and
           (RPI.Address <= AddrHi) and
           (OrVector(RPI.RdStrobe) or OrVector(RPI.WtStrobe));
  end function RangeSelected;

  -- Integer version of RangeSelected
  function RangeSelected (AddrLo, AddrHi : integer; RPI : BaRegPortIn_t) return boolean is
  begin
    return RangeSelected(To_BaAddr(AddrLo), To_BaAddr(AddrHi), RPI);
  end function RangeSelected;

  -- Returns enables appropriate for gating writes or reads to each byte of a
  -- particular register.  The output of this function matches the size of the register
  -- even if the register is wider than the data bus.
  function RegEnables(RegOffset : BaRegPortAddress_t;
                      RegSize : integer;
                      BaRegPortIn : BaRegPortIn_t;
                      DoWt : boolean := true) return BooleanVector is
    variable RegWord : integer;
    variable RetVal : BooleanVector(RegSize / 8 - 1 downto 0) := (others => false);
    variable Strobes : BaRegPortStrobe_t;
  begin
    if DoWt then Strobes := BaRegPortIn.WtStrobe;
            else Strobes := BaRegPortIn.RdStrobe;
    end if;
    if RegSelected(RegOffset, RegSize, BaRegPortIn) then
      if RegSize <= kBaRegPortDataWidth then
        -- If the register is smaller than the data bus, then we can return the slice
        -- of the write enables that correspond to the lower bits of the register's offset
        -- up to the register's size.
        -- For example, if the register is 32 bits, but the bus is 64, then the
        -- access would select WtStrobe(3:0). A 16-bit register with an address of 2
        -- would select WtStrobe(3:2).
        RetVal := Strobes(OffsetMod(RegOffset)+RegSize/8-1 downto OffsetMod(RegOffset));
      else
        -- If the register is larger than the data bus, then we assign Strobes to
        -- the appropriate slice of RetVal
        RegWord := To_Integer(BaRegPortIn.Address(Log2(RegSize/8)-1 downto kBaRegPortByteWidthLog2))
                       * kBaRegPortDataWidthInBytes;
        for i in BaRegPortStrobe_t'range loop
          RetVal(RegWord + i) := Strobes(i);
        end loop;
      end if;
    end if;
    return RetVal;
  end function RegEnables;

  -- Returns enables appropriate for gating writes to each byte of a particular
  -- register.  The output of this function matches the size of the register
  -- even if the register is wider than the data bus.
  function RegWriteEnables(RegOffset : BaRegPortAddress_t;
                           RegSize : integer;
                           BaRegPortIn : BaRegPortIn_t) return BooleanVector is
  begin
    return RegEnables(RegOffset, RegSize, BaRegPortIn, DoWt=>true);
  end function RegWriteEnables;

  -- Integer version of RegWriteEnables.
  function RegWriteEnables(RegOffset : integer;
                           RegSize : integer;
                           BaRegPortIn : BaRegPortIn_t) return BooleanVector is
  begin
    return RegEnables(To_BaAddr(RegOffset), RegSize, BaRegPortIn, DoWt=>true);
  end function RegWriteEnables;

  -- XReg2 version of RegWriteEnables
  function RegWriteEnables(RegInfo : XReg2_t;
                           BaRegPortIn : BaRegPortIn_t;
                           BaseAddr : natural := 0) return BooleanVector is
  begin
    return RegWriteEnables(BaAddrResize(BaseAddr + RegInfo.offset), RegInfo.size, BaRegPortIn);
  end function RegWriteEnables;

  -- Returns write data appropriate for a particular register.  The output of
  -- this function matches the size of the register even if the register is
  -- wider than the data bus.  Since RegOffset and RegSize should be constants
  -- this function should synthesize to zero gates.
  function RegWriteData(RegOffset : BaRegPortAddress_t;
                        RegSize : integer;
                        BaRegPortIn : BaRegPortIn_t) return std_logic_vector is
    variable RetVal : std_logic_vector(RegSize - 1 downto 0);
  begin
    if RegSize <= kBaRegPortDataWidth then
      RetVal := BaRegPortIn.Data(OffsetMod(RegOffset)*8+RegSize-1 downto OffsetMod(RegOffset)*8);
    else
      for i in 0 to (RegSize / kBaRegPortDataWidth) - 1 loop
        RetVal((i+1)*kBaRegPortDataWidth-1 downto i*kBaRegPortDataWidth) := BaRegPortIn.Data;
      end loop;
    end if;
    return RetVal;
  end function RegWriteData;

  -- Integer version of RegWriteData.
  function RegWriteData(RegOffset : integer;
                        RegSize : integer;
                        BaRegPortIn : BaRegPortIn_t) return std_logic_vector is
  begin
    return RegWriteData(To_BaAddr(RegOffset), RegSize, BaRegPortIn);
  end function RegWriteData;

  -- Creates updated write data for a register.  Takes in the old register data, and
  -- only updates the bytes that were written.  The return value only differs from
  -- OldData for each byte lane whose write strobe is asserted.
  function RegWriteData(RegOffset : integer;
                        RegSize : integer;
                        OldData : std_logic_vector;
                        BaRegPortIn : BaRegPortIn_t) return std_logic_vector is
    variable ByteEnables : BooleanVector(RegSize / 8 - 1 downto 0);
    variable NewData : std_logic_vector(RegSize - 1 downto 0);
    variable ReturnVal : std_logic_vector(RegSize - 1 downto 0) := OldData;
  begin
    --synopsys translate_off
    assert OldData'length = RegSize
      report "RegSize must match data length"
      severity FAILURE;
    --synopsys translate_on
    ByteEnables := RegWriteEnables(RegOffset, RegSize, BaRegPortIn);
    NewData := RegWriteData(RegOffset, RegSize, BaRegPortIn);
    for i in ByteEnables'range loop
      if ByteEnables(i) then
        ReturnVal(8*i + 7 downto 8*i) := NewData(8*i + 7 downto 8*i);
      end if;
    end loop;
    return ReturnVal;
  end function RegWriteData;

  -- Behaves similar to the function above but takes advantage of PkgXReg.
  -- Differences:
  --   1. If the register is not marked as writable by RegInfo this
  --      function just always returns OldData.
  --   2. Strobe bits are masked off from OldData
  --   3. BaseAddr argument allows base address to be added to RegInfo.offset
  --   4. Bits that are not writable always return OldData
  function RegWriteData(RegInfo : XReg2_t;
                        OldData : std_logic_vector;
                        BaRegPortIn : BaRegPortIn_t;
                        BaseAddr : natural := 0) return std_logic_vector is
    variable ByteEnables : BooleanVector(RegInfo.size / 8 - 1 downto 0);
    variable WtMask, NewData, ReturnVal : std_logic_vector(RegInfo.size - 1 downto 0);
  begin
    --synopsys translate_off
    assert OldData'length = RegInfo.size
      report "RegInfo.size must match data length"
      severity FAILURE;
    --synopsys translate_on
    -- ReturnVal starts out as OldData, with the strobe bits masked off
    ReturnVal := OldData and not GetStrobeMask(RegInfo);
    -- If the register is writable, then process the write, otherwise the
    -- old data will be returned
    if RegInfo.writable then
      -- Figure out the byte enables and the value being written
      ByteEnables := RegWriteEnables(RegInfo, BaRegPortIn, BaseAddr);
      NewData := RegWriteData(BaAddrResize(BaseAddr + RegInfo.offset), RegInfo.size, BaRegPortIn);
      WtMask := GetWtMask(RegInfo);
      -- For each byte that is enabled, update any writable bits
      for i in ByteEnables'range loop
        if ByteEnables(i) then
          for b in 8*i to 8*i+7 loop
            if WtMask(b)='1' then
              ReturnVal(b) := NewData(b);
            end if;
          end loop;
        end if;
      end loop;
    end if;
    return ReturnVal;
  end function RegWriteData;

  -- Returns enables appropriate for gating reads to each byte of a particular
  -- register.  The output of this function matches the size of the register
  -- even if the register is wider than the data bus.
  function RegReadEnables(RegOffset : BaRegPortAddress_t;
                          RegSize : integer;
                          BaRegPortIn : BaRegPortIn_t) return BooleanVector is
  begin
    return RegEnables(RegOffset, RegSize, BaRegPortIn, DoWt=>false);
  end function RegReadEnables;

  -- Integer version of RegReadEnables.
  function RegReadEnables(RegOffset : integer;
                          RegSize : integer;
                          BaRegPortIn : BaRegPortIn_t) return BooleanVector is
  begin
    return RegEnables(To_BaAddr(RegOffset), RegSize, BaRegPortIn, DoWt=>false);
  end function RegReadEnables;

  -- XReg version of RegReadEnables
  function RegReadEnables(RegInfo : XReg2_t;
                          BaRegPortIn : BaRegPortIn_t;
                          BaseAddr : natural := 0) return BooleanVector is
  begin
    return RegReadEnables(BaAddrResize(BaseAddr + RegInfo.offset), RegInfo.size, BaRegPortIn);
  end function RegReadEnables;

  -- Creates the data field of a BaRegPortOut_t record from a particular
  -- register's read value.
  function RegReadData(RegOffset : BaRegPortAddress_t;
                       RegSize : integer;
                       RegReadValue : std_logic_vector;
                       BaRegPortIn : BaRegPortIn_t) return BaRegPortData_t is
    alias LocalData : std_logic_vector(RegReadValue'length - 1 downto 0) is RegReadValue;
    variable RegByte : integer;
    variable RetVal : BaRegPortData_t := (others => '0');
  begin
    --synopsys translate_off
    assert RegReadValue'length = RegSize
      report "Register read value must match register size."
      severity FAILURE;
    --synopsys translate_on
    if RegSelected(RegOffset, RegSize, BaRegPortIn) then
      if RegSize <= kBaRegPortDataWidth then
        RetVal(OffsetMod(RegOffset)*8+RegSize-1 downto OffsetMod(RegOffset)*8) := LocalData;
      else
        RegByte := to_integer(BaRegPortIn.Address(Log2(RegSize / 8) - 1 downto
                       kBaRegPortByteWidthLog2)) *
                       kBaRegPortDataWidth;
        RetVal := LocalData(RegByte + kBaRegPortDataWidth - 1 downto RegByte);
      end if;
    end if;
    return RetVal;
  end function RegReadData;

  -- Integer version of RegReadData.
  function RegReadData(RegOffset : integer;
                       RegSize : integer;
                       RegReadValue : std_logic_vector;
                       BaRegPortIn : BaRegPortIn_t) return BaRegPortData_t is
  begin
    return RegReadData(To_BaAddr(RegOffset), RegSize, RegReadValue, BaRegPortIn);
  end function RegReadData;

  -- Behaves the same as the function above but takes advantage of PkgXReg.
  -- Note that if the register is not marked as readable by RegInfo this
  -- function just always returns 0.
  function RegReadData(RegInfo : XReg2_t;
                       RegReadValue : std_logic_vector;
                       BaRegPortIn : BaRegPortIn_t;
                       BaseAddr : natural := 0) return BaRegPortData_t is
    variable RetVal : BaRegPortData_t := (others => '0');
    variable RdData : std_logic_vector(RegReadValue'length - 1 downto 0) := RegReadValue;
  begin
    RdData := RdData and GetRdMask(RegInfo);
    if RegInfo.readable then
      RetVal := RegReadData(BaAddrResize(BaseAddr + RegInfo.offset), RegInfo.size, RdData, BaRegPortIn);
    end if;
    return RetVal;
  end function RegReadData;

  -- This function returns true if any read or write strobe to the register is
  -- asserted.  Note that this function will return true if a read-only
  -- register is written or a write only register is read.
  function RegAccess(RegOffset : integer; RegSize : integer;
                     BaRegPortIn : BaRegPortIn_t) return boolean is
  begin
    return OrVector(RegWriteEnables(RegOffset, RegSize, BaRegPortIn)) or
           OrVector(RegReadEnables(RegOffset, RegSize, BaRegPortIn));
  end function RegAccess;

  -- This function returns true if any strobe to the register is asserted,
  -- taking into account whether the register is marked as readable and/or
  -- writable by the RegInfo parameter.
  function RegAccess(RegInfo : XReg2_t;
                     BaRegPortIn : BaRegPortIn_t;
                     BaseAddr : natural := 0) return boolean is
  begin
    return (OrVector(RegWriteEnables(RegInfo, BaRegPortIn, BaseAddr)) and RegInfo.writable) or
           (OrVector(RegReadEnables(RegInfo, BaRegPortIn, BaseAddr)) and RegInfo.readable);
  end function RegAccess;

  -- This function can be used to drive BaRegPortOut directly for a particular
  -- register.  When driving Ack this function takes into account whether the
  -- register is marked as readable and/or writable by the RegInfo parameter.
  -- The RegReadValue parameter is unused for write-only registers.
  function DriveRegPortOut(RegInfo : XReg2_t;
                           RegReadValue : std_logic_vector;
                           BaRegPortIn : BaRegPortIn_t;
                           BaseAddr : natural := 0) return BaRegPortOut_t is
    variable Accessed : boolean;
    variable ReturnVal : BaRegPortOut_t := kBaRegPortOutZero;
  begin
    Accessed := RegAccess(RegInfo, BaRegPortIn, BaseAddr);
    if RegInfo.readable and Accessed then
      ReturnVal.Data := RegReadData(RegInfo, RegReadValue, BaRegPortIn, BaseAddr);
    end if;
    ReturnVal.Ack := Accessed;
    return ReturnVal;
  end function DriveRegPortOut;

  -- This function is the same as the one above but is more convenient for
  -- write-only registers (no RegReadValue parameter).
  function DriveRegPortOut(RegInfo : XReg2_t;
                           BaRegPortIn : BaRegPortIn_t;
                           BaseAddr : natural := 0) return BaRegPortOut_t is
  begin
    --synopsys translate_off
    assert not RegInfo.readable
      report "Readable registers need a RegReadValue."
      severity FAILURE;
    --synopsys translate_on
    return DriveRegPortOut(RegInfo, Zeros(RegInfo.size), BaRegPortIn, BaseAddr);
  end function DriveRegPortOut;

  -- Combine two BaRegPortOut_t busses together into a common bus.
  function "or" (L, R : BaRegPortOut_t) return BaRegPortOut_t is
    variable RetVal : BaRegPortOut_t;
  begin
    RetVal.Data := L.Data or R.Data;
    RetVal.Ack := L.Ack or R.Ack;
    return RetVal;
  end function "or";

  -- OR all the elements of an array of BaRegPortOut_t.
  function OrArray(BaRegPortOutArray : BaRegPortOutArray_t) return BaRegPortOut_t is
    variable RetVal : BaRegPortOut_t := kBaRegPortOutZero;
  begin
    for i in BaRegPortOutArray'range loop
      RetVal := RetVal or BaRegPortOutArray(i);
    end loop;
    return RetVal;
  end function OrArray;

  -- Return a modified BaRegPortIn_t that has its address adjusted according to
  -- the base address and disables WtStrobe and RdStrobe if the incoming address
  -- is outside of the Base/Size range.
  function WindowBaRegPortIn (kBase, kSize : natural;
                              BaRegPortIn : BaRegPortIn_t) return BaRegPortIn_t is
    variable RPI : BaRegPortIn_t;
  begin
    --synopsys translate_off
    assert (kBase mod kBaRegPortDataWidthInBytes = 0) and (kSize mod kBaRegPortDataWidthInBytes = 0)
      report "Window cannot cross data bus word boundaries."
      severity FAILURE;
    --synopsys translate_on
    RPI := BaRegPortIn;
      RPI.Address := BaRegPortIn.Address - kBase;
    if not RangeSelected(AddrLo=>kBase, AddrHi=>kBase+kSize-1, RPI=>BaRegPortIn) then
      RPI.WtStrobe := (others => false);
      RPI.RdStrobe := (others => false);
    end if;
    return RPI;
  end function WindowBaRegPortIn;

  -- XReg2_t version of WindowBaRegPortIn
  function WindowBaRegPortIn (RegInfo : XReg2_t;
                              BaRegPortIn : BaRegPortIn_t) return BaRegPortIn_t is
  begin
    --synopsys translate_off
    assert not RegInfo.isreg
      report "WindowBaRegPortIn must be called on a RAM or a Window"
      severity failure;
    --synopsys translate_on
    return WindowBaRegPortIn(kBase=>GetOffset(RegInfo), kSize=>GetSize(RegInfo), BaRegPortIn=>BaRegPortIn);
  end function WindowBaRegPortIn;

end PkgBaRegPort;
