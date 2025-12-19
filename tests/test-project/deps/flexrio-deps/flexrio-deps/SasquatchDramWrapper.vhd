------------------------------------------------------------------------------------------
--
-- File: SasquatchDramWrapper.vhd
-- Author: Rolando Ortega
-- Original Project: Macallan PXIe FlexRIO Carrier
-- Date: 15 October 2015
--
------------------------------------------------------------------------------------------
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
------------------------------------------------------------------------------------------
--
-- Purpose: This is a wrapper to prettify the signals coming from the UltrascaleDdr4
-- block.
--
-- There are two sets of signals in here:
--
-- - The dr* signals can be considered synchronous to the (outgoing) DramClk, though DRAM
--   timing is of course more complicated than that. But ultimately they are all
--   connected to the physical DRAM chips on the board.
--
-- - The du* signals are internal to the chip, are synchronous to DramClkUser, and are
--   connected to the LVFPGA Window. Minor adaptations are done in this module to match
--   the interface that LV expects.
------------------------------------------------------------------------------------------
--
-- githubvisible=true
--
-- vreview_group SasquatchDram
-- vreview_closed http://review-board.natinst.com/r/313047/
-- vreview_reviewers kygreen dhearn esalinas hrubio lboughal rcastro
--
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

entity SasquatchDramWrapper is

  port (
    -------------------------------------------------------------------------------------
    -- System Reset and reference Clock
    -------------------------------------------------------------------------------------
    aDramPonResetSl      : in    std_logic;
    DramRefClk_p         : in    std_logic;
    DramRefClk_n         : in    std_logic;
    -------------------------------------------------------------------------------------
    -- Outgoing Clock
    -------------------------------------------------------------------------------------
    DramClk_p            : out   std_logic;
    DramClk_n            : out   std_logic;
    -------------------------------------------------------------------------------------
    -- Chip Interface
    -------------------------------------------------------------------------------------
    drDramCs_n           : out   std_logic;
    drDramAct_n          : out   std_logic;
    drDramAddr           : out   std_logic_vector (16 downto 0);
    drDramBankAddr       : out   std_logic_vector (1 downto 0);
    drDramBg             : out   std_logic_vector (0 downto 0);
    drDramClkEn          : out   std_logic;
    drDramOdt            : out   std_logic;
    drDramReset_n        : out   std_logic;
    drDramDmDbi_n        : inout std_logic_vector (9 downto 0);
    drDramDq             : inout std_logic_vector (79 downto 0);
    drDramDqs_p          : inout std_logic_vector (9 downto 0);
    drDramDqs_n          : inout std_logic_vector (9 downto 0);
    drDramTestMode       : out   std_logic;
    -------------------------------------------------------------------------------------
    -- User Interface
    -------------------------------------------------------------------------------------
    -- Clocks and Resets
    DramClkUserLcl       : out   std_logic;
    aduReset             : out   std_logic;
    -- Status
    duDramPhyInitDone    : out   std_logic;
    -- Address Fifo
    duDramAddrFifoFull   : out   std_logic;
    duDramAddrFifoAddr   : in    std_logic_vector (29 downto 0);
    duDramAddrFifoCmd    : in    std_logic_vector (2 downto 0);
    duDramAddrFifoWrEn   : in    std_logic;
    -- Write Fifo
    duDramWrFifoFull     : out   std_logic;
    duDramWrFifoWrEn     : in    std_logic;
    duDramWrFifoDataIn   : in    std_logic_vector (639 downto 0);
    duDramWrFifoMaskData : in    std_logic_vector (79 downto 0);
    -- Read Fifo
    duDramRdDataValid    : out   std_logic;
    duDramRdFifoDataOut  : out   std_logic_vector (639 downto 0)
    );

end entity SasquatchDramWrapper;

