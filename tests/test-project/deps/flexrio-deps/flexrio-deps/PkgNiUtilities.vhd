-------------------------------------------------------------------------------
--
-- File: PkgNiUtilities.vhd
-- Author: Paul Butler with substantial advice from Craig Conway
-- Original Project: CHINCH Testing
-- Date: 8 October 2003
--
-------------------------------------------------------------------------------
-- (c) 2003 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
-- PkgNiUtilities will provide some commonly needed functions that are not
-- provided by IEEE packages.
--
-- The type BooleanVector is so named to match the NI style guideline.
-- Future versions of the VHDL spec might choose to add such a type but
-- the name is likely to follow the existing IEEE pattern: boolean_vector.
-- Our name won't collide with that future name so "BooleanVector" is
-- probably a good choice for that reason also.
--
-- The conversions between boolean and std_logic are controversial since
-- '1' is not universally understood to mean "true".  Since active-high
-- logic is more common than active-low, we decided to make the
-- active-high conversions use the "simple" names "to_boolean" and
-- "to_StdLogic".  The active-low versions use the wordy names
-- "to_BooleanActiveLow".  You might prefer to invert the the active-high
-- results but I suggest using the active-low converters since the intent
-- is very explicit.
--
-- In the past, I've written "resize" functions for std_logic_vector that
-- act like the numeric_std resize function for unsigned.  That strategy
-- is weak since std_logic_vector is not always an unsigned binary number.
-- We often want to zero pad on the right instead of left, or maybe even
-- in the middle.  The two functions "Zeros" and "Ones" are intended to
-- solve that problem, especially when creating readable registers with
-- some unused bits:
--
-- signal StatusData : std_logic_vector(15 downto 0);
-- ...
-- StatusData <= Zeros(13) & InterruptStatus & DMARequest & OverflowError;
--
-- Log2 is intended to help write reusable components. Check out the
-- example comment over the Log2 function in the package body.
--
-- I think the Smaller and Larger functions might reasonably be called Min
-- and Max.  Unfortunately, the function name Min collides with the "min"
-- (minutes) defined in STD.Standard package.  To use a min function, it
-- must be called "long hand" as in WORK.PkgNiUtilities.Min(1,2).
--
-- Reviewers: Paul Butler, Craig Conway
-- ReviewBoard: http://review-board.natinst.com/r/28738/
--
-- vreview_group packages
-- vreview_closed http://review-board.natinst.com/r/257847/
-- vreview_closed http://review-board.natinst.com/r/238277/
-- vreview_closed http://review-board.natinst.com/r/218352/
-- vreview_closed http://review-board.natinst.com/r/154082/
-- vreview_closed http://review-board.natinst.com/r/151570/
-- vreview_closed http://review-board.natinst.com/r/149662/
-- vreview_closed http://review-board.natinst.com/r/112173/
-- vreview_closed http://review-board.natinst.com/r/111463/
-- vreview_closed http://review-board.natinst.com/r/90009/
-- vreview_closed http://review-board.natinst.com/r/79838/
--
-------------------------------------------------------------------------------
library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

