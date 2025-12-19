-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcInputArbiter.vhd
-- Author: Florin Hurgoi, Claudiu Chirap
-- Original Project: LV FPGA Dma Port Communication Interface
-- Date: 15 June 2011
--
-------------------------------------------------------------------------------
-- (c) 2007 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   The NI DMA IP implements a single Input Request interface for all the requesters
--   in the application logic side needing access to the resource.
--   Each subsystem that will request access to the DMA channel will provide
--   the Space and Channel information creating an unique identifier that specify
--   the subsystem that the transaction belongs to. The Arbiter will give access to
--   Input Request Interface to each requester based on the Normal and Emergency requests
--   issued by each requester.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

  use work.PkgDmaPortCommIfcArbiter.all;

entity DmaPortCommIfcInputArbiter is
  generic (

    -------------------------------------------------------------------------------------
    -- The number of DMA IN that require register access.
    -------------------------------------------------------------------------------------
    kNumOfInStrms : natural := 64
  );
  port (
    aReset               : in  boolean;
    BusClk               : in  std_logic;
    bReset               : in  boolean;

    -------------------------------------------------------------------------------------
    -- arbitiration signals for DMA IN:
    -------------------------------------------------------------------------------------
    bInStrmsAccNormalReq     : in  std_logic_vector(ArbVecMSB(kNumOfInStrms) downto 0);
    bInStrmsAccEmergencyReq  : in  std_logic_vector(ArbVecMSB(kNumOfInStrms) downto 0);
    bInStrmsAccDoneStrb      : in  boolean;
    bInStrmsAccGrant         : out std_logic_vector(ArbVecMSB(kNumOfInStrms) downto 0)
    );

end DmaPortCommIfcInputArbiter;

architecture rtl of DmaPortCommIfcInputArbiter is

  type ArbitrationState_t is (Idle, EmergencyAccess, NormalAccess);
  signal bArbitrationState : ArbitrationState_t := (Idle);

  --vhook_sigstart
  signal bInStrmsAccGntEmergency: std_logic_vector(kNumOfInStrms-1 downto 0);
  signal bInStrmsAccGntNormal: std_logic_vector(kNumOfInStrms-1 downto 0);
  signal bInStrmsAccStrmDoneEmergency: boolean ;
  signal bInStrmsAccStrmDoneNormal: boolean ;
  signal bInStrmsEmergencyEnArb: boolean;
  signal bInStrmsNormalEnArb: boolean;
  --vhook_sigend
  signal bInStrmsAccNormalReqAssert, bInStrmsAccEmergencyReqAssert: boolean;

