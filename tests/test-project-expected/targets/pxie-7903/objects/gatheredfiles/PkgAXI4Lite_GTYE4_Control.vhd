-- 
-- This file was automatically processed for release on GitHub
-- All comments were removed and this header was added
-- 
-- 
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
-- 
-- 


















library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package PkgAXI4Lite_GTYE4_Control is

  
  subtype GTRefClkSel_t is std_logic_vector(2 downto 0);
  type GTRefClkSelAry_t is array(natural range <>) of GTRefClkSel_t;

  subtype GTClkSel_t is std_logic_vector(1 downto 0);
  type GTClkSelAry_t is array(natural range <>) of GTClkSel_t;

  subtype GTOutClkSel_t is std_logic_vector(2 downto 0);
  type GTOutClkSelAry_t is array(natural range <>) of GTOutClkSel_t;

  subtype GTPrbsSel_t is std_logic_vector(3 downto 0);
  type GTPrbsSelAry_t is array(natural range <>) of GTPrbsSel_t;

  subtype GTRateSel_t is std_logic_vector(2 downto 0);
  type GTRateSelAry_t is array(natural range <>) of GTRateSel_t;

  subtype GTYCursorSel_t is std_logic_vector(4 downto 0);
  type GTYCursorSelAry_t is array(natural range <>) of GTYCursorSel_t;

  subtype GTYDiffCtrl_t is std_logic_vector(4 downto 0);
  type GTYDiffCtrlAry_t is array(natural range <>) of GTYDiffCtrl_t;

  subtype GTYE4DMonitorOut_t is std_logic_vector(15 downto 0);
  type GTYE4DMonitorOutAry_t is array(natural range <>) of GTYE4DMonitorOut_t;

  subtype GTLoopbackSel_t is std_logic_vector(2 downto 0);
  type GTLoopbackSelAry_t is array(natural range <>) of GTLoopbackSel_t;

  subtype GTTxPiPpmStepSize_t is std_logic_vector(4 downto 0);
  type GTTxPiPpmStepSizeAry_t is array(natural range <>) of GTTxPiPpmStepSize_t;

  subtype GTRxStatus_t is std_logic_vector(2 downto 0);
  type GTRxStatusAry_t is array(natural range <>) of GTRxStatus_t;

  subtype GTPd_t is std_logic_vector(1 downto 0);
  type GTPdAry_t is array(natural range <>) of GTPd_t;

  
  subtype Axi4LiteAddr_t is unsigned(31 downto 0);
  subtype Axi4LiteData_t is std_logic_vector(31 downto 0);
  subtype Axi4LiteStrb_t is std_logic_vector(3 downto 0);
  subtype Axi4LiteResp_t is std_logic_vector(1 downto 0);

  constant kAxiRespOkay   : Axi4LiteResp_t := "00";
  constant kAxiRespSlvErr : Axi4LiteResp_t := "10";

  type Axi4LiteWritePortIn_t is record
    
    
    Address : Axi4LiteAddr_t;
    
    
    AddrValid : boolean;
    
    Data : Axi4LiteData_t;
    
    
    DataStrb : Axi4LiteStrb_t;
    
    
    DataValid : boolean;
    
    
    Ready : boolean;
  end record;

  constant kAxi4LiteWritePortInZero : Axi4LiteWritePortIn_t := (
    Address   => (others => '0'),
    AddrValid => false,
    Data      => (others => '0'),
    DataStrb  => (others => '0'),
    DataValid => false,
    Ready     => false
  );

  type Axi4LiteWritePortOut_t is record
    
    
    
    AddrReady : boolean;
    
    
    DataReady : boolean;
    
    
    Response : Axi4LiteResp_t;
    
    
    RespValid : boolean;
  end record;

  constant kAxi4LiteWritePortOutZero : Axi4LiteWritePortOut_t := (
    AddrReady => false,
    DataReady => false,
    Response  => kAxiRespOkay,
    RespValid => false
  );

  type Axi4LiteReadPortIn_t is record
    
    
    Address : Axi4LiteAddr_t;
    
    
    
    
    AddrValid : boolean;
    
    
    Ready : boolean;
  end record;

  constant kAxi4LiteReadPortInZero : Axi4LiteReadPortIn_t := (
    Address   => (others => '0'),
    AddrValid => false,
    Ready     => false
  );

  type Axi4LiteReadPortOut_t is record
    
    
    
    AddrReady : boolean;
    
    Data : Axi4LiteData_t;
    
    
    Response : Axi4LiteResp_t;
    
    
    DataValid : boolean;
  end record;

  constant kAxi4LiteReadPortOutZero : Axi4LiteReadPortOut_t := (
    AddrReady => false,
    Data      => (others => '0'),
    Response  => kAxiRespOkay,
    DataValid => false
  );

  
  
  function RegAccess (Addr : natural;
                      AxiPortAddr : Axi4LiteAddr_t;
                      AddrValid : boolean) return boolean;
  function RegWrite (Addr : natural; WritePortIn : Axi4LiteWritePortIn_t) return boolean;
  function RegRead (Addr : natural; ReadPortIn : Axi4LiteReadPortIn_t) return boolean;

end package PkgAXI4Lite_GTYE4_Control;

package body PkgAXI4Lite_GTYE4_Control is

  
  
  function RegAccess (Addr : natural;
                      AxiPortAddr : Axi4LiteAddr_t;
                      AddrValid : boolean) return boolean is
  begin
    return Addr = AxiPortAddr and AddrValid;
  end RegAccess;

  function RegWrite (Addr : natural; WritePortIn : Axi4LiteWritePortIn_t) return boolean is
  begin
    return RegAccess(Addr, WritePortIn.Address, WritePortIn.AddrValid) and WritePortIn.DataValid;
  end RegWrite;

  function RegRead (Addr : natural; ReadPortIn : Axi4LiteReadPortIn_t) return boolean is
  begin
    return RegAccess(Addr, ReadPortIn.Address, ReadPortIn.AddrValid);
  end RegRead;

end PkgAXI4Lite_GTYE4_Control;