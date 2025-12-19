-------------------------------------------------------------------------------
--
-- File: PkgXReg.vhd
-- Author: Craig Conway
-- Original Project: XmlParse
-- Date: 2 December 2015
--
-------------------------------------------------------------------------------
-- (c) 2015 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--   This file contains constants and the record definition used by XmlParse
-- to describe registers.
--   XmlParse will use XReg2_t as long as it finds the XReg2_t declaration
-- in this file.as appropriate for what it detects in the PkgXReg file.
--
--   Recommended Usage
--
--   Use the accessor functions (Get*) to get fields from the XReg2_t
-- record. You should not create any constants yourself of type XReg2_t
-- using this format:
--
-- constant kSomeRec : XReg2_t := (offset => X"1234", size=>32, etc.);  -- WRONG
--
-- Doing it this way means that any update to PkgXReg (where fields
-- are added), will cause the above line to fail due to missing
-- fields. Instead, create functions (see XmlParse-generated files
-- for additional examples) like this:
--
-- function kSomeRecF return XReg2_t is          -- RIGHT
--   variable X : XReg2_t := kXRegDefault;
-- begin
--   X.offset := X"1234"
--   X.size := 32;
--   etc.
-- end function kSomeRecF;
--
-- constant kSomeRec : XReg2_t := kSomeRecF;
--
-- Because X has a default assignment of kXRegDefault, any additional fields
-- added to XReg2_t will not break the above code.
--
-- Note, however, that even if existing code will not be broken, new code that
-- relies on new fields may behave incorrectly when a register information is
-- created with a version of XmlParse that does not support such new fields, or
-- created in an external project with a version of this package that does not
-- have those fields. To catch these problems a version field is used. Every
-- time a new field is added to XReg2_t the version of XmlParse that knows how
-- to assign such field bumps up the value reported on the version field (as
-- long as the PkgXReg in that project supports it as well) and the accessor
-- function (Get*) for that field will check the version to make sure the field
-- info is reliable and not just assigned to a default.
--
-- You may notice comments of the form "XmlParse supports xyz". These are read
-- by XmlParse to know what features this version of the file supports. Don't
-- modify them.
--
-- vreview_group packages
-- vreview_closed http://review-board.natinst.com/r/257847/
-- vreview_closed http://review-board.natinst.com/r/238277/
-- vreview_closed http://review-board.natinst.com/r/222525/
-- vreview_closed http://review-board.natinst.com/r/218352/
-- vreview_closed http://review-board.natinst.com/r/154082/
-- vreview_closed http://review-board.natinst.com/r/151570/
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library work;
  --synopsys translate_off
  use work.PkgNiSim.all;
  --synopsys translate_on

