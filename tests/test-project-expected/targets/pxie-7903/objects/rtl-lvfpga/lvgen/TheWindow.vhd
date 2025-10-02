------------------------------------------------------------------------------
--
-- File: DmaPortWindowTemplate.vhd
-- Author: Daria Tioc-Deac
-- Original Project: DmaPort Communication Interface
-- Date: 20 December 2011
--
------------------------------------------------------------------------------
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
------------------------------------------------------------------------------
--
-- Purpose:
-- Dummy window for VSMAKE to work. All signals will be driven from the appropiate
-- clocks and ensure that they are not optimized away.
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library work;
use work.PkgNiUtilities.all;

use work.PkgDmaPortCommIfcArbiter.all;

-- The pkg that specifies several signals used by the user VI and register
-- framework.
use work.PkgCommunicationInterface.all;
use work.PkgDmaPortCommunicationInterface.all;

-- The pkg containing some configuration info on the communication interface,
-- such as the number of DMA channels and size of the DMA FIFO's.
use work.PkgCommIntConfiguration.all;

-- The pkg containing information on the DmaPort configuration.
use work.PkgNiDmaConfig.all;

-- The pkg containing the definitions for the FIFO interface signals.
use work.PkgDmaPortDmaFifos.all;

-- This package contains the definitions for the interface between the NI DMA IP and
-- the application specific logic
use work.PkgNiDma.all;

-- The package contain data types definitions needed to define Master Port interfaces.
use work.PkgDmaPortCommIfcMasterPort.all;
use work.PkgDmaPortCommIfcMasterPortFlatTypes.all;

