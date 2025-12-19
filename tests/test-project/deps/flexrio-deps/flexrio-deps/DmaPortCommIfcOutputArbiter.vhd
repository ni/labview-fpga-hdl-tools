-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcOutputArbiter.vhd
-- Author: Florin Hurgoi
-- Original Project: LV FPGA Dma Port Communication Interface
-- Date: 06 September 2011
--
-------------------------------------------------------------------------------
-- (c) 2007 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   The NI DMA IP implements a single Output Request interface for all the requesters
--   in the application logic side needing access to the resource.
--   Each subsystem that will request access to the DMA channel will provide
--   the Space and Channel information creating an unique identifier that specify
--   the subsystem that the transaction belongs to. The Arbiter will give access to
--   Output Request Interface to each requester based on the Normal and Emergency requests
--   issued by each requester.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

  use work.PkgDmaPortCommIfcArbiter.all;

entity DmaPortCommIfcOutputArbiter is
  generic (

    -------------------------------------------------------------------------------------
    --The number of DMA IN that require register access.
    -------------------------------------------------------------------------------------
    kNumOfOutStrms : natural := 16
  );
  port (
    aReset               : in  boolean;
    BusClk               : in  std_logic;
    bReset               : in  boolean;

    -------------------------------------------------------------------------------------
    --arbitiration signals for DMA IN:
    -------------------------------------------------------------------------------------
    bOutStrmsAccNormalReq     : in  std_logic_vector(ArbVecMSB(kNumOfOutStrms) downto 0);
    bOutStrmsAccEmergencyReq  : in  std_logic_vector(ArbVecMSB(kNumOfOutStrms) downto 0);
    bOutStrmsAccDoneStrb      : in  boolean;
    bOutStrmsAccGrant         : out std_logic_vector(ArbVecMSB(kNumOfOutStrms) downto 0)
  );
end DmaPortCommIfcOutputArbiter;

architecture rtl of DmaPortCommIfcOutputArbiter is

  type ArbitrationState_t is (Idle, EmergencyAccess, NormalAccess);
  signal bArbitrationState : ArbitrationState_t := (Idle);

  --vhook_sigstart
  signal bOutStrmsAccGntEmergency: std_logic_vector(kNumOfOutStrms-1 downto 0);
  signal bOutStrmsAccGntNormal: std_logic_vector(kNumOfOutStrms-1 downto 0);
  signal bOutStrmsAccStrmDoneEmergency: boolean ;
  signal bOutStrmsAccStrmDoneNormal: boolean ;
  signal bOutStrmsEmergencyEnArb: boolean;
  signal bOutStrmsNormalEnArb: boolean;
  --vhook_sigend
  signal bOutStrmsAccNormalReqAssert, bOutStrmsAccEmergencyReqAssert: boolean;