package PkgXReg is

    -- The largest register width supported by XmlParse is kMaxRegVecLen
    constant kMaxRegVecLen : integer := 512;
    subtype XRegVec_t is std_logic_vector(kMaxRegVecLen-1 downto 0);
    type XRegNatVec_t is array(0 to kMaxRegVecLen-1) of natural;

    -- Sets the maximum address width supported by XReg2_t
    constant kXAddrWidth : natural := 64;
    function XAddrResize (Addr : unsigned) return unsigned;


    -- This record is used by XmlParse to create constants holding
    -- information about each register. Earlier versions of XmlParse
    -- created constants with default assignments, so this record
    -- cannot be changed without breaking a lot of code. Newer
    -- versions of XmlParse create functions that return XReg2_t.
    -- This allows fields to be added to XReg2_t without breaking
    -- existing projects. But we're stuck with XReg_t for backwards
    -- compatibility reasons.
    type XReg_t is record
      offset, size : natural;
      readable, writable : boolean;
      mask, strobemask : XRegVec_t;
    end record;

    -- This record is a superset of XReg_t. XmlParse will create
    -- functions that return XReg2_t for each register. The
    -- accessor functions defined in this file provide convenient
    -- access to the fields.
    type XReg2_t is record  --XmlParse supports xreg2
      offset : unsigned(kXAddrWidth-1 downto 0);
      size : natural;
      readable, writable : boolean;
      rmask, wmask, strobemask, initialvalue: XRegVec_t;
      msblookupw, msblookupr : XRegNatVec_t; -- write bitfield array, read bitfield array
      isreg, ismem, iswin : boolean;  --XmlParse supports isreg
      --synopsys translate_off
      name : TestStatusString_t;  --XmlParse supports name
      --synopsys translate_on
      ------- Added in version 1 -------
      version : natural;
      clearablemask : XRegVec_t;
      ------- Tell XML Parse the latest version this file supports ----------
      --XmlParse xreg2version 1
    end record;

    constant kXRegVecOnes : XRegVec_t := (others => '1');
    constant kXRegVecZero : XRegVec_t := (others => '0');
    -- This deferred constant is assigned in the package body
    constant kXRegDefault : XReg2_t;

    -- Resize the argument so that it is kMaxRegVecLen bits
    function XRegResize (X : std_logic_vector) return XRegVec_t;

    -- Return the offset/size
    function GetOffset(X : XReg2_t) return unsigned;
    function GetOffset(X : XReg2_t) return natural;
    function GetSize(X : XReg2_t) return natural;

    -- Return the write, read, strobe and clearable masks
    function GetWtMask(X : XReg2_t) return std_logic_vector;
    function GetRdMask(X : XReg2_t) return std_logic_vector;
    --Note: bits with clearable attribute are also considered strobes for this function
    function GetStrobeMask(X : XReg2_t) return std_logic_vector;
    function GetClearableMask(X : XReg2_t) return std_logic_vector;

    -- Return a bitfield from a register. These are generally useful to decode a writable
    --  field in the register implementation or decode a readable field in the testbench
    -- Note that a register can have different bitfields of different size on the same
    --  location, therefore, a parameter is needed to specify if the bitfield is readable
    --  or writable. The parameter defaults to writable for convenience since that is the
    --  expected use on the register implementation side and the testbench side typically
    --  has wrappers that know the context (read or write).
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return std_logic_vector;
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return natural;
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return std_logic;
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return boolean;

    --Get Msb of a readable or writable bitfield
    function GetMsb(X : XReg2_t; Bf : natural; Rd : boolean) return natural;

    -- Return the initial value of a register or bitfield
    function GetInitialVal(X : XReg2_t) return std_logic_vector;
    function GetInitialVal(X : XReg2_t; Bf : natural) return std_logic_vector;
    function GetInitialVal(X : XReg2_t; Bf : natural) return integer;
    function GetInitialVal(X : XReg2_t; Bf : natural) return std_logic;
    function GetInitialVal(X : XReg2_t; Bf : natural) return boolean;

    --synopsys translate_off
    function GetOffsetStr(X : XReg2_t; MinBitWidth : natural := 16) return string;
    function GetName(X : XReg2_t) return string;
    --synopsys translate_on

