------------------------------------------------------------------------------------------
--
-- File: DmaPortStrmArbiterRoundRobin.vhd
-- Author: Rolando Ortega
-- Original Project: The Macallan (Next FlexRIO)
-- Date: 19 September 2016
--
------------------------------------------------------------------------------------------
-- (c) 2016 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
------------------------------------------------------------------------------------------
--
-- Purpose:
--
-- The module is designed to provide arbitration between multiple units requesting access
-- to a common resource. If a unit needs the resource it must assert its request and hold
-- it asserted at least until the same clock cycle in which Grant appears.
--
-- The Grant signal is kept asserted by the arbiter until it sees the Done signal strobed
-- by the requester.
--
-- After the grant is given, the resource is set free by strobing done (kept up for 1
-- cycle), after which the arbiter will give access to the next request. This arbiter will
-- never try to give Grant to another channel before it has received the Done for the last
-- request that got a grant.
--
-----------------------------------------------------------------------------------------
-- Theory of Operation:
-----------------------------------------------------------------------------------------
--
-- Objectives:
-- This module implements a "fair" arbiter. There is much discussion about the "fairness"
-- of arbiters. See, for example, here: https://en.wikipedia.org/wiki/Fair_queuing, and
-- here: https://en.wikipedia.org/wiki/Round-robin_scheduling. This arbiter strives to
-- achieve the following two objectives:
--
-- 1. For an arbiter with n requesters, a given requester may have to wait until all other
--    n-1 requesters have been serviced, but will never have to wait more than that. This
--    puts a maximum (and equal) bound on all requester's service time of
--    n*IndividualServeTime.
--
-- 2. On average, all requesters will be allocated whichever is LESS of:
--    a) However much bandwidth they request.
--    b) An approximately equal share of the total available bandwidth.
--
-- #2 is true because round-robin scheduling is said to have "max-min fairness"
-- (https://en.wikipedia.org/wiki/Max-min_fairness) when all packets are the same size,
-- which is true for the DmaPort during steady-state streaming. There are boundary
-- conditions in which some packets are smaller than the maximum, but that doesn't really
-- affect this analysis.
--
-- Round-robin Concept
--
-- A round-robin arbiter is effectively a priority encoder with a rotating priority, which
-- is determined by which requester was serviced last. So in a 4-stream arbiter, if the
-- last stream that was serviced was #2, the arbiter looks like a priority encoder with
-- maximum priority given to steam #3, then stream #0 (wrap around), then stream #1, and
-- then stream #2. This LSB-to-MSB priority rotates as different streams get serviced, so
-- that priority is always given to stream mod(i+1, n), where i is the last stream that
-- was serviced and n is the number of streams.
--
-- To achieve this in an efficient manner, this module utilizes a mask. This mask has 0s
-- for all the bits in the request vector "vec" between index 0 and the index i that was
-- last granted. In other words:
--
--  mask <= (i downto 0 => '0', others <= '1');
--
-- In order to determine the next grantee, the request vector gets duplicated, one of the
-- copies is AND'd with the mask, and a priority encoder is applied to the resulting (2*n
-- wide) vector. E.g. Assume we have a request vector defined as (4 downto 0) with the
-- value "11010". Further assume that the last grant was "00100", and therefore the
-- current mask is "11000". We would have the following combined vector:
--
--  Request vector:     ┌── 11010
--            Mask:     ˇ   11000
--    Pre-Priority:   11010 11000
--           Grant:          ^     3
--
-- We thus achieve the rotating priority by appending the unmasked request vector to the
-- left of the masked one. Let's continue working through this example:
--
--      Bit Index:   43210           43210                  4321043210
-- -------------------------------------------------------------------------------
-- Request Vector:   10010     Mask: 10000    Pre-priority: 1001010000    Grant: 4
--                                                               ^
--                   00010           00000                  0001000000    Grant: 1
--                                                             ^
-- Assume we get some more requests:
--                   11001           11100                  1100111000    Grant: 3
--                                                                ^
--                   10011           10000                  1001110000    Grant: 4
--                                                               ^
--                   00011           00000                  0001100000    Grant: 0
--                                                              ^
--                   01010           11110                  0101001010    Grant: 1
--                                                                  ^
--                   01010           11100                  0101001000    Grant: 3
--                                                                ^
--                   00010           10000                  0001000000    Grant: 1
--
-- The overall effect is that of a rotating priority. The bits that would "naturally" be
-- given priority in a straight priority encoder are blocked by the mask, but they remain
-- eligible to be selected if none of the bits to their left in the request vector are
-- '1's. Concatenating the un-masked vector to the masked one achieves the rotation.
--
-- Implementation Details:
--
-- In order to save resources and improve timing, some optimizations are made to the above
-- concept.
--
-- 1. Instead of concatenating the masked and unmasked request vectors, we multiplex them.
--    Observe above that the unmasked version of the vector is only ever relevant if the
--    masked vector is all '0's. So if the masked vector is all '0's we apply the priority
--    encoder to the unmasked vector, and otherwise we apply it to the masked vector. In
--    this way, we only need a priority encoder of length n instead of n*2.
--
-- 2. Rather than create the mask directly, we create a shifted version of it. We call
--    this a "thermometer", which is simply a string of 1's that grows from left to right.
--    The rightmost '1' in the thermometer lands on the bit that was granted. We do this
--    because it fulfills two purposes:
--
--    a) It's a shifted (to the right) version of the mask, so we can generate the mask
--    with a left shift without incurring any additional logic.
--
--    b) When this thermometer is XOR'd with a shifted-left version of itself, it outputs
--    our grant vector. Thus, this thermometer simultaneously creates our mask *and*
--    implements our priority encoder.
--
-- Additionally, we know that the request vector will be valid for two clock cycles before
-- we are expected to generate a grant. This allows us to pipeline the above process for
-- further timing improvements.
--
-----------------------------------------------------------------------------------------
-- Ports and Generics:
-----------------------------------------------------------------------------------------
--
-- kNumOfStrms: The number of streams that are competing to access a resource
--
-- aReset: Asynchronous reset.
--
-- SysClk: System clock.
--
-- sReset: Synchronous reset.
--
-- sAccReq: The request vector where each bit represents the request of a stream
--
-- sAccGnt: The request grant for an associated stream which is kept asserted until the
--          Done
--
-- sEnArb: Enables the arbiter by setting the grant value.
--
-- sAccDoneStrb: The Done strobe which should mark the stream as done
--
-- sStrmDone: This signal indicates when the arbiter has finished an arbitration which
--            does not result into a Grant (if the Request deasserted one clock cycle
--            before the Grant should have asserted i.e. the requestor changed its mind
--            over the Request assertion). WE DO NOT CONSIDER THIS VALID! And therefore we
--            don't drive this bit.
--
-----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