Package PkgNiUtilities is

  -----------------------------------------------------------------------------
  -- Clock type
  -----------------------------------------------------------------------------

  type NiClk_t is record
    -- C is the actual clock signal
    C : std_logic;
    -- kSyncCnt is the number of synchronizers needed when taking an asynchronous
    -- signal into this clock domain. This number will be dependent on the clock
    -- frequency and the target technology. You must set kSyncCnt to at least 2
    -- (indicating 1 metastable flop and 1 flop after) and should ensure that
    -- kSyncCnt * ClkPeriod is at least 5 ns.
    -- Note that this field should be driven by a constant. If you drive it with
    -- a signal, it will likely synthesize just fine, but you'll end up with a
    -- bunch of flops and a mux. If you have not restricted the size of the
    -- signal driving kSyncCnt, that "bunch of flops" could be integer'high.
    kSyncCnt : positive;
  end record;

  constant kNiClkDef : NiClk_t := ('0', 2);

  -- These two functions allow you to create the NiClk_t record. The intent is for
  -- them to be used as actuals in a port map so that it is easy to connect a std_logic
  -- clock signal to an NI module that uses NiClk_t. They can also be used to create
  -- the initial NiClk_t record at the output of the clock generator.
  -- It is important to try to create NiClk_t in a way that delta cycles do not get
  -- inserted into the clock path.
  -- Also, note that Synopsys does not support functions in actuals at all, so
  -- if your code is to be used in an ASIC, you should associate the proper values
  -- with the fields of the formal's record using the --vhook_af command.
  -- Create NiClk_t record
  function ToNiClk (ClkIn : std_logic; SyncCnt : positive) return NiClk_t;
  -- Create NiClk_t record with kSyncCnt set to 2
  function ToNiClk2 (ClkIn : std_logic) return NiClk_t;

  -- These two functions allow an NiClk_t signal to have edge detection on the
  -- .C field, allowing the user to do this:
  --    if rising_edge(MyClk)
  -- instead of this:
  --    if rising_edge(MyClk.C)
  function rising_edge(signal Clk : NiClk_t) return boolean;
  function falling_edge(signal Clk : NiClk_t) return boolean;

  -----------------------------------------------------------------------------
  -- Useful array types
  -----------------------------------------------------------------------------

  type BooleanVector is array ( natural range<> ) of boolean;
  type IntegerVector is array ( natural range <>) of integer;
  type NaturalVector is array ( natural range <>) of natural;
  type Slv64Ary_t is array ( natural range <> ) of std_logic_vector(63 downto 0);
  type Slv32Ary_t is array ( natural range <> ) of std_logic_vector(31 downto 0);
  type Slv16Ary_t is array ( natural range <> ) of std_logic_vector(15 downto 0);

  -----------------------------------------------------------------------------
  -- Type Conversion functions
  -----------------------------------------------------------------------------

  -- active high conversion, '1' -> true
  function to_Boolean (s : std_ulogic) return boolean;

  -- active low conversion, '0' -> true
  function to_BooleanActiveLow (s : std_ulogic) return boolean;

  -- active high conversion, "10" -> (true, false)
  function to_BooleanVector(s : std_logic_vector) return BooleanVector;
  function to_BooleanVector(s : unsigned) return BooleanVector;

  -- active high conversion, "10" -> (false, true)
  function to_BooleanVectorActiveLow(s : std_logic_vector)
                                     return BooleanVector;

  -- active high conversion, true -> '1'
  function to_StdLogic(b : boolean) return std_ulogic;

  -- active low conversion, false -> '1'
  function to_StdLogicActiveLow(b : boolean) return std_ulogic;

  -- active high conversion, (true, false) -> "10"
  function to_StdLogicVector(b : BooleanVector) return std_logic_vector;
  function to_Unsigned(b : BooleanVector) return unsigned;

  -- active high conversion, (true, false) -> "01"
  function to_StdLogicVectorActiveLow(b : BooleanVector) return std_logic_vector;
  function to_UnsignedActiveLow(b : BooleanVector) return unsigned;

  -----------------------------------------------------------------------------
  -- Misc functions
  -----------------------------------------------------------------------------

  -- returns a std_logic_vector with Length bits, all set to '0'
  function Zeros(Length : natural) return std_logic_vector;

  -- returns a std_logic_vector with Length bits, all set to '1'
  function Ones(Length : natural) return std_logic_vector;

  -- returns ceiling of base-2/4 logarithm
  function Log2(arg : positive) return natural;
  function Log4(arg : positive) return natural;

  -- returns the number of ones in a std_logic_vector
  function CountOnes(arg : std_logic_vector) return natural;

  -- returns the number of ones in an unsigned
  function CountOnes(arg : unsigned) return natural;

  -- returns true if the argument is a power of 2
  function IsPowerOf2(arg : unsigned) return boolean;

  -- returns true if the argument is a power of 2
  function IsPowerOf2(arg : natural) return boolean;

  -----------------------------------------------------------------------------
  -- Misc global definitions
  -----------------------------------------------------------------------------

  constant kByteSize : natural := 8;

  --********************************************************
  --  Commenting this code because Talus (MAGMA) doesn't compile it.
  --  It does not support clock statements in procedures.
  --  Still evaluating if we will move this code somewhere else.
  --********************************************************
  -----------------------------------------------------------------------------
  -- Shift Registers
  -----------------------------------------------------------------------------

  -- This procedure creates a std_logic shift register whose width
  -- is determined by Q'length
  -- Copy the line below to make instantiation easier:
  -- --ShiftInSL(D=>D, Clk=>Clk, cRst=>cReset, aRst=>acReset, Q=>Q);
  -- procedure ShiftInSL(kRstVal : in std_logic := '0';
  --                     D : in std_logic;
  --                     signal Clk : in std_logic;
  --                     En : in boolean := true;
  --                     cRst, aRst : in boolean := false;
  --                     signal Q : inout std_logic_vector);

  -- This procedure creates a boolean shift register whose width
  -- is determined by Q'length
  -- Copy the line below to make instantiation easier:
  --ShiftInBool(D=>D, Clk=>Clk, cRst=>cReset, aRst=>acReset, Q=>Q);
  -- procedure ShiftInBool(kRstVal : in boolean := false;
  --                       D : in boolean;
  --                       signal Clk : in std_logic;
  --                       En : in boolean := true;
  --                       cRst, aRst : in boolean := false;
  --                       signal Q : inout BooleanVector);


  -----------------------------------------------------------------------------
  -- Size Comparison functions
  -----------------------------------------------------------------------------

  -- returns the bigger of the two inputs
  function Larger(a,b : integer) return integer;

  -- Max is just another way to call Larger.
  -- Alias is not supported by Synplicity 7.2
  -- Uncomment the alias declaration in the future
  --alias Max is Larger [integer, integer return integer];

  -- returns the smaller of the two inputs
  function Smaller(a,b : integer) return integer;

  -- Min is another way to call Smaller.  However, when calling Min, you
  -- must use the expanded name "WORK.PkgNiUtilities.Min(x,y)" to avoid
  -- collisions with the abbreviation for "minutes" defined in
  -- STD.Standard.  Calling Smaller is probably simpler.
  -- Alias is not supported by Synplicity 7.2
  -- Uncomment the alias declaration in the future
  --alias Min is Smaller [integer, integer return integer];

  -----------------------------------------------------------------------------
  -- Vector And/Or functions
  -----------------------------------------------------------------------------

  -- These functions return the "OR" of every bit of the vector passed in
  function OrVector (arg : std_logic_vector) return std_ulogic;
  function OrVector (arg : unsigned) return std_ulogic;
  function OrVector (arg : BooleanVector) return boolean;

  -- These functions return the "AND" of every bit of the vector passed in
  function AndVector (arg : std_logic_vector) return std_ulogic;
  function AndVector (arg : unsigned) return std_ulogic;
  function AndVector (arg : BooleanVector) return boolean;

  -- These functions return the "XOR" of every bit of the vector passed in
  function XorVector (arg : std_logic_vector) return std_ulogic;
  function XorVector (arg : unsigned) return std_ulogic;
  function XorVector (arg : BooleanVector) return boolean;

  -----------------------------------------------------------------------------
  --  Functions for setting bits/fields within a vector
  --  All of these functions return a std_logic_vector with a range of
  -- (W-1 downto 0), where W defaults to 32 if it is not specified.
  -----------------------------------------------------------------------------

  -- Examples:
  --
  -- Return a 32-bit vector with bits 5, 16, and 18 set
  -- kVec32 <= SetBits((5, 16, 18));
  --
  -- Notice that the natural array must be enclosed in parenthesis, so you
  -- must have double parens when you call SetBits.  Here's another way to
  -- get the same result that might make the reason for the extra parens
  -- more clear:
  -- kVec32 <= SetBits(Indices=>(5, 16, 18));
  --
  -- Return a 64-bit vector with bits 2, 4, 6, and 63 set
  -- kVec64 <= SetBits((2, 4, 6, 63), 64);
  --   alternatively
  -- kVec64 <= SetBits(Indices=>(2, 4, 6, 63), W=>64);
  --
  -- Return a 32 bit vector with bit 3 set
  -- kVec32 <= SetBit(3);
  --
  -- Return a 32 bit vector with bit kBobBit taking on the value of a signal called xBob
  -- and bit kJoeBit taking on the value of a signal called xJoe
  -- xVec32 <= SetBit(kBobBit, xBob) or SetBit(kJoeBit, xJoe);
  --
  -- Return a 32-bit vector where bit kBob is set to xBob and the xJoeField vector is
  -- assigned to the bits starting at bit kJoe
  -- xVec32 <= SetBit(kBobBit, xBob) or SetField(kJoe, xJoeField);
  --
  -- Note that xJoeField can be an integer, an unsigned, or a std_logic_vector.
  --
  -- Let's say we have a readable register.  Here's the old way to do it:
  --
  -- process (mBob, mJoeField, mIoPortIn)
  -- begin
  --   mVec32 <= (others => '0');
  --   if RegSelected(MyReg, mIoPortIn) then
  --     mVec32(kBobBit) <= xBob;
  --     mVec32(kJoeFieldMsb downto kJoeField) <= mJoeField;
  --   end if;
  -- end process;
  --
  -- And here's the new way:
  --
  -- mVec32 <= SetBit(kBobBit, mBob) or SetField(kJoeField, mJoeField)
  --              when RegSelected(MyReg, mIoPortIn) else (others => '0');
  --
  -- These functions are also useful in testbenches when writing and reading
  -- registers.  Consider the old way:
  --
  -- Data := (others => '0');
  -- Data(kBob) := '1';
  -- Data(kJoeFieldMsb downto kJoeField)
  --              := std_logic_vector(To_Unsigned(19,kJoeFieldSize));
  -- WriteIoPort(MyReg, Data);
  --
  -- And now the new way:
  --
  -- WriteIoPort(MyReg, SetBit(kBob) or SetField(kJoeField, 19));

  -- The previous version of the following SetBits and SetField
  -- functions used to assign a default value of 32 for the W parameter.
  -- That exposed a bug in ISE 10.1 when calling SetBit with W set to
  -- something less than 32.  In some cases, using a W value less than
  -- 32 would cause SetBit to return all '0'.  To work around the
  -- problem, I duplicated each of the functions:  one version with W
  -- (but without a default value) and another version with no W
  -- parameter at all.  The version of the functions that omit the W
  -- parameter all return a 32 bit result.  Existing code that relies on
  -- the default value for W will continue to compile, but those
  -- function calls will now match the signature of the function that
  -- has no W parameter at all.
  function SetBits(Indices : NaturalVector; W : natural) return std_logic_vector;
  function SetBits(Indices : NaturalVector) return std_logic_vector;

  function SetBit(Index : natural;
                  Val : std_logic;
                  W : natural) return std_logic_vector;
  function SetBit(Index : natural;
                  Val : std_logic) return std_logic_vector;

  function SetBit(Index : natural; W : natural) return std_logic_vector;
  function SetBit(Index : natural) return std_logic_vector;

  function SetBit(Index : natural;
                  Val : boolean;
                  W : natural) return std_logic_vector;
  function SetBit(Index : natural;
                  Val : boolean) return std_logic_vector;

  function SetField(Index : natural;
                    Val : unsigned;
                    W : natural) return std_logic_vector;
  function SetField(Index : natural;
                    Val : unsigned) return std_logic_vector;

  function SetField(Index : natural;
                    Val : std_logic_vector;
                    W : natural) return std_logic_vector;
  function SetField(Index : natural;
                    Val : std_logic_vector) return std_logic_vector;

  function SetField(Index : natural;
                    Val : natural;
                    W : natural) return std_logic_vector;
  function SetField(Index : natural;
                    Val : natural) return std_logic_vector;