begin

  ---------------------------------------------------------------------------------------
  --Block for stream IN arbiter. There are three cases that need to be covered for the
  --arbiter. All these cases are explained below.
  ---------------------------------------------------------------------------------------
  LocalInArbiter: Block
  begin
    -----------------------
    --Case 1: No In Streams
    -----------------------
    --Grant should always be zero.
    NoInStrm: if kNumOfInStrms = 0 generate

      bInStrmsAccEmergencyReqAssert <= false;
      bInStrmsAccNormalReqAssert <= false;

      bInStrmsAccGrant <= (others => '0');
      bInStrmsAccStrmDoneEmergency <= false;
      bInStrmsAccStrmDoneNormal <= false;
    end generate;

    ----------------------
    --Case 2: 1 In Streams
    ----------------------
    --No Need for any arbiters because there is only one IN stream. In this case we can
    --simply wrap the request to the grant. The wrap back is qualified by the state
    --machine to make sure that it is the IN streams turn when access is granted.

    OneInStrm: if kNumOfInStrms = 1 generate

      --Conversion from std_logic to boolean.
      bInStrmsAccEmergencyReqAssert <= to_Boolean(OrVector(bInStrmsAccEmergencyReq));
      bInStrmsAccNormalReqAssert <= to_Boolean(OrVector(bInStrmsAccNormalReq));

      --Grant access to the stream whenever we enable the stream arbiter
      bInStrmsAccGrant <= (others=>'1') when bInStrmsEmergencyEnArb or bInStrmsNormalEnArb
        else (others=>'0');
      bInStrmsAccStrmDoneEmergency <= false;
      bInStrmsAccStrmDoneNormal <= false;
    end generate;

    ------------------------------
    --Case 3: 2 or more In Streams
    ------------------------------
    --There is only one arbiter here. The input requests to the arbiter is muxed
    --based on whether there is a high priority request pending or not.

    MultInStrms: if kNumOfInStrms > 1 generate

      bInStrmsAccEmergencyReqAssert <= to_Boolean(OrVector(bInStrmsAccEmergencyReq));
      bInStrmsAccNormalReqAssert <= to_Boolean(OrVector(bInStrmsAccNormalReq));
      bInStrmsAccGrant <= bInStrmsAccGntEmergency or bInStrmsAccGntNormal;

      --vhook_e DmaPortStrmArbiterRoundRobin InStrmsEmergencyArbiter
      --vhook_c kNumOfStrms kNumOfInStrms
      --vhook_a SysClk BusClk
      --vhook_a sReset bReset
      --vhook_a sEnArb bInStrmsEmergencyEnArb
      --vhook_c sAccReq bInStrmsAccEmergencyReq
      --vhook_a sAccDoneStrb bInStrmsAccDoneStrb
      --vhook_a sAccGnt bInStrmsAccGntEmergency
      --vhook_a sStrmDone bInStrmsAccStrmDoneEmergency
      InStrmsEmergencyArbiter: entity work.DmaPortStrmArbiterRoundRobin (rtl)
        generic map (
          kNumOfStrms => kNumOfInStrms)  -- in  positive := 16
        port map (
          aReset       => aReset,                        -- in  boolean
          SysClk       => BusClk,                        -- in  std_logic
          sReset       => bReset,                        -- in  boolean
          sAccReq      => bInStrmsAccEmergencyReq,       -- in  std_logic_vector(kNumOfSt
          sAccGnt      => bInStrmsAccGntEmergency,       -- out std_logic_vector(kNumOfSt
          sEnArb       => bInStrmsEmergencyEnArb,        -- in  boolean
          sAccDoneStrb => bInStrmsAccDoneStrb,           -- in  boolean
          sStrmDone    => bInStrmsAccStrmDoneEmergency); -- out boolean 


      --vhook_e DmaPortStrmArbiterRoundRobin InStrmsNormalArbiter
      --vhook_c kNumOfStrms kNumOfInStrms
      --vhook_a SysClk BusClk
      --vhook_a sReset bReset
      --vhook_a sEnArb bInStrmsNormalEnArb
      --vhook_c sAccReq bInStrmsAccNormalReq
      --vhook_a sAccDoneStrb bInStrmsAccDoneStrb
      --vhook_a sAccGnt bInStrmsAccGntNormal
      --vhook_a sStrmDone bInStrmsAccStrmDoneNormal
      InStrmsNormalArbiter: entity work.DmaPortStrmArbiterRoundRobin (rtl)
        generic map (
          kNumOfStrms => kNumOfInStrms)  -- in  positive := 16
        port map (
          aReset       => aReset,                     -- in  boolean
          SysClk       => BusClk,                     -- in  std_logic
          sReset       => bReset,                     -- in  boolean
          sAccReq      => bInStrmsAccNormalReq,       -- in  std_logic_vector(kNumOfStrms
          sAccGnt      => bInStrmsAccGntNormal,       -- out std_logic_vector(kNumOfStrms
          sEnArb       => bInStrmsNormalEnArb,        -- in  boolean
          sAccDoneStrb => bInStrmsAccDoneStrb,        -- in  boolean
          sStrmDone    => bInStrmsAccStrmDoneNormal); -- out boolean 

    end generate;

  end block LocalInArbiter;

  bInStrmsEmergencyEnArb <= (bArbitrationState = EmergencyAccess);
  bInStrmsNormalEnArb <= (bArbitrationState = NormalAccess);

  StateMachineRegisters: process(aReset, BusClk)
  begin
    if aReset then
      bArbitrationState <= Idle;

    elsif rising_edge(BusClk) then
      if bReset then
        bArbitrationState <= Idle;

      else

        case bArbitrationState is
          when Idle =>
            if bInStrmsAccEmergencyReqAssert then
              bArbitrationState <= EmergencyAccess;
            elsif bInStrmsAccNormalReqAssert then
              bArbitrationState <= NormalAccess;
            end if;

          when EmergencyAccess =>

            if bInStrmsAccDoneStrb or bInStrmsAccStrmDoneEmergency then
              bArbitrationState <= Idle;
            end if;

          when NormalAccess =>

            if bInStrmsAccDoneStrb or bInStrmsAccStrmDoneNormal then
              bArbitrationState <= Idle;
            end if;

        end case;

      end if;
    end if;
  end process StateMachineRegisters;

end rtl;