begin

  bOutStrmsEmergencyEnArb <= (bArbitrationState = EmergencyAccess);
  bOutStrmsNormalEnArb <= (bArbitrationState = NormalAccess);

  LocalOutArbiter: Block
  begin
    ------------------------------
    --Case 1: No Out Streams
    ------------------------------
    --Grant should always be zero.
    NoOutStrm: if kNumOfOutStrms = 0 generate

      bOutStrmsAccEmergencyReqAssert <= false;
      bOutStrmsAccNormalReqAssert <= false;
      bOutStrmsAccGrant <= (others => '0');

      bOutStrmsAccStrmDoneEmergency <= false;
      bOutStrmsAccStrmDoneNormal <= false;
    end generate;

    ------------------------------
    --Case 2: 1 Out Streams
    ------------------------------
    --No Need for any arbiters because there is only one OUT stream. In this case we can
    --simply wrap the request to the grant. The wrap back is qualified by the state
    --machine to make sure that it is the IN streams turn when access is granted.

    OneOutStrm: if kNumOfOutStrms = 1 generate

      --Conversion from std_logic to boolean.
      bOutStrmsAccNormalReqAssert <= to_Boolean(OrVector(bOutStrmsAccNormalReq));
      bOutStrmsAccEmergencyReqAssert <= to_Boolean(OrVector(bOutStrmsAccEmergencyReq));

      --Grant access to the output streams whenever we enable the output stream arbiter.
      bOutStrmsAccGrant <= (others=>'1') when bOutStrmsEmergencyEnArb or bOutStrmsNormalEnArb
        else (others=>'0');
      bOutStrmsAccStrmDoneEmergency <= false;
      bOutStrmsAccStrmDoneNormal <= false;
    end generate;

    -------------------------------
    --Case 3: 2 or more Out Streams
    -------------------------------
    --There is only one arbiter here. The input requests to the arbiter is muxed
    --based on whether there is a high priority request pending or not.

    MultOutStrms: if kNumOfOutStrms > 1 generate

      bOutStrmsAccNormalReqAssert <= to_Boolean(OrVector(bOutStrmsAccNormalReq));
      bOutStrmsAccEmergencyReqAssert <= to_Boolean(OrVector(bOutStrmsAccEmergencyReq));
      bOutStrmsAccGrant <= bOutStrmsAccGntEmergency or bOutStrmsAccGntNormal;

      --vhook_e DmaPortStrmArbiterRoundRobin OutStrmsEmergencyArbiter
      --vhook_c kNumOfStrms kNumOfOutStrms
      --vhook_a SysClk BusClk
      --vhook_a sReset bReset
      --vhook_a sEnArb bOutStrmsEmergencyEnArb
      --vhook_c sAccReq bOutStrmsAccEmergencyReq
      --vhook_a sAccDoneStrb bOutStrmsAccDoneStrb
      --vhook_a sAccGnt bOutStrmsAccGntEmergency
      --vhook_a sStrmDone bOutStrmsAccStrmDoneEmergency
      OutStrmsEmergencyArbiter: entity work.DmaPortStrmArbiterRoundRobin (rtl)
        generic map (
          kNumOfStrms => kNumOfOutStrms)  -- in  positive := 64
        port map (
          aReset       => aReset,                         -- in  boolean
          SysClk       => BusClk,                         -- in  std_logic
          sReset       => bReset,                         -- in  boolean
          sAccReq      => bOutStrmsAccEmergencyReq,       -- in  std_logic_vector(kNumOfS
          sAccGnt      => bOutStrmsAccGntEmergency,       -- out std_logic_vector(kNumOfS
          sEnArb       => bOutStrmsEmergencyEnArb,        -- in  boolean
          sAccDoneStrb => bOutStrmsAccDoneStrb,           -- in  boolean
          sStrmDone    => bOutStrmsAccStrmDoneEmergency); -- out boolean 


      --vhook_e DmaPortStrmArbiterRoundRobin OutStrmsNormalArbiter
      --vhook_c kNumOfStrms kNumOfOutStrms
      --vhook_a SysClk BusClk
      --vhook_a sReset bReset
      --vhook_a sEnArb bOutStrmsNormalEnArb
      --vhook_c sAccReq bOutStrmsAccNormalReq
      --vhook_a sAccDoneStrb bOutStrmsAccDoneStrb
      --vhook_a sAccGnt bOutStrmsAccGntNormal
      --vhook_a sStrmDone bOutStrmsAccStrmDoneNormal
      OutStrmsNormalArbiter: entity work.DmaPortStrmArbiterRoundRobin (rtl)
        generic map (
          kNumOfStrms => kNumOfOutStrms)  -- in  positive := 64
        port map (
          aReset       => aReset,                      -- in  boolean
          SysClk       => BusClk,                      -- in  std_logic
          sReset       => bReset,                      -- in  boolean
          sAccReq      => bOutStrmsAccNormalReq,       -- in  std_logic_vector(kNumOfStrm
          sAccGnt      => bOutStrmsAccGntNormal,       -- out std_logic_vector(kNumOfStrm
          sEnArb       => bOutStrmsNormalEnArb,        -- in  boolean
          sAccDoneStrb => bOutStrmsAccDoneStrb,        -- in  boolean
          sStrmDone    => bOutStrmsAccStrmDoneNormal); -- out boolean 

    end generate;

  end block LocalOutArbiter;


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
            if bOutStrmsAccEmergencyReqAssert then
              bArbitrationState <= EmergencyAccess;
            elsif bOutStrmsAccNormalReqAssert then
              bArbitrationState <= NormalAccess;
            end if;

          when EmergencyAccess =>

            if bOutStrmsAccDoneStrb or bOutStrmsAccStrmDoneEmergency then
              bArbitrationState <= Idle;
            end if;

          when NormalAccess =>

            if bOutStrmsAccDoneStrb or bOutStrmsAccStrmDoneNormal then
              bArbitrationState <= Idle;
            end if;

        end case;

      end if;
    end if;
  end process StateMachineRegisters;

end rtl;
