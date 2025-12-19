-------------------------------------------------------------------------------
--
-- File: PkgCommunicationInterface.vhd
-- Author: Hector Rubio
-- Original Project: NI DMA IP
-- Date: 25 September 2014
--
-------------------------------------------------------------------------------
-- (c) 2014 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
-- Local version of this file that should be provided by LabVEIW to LabVIEW
--  clients. It is needed to define the types of the register ports  that we create
--  on the exported wrappers of the PCIe InChWORM so it connects directly to LabVIEW
--
-- A local version allows us to compile local testbenches
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

package PkgCommunicationInterface is

  subtype InterfaceData_t is std_logic_vector(31 downto 0);

  -- The whole communication interface is 32bits by design. Therefore
  -- we are removing bits 0 and 1 of the address to obtain 32bits
  -- aligned address.

  constant kAlignedAddressWidth : positive := 17; --19 - 2

  -- RegPortIn contains the address plus 32 bits of data, a read
  -- signal and a write signal (32 + 1 + 1 = 34)

  constant kRegPortInSize  : positive := kAlignedAddressWidth + 34;

  -- RegPortOut contains 32 bits of data, a DataValid signal and
  -- a Ready signal (32 + 1 + 1 = 34)

  constant kRegPortOutSize : positive := 34;

  -----------------------------------------------------------------------------
  -- Type Definitions
  -----------------------------------------------------------------------------

  -- The type of the signal used to communicate from the Interface
  -- component to the frameworks
  type RegPortIn_t is record
    Address : unsigned(kAlignedAddressWidth - 1 downto 0);
    Data    : InterfaceData_t;
    Rd      : boolean;                  -- Must be a one clock cycle pulse
    Wt      : boolean;                  -- Must be a one clock cycle pulse
  end record;

  -- The type of the signal used to communicate to the Interface
  -- component from the frameworks
  -- Ready is just the Ready signal from the Handshake component.
  -- Address in RegPortIn_t should be valid in the cycle where Data, DataValid,
  -- or Ready are being sampled by the bus communication interface.
  type RegPortOut_t is record
    Data      : InterfaceData_t;
    DataValid : boolean;                -- Must be a one clock cycle pulse
    Ready     : boolean;                -- Must be valid one clock after Wt assertion
  end record;

  -- The array containing all the signals from all the frameworks
  type RegPortOutArray_t is array (natural range<>) of RegPortOut_t;
  function SelectPort(arg : RegPortOutArray_t) return RegPortOut_t;
  -- Constants for the RegPort
  constant kRegPortInZero : RegPortIn_t := (
    Address => to_unsigned(0,kAlignedAddressWidth),
    Data => (others => '0'),
    Rd => false,
    Wt => false);

  constant kRegPortOutZero : RegPortOut_t := (
    Data => (others=>'0'),
    DataValid => false,
    Ready => true);

  function BuildRegPortIn(
    arg  : std_logic_vector(kRegPortInSize-1 downto 0))
    return RegPortIn_t;

  function BuildRegPortOut(
    arg : std_logic_vector(kRegPortOutSize-1 downto 0))
    return RegPortOut_t;

  function to_StdLogicVector(arg : RegPortIn_t) return std_logic_vector;
  function to_StdLogicVector(arg : RegPortOut_t) return std_logic_vector;

end PkgCommunicationInterface;

package body PkgCommunicationInterface is

  -- This function prints one hot mux
  function SelectPort(arg : RegPortOutArray_t) return RegPortOut_t is

    type Array_t is array (arg'range) of InterfaceData_t;

    variable ReturnVal     : RegPortOut_t;
    -- ArrayToBeOred may seem a weird name as it is first used in the AND stage
    -- of the OneHot Mux, but it gets ORed ultimately :-)
    variable ArrayToBeOred : Array_t;
  begin

    -- Zero out input vector based on the DataValid
    for i in arg'range loop
      if arg(i).DataValid then
        ArrayToBeOred(i) := arg(i).Data;
      else
        ArrayToBeOred(i) := (others => '0');
      end if;
    end loop;

    -- Init values
    ReturnVal.Data      := (others => '0');
    ReturnVal.DataValid := false;
    ReturnVal.Ready     := true;

    for i in ArrayToBeOred'range loop
      ReturnVal.Data      := ReturnVal.Data or ArrayToBeOred(i);
      ReturnVal.DataValid := ReturnVal.DataValid or arg(i).DataValid;
      ReturnVal.Ready     := ReturnVal.Ready and arg(i).Ready;
    end loop;

    return ReturnVal;

  end SelectPort;

  function BuildRegPortOut(arg : std_logic_vector(kRegPortOutSize - 1 downto 0))
      return RegPortOut_t is
    variable ReturnVal : RegPortOut_t;
  begin
    ReturnVal.Data      := arg(31 downto 0);
    ReturnVal.DataValid := to_Boolean(arg(32));
    ReturnVal.Ready     := to_Boolean(arg(33));
    return ReturnVal;
  end BuildRegPortOut;

  function BuildRegPortIn(arg : std_logic_vector(kRegPortInSize - 1 downto 0))
      return RegPortIn_t is
    variable ReturnVal : RegPortIn_t;
  begin
    ReturnVal.Data    := arg(31 downto 0);
    ReturnVal.Address := unsigned(arg(kRegPortInSize - 3 downto 32));
    ReturnVal.Wt      := to_Boolean(arg(kRegPortInSize - 2));
    ReturnVal.Rd      := to_Boolean(arg(kRegPortInSize - 1));
    return ReturnVal;
  end BuildRegPortIn;

  function to_StdLogicVector(arg : RegPortOut_t) return std_logic_vector is
    variable ReturnVal : std_logic_vector(kRegPortOutSize - 1 downto 0);
  begin
    ReturnVal := to_StdLogic(arg.Ready) & to_StdLogic(arg.DataValid) & arg.Data;
    return ReturnVal;
  end to_StdLogicVector;

  function to_StdLogicVector(arg : RegPortIn_t) return std_logic_vector is
    variable ReturnVal : std_logic_vector(kRegPortInSize - 1 downto 0);
  begin
    ReturnVal := to_StdLogic(arg.Rd) &
                 to_StdLogic(arg.Wt) &
                 std_logic_vector(arg.Address) &
                 arg.Data;
    return ReturnVal;

  end to_StdLogicVector;


end PkgCommunicationInterface;