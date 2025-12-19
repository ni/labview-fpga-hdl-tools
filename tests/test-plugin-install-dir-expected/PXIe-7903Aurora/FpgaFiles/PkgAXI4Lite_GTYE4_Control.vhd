-------------------------------------------------------------------------------
--
-- File: PkgAXI4Lite_GTYE4_Control.vhd
-- Author: Brandon Griffith
-- Original Project: Kintex UltraScale+ KCU116 emulation
-- Date: 1 November 2017
--
-------------------------------------------------------------------------------
-- (c) 2017 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose: This package is used by the AXI4Lite_GTYE4_Control_Regs component.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package PkgAXI4Lite_GTYE4_Control is

  -- Arrays of std_logic_vector for indexing into separate GTY transceivers.
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

  -- Address and Data types for AXI4-Lite register types.
  subtype Axi4LiteAddr_t is unsigned(31 downto 0);
  subtype Axi4LiteData_t is std_logic_vector(31 downto 0);
  subtype Axi4LiteStrb_t is std_logic_vector(3 downto 0);
  subtype Axi4LiteResp_t is std_logic_vector(1 downto 0);

  constant kAxiRespOkay   : Axi4LiteResp_t := "00";
  constant kAxiRespSlvErr : Axi4LiteResp_t := "10";

  type Axi4LiteWritePortIn_t is record
    -- AXI Write address. The write address bus gives the
    -- address of the write transaction.
    Address : Axi4LiteAddr_t;
    -- Write address valid. This signal indicates that valid
    -- write address and control information are available.
    AddrValid : boolean;
    -- Write data
    Data : Axi4LiteData_t;
    -- Write strobes. This signal indicates which byte lanes to
    -- update in memory.
    DataStrb : Axi4LiteStrb_t;
    -- Write valid. This signal indicates that valid write data
    -- and strobes are available.
    DataValid : boolean;
    -- Response ready. This signal indicates that the master
    -- can accept the response information.
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
    -- Write address ready. This signal indicates that the
    -- slave is ready to accept an address and associated
    -- control signals.
    AddrReady : boolean;
    -- Write ready. This signal indicates that the slave can
    -- accept the write data.
    DataReady : boolean;
    -- Write response. This signal indicates the status of the
    -- write transaction. "00" = OKAY, "10" = SLVERR
    Response : Axi4LiteResp_t;
    -- Write response valid. This signal indicates that a valid
    -- write response is available.
    RespValid : boolean;
  end record;

  constant kAxi4LiteWritePortOutZero : Axi4LiteWritePortOut_t := (
    AddrReady => false,
    DataReady => false,
    Response  => kAxiRespOkay,
    RespValid => false
  );

  type Axi4LiteReadPortIn_t is record
    -- Read address. The read address bus gives the
    -- address of a read transaction.
    Address : Axi4LiteAddr_t;
    -- Read address valid. This signal indicates, when high,
    -- that the read address and control information is valid
    -- and will remain stable until the address
    -- acknowledgement signal, S_AXI_ARREADY, is High.
    AddrValid : boolean;
    -- Read ready. This signal indicates that the master can
    -- accept the read data and response information.
    Ready : boolean;
  end record;

  constant kAxi4LiteReadPortInZero : Axi4LiteReadPortIn_t := (
    Address   => (others => '0'),
    AddrValid => false,
    Ready     => false
  );

  type Axi4LiteReadPortOut_t is record
    -- Read address ready. This signal indicates that the
    -- slave is ready to accept an address and associated
    -- control signals.
    AddrReady : boolean;
    -- Read data
    Data : Axi4LiteData_t;
    -- Read response. This signal indicates the status of the
    -- read transfer.
    Response : Axi4LiteResp_t;
    -- Read valid. This signal indicates that the required read
    -- data is available and the read transfer can complete.
    DataValid : boolean;
  end record;

  constant kAxi4LiteReadPortOutZero : Axi4LiteReadPortOut_t := (
    AddrReady => false,
    Data      => (others => '0'),
    Response  => kAxiRespOkay,
    DataValid => false
  );

  -- Functions to determine the start of an AXI4-Lite register access, a
  -- register write, or a register read.
  function RegAccess (Addr : natural;
                      AxiPortAddr : Axi4LiteAddr_t;
                      AddrValid : boolean) return boolean;
  function RegWrite (Addr : natural; WritePortIn : Axi4LiteWritePortIn_t) return boolean;
  function RegRead (Addr : natural; ReadPortIn : Axi4LiteReadPortIn_t) return boolean;

end package PkgAXI4Lite_GTYE4_Control;

package body PkgAXI4Lite_GTYE4_Control is

  -- Functions to determine the start of an AXI4-Lite register access, a
  -- register write, or a register read.
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