architecture struct of SasquatchDramWrapper is

  component ddr4_0
    port (
      sys_rst                   : in  STD_LOGIC;
      c0_sys_clk_i              : in  STD_LOGIC;
      c0_ddr4_act_n             : out STD_LOGIC;
      c0_ddr4_adr               : out STD_LOGIC_VECTOR(16 downto 0);
      c0_ddr4_ba                : out STD_LOGIC_VECTOR(1 downto 0);
      c0_ddr4_bg                : out STD_LOGIC_VECTOR(0 to 0);
      c0_ddr4_cke               : out STD_LOGIC_VECTOR(0 to 0);
      c0_ddr4_odt               : out STD_LOGIC_VECTOR(0 to 0);
      c0_ddr4_cs_n              : out STD_LOGIC_VECTOR(0 to 0);
      c0_ddr4_ck_t              : out STD_LOGIC_VECTOR(0 to 0);
      c0_ddr4_ck_c              : out STD_LOGIC_VECTOR(0 to 0);
      c0_ddr4_reset_n           : out STD_LOGIC;
      c0_ddr4_dm_dbi_n          : inout STD_LOGIC_VECTOR(9 downto 0);
      c0_ddr4_dq                : inout STD_LOGIC_VECTOR(79 downto 0);
      c0_ddr4_dqs_c             : inout STD_LOGIC_VECTOR(9 downto 0);
      c0_ddr4_dqs_t             : inout STD_LOGIC_VECTOR(9 downto 0);
      c0_init_calib_complete    : out STD_LOGIC;
      c0_ddr4_ui_clk            : out STD_LOGIC;
      c0_ddr4_ui_clk_sync_rst   : out STD_LOGIC;
      dbg_clk                   : out STD_LOGIC;
      c0_ddr4_app_addr          : in  STD_LOGIC_VECTOR(29 downto 0);
      c0_ddr4_app_cmd           : in  STD_LOGIC_VECTOR(2 downto 0);
      c0_ddr4_app_en            : in  STD_LOGIC;
      c0_ddr4_app_hi_pri        : in  STD_LOGIC;
      c0_ddr4_app_wdf_data      : in  STD_LOGIC_VECTOR(639 downto 0);
      c0_ddr4_app_wdf_end       : in  STD_LOGIC;
      c0_ddr4_app_wdf_mask      : in  STD_LOGIC_VECTOR(79 downto 0);
      c0_ddr4_app_wdf_wren      : in  STD_LOGIC;
      c0_ddr4_app_rd_data       : out STD_LOGIC_VECTOR(639 downto 0);
      c0_ddr4_app_rd_data_end   : out STD_LOGIC;
      c0_ddr4_app_rd_data_valid : out STD_LOGIC;
      c0_ddr4_app_rdy           : out STD_LOGIC;
      c0_ddr4_app_wdf_rdy       : out STD_LOGIC;
      dbg_bus                   : out STD_LOGIC_VECTOR(511 downto 0));
  end component;

  --vhook_sigstart
  signal DramClkSlv_n: STD_LOGIC_VECTOR(0 to 0);
  signal DramClkSlv_p: STD_LOGIC_VECTOR(0 to 0);
  signal DramRefClk: std_ulogic;
  signal DramRefClkPin: std_ulogic;
  signal drDramClkEnSlv: STD_LOGIC_VECTOR(0 to 0);
  signal drDramCsSlv_n: STD_LOGIC_VECTOR(0 to 0);
  signal drDramOdtSlv: STD_LOGIC_VECTOR(0 to 0);
  signal duDramCtrlReady: STD_LOGIC;
  signal duDramWrReady: STD_LOGIC;
  --vhook_sigend

