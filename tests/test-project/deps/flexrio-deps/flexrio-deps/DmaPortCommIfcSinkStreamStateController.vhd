-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcSinkStreamStateController.vhd
-- Author: Matthew Koenn
-- Original Project: LabVIEW FPGA
-- Date: 29 September 2008
--
-------------------------------------------------------------------------------
-- (c) 2008 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
--   The stream state controller is used to track and report the state of
-- the DMA stream.  It is also responsible for generating the reset FIFO signal
-- and disable signals for the stream.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
library work;
  use work.PkgNiUtilities.all;

  -- This package contains the definitions of the stream states and corresponding
  -- utilities.
  use work.PkgDmaPortCommIfcStreamStates.all;  
  
  -- This package contains the definitions for the LabVIEW FPGA register 
  -- framework signals 
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;
  
entity DmaPortCommIfcSinkStreamStateController is
  port (

    -- aReset      : This is the asynchronous reset signal.
    aReset         : in  boolean;
    
    -- bReset      : This is the synchronous reset signal.
    bReset         : in  boolean;
    
    -- BusClk      : This is the CHInCh transmit clock.
    BusClk         : in  std_logic;
    
    -------------------------------------------------------------------------------------
    -- Status and control output signals.
    -------------------------------------------------------------------------------------
    
    -- bState             : The current value of the stream state.
    bState                : out StreamStateValue_t;
    
    -- bReportDisabledToDiagram : This signal is true while the stream state is enabled
    --                            but the diagram should report disabled.  This would 
    --                            occur when the stream is disabling but has not yet
    --                            completely disabled, but the diagram should read
    --                            disabled to qualify underflows.
    bReportDisabledToDiagram    : out boolean;
    
    -- bDisable           : This is used to indicate that the stream is attempting to
    --                      disable.
    bDisable              : out boolean;
    
    -- bResetFifo         : The signal indicating that the DMA FIFO should reset.  The
    --                      FIFO is reset when the stream is enabled.
    bResetFifo            : out boolean;
    
    -- bSetEnableIrq      : This signal is strobed for one clock cycle whenever the 
    --                      enable IRQ is set.
    bSetEnableIrq         : out boolean;
    
    -- bClearEnableIrq    : This signal is strobed for one clock cycle whenever the 
    --                      enable IRQ should be cleared.
    bClearEnableIrq       : out boolean;
    
    -- bClearDisableIrq   : This signal is strobed for one clock cycle whenever the 
    --                      disable IRQ should be cleared.
    bClearDisableIrq      : out boolean;
    
    -- bDisabledStatusForHost : This is the disabled status bit readable by the host.
    --                          While the normal Disabled bit instructs the stream to
    --                          discard packets instead of pushing the data into the
    --                          FIFO, the host should not read disabled as true at 
    --                          this point since the source could still be sending data
    --                          to the sink.  The host readable disabled status is only
    --                          true once the done indicator from the source has been
    --                          received indicating that the stream is truly shut down.
    bDisabledStatusForHost    : out boolean;
    
    -------------------------------------------------------------------------------------
    -- State transition requests.
    -------------------------------------------------------------------------------------
    
    -- bHostEnable                  : The enable request from the host.  This is strobed
    --                                for one clock cycle for each request.
    bHostEnable                     : in boolean;
    
    -- bHostDisable                 : The disable request from the host.  This is strobed
    --                                for one clock cycle for each request.
    bHostDisable                    : in boolean;
    
    -- bStopChannelRequest          : The stop request from the user diagram.  This is
    --                                strobed for one clock cycle for each request.
    bStopChannelRequest             : in boolean;
    
    -- bStartChannelRequest         : The start request from the user diagram.  This is
    --                                strobed for one clock cycle for each request.
    bStartChannelRequest            : in boolean;
    
    -------------------------------------------------------------------------------------
    -- Status inputs.
    -------------------------------------------------------------------------------------
    
    -- bDisabled        : This signal indicates when the stream has actually finished
    --                    disabling.
    bDisabled           : in boolean;
    
    -- bLinked          : This signal indicates whether or not the stream is linked.
    bLinked             : in boolean;
    
    -- bResetDone       : This is a one clock cycle strobe that indicates when a FIFO
    --                    reset has completed.
    bResetDone          : in boolean;
    
    -- bStreamError     : This is a one clock cycle strobe indicating that an error 
    --                    has occurred and the stream should shut down.
    bStreamError        : in boolean;
    
    -- bStateInDefaultClkDomain : This is the value of the state as seen by the 
    --                            default clock domain.
    bStateInDefaultClkDomain    : in StreamStateValue_t

  );
end DmaPortCommIfcSinkStreamStateController;

