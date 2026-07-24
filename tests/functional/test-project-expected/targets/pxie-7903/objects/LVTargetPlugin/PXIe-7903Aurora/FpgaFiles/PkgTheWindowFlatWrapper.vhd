------------------------------------------------------------------------------
--
-- File: PkgTheWindowFlatWrapper.vhd
-- Author: Auto-generated wrapper
-- Original Project: FlexRIO
-- Date: 2 January 2026
--
------------------------------------------------------------------------------
-- (c) 2026 Copyright National Instruments Corporation
--
-- SPDX-License-Identifier: MIT
------------------------------------------------------------------------------
--
-- Purpose: This wrapper flattens all record-type ports of TheWindow to
--          std_logic_vector ports for compatibility.
--
------------------------------------------------------------------------------
-- githubvisible=true

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

Library work;
  use work.PkgNiUtilities.all;
  use work.PkgCommIntConfiguration.all;
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;
  use work.PkgDmaPortDmaFifos.all;
  use work.PkgDmaPortDmaFifosFlatTypes.all;
  use work.PkgDmaPortCommIfcMasterPort.all;
  use work.PkgDmaPortCommIfcMasterPortFlatTypes.all;

package PkgTheWindowFlatWrapper is

  component TheWindowFlatWrapper is
    port(
      -----------------------------------
      -- CUSTOM BOARD IO
      -----------------------------------
      xIoModuleReady : in std_logic; -- xIoModuleReady
      xIoModuleErrorCode : in std_logic_vector(31 downto 0); -- xIoModuleErrorCode
      aDioOut : out std_logic_vector(7 downto 0); -- aDioOut
      aDioIn : in std_logic_vector(7 downto 0); -- aDioIn
      UserClkPort0 : in std_logic; -- UserClkPort0
      aPort0PmaInit : out std_logic; -- aPort0PmaInit
      aPort0ResetPb : out std_logic; -- aPort0ResetPb
      uPort0AxiTxTData0 : out std_logic_vector(63 downto 0); -- uPort0AxiTxTData0
      uPort0AxiTxTData1 : out std_logic_vector(63 downto 0); -- uPort0AxiTxTData1
      uPort0AxiTxTData2 : out std_logic_vector(63 downto 0); -- uPort0AxiTxTData2
      uPort0AxiTxTData3 : out std_logic_vector(63 downto 0); -- uPort0AxiTxTData3
      uPort0AxiTxTKeep : out std_logic_vector(31 downto 0); -- uPort0AxiTxTKeep
      uPort0AxiTxTLast : out std_logic; -- uPort0AxiTxTLast
      uPort0AxiTxTValid : out std_logic; -- uPort0AxiTxTValid
      uPort0AxiTxTReady : in std_logic; -- uPort0AxiTxTReady
      uPort0AxiRxTData0 : in std_logic_vector(63 downto 0); -- uPort0AxiRxTData0
      uPort0AxiRxTData1 : in std_logic_vector(63 downto 0); -- uPort0AxiRxTData1
      uPort0AxiRxTData2 : in std_logic_vector(63 downto 0); -- uPort0AxiRxTData2
      uPort0AxiRxTData3 : in std_logic_vector(63 downto 0); -- uPort0AxiRxTData3
      uPort0AxiRxTKeep : in std_logic_vector(31 downto 0); -- uPort0AxiRxTKeep
      uPort0AxiRxTLast : in std_logic; -- uPort0AxiRxTLast
      uPort0AxiRxTValid : in std_logic; -- uPort0AxiRxTValid
      uPort0AxiNfcTValid : out std_logic; -- uPort0AxiNfcTValid
      uPort0AxiNfcTData : out std_logic_vector(31 downto 0); -- uPort0AxiNfcTData
      uPort0AxiNfcTReady : in std_logic; -- uPort0AxiNfcTReady
      uPort0HardError : in std_logic; -- uPort0HardError
      uPort0SoftError : in std_logic; -- uPort0SoftError
      uPort0LaneUp : in std_logic_vector(3 downto 0); -- uPort0LaneUp
      uPort0ChannelUp : in std_logic; -- uPort0ChannelUp
      uPort0SysResetOut : in std_logic; -- uPort0SysResetOut
      uPort0MmcmNotLockOut : in std_logic; -- uPort0MmcmNotLockOut
      uPort0CrcPassFail_n : in std_logic; -- uPort0CrcPassFail_n
      uPort0CrcValid : in std_logic; -- uPort0CrcValid
      iPort0LinkResetOut : in std_logic; -- iPort0LinkResetOut
      sGtwiz0CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz0CtrlAxiAWAddr
      sGtwiz0CtrlAxiAWValid : out std_logic; -- sGtwiz0CtrlAxiAWValid
      sGtwiz0CtrlAxiAWReady : in std_logic; -- sGtwiz0CtrlAxiAWReady
      sGtwiz0CtrlAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz0CtrlAxiWData
      sGtwiz0CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz0CtrlAxiWStrb
      sGtwiz0CtrlAxiWValid : out std_logic; -- sGtwiz0CtrlAxiWValid
      sGtwiz0CtrlAxiWReady : in std_logic; -- sGtwiz0CtrlAxiWReady
      sGtwiz0CtrlAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz0CtrlAxiBResp
      sGtwiz0CtrlAxiBValid : in std_logic; -- sGtwiz0CtrlAxiBValid
      sGtwiz0CtrlAxiBReady : out std_logic; -- sGtwiz0CtrlAxiBReady
      sGtwiz0CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz0CtrlAxiARAddr
      sGtwiz0CtrlAxiARValid : out std_logic; -- sGtwiz0CtrlAxiARValid
      sGtwiz0CtrlAxiARReady : in std_logic; -- sGtwiz0CtrlAxiARReady
      sGtwiz0CtrlAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz0CtrlAxiRData
      sGtwiz0CtrlAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz0CtrlAxiRResp
      sGtwiz0CtrlAxiRValid : in std_logic; -- sGtwiz0CtrlAxiRValid
      sGtwiz0CtrlAxiRReady : out std_logic; -- sGtwiz0CtrlAxiRReady
      sGtwiz0DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz0DrpChAxiAWAddr
      sGtwiz0DrpChAxiAWValid : out std_logic; -- sGtwiz0DrpChAxiAWValid
      sGtwiz0DrpChAxiAWReady : in std_logic; -- sGtwiz0DrpChAxiAWReady
      sGtwiz0DrpChAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz0DrpChAxiWData
      sGtwiz0DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz0DrpChAxiWStrb
      sGtwiz0DrpChAxiWValid : out std_logic; -- sGtwiz0DrpChAxiWValid
      sGtwiz0DrpChAxiWReady : in std_logic; -- sGtwiz0DrpChAxiWReady
      sGtwiz0DrpChAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz0DrpChAxiBResp
      sGtwiz0DrpChAxiBValid : in std_logic; -- sGtwiz0DrpChAxiBValid
      sGtwiz0DrpChAxiBReady : out std_logic; -- sGtwiz0DrpChAxiBReady
      sGtwiz0DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz0DrpChAxiARAddr
      sGtwiz0DrpChAxiARValid : out std_logic; -- sGtwiz0DrpChAxiARValid
      sGtwiz0DrpChAxiARReady : in std_logic; -- sGtwiz0DrpChAxiARReady
      sGtwiz0DrpChAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz0DrpChAxiRData
      sGtwiz0DrpChAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz0DrpChAxiRResp
      sGtwiz0DrpChAxiRValid : in std_logic; -- sGtwiz0DrpChAxiRValid
      sGtwiz0DrpChAxiRReady : out std_logic; -- sGtwiz0DrpChAxiRReady
      UserClkPort1 : in std_logic; -- UserClkPort1
      aPort1PmaInit : out std_logic; -- aPort1PmaInit
      aPort1ResetPb : out std_logic; -- aPort1ResetPb
      uPort1AxiTxTData0 : out std_logic_vector(63 downto 0); -- uPort1AxiTxTData0
      uPort1AxiTxTData1 : out std_logic_vector(63 downto 0); -- uPort1AxiTxTData1
      uPort1AxiTxTData2 : out std_logic_vector(63 downto 0); -- uPort1AxiTxTData2
      uPort1AxiTxTData3 : out std_logic_vector(63 downto 0); -- uPort1AxiTxTData3
      uPort1AxiTxTKeep : out std_logic_vector(31 downto 0); -- uPort1AxiTxTKeep
      uPort1AxiTxTLast : out std_logic; -- uPort1AxiTxTLast
      uPort1AxiTxTValid : out std_logic; -- uPort1AxiTxTValid
      uPort1AxiTxTReady : in std_logic; -- uPort1AxiTxTReady
      uPort1AxiRxTData0 : in std_logic_vector(63 downto 0); -- uPort1AxiRxTData0
      uPort1AxiRxTData1 : in std_logic_vector(63 downto 0); -- uPort1AxiRxTData1
      uPort1AxiRxTData2 : in std_logic_vector(63 downto 0); -- uPort1AxiRxTData2
      uPort1AxiRxTData3 : in std_logic_vector(63 downto 0); -- uPort1AxiRxTData3
      uPort1AxiRxTKeep : in std_logic_vector(31 downto 0); -- uPort1AxiRxTKeep
      uPort1AxiRxTLast : in std_logic; -- uPort1AxiRxTLast
      uPort1AxiRxTValid : in std_logic; -- uPort1AxiRxTValid
      uPort1AxiNfcTValid : out std_logic; -- uPort1AxiNfcTValid
      uPort1AxiNfcTData : out std_logic_vector(31 downto 0); -- uPort1AxiNfcTData
      uPort1AxiNfcTReady : in std_logic; -- uPort1AxiNfcTReady
      uPort1HardError : in std_logic; -- uPort1HardError
      uPort1SoftError : in std_logic; -- uPort1SoftError
      uPort1LaneUp : in std_logic_vector(3 downto 0); -- uPort1LaneUp
      uPort1ChannelUp : in std_logic; -- uPort1ChannelUp
      uPort1SysResetOut : in std_logic; -- uPort1SysResetOut
      uPort1MmcmNotLockOut : in std_logic; -- uPort1MmcmNotLockOut
      uPort1CrcPassFail_n : in std_logic; -- uPort1CrcPassFail_n
      uPort1CrcValid : in std_logic; -- uPort1CrcValid
      iPort1LinkResetOut : in std_logic; -- iPort1LinkResetOut
      sGtwiz1CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz1CtrlAxiAWAddr
      sGtwiz1CtrlAxiAWValid : out std_logic; -- sGtwiz1CtrlAxiAWValid
      sGtwiz1CtrlAxiAWReady : in std_logic; -- sGtwiz1CtrlAxiAWReady
      sGtwiz1CtrlAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz1CtrlAxiWData
      sGtwiz1CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz1CtrlAxiWStrb
      sGtwiz1CtrlAxiWValid : out std_logic; -- sGtwiz1CtrlAxiWValid
      sGtwiz1CtrlAxiWReady : in std_logic; -- sGtwiz1CtrlAxiWReady
      sGtwiz1CtrlAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz1CtrlAxiBResp
      sGtwiz1CtrlAxiBValid : in std_logic; -- sGtwiz1CtrlAxiBValid
      sGtwiz1CtrlAxiBReady : out std_logic; -- sGtwiz1CtrlAxiBReady
      sGtwiz1CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz1CtrlAxiARAddr
      sGtwiz1CtrlAxiARValid : out std_logic; -- sGtwiz1CtrlAxiARValid
      sGtwiz1CtrlAxiARReady : in std_logic; -- sGtwiz1CtrlAxiARReady
      sGtwiz1CtrlAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz1CtrlAxiRData
      sGtwiz1CtrlAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz1CtrlAxiRResp
      sGtwiz1CtrlAxiRValid : in std_logic; -- sGtwiz1CtrlAxiRValid
      sGtwiz1CtrlAxiRReady : out std_logic; -- sGtwiz1CtrlAxiRReady
      sGtwiz1DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz1DrpChAxiAWAddr
      sGtwiz1DrpChAxiAWValid : out std_logic; -- sGtwiz1DrpChAxiAWValid
      sGtwiz1DrpChAxiAWReady : in std_logic; -- sGtwiz1DrpChAxiAWReady
      sGtwiz1DrpChAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz1DrpChAxiWData
      sGtwiz1DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz1DrpChAxiWStrb
      sGtwiz1DrpChAxiWValid : out std_logic; -- sGtwiz1DrpChAxiWValid
      sGtwiz1DrpChAxiWReady : in std_logic; -- sGtwiz1DrpChAxiWReady
      sGtwiz1DrpChAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz1DrpChAxiBResp
      sGtwiz1DrpChAxiBValid : in std_logic; -- sGtwiz1DrpChAxiBValid
      sGtwiz1DrpChAxiBReady : out std_logic; -- sGtwiz1DrpChAxiBReady
      sGtwiz1DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz1DrpChAxiARAddr
      sGtwiz1DrpChAxiARValid : out std_logic; -- sGtwiz1DrpChAxiARValid
      sGtwiz1DrpChAxiARReady : in std_logic; -- sGtwiz1DrpChAxiARReady
      sGtwiz1DrpChAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz1DrpChAxiRData
      sGtwiz1DrpChAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz1DrpChAxiRResp
      sGtwiz1DrpChAxiRValid : in std_logic; -- sGtwiz1DrpChAxiRValid
      sGtwiz1DrpChAxiRReady : out std_logic; -- sGtwiz1DrpChAxiRReady
      UserClkPort2 : in std_logic; -- UserClkPort2
      aPort2PmaInit : out std_logic; -- aPort2PmaInit
      aPort2ResetPb : out std_logic; -- aPort2ResetPb
      uPort2AxiTxTData0 : out std_logic_vector(63 downto 0); -- uPort2AxiTxTData0
      uPort2AxiTxTData1 : out std_logic_vector(63 downto 0); -- uPort2AxiTxTData1
      uPort2AxiTxTData2 : out std_logic_vector(63 downto 0); -- uPort2AxiTxTData2
      uPort2AxiTxTData3 : out std_logic_vector(63 downto 0); -- uPort2AxiTxTData3
      uPort2AxiTxTKeep : out std_logic_vector(31 downto 0); -- uPort2AxiTxTKeep
      uPort2AxiTxTLast : out std_logic; -- uPort2AxiTxTLast
      uPort2AxiTxTValid : out std_logic; -- uPort2AxiTxTValid
      uPort2AxiTxTReady : in std_logic; -- uPort2AxiTxTReady
      uPort2AxiRxTData0 : in std_logic_vector(63 downto 0); -- uPort2AxiRxTData0
      uPort2AxiRxTData1 : in std_logic_vector(63 downto 0); -- uPort2AxiRxTData1
      uPort2AxiRxTData2 : in std_logic_vector(63 downto 0); -- uPort2AxiRxTData2
      uPort2AxiRxTData3 : in std_logic_vector(63 downto 0); -- uPort2AxiRxTData3
      uPort2AxiRxTKeep : in std_logic_vector(31 downto 0); -- uPort2AxiRxTKeep
      uPort2AxiRxTLast : in std_logic; -- uPort2AxiRxTLast
      uPort2AxiRxTValid : in std_logic; -- uPort2AxiRxTValid
      uPort2AxiNfcTValid : out std_logic; -- uPort2AxiNfcTValid
      uPort2AxiNfcTData : out std_logic_vector(31 downto 0); -- uPort2AxiNfcTData
      uPort2AxiNfcTReady : in std_logic; -- uPort2AxiNfcTReady
      uPort2HardError : in std_logic; -- uPort2HardError
      uPort2SoftError : in std_logic; -- uPort2SoftError
      uPort2LaneUp : in std_logic_vector(3 downto 0); -- uPort2LaneUp
      uPort2ChannelUp : in std_logic; -- uPort2ChannelUp
      uPort2SysResetOut : in std_logic; -- uPort2SysResetOut
      uPort2MmcmNotLockOut : in std_logic; -- uPort2MmcmNotLockOut
      uPort2CrcPassFail_n : in std_logic; -- uPort2CrcPassFail_n
      uPort2CrcValid : in std_logic; -- uPort2CrcValid
      iPort2LinkResetOut : in std_logic; -- iPort2LinkResetOut
      sGtwiz2CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz2CtrlAxiAWAddr
      sGtwiz2CtrlAxiAWValid : out std_logic; -- sGtwiz2CtrlAxiAWValid
      sGtwiz2CtrlAxiAWReady : in std_logic; -- sGtwiz2CtrlAxiAWReady
      sGtwiz2CtrlAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz2CtrlAxiWData
      sGtwiz2CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz2CtrlAxiWStrb
      sGtwiz2CtrlAxiWValid : out std_logic; -- sGtwiz2CtrlAxiWValid
      sGtwiz2CtrlAxiWReady : in std_logic; -- sGtwiz2CtrlAxiWReady
      sGtwiz2CtrlAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz2CtrlAxiBResp
      sGtwiz2CtrlAxiBValid : in std_logic; -- sGtwiz2CtrlAxiBValid
      sGtwiz2CtrlAxiBReady : out std_logic; -- sGtwiz2CtrlAxiBReady
      sGtwiz2CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz2CtrlAxiARAddr
      sGtwiz2CtrlAxiARValid : out std_logic; -- sGtwiz2CtrlAxiARValid
      sGtwiz2CtrlAxiARReady : in std_logic; -- sGtwiz2CtrlAxiARReady
      sGtwiz2CtrlAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz2CtrlAxiRData
      sGtwiz2CtrlAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz2CtrlAxiRResp
      sGtwiz2CtrlAxiRValid : in std_logic; -- sGtwiz2CtrlAxiRValid
      sGtwiz2CtrlAxiRReady : out std_logic; -- sGtwiz2CtrlAxiRReady
      sGtwiz2DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz2DrpChAxiAWAddr
      sGtwiz2DrpChAxiAWValid : out std_logic; -- sGtwiz2DrpChAxiAWValid
      sGtwiz2DrpChAxiAWReady : in std_logic; -- sGtwiz2DrpChAxiAWReady
      sGtwiz2DrpChAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz2DrpChAxiWData
      sGtwiz2DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz2DrpChAxiWStrb
      sGtwiz2DrpChAxiWValid : out std_logic; -- sGtwiz2DrpChAxiWValid
      sGtwiz2DrpChAxiWReady : in std_logic; -- sGtwiz2DrpChAxiWReady
      sGtwiz2DrpChAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz2DrpChAxiBResp
      sGtwiz2DrpChAxiBValid : in std_logic; -- sGtwiz2DrpChAxiBValid
      sGtwiz2DrpChAxiBReady : out std_logic; -- sGtwiz2DrpChAxiBReady
      sGtwiz2DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz2DrpChAxiARAddr
      sGtwiz2DrpChAxiARValid : out std_logic; -- sGtwiz2DrpChAxiARValid
      sGtwiz2DrpChAxiARReady : in std_logic; -- sGtwiz2DrpChAxiARReady
      sGtwiz2DrpChAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz2DrpChAxiRData
      sGtwiz2DrpChAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz2DrpChAxiRResp
      sGtwiz2DrpChAxiRValid : in std_logic; -- sGtwiz2DrpChAxiRValid
      sGtwiz2DrpChAxiRReady : out std_logic; -- sGtwiz2DrpChAxiRReady
      UserClkPort3 : in std_logic; -- UserClkPort3
      aPort3PmaInit : out std_logic; -- aPort3PmaInit
      aPort3ResetPb : out std_logic; -- aPort3ResetPb
      uPort3AxiTxTData0 : out std_logic_vector(63 downto 0); -- uPort3AxiTxTData0
      uPort3AxiTxTData1 : out std_logic_vector(63 downto 0); -- uPort3AxiTxTData1
      uPort3AxiTxTData2 : out std_logic_vector(63 downto 0); -- uPort3AxiTxTData2
      uPort3AxiTxTData3 : out std_logic_vector(63 downto 0); -- uPort3AxiTxTData3
      uPort3AxiTxTKeep : out std_logic_vector(31 downto 0); -- uPort3AxiTxTKeep
      uPort3AxiTxTLast : out std_logic; -- uPort3AxiTxTLast
      uPort3AxiTxTValid : out std_logic; -- uPort3AxiTxTValid
      uPort3AxiTxTReady : in std_logic; -- uPort3AxiTxTReady
      uPort3AxiRxTData0 : in std_logic_vector(63 downto 0); -- uPort3AxiRxTData0
      uPort3AxiRxTData1 : in std_logic_vector(63 downto 0); -- uPort3AxiRxTData1
      uPort3AxiRxTData2 : in std_logic_vector(63 downto 0); -- uPort3AxiRxTData2
      uPort3AxiRxTData3 : in std_logic_vector(63 downto 0); -- uPort3AxiRxTData3
      uPort3AxiRxTKeep : in std_logic_vector(31 downto 0); -- uPort3AxiRxTKeep
      uPort3AxiRxTLast : in std_logic; -- uPort3AxiRxTLast
      uPort3AxiRxTValid : in std_logic; -- uPort3AxiRxTValid
      uPort3AxiNfcTValid : out std_logic; -- uPort3AxiNfcTValid
      uPort3AxiNfcTData : out std_logic_vector(31 downto 0); -- uPort3AxiNfcTData
      uPort3AxiNfcTReady : in std_logic; -- uPort3AxiNfcTReady
      uPort3HardError : in std_logic; -- uPort3HardError
      uPort3SoftError : in std_logic; -- uPort3SoftError
      uPort3LaneUp : in std_logic_vector(3 downto 0); -- uPort3LaneUp
      uPort3ChannelUp : in std_logic; -- uPort3ChannelUp
      uPort3SysResetOut : in std_logic; -- uPort3SysResetOut
      uPort3MmcmNotLockOut : in std_logic; -- uPort3MmcmNotLockOut
      uPort3CrcPassFail_n : in std_logic; -- uPort3CrcPassFail_n
      uPort3CrcValid : in std_logic; -- uPort3CrcValid
      iPort3LinkResetOut : in std_logic; -- iPort3LinkResetOut
      sGtwiz3CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz3CtrlAxiAWAddr
      sGtwiz3CtrlAxiAWValid : out std_logic; -- sGtwiz3CtrlAxiAWValid
      sGtwiz3CtrlAxiAWReady : in std_logic; -- sGtwiz3CtrlAxiAWReady
      sGtwiz3CtrlAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz3CtrlAxiWData
      sGtwiz3CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz3CtrlAxiWStrb
      sGtwiz3CtrlAxiWValid : out std_logic; -- sGtwiz3CtrlAxiWValid
      sGtwiz3CtrlAxiWReady : in std_logic; -- sGtwiz3CtrlAxiWReady
      sGtwiz3CtrlAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz3CtrlAxiBResp
      sGtwiz3CtrlAxiBValid : in std_logic; -- sGtwiz3CtrlAxiBValid
      sGtwiz3CtrlAxiBReady : out std_logic; -- sGtwiz3CtrlAxiBReady
      sGtwiz3CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz3CtrlAxiARAddr
      sGtwiz3CtrlAxiARValid : out std_logic; -- sGtwiz3CtrlAxiARValid
      sGtwiz3CtrlAxiARReady : in std_logic; -- sGtwiz3CtrlAxiARReady
      sGtwiz3CtrlAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz3CtrlAxiRData
      sGtwiz3CtrlAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz3CtrlAxiRResp
      sGtwiz3CtrlAxiRValid : in std_logic; -- sGtwiz3CtrlAxiRValid
      sGtwiz3CtrlAxiRReady : out std_logic; -- sGtwiz3CtrlAxiRReady
      sGtwiz3DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz3DrpChAxiAWAddr
      sGtwiz3DrpChAxiAWValid : out std_logic; -- sGtwiz3DrpChAxiAWValid
      sGtwiz3DrpChAxiAWReady : in std_logic; -- sGtwiz3DrpChAxiAWReady
      sGtwiz3DrpChAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz3DrpChAxiWData
      sGtwiz3DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz3DrpChAxiWStrb
      sGtwiz3DrpChAxiWValid : out std_logic; -- sGtwiz3DrpChAxiWValid
      sGtwiz3DrpChAxiWReady : in std_logic; -- sGtwiz3DrpChAxiWReady
      sGtwiz3DrpChAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz3DrpChAxiBResp
      sGtwiz3DrpChAxiBValid : in std_logic; -- sGtwiz3DrpChAxiBValid
      sGtwiz3DrpChAxiBReady : out std_logic; -- sGtwiz3DrpChAxiBReady
      sGtwiz3DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz3DrpChAxiARAddr
      sGtwiz3DrpChAxiARValid : out std_logic; -- sGtwiz3DrpChAxiARValid
      sGtwiz3DrpChAxiARReady : in std_logic; -- sGtwiz3DrpChAxiARReady
      sGtwiz3DrpChAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz3DrpChAxiRData
      sGtwiz3DrpChAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz3DrpChAxiRResp
      sGtwiz3DrpChAxiRValid : in std_logic; -- sGtwiz3DrpChAxiRValid
      sGtwiz3DrpChAxiRReady : out std_logic; -- sGtwiz3DrpChAxiRReady
      UserClkPort4 : in std_logic; -- UserClkPort4
      aPort4PmaInit : out std_logic; -- aPort4PmaInit
      aPort4ResetPb : out std_logic; -- aPort4ResetPb
      uPort4AxiTxTData0 : out std_logic_vector(63 downto 0); -- uPort4AxiTxTData0
      uPort4AxiTxTData1 : out std_logic_vector(63 downto 0); -- uPort4AxiTxTData1
      uPort4AxiTxTData2 : out std_logic_vector(63 downto 0); -- uPort4AxiTxTData2
      uPort4AxiTxTData3 : out std_logic_vector(63 downto 0); -- uPort4AxiTxTData3
      uPort4AxiTxTKeep : out std_logic_vector(31 downto 0); -- uPort4AxiTxTKeep
      uPort4AxiTxTLast : out std_logic; -- uPort4AxiTxTLast
      uPort4AxiTxTValid : out std_logic; -- uPort4AxiTxTValid
      uPort4AxiTxTReady : in std_logic; -- uPort4AxiTxTReady
      uPort4AxiRxTData0 : in std_logic_vector(63 downto 0); -- uPort4AxiRxTData0
      uPort4AxiRxTData1 : in std_logic_vector(63 downto 0); -- uPort4AxiRxTData1
      uPort4AxiRxTData2 : in std_logic_vector(63 downto 0); -- uPort4AxiRxTData2
      uPort4AxiRxTData3 : in std_logic_vector(63 downto 0); -- uPort4AxiRxTData3
      uPort4AxiRxTKeep : in std_logic_vector(31 downto 0); -- uPort4AxiRxTKeep
      uPort4AxiRxTLast : in std_logic; -- uPort4AxiRxTLast
      uPort4AxiRxTValid : in std_logic; -- uPort4AxiRxTValid
      uPort4AxiNfcTValid : out std_logic; -- uPort4AxiNfcTValid
      uPort4AxiNfcTData : out std_logic_vector(31 downto 0); -- uPort4AxiNfcTData
      uPort4AxiNfcTReady : in std_logic; -- uPort4AxiNfcTReady
      uPort4HardError : in std_logic; -- uPort4HardError
      uPort4SoftError : in std_logic; -- uPort4SoftError
      uPort4LaneUp : in std_logic_vector(3 downto 0); -- uPort4LaneUp
      uPort4ChannelUp : in std_logic; -- uPort4ChannelUp
      uPort4SysResetOut : in std_logic; -- uPort4SysResetOut
      uPort4MmcmNotLockOut : in std_logic; -- uPort4MmcmNotLockOut
      uPort4CrcPassFail_n : in std_logic; -- uPort4CrcPassFail_n
      uPort4CrcValid : in std_logic; -- uPort4CrcValid
      iPort4LinkResetOut : in std_logic; -- iPort4LinkResetOut
      sGtwiz4CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz4CtrlAxiAWAddr
      sGtwiz4CtrlAxiAWValid : out std_logic; -- sGtwiz4CtrlAxiAWValid
      sGtwiz4CtrlAxiAWReady : in std_logic; -- sGtwiz4CtrlAxiAWReady
      sGtwiz4CtrlAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz4CtrlAxiWData
      sGtwiz4CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz4CtrlAxiWStrb
      sGtwiz4CtrlAxiWValid : out std_logic; -- sGtwiz4CtrlAxiWValid
      sGtwiz4CtrlAxiWReady : in std_logic; -- sGtwiz4CtrlAxiWReady
      sGtwiz4CtrlAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz4CtrlAxiBResp
      sGtwiz4CtrlAxiBValid : in std_logic; -- sGtwiz4CtrlAxiBValid
      sGtwiz4CtrlAxiBReady : out std_logic; -- sGtwiz4CtrlAxiBReady
      sGtwiz4CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz4CtrlAxiARAddr
      sGtwiz4CtrlAxiARValid : out std_logic; -- sGtwiz4CtrlAxiARValid
      sGtwiz4CtrlAxiARReady : in std_logic; -- sGtwiz4CtrlAxiARReady
      sGtwiz4CtrlAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz4CtrlAxiRData
      sGtwiz4CtrlAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz4CtrlAxiRResp
      sGtwiz4CtrlAxiRValid : in std_logic; -- sGtwiz4CtrlAxiRValid
      sGtwiz4CtrlAxiRReady : out std_logic; -- sGtwiz4CtrlAxiRReady
      sGtwiz4DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz4DrpChAxiAWAddr
      sGtwiz4DrpChAxiAWValid : out std_logic; -- sGtwiz4DrpChAxiAWValid
      sGtwiz4DrpChAxiAWReady : in std_logic; -- sGtwiz4DrpChAxiAWReady
      sGtwiz4DrpChAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz4DrpChAxiWData
      sGtwiz4DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz4DrpChAxiWStrb
      sGtwiz4DrpChAxiWValid : out std_logic; -- sGtwiz4DrpChAxiWValid
      sGtwiz4DrpChAxiWReady : in std_logic; -- sGtwiz4DrpChAxiWReady
      sGtwiz4DrpChAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz4DrpChAxiBResp
      sGtwiz4DrpChAxiBValid : in std_logic; -- sGtwiz4DrpChAxiBValid
      sGtwiz4DrpChAxiBReady : out std_logic; -- sGtwiz4DrpChAxiBReady
      sGtwiz4DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz4DrpChAxiARAddr
      sGtwiz4DrpChAxiARValid : out std_logic; -- sGtwiz4DrpChAxiARValid
      sGtwiz4DrpChAxiARReady : in std_logic; -- sGtwiz4DrpChAxiARReady
      sGtwiz4DrpChAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz4DrpChAxiRData
      sGtwiz4DrpChAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz4DrpChAxiRResp
      sGtwiz4DrpChAxiRValid : in std_logic; -- sGtwiz4DrpChAxiRValid
      sGtwiz4DrpChAxiRReady : out std_logic; -- sGtwiz4DrpChAxiRReady
      UserClkPort5 : in std_logic; -- UserClkPort5
      aPort5PmaInit : out std_logic; -- aPort5PmaInit
      aPort5ResetPb : out std_logic; -- aPort5ResetPb
      uPort5AxiTxTData0 : out std_logic_vector(63 downto 0); -- uPort5AxiTxTData0
      uPort5AxiTxTData1 : out std_logic_vector(63 downto 0); -- uPort5AxiTxTData1
      uPort5AxiTxTData2 : out std_logic_vector(63 downto 0); -- uPort5AxiTxTData2
      uPort5AxiTxTData3 : out std_logic_vector(63 downto 0); -- uPort5AxiTxTData3
      uPort5AxiTxTKeep : out std_logic_vector(31 downto 0); -- uPort5AxiTxTKeep
      uPort5AxiTxTLast : out std_logic; -- uPort5AxiTxTLast
      uPort5AxiTxTValid : out std_logic; -- uPort5AxiTxTValid
      uPort5AxiTxTReady : in std_logic; -- uPort5AxiTxTReady
      uPort5AxiRxTData0 : in std_logic_vector(63 downto 0); -- uPort5AxiRxTData0
      uPort5AxiRxTData1 : in std_logic_vector(63 downto 0); -- uPort5AxiRxTData1
      uPort5AxiRxTData2 : in std_logic_vector(63 downto 0); -- uPort5AxiRxTData2
      uPort5AxiRxTData3 : in std_logic_vector(63 downto 0); -- uPort5AxiRxTData3
      uPort5AxiRxTKeep : in std_logic_vector(31 downto 0); -- uPort5AxiRxTKeep
      uPort5AxiRxTLast : in std_logic; -- uPort5AxiRxTLast
      uPort5AxiRxTValid : in std_logic; -- uPort5AxiRxTValid
      uPort5AxiNfcTValid : out std_logic; -- uPort5AxiNfcTValid
      uPort5AxiNfcTData : out std_logic_vector(31 downto 0); -- uPort5AxiNfcTData
      uPort5AxiNfcTReady : in std_logic; -- uPort5AxiNfcTReady
      uPort5HardError : in std_logic; -- uPort5HardError
      uPort5SoftError : in std_logic; -- uPort5SoftError
      uPort5LaneUp : in std_logic_vector(3 downto 0); -- uPort5LaneUp
      uPort5ChannelUp : in std_logic; -- uPort5ChannelUp
      uPort5SysResetOut : in std_logic; -- uPort5SysResetOut
      uPort5MmcmNotLockOut : in std_logic; -- uPort5MmcmNotLockOut
      uPort5CrcPassFail_n : in std_logic; -- uPort5CrcPassFail_n
      uPort5CrcValid : in std_logic; -- uPort5CrcValid
      iPort5LinkResetOut : in std_logic; -- iPort5LinkResetOut
      sGtwiz5CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz5CtrlAxiAWAddr
      sGtwiz5CtrlAxiAWValid : out std_logic; -- sGtwiz5CtrlAxiAWValid
      sGtwiz5CtrlAxiAWReady : in std_logic; -- sGtwiz5CtrlAxiAWReady
      sGtwiz5CtrlAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz5CtrlAxiWData
      sGtwiz5CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz5CtrlAxiWStrb
      sGtwiz5CtrlAxiWValid : out std_logic; -- sGtwiz5CtrlAxiWValid
      sGtwiz5CtrlAxiWReady : in std_logic; -- sGtwiz5CtrlAxiWReady
      sGtwiz5CtrlAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz5CtrlAxiBResp
      sGtwiz5CtrlAxiBValid : in std_logic; -- sGtwiz5CtrlAxiBValid
      sGtwiz5CtrlAxiBReady : out std_logic; -- sGtwiz5CtrlAxiBReady
      sGtwiz5CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz5CtrlAxiARAddr
      sGtwiz5CtrlAxiARValid : out std_logic; -- sGtwiz5CtrlAxiARValid
      sGtwiz5CtrlAxiARReady : in std_logic; -- sGtwiz5CtrlAxiARReady
      sGtwiz5CtrlAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz5CtrlAxiRData
      sGtwiz5CtrlAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz5CtrlAxiRResp
      sGtwiz5CtrlAxiRValid : in std_logic; -- sGtwiz5CtrlAxiRValid
      sGtwiz5CtrlAxiRReady : out std_logic; -- sGtwiz5CtrlAxiRReady
      sGtwiz5DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz5DrpChAxiAWAddr
      sGtwiz5DrpChAxiAWValid : out std_logic; -- sGtwiz5DrpChAxiAWValid
      sGtwiz5DrpChAxiAWReady : in std_logic; -- sGtwiz5DrpChAxiAWReady
      sGtwiz5DrpChAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz5DrpChAxiWData
      sGtwiz5DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz5DrpChAxiWStrb
      sGtwiz5DrpChAxiWValid : out std_logic; -- sGtwiz5DrpChAxiWValid
      sGtwiz5DrpChAxiWReady : in std_logic; -- sGtwiz5DrpChAxiWReady
      sGtwiz5DrpChAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz5DrpChAxiBResp
      sGtwiz5DrpChAxiBValid : in std_logic; -- sGtwiz5DrpChAxiBValid
      sGtwiz5DrpChAxiBReady : out std_logic; -- sGtwiz5DrpChAxiBReady
      sGtwiz5DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz5DrpChAxiARAddr
      sGtwiz5DrpChAxiARValid : out std_logic; -- sGtwiz5DrpChAxiARValid
      sGtwiz5DrpChAxiARReady : in std_logic; -- sGtwiz5DrpChAxiARReady
      sGtwiz5DrpChAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz5DrpChAxiRData
      sGtwiz5DrpChAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz5DrpChAxiRResp
      sGtwiz5DrpChAxiRValid : in std_logic; -- sGtwiz5DrpChAxiRValid
      sGtwiz5DrpChAxiRReady : out std_logic; -- sGtwiz5DrpChAxiRReady
      UserClkPort6 : in std_logic; -- UserClkPort6
      aPort6PmaInit : out std_logic; -- aPort6PmaInit
      aPort6ResetPb : out std_logic; -- aPort6ResetPb
      uPort6AxiTxTData0 : out std_logic_vector(63 downto 0); -- uPort6AxiTxTData0
      uPort6AxiTxTData1 : out std_logic_vector(63 downto 0); -- uPort6AxiTxTData1
      uPort6AxiTxTData2 : out std_logic_vector(63 downto 0); -- uPort6AxiTxTData2
      uPort6AxiTxTData3 : out std_logic_vector(63 downto 0); -- uPort6AxiTxTData3
      uPort6AxiTxTKeep : out std_logic_vector(31 downto 0); -- uPort6AxiTxTKeep
      uPort6AxiTxTLast : out std_logic; -- uPort6AxiTxTLast
      uPort6AxiTxTValid : out std_logic; -- uPort6AxiTxTValid
      uPort6AxiTxTReady : in std_logic; -- uPort6AxiTxTReady
      uPort6AxiRxTData0 : in std_logic_vector(63 downto 0); -- uPort6AxiRxTData0
      uPort6AxiRxTData1 : in std_logic_vector(63 downto 0); -- uPort6AxiRxTData1
      uPort6AxiRxTData2 : in std_logic_vector(63 downto 0); -- uPort6AxiRxTData2
      uPort6AxiRxTData3 : in std_logic_vector(63 downto 0); -- uPort6AxiRxTData3
      uPort6AxiRxTKeep : in std_logic_vector(31 downto 0); -- uPort6AxiRxTKeep
      uPort6AxiRxTLast : in std_logic; -- uPort6AxiRxTLast
      uPort6AxiRxTValid : in std_logic; -- uPort6AxiRxTValid
      uPort6AxiNfcTValid : out std_logic; -- uPort6AxiNfcTValid
      uPort6AxiNfcTData : out std_logic_vector(31 downto 0); -- uPort6AxiNfcTData
      uPort6AxiNfcTReady : in std_logic; -- uPort6AxiNfcTReady
      uPort6HardError : in std_logic; -- uPort6HardError
      uPort6SoftError : in std_logic; -- uPort6SoftError
      uPort6LaneUp : in std_logic_vector(3 downto 0); -- uPort6LaneUp
      uPort6ChannelUp : in std_logic; -- uPort6ChannelUp
      uPort6SysResetOut : in std_logic; -- uPort6SysResetOut
      uPort6MmcmNotLockOut : in std_logic; -- uPort6MmcmNotLockOut
      uPort6CrcPassFail_n : in std_logic; -- uPort6CrcPassFail_n
      uPort6CrcValid : in std_logic; -- uPort6CrcValid
      iPort6LinkResetOut : in std_logic; -- iPort6LinkResetOut
      sGtwiz6CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz6CtrlAxiAWAddr
      sGtwiz6CtrlAxiAWValid : out std_logic; -- sGtwiz6CtrlAxiAWValid
      sGtwiz6CtrlAxiAWReady : in std_logic; -- sGtwiz6CtrlAxiAWReady
      sGtwiz6CtrlAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz6CtrlAxiWData
      sGtwiz6CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz6CtrlAxiWStrb
      sGtwiz6CtrlAxiWValid : out std_logic; -- sGtwiz6CtrlAxiWValid
      sGtwiz6CtrlAxiWReady : in std_logic; -- sGtwiz6CtrlAxiWReady
      sGtwiz6CtrlAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz6CtrlAxiBResp
      sGtwiz6CtrlAxiBValid : in std_logic; -- sGtwiz6CtrlAxiBValid
      sGtwiz6CtrlAxiBReady : out std_logic; -- sGtwiz6CtrlAxiBReady
      sGtwiz6CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz6CtrlAxiARAddr
      sGtwiz6CtrlAxiARValid : out std_logic; -- sGtwiz6CtrlAxiARValid
      sGtwiz6CtrlAxiARReady : in std_logic; -- sGtwiz6CtrlAxiARReady
      sGtwiz6CtrlAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz6CtrlAxiRData
      sGtwiz6CtrlAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz6CtrlAxiRResp
      sGtwiz6CtrlAxiRValid : in std_logic; -- sGtwiz6CtrlAxiRValid
      sGtwiz6CtrlAxiRReady : out std_logic; -- sGtwiz6CtrlAxiRReady
      sGtwiz6DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz6DrpChAxiAWAddr
      sGtwiz6DrpChAxiAWValid : out std_logic; -- sGtwiz6DrpChAxiAWValid
      sGtwiz6DrpChAxiAWReady : in std_logic; -- sGtwiz6DrpChAxiAWReady
      sGtwiz6DrpChAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz6DrpChAxiWData
      sGtwiz6DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz6DrpChAxiWStrb
      sGtwiz6DrpChAxiWValid : out std_logic; -- sGtwiz6DrpChAxiWValid
      sGtwiz6DrpChAxiWReady : in std_logic; -- sGtwiz6DrpChAxiWReady
      sGtwiz6DrpChAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz6DrpChAxiBResp
      sGtwiz6DrpChAxiBValid : in std_logic; -- sGtwiz6DrpChAxiBValid
      sGtwiz6DrpChAxiBReady : out std_logic; -- sGtwiz6DrpChAxiBReady
      sGtwiz6DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz6DrpChAxiARAddr
      sGtwiz6DrpChAxiARValid : out std_logic; -- sGtwiz6DrpChAxiARValid
      sGtwiz6DrpChAxiARReady : in std_logic; -- sGtwiz6DrpChAxiARReady
      sGtwiz6DrpChAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz6DrpChAxiRData
      sGtwiz6DrpChAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz6DrpChAxiRResp
      sGtwiz6DrpChAxiRValid : in std_logic; -- sGtwiz6DrpChAxiRValid
      sGtwiz6DrpChAxiRReady : out std_logic; -- sGtwiz6DrpChAxiRReady
      UserClkPort7 : in std_logic; -- UserClkPort7
      aPort7PmaInit : out std_logic; -- aPort7PmaInit
      aPort7ResetPb : out std_logic; -- aPort7ResetPb
      uPort7AxiTxTData0 : out std_logic_vector(63 downto 0); -- uPort7AxiTxTData0
      uPort7AxiTxTData1 : out std_logic_vector(63 downto 0); -- uPort7AxiTxTData1
      uPort7AxiTxTData2 : out std_logic_vector(63 downto 0); -- uPort7AxiTxTData2
      uPort7AxiTxTData3 : out std_logic_vector(63 downto 0); -- uPort7AxiTxTData3
      uPort7AxiTxTKeep : out std_logic_vector(31 downto 0); -- uPort7AxiTxTKeep
      uPort7AxiTxTLast : out std_logic; -- uPort7AxiTxTLast
      uPort7AxiTxTValid : out std_logic; -- uPort7AxiTxTValid
      uPort7AxiTxTReady : in std_logic; -- uPort7AxiTxTReady
      uPort7AxiRxTData0 : in std_logic_vector(63 downto 0); -- uPort7AxiRxTData0
      uPort7AxiRxTData1 : in std_logic_vector(63 downto 0); -- uPort7AxiRxTData1
      uPort7AxiRxTData2 : in std_logic_vector(63 downto 0); -- uPort7AxiRxTData2
      uPort7AxiRxTData3 : in std_logic_vector(63 downto 0); -- uPort7AxiRxTData3
      uPort7AxiRxTKeep : in std_logic_vector(31 downto 0); -- uPort7AxiRxTKeep
      uPort7AxiRxTLast : in std_logic; -- uPort7AxiRxTLast
      uPort7AxiRxTValid : in std_logic; -- uPort7AxiRxTValid
      uPort7AxiNfcTValid : out std_logic; -- uPort7AxiNfcTValid
      uPort7AxiNfcTData : out std_logic_vector(31 downto 0); -- uPort7AxiNfcTData
      uPort7AxiNfcTReady : in std_logic; -- uPort7AxiNfcTReady
      uPort7HardError : in std_logic; -- uPort7HardError
      uPort7SoftError : in std_logic; -- uPort7SoftError
      uPort7LaneUp : in std_logic_vector(3 downto 0); -- uPort7LaneUp
      uPort7ChannelUp : in std_logic; -- uPort7ChannelUp
      uPort7SysResetOut : in std_logic; -- uPort7SysResetOut
      uPort7MmcmNotLockOut : in std_logic; -- uPort7MmcmNotLockOut
      uPort7CrcPassFail_n : in std_logic; -- uPort7CrcPassFail_n
      uPort7CrcValid : in std_logic; -- uPort7CrcValid
      iPort7LinkResetOut : in std_logic; -- iPort7LinkResetOut
      sGtwiz7CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz7CtrlAxiAWAddr
      sGtwiz7CtrlAxiAWValid : out std_logic; -- sGtwiz7CtrlAxiAWValid
      sGtwiz7CtrlAxiAWReady : in std_logic; -- sGtwiz7CtrlAxiAWReady
      sGtwiz7CtrlAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz7CtrlAxiWData
      sGtwiz7CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz7CtrlAxiWStrb
      sGtwiz7CtrlAxiWValid : out std_logic; -- sGtwiz7CtrlAxiWValid
      sGtwiz7CtrlAxiWReady : in std_logic; -- sGtwiz7CtrlAxiWReady
      sGtwiz7CtrlAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz7CtrlAxiBResp
      sGtwiz7CtrlAxiBValid : in std_logic; -- sGtwiz7CtrlAxiBValid
      sGtwiz7CtrlAxiBReady : out std_logic; -- sGtwiz7CtrlAxiBReady
      sGtwiz7CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz7CtrlAxiARAddr
      sGtwiz7CtrlAxiARValid : out std_logic; -- sGtwiz7CtrlAxiARValid
      sGtwiz7CtrlAxiARReady : in std_logic; -- sGtwiz7CtrlAxiARReady
      sGtwiz7CtrlAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz7CtrlAxiRData
      sGtwiz7CtrlAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz7CtrlAxiRResp
      sGtwiz7CtrlAxiRValid : in std_logic; -- sGtwiz7CtrlAxiRValid
      sGtwiz7CtrlAxiRReady : out std_logic; -- sGtwiz7CtrlAxiRReady
      sGtwiz7DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz7DrpChAxiAWAddr
      sGtwiz7DrpChAxiAWValid : out std_logic; -- sGtwiz7DrpChAxiAWValid
      sGtwiz7DrpChAxiAWReady : in std_logic; -- sGtwiz7DrpChAxiAWReady
      sGtwiz7DrpChAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz7DrpChAxiWData
      sGtwiz7DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz7DrpChAxiWStrb
      sGtwiz7DrpChAxiWValid : out std_logic; -- sGtwiz7DrpChAxiWValid
      sGtwiz7DrpChAxiWReady : in std_logic; -- sGtwiz7DrpChAxiWReady
      sGtwiz7DrpChAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz7DrpChAxiBResp
      sGtwiz7DrpChAxiBValid : in std_logic; -- sGtwiz7DrpChAxiBValid
      sGtwiz7DrpChAxiBReady : out std_logic; -- sGtwiz7DrpChAxiBReady
      sGtwiz7DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz7DrpChAxiARAddr
      sGtwiz7DrpChAxiARValid : out std_logic; -- sGtwiz7DrpChAxiARValid
      sGtwiz7DrpChAxiARReady : in std_logic; -- sGtwiz7DrpChAxiARReady
      sGtwiz7DrpChAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz7DrpChAxiRData
      sGtwiz7DrpChAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz7DrpChAxiRResp
      sGtwiz7DrpChAxiRValid : in std_logic; -- sGtwiz7DrpChAxiRValid
      sGtwiz7DrpChAxiRReady : out std_logic; -- sGtwiz7DrpChAxiRReady
      UserClkPort8 : in std_logic; -- UserClkPort8
      aPort8PmaInit : out std_logic; -- aPort8PmaInit
      aPort8ResetPb : out std_logic; -- aPort8ResetPb
      uPort8AxiTxTData0 : out std_logic_vector(63 downto 0); -- uPort8AxiTxTData0
      uPort8AxiTxTData1 : out std_logic_vector(63 downto 0); -- uPort8AxiTxTData1
      uPort8AxiTxTData2 : out std_logic_vector(63 downto 0); -- uPort8AxiTxTData2
      uPort8AxiTxTData3 : out std_logic_vector(63 downto 0); -- uPort8AxiTxTData3
      uPort8AxiTxTKeep : out std_logic_vector(31 downto 0); -- uPort8AxiTxTKeep
      uPort8AxiTxTLast : out std_logic; -- uPort8AxiTxTLast
      uPort8AxiTxTValid : out std_logic; -- uPort8AxiTxTValid
      uPort8AxiTxTReady : in std_logic; -- uPort8AxiTxTReady
      uPort8AxiRxTData0 : in std_logic_vector(63 downto 0); -- uPort8AxiRxTData0
      uPort8AxiRxTData1 : in std_logic_vector(63 downto 0); -- uPort8AxiRxTData1
      uPort8AxiRxTData2 : in std_logic_vector(63 downto 0); -- uPort8AxiRxTData2
      uPort8AxiRxTData3 : in std_logic_vector(63 downto 0); -- uPort8AxiRxTData3
      uPort8AxiRxTKeep : in std_logic_vector(31 downto 0); -- uPort8AxiRxTKeep
      uPort8AxiRxTLast : in std_logic; -- uPort8AxiRxTLast
      uPort8AxiRxTValid : in std_logic; -- uPort8AxiRxTValid
      uPort8AxiNfcTValid : out std_logic; -- uPort8AxiNfcTValid
      uPort8AxiNfcTData : out std_logic_vector(31 downto 0); -- uPort8AxiNfcTData
      uPort8AxiNfcTReady : in std_logic; -- uPort8AxiNfcTReady
      uPort8HardError : in std_logic; -- uPort8HardError
      uPort8SoftError : in std_logic; -- uPort8SoftError
      uPort8LaneUp : in std_logic_vector(3 downto 0); -- uPort8LaneUp
      uPort8ChannelUp : in std_logic; -- uPort8ChannelUp
      uPort8SysResetOut : in std_logic; -- uPort8SysResetOut
      uPort8MmcmNotLockOut : in std_logic; -- uPort8MmcmNotLockOut
      uPort8CrcPassFail_n : in std_logic; -- uPort8CrcPassFail_n
      uPort8CrcValid : in std_logic; -- uPort8CrcValid
      iPort8LinkResetOut : in std_logic; -- iPort8LinkResetOut
      sGtwiz8CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz8CtrlAxiAWAddr
      sGtwiz8CtrlAxiAWValid : out std_logic; -- sGtwiz8CtrlAxiAWValid
      sGtwiz8CtrlAxiAWReady : in std_logic; -- sGtwiz8CtrlAxiAWReady
      sGtwiz8CtrlAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz8CtrlAxiWData
      sGtwiz8CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz8CtrlAxiWStrb
      sGtwiz8CtrlAxiWValid : out std_logic; -- sGtwiz8CtrlAxiWValid
      sGtwiz8CtrlAxiWReady : in std_logic; -- sGtwiz8CtrlAxiWReady
      sGtwiz8CtrlAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz8CtrlAxiBResp
      sGtwiz8CtrlAxiBValid : in std_logic; -- sGtwiz8CtrlAxiBValid
      sGtwiz8CtrlAxiBReady : out std_logic; -- sGtwiz8CtrlAxiBReady
      sGtwiz8CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz8CtrlAxiARAddr
      sGtwiz8CtrlAxiARValid : out std_logic; -- sGtwiz8CtrlAxiARValid
      sGtwiz8CtrlAxiARReady : in std_logic; -- sGtwiz8CtrlAxiARReady
      sGtwiz8CtrlAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz8CtrlAxiRData
      sGtwiz8CtrlAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz8CtrlAxiRResp
      sGtwiz8CtrlAxiRValid : in std_logic; -- sGtwiz8CtrlAxiRValid
      sGtwiz8CtrlAxiRReady : out std_logic; -- sGtwiz8CtrlAxiRReady
      sGtwiz8DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz8DrpChAxiAWAddr
      sGtwiz8DrpChAxiAWValid : out std_logic; -- sGtwiz8DrpChAxiAWValid
      sGtwiz8DrpChAxiAWReady : in std_logic; -- sGtwiz8DrpChAxiAWReady
      sGtwiz8DrpChAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz8DrpChAxiWData
      sGtwiz8DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz8DrpChAxiWStrb
      sGtwiz8DrpChAxiWValid : out std_logic; -- sGtwiz8DrpChAxiWValid
      sGtwiz8DrpChAxiWReady : in std_logic; -- sGtwiz8DrpChAxiWReady
      sGtwiz8DrpChAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz8DrpChAxiBResp
      sGtwiz8DrpChAxiBValid : in std_logic; -- sGtwiz8DrpChAxiBValid
      sGtwiz8DrpChAxiBReady : out std_logic; -- sGtwiz8DrpChAxiBReady
      sGtwiz8DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz8DrpChAxiARAddr
      sGtwiz8DrpChAxiARValid : out std_logic; -- sGtwiz8DrpChAxiARValid
      sGtwiz8DrpChAxiARReady : in std_logic; -- sGtwiz8DrpChAxiARReady
      sGtwiz8DrpChAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz8DrpChAxiRData
      sGtwiz8DrpChAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz8DrpChAxiRResp
      sGtwiz8DrpChAxiRValid : in std_logic; -- sGtwiz8DrpChAxiRValid
      sGtwiz8DrpChAxiRReady : out std_logic; -- sGtwiz8DrpChAxiRReady
      UserClkPort9 : in std_logic; -- UserClkPort9
      aPort9PmaInit : out std_logic; -- aPort9PmaInit
      aPort9ResetPb : out std_logic; -- aPort9ResetPb
      uPort9AxiTxTData0 : out std_logic_vector(63 downto 0); -- uPort9AxiTxTData0
      uPort9AxiTxTData1 : out std_logic_vector(63 downto 0); -- uPort9AxiTxTData1
      uPort9AxiTxTData2 : out std_logic_vector(63 downto 0); -- uPort9AxiTxTData2
      uPort9AxiTxTData3 : out std_logic_vector(63 downto 0); -- uPort9AxiTxTData3
      uPort9AxiTxTKeep : out std_logic_vector(31 downto 0); -- uPort9AxiTxTKeep
      uPort9AxiTxTLast : out std_logic; -- uPort9AxiTxTLast
      uPort9AxiTxTValid : out std_logic; -- uPort9AxiTxTValid
      uPort9AxiTxTReady : in std_logic; -- uPort9AxiTxTReady
      uPort9AxiRxTData0 : in std_logic_vector(63 downto 0); -- uPort9AxiRxTData0
      uPort9AxiRxTData1 : in std_logic_vector(63 downto 0); -- uPort9AxiRxTData1
      uPort9AxiRxTData2 : in std_logic_vector(63 downto 0); -- uPort9AxiRxTData2
      uPort9AxiRxTData3 : in std_logic_vector(63 downto 0); -- uPort9AxiRxTData3
      uPort9AxiRxTKeep : in std_logic_vector(31 downto 0); -- uPort9AxiRxTKeep
      uPort9AxiRxTLast : in std_logic; -- uPort9AxiRxTLast
      uPort9AxiRxTValid : in std_logic; -- uPort9AxiRxTValid
      uPort9AxiNfcTValid : out std_logic; -- uPort9AxiNfcTValid
      uPort9AxiNfcTData : out std_logic_vector(31 downto 0); -- uPort9AxiNfcTData
      uPort9AxiNfcTReady : in std_logic; -- uPort9AxiNfcTReady
      uPort9HardError : in std_logic; -- uPort9HardError
      uPort9SoftError : in std_logic; -- uPort9SoftError
      uPort9LaneUp : in std_logic_vector(3 downto 0); -- uPort9LaneUp
      uPort9ChannelUp : in std_logic; -- uPort9ChannelUp
      uPort9SysResetOut : in std_logic; -- uPort9SysResetOut
      uPort9MmcmNotLockOut : in std_logic; -- uPort9MmcmNotLockOut
      uPort9CrcPassFail_n : in std_logic; -- uPort9CrcPassFail_n
      uPort9CrcValid : in std_logic; -- uPort9CrcValid
      iPort9LinkResetOut : in std_logic; -- iPort9LinkResetOut
      sGtwiz9CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz9CtrlAxiAWAddr
      sGtwiz9CtrlAxiAWValid : out std_logic; -- sGtwiz9CtrlAxiAWValid
      sGtwiz9CtrlAxiAWReady : in std_logic; -- sGtwiz9CtrlAxiAWReady
      sGtwiz9CtrlAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz9CtrlAxiWData
      sGtwiz9CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz9CtrlAxiWStrb
      sGtwiz9CtrlAxiWValid : out std_logic; -- sGtwiz9CtrlAxiWValid
      sGtwiz9CtrlAxiWReady : in std_logic; -- sGtwiz9CtrlAxiWReady
      sGtwiz9CtrlAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz9CtrlAxiBResp
      sGtwiz9CtrlAxiBValid : in std_logic; -- sGtwiz9CtrlAxiBValid
      sGtwiz9CtrlAxiBReady : out std_logic; -- sGtwiz9CtrlAxiBReady
      sGtwiz9CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz9CtrlAxiARAddr
      sGtwiz9CtrlAxiARValid : out std_logic; -- sGtwiz9CtrlAxiARValid
      sGtwiz9CtrlAxiARReady : in std_logic; -- sGtwiz9CtrlAxiARReady
      sGtwiz9CtrlAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz9CtrlAxiRData
      sGtwiz9CtrlAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz9CtrlAxiRResp
      sGtwiz9CtrlAxiRValid : in std_logic; -- sGtwiz9CtrlAxiRValid
      sGtwiz9CtrlAxiRReady : out std_logic; -- sGtwiz9CtrlAxiRReady
      sGtwiz9DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz9DrpChAxiAWAddr
      sGtwiz9DrpChAxiAWValid : out std_logic; -- sGtwiz9DrpChAxiAWValid
      sGtwiz9DrpChAxiAWReady : in std_logic; -- sGtwiz9DrpChAxiAWReady
      sGtwiz9DrpChAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz9DrpChAxiWData
      sGtwiz9DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz9DrpChAxiWStrb
      sGtwiz9DrpChAxiWValid : out std_logic; -- sGtwiz9DrpChAxiWValid
      sGtwiz9DrpChAxiWReady : in std_logic; -- sGtwiz9DrpChAxiWReady
      sGtwiz9DrpChAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz9DrpChAxiBResp
      sGtwiz9DrpChAxiBValid : in std_logic; -- sGtwiz9DrpChAxiBValid
      sGtwiz9DrpChAxiBReady : out std_logic; -- sGtwiz9DrpChAxiBReady
      sGtwiz9DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz9DrpChAxiARAddr
      sGtwiz9DrpChAxiARValid : out std_logic; -- sGtwiz9DrpChAxiARValid
      sGtwiz9DrpChAxiARReady : in std_logic; -- sGtwiz9DrpChAxiARReady
      sGtwiz9DrpChAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz9DrpChAxiRData
      sGtwiz9DrpChAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz9DrpChAxiRResp
      sGtwiz9DrpChAxiRValid : in std_logic; -- sGtwiz9DrpChAxiRValid
      sGtwiz9DrpChAxiRReady : out std_logic; -- sGtwiz9DrpChAxiRReady
      UserClkPort10 : in std_logic; -- UserClkPort10
      aPort10PmaInit : out std_logic; -- aPort10PmaInit
      aPort10ResetPb : out std_logic; -- aPort10ResetPb
      uPort10AxiTxTData0 : out std_logic_vector(63 downto 0); -- uPort10AxiTxTData0
      uPort10AxiTxTData1 : out std_logic_vector(63 downto 0); -- uPort10AxiTxTData1
      uPort10AxiTxTData2 : out std_logic_vector(63 downto 0); -- uPort10AxiTxTData2
      uPort10AxiTxTData3 : out std_logic_vector(63 downto 0); -- uPort10AxiTxTData3
      uPort10AxiTxTKeep : out std_logic_vector(31 downto 0); -- uPort10AxiTxTKeep
      uPort10AxiTxTLast : out std_logic; -- uPort10AxiTxTLast
      uPort10AxiTxTValid : out std_logic; -- uPort10AxiTxTValid
      uPort10AxiTxTReady : in std_logic; -- uPort10AxiTxTReady
      uPort10AxiRxTData0 : in std_logic_vector(63 downto 0); -- uPort10AxiRxTData0
      uPort10AxiRxTData1 : in std_logic_vector(63 downto 0); -- uPort10AxiRxTData1
      uPort10AxiRxTData2 : in std_logic_vector(63 downto 0); -- uPort10AxiRxTData2
      uPort10AxiRxTData3 : in std_logic_vector(63 downto 0); -- uPort10AxiRxTData3
      uPort10AxiRxTKeep : in std_logic_vector(31 downto 0); -- uPort10AxiRxTKeep
      uPort10AxiRxTLast : in std_logic; -- uPort10AxiRxTLast
      uPort10AxiRxTValid : in std_logic; -- uPort10AxiRxTValid
      uPort10AxiNfcTValid : out std_logic; -- uPort10AxiNfcTValid
      uPort10AxiNfcTData : out std_logic_vector(31 downto 0); -- uPort10AxiNfcTData
      uPort10AxiNfcTReady : in std_logic; -- uPort10AxiNfcTReady
      uPort10HardError : in std_logic; -- uPort10HardError
      uPort10SoftError : in std_logic; -- uPort10SoftError
      uPort10LaneUp : in std_logic_vector(3 downto 0); -- uPort10LaneUp
      uPort10ChannelUp : in std_logic; -- uPort10ChannelUp
      uPort10SysResetOut : in std_logic; -- uPort10SysResetOut
      uPort10MmcmNotLockOut : in std_logic; -- uPort10MmcmNotLockOut
      uPort10CrcPassFail_n : in std_logic; -- uPort10CrcPassFail_n
      uPort10CrcValid : in std_logic; -- uPort10CrcValid
      iPort10LinkResetOut : in std_logic; -- iPort10LinkResetOut
      sGtwiz10CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz10CtrlAxiAWAddr
      sGtwiz10CtrlAxiAWValid : out std_logic; -- sGtwiz10CtrlAxiAWValid
      sGtwiz10CtrlAxiAWReady : in std_logic; -- sGtwiz10CtrlAxiAWReady
      sGtwiz10CtrlAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz10CtrlAxiWData
      sGtwiz10CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz10CtrlAxiWStrb
      sGtwiz10CtrlAxiWValid : out std_logic; -- sGtwiz10CtrlAxiWValid
      sGtwiz10CtrlAxiWReady : in std_logic; -- sGtwiz10CtrlAxiWReady
      sGtwiz10CtrlAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz10CtrlAxiBResp
      sGtwiz10CtrlAxiBValid : in std_logic; -- sGtwiz10CtrlAxiBValid
      sGtwiz10CtrlAxiBReady : out std_logic; -- sGtwiz10CtrlAxiBReady
      sGtwiz10CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz10CtrlAxiARAddr
      sGtwiz10CtrlAxiARValid : out std_logic; -- sGtwiz10CtrlAxiARValid
      sGtwiz10CtrlAxiARReady : in std_logic; -- sGtwiz10CtrlAxiARReady
      sGtwiz10CtrlAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz10CtrlAxiRData
      sGtwiz10CtrlAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz10CtrlAxiRResp
      sGtwiz10CtrlAxiRValid : in std_logic; -- sGtwiz10CtrlAxiRValid
      sGtwiz10CtrlAxiRReady : out std_logic; -- sGtwiz10CtrlAxiRReady
      sGtwiz10DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz10DrpChAxiAWAddr
      sGtwiz10DrpChAxiAWValid : out std_logic; -- sGtwiz10DrpChAxiAWValid
      sGtwiz10DrpChAxiAWReady : in std_logic; -- sGtwiz10DrpChAxiAWReady
      sGtwiz10DrpChAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz10DrpChAxiWData
      sGtwiz10DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz10DrpChAxiWStrb
      sGtwiz10DrpChAxiWValid : out std_logic; -- sGtwiz10DrpChAxiWValid
      sGtwiz10DrpChAxiWReady : in std_logic; -- sGtwiz10DrpChAxiWReady
      sGtwiz10DrpChAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz10DrpChAxiBResp
      sGtwiz10DrpChAxiBValid : in std_logic; -- sGtwiz10DrpChAxiBValid
      sGtwiz10DrpChAxiBReady : out std_logic; -- sGtwiz10DrpChAxiBReady
      sGtwiz10DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz10DrpChAxiARAddr
      sGtwiz10DrpChAxiARValid : out std_logic; -- sGtwiz10DrpChAxiARValid
      sGtwiz10DrpChAxiARReady : in std_logic; -- sGtwiz10DrpChAxiARReady
      sGtwiz10DrpChAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz10DrpChAxiRData
      sGtwiz10DrpChAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz10DrpChAxiRResp
      sGtwiz10DrpChAxiRValid : in std_logic; -- sGtwiz10DrpChAxiRValid
      sGtwiz10DrpChAxiRReady : out std_logic; -- sGtwiz10DrpChAxiRReady
      UserClkPort11 : in std_logic; -- UserClkPort11
      aPort11PmaInit : out std_logic; -- aPort11PmaInit
      aPort11ResetPb : out std_logic; -- aPort11ResetPb
      uPort11AxiTxTData0 : out std_logic_vector(63 downto 0); -- uPort11AxiTxTData0
      uPort11AxiTxTData1 : out std_logic_vector(63 downto 0); -- uPort11AxiTxTData1
      uPort11AxiTxTData2 : out std_logic_vector(63 downto 0); -- uPort11AxiTxTData2
      uPort11AxiTxTData3 : out std_logic_vector(63 downto 0); -- uPort11AxiTxTData3
      uPort11AxiTxTKeep : out std_logic_vector(31 downto 0); -- uPort11AxiTxTKeep
      uPort11AxiTxTLast : out std_logic; -- uPort11AxiTxTLast
      uPort11AxiTxTValid : out std_logic; -- uPort11AxiTxTValid
      uPort11AxiTxTReady : in std_logic; -- uPort11AxiTxTReady
      uPort11AxiRxTData0 : in std_logic_vector(63 downto 0); -- uPort11AxiRxTData0
      uPort11AxiRxTData1 : in std_logic_vector(63 downto 0); -- uPort11AxiRxTData1
      uPort11AxiRxTData2 : in std_logic_vector(63 downto 0); -- uPort11AxiRxTData2
      uPort11AxiRxTData3 : in std_logic_vector(63 downto 0); -- uPort11AxiRxTData3
      uPort11AxiRxTKeep : in std_logic_vector(31 downto 0); -- uPort11AxiRxTKeep
      uPort11AxiRxTLast : in std_logic; -- uPort11AxiRxTLast
      uPort11AxiRxTValid : in std_logic; -- uPort11AxiRxTValid
      uPort11AxiNfcTValid : out std_logic; -- uPort11AxiNfcTValid
      uPort11AxiNfcTData : out std_logic_vector(31 downto 0); -- uPort11AxiNfcTData
      uPort11AxiNfcTReady : in std_logic; -- uPort11AxiNfcTReady
      uPort11HardError : in std_logic; -- uPort11HardError
      uPort11SoftError : in std_logic; -- uPort11SoftError
      uPort11LaneUp : in std_logic_vector(3 downto 0); -- uPort11LaneUp
      uPort11ChannelUp : in std_logic; -- uPort11ChannelUp
      uPort11SysResetOut : in std_logic; -- uPort11SysResetOut
      uPort11MmcmNotLockOut : in std_logic; -- uPort11MmcmNotLockOut
      uPort11CrcPassFail_n : in std_logic; -- uPort11CrcPassFail_n
      uPort11CrcValid : in std_logic; -- uPort11CrcValid
      iPort11LinkResetOut : in std_logic; -- iPort11LinkResetOut
      sGtwiz11CtrlAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz11CtrlAxiAWAddr
      sGtwiz11CtrlAxiAWValid : out std_logic; -- sGtwiz11CtrlAxiAWValid
      sGtwiz11CtrlAxiAWReady : in std_logic; -- sGtwiz11CtrlAxiAWReady
      sGtwiz11CtrlAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz11CtrlAxiWData
      sGtwiz11CtrlAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz11CtrlAxiWStrb
      sGtwiz11CtrlAxiWValid : out std_logic; -- sGtwiz11CtrlAxiWValid
      sGtwiz11CtrlAxiWReady : in std_logic; -- sGtwiz11CtrlAxiWReady
      sGtwiz11CtrlAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz11CtrlAxiBResp
      sGtwiz11CtrlAxiBValid : in std_logic; -- sGtwiz11CtrlAxiBValid
      sGtwiz11CtrlAxiBReady : out std_logic; -- sGtwiz11CtrlAxiBReady
      sGtwiz11CtrlAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz11CtrlAxiARAddr
      sGtwiz11CtrlAxiARValid : out std_logic; -- sGtwiz11CtrlAxiARValid
      sGtwiz11CtrlAxiARReady : in std_logic; -- sGtwiz11CtrlAxiARReady
      sGtwiz11CtrlAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz11CtrlAxiRData
      sGtwiz11CtrlAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz11CtrlAxiRResp
      sGtwiz11CtrlAxiRValid : in std_logic; -- sGtwiz11CtrlAxiRValid
      sGtwiz11CtrlAxiRReady : out std_logic; -- sGtwiz11CtrlAxiRReady
      sGtwiz11DrpChAxiAWAddr : out std_logic_vector(31 downto 0); -- sGtwiz11DrpChAxiAWAddr
      sGtwiz11DrpChAxiAWValid : out std_logic; -- sGtwiz11DrpChAxiAWValid
      sGtwiz11DrpChAxiAWReady : in std_logic; -- sGtwiz11DrpChAxiAWReady
      sGtwiz11DrpChAxiWData : out std_logic_vector(31 downto 0); -- sGtwiz11DrpChAxiWData
      sGtwiz11DrpChAxiWStrb : out std_logic_vector(3 downto 0); -- sGtwiz11DrpChAxiWStrb
      sGtwiz11DrpChAxiWValid : out std_logic; -- sGtwiz11DrpChAxiWValid
      sGtwiz11DrpChAxiWReady : in std_logic; -- sGtwiz11DrpChAxiWReady
      sGtwiz11DrpChAxiBResp : in std_logic_vector(1 downto 0); -- sGtwiz11DrpChAxiBResp
      sGtwiz11DrpChAxiBValid : in std_logic; -- sGtwiz11DrpChAxiBValid
      sGtwiz11DrpChAxiBReady : out std_logic; -- sGtwiz11DrpChAxiBReady
      sGtwiz11DrpChAxiARAddr : out std_logic_vector(31 downto 0); -- sGtwiz11DrpChAxiARAddr
      sGtwiz11DrpChAxiARValid : out std_logic; -- sGtwiz11DrpChAxiARValid
      sGtwiz11DrpChAxiARReady : in std_logic; -- sGtwiz11DrpChAxiARReady
      sGtwiz11DrpChAxiRData : in std_logic_vector(31 downto 0); -- sGtwiz11DrpChAxiRData
      sGtwiz11DrpChAxiRResp : in std_logic_vector(1 downto 0); -- sGtwiz11DrpChAxiRResp
      sGtwiz11DrpChAxiRValid : in std_logic; -- sGtwiz11DrpChAxiRValid
      sGtwiz11DrpChAxiRReady : out std_logic; -- sGtwiz11DrpChAxiRReady

      -----------------------------------
      -- Communication interface ports
      -----------------------------------
      -- Reset ports
      aBusReset : in std_logic;

      -- Register Access/ PIO Ports
      bRegPortIn : in std_logic_vector(kRegPortInSize-1 downto 0);
      bRegPortOut : out std_logic_vector(kRegPortOutSize-1 downto 0);
      bRegPortTimeout : in std_logic;

      -- DMA Stream Ports
      dInputStreamInterfaceToFifo : in std_logic_vector(
        Larger(kNumberOfDmaChannels,1)*SizeOf(kInputStreamInterfaceToFifoZero)-1 downto 0);
      dInputStreamInterfaceFromFifo : out std_logic_vector(
        Larger(kNumberOfDmaChannels,1)*SizeOf(kInputStreamInterfaceFromFifoZero)-1 downto 0);
      dOutputStreamInterfaceToFifo : in std_logic_vector(
        Larger(kNumberOfDmaChannels,1)*SizeOf(kOutputStreamInterfaceToFifoZero)-1 downto 0);
      dOutputStreamInterfaceFromFifo : out std_logic_vector(
        Larger(kNumberOfDmaChannels,1)*SizeOf(kOutputStreamInterfaceFromFifoZero)-1 downto 0);

      -- Memory Buffer DMA Stream Ports (if any)

      -- IRQ Ports
      bIrqToInterface : out std_logic_vector(
        Larger(kNumberOfIrqs,1)*kIrqToInterfaceSize*kIrqStatusToInterfaceSize-1 downto 0);

      -- MasterPort Ports
      dNiFpgaMasterWriteRequestFromMaster : out std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterWriteRequestFromMasterZero)-1 downto 0);
      dNiFpgaMasterWriteRequestToMaster : in std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterWriteRequestToMasterZero)-1 downto 0);
      dNiFpgaMasterWriteDataFromMaster : out std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterWriteDataFromMasterZero)-1 downto 0);
      dNiFpgaMasterWriteDataToMaster : in std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterWriteDataToMasterZero)-1 downto 0);
      dNiFpgaMasterWriteStatusToMaster : in std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterWriteStatusToMasterZero)-1 downto 0);

      dNiFpgaMasterReadRequestFromMaster : out std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterReadRequestFromMasterZero)-1 downto 0);
      dNiFpgaMasterReadRequestToMaster : in std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterReadRequestToMasterZero)-1 downto 0);
      dNiFpgaMasterReadDataToMaster : in std_logic_vector(
        Larger(kNumberOfMasterPorts,1)*SizeOf(kNiFpgaMasterReadDataToMasterZero)-1 downto 0);

      -----------------------------------
      -- Clocks from TopLevel
      -----------------------------------
      DmaClk :  in std_logic;
      BusClk :  in std_logic;
      ReliableClkIn :  in std_logic;
      PllClk80 :  in std_logic;
      DlyRefClk :  in std_logic;
      PxieClk100 :  in std_logic;
      DramClkLvFpga :  in std_logic;
      Dram0ClkSocket :  in std_logic;
      Dram1ClkSocket :  in std_logic;
      Dram0ClkUser :  in std_logic;
      Dram1ClkUser :  in std_logic;
      dHmbDmaClkSocket :  in std_logic;
      dLlbDmaClkSocket :  in std_logic;

      -----------------------------------
      -- IO Node ports
      -----------------------------------
      pIntSync100 : in std_logic;
      aIntClk10 : in std_logic;

      -----------------------------------
      -- Target Method and Properties ports
      -----------------------------------
      bdIFifoRdData : out  std_logic_vector(63 downto 0);
      bdIFifoRdDataValid : out std_logic;
      bdIFifoRdReadyForInput : in std_logic;
      bdIFifoRdIsError : out std_logic;
      bdIFifoWrData : in  std_logic_vector(63 downto 0);
      bdIFifoWrDataValid : in std_logic;
      bdIFifoWrReadyForOutput : out std_logic;
      bdAxiStreamRdFromClipTData : in  std_logic_vector(31 downto 0);
      bdAxiStreamRdFromClipTLast : in std_logic;
      bdAxiStreamRdFromClipTValid : in std_logic;
      bdAxiStreamRdToClipTReady : out std_logic;
      bdAxiStreamWrToClipTData : out  std_logic_vector(31 downto 0);
      bdAxiStreamWrToClipTLast : out std_logic;
      bdAxiStreamWrToClipTValid : out std_logic;
      bdAxiStreamWrFromClipTReady : in std_logic;

      -----------------------------------
      -- Pass through LabVIEW FPGA ports
      -----------------------------------

      ----------------------------------------
      -- Trigger Routing Socketed CLIP
      ----------------------------------------
      PxieClk100Trigger : in std_logic;
      pIntSync100Trigger : in std_logic;
      dDevClkEn : in std_logic;
      aIntClk10Trigger : in std_logic;
      bRoutingClipPresent : out std_logic;
      bRoutingClipNiCompatible : out std_logic;
      BusClkTrigger : in std_logic;
      abBusResetTrigger : in std_logic;
      bTriggerRoutingBaRegPortInAddress : in std_logic_vector(27 downto 0);
      bTriggerRoutingBaRegPortInData : in std_logic_vector(63 downto 0);
      bTriggerRoutingBaRegPortInWtStrobe : in std_logic_vector(7 downto 0);
      bTriggerRoutingBaRegPortInRdStrobe : in std_logic_vector(7 downto 0);
      bTriggerRoutingBaRegPortOutData : out std_logic_vector(63 downto 0);
      bTriggerRoutingBaRegPortOutAck : out std_logic;
      aPxiTrigDataIn : in  std_logic_vector(7 downto 0);
      aPxiTrigDataOut : out std_logic_vector(7 downto 0);
      aPxiTrigDataTri : out std_logic_vector(7 downto 0);
      aPxiStarData : in std_logic;
      aPxieDstarB : in std_logic;
      aPxieDstarC : out std_logic;

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
      aDramReady : in std_logic;
      du0DramAddrFifoAddr : out std_logic_vector(29 downto 0);
      du0DramAddrFifoCmd : out std_logic_vector(2 downto 0);
      du0DramAddrFifoFull : in std_logic;
      du0DramAddrFifoWrEn : out std_logic;
      du0DramPhyInitDone : in std_logic;
      du0DramRdDataValid : in std_logic;
      du0DramRdFifoDataOut : in std_logic_vector(639 downto 0);
      du0DramWrFifoDataIn : out std_logic_vector(639 downto 0);
      du0DramWrFifoFull : in std_logic;
      du0DramWrFifoMaskData : out std_logic_vector(79 downto 0);
      du0DramWrFifoWrEn : out std_logic;
      du1DramAddrFifoAddr : out std_logic_vector(29 downto 0);
      du1DramAddrFifoCmd : out std_logic_vector(2 downto 0);
      du1DramAddrFifoFull : in std_logic;
      du1DramAddrFifoWrEn : out std_logic;
      du1DramPhyInitDone : in std_logic;
      du1DramRdDataValid : in std_logic;
      du1DramRdFifoDataOut : in std_logic_vector(639 downto 0);
      du1DramWrFifoDataIn : out std_logic_vector(639 downto 0);
      du1DramWrFifoFull : in std_logic;
      du1DramWrFifoMaskData : out std_logic_vector(79 downto 0);
      du1DramWrFifoWrEn : out std_logic;

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
      rBaseClksValid : in std_logic := '1';
      tDiagramActive : out std_logic;
      rDiagramReset : out std_logic;
      aDiagramReset : out std_logic;
      rDerivedClockLostLockError : out std_logic;
      rGatedBaseClksValid : in std_logic := '1';
      aSafeToEnableGatedClks : out std_logic
    );
  end component;

end package PkgTheWindowFlatWrapper;