entity DmaPortStrmArbiterRoundRobin is

  generic (
    kNumOfStrms : positive := 16);

  port (
    aReset        : in  boolean;
    SysClk        : in  std_logic;
    sReset        : in  boolean;
    -- Input and Output vectors
    sAccReq       : in  std_logic_vector(kNumOfStrms-1 downto 0);
    sAccGnt       : out std_logic_vector(kNumOfStrms-1 downto 0);
    -- Control
    sEnArb        : in  boolean;
    sAccDoneStrb  : in  boolean;
    sStrmDone     : out boolean
    );

end entity DmaPortStrmArbiterRoundRobin;

architecture rtl of DmaPortStrmArbiterRoundRobin is

  subtype ArbVector_t is std_logic_vector(kNumOfStrms-1 downto 0);

  -- Mask and masked vector
  signal sMask, sMaskedVector : ArbVector_t := (others => '1');

  -- Intermediate values
  signal sNxTherm, sTherm : ArbVector_t := (others => '0');
  signal sPrePriority     : ArbVector_t := (others => '0');

  -- This signal tells us when we're holding the grant (waiting for done).
  signal sHoldingGrant : boolean := false;

  -- This signal lets us select between the masked vector and the unmasked vector.
  signal sSelectMask : boolean := false;

  -- This function creates a "thermometer" whereby a given output bit, retVal(j) will be
  -- set iff some input bit vec(i) is set, where j >= i.
  function Thermometer (
    vec : ArbVector_t)
    return ArbVector_t
  is
    variable retVal : ArbVector_t := (others => '0');
  begin  -- function Thermometer
    for i in retVal'range loop
      retVal(i) := OrVector(vec(i downto 0));
    end loop;  -- i

    return retVal;
  end function Thermometer;

  function GrantFromTherm (
    thermometer : ArbVector_t)
    return ArbVector_t
  is
    variable shiftTherm : ArbVector_t;
  begin  -- function GrantFromTherm

    -- To derive the one-hot grant vector from the thermometer, we just need to XOR the
    -- thermometer with a shifted-left (towards the MSB) version of itself. We will shift
    -- in a '0' on the right-most bit (LSB).
    --
    -- Note that the thermometer is "monotonic": it has a '1' on the highest-priority bit
    -- and in all bits to the left of it. All bits to the right (if any) are '0's.
    -- Furthermore, there is at least one bit that is set to '1', because the arbiter is
    -- only enabled when at least one bit in the request vector is '1'.
    --
    -- The shifted-left version (shiftTherm) is also monotonic: there's only one
    -- "transition" point between '1's and '0's. Thus, when we XOR them together, there
    -- will be one and only one bit asserted in the result, with its index corresponding
    -- to the highest-priority bit that we're looking for.
    shiftTherm := thermometer(thermometer'high-1 downto 0) & '0';
    return ArbVector_t'(thermometer xor shiftTherm);

  end function GrantFromTherm;

begin  -- architecture rtl

  -- We can create our mask using a version of the stored thermometer. The thermometer is
  -- true for the bit we just assigned and all bits to the left of it. If we shift to the
  -- left by one, it'll be false for all bits from 0 up to and including the most recent
  -- grant. We can use this as a mask for the incoming vector. Note that this implies that
  -- the mask's LSB is always a 0. That's ok: the case where we will select Stream 0 is
  -- when the mask is all-0s, not when it's all-1s (see Theory of Operation above for an
  -- example of this).
  sMask         <= sTherm(sTherm'high-1 downto 0) & '0';
  sMaskedVector <= sMask and sAccReq;

  -- We want to use the masked vector whenever possible. However, if we are enabled and
  -- there's no valid request in the masked vector, we'll give the requests in the
  -- un-masked vector a chance.
  sSelectMask <= to_Boolean(OrVector(sMaskedVector));

  Pipeline : process (SysClk, aReset)
  begin  -- process Pipeline
    if aReset then
      sPrePriority <= (others => '0');
    elsif rising_edge(SysClk) then
      if sReset then
        sPrePriority <= (others => '0');
      else
        -- In the case where none of the un-masked streams are requesting, we will give a
        -- chance to one of the masked ones. Combining both the masked and un-masked
        -- vector in this way gives us the vector from which to decide who to grant to.
        --
        -- Because this mux winds up in the critical path of the Grant calculation, we're
        -- effectively pipelining. This may cause us to miss some requests that may have
        -- been valid when enabled but not a clock cycle before. That's ok, because those
        -- requests weren't the ones that led the Arbiter to be enabled in the first
        -- place, and we'll get to them eventually.
        if sSelectMask then
          sPrePriority <= sMaskedVector;
        else
          sPrePriority <= sAccReq;
        end if;
      end if;
    end if;
  end process Pipeline;

  -- We can derive both the mask AND the priority encoding from the Thermometer, so we
  -- start by generating said thermometer.
  sNxTherm <= Thermometer(sPrePriority);

  FFs : process (SysClk, aReset)
  begin  -- process FFs
    if aReset then
      sTherm        <= (others => '0');
      sHoldingGrant <= false;
    elsif rising_edge(SysClk) then

      if sReset then
        sTherm        <= (others => '0');
        sHoldingGrant <= false;
      else
        -- Do not update the last grant unless enabled. Also, don't update it if we're
        -- holding the output. And once we do update it, start holding the output.
        if sEnArb and not sHoldingGrant then
          sTherm        <= sNxTherm;
          sHoldingGrant <= true;
        end if;

        -- We want to stop holding the grant whenever we're disabled, but we can do that
        -- faster if we look at the DoneStrb and save a clock cycle. We leave both
        -- conditions here in case sEnArb goes away without us seeing the Done strobe for
        -- some reason.
        if sAccDoneStrb or not sEnArb then
          sHoldingGrant <= false;
        end if;

      end if;

    end if;
  end process FFs;

  -- We generate our grant from the latched thermometer, which contributes to the
  -- pipelining efforts to keep the critical path short by pushing this part of the logic
  -- to after the sTherm FFs.
  --
  -- Although we *are* creating a combinatorial path coming out of this module, it's not a
  -- bad one: each bit depends only on two bits from the thermometer and the sHoldingGrant
  -- bit. And there was a combinational path there anyway, because we "OR" the grants from
  -- both the Normal and Emergency arbiters outside of this module.
  --
  -- Note that although the grant itself is one-hot, the output of this module is
  -- zero-one-hot, since the module will revert to an output of all '0's once the grant
  -- has been acknowledged by the grantee.
  sAccGnt <= GrantFromTherm(sTherm) when sHoldingGrant else (others => '0');

  --synthesis translate_off

  -- We want to put in a (simulation) check to make sure that we never have a case where
  -- we grant to a requester that rescinded (removed) its request. We'll actually check
  -- for a stronger condition, which is that no request is allowed to be rescinded during
  -- the clock cycle that it takes the arbiter to output a grant.

  CheckForRescindedRequests : block is
    signal sReqBeforeEnable : ArbVector_t := (others => '0');
  begin  -- block CheckForRescindedRequests
    Delays : process (SysClk, aReset)
    begin  -- process Delays
      if aReset then
        sReqBeforeEnable <= (others => '0');
      elsif rising_edge(SysClk) then

        -- This old request value will keep being updated until the arbiter is enabled, so
        -- it'll retain the last value of the request before the enable came.
        if not sEnArb then
          sReqBeforeEnable <= sAccReq;
        end if;

        -- This is the moment when the grant gets latched, so it's also the moment when we
        -- make our check.
        if sEnArb and not sHoldingGrant then
          for i in sReqBeforeEnable'range loop
            -- For each requester, if the request was asserted before, it should still be
            -- asserted now.
            if sReqBeforeEnable(i) = '1' then
              assert sAccReq(i) = '1'
                report "Stream # " & integer'image(i) &
                " illegally rescinded its request during the Arbiter's enable period."
                severity warning;
            end if;
          end loop;  -- i
        end if;
      end if;
    end process Delays;

  end block CheckForRescindedRequests;
  --synthesis translate_on

  -- Because we don't allow requests to be rescinded, we never have a need to assert the
  -- "a request was rescinded" flag:
  sStrmDone <= false;

end architecture rtl;