end package;
package body PkgXReg is

    function XAddrResize(Addr : unsigned) return unsigned is
    begin
      return resize(Addr, kXAddrWidth);
    end function XAddrResize;

    -- Return a vector of type XRegVec_t. Allows XmlParse to create
    -- masks that are the size of each register. The assumption is
    -- that there won't be a register larger than kMaxRegVecLen.
    function XRegResize (X : std_logic_vector) return XRegVec_t is
      variable Val : XRegVec_t := (others => '0');
    begin
      Val(x'length-1 downto 0) := X;
      return Val;
    end function XRegResize;

    -- Return the default for an XReg
    function XRegDefault return XReg2_t is
      variable X : XReg2_t;
    begin
      X.version := 0;
      X.offset := (others => '0');
      X.size := 32;
      X.readable := true;
      X.writable := true;
      X.wmask := kXRegVecOnes;
      X.rmask := kXRegVecOnes;
      X.strobemask := kXRegVecZero;
      X.clearablemask := kXRegVecZero;
      X.initialvalue := kXRegVecZero;
      -- Default assumes all bitfields are single bits (lsb=msb)
      for i in 0 to kMaxRegVecLen-1 loop
        X.msblookupw(i) := i;
        X.msblookupr(i) := i;
      end loop;
      x.isreg := false;
      x.ismem := false;
      x.iswin := false;
      --synopsys translate_off
      X.name := (others => ' ');
      --synopsys translate_on
      return X;
    end function XRegDefault;

    constant kXRegDefault : XReg2_t := XRegDefault;

    -- Return the offset as unsigned
    function GetOffset(X : XReg2_t) return unsigned is
    begin
      return X.offset;
    end function GetOffset;

    -- Return the offset as natural
    function GetOffset(X : XReg2_t) return natural is
    begin
      return To_Integer(X.offset);
    end function GetOffset;

    -- Return the size as natural
    function GetSize(X : XReg2_t) return natural is
    begin
      return X.size;
    end function GetSize;

    -- Return the write mask
    function GetWtMask(X : XReg2_t) return std_logic_vector is
    begin
      return X.wmask(X.size-1 downto 0);
    end function GetWtMask;

    -- Return the read mask
    function GetRdMask(X : XReg2_t) return std_logic_vector is
    begin
      return X.rmask(X.size-1 downto 0);
    end function GetRdMask;

    -- Return the strobe mask
    function GetStrobeMask(X : XReg2_t) return std_logic_vector is
    begin
      --Note. Using clearablemask directly without checking for version.
      --If clearablemask actually comes from XML, this defines the desired new behavior
      --  (It is equivalent to modifying XmlParse to mark clearable bits as strobes).
      --If clearablemask comes from old XmlParse or old PkgXReg (default to all '0's) then
      --  this is equivalent to old behavior (before XmlParse printed the clearable mask).
      --We do this to avoid breaking existing code that doesn't use clearable bits.
      return X.strobemask(X.size-1 downto 0) or X.clearablemask(X.size-1 downto 0);
    end function GetStrobeMask;

    -- Return the clearable mask
    function GetClearableMask(X : XReg2_t) return std_logic_vector is
    begin
      --synopsys translate_off
      assert X.version >= 1
        report "Called GetClearableMask with an XReg2_t record created with an old version of XmlParse or PkgXReg." & LF &
               "Default value of clearablemask returned may not reflect the actual attribute of the register." & LF &
               "Update the regmap package with the latest version of XmlParse and this (or newer) version of PkgXReg" & LF &
               "Register Name: " & X.name
        severity failure;
      --synopsys translate_on
      return X.clearablemask(X.size-1 downto 0);
    end function GetClearableMask;

    function GetMsb(X : XReg2_t; Bf : natural; Rd : boolean) return natural is
    begin
      if Rd then
        return X.msblookupr(Bf);
      end if;
      return X.msblookupw(Bf);
    end function GetMsb;

    -- Return a bitfield from a register vector as a std_logic_vector
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return std_logic_vector is
    begin
      return Reg(GetMsb(X, Bf, Rd) downto Bf);
    end function GetBitfield;

    -- Return a bitfield from a register vector as a integer
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return natural is
    begin
      return To_Integer(unsigned(Reg(GetMsb(X, Bf, Rd) downto Bf)));
    end function GetBitfield;

    -- Return a bitfield from a register vector as a std_logic
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return std_logic is
    begin
      --synopsys translate_off
      assert GetMsb(X, Bf, Rd)=Bf
        report "Single bit version of GetBitfield called on multi-bit bitfield at lsb=" & integer'image(Bf)
        severity failure;
      --synopsys translate_on
      return Reg(Bf);
    end function GetBitfield;

    -- Return a bitfield from a register vector as a boolean
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return boolean is
    begin
      --synopsys translate_off
      assert GetMsb(X, Bf, Rd)=Bf
        report "Single bit version of GetBitfield called on multi-bit bitfield at lsb=" & integer'image(Bf)
        severity failure;
      --synopsys translate_on
      return Reg(Bf)='1';
    end function GetBitfield;

    -- Return the initial value of a register
    function GetInitialVal(X : XReg2_t) return std_logic_vector is
    begin
      return X.initialvalue(X.size-1 downto 0);
    end function GetInitialVal;

    -- Return the initial value of a bitfield as std_logic_vector
    function GetInitialVal(X : XReg2_t; Bf : natural) return std_logic_vector is
    begin
      --synopsys translate_off
      assert X.msblookupw(Bf)>Bf
        report "Multi-bit version of GetInitialVal called on single bit bitfield at " & integer'image(Bf)
        severity failure;
      --synopsys translate_on
      return X.initialvalue(X.msblookupw(Bf) downto Bf);
    end function GetInitialVal;

    -- Return the initial value of a bitfield as integer
    function GetInitialVal(X : XReg2_t; Bf : natural) return integer is
    begin
      return To_Integer(unsigned(X.initialvalue(X.msblookupw(Bf) downto Bf)));
    end function GetInitialVal;

    -- Return the initial value of a bitfield as std_logic
    function GetInitialVal(X : XReg2_t; Bf : natural) return std_logic is
    begin
      --synopsys translate_off
      assert X.msblookupw(Bf)=Bf
        report "Single bit version of GetInitialVal called on multi-bit bitfield at lsb=" & integer'image(Bf)
        severity failure;
      --synopsys translate_on
      return X.initialvalue(Bf);
    end function GetInitialVal;

    -- Return the initial value of a bitfield as boolean
    function GetInitialVal(X : XReg2_t; Bf : natural) return boolean is
    begin
      return X.initialvalue(Bf)='1';
    end function GetInitialVal;

    --synopsys translate_off

    -- Return the offset of the register/ram/window
    function GetOffsetStr(X : XReg2_t; MinBitWidth : natural := 16) return string is
      variable MinLen : natural;
    begin
      MinLen := MinBitWidth / 4;
      if MinBitWidth mod 4 > 0 then
        MinLen := MinLen + 1;
      end if;
      return 'x' & TrimNumericString(HexImage(X.offset), MinLen);
    end function GetOffsetStr;

    -- Return the name of the register/ram/window
    function GetName(X : XReg2_t) return string is
    begin
      return RemoveTrailingSpaces(X.name);
    end function GetName;

    --synopsys translate_on

end package body;