end Package PkgNiUtilities;

Package body PkgNiUtilities is

  -- Creat an NiClk_t record.
  -- This function makes it easy to connect a std_logic clock
  -- signal to a module that uses NiClk_t as its input.
  function ToNiClk (ClkIn : std_logic; SyncCnt : positive) return NiClk_t is
    variable ClkOut : NiClk_t;
  begin
    ClkOut.C := ClkIn;
    ClkOut.kSyncCnt := SyncCnt;
    return ClkOut;
  end function ToNiClk;

  -- Return an NiClk_t record with the kSyncCnt field set to 2.
  -- This function makes it easy to connect a std_logic clock
  -- signal to a module that uses NiClk_t as its input and maintain
  -- compatibility with the original NiCores clock crossing components.
  -- Note that this will not work for Synopsys compilers as they do
  -- not support functions as actuals. Only use this function
  -- as an actual for FPGAs.
  function ToNiClk2 (ClkIn : std_logic) return NiClk_t is
  begin
    return ToNiClk(ClkIn, 2);
  end function ToNiClk2;

  -- Return true if the .C field of the input has a rising edge
  function rising_edge(signal Clk : NiClk_t) return boolean is
  begin
    return rising_edge(Clk.C);
  end function rising_edge;

  -- Return true if the .C field of the input has a falling edge
  function falling_edge(signal Clk : NiClk_t) return boolean is
  begin
    return falling_edge(Clk.C);
  end function falling_edge;


  -- The main strategy of the converter implementations is to write one
  -- or two functions that define the behavior.  All the other functions
  -- define their behavior by calling the base functions.
  --
  -- In this case, to_Boolean and to_StdLogic are the base functions.
  -- The vector converters simply call the base functions iteratively.
  -- The active-low converters merely invert the results of the base
  -- functions.
  --
  -- This approach probably reduces the amount of code, but it also
  -- concentrates the behavior into a small place.  If the single bit
  -- converters are correct, then bugs in the vector converters are
  -- almost guaranteed to relate to the iteration but not the
  -- conversions themselves.

  -- define the base conversion
  -- Unlike the IEEE defined:
  --   function to_bit(s : stdulogic; xmap : bit) return bit;
  -- Our converter does not allow any configuration for the case when
  -- the input has a meta-value.  Hopefully, we're guessing correctly.
  function to_Boolean (s : std_ulogic) return boolean is
  begin
    return (To_X01(s)='1');
  end to_Boolean;

  -- A base converson based on an existing operator ("not")
  function to_BooleanActiveLow (s : std_ulogic) return boolean is
  begin
    return (To_X01(s)='0');
  end to_BooleanActiveLow;

  -- A derivative converter using the base converter
  function to_BooleanVector(s : std_logic_vector) return BooleanVector is
    variable rval : BooleanVector(s'range);
  begin
    for i in rval'range loop
      rval(i) := to_Boolean(s(i));
    end loop;
    return rval;
  end to_BooleanVector;

  -- A derivative converter using the base converter
  function to_BooleanVector(s : unsigned) return BooleanVector is
  begin
    return to_BooleanVector(std_logic_vector(s));
  end to_BooleanVector;

  -- A derivative converter using an existing operator ("not")
  function to_BooleanVectorActiveLow(s : std_logic_vector)
                                     return BooleanVector is
    variable rval : BooleanVector(s'range);
  begin
    for i in rval'range loop
      rval(i) := to_BooleanActiveLow(s(i));
    end loop;
    return rval;
  end to_BooleanVectorActiveLow;

  -- The base conversion
  function to_StdLogic(b : boolean) return std_ulogic is
  begin
    if b then
      return '1';
    else
      return '0';
    end if;
  end to_StdLogic;

  function to_StdLogicActiveLow(b : boolean) return std_ulogic is
  begin
    return not to_StdLogic(b);
  end to_StdLogicActiveLow;

  function to_StdLogicVector(b : BooleanVector) return std_logic_vector is
    variable rval : std_logic_vector(b'range);
  begin
    for i in rval'range loop
      rval(i) := to_StdLogic(b(i));
    end loop;
    return rval;
  end to_StdLogicVector;

  function to_Unsigned(b : BooleanVector) return unsigned is
  begin
    return unsigned(to_StdLogicVector(b));
  end to_Unsigned;

  function to_StdLogicVectorActiveLow(b : BooleanVector)
                                      return std_logic_vector is
  begin
    return not to_StdLogicVector(b);
  end to_StdLogicVectorActiveLow;

  function to_UnsignedActiveLow(b : BooleanVector) return unsigned is
  begin
    return unsigned(to_StdLogicVectorActiveLow(b));
  end to_UnsignedActiveLow;

  function Zeros(Length : natural) return std_logic_vector is
    variable Vec: std_logic_vector(1 to Length) := (others => '0');
  begin
    return Vec;
  end Zeros;

  function Ones(Length : natural) return std_logic_vector is
    variable Vec: std_logic_vector(1 to Length) := (others => '1');
  begin
    return Vec;
  end Ones;

  -- Log2 returns the ceiling of a base-2 logarithm.  Example application:
  --
  -- entity mux is
  --   generic(
  --     width : integer := 32
  --   );
  --   port(
  --     Din : in std_logic_vector(width-1 downto 0);
  --     Sel : in unsigned(log2(width)-1 downto 0);
  --     Dout : out std_logic
  --   );
  -- end mux;
  function Log2(Arg : positive) return natural is
    variable ReturnVal : natural;
    variable ShiftedArg : natural;
  begin
    ReturnVal := 0;
    ShiftedArg := Arg-1;
    while ShiftedArg > 0 loop
      ShiftedArg := ShiftedArg / 2;
      ReturnVal := ReturnVal + 1;
    end loop;
    return ReturnVal;
  end Log2;

  -- Log4 returns the ceiling of a base-4 logarithm.
  function Log4(Arg : positive) return natural is
    variable ReturnVal : natural;
    variable ShiftedArg : natural;
  begin
    ReturnVal := 0;
    ShiftedArg := Arg-1;
    while ShiftedArg > 0 loop
      ShiftedArg := ShiftedArg / 4;
      ReturnVal := ReturnVal + 1;
    end loop;
    return ReturnVal;
  end Log4;

  -- returns the number of ones in a std_logic_vector
  function CountOnes(arg : std_logic_vector) return natural is
    -- argNormal just adjusts the index range for simpler arithmetic
    variable argNormal : std_logic_vector(1 to arg'length) := arg;
    constant kMidPoint : natural := arg'length / 2;
  begin

    if arg'length = 0 then
      return 0;
    elsif arg'length = 1 then
      if To_Boolean(argNormal(1)) then
        return 1;
      else 
        return 0;
      end if;
    else
      return CountOnes(argNormal(1 to kMidPoint)) 
           + CountOnes(argNormal(kMidPoint + 1 to argNormal'high));
    end if;

  end function CountOnes;

  -- returns the number of ones in an unsigned
  function CountOnes(arg : unsigned) return natural is
  begin
    return CountOnes(std_logic_vector(arg));
  end function CountOnes;

  -- returns true if the argument is a power of 2
  function IsPowerOf2(arg : unsigned) return boolean is
  begin
    return CountOnes(arg) = 1;
  end function IsPowerOf2;

  -- returns true if the argument is a power of 2
  function IsPowerOf2(arg : natural) return boolean is
  begin
    return IsPowerOf2(To_Unsigned(arg,32));
  end function IsPowerOf2;



  --********************************************************
  --  Commenting this code because Talus (MAGMA) doesn't compile it.
  --  It does not support clock statements in procedures.
  --  Still evaluating if we will move this code somewhere else.
  --********************************************************

  -- The ShiftIn* procedures create a shift register whose width
  -- is determined by Q'length. The shift register will shift in a single
  -- bit into the Q'low position, moving the shift register toward the high
  -- index of the range, so both Q(X downto 0) and Q(0 to X) would shift in D
  -- at bit 0 and shift out at X.

  -- -- Create a std_logic shift register
  -- procedure ShiftInSL(kRstVal : in std_logic := '0';
  --                     D : in std_logic;
  --                     signal Clk : in std_logic;
  --                     En : in boolean := true;
  --                     cRst, aRst : in boolean := false;
  --                     signal Q : inout std_logic_vector) is
  -- begin
  --   if aRst then
  --     Q <= (Q'range => kRstVal);
  --   elsif rising_edge(Clk) then
  --     if En then
  --       if cRst then
  --         Q <= (Q'range => kRstVal);
  --       else
  --         if Q'ascending then
  --           Q <= Q(Q'low+1 to Q'high) & D;
  --         else
  --           Q <= Q(Q'high-1 downto Q'low) & D;
  --         end if;
  --       end if;
  --     end if;
  --   end if;
  -- end procedure ShiftInSL;

  -- -- Create a boolean shift register
  -- procedure ShiftInBool(kRstVal : in boolean := false;
  --                       D : in boolean;
  --                       signal Clk : in std_logic;
  --                       En : in boolean := true;
  --                       cRst, aRst : in boolean := false;
  --                       signal Q : inout BooleanVector) is
  -- begin
  --   if aRst then
  --     Q <= (Q'range => kRstVal);
  --   elsif rising_edge(Clk) then
  --     if En then
  --       if cRst then
  --         Q <= (Q'range => kRstVal);
  --       else
  --         if Q'ascending then
  --           Q <= Q(Q'low+1 to Q'high) & D;
  --         else
  --           Q <= Q(Q'high-1 downto Q'low) & D;
  --         end if;
  --       end if;
  --     end if;
  --   end if;
  -- end procedure ShiftInBool;

  -- returns the larger of two integers
  function Larger(a,b : integer) return integer is
  begin
    if a > b then
      return a;
    else
      return b;
    end if;
  end Larger;

  -- returns the smaller of two integers
  function Smaller(a,b : integer) return integer is
  begin
    if a < b then
      return a;
    else
      return b;
    end if;
  end Smaller;

  -- These functions return the "OR" of every bit of the vector passed in
  function OrVector (arg : std_logic_vector) return std_ulogic is
    variable ReturnVal : std_ulogic;
  begin
    ReturnVal := '0';
    for i in arg'range loop
      ReturnVal := ReturnVal or arg(i);
    end loop;
    return ReturnVal;
  end OrVector;

  function OrVector (arg : unsigned) return std_ulogic is
  begin
    return OrVector(std_logic_vector(arg));
  end OrVector;

  function OrVector (arg : BooleanVector) return boolean is
  begin
    return To_Boolean(OrVector(To_StdLogicVector(arg)));
  end OrVector;

  -- These functions return the "AND" of every bit of the vector passed in
  function AndVector (arg : std_logic_vector) return std_ulogic is
    variable ReturnVal : std_ulogic;
  begin
    ReturnVal := '1';
    for i in arg'range loop
      ReturnVal := ReturnVal and arg(i);
    end loop;
    return ReturnVal;
  end AndVector;

  function AndVector (arg : unsigned) return std_ulogic is
  begin
    return AndVector(std_logic_vector(arg));
  end AndVector;

  function AndVector (arg : BooleanVector) return boolean is
  begin
    return To_Boolean(AndVector(To_StdLogicVector(arg)));
  end AndVector;

  -- These functions return the "XOR" of every bit of the vector passed in
  function XorVector (arg : std_logic_vector) return std_ulogic is
    variable ReturnVal : std_ulogic;
  begin
    ReturnVal := '0';
    for i in arg'range loop
      ReturnVal := ReturnVal Xor arg(i);
    end loop;
    return ReturnVal;
  end XorVector;

  function XorVector (arg : unsigned) return std_ulogic is
  begin
    return XorVector(std_logic_vector(arg));
  end XorVector;

  function XorVector (arg : BooleanVector) return boolean is
  begin
    return To_Boolean(XorVector(To_StdLogicVector(arg)));
  end XorVector;


  -----------------------------------------------------------------------------
  -- Functions for setting bits and bitfields within a vector
  -----------------------------------------------------------------------------

  -- Returns a std_logic_vector with the bits corresponding to Indices set.
  function SetBits(Indices : NaturalVector; W : natural) return std_logic_vector is
    variable Data : std_logic_vector(W-1 downto 0);
  begin
    Data := (others => '0');
    for i in Indices'range loop
      Data(Indices(i)) := '1';
    end loop;
    return Data;
  end function SetBits;

  function SetBits(Indices : NaturalVector) return std_logic_vector is
  begin
    return SetBits ( Indices=>Indices, W=>32 );
  end function SetBits;

  -- Returns a std_logic_vector with bit(Index) set to Sig
  function SetBit(Index : natural;
                  Val : std_logic;
                  W : natural) return std_logic_vector is
    variable Data : std_logic_vector(W-1 downto 0);
  begin
    --synopsys translate_off
    assert Index < W
      report "SetBit: Index (" & integer'image(Index) & ") must be less than W (" & integer'image(W) & ")"
      severity error;
    --synopsys translate_on
    Data := (others => '0');
    Data(Index) := Val;
    return Data;
  end function SetBit;

  function SetBit(Index : natural;
                  Val : std_logic ) return std_logic_vector is
  begin
    return SetBit ( Index=>Index, Val=>Val, W=>32 );
  end function SetBit;

  -- Returns a std_logic_vector with the bit corresponding to Index set.
  function SetBit(Index : natural; W : natural) return std_logic_vector is
  begin
    return SetBit(Index=>Index, Val=>'1', W=>W);
  end function SetBit;

  function SetBit(Index : natural) return std_logic_vector is
  begin
    return SetBit ( Index=>Index, W=>32 );
  end function SetBit;

  -- Returns a std_logic_vector with bit(Index) set to Sig
  function SetBit(Index : natural;
                  Val : boolean;
                  W : natural) return std_logic_vector is
  begin
    return SetBit(Index=>Index, Val=>To_StdLogic(Val), W=>W);
  end function SetBit;

  function SetBit(Index : natural;
                  Val : boolean) return std_logic_vector is
  begin
    return SetBit ( Index=>Index, Val=>Val, W=>32 );
  end function SetBit;

  -- Returns a std_logic_vector that has Val returned at
  -- the bit position indicated by Index.
  function SetField(Index : natural;
                    Val : unsigned;
                    W : natural) return std_logic_vector is
    variable Data : std_logic_vector(W-1 downto 0) := (others => '0');
  begin
    --synopsys translate_off
    assert Index < W
      report "SetField: Index (" & integer'image(Index) & ") must be less than W (" & integer'image(W) & ")"
      severity error;
    assert (Val'length + Index) <= W
      report "Val is too big to fit in vector" severity error;
    --synopsys translate_on
    Data(W-1 downto Index) := std_logic_vector(resize(Val, W-Index));
    return Data;
  end function SetField;

  function SetField(Index : natural;
                    Val : unsigned) return std_logic_vector is
  begin
    return SetField ( Index=>Index, Val=>Val, W=>32 );
  end function SetField;

  -- Returns a std_logic_vector that has Val returned at
  -- the bit position indicated by Index.
  function SetField(Index : natural;
                    Val : std_logic_vector;
                    W : natural) return std_logic_vector is
  begin
    return SetField(Index=>Index, Val=>unsigned(Val), W=>W);
  end function SetField;

  function SetField(Index : natural;
                    Val : std_logic_vector) return std_logic_vector is
  begin
    return SetField ( Index=>Index, Val=>Val, W=>32 );
  end function SetField;

  -- Returns a std_logic_vector that has Val returned at
  -- the bit position indicated by Index.
  function SetField(Index : natural;
                    Val : natural;
                    W : natural) return std_logic_vector is
  begin
    return SetField(Index=>Index, Val=>To_Unsigned(Val, W-Index), W=>W);
  end function SetField;

  function SetField(Index : natural;
                    Val : natural) return std_logic_vector is
  begin
    return SetField(Index=>Index, Val=>Val, W=>32);
  end function SetField;

end Package body PkgNiUtilities;