entity TheWindow is
  port(

     -----------------------------------
    -- CUSTOM BOARD IO
    -----------------------------------
    xIoModuleReady : in std_logic; -- IO Socket\IO Ready
    xIoModuleErrorCode : in std_logic_vector(31 downto 0); -- IO Socket\IO Error
    aDioOut : out std_logic_vector(7 downto 0); -- IO Socket\DIO Out
    aDioIn : in std_logic_vector(7 downto 0); -- IO Socket\DIO In
    UserClkPort0 : in std_logic; -- IO Socket\Port0 User Clock
    aPort0PmaInit : out std_logic; -- IO Socket\Port0\PmaInit
    aPort0ResetPb : out std_logic; -- IO Socket\Port0\ResetPb
    uPort0AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port0\Tx\TData0
    uPort0AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port0\Tx\TData1
    uPort0AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port0\Tx\TData2
    uPort0AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port0\Tx\TData3
    uPort0AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port0\Tx\TKeep
    uPort0AxiTxTLast : out std_logic; -- IO Socket\Port0\Tx\TLast
    uPort0AxiTxTValid : out std_logic; -- IO Socket\Port0\Tx\TValid
    uPort0AxiTxTReady : in std_logic; -- IO Socket\Port0\Tx\TReady
    uPort0AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port0\Rx\TData0
    uPort0AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port0\Rx\TData1
    uPort0AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port0\Rx\TData2
    uPort0AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port0\Rx\TData3
    uPort0AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port0\Rx\TKeep
    uPort0AxiRxTLast : in std_logic; -- IO Socket\Port0\Rx\TLast
    uPort0AxiRxTValid : in std_logic; -- IO Socket\Port0\Rx\TValid
    uPort0AxiNfcTValid : out std_logic; -- IO Socket\Port0\Nfc\TValid
    uPort0AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port0\Nfc\TData
    uPort0AxiNfcTReady : in std_logic; -- IO Socket\Port0\Nfc\TReady
    uPort0HardError : in std_logic; -- IO Socket\Port0\HardError
    uPort0SoftError : in std_logic; -- IO Socket\Port0\SoftError
    uPort0LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port0\LaneUp
    uPort0ChannelUp : in std_logic; -- IO Socket\Port0\ChannelUp
    uPort0SysResetOut : in std_logic; -- IO Socket\Port0\SysResetOut
    uPort0MmcmNotLockOut : in std_logic; -- IO Socket\Port0\MmcmNotLockOut
    uPort0CrcPassFail_n : in std_logic; -- IO Socket\Port0\CrcPassFail_n
    uPort0CrcValid : in std_logic; -- IO Socket\Port0\CrcValid
    iPort0LinkResetOut : in std_logic; -- IO Socket\Port0\LinkResetOut
    sGtwiz0CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port0\CtrlAxi\AWAddr
    sGtwiz0CtrlAxiAWValid : out std_logic; -- IO Socket\Port0\CtrlAxi\AWValid
    sGtwiz0CtrlAxiAWReady : in std_logic; -- IO Socket\Port0\CtrlAxi\AWReady
    sGtwiz0CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port0\CtrlAxi\WData
    sGtwiz0CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port0\CtrlAxi\WStrb
    sGtwiz0CtrlAxiWValid : out std_logic; -- IO Socket\Port0\CtrlAxi\WValid
    sGtwiz0CtrlAxiWReady : in std_logic; -- IO Socket\Port0\CtrlAxi\WReady
    sGtwiz0CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port0\CtrlAxi\BResp
    sGtwiz0CtrlAxiBValid : in std_logic; -- IO Socket\Port0\CtrlAxi\BValid
    sGtwiz0CtrlAxiBReady : out std_logic; -- IO Socket\Port0\CtrlAxi\BReady
    sGtwiz0CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port0\CtrlAxi\ARAddr
    sGtwiz0CtrlAxiARValid : out std_logic; -- IO Socket\Port0\CtrlAxi\ARValid
    sGtwiz0CtrlAxiARReady : in std_logic; -- IO Socket\Port0\CtrlAxi\ARReady
    sGtwiz0CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port0\CtrlAxi\RData
    sGtwiz0CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port0\CtrlAxi\RResp
    sGtwiz0CtrlAxiRValid : in std_logic; -- IO Socket\Port0\CtrlAxi\RValid
    sGtwiz0CtrlAxiRReady : out std_logic; -- IO Socket\Port0\CtrlAxi\RReady
    sGtwiz0DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port0\DrpChAxi\AWAddr
    sGtwiz0DrpChAxiAWValid : out std_logic; -- IO Socket\Port0\DrpChAxi\AWValid
    sGtwiz0DrpChAxiAWReady : in std_logic; -- IO Socket\Port0\DrpChAxi\AWReady
    sGtwiz0DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port0\DrpChAxi\WData
    sGtwiz0DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port0\DrpChAxi\WStrb
    sGtwiz0DrpChAxiWValid : out std_logic; -- IO Socket\Port0\DrpChAxi\WValid
    sGtwiz0DrpChAxiWReady : in std_logic; -- IO Socket\Port0\DrpChAxi\WReady
    sGtwiz0DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port0\DrpChAxi\BResp
    sGtwiz0DrpChAxiBValid : in std_logic; -- IO Socket\Port0\DrpChAxi\BValid
    sGtwiz0DrpChAxiBReady : out std_logic; -- IO Socket\Port0\DrpChAxi\BReady
    sGtwiz0DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port0\DrpChAxi\ARAddr
    sGtwiz0DrpChAxiARValid : out std_logic; -- IO Socket\Port0\DrpChAxi\ARValid
    sGtwiz0DrpChAxiARReady : in std_logic; -- IO Socket\Port0\DrpChAxi\ARReady
    sGtwiz0DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port0\DrpChAxi\RData
    sGtwiz0DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port0\DrpChAxi\RResp
    sGtwiz0DrpChAxiRValid : in std_logic; -- IO Socket\Port0\DrpChAxi\RValid
    sGtwiz0DrpChAxiRReady : out std_logic; -- IO Socket\Port0\DrpChAxi\RReady
    UserClkPort1 : in std_logic; -- IO Socket\Port1 User Clock
    aPort1PmaInit : out std_logic; -- IO Socket\Port1\PmaInit
    aPort1ResetPb : out std_logic; -- IO Socket\Port1\ResetPb
    uPort1AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port1\Tx\TData0
    uPort1AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port1\Tx\TData1
    uPort1AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port1\Tx\TData2
    uPort1AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port1\Tx\TData3
    uPort1AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port1\Tx\TKeep
    uPort1AxiTxTLast : out std_logic; -- IO Socket\Port1\Tx\TLast
    uPort1AxiTxTValid : out std_logic; -- IO Socket\Port1\Tx\TValid
    uPort1AxiTxTReady : in std_logic; -- IO Socket\Port1\Tx\TReady
    uPort1AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port1\Rx\TData0
    uPort1AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port1\Rx\TData1
    uPort1AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port1\Rx\TData2
    uPort1AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port1\Rx\TData3
    uPort1AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port1\Rx\TKeep
    uPort1AxiRxTLast : in std_logic; -- IO Socket\Port1\Rx\TLast
    uPort1AxiRxTValid : in std_logic; -- IO Socket\Port1\Rx\TValid
    uPort1AxiNfcTValid : out std_logic; -- IO Socket\Port1\Nfc\TValid
    uPort1AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port1\Nfc\TData
    uPort1AxiNfcTReady : in std_logic; -- IO Socket\Port1\Nfc\TReady
    uPort1HardError : in std_logic; -- IO Socket\Port1\HardError
    uPort1SoftError : in std_logic; -- IO Socket\Port1\SoftError
    uPort1LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port1\LaneUp
    uPort1ChannelUp : in std_logic; -- IO Socket\Port1\ChannelUp
    uPort1SysResetOut : in std_logic; -- IO Socket\Port1\SysResetOut
    uPort1MmcmNotLockOut : in std_logic; -- IO Socket\Port1\MmcmNotLockOut
    uPort1CrcPassFail_n : in std_logic; -- IO Socket\Port1\CrcPassFail_n
    uPort1CrcValid : in std_logic; -- IO Socket\Port1\CrcValid
    iPort1LinkResetOut : in std_logic; -- IO Socket\Port1\LinkResetOut
    sGtwiz1CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port1\CtrlAxi\AWAddr
    sGtwiz1CtrlAxiAWValid : out std_logic; -- IO Socket\Port1\CtrlAxi\AWValid
    sGtwiz1CtrlAxiAWReady : in std_logic; -- IO Socket\Port1\CtrlAxi\AWReady
    sGtwiz1CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port1\CtrlAxi\WData
    sGtwiz1CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port1\CtrlAxi\WStrb
    sGtwiz1CtrlAxiWValid : out std_logic; -- IO Socket\Port1\CtrlAxi\WValid
    sGtwiz1CtrlAxiWReady : in std_logic; -- IO Socket\Port1\CtrlAxi\WReady
    sGtwiz1CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port1\CtrlAxi\BResp
    sGtwiz1CtrlAxiBValid : in std_logic; -- IO Socket\Port1\CtrlAxi\BValid
    sGtwiz1CtrlAxiBReady : out std_logic; -- IO Socket\Port1\CtrlAxi\BReady
    sGtwiz1CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port1\CtrlAxi\ARAddr
    sGtwiz1CtrlAxiARValid : out std_logic; -- IO Socket\Port1\CtrlAxi\ARValid
    sGtwiz1CtrlAxiARReady : in std_logic; -- IO Socket\Port1\CtrlAxi\ARReady
    sGtwiz1CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port1\CtrlAxi\RData
    sGtwiz1CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port1\CtrlAxi\RResp
    sGtwiz1CtrlAxiRValid : in std_logic; -- IO Socket\Port1\CtrlAxi\RValid
    sGtwiz1CtrlAxiRReady : out std_logic; -- IO Socket\Port1\CtrlAxi\RReady
    sGtwiz1DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port1\DrpChAxi\AWAddr
    sGtwiz1DrpChAxiAWValid : out std_logic; -- IO Socket\Port1\DrpChAxi\AWValid
    sGtwiz1DrpChAxiAWReady : in std_logic; -- IO Socket\Port1\DrpChAxi\AWReady
    sGtwiz1DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port1\DrpChAxi\WData
    sGtwiz1DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port1\DrpChAxi\WStrb
    sGtwiz1DrpChAxiWValid : out std_logic; -- IO Socket\Port1\DrpChAxi\WValid
    sGtwiz1DrpChAxiWReady : in std_logic; -- IO Socket\Port1\DrpChAxi\WReady
    sGtwiz1DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port1\DrpChAxi\BResp
    sGtwiz1DrpChAxiBValid : in std_logic; -- IO Socket\Port1\DrpChAxi\BValid
    sGtwiz1DrpChAxiBReady : out std_logic; -- IO Socket\Port1\DrpChAxi\BReady
    sGtwiz1DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port1\DrpChAxi\ARAddr
    sGtwiz1DrpChAxiARValid : out std_logic; -- IO Socket\Port1\DrpChAxi\ARValid
    sGtwiz1DrpChAxiARReady : in std_logic; -- IO Socket\Port1\DrpChAxi\ARReady
    sGtwiz1DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port1\DrpChAxi\RData
    sGtwiz1DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port1\DrpChAxi\RResp
    sGtwiz1DrpChAxiRValid : in std_logic; -- IO Socket\Port1\DrpChAxi\RValid
    sGtwiz1DrpChAxiRReady : out std_logic; -- IO Socket\Port1\DrpChAxi\RReady
    UserClkPort2 : in std_logic; -- IO Socket\Port2 User Clock
    aPort2PmaInit : out std_logic; -- IO Socket\Port2\PmaInit
    aPort2ResetPb : out std_logic; -- IO Socket\Port2\ResetPb
    uPort2AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port2\Tx\TData0
    uPort2AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port2\Tx\TData1
    uPort2AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port2\Tx\TData2
    uPort2AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port2\Tx\TData3
    uPort2AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port2\Tx\TKeep
    uPort2AxiTxTLast : out std_logic; -- IO Socket\Port2\Tx\TLast
    uPort2AxiTxTValid : out std_logic; -- IO Socket\Port2\Tx\TValid
    uPort2AxiTxTReady : in std_logic; -- IO Socket\Port2\Tx\TReady
    uPort2AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port2\Rx\TData0
    uPort2AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port2\Rx\TData1
    uPort2AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port2\Rx\TData2
    uPort2AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port2\Rx\TData3
    uPort2AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port2\Rx\TKeep
    uPort2AxiRxTLast : in std_logic; -- IO Socket\Port2\Rx\TLast
    uPort2AxiRxTValid : in std_logic; -- IO Socket\Port2\Rx\TValid
    uPort2AxiNfcTValid : out std_logic; -- IO Socket\Port2\Nfc\TValid
    uPort2AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port2\Nfc\TData
    uPort2AxiNfcTReady : in std_logic; -- IO Socket\Port2\Nfc\TReady
    uPort2HardError : in std_logic; -- IO Socket\Port2\HardError
    uPort2SoftError : in std_logic; -- IO Socket\Port2\SoftError
    uPort2LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port2\LaneUp
    uPort2ChannelUp : in std_logic; -- IO Socket\Port2\ChannelUp
    uPort2SysResetOut : in std_logic; -- IO Socket\Port2\SysResetOut
    uPort2MmcmNotLockOut : in std_logic; -- IO Socket\Port2\MmcmNotLockOut
    uPort2CrcPassFail_n : in std_logic; -- IO Socket\Port2\CrcPassFail_n
    uPort2CrcValid : in std_logic; -- IO Socket\Port2\CrcValid
    iPort2LinkResetOut : in std_logic; -- IO Socket\Port2\LinkResetOut
    sGtwiz2CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port2\CtrlAxi\AWAddr
    sGtwiz2CtrlAxiAWValid : out std_logic; -- IO Socket\Port2\CtrlAxi\AWValid
    sGtwiz2CtrlAxiAWReady : in std_logic; -- IO Socket\Port2\CtrlAxi\AWReady
    sGtwiz2CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port2\CtrlAxi\WData
    sGtwiz2CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port2\CtrlAxi\WStrb
    sGtwiz2CtrlAxiWValid : out std_logic; -- IO Socket\Port2\CtrlAxi\WValid
    sGtwiz2CtrlAxiWReady : in std_logic; -- IO Socket\Port2\CtrlAxi\WReady
    sGtwiz2CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port2\CtrlAxi\BResp
    sGtwiz2CtrlAxiBValid : in std_logic; -- IO Socket\Port2\CtrlAxi\BValid
    sGtwiz2CtrlAxiBReady : out std_logic; -- IO Socket\Port2\CtrlAxi\BReady
    sGtwiz2CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port2\CtrlAxi\ARAddr
    sGtwiz2CtrlAxiARValid : out std_logic; -- IO Socket\Port2\CtrlAxi\ARValid
    sGtwiz2CtrlAxiARReady : in std_logic; -- IO Socket\Port2\CtrlAxi\ARReady
    sGtwiz2CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port2\CtrlAxi\RData
    sGtwiz2CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port2\CtrlAxi\RResp
    sGtwiz2CtrlAxiRValid : in std_logic; -- IO Socket\Port2\CtrlAxi\RValid
    sGtwiz2CtrlAxiRReady : out std_logic; -- IO Socket\Port2\CtrlAxi\RReady
    sGtwiz2DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port2\DrpChAxi\AWAddr
    sGtwiz2DrpChAxiAWValid : out std_logic; -- IO Socket\Port2\DrpChAxi\AWValid
    sGtwiz2DrpChAxiAWReady : in std_logic; -- IO Socket\Port2\DrpChAxi\AWReady
    sGtwiz2DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port2\DrpChAxi\WData
    sGtwiz2DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port2\DrpChAxi\WStrb
    sGtwiz2DrpChAxiWValid : out std_logic; -- IO Socket\Port2\DrpChAxi\WValid
    sGtwiz2DrpChAxiWReady : in std_logic; -- IO Socket\Port2\DrpChAxi\WReady
    sGtwiz2DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port2\DrpChAxi\BResp
    sGtwiz2DrpChAxiBValid : in std_logic; -- IO Socket\Port2\DrpChAxi\BValid
    sGtwiz2DrpChAxiBReady : out std_logic; -- IO Socket\Port2\DrpChAxi\BReady
    sGtwiz2DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port2\DrpChAxi\ARAddr
    sGtwiz2DrpChAxiARValid : out std_logic; -- IO Socket\Port2\DrpChAxi\ARValid
    sGtwiz2DrpChAxiARReady : in std_logic; -- IO Socket\Port2\DrpChAxi\ARReady
    sGtwiz2DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port2\DrpChAxi\RData
    sGtwiz2DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port2\DrpChAxi\RResp
    sGtwiz2DrpChAxiRValid : in std_logic; -- IO Socket\Port2\DrpChAxi\RValid
    sGtwiz2DrpChAxiRReady : out std_logic; -- IO Socket\Port2\DrpChAxi\RReady
    UserClkPort3 : in std_logic; -- IO Socket\Port3 User Clock
    aPort3PmaInit : out std_logic; -- IO Socket\Port3\PmaInit
    aPort3ResetPb : out std_logic; -- IO Socket\Port3\ResetPb
    uPort3AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port3\Tx\TData0
    uPort3AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port3\Tx\TData1
    uPort3AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port3\Tx\TData2
    uPort3AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port3\Tx\TData3
    uPort3AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port3\Tx\TKeep
    uPort3AxiTxTLast : out std_logic; -- IO Socket\Port3\Tx\TLast
    uPort3AxiTxTValid : out std_logic; -- IO Socket\Port3\Tx\TValid
    uPort3AxiTxTReady : in std_logic; -- IO Socket\Port3\Tx\TReady
    uPort3AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port3\Rx\TData0
    uPort3AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port3\Rx\TData1
    uPort3AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port3\Rx\TData2
    uPort3AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port3\Rx\TData3
    uPort3AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port3\Rx\TKeep
    uPort3AxiRxTLast : in std_logic; -- IO Socket\Port3\Rx\TLast
    uPort3AxiRxTValid : in std_logic; -- IO Socket\Port3\Rx\TValid
    uPort3AxiNfcTValid : out std_logic; -- IO Socket\Port3\Nfc\TValid
    uPort3AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port3\Nfc\TData
    uPort3AxiNfcTReady : in std_logic; -- IO Socket\Port3\Nfc\TReady
    uPort3HardError : in std_logic; -- IO Socket\Port3\HardError
    uPort3SoftError : in std_logic; -- IO Socket\Port3\SoftError
    uPort3LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port3\LaneUp
    uPort3ChannelUp : in std_logic; -- IO Socket\Port3\ChannelUp
    uPort3SysResetOut : in std_logic; -- IO Socket\Port3\SysResetOut
    uPort3MmcmNotLockOut : in std_logic; -- IO Socket\Port3\MmcmNotLockOut
    uPort3CrcPassFail_n : in std_logic; -- IO Socket\Port3\CrcPassFail_n
    uPort3CrcValid : in std_logic; -- IO Socket\Port3\CrcValid
    iPort3LinkResetOut : in std_logic; -- IO Socket\Port3\LinkResetOut
    sGtwiz3CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port3\CtrlAxi\AWAddr
    sGtwiz3CtrlAxiAWValid : out std_logic; -- IO Socket\Port3\CtrlAxi\AWValid
    sGtwiz3CtrlAxiAWReady : in std_logic; -- IO Socket\Port3\CtrlAxi\AWReady
    sGtwiz3CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port3\CtrlAxi\WData
    sGtwiz3CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port3\CtrlAxi\WStrb
    sGtwiz3CtrlAxiWValid : out std_logic; -- IO Socket\Port3\CtrlAxi\WValid
    sGtwiz3CtrlAxiWReady : in std_logic; -- IO Socket\Port3\CtrlAxi\WReady
    sGtwiz3CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port3\CtrlAxi\BResp
    sGtwiz3CtrlAxiBValid : in std_logic; -- IO Socket\Port3\CtrlAxi\BValid
    sGtwiz3CtrlAxiBReady : out std_logic; -- IO Socket\Port3\CtrlAxi\BReady
    sGtwiz3CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port3\CtrlAxi\ARAddr
    sGtwiz3CtrlAxiARValid : out std_logic; -- IO Socket\Port3\CtrlAxi\ARValid
    sGtwiz3CtrlAxiARReady : in std_logic; -- IO Socket\Port3\CtrlAxi\ARReady
    sGtwiz3CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port3\CtrlAxi\RData
    sGtwiz3CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port3\CtrlAxi\RResp
    sGtwiz3CtrlAxiRValid : in std_logic; -- IO Socket\Port3\CtrlAxi\RValid
    sGtwiz3CtrlAxiRReady : out std_logic; -- IO Socket\Port3\CtrlAxi\RReady
    sGtwiz3DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port3\DrpChAxi\AWAddr
    sGtwiz3DrpChAxiAWValid : out std_logic; -- IO Socket\Port3\DrpChAxi\AWValid
    sGtwiz3DrpChAxiAWReady : in std_logic; -- IO Socket\Port3\DrpChAxi\AWReady
    sGtwiz3DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port3\DrpChAxi\WData
    sGtwiz3DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port3\DrpChAxi\WStrb
    sGtwiz3DrpChAxiWValid : out std_logic; -- IO Socket\Port3\DrpChAxi\WValid
    sGtwiz3DrpChAxiWReady : in std_logic; -- IO Socket\Port3\DrpChAxi\WReady
    sGtwiz3DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port3\DrpChAxi\BResp
    sGtwiz3DrpChAxiBValid : in std_logic; -- IO Socket\Port3\DrpChAxi\BValid
    sGtwiz3DrpChAxiBReady : out std_logic; -- IO Socket\Port3\DrpChAxi\BReady
    sGtwiz3DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port3\DrpChAxi\ARAddr
    sGtwiz3DrpChAxiARValid : out std_logic; -- IO Socket\Port3\DrpChAxi\ARValid
    sGtwiz3DrpChAxiARReady : in std_logic; -- IO Socket\Port3\DrpChAxi\ARReady
    sGtwiz3DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port3\DrpChAxi\RData
    sGtwiz3DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port3\DrpChAxi\RResp
    sGtwiz3DrpChAxiRValid : in std_logic; -- IO Socket\Port3\DrpChAxi\RValid
    sGtwiz3DrpChAxiRReady : out std_logic; -- IO Socket\Port3\DrpChAxi\RReady
    UserClkPort4 : in std_logic; -- IO Socket\Port4 User Clock
    aPort4PmaInit : out std_logic; -- IO Socket\Port4\PmaInit
    aPort4ResetPb : out std_logic; -- IO Socket\Port4\ResetPb
    uPort4AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port4\Tx\TData0
    uPort4AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port4\Tx\TData1
    uPort4AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port4\Tx\TData2
    uPort4AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port4\Tx\TData3
    uPort4AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port4\Tx\TKeep
    uPort4AxiTxTLast : out std_logic; -- IO Socket\Port4\Tx\TLast
    uPort4AxiTxTValid : out std_logic; -- IO Socket\Port4\Tx\TValid
    uPort4AxiTxTReady : in std_logic; -- IO Socket\Port4\Tx\TReady
    uPort4AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port4\Rx\TData0
    uPort4AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port4\Rx\TData1
    uPort4AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port4\Rx\TData2
    uPort4AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port4\Rx\TData3
    uPort4AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port4\Rx\TKeep
    uPort4AxiRxTLast : in std_logic; -- IO Socket\Port4\Rx\TLast
    uPort4AxiRxTValid : in std_logic; -- IO Socket\Port4\Rx\TValid
    uPort4AxiNfcTValid : out std_logic; -- IO Socket\Port4\Nfc\TValid
    uPort4AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port4\Nfc\TData
    uPort4AxiNfcTReady : in std_logic; -- IO Socket\Port4\Nfc\TReady
    uPort4HardError : in std_logic; -- IO Socket\Port4\HardError
    uPort4SoftError : in std_logic; -- IO Socket\Port4\SoftError
    uPort4LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port4\LaneUp
    uPort4ChannelUp : in std_logic; -- IO Socket\Port4\ChannelUp
    uPort4SysResetOut : in std_logic; -- IO Socket\Port4\SysResetOut
    uPort4MmcmNotLockOut : in std_logic; -- IO Socket\Port4\MmcmNotLockOut
    uPort4CrcPassFail_n : in std_logic; -- IO Socket\Port4\CrcPassFail_n
    uPort4CrcValid : in std_logic; -- IO Socket\Port4\CrcValid
    iPort4LinkResetOut : in std_logic; -- IO Socket\Port4\LinkResetOut
    sGtwiz4CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port4\CtrlAxi\AWAddr
    sGtwiz4CtrlAxiAWValid : out std_logic; -- IO Socket\Port4\CtrlAxi\AWValid
    sGtwiz4CtrlAxiAWReady : in std_logic; -- IO Socket\Port4\CtrlAxi\AWReady
    sGtwiz4CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port4\CtrlAxi\WData
    sGtwiz4CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port4\CtrlAxi\WStrb
    sGtwiz4CtrlAxiWValid : out std_logic; -- IO Socket\Port4\CtrlAxi\WValid
    sGtwiz4CtrlAxiWReady : in std_logic; -- IO Socket\Port4\CtrlAxi\WReady
    sGtwiz4CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port4\CtrlAxi\BResp
    sGtwiz4CtrlAxiBValid : in std_logic; -- IO Socket\Port4\CtrlAxi\BValid
    sGtwiz4CtrlAxiBReady : out std_logic; -- IO Socket\Port4\CtrlAxi\BReady
    sGtwiz4CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port4\CtrlAxi\ARAddr
    sGtwiz4CtrlAxiARValid : out std_logic; -- IO Socket\Port4\CtrlAxi\ARValid
    sGtwiz4CtrlAxiARReady : in std_logic; -- IO Socket\Port4\CtrlAxi\ARReady
    sGtwiz4CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port4\CtrlAxi\RData
    sGtwiz4CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port4\CtrlAxi\RResp
    sGtwiz4CtrlAxiRValid : in std_logic; -- IO Socket\Port4\CtrlAxi\RValid
    sGtwiz4CtrlAxiRReady : out std_logic; -- IO Socket\Port4\CtrlAxi\RReady
    sGtwiz4DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port4\DrpChAxi\AWAddr
    sGtwiz4DrpChAxiAWValid : out std_logic; -- IO Socket\Port4\DrpChAxi\AWValid
    sGtwiz4DrpChAxiAWReady : in std_logic; -- IO Socket\Port4\DrpChAxi\AWReady
    sGtwiz4DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port4\DrpChAxi\WData
    sGtwiz4DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port4\DrpChAxi\WStrb
    sGtwiz4DrpChAxiWValid : out std_logic; -- IO Socket\Port4\DrpChAxi\WValid
    sGtwiz4DrpChAxiWReady : in std_logic; -- IO Socket\Port4\DrpChAxi\WReady
    sGtwiz4DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port4\DrpChAxi\BResp
    sGtwiz4DrpChAxiBValid : in std_logic; -- IO Socket\Port4\DrpChAxi\BValid
    sGtwiz4DrpChAxiBReady : out std_logic; -- IO Socket\Port4\DrpChAxi\BReady
    sGtwiz4DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port4\DrpChAxi\ARAddr
    sGtwiz4DrpChAxiARValid : out std_logic; -- IO Socket\Port4\DrpChAxi\ARValid
    sGtwiz4DrpChAxiARReady : in std_logic; -- IO Socket\Port4\DrpChAxi\ARReady
    sGtwiz4DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port4\DrpChAxi\RData
    sGtwiz4DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port4\DrpChAxi\RResp
    sGtwiz4DrpChAxiRValid : in std_logic; -- IO Socket\Port4\DrpChAxi\RValid
    sGtwiz4DrpChAxiRReady : out std_logic; -- IO Socket\Port4\DrpChAxi\RReady
    UserClkPort5 : in std_logic; -- IO Socket\Port5 User Clock
    aPort5PmaInit : out std_logic; -- IO Socket\Port5\PmaInit
    aPort5ResetPb : out std_logic; -- IO Socket\Port5\ResetPb
    uPort5AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port5\Tx\TData0
    uPort5AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port5\Tx\TData1
    uPort5AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port5\Tx\TData2
    uPort5AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port5\Tx\TData3
    uPort5AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port5\Tx\TKeep
    uPort5AxiTxTLast : out std_logic; -- IO Socket\Port5\Tx\TLast
    uPort5AxiTxTValid : out std_logic; -- IO Socket\Port5\Tx\TValid
    uPort5AxiTxTReady : in std_logic; -- IO Socket\Port5\Tx\TReady
    uPort5AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port5\Rx\TData0
    uPort5AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port5\Rx\TData1
    uPort5AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port5\Rx\TData2
    uPort5AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port5\Rx\TData3
    uPort5AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port5\Rx\TKeep
    uPort5AxiRxTLast : in std_logic; -- IO Socket\Port5\Rx\TLast
    uPort5AxiRxTValid : in std_logic; -- IO Socket\Port5\Rx\TValid
    uPort5AxiNfcTValid : out std_logic; -- IO Socket\Port5\Nfc\TValid
    uPort5AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port5\Nfc\TData
    uPort5AxiNfcTReady : in std_logic; -- IO Socket\Port5\Nfc\TReady
    uPort5HardError : in std_logic; -- IO Socket\Port5\HardError
    uPort5SoftError : in std_logic; -- IO Socket\Port5\SoftError
    uPort5LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port5\LaneUp
    uPort5ChannelUp : in std_logic; -- IO Socket\Port5\ChannelUp
    uPort5SysResetOut : in std_logic; -- IO Socket\Port5\SysResetOut
    uPort5MmcmNotLockOut : in std_logic; -- IO Socket\Port5\MmcmNotLockOut
    uPort5CrcPassFail_n : in std_logic; -- IO Socket\Port5\CrcPassFail_n
    uPort5CrcValid : in std_logic; -- IO Socket\Port5\CrcValid
    iPort5LinkResetOut : in std_logic; -- IO Socket\Port5\LinkResetOut
    sGtwiz5CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port5\CtrlAxi\AWAddr
    sGtwiz5CtrlAxiAWValid : out std_logic; -- IO Socket\Port5\CtrlAxi\AWValid
    sGtwiz5CtrlAxiAWReady : in std_logic; -- IO Socket\Port5\CtrlAxi\AWReady
    sGtwiz5CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port5\CtrlAxi\WData
    sGtwiz5CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port5\CtrlAxi\WStrb
    sGtwiz5CtrlAxiWValid : out std_logic; -- IO Socket\Port5\CtrlAxi\WValid
    sGtwiz5CtrlAxiWReady : in std_logic; -- IO Socket\Port5\CtrlAxi\WReady
    sGtwiz5CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port5\CtrlAxi\BResp
    sGtwiz5CtrlAxiBValid : in std_logic; -- IO Socket\Port5\CtrlAxi\BValid
    sGtwiz5CtrlAxiBReady : out std_logic; -- IO Socket\Port5\CtrlAxi\BReady
    sGtwiz5CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port5\CtrlAxi\ARAddr
    sGtwiz5CtrlAxiARValid : out std_logic; -- IO Socket\Port5\CtrlAxi\ARValid
    sGtwiz5CtrlAxiARReady : in std_logic; -- IO Socket\Port5\CtrlAxi\ARReady
    sGtwiz5CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port5\CtrlAxi\RData
    sGtwiz5CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port5\CtrlAxi\RResp
    sGtwiz5CtrlAxiRValid : in std_logic; -- IO Socket\Port5\CtrlAxi\RValid
    sGtwiz5CtrlAxiRReady : out std_logic; -- IO Socket\Port5\CtrlAxi\RReady
    sGtwiz5DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port5\DrpChAxi\AWAddr
    sGtwiz5DrpChAxiAWValid : out std_logic; -- IO Socket\Port5\DrpChAxi\AWValid
    sGtwiz5DrpChAxiAWReady : in std_logic; -- IO Socket\Port5\DrpChAxi\AWReady
    sGtwiz5DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port5\DrpChAxi\WData
    sGtwiz5DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port5\DrpChAxi\WStrb
    sGtwiz5DrpChAxiWValid : out std_logic; -- IO Socket\Port5\DrpChAxi\WValid
    sGtwiz5DrpChAxiWReady : in std_logic; -- IO Socket\Port5\DrpChAxi\WReady
    sGtwiz5DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port5\DrpChAxi\BResp
    sGtwiz5DrpChAxiBValid : in std_logic; -- IO Socket\Port5\DrpChAxi\BValid
    sGtwiz5DrpChAxiBReady : out std_logic; -- IO Socket\Port5\DrpChAxi\BReady
    sGtwiz5DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port5\DrpChAxi\ARAddr
    sGtwiz5DrpChAxiARValid : out std_logic; -- IO Socket\Port5\DrpChAxi\ARValid
    sGtwiz5DrpChAxiARReady : in std_logic; -- IO Socket\Port5\DrpChAxi\ARReady
    sGtwiz5DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port5\DrpChAxi\RData
    sGtwiz5DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port5\DrpChAxi\RResp
    sGtwiz5DrpChAxiRValid : in std_logic; -- IO Socket\Port5\DrpChAxi\RValid
    sGtwiz5DrpChAxiRReady : out std_logic; -- IO Socket\Port5\DrpChAxi\RReady
    UserClkPort6 : in std_logic; -- IO Socket\Port6 User Clock
    aPort6PmaInit : out std_logic; -- IO Socket\Port6\PmaInit
    aPort6ResetPb : out std_logic; -- IO Socket\Port6\ResetPb
    uPort6AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port6\Tx\TData0
    uPort6AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port6\Tx\TData1
    uPort6AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port6\Tx\TData2
    uPort6AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port6\Tx\TData3
    uPort6AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port6\Tx\TKeep
    uPort6AxiTxTLast : out std_logic; -- IO Socket\Port6\Tx\TLast
    uPort6AxiTxTValid : out std_logic; -- IO Socket\Port6\Tx\TValid
    uPort6AxiTxTReady : in std_logic; -- IO Socket\Port6\Tx\TReady
    uPort6AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port6\Rx\TData0
    uPort6AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port6\Rx\TData1
    uPort6AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port6\Rx\TData2
    uPort6AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port6\Rx\TData3
    uPort6AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port6\Rx\TKeep
    uPort6AxiRxTLast : in std_logic; -- IO Socket\Port6\Rx\TLast
    uPort6AxiRxTValid : in std_logic; -- IO Socket\Port6\Rx\TValid
    uPort6AxiNfcTValid : out std_logic; -- IO Socket\Port6\Nfc\TValid
    uPort6AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port6\Nfc\TData
    uPort6AxiNfcTReady : in std_logic; -- IO Socket\Port6\Nfc\TReady
    uPort6HardError : in std_logic; -- IO Socket\Port6\HardError
    uPort6SoftError : in std_logic; -- IO Socket\Port6\SoftError
    uPort6LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port6\LaneUp
    uPort6ChannelUp : in std_logic; -- IO Socket\Port6\ChannelUp
    uPort6SysResetOut : in std_logic; -- IO Socket\Port6\SysResetOut
    uPort6MmcmNotLockOut : in std_logic; -- IO Socket\Port6\MmcmNotLockOut
    uPort6CrcPassFail_n : in std_logic; -- IO Socket\Port6\CrcPassFail_n
    uPort6CrcValid : in std_logic; -- IO Socket\Port6\CrcValid
    iPort6LinkResetOut : in std_logic; -- IO Socket\Port6\LinkResetOut
    sGtwiz6CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port6\CtrlAxi\AWAddr
    sGtwiz6CtrlAxiAWValid : out std_logic; -- IO Socket\Port6\CtrlAxi\AWValid
    sGtwiz6CtrlAxiAWReady : in std_logic; -- IO Socket\Port6\CtrlAxi\AWReady
    sGtwiz6CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port6\CtrlAxi\WData
    sGtwiz6CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port6\CtrlAxi\WStrb
    sGtwiz6CtrlAxiWValid : out std_logic; -- IO Socket\Port6\CtrlAxi\WValid
    sGtwiz6CtrlAxiWReady : in std_logic; -- IO Socket\Port6\CtrlAxi\WReady
    sGtwiz6CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port6\CtrlAxi\BResp
    sGtwiz6CtrlAxiBValid : in std_logic; -- IO Socket\Port6\CtrlAxi\BValid
    sGtwiz6CtrlAxiBReady : out std_logic; -- IO Socket\Port6\CtrlAxi\BReady
    sGtwiz6CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port6\CtrlAxi\ARAddr
    sGtwiz6CtrlAxiARValid : out std_logic; -- IO Socket\Port6\CtrlAxi\ARValid
    sGtwiz6CtrlAxiARReady : in std_logic; -- IO Socket\Port6\CtrlAxi\ARReady
    sGtwiz6CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port6\CtrlAxi\RData
    sGtwiz6CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port6\CtrlAxi\RResp
    sGtwiz6CtrlAxiRValid : in std_logic; -- IO Socket\Port6\CtrlAxi\RValid
    sGtwiz6CtrlAxiRReady : out std_logic; -- IO Socket\Port6\CtrlAxi\RReady
    sGtwiz6DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port6\DrpChAxi\AWAddr
    sGtwiz6DrpChAxiAWValid : out std_logic; -- IO Socket\Port6\DrpChAxi\AWValid
    sGtwiz6DrpChAxiAWReady : in std_logic; -- IO Socket\Port6\DrpChAxi\AWReady
    sGtwiz6DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port6\DrpChAxi\WData
    sGtwiz6DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port6\DrpChAxi\WStrb
    sGtwiz6DrpChAxiWValid : out std_logic; -- IO Socket\Port6\DrpChAxi\WValid
    sGtwiz6DrpChAxiWReady : in std_logic; -- IO Socket\Port6\DrpChAxi\WReady
    sGtwiz6DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port6\DrpChAxi\BResp
    sGtwiz6DrpChAxiBValid : in std_logic; -- IO Socket\Port6\DrpChAxi\BValid
    sGtwiz6DrpChAxiBReady : out std_logic; -- IO Socket\Port6\DrpChAxi\BReady
    sGtwiz6DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port6\DrpChAxi\ARAddr
    sGtwiz6DrpChAxiARValid : out std_logic; -- IO Socket\Port6\DrpChAxi\ARValid
    sGtwiz6DrpChAxiARReady : in std_logic; -- IO Socket\Port6\DrpChAxi\ARReady
    sGtwiz6DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port6\DrpChAxi\RData
    sGtwiz6DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port6\DrpChAxi\RResp
    sGtwiz6DrpChAxiRValid : in std_logic; -- IO Socket\Port6\DrpChAxi\RValid
    sGtwiz6DrpChAxiRReady : out std_logic; -- IO Socket\Port6\DrpChAxi\RReady
    UserClkPort7 : in std_logic; -- IO Socket\Port7 User Clock
    aPort7PmaInit : out std_logic; -- IO Socket\Port7\PmaInit
    aPort7ResetPb : out std_logic; -- IO Socket\Port7\ResetPb
    uPort7AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port7\Tx\TData0
    uPort7AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port7\Tx\TData1
    uPort7AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port7\Tx\TData2
    uPort7AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port7\Tx\TData3
    uPort7AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port7\Tx\TKeep
    uPort7AxiTxTLast : out std_logic; -- IO Socket\Port7\Tx\TLast
    uPort7AxiTxTValid : out std_logic; -- IO Socket\Port7\Tx\TValid
    uPort7AxiTxTReady : in std_logic; -- IO Socket\Port7\Tx\TReady
    uPort7AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port7\Rx\TData0
    uPort7AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port7\Rx\TData1
    uPort7AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port7\Rx\TData2
    uPort7AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port7\Rx\TData3
    uPort7AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port7\Rx\TKeep
    uPort7AxiRxTLast : in std_logic; -- IO Socket\Port7\Rx\TLast
    uPort7AxiRxTValid : in std_logic; -- IO Socket\Port7\Rx\TValid
    uPort7AxiNfcTValid : out std_logic; -- IO Socket\Port7\Nfc\TValid
    uPort7AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port7\Nfc\TData
    uPort7AxiNfcTReady : in std_logic; -- IO Socket\Port7\Nfc\TReady
    uPort7HardError : in std_logic; -- IO Socket\Port7\HardError
    uPort7SoftError : in std_logic; -- IO Socket\Port7\SoftError
    uPort7LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port7\LaneUp
    uPort7ChannelUp : in std_logic; -- IO Socket\Port7\ChannelUp
    uPort7SysResetOut : in std_logic; -- IO Socket\Port7\SysResetOut
    uPort7MmcmNotLockOut : in std_logic; -- IO Socket\Port7\MmcmNotLockOut
    uPort7CrcPassFail_n : in std_logic; -- IO Socket\Port7\CrcPassFail_n
    uPort7CrcValid : in std_logic; -- IO Socket\Port7\CrcValid
    iPort7LinkResetOut : in std_logic; -- IO Socket\Port7\LinkResetOut
    sGtwiz7CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port7\CtrlAxi\AWAddr
    sGtwiz7CtrlAxiAWValid : out std_logic; -- IO Socket\Port7\CtrlAxi\AWValid
    sGtwiz7CtrlAxiAWReady : in std_logic; -- IO Socket\Port7\CtrlAxi\AWReady
    sGtwiz7CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port7\CtrlAxi\WData
    sGtwiz7CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port7\CtrlAxi\WStrb
    sGtwiz7CtrlAxiWValid : out std_logic; -- IO Socket\Port7\CtrlAxi\WValid
    sGtwiz7CtrlAxiWReady : in std_logic; -- IO Socket\Port7\CtrlAxi\WReady
    sGtwiz7CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port7\CtrlAxi\BResp
    sGtwiz7CtrlAxiBValid : in std_logic; -- IO Socket\Port7\CtrlAxi\BValid
    sGtwiz7CtrlAxiBReady : out std_logic; -- IO Socket\Port7\CtrlAxi\BReady
    sGtwiz7CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port7\CtrlAxi\ARAddr
    sGtwiz7CtrlAxiARValid : out std_logic; -- IO Socket\Port7\CtrlAxi\ARValid
    sGtwiz7CtrlAxiARReady : in std_logic; -- IO Socket\Port7\CtrlAxi\ARReady
    sGtwiz7CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port7\CtrlAxi\RData
    sGtwiz7CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port7\CtrlAxi\RResp
    sGtwiz7CtrlAxiRValid : in std_logic; -- IO Socket\Port7\CtrlAxi\RValid
    sGtwiz7CtrlAxiRReady : out std_logic; -- IO Socket\Port7\CtrlAxi\RReady
    sGtwiz7DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port7\DrpChAxi\AWAddr
    sGtwiz7DrpChAxiAWValid : out std_logic; -- IO Socket\Port7\DrpChAxi\AWValid
    sGtwiz7DrpChAxiAWReady : in std_logic; -- IO Socket\Port7\DrpChAxi\AWReady
    sGtwiz7DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port7\DrpChAxi\WData
    sGtwiz7DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port7\DrpChAxi\WStrb
    sGtwiz7DrpChAxiWValid : out std_logic; -- IO Socket\Port7\DrpChAxi\WValid
    sGtwiz7DrpChAxiWReady : in std_logic; -- IO Socket\Port7\DrpChAxi\WReady
    sGtwiz7DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port7\DrpChAxi\BResp
    sGtwiz7DrpChAxiBValid : in std_logic; -- IO Socket\Port7\DrpChAxi\BValid
    sGtwiz7DrpChAxiBReady : out std_logic; -- IO Socket\Port7\DrpChAxi\BReady
    sGtwiz7DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port7\DrpChAxi\ARAddr
    sGtwiz7DrpChAxiARValid : out std_logic; -- IO Socket\Port7\DrpChAxi\ARValid
    sGtwiz7DrpChAxiARReady : in std_logic; -- IO Socket\Port7\DrpChAxi\ARReady
    sGtwiz7DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port7\DrpChAxi\RData
    sGtwiz7DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port7\DrpChAxi\RResp
    sGtwiz7DrpChAxiRValid : in std_logic; -- IO Socket\Port7\DrpChAxi\RValid
    sGtwiz7DrpChAxiRReady : out std_logic; -- IO Socket\Port7\DrpChAxi\RReady
    UserClkPort8 : in std_logic; -- IO Socket\Port8 User Clock
    aPort8PmaInit : out std_logic; -- IO Socket\Port8\PmaInit
    aPort8ResetPb : out std_logic; -- IO Socket\Port8\ResetPb
    uPort8AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port8\Tx\TData0
    uPort8AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port8\Tx\TData1
    uPort8AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port8\Tx\TData2
    uPort8AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port8\Tx\TData3
    uPort8AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port8\Tx\TKeep
    uPort8AxiTxTLast : out std_logic; -- IO Socket\Port8\Tx\TLast
    uPort8AxiTxTValid : out std_logic; -- IO Socket\Port8\Tx\TValid
    uPort8AxiTxTReady : in std_logic; -- IO Socket\Port8\Tx\TReady
    uPort8AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port8\Rx\TData0
    uPort8AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port8\Rx\TData1
    uPort8AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port8\Rx\TData2
    uPort8AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port8\Rx\TData3
    uPort8AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port8\Rx\TKeep
    uPort8AxiRxTLast : in std_logic; -- IO Socket\Port8\Rx\TLast
    uPort8AxiRxTValid : in std_logic; -- IO Socket\Port8\Rx\TValid
    uPort8AxiNfcTValid : out std_logic; -- IO Socket\Port8\Nfc\TValid
    uPort8AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port8\Nfc\TData
    uPort8AxiNfcTReady : in std_logic; -- IO Socket\Port8\Nfc\TReady
    uPort8HardError : in std_logic; -- IO Socket\Port8\HardError
    uPort8SoftError : in std_logic; -- IO Socket\Port8\SoftError
    uPort8LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port8\LaneUp
    uPort8ChannelUp : in std_logic; -- IO Socket\Port8\ChannelUp
    uPort8SysResetOut : in std_logic; -- IO Socket\Port8\SysResetOut
    uPort8MmcmNotLockOut : in std_logic; -- IO Socket\Port8\MmcmNotLockOut
    uPort8CrcPassFail_n : in std_logic; -- IO Socket\Port8\CrcPassFail_n
    uPort8CrcValid : in std_logic; -- IO Socket\Port8\CrcValid
    iPort8LinkResetOut : in std_logic; -- IO Socket\Port8\LinkResetOut
    sGtwiz8CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port8\CtrlAxi\AWAddr
    sGtwiz8CtrlAxiAWValid : out std_logic; -- IO Socket\Port8\CtrlAxi\AWValid
    sGtwiz8CtrlAxiAWReady : in std_logic; -- IO Socket\Port8\CtrlAxi\AWReady
    sGtwiz8CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port8\CtrlAxi\WData
    sGtwiz8CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port8\CtrlAxi\WStrb
    sGtwiz8CtrlAxiWValid : out std_logic; -- IO Socket\Port8\CtrlAxi\WValid
    sGtwiz8CtrlAxiWReady : in std_logic; -- IO Socket\Port8\CtrlAxi\WReady
    sGtwiz8CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port8\CtrlAxi\BResp
    sGtwiz8CtrlAxiBValid : in std_logic; -- IO Socket\Port8\CtrlAxi\BValid
    sGtwiz8CtrlAxiBReady : out std_logic; -- IO Socket\Port8\CtrlAxi\BReady
    sGtwiz8CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port8\CtrlAxi\ARAddr
    sGtwiz8CtrlAxiARValid : out std_logic; -- IO Socket\Port8\CtrlAxi\ARValid
    sGtwiz8CtrlAxiARReady : in std_logic; -- IO Socket\Port8\CtrlAxi\ARReady
    sGtwiz8CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port8\CtrlAxi\RData
    sGtwiz8CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port8\CtrlAxi\RResp
    sGtwiz8CtrlAxiRValid : in std_logic; -- IO Socket\Port8\CtrlAxi\RValid
    sGtwiz8CtrlAxiRReady : out std_logic; -- IO Socket\Port8\CtrlAxi\RReady
    sGtwiz8DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port8\DrpChAxi\AWAddr
    sGtwiz8DrpChAxiAWValid : out std_logic; -- IO Socket\Port8\DrpChAxi\AWValid
    sGtwiz8DrpChAxiAWReady : in std_logic; -- IO Socket\Port8\DrpChAxi\AWReady
    sGtwiz8DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port8\DrpChAxi\WData
    sGtwiz8DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port8\DrpChAxi\WStrb
    sGtwiz8DrpChAxiWValid : out std_logic; -- IO Socket\Port8\DrpChAxi\WValid
    sGtwiz8DrpChAxiWReady : in std_logic; -- IO Socket\Port8\DrpChAxi\WReady
    sGtwiz8DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port8\DrpChAxi\BResp
    sGtwiz8DrpChAxiBValid : in std_logic; -- IO Socket\Port8\DrpChAxi\BValid
    sGtwiz8DrpChAxiBReady : out std_logic; -- IO Socket\Port8\DrpChAxi\BReady
    sGtwiz8DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port8\DrpChAxi\ARAddr
    sGtwiz8DrpChAxiARValid : out std_logic; -- IO Socket\Port8\DrpChAxi\ARValid
    sGtwiz8DrpChAxiARReady : in std_logic; -- IO Socket\Port8\DrpChAxi\ARReady
    sGtwiz8DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port8\DrpChAxi\RData
    sGtwiz8DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port8\DrpChAxi\RResp
    sGtwiz8DrpChAxiRValid : in std_logic; -- IO Socket\Port8\DrpChAxi\RValid
    sGtwiz8DrpChAxiRReady : out std_logic; -- IO Socket\Port8\DrpChAxi\RReady
    UserClkPort9 : in std_logic; -- IO Socket\Port9 User Clock
    aPort9PmaInit : out std_logic; -- IO Socket\Port9\PmaInit
    aPort9ResetPb : out std_logic; -- IO Socket\Port9\ResetPb
    uPort9AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port9\Tx\TData0
    uPort9AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port9\Tx\TData1
    uPort9AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port9\Tx\TData2
    uPort9AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port9\Tx\TData3
    uPort9AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port9\Tx\TKeep
    uPort9AxiTxTLast : out std_logic; -- IO Socket\Port9\Tx\TLast
    uPort9AxiTxTValid : out std_logic; -- IO Socket\Port9\Tx\TValid
    uPort9AxiTxTReady : in std_logic; -- IO Socket\Port9\Tx\TReady
    uPort9AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port9\Rx\TData0
    uPort9AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port9\Rx\TData1
    uPort9AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port9\Rx\TData2
    uPort9AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port9\Rx\TData3
    uPort9AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port9\Rx\TKeep
    uPort9AxiRxTLast : in std_logic; -- IO Socket\Port9\Rx\TLast
    uPort9AxiRxTValid : in std_logic; -- IO Socket\Port9\Rx\TValid
    uPort9AxiNfcTValid : out std_logic; -- IO Socket\Port9\Nfc\TValid
    uPort9AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port9\Nfc\TData
    uPort9AxiNfcTReady : in std_logic; -- IO Socket\Port9\Nfc\TReady
    uPort9HardError : in std_logic; -- IO Socket\Port9\HardError
    uPort9SoftError : in std_logic; -- IO Socket\Port9\SoftError
    uPort9LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port9\LaneUp
    uPort9ChannelUp : in std_logic; -- IO Socket\Port9\ChannelUp
    uPort9SysResetOut : in std_logic; -- IO Socket\Port9\SysResetOut
    uPort9MmcmNotLockOut : in std_logic; -- IO Socket\Port9\MmcmNotLockOut
    uPort9CrcPassFail_n : in std_logic; -- IO Socket\Port9\CrcPassFail_n
    uPort9CrcValid : in std_logic; -- IO Socket\Port9\CrcValid
    iPort9LinkResetOut : in std_logic; -- IO Socket\Port9\LinkResetOut
    sGtwiz9CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port9\CtrlAxi\AWAddr
    sGtwiz9CtrlAxiAWValid : out std_logic; -- IO Socket\Port9\CtrlAxi\AWValid
    sGtwiz9CtrlAxiAWReady : in std_logic; -- IO Socket\Port9\CtrlAxi\AWReady
    sGtwiz9CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port9\CtrlAxi\WData
    sGtwiz9CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port9\CtrlAxi\WStrb
    sGtwiz9CtrlAxiWValid : out std_logic; -- IO Socket\Port9\CtrlAxi\WValid
    sGtwiz9CtrlAxiWReady : in std_logic; -- IO Socket\Port9\CtrlAxi\WReady
    sGtwiz9CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port9\CtrlAxi\BResp
    sGtwiz9CtrlAxiBValid : in std_logic; -- IO Socket\Port9\CtrlAxi\BValid
    sGtwiz9CtrlAxiBReady : out std_logic; -- IO Socket\Port9\CtrlAxi\BReady
    sGtwiz9CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port9\CtrlAxi\ARAddr
    sGtwiz9CtrlAxiARValid : out std_logic; -- IO Socket\Port9\CtrlAxi\ARValid
    sGtwiz9CtrlAxiARReady : in std_logic; -- IO Socket\Port9\CtrlAxi\ARReady
    sGtwiz9CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port9\CtrlAxi\RData
    sGtwiz9CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port9\CtrlAxi\RResp
    sGtwiz9CtrlAxiRValid : in std_logic; -- IO Socket\Port9\CtrlAxi\RValid
    sGtwiz9CtrlAxiRReady : out std_logic; -- IO Socket\Port9\CtrlAxi\RReady
    sGtwiz9DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port9\DrpChAxi\AWAddr
    sGtwiz9DrpChAxiAWValid : out std_logic; -- IO Socket\Port9\DrpChAxi\AWValid
    sGtwiz9DrpChAxiAWReady : in std_logic; -- IO Socket\Port9\DrpChAxi\AWReady
    sGtwiz9DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port9\DrpChAxi\WData
    sGtwiz9DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port9\DrpChAxi\WStrb
    sGtwiz9DrpChAxiWValid : out std_logic; -- IO Socket\Port9\DrpChAxi\WValid
    sGtwiz9DrpChAxiWReady : in std_logic; -- IO Socket\Port9\DrpChAxi\WReady
    sGtwiz9DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port9\DrpChAxi\BResp
    sGtwiz9DrpChAxiBValid : in std_logic; -- IO Socket\Port9\DrpChAxi\BValid
    sGtwiz9DrpChAxiBReady : out std_logic; -- IO Socket\Port9\DrpChAxi\BReady
    sGtwiz9DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port9\DrpChAxi\ARAddr
    sGtwiz9DrpChAxiARValid : out std_logic; -- IO Socket\Port9\DrpChAxi\ARValid
    sGtwiz9DrpChAxiARReady : in std_logic; -- IO Socket\Port9\DrpChAxi\ARReady
    sGtwiz9DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port9\DrpChAxi\RData
    sGtwiz9DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port9\DrpChAxi\RResp
    sGtwiz9DrpChAxiRValid : in std_logic; -- IO Socket\Port9\DrpChAxi\RValid
    sGtwiz9DrpChAxiRReady : out std_logic; -- IO Socket\Port9\DrpChAxi\RReady
    UserClkPort10 : in std_logic; -- IO Socket\Port10 User Clock
    aPort10PmaInit : out std_logic; -- IO Socket\Port10\PmaInit
    aPort10ResetPb : out std_logic; -- IO Socket\Port10\ResetPb
    uPort10AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port10\Tx\TData0
    uPort10AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port10\Tx\TData1
    uPort10AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port10\Tx\TData2
    uPort10AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port10\Tx\TData3
    uPort10AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port10\Tx\TKeep
    uPort10AxiTxTLast : out std_logic; -- IO Socket\Port10\Tx\TLast
    uPort10AxiTxTValid : out std_logic; -- IO Socket\Port10\Tx\TValid
    uPort10AxiTxTReady : in std_logic; -- IO Socket\Port10\Tx\TReady
    uPort10AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port10\Rx\TData0
    uPort10AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port10\Rx\TData1
    uPort10AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port10\Rx\TData2
    uPort10AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port10\Rx\TData3
    uPort10AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port10\Rx\TKeep
    uPort10AxiRxTLast : in std_logic; -- IO Socket\Port10\Rx\TLast
    uPort10AxiRxTValid : in std_logic; -- IO Socket\Port10\Rx\TValid
    uPort10AxiNfcTValid : out std_logic; -- IO Socket\Port10\Nfc\TValid
    uPort10AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port10\Nfc\TData
    uPort10AxiNfcTReady : in std_logic; -- IO Socket\Port10\Nfc\TReady
    uPort10HardError : in std_logic; -- IO Socket\Port10\HardError
    uPort10SoftError : in std_logic; -- IO Socket\Port10\SoftError
    uPort10LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port10\LaneUp
    uPort10ChannelUp : in std_logic; -- IO Socket\Port10\ChannelUp
    uPort10SysResetOut : in std_logic; -- IO Socket\Port10\SysResetOut
    uPort10MmcmNotLockOut : in std_logic; -- IO Socket\Port10\MmcmNotLockOut
    uPort10CrcPassFail_n : in std_logic; -- IO Socket\Port10\CrcPassFail_n
    uPort10CrcValid : in std_logic; -- IO Socket\Port10\CrcValid
    iPort10LinkResetOut : in std_logic; -- IO Socket\Port10\LinkResetOut
    sGtwiz10CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port10\CtrlAxi\AWAddr
    sGtwiz10CtrlAxiAWValid : out std_logic; -- IO Socket\Port10\CtrlAxi\AWValid
    sGtwiz10CtrlAxiAWReady : in std_logic; -- IO Socket\Port10\CtrlAxi\AWReady
    sGtwiz10CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port10\CtrlAxi\WData
    sGtwiz10CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port10\CtrlAxi\WStrb
    sGtwiz10CtrlAxiWValid : out std_logic; -- IO Socket\Port10\CtrlAxi\WValid
    sGtwiz10CtrlAxiWReady : in std_logic; -- IO Socket\Port10\CtrlAxi\WReady
    sGtwiz10CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port10\CtrlAxi\BResp
    sGtwiz10CtrlAxiBValid : in std_logic; -- IO Socket\Port10\CtrlAxi\BValid
    sGtwiz10CtrlAxiBReady : out std_logic; -- IO Socket\Port10\CtrlAxi\BReady
    sGtwiz10CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port10\CtrlAxi\ARAddr
    sGtwiz10CtrlAxiARValid : out std_logic; -- IO Socket\Port10\CtrlAxi\ARValid
    sGtwiz10CtrlAxiARReady : in std_logic; -- IO Socket\Port10\CtrlAxi\ARReady
    sGtwiz10CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port10\CtrlAxi\RData
    sGtwiz10CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port10\CtrlAxi\RResp
    sGtwiz10CtrlAxiRValid : in std_logic; -- IO Socket\Port10\CtrlAxi\RValid
    sGtwiz10CtrlAxiRReady : out std_logic; -- IO Socket\Port10\CtrlAxi\RReady
    sGtwiz10DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port10\DrpChAxi\AWAddr
    sGtwiz10DrpChAxiAWValid : out std_logic; -- IO Socket\Port10\DrpChAxi\AWValid
    sGtwiz10DrpChAxiAWReady : in std_logic; -- IO Socket\Port10\DrpChAxi\AWReady
    sGtwiz10DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port10\DrpChAxi\WData
    sGtwiz10DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port10\DrpChAxi\WStrb
    sGtwiz10DrpChAxiWValid : out std_logic; -- IO Socket\Port10\DrpChAxi\WValid
    sGtwiz10DrpChAxiWReady : in std_logic; -- IO Socket\Port10\DrpChAxi\WReady
    sGtwiz10DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port10\DrpChAxi\BResp
    sGtwiz10DrpChAxiBValid : in std_logic; -- IO Socket\Port10\DrpChAxi\BValid
    sGtwiz10DrpChAxiBReady : out std_logic; -- IO Socket\Port10\DrpChAxi\BReady
    sGtwiz10DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port10\DrpChAxi\ARAddr
    sGtwiz10DrpChAxiARValid : out std_logic; -- IO Socket\Port10\DrpChAxi\ARValid
    sGtwiz10DrpChAxiARReady : in std_logic; -- IO Socket\Port10\DrpChAxi\ARReady
    sGtwiz10DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port10\DrpChAxi\RData
    sGtwiz10DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port10\DrpChAxi\RResp
    sGtwiz10DrpChAxiRValid : in std_logic; -- IO Socket\Port10\DrpChAxi\RValid
    sGtwiz10DrpChAxiRReady : out std_logic; -- IO Socket\Port10\DrpChAxi\RReady
    UserClkPort11 : in std_logic; -- IO Socket\Port11 User Clock
    aPort11PmaInit : out std_logic; -- IO Socket\Port11\PmaInit
    aPort11ResetPb : out std_logic; -- IO Socket\Port11\ResetPb
    uPort11AxiTxTData0 : out std_logic_vector(63 downto 0); -- IO Socket\Port11\Tx\TData0
    uPort11AxiTxTData1 : out std_logic_vector(63 downto 0); -- IO Socket\Port11\Tx\TData1
    uPort11AxiTxTData2 : out std_logic_vector(63 downto 0); -- IO Socket\Port11\Tx\TData2
    uPort11AxiTxTData3 : out std_logic_vector(63 downto 0); -- IO Socket\Port11\Tx\TData3
    uPort11AxiTxTKeep : out std_logic_vector(31 downto 0); -- IO Socket\Port11\Tx\TKeep
    uPort11AxiTxTLast : out std_logic; -- IO Socket\Port11\Tx\TLast
    uPort11AxiTxTValid : out std_logic; -- IO Socket\Port11\Tx\TValid
    uPort11AxiTxTReady : in std_logic; -- IO Socket\Port11\Tx\TReady
    uPort11AxiRxTData0 : in std_logic_vector(63 downto 0); -- IO Socket\Port11\Rx\TData0
    uPort11AxiRxTData1 : in std_logic_vector(63 downto 0); -- IO Socket\Port11\Rx\TData1
    uPort11AxiRxTData2 : in std_logic_vector(63 downto 0); -- IO Socket\Port11\Rx\TData2
    uPort11AxiRxTData3 : in std_logic_vector(63 downto 0); -- IO Socket\Port11\Rx\TData3
    uPort11AxiRxTKeep : in std_logic_vector(31 downto 0); -- IO Socket\Port11\Rx\TKeep
    uPort11AxiRxTLast : in std_logic; -- IO Socket\Port11\Rx\TLast
    uPort11AxiRxTValid : in std_logic; -- IO Socket\Port11\Rx\TValid
    uPort11AxiNfcTValid : out std_logic; -- IO Socket\Port11\Nfc\TValid
    uPort11AxiNfcTData : out std_logic_vector(31 downto 0); -- IO Socket\Port11\Nfc\TData
    uPort11AxiNfcTReady : in std_logic; -- IO Socket\Port11\Nfc\TReady
    uPort11HardError : in std_logic; -- IO Socket\Port11\HardError
    uPort11SoftError : in std_logic; -- IO Socket\Port11\SoftError
    uPort11LaneUp : in std_logic_vector(3 downto 0); -- IO Socket\Port11\LaneUp
    uPort11ChannelUp : in std_logic; -- IO Socket\Port11\ChannelUp
    uPort11SysResetOut : in std_logic; -- IO Socket\Port11\SysResetOut
    uPort11MmcmNotLockOut : in std_logic; -- IO Socket\Port11\MmcmNotLockOut
    uPort11CrcPassFail_n : in std_logic; -- IO Socket\Port11\CrcPassFail_n
    uPort11CrcValid : in std_logic; -- IO Socket\Port11\CrcValid
    iPort11LinkResetOut : in std_logic; -- IO Socket\Port11\LinkResetOut
    sGtwiz11CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port11\CtrlAxi\AWAddr
    sGtwiz11CtrlAxiAWValid : out std_logic; -- IO Socket\Port11\CtrlAxi\AWValid
    sGtwiz11CtrlAxiAWReady : in std_logic; -- IO Socket\Port11\CtrlAxi\AWReady
    sGtwiz11CtrlAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port11\CtrlAxi\WData
    sGtwiz11CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port11\CtrlAxi\WStrb
    sGtwiz11CtrlAxiWValid : out std_logic; -- IO Socket\Port11\CtrlAxi\WValid
    sGtwiz11CtrlAxiWReady : in std_logic; -- IO Socket\Port11\CtrlAxi\WReady
    sGtwiz11CtrlAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port11\CtrlAxi\BResp
    sGtwiz11CtrlAxiBValid : in std_logic; -- IO Socket\Port11\CtrlAxi\BValid
    sGtwiz11CtrlAxiBReady : out std_logic; -- IO Socket\Port11\CtrlAxi\BReady
    sGtwiz11CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port11\CtrlAxi\ARAddr
    sGtwiz11CtrlAxiARValid : out std_logic; -- IO Socket\Port11\CtrlAxi\ARValid
    sGtwiz11CtrlAxiARReady : in std_logic; -- IO Socket\Port11\CtrlAxi\ARReady
    sGtwiz11CtrlAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port11\CtrlAxi\RData
    sGtwiz11CtrlAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port11\CtrlAxi\RResp
    sGtwiz11CtrlAxiRValid : in std_logic; -- IO Socket\Port11\CtrlAxi\RValid
    sGtwiz11CtrlAxiRReady : out std_logic; -- IO Socket\Port11\CtrlAxi\RReady
    sGtwiz11DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port11\DrpChAxi\AWAddr
    sGtwiz11DrpChAxiAWValid : out std_logic; -- IO Socket\Port11\DrpChAxi\AWValid
    sGtwiz11DrpChAxiAWReady : in std_logic; -- IO Socket\Port11\DrpChAxi\AWReady
    sGtwiz11DrpChAxiWData : out std_logic_vector(31 downto 0); -- IO Socket\Port11\DrpChAxi\WData
    sGtwiz11DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- IO Socket\Port11\DrpChAxi\WStrb
    sGtwiz11DrpChAxiWValid : out std_logic; -- IO Socket\Port11\DrpChAxi\WValid
    sGtwiz11DrpChAxiWReady : in std_logic; -- IO Socket\Port11\DrpChAxi\WReady
    sGtwiz11DrpChAxiBResp : in std_logic_vector(1 downto 0); -- IO Socket\Port11\DrpChAxi\BResp
    sGtwiz11DrpChAxiBValid : in std_logic; -- IO Socket\Port11\DrpChAxi\BValid
    sGtwiz11DrpChAxiBReady : out std_logic; -- IO Socket\Port11\DrpChAxi\BReady
    sGtwiz11DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- IO Socket\Port11\DrpChAxi\ARAddr
    sGtwiz11DrpChAxiARValid : out std_logic; -- IO Socket\Port11\DrpChAxi\ARValid
    sGtwiz11DrpChAxiARReady : in std_logic; -- IO Socket\Port11\DrpChAxi\ARReady
    sGtwiz11DrpChAxiRData : in std_logic_vector(31 downto 0); -- IO Socket\Port11\DrpChAxi\RData
    sGtwiz11DrpChAxiRResp : in std_logic_vector(1 downto 0); -- IO Socket\Port11\DrpChAxi\RResp
    sGtwiz11DrpChAxiRValid : in std_logic; -- IO Socket\Port11\DrpChAxi\RValid
    sGtwiz11DrpChAxiRReady : out std_logic; -- IO Socket\Port11\DrpChAxi\RReady

    -----------------------------------
    -- Communication interface ports
    -----------------------------------
    -- Reset ports
    aBusReset : in boolean;

    -- Register Access/ PIO Ports
    bRegPortIn      : in  RegPortIn_t;
    bRegPortOut     : out RegPortOut_t;
    bRegPortTimeout : in  boolean;

    -- DMA Stream Ports
    dInputStreamInterfaceToFifo    : in  InputStreamInterfaceToFifoArray_t (Larger(kNumberOfDmaChannels, 1)-1 downto 0);
    dInputStreamInterfaceFromFifo  : out InputStreamInterfaceFromFifoArray_t (Larger(kNumberOfDmaChannels, 1)-1 downto 0);
    dOutputStreamInterfaceToFifo   : in  OutputStreamInterfaceToFifoArray_t (Larger(kNumberOfDmaChannels, 1)-1 downto 0);
    dOutputStreamInterfaceFromFifo : out OutputStreamInterfaceFromFifoArray_t (Larger(kNumberOfDmaChannels, 1)-1 downto 0);

    -- IRQ Ports
    bIrqToInterface : out IrqToInterfaceArray_t(Larger(kNumberOfIrqs, 1)-1 downto 0);

    -- MasterPort Ports
    dNiFpgaMasterWriteRequestFromMaster : out NiFpgaMasterWriteRequestFromMasterArray_t (Larger(kNumberOfMasterPorts, 1)-1 downto 0);
    dNiFpgaMasterWriteRequestToMaster   : in  NiFpgaMasterWriteRequestToMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1 downto 0);
    dNiFpgaMasterWriteDataFromMaster    : out NiFpgaMasterWriteDataFromMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1 downto 0);
    dNiFpgaMasterWriteDataToMaster      : in  NiFpgaMasterWriteDataToMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1 downto 0);
    dNiFpgaMasterWriteStatusToMaster    : in  NiFpgaMasterWriteStatusToMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1 downto 0);

    dNiFpgaMasterReadRequestFromMaster : out NiFpgaMasterReadRequestFromMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1 downto 0);
    dNiFpgaMasterReadRequestToMaster   : in  NiFpgaMasterReadRequestToMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1 downto 0);
    dNiFpgaMasterReadDataToMaster      : in  NiFpgaMasterReadDataToMasterArray_t(Larger(kNumberOfMasterPorts, 1)-1 downto 0);

    -----------------------------------
    -- Clocks from TopLevel
    -----------------------------------
    DmaClk            : in std_logic;
    BusClk            : in std_logic;
    ReliableClkIn     : in std_logic;
    PllClk80          : in std_logic;
    DlyRefClk         : in std_logic;
    PxieClk100        : in std_logic;
    DramClkLvFpga     : in std_logic;
    Dram0ClkSocket    : in std_logic;
    Dram1ClkSocket    : in std_logic;
    Dram0ClkUser      : in std_logic;
    Dram1ClkUser      : in std_logic;
    dHmbDmaClkSocket  : in std_logic;
    dLlbDmaClkSocket  : in std_logic;


    -----------------------------------
    -- Handshaking signals for derived
    -- clocks on external clocks
    -----------------------------------


    -----------------------------------
    -- IO Node ports
    -----------------------------------
    pIntSync100            : in    std_logic;
    aIntClk10              : in    std_logic;

    -----------------------------------
    -- Target Method and Properties ports
    -----------------------------------
    bdIFifoRdData               : out std_logic_vector(63 downto 0);
    bdIFifoRdDataValid          : out std_logic;
    bdIFifoRdReadyForInput      : in  std_logic;
    bdIFifoRdIsError            : out std_logic;
    bdIFifoWrData               : in  std_logic_vector(63 downto 0);
    bdIFifoWrDataValid          : in  std_logic;
    bdIFifoWrReadyForOutput     : out std_logic;
    bdAxiStreamRdFromClipTData  : in  std_logic_vector(31 downto 0);
    bdAxiStreamRdFromClipTLast  : in  std_logic;
    bdAxiStreamRdFromClipTValid : in  std_logic;
    bdAxiStreamRdToClipTReady   : out std_logic;
    bdAxiStreamWrToClipTData    : out std_logic_vector(31 downto 0);
    bdAxiStreamWrToClipTLast    : out std_logic;
    bdAxiStreamWrToClipTValid   : out std_logic;
    bdAxiStreamWrFromClipTReady : in  std_logic;

    -----------------------------------
    -- Pass through LabVIEW FPGA ports
    -----------------------------------

    ----------------------------------------
    -- Trigger Routing Socketed CLIP
    ----------------------------------------
    PxieClk100Trigger  : in  std_logic;
    pIntSync100Trigger : in  std_logic;
    dDevClkEn          : in  std_logic;
    aIntClk10Trigger   : in  std_logic;
    --ID Signals from Routing CLIP
    bRoutingClipPresent      : out std_logic;
    bRoutingClipNiCompatible : out std_logic;

    BusClkTrigger : in std_logic;
    abBusResetTrigger : in std_logic;

    -- From PkgBaRegPort
    -- RegPortIn_t Size = Address 28 Data 64 WrStrobes 8 RdStrobes 8 = 108
    -- RegPortOut_t Size = Data 64 + Ack 1 = 65
    bTriggerRoutingBaRegPortInAddress  : in std_logic_vector(27 downto 0);
    bTriggerRoutingBaRegPortInData     : in std_logic_vector(63 downto 0);
    bTriggerRoutingBaRegPortInWtStrobe : in std_logic_vector(7 downto 0);
    bTriggerRoutingBaRegPortInRdStrobe : in std_logic_vector(7 downto 0);

    bTriggerRoutingBaRegPortOutData : out std_logic_vector(63 downto 0);
    bTriggerRoutingBaRegPortOutAck  : out std_logic;

    aPxiTrigDataIn         : in  std_logic_vector(7 downto 0);
    aPxiTrigDataOut        : out std_logic_vector(7 downto 0);
    aPxiTrigDataTri        : out std_logic_vector(7 downto 0);
    aPxiStarData           : in    std_logic;
    aPxieDstarB            : in    std_logic;
    aPxieDstarC            : out   std_logic;

    -----------------------------------
    -- CLIP Socket ports
    -----------------------------------

    -- AxiClk is the same as BusCLk is the same as PllClk80
    AxiClk : in std_logic;

    xDiagramAxiStreamFromClipTData  : out std_logic_vector(31 downto 0);
    xDiagramAxiStreamFromClipTLast  : out std_logic;
    xDiagramAxiStreamFromClipTReady : out std_logic;
    xDiagramAxiStreamFromClipTValid : out std_logic;
    xDiagramAxiStreamToClipTData    : in  std_logic_vector(31 downto 0);
    xDiagramAxiStreamToClipTLast    : in  std_logic;
    xDiagramAxiStreamToClipTReady   : in  std_logic;
    xDiagramAxiStreamToClipTValid   : in  std_logic;

    xHostAxiStreamFromClipTData  : out std_logic_vector(31 downto 0);
    xHostAxiStreamFromClipTLast  : out std_logic;
    xHostAxiStreamFromClipTReady : out std_logic;
    xHostAxiStreamFromClipTValid : out std_logic;
    xHostAxiStreamToClipTData    : in  std_logic_vector(31 downto 0);
    xHostAxiStreamToClipTLast    : in  std_logic;
    xHostAxiStreamToClipTReady   : in  std_logic;
    xHostAxiStreamToClipTValid   : in  std_logic;


    -- Axi4Lite Interface from the CLIP to FixedLogic
    xClipAxi4LiteMasterARAddr  : out std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterARProt  : out std_logic_vector(2 downto 0);
    xClipAxi4LiteMasterARReady : in  std_logic;
    xClipAxi4LiteMasterARValid : out std_logic;
    xClipAxi4LiteMasterAWAddr  : out std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterAWProt  : out std_logic_vector(2 downto 0);
    xClipAxi4LiteMasterAWReady : in  std_logic;
    xClipAxi4LiteMasterAWValid : out std_logic;
    xClipAxi4LiteMasterBReady  : out std_logic;
    xClipAxi4LiteMasterBResp   : in  std_logic_vector(1 downto 0);
    xClipAxi4LiteMasterBValid  : in  std_logic;
    xClipAxi4LiteMasterRData   : in  std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterRReady  : out std_logic;
    xClipAxi4LiteMasterRResp   : in  std_logic_vector(1 downto 0);
    xClipAxi4LiteMasterRValid  : in  std_logic;
    xClipAxi4LiteMasterWData   : out std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterWReady  : in  std_logic;
    xClipAxi4LiteMasterWStrb   : out std_logic_vector(3 downto 0);
    xClipAxi4LiteMasterWValid  : out std_logic;
    xClipAxi4LiteInterrupt     : in  std_logic;

    --Reserved CLIP Signals
    stIoModuleSupportsFRAGLs : out std_logic;

    -- RefClks
    MgtRefClk_p               : in    std_logic_vector (11 downto 0);
    MgtRefClk_n               : in    std_logic_vector (11 downto 0);
    -- MGTs
    MgtPortRx_p               : in    std_logic_vector (47 downto 0);
    MgtPortRx_n               : in    std_logic_vector (47 downto 0);
    MgtPortTx_p               : out   std_logic_vector (47 downto 0);
    MgtPortTx_n               : out   std_logic_vector (47 downto 0);

    -- Base board DIO
    aDio                      : inout std_logic_vector(7 downto 0);

    -- Configuration
    aLmkI2cSda            : inout std_logic;
    aLmkI2cScl            : inout std_logic;
    aLmk1Pdn_n            : out std_logic;
    aLmk2Pdn_n            : out std_logic;
    aLmk1Gpio0            : out std_logic;
    aLmk2Gpio0            : out std_logic;
    aLmk1Status0          : in std_logic;
    aLmk1Status1          : in std_logic;
    aLmk2Status0          : in std_logic;
    aLmk2Status1          : in std_logic;
    aIPassVccPowerFault_n : in std_logic;
    aIPassPrsnt_n         : in std_logic_vector(7 downto 0);
    aIPassIntr_n          : in std_logic_vector(7 downto 0);
    aIPassSCL             : inout std_logic_vector(11 downto 0);
    aIPassSDA             : inout std_logic_vector(11 downto 0);
    aPortExpReset_n       : out std_logic;
    aPortExpIntr_n        : in std_logic;
    aPortExpSda           : inout std_logic;
    aPortExpScl           : inout std_logic;
    -----------------------------------------------------------------------------
    --Dram Interface
    -----------------------------------------------------------------------------
    aDramReady               : in    std_logic;
    du0DramAddrFifoAddr      : out   std_logic_vector(29 downto 0);
    du0DramAddrFifoCmd       : out   std_logic_vector(2 downto 0);
    du0DramAddrFifoFull      : in    std_logic;
    du0DramAddrFifoWrEn      : out   std_logic;
    du0DramPhyInitDone       : in    std_logic;
    du0DramRdDataValid       : in    std_logic;
    du0DramRdFifoDataOut     : in    std_logic_vector(639 downto 0);
    du0DramWrFifoDataIn      : out   std_logic_vector(639 downto 0);
    du0DramWrFifoFull        : in    std_logic;
    du0DramWrFifoMaskData    : out   std_logic_vector(79 downto 0);
    du0DramWrFifoWrEn        : out   std_logic;
    du1DramAddrFifoAddr      : out   std_logic_vector(29 downto 0);
    du1DramAddrFifoCmd       : out   std_logic_vector(2 downto 0);
    du1DramAddrFifoFull      : in    std_logic;
    du1DramAddrFifoWrEn      : out   std_logic;
    du1DramPhyInitDone       : in    std_logic;
    du1DramRdDataValid       : in    std_logic;
    du1DramRdFifoDataOut     : in    std_logic_vector(639 downto 0);
    du1DramWrFifoDataIn      : out   std_logic_vector(639 downto 0);
    du1DramWrFifoFull        : in    std_logic;
    du1DramWrFifoMaskData    : out   std_logic_vector(79 downto 0);
    du1DramWrFifoWrEn        : out   std_logic;

    -----------------------------------------------------------------------------
    --HMB Interface
    -----------------------------------------------------------------------------
    dHmbDramAddrFifoAddr : out std_logic_vector(31 downto 0);
    dHmbDramAddrFifoCmd : out std_logic_vector(2 downto 0);
    dHmbDramAddrFifoFull : in std_logic;
    dHmbDramAddrFifoWrEn : out std_logic;
    dHmbDramRdDataValid : in std_logic;
    dHmbDramRdFifoDataOut : in std_logic_vector(1023 downto 0);
    dHmbDramWrFifoDataIn : out std_logic_vector(1023 downto 0);
    dHmbDramWrFifoFull : in std_logic;
    dHmbDramWrFifoMaskData : out std_logic_vector(127 downto 0);
    dHmbDramWrFifoWrEn : out std_logic;
    dHmbPhyInitDoneForLvfpga : in std_logic;
    dLlbDramAddrFifoAddr : out std_logic_vector(31 downto 0);
    dLlbDramAddrFifoCmd : out std_logic_vector(2 downto 0);
    dLlbDramAddrFifoFull : in std_logic;
    dLlbDramAddrFifoWrEn : out std_logic;
    dLlbDramRdDataValid : in std_logic;
    dLlbDramRdFifoDataOut : in std_logic_vector(1023 downto 0);
    dLlbDramWrFifoDataIn : out std_logic_vector(1023 downto 0);
    dLlbDramWrFifoFull : in std_logic;
    dLlbDramWrFifoMaskData : out std_logic_vector(127 downto 0);
    dLlbDramWrFifoWrEn : out std_logic;
    dLlbPhyInitDoneForLvfpga : in std_logic;

    -----------------------------------
    -- Clocks from TheWindow
    -----------------------------------
    TopLevelClkOut : out std_logic;
    ReliableClkOut : out std_logic;

    -----------------------------------
    -- Diagram/Reset/Clock status
    -----------------------------------
    rBaseClksValid             : in  std_logic := '1';
    tDiagramActive             : out std_logic;
    rDiagramReset              : out std_logic;
    aDiagramReset              : out std_logic;
    rDerivedClockLostLockError : out std_logic;
    rGatedBaseClksValid        : in  std_logic := '1';
    aSafeToEnableGatedClks     : out std_logic
    );

end TheWindow;

architecture behavioral of TheWindow is

  --vhook_sigstart
  --vhook_sigend

  signal rTrigReadData_ms, rTrigReadData : std_logic;

begin

end architecture Behavioral;