begin  -- architecture struct

  ---------------------------------------------------------------------------------------
  -- Clock Buffers
  ---------------------------------------------------------------------------------------

  --vhook_i IBUFDS              DramRefClkIbuf hidegeneric=open
  --vhook_g IBUF_LOW_PWR        false
  --vhook_g DIFF_TERM           false
  --vhook_g *                   open
  --vhook_a I                   DramRefClk_p
  --vhook_a IB                  DramRefClk_n
  --vhook_a O                   DramRefClkPin
  DramRefClkIbuf: IBUFDS
    generic map (
      DIFF_TERM    => false,  --boolean:=FALSE
      IBUF_LOW_PWR => false)  --boolean:=TRUE
    port map (
      O  => DramRefClkPin,  --out std_ulogic
      I  => DramRefClk_p,   --in  std_ulogic
      IB => DramRefClk_n);  --in  std_ulogic


  --vhook_i BUFG        DramRefClkBufg
  --vhook_a I           DramRefClkPin
  --vhook_a O           DramRefClk
  DramRefClkBufg: BUFG
    port map (
      O => DramRefClk,     --out std_ulogic
      I => DramRefClkPin); --in  std_ulogic

  ---------------------------------------------------------------------------------------
  -- MIG instantiation
  ---------------------------------------------------------------------------------------

  --vhook   ddr4_0
  --vhook_a sys_rst                     aDramPonResetSl
  --vhook_a c0_sys_clk_i                DramRefClk
  --vhook_a *cs_n                       drDramCsSlv_n
  --vhook_a *act_n                      drDramAct_n
  --vhook_a *adr                        drDramAddr
  --vhook_a *ba                         drDramBankAddr
  --vhook_a *bg                         drDramBg
  --vhook_a *cke                        drDramClkEnSlv
  --vhook_a *odt                        drDramOdtSlv
  --vhook_a *ck_t                       DramClkSlv_p
  --vhook_a *ck_c                       DramClkSlv_n
  --vhook_a *reset_n                    drDramReset_n
  --vhook_a *dm_dbi_n                   drDramDmDbi_n
  --vhook_a *dq                         drDramDq
  --vhook_a *dqs_c                      drDramDqs_n
  --vhook_a *dqs_t                      drDramDqs_p
  --vhook_a *init_calib_complete        duDramPhyInitDone
  --vhook_a *ui_clk                     DramClkUserLcl
  --vhook_a *ui_clk_sync_rst            aduReset
  --vhook_a *app_addr                   duDramAddrFifoAddr
  --vhook_a *app_cmd                    duDramAddrFifoCmd
  --vhook_a *app_en                     duDramAddrFifoWrEn
  --vhook_a *app_wdf_data               duDramWrFifoDataIn
  --vhook_a *app_wdf_mask               duDramWrFifoMaskData
  --vhook_# *app_wdf_end and *app_wdf_wren both tied to WrEn because the LV memory
  --vhook_# interface doesn't use packetizing (each word is always the end of a write
  --vhook_# packet).
  --vhook_a *app_wdf_end                duDramWrFifoWrEn
  --vhook_a *app_wdf_wren               duDramWrFifoWrEn
  --vhook_a *app_rd_data                duDramRdFifoDataOut
  --vhook_# *rd_data_end is left open because we don't care about packetizing.
  --vhook_# We only care when data is valid and when it isn't.
  --vhook_a *app_rd_data_end            open
  --vhook_a *app_rd_data_valid          duDramRdDataValid
  --vhook_a *app_rdy                    duDramCtrlReady
  --vhook_a *app_wdf_rdy                duDramWrReady
  --vhook_# *app_hi_pri tied to '0' as per PG150
  --vhook_c *app_hi_pri                 '0'
  --vhook_a dbg_bus                     open
  --vhook_# dbg_clk is left open as specified in PG150 (pg 337 for v1.1, Nov 2015).
  --vhook_# Vivado will hook up this connection appropriately if necessary.
  --vhook_a dbg_clk                     open
  ddr4_0x: ddr4_0
    port map (
      sys_rst                   => aDramPonResetSl,       --in  STD_LOGIC
      c0_sys_clk_i              => DramRefClk,            --in  STD_LOGIC
      c0_ddr4_act_n             => drDramAct_n,           --out STD_LOGIC
      c0_ddr4_adr               => drDramAddr,            --out STD_LOGIC_VECTOR(16:0)
      c0_ddr4_ba                => drDramBankAddr,        --out STD_LOGIC_VECTOR(1:0)
      c0_ddr4_bg                => drDramBg,              --out STD_LOGIC_VECTOR(0:0)
      c0_ddr4_cke               => drDramClkEnSlv,        --out STD_LOGIC_VECTOR(0:0)
      c0_ddr4_odt               => drDramOdtSlv,          --out STD_LOGIC_VECTOR(0:0)
      c0_ddr4_cs_n              => drDramCsSlv_n,         --out STD_LOGIC_VECTOR(0:0)
      c0_ddr4_ck_t              => DramClkSlv_p,          --out STD_LOGIC_VECTOR(0:0)
      c0_ddr4_ck_c              => DramClkSlv_n,          --out STD_LOGIC_VECTOR(0:0)
      c0_ddr4_reset_n           => drDramReset_n,         --out STD_LOGIC
      c0_ddr4_dm_dbi_n          => drDramDmDbi_n,         --inout STD_LOGIC_VECTOR(9:0)
      c0_ddr4_dq                => drDramDq,              --inout STD_LOGIC_VECTOR(79:0)
      c0_ddr4_dqs_c             => drDramDqs_n,           --inout STD_LOGIC_VECTOR(9:0)
      c0_ddr4_dqs_t             => drDramDqs_p,           --inout STD_LOGIC_VECTOR(9:0)
      c0_init_calib_complete    => duDramPhyInitDone,     --out STD_LOGIC
      c0_ddr4_ui_clk            => DramClkUserLcl,        --out STD_LOGIC
      c0_ddr4_ui_clk_sync_rst   => aduReset,              --out STD_LOGIC
      dbg_clk                   => open,                  --out STD_LOGIC
      c0_ddr4_app_addr          => duDramAddrFifoAddr,    --in  STD_LOGIC_VECTOR(29:0)
      c0_ddr4_app_cmd           => duDramAddrFifoCmd,     --in  STD_LOGIC_VECTOR(2:0)
      c0_ddr4_app_en            => duDramAddrFifoWrEn,    --in  STD_LOGIC
      c0_ddr4_app_hi_pri        => '0',                   --in  STD_LOGIC
      c0_ddr4_app_wdf_data      => duDramWrFifoDataIn,    --in  STD_LOGIC_VECTOR(639:0)
      c0_ddr4_app_wdf_end       => duDramWrFifoWrEn,      --in  STD_LOGIC
      c0_ddr4_app_wdf_mask      => duDramWrFifoMaskData,  --in  STD_LOGIC_VECTOR(79:0)
      c0_ddr4_app_wdf_wren      => duDramWrFifoWrEn,      --in  STD_LOGIC
      c0_ddr4_app_rd_data       => duDramRdFifoDataOut,   --out STD_LOGIC_VECTOR(639:0)
      c0_ddr4_app_rd_data_end   => open,                  --out STD_LOGIC
      c0_ddr4_app_rd_data_valid => duDramRdDataValid,     --out STD_LOGIC
      c0_ddr4_app_rdy           => duDramCtrlReady,       --out STD_LOGIC
      c0_ddr4_app_wdf_rdy       => duDramWrReady,         --out STD_LOGIC
      dbg_bus                   => open);                 --out STD_LOGIC_VECTOR(511:0)

  ---------------------------------------------------------------------------------------
  -- SLV -> SL
  ---------------------------------------------------------------------------------------
  -- These signals are (0 downto 0) standard_logic_vectors. We will extract the single
  -- signal in them and pass out a "normal" standard_logic;
  -- Clock
  DramClk_p   <= DramClkSlv_p(0);
  DramClk_n   <= DramClkSlv_n(0);
  -- Other control signals
  drDramClkEn <= drDramClkEnSlv(0);
  drDramOdt   <= drDramOdtSlv(0);
  drDramCs_n  <= drDramCsSlv_n(0);

  ---------------------------------------------------------------------------------------
  -- Ready -> FifoFull
  ---------------------------------------------------------------------------------------
  -- Map "Ready" signals from MIG to "Full" signals form LV FPGA interface, as done in
  -- 7Series devices before.
  duDramAddrFifoFull <= not duDramCtrlReady;
  duDramWrFifoFull   <= not duDramWrReady;

  ---------------------------------------------------------------------------------------
  -- DRAM Test Mode
  ---------------------------------------------------------------------------------------
  -- Regardless of whether we generate the memory controller or not, the Test Enable (TEN)
  -- pin on the DRAM needs to be tied to '0' so it doesn't go into test mode. We'll set it
  -- to 1 only during boundary scan testing.
  drDramTestMode <= '0';

end architecture struct;