architecture behavior of DmaPortCommIfcSinkStreamStateController is

  signal bStreamState, bStreamStateNx : StreamState_t;
  signal bEnableReg, bEnableRegNx : boolean;
  signal bStateEnableReg, bStateEnableRegNx : boolean;
  signal bDisableNx : boolean;
  signal bWaitOnFifoReset, bWaitOnFifoResetNx : boolean;
  signal bOutstandingEnableIrq : boolean;
  signal bDisableLoc : boolean := true;
begin

  bResetFifo <= bWaitOnFifoReset;
  bState <= to_StreamStateValue(bStreamState);
  bDisable <= bDisableLoc;
  
  -- Implement the registers associated with the state controller.
  StreamStateRegs: process(aReset, BusClk)
  begin
    
    if aReset then
    
      -- Reset to the unlinked state.
      bStreamState <= Unlinked;
      bEnableReg <= false;
      bStateEnableReg <= false;
      bDisableLoc <= true;
      bWaitOnFifoReset <= false;
    
    elsif rising_edge(BusClk) then
    
      if bReset then
      
        -- Reset to the unlinked state.
        bStreamState <= Unlinked;
        bEnableReg <= false;
        bStateEnableReg <= false;
        bDisableLoc <= true;
        bWaitOnFifoReset <= false;
      
      else
      
        bStreamState <= bStreamStateNx;
        bEnableReg <= bEnableRegNx;
        bStateEnableReg <= bStateEnableRegNx;
        bDisableLoc <= bDisableNx;
        bWaitOnFifoReset <= bWaitOnFifoResetNx;
      
      end if;
      
    end if;
    
  end process StreamStateRegs;


  -- !STATE MACHINE STARTUP!
  -- The state machine starts up safely because it resets to the Unlinked state and only
  -- moves out of the Unlinked state if the bLinked signal is true.  The bLinked signal
  -- resets to false with the same reset as the state machine, so it will always be 
  -- false coming out of reset.
  NextStreamState: process(bStreamState, bLinked, bDisabled, bStateEnableRegNx, 
                           bOutstandingEnableIrq, bEnableReg, bStateInDefaultClkDomain,
                           bStartChannelRequest)
  begin
  
    bStreamStateNx <= bStreamState;
    bSetEnableIrq <= false;
    bClearEnableIrq <= false;
    bClearDisableIrq <= false;
    bReportDisabledToDiagram <= false;
    
    case bStreamState is
    
      when Unlinked =>
        
        -- Move to the stopped state whenever we become linked.
        if bLinked then
          bStreamStateNx <= Disabled;
          
          -- If there is an outstanding enable request that has not yet been
          -- satisfied, set the enable IRQ when we become linked.  We cannot set the
          -- IRQ while we are unlinked or the driver will immediately clear it and
          -- ignore the request.
          bSetEnableIrq <= bOutstandingEnableIrq;
          
        end if;
      
      when Disabled =>
      
        -- Return to the unlinked state whenever we become unlinked.
        if not bLinked then
        
          bStreamStateNx <= Unlinked;
        
        -- Go to the started state if the controller indicates that it has enabled.  Also
        -- ensure that the state seen by the default clock domain is disabled.  If we
        -- transition states too quickly and the default clock domain does not see the
        -- transition, state transition methods in that clock domain could block
        -- indefinitely.
        elsif not bDisabled and bStateEnableRegNx and bStateInDefaultClkDomain = 
          to_StreamStateValue(Disabled) then
          
          bStreamStateNx <= Enabled;
        
        end if;
        
        -- Set the enable request IRQ if it arrives while in this state.
        bSetEnableIrq <= bStartChannelRequest;
        
        -- When we go to the disabled state, we need to clear the disable IRQ.  The 
        -- driver disables the disable IRQ right before it writes the stop stream bit, 
        -- and it enables the IRQ again right before it writes the start stream bit.
        -- The IRQ status holds the value even while the IRQ is disabled, so we don't
        -- want to report an old disable IRQ when we re-enable it, so we clear it when
        -- we become disabled.  We also need to check that we have disabled in the 
        -- default clock domain since a disable request could still occur from the 
        -- diagram until it reports disabled in this domain.
        if bStateInDefaultClkDomain = to_StreamStateValue(Disabled) then
          bClearDisableIrq <= true;
        end if;
      
      when Enabled =>
        
        -- Move to the stopped state if the DMA controller indicates that it is
        -- disabled.  Also ensure that the state seen by the default clock domain 
        -- is enabled.  If we transition states too quickly and the default clock
        -- domain does not see the transition, state transition methods in that 
        -- clock domain could block indefinitely.
        if bDisabled and not bStateEnableRegNx and bStateInDefaultClkDomain = 
          to_StreamStateValue(Enabled) then
          
          bStreamStateNx <= Disabled;
          
        end if;
        
        -- When we go to the enabled state, we need to clear the enable IRQ.  The driver
        -- disables the enable IRQ right before it writes the start stream bit, and it
        -- enables the IRQ again right before it writes the stop stream bit.  The IRQ
        -- status holds the value even while the IRQ is disabled, so we don't want to
        -- report an old enable IRQ when we re-enable it, so we clear it when we become
        -- enabled.  We also need to check that we have enabled in the default clock
        -- domain since an enable request could still occur from the diagram until it 
        -- reports enabled in this domain.
        if bStateInDefaultClkDomain = to_StreamStateValue(Enabled) then
          bClearEnableIrq <= true;
        end if;
        
        -- As soon as the host disables the stream, the stream state in the ViClk
        -- domain should report disabled immediately so that the stream does not
        -- report underflow while it is in the process of disabling.  However, the
        -- stream should not actually return to the disabled state until it is
        -- properly disabled.  Therefore, while we are enabled but waiting to disable,
        -- report disabled to the diagram.
        bReportDisabledToDiagram <= not bEnableReg;
      
      when others =>
      
        bStreamStateNx <= Unlinked;
      
    end case;
  
  end process NextStreamState;

  
  bDisableNx <= not bEnableRegNx;

  
  ---------------------------------------------------------------------------------------
  -- There are two separate signals here: the enable signal and the state enable signal.
  -- They operate similarly, except that the state enable bit is cleared when a host 
  -- write causes an disable, and the enable bit is clear when either the host or the
  -- diagram causes a disable.  The state enable bit is used to transition the stream
  -- state, whereas the enable bit is used to enable the DMA controller circuit.  The
  -- need for these two bits comes from the requirement that the sink stream begins to
  -- discard data immediately following a diagram disable, but that the stream state
  -- won't transition to disabled until the host write occurs to disable the stream.
  --
  -- There is also a WaitOnFifoReset signal, which indicates when the state is trying
  -- to enable but must reset the FIFO first.  The host enable only triggers the
  -- WaitOnFifoReset, and the actual enable signal is set when the FIFO is done
  -- clearing.
  ---------------------------------------------------------------------------------------
  SetEnableStatus: process(bHostDisable, bStopChannelRequest, bLinked, bEnableReg, 
                           bHostEnable, bStateEnableReg, bWaitOnFifoReset, bResetDone,
                           bStreamError)
  begin
  
    bEnableRegNx <= bEnableReg;
    bStateEnableRegNx <= bStateEnableReg;
    bWaitOnFifoResetNx <= bWaitOnFifoReset;
    
    -- If disable is being set, then clear the disable output.  If enable
    -- and disable bits are both set simultaneously, give priority to
    -- disable.
    if bHostDisable or bStopChannelRequest or bStreamError or not bLinked then
    
      bEnableRegNx <= false;
      bWaitOnFifoResetNx <= false;
    
      -- The state transition to Disabled should only occur when the host disables.
      if bHostDisable or not bLinked then
        bStateEnableRegNx <= false;
      end if;
      
    elsif bHostEnable then
      
      -- Begin waiting on the FIFO to reset when the enable signal is received.
      bWaitOnFifoResetNx <= true;
    
    elsif bWaitOnFifoReset and bResetDone then
    
      -- Enable the stream once the FIFO has been cleared.
      bEnableRegNx <= true;
      bStateEnableRegNx <= true;
      bWaitOnFifoResetNx <= false;
      
    end if;
  
  end process SetEnableStatus;
 
  
  -- Track when we have an enable request that has not yet been satisfied.
  TrackOutstandingEnableIrq: process(aReset, BusClk)
  begin
    if aReset then
      bOutstandingEnableIrq <= false;
    elsif rising_edge(BusClk) then
      if bReset then
        bOutstandingEnableIrq <= false;
      else
      
        -- Clear the OutstandingEnableIrq whenever the Enabled state has been
        -- reached, since the enable has been satisfied.
        if bStreamState = Enabled then
          bOutstandingEnableIrq <= false;
          
        -- Set the OutstandingEnableIrq whenever a start channel request is first
        -- received.
        elsif bStartChannelRequest then
          bOutstandingEnableIrq <= true;
        
        end if;
        
      end if;
    end if;
  end process TrackOutstandingEnableIrq;
 
  
  -- Qualify the disabled status read by the host with the state not being in the enabled
  -- state.  The bDisabled bit will get set to true when a disable happens following a
  -- diagram stop but before the stop bit is received from the host.  We don't want the
  -- host to read the disabled status as true until it is both disabled and the host has
  -- written the stop bit to allow the state to transition to disabled.
  bDisabledStatusForHost <= bDisabled and bStreamState /= Enabled;

end behavior;