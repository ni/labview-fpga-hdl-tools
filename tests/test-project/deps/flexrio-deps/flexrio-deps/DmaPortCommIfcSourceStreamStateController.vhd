-------------------------------------------------------------------------------
--
-- File: DmaPortCommIfcSourceStreamStateController.vhd
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
-- the DMA stream.  It is also responsible for generating the flush IRQ strobe
-- and disable signals for the stream and the DMA controller.
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
  
entity DmaPortCommIfcSourceStreamStateController is

  port (

    -- aReset      : This is the asynchronous reset signal.
    aReset         : in  boolean;
    
    -- bReset      : This is the synchronous reset signal.
    bReset         : in  boolean;
    
    -- BusClk      : This is the Dma Port clock.
    BusClk         : in  std_logic;
    
    -------------------------------------------------------------------------------------
    -- Status and control output signals.
    -------------------------------------------------------------------------------------
    
    -- bState                     : The current value of the stream state.
    bState                        : out StreamStateValue_t;
    
    -- bDisable                   : This is used to indicate that the stream is
    --                              attempting to disable.
    bDisable                      : out boolean;
    
    -- bDisableController         : This is used to indicate that the DMA controller 
    --                              should shut down.  This differs from the bDisable 
    --                              signal in that when the stream is flushing, the 
    --                              controller will continue to run, even though the 
    --                              stream is disabling.
    bDisableController            : out boolean := true;
    
    -- bFlushIrqStrobe            : This signal is strobed for one clock cycle when the 
    --                              flushing state is entered.  This is used to interrupt
    --                              the driver to notify of this event.
    bFlushIrqStrobe               : out boolean;
    
    -- bSetEnableIrq              : This signal is strobed for one clock cycle whenever 
    --                              the enable IRQ should be set.
    bSetEnableIrq                 : out boolean;
    
    -- bClearEnableIrq            : This signal is strobed for one clock cycle whenever 
    --                              the enable IRQ should be cleared.
    bClearEnableIrq               : out boolean;
    
    -- bClearFlushingIrq          : This signal is strobed for one clock cycle whenever 
    --                              the flushing IRQ should be cleared.
    bClearFlushingIrq             : out boolean;
    
    -- bSetFlushingStatus         : This signal is strobed for one clock cycle whenever
    --                              the flushing status bit should be set.
    bSetFlushingStatus            : out boolean;
    
    -- bClearFlushingStatus       : This signal is strobed for one clock cycle whenever
    --                              the flushing status bit should be cleared.
    bClearFlushingStatus          : out boolean;
    
    -- bSetFlushingFailedStatus   : This signal is strobed for one clock cycle whenever
    --                              the flushing failed status bit should be set.
    bSetFlushingFailedStatus      : out boolean;
    
    -- bClearFlushingFailedStatus : This signal is strobed for one clock cycle whenever
    --                              the flushing failed status bit should be cleared.
    bClearFlushingFailedStatus    : out boolean;
    
    -------------------------------------------------------------------------------------
    -- State transition requests.
    -------------------------------------------------------------------------------------
    
    -- bHostEnable                  : The enable request from the host.  This is strobed
    --                                for one clock cycle for each request.
    bHostEnable                     : in boolean;
    
    -- bHostDisable                 : The disable request from the host.  This is strobed
    --                                for one clock cycle for each request.
    bHostDisable                    : in boolean;
    
    -- bHostFlush                   : The flush request from the host.  This is strobed
    --                                for one clock cycle for each request.
    bHostFlush                      : in boolean;
    
    -- bStartChannelRequest         : The start channel request from the diagram.  This
    --                                is strobed for one clock cycle.
    bStartChannelRequest            : in boolean;
    
    -- bStopChannelRequest          : The stop request from the user diagram.  This is
    --                                strobed for one clock cycle for each request.
    bStopChannelRequest             : in boolean;
    
    -- bStopChannelWithFlushRequest : The flush request from the user diagram.  This is
    --                                strobed for one clock cycle for each request.
    bStopChannelWithFlushRequest    : in boolean;
    
    -------------------------------------------------------------------------------------
    -- Status inputs.
    -------------------------------------------------------------------------------------
    
    -- bDisabled        : This signal indicates when the stream has actually finished
    --                    disabling.
    bDisabled           : in boolean;
    
    -- bLinked          : This signal indicates whether or not the stream is linked.
    bLinked             : in boolean;
    
    -- bSatcrWriteEvent : This signal strobes for one clock cycle every time a write to
    --                    the SATCR register occurs.
    bSatcrWriteEvent    : in boolean;
    
    -- bFifoFullCount   : This is the current value of the FIFO full count.
    bFifoFullCount      : in unsigned;
    
    -- bWritesDisabled  : This status bit indicates when writes from the VI diagram
    --                    are disabled.  This is used when flushing to know that
    --                    there is no more data that has been pushed in the FIFO but
    --                    has not yet crossed the clock domain.  When WritesDisabled is
    --                    true, the FIFO count can no longer change as the result of
    --                    a write.
    bWritesDisabled     : in boolean;
    
    -- bStateInDefaultClkDomain : This is the value of the state as seen by the 
    --                            default clock domain.
    bStateInDefaultClkDomain    : in StreamStateValue_t

  );
end DmaPortCommIfcSourceStreamStateController;

architecture behavior of DmaPortCommIfcSourceStreamStateController is

  signal bStreamState, bStreamStateNx : StreamState_t;
  signal bEnableReg, bEnableRegNx : boolean;
  signal bEnableRequestReg, bEnableRequestRegNx : boolean;
  signal bFlushReg, bFlushRegNx : boolean;
  signal bFlushIrqStrobeNx : boolean;
  signal bResetFirstSatcrWriteTracker : boolean;
  signal bSatcrWriteReceived : boolean;
  signal bDisableControllerNx : boolean;
  signal bFifoEmpty : boolean;
  signal bSafeToDisableController, bSafeToEnableController : boolean;
  signal bOutstandingEnableIrq : boolean;

begin

  -- Implement the registers associated with the state controller.
  StreamStateRegs: process(aReset, BusClk)
  begin
    
    if aReset then
    
      -- Reset to the unlinked state.
      bStreamState <= Unlinked;
      bState <= kStreamStateUnlinked;
      bEnableReg <= false;
      bEnableRequestReg <= false;
      bFlushReg <= false;
      bFlushIrqStrobe <= false;
      bDisableController <= true;
    
    elsif rising_edge(BusClk) then
    
      if bReset then
      
        -- Reset to the unlinked state.
        bStreamState <= Unlinked;
        bState <= kStreamStateUnlinked;
        bEnableReg <= false;
        bEnableRequestReg <= false;
        bFlushReg <= false;
        bFlushIrqStrobe <= false;
        bDisableController <= true;
      
      else
      
        bStreamState <= bStreamStateNx;
        bEnableReg <= bEnableRegNx;
        bEnableRequestReg <= bEnableRequestRegNx;
        bFlushReg <= bFlushRegNx;
        bFlushIrqStrobe <= bFlushIrqStrobeNx;
        bDisableController <= bDisableControllerNx;
        bState <= to_StreamStateValue(bStreamStateNx);
        
      end if;
      
    end if;
    
  end process StreamStateRegs;


  -------------------------------------------------------------------------------------
  -- Safely Enabling/Disabling the DMA Controller
  --
  -- Enabling/disabling the controller depends on bWritesDisabled.  bWritesDisabled
  -- will get set to false when the stream is in the Enabled state and will get set
  -- to true for any other state.  However, this has to cross clock domains, so
  -- bWritesDisabled will always lag the stream state change.  When we're switching
  -- in and out of the Enabled state, we always want to make sure we stay Enabled
  -- until we receive acknowledgement that bWritesDisabled went false and stay
  -- Disabled until we receive acknowledgement that bWritesDisabled went true.  
  -- Note that if bEnableReg is true but the state never transitioned to Enabled, then
  -- bWritesDisabled will never go false.  We should still allow disabling in this
  -- case, and this is safe because bWritesDisable will never go true.  This is used
  -- to ensure that the final FIFO count has made it across the clock domain.
  --
  -- Additionally, state transition methods in the default clock domain (enable stream,
  -- disables stream, and disable and flush stream) will block until the state they
  -- are waiting on is seen in the default clock domain.  Therefore, to prevent these
  -- methods from blocking indefinitely and possibly missing a state transition, it's
  -- necessary to poll the value of the state in the default clock domain to ensure
  -- that it has transitioned before allowing the controller to perform the 
  -- corresponding operation.
  -------------------------------------------------------------------------------------


  -- !STATE MACHINE STARTUP!
  -- The state machine starts up safely because it resets to the Unlinked state and only
  -- moves out of the Unlinked state if the bLinked signal is true.  The bLinked signal
  -- resets to false with the same reset as the state machine, so it will always be 
  -- false coming out of reset.
  NextStreamState: process(bStreamState, bLinked, bDisabled, bSatcrWriteReceived, 
                           bEnableRegNx, bOutstandingEnableIrq, bWritesDisabled,
                           bStateInDefaultClkDomain, bStartChannelRequest)
  begin
  
    bStreamStateNx <= bStreamState;
    bResetFirstSatcrWriteTracker <= false;
    bClearEnableIrq <= false;
    bClearFlushingIrq <= false;
    bSetEnableIrq <= false;
    bSafeToEnableController <= false;
    bSafeToDisableController <= false;
  
    case bStreamState is
    
      when Unlinked =>
        
        -- Move to the stopped state whenever we become linked.
        if bLinked then
          bStreamStateNx <= Disabled;
          
          -- If there is an outstanding enable request that has not yet been
          -- satisfied, set the enable IRQ when we become linked.  We cannot set the
          -- IRQ while we are unlinked or the driver will immediately clear it and
          -- ignore the request.
          bSetEnableIrq <= bOutstandingEnableIrq or bStartChannelRequest;
          
        end if;
        
        -- It is only safe to enable if the bWritesDelayed signal has propogated from
        -- the FIFO clock domain and the state in the default clock domain has seen
        -- either the disabled or unlinked state.
        bSafeToEnableController <= bWritesDisabled and 
          (bStateInDefaultClkDomain = to_StreamStateValue(Disabled) or 
          bStateInDefaultClkDomain = to_StreamStateValue(Unlinked));
        
        -- It is always safe to disable while in the Unlinked state.
        bSafeToDisableController <= true;
      
      when Disabled =>
      
        -- Return to the unlinked state whenever we become unlinked.
        if not bLinked then
          bStreamStateNx <= Unlinked;
        
        -- Go to the started state if the controller indicates that it has enabled
        -- and the first SATCR write has been received.
        elsif not bDisabled and bSatcrWriteReceived and bEnableRegNx and
          bStateInDefaultClkDomain = to_StreamStateValue(Disabled) then
          
          bStreamStateNx <= Enabled;
        
        end if;
        
        -- When we go to the disabled state, we need to clear the flushing IRQ.  The 
        -- driver disables the flushing IRQ right before it writes the stop stream bit,
        -- and it enables the IRQ again right before it writes the start stream bit.  
        -- The IRQ status holds the value even while the IRQ is disabled, so we don't 
        -- want to report an old flushing IRQ when we re-enable it, so we clear it when
        -- we become enabled.  We also need to check that we have disabled in the 
        -- default clock domain since a flushing request could still occur from the 
        -- diagram until it reports disabled in this domain.
        if bStateInDefaultClkDomain = to_StreamStateValue(Disabled) then
          bClearFlushingIrq <= true;
        end if;
        
        -- Set the enable request IRQ if it arrives while in this state.
        bSetEnableIrq <= bStartChannelRequest;
        
        -- It is safe to enable while in the disabled state if the writes are disabled
        -- in the FIFO clock domain and the state in the default clock domain is also
        -- disabled.
        bSafeToEnableController <= bWritesDisabled and 
          (bStateInDefaultClkDomain = to_StreamStateValue(Disabled) or 
          bStateInDefaultClkDomain = to_StreamStateValue(Unlinked));
        
        -- It is always safe to disable the controller if the stream is disabled.
        bSafeToDisableController <= true;
      
      when Enabled =>
        
        -- Move to the stopped state if the DMA controller indicates that it is
        -- disabled.
        if bDisabled and bStateInDefaultClkDomain = to_StreamStateValue(Enabled) then
        
          bStreamStateNx <= Disabled;
          
          -- Reset the bit that tracks whether the first SATCR write has been received
          -- whenever there is a transition to the disabled state from a running
          -- state.
          bResetFirstSatcrWriteTracker <= true;
          
        -- If the disable request is active but the DMA controller has not yet
        -- disabled, then move to the flushing state.
        elsif not bEnableRegNx and bStateInDefaultClkDomain =
          to_StreamStateValue(Enabled) then
          
          bStreamStateNx <= Flushing;
        
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
        
        -- The controller should always be enabled while in the Enabled state.
        bSafeToEnableController <= true;
        
        -- It is only safe to disable the controller here if writes are enabled in the
        -- FIFO clock domain and the state in the default clock domain sees Enabled or
        -- Flushing.
        bSafeToDisableController <= not bWritesDisabled and (bStateInDefaultClkDomain =
          to_StreamStateValue(Enabled) or bStateInDefaultClkDomain = 
          to_StreamStateValue(Flushing));
      
      when Flushing =>
      
        -- Hold in the flushing state until the DMA controller indicates that it is
        -- disabled.
        if bDisabled then
        
          bStreamStateNx <= Disabled;
          
          -- Reset the bit that tracks whether the first SATCR write has been received
          -- whenever there is a transition to the disabled state from a running
          -- state.
          bResetFirstSatcrWriteTracker <= true;
          
          -- If there is an outstanding enable request that has not yet been
          -- satisfied, set the enable IRQ when we move back to Disabled.  If the
          -- enable was requested during a flush, we need to make sure that we
          -- set the enable IRQ.
          bSetEnableIrq <= bOutstandingEnableIrq or bStartChannelRequest;
          
        end if;
        
        -- The controller should always be enabled while we're in the flushing state.
        bSafeToEnableController <= true;
        
        -- It is only safe to disable the controller here if writes are enabled in the
        -- FIFO clock domain and the state in the default clock domain sees Enabled or
        -- Flushing.
        bSafeToDisableController <= not bWritesDisabled and (bStateInDefaultClkDomain = 
          to_StreamStateValue(Enabled) or bStateInDefaultClkDomain = 
          to_StreamStateValue(Flushing));
      
      when others =>
      
        bStreamStateNx <= Unlinked;
      
    end case;
  
  end process NextStreamState;
  
  
  bDisable <= not bEnableReg;
  
  -- Disable the DMA controller when either 
  --   (1) The state machine is disabling without flush OR
  --   (2) The state machine is disabling with flush and the flush is complete and there
  --       are no more points in the FIFO that have not yet crossed the clock domain.
  bDisableControllerNx <= (not bEnableRegNx and not bFlushRegNx) or (not bEnableRegNx
                          and bFlushRegNx and bFifoEmpty and bWritesDisabled);
  bFifoEmpty <= bFifoFullCount = 0;
  
  
  SetEnableStatus: process(bHostDisable, bStopChannelRequest, bHostFlush, 
                           bLinked, bStopChannelWithFlushRequest, bEnableRequestReg,
                           bFlushReg, bEnableReg, bEnableRequestRegNx, bWritesDisabled,
                           bSatcrWriteReceived,  bHostEnable, bSafeToEnableController,
                           bSafeToDisableController, bFifoEmpty, bDisabled)
  begin
  
    bFlushIrqStrobeNx <= false;
    bEnableRegNx <= bEnableReg;
    bEnableRequestRegNx <= bEnableRequestReg;
    bFlushRegNx <= bFlushReg;
    
    bSetFlushingStatus <= false;
    bClearFlushingStatus <= false;
    bSetFlushingFailedStatus <= false;
    bClearFlushingFailedStatus <= false;
    
    -- If disable is being set, then clear the disable output.  If enable
    -- and disable bits are both set simultaneously, give priority to
    -- disable.  Set the flushing bit accordingly, but give priority to a stop
    -- without flush.  If a stop is already in progress, do not allow the flush bit
    -- to get set, since a stop with flush should never overwrite a stop.  Also
    -- initiate a stop if we become unlinked.
    if bHostDisable or bStopChannelRequest or not bLinked then
    
      bEnableRequestRegNx <= false;
      bFlushRegNx <= false;
      
      -- If we were flushing and the flushing had not complete, set the flushing
      -- failed status.  A flushing has not yet finished if the bFlushReg is set
      -- but the FIFO is not yet empty.  However, to cover the case where a flush
      -- completed but data made it into the FIFO and another disable request was
      -- received, we also check to make sure the bDisabled signal is false.  If
      -- we were already disabled, there would be no need to set the flushing
      -- failed status.
      if bFlushReg and not (bFifoEmpty and bWritesDisabled) and not bDisabled then
        bSetFlushingFailedStatus <= true;
      end if;
      
    -- If disable with flush is set from the host or the target, then set the enable
    -- register with the flush signal.  This is qualified with the enable register
    -- being true because the flush bit should not get set to true if the stream
    -- is already stopping without a flush.  
    elsif (bHostFlush or bStopChannelWithFlushRequest) and bEnableReg then
    
      bEnableRequestRegNx <= false;
      bFlushRegNx <= true;
      
      -- Set flushing status whenever a flush begins.
      bSetFlushingStatus <= true;
      
      -- Set the flushing IRQ if the diagram requests a disable with flush.
      if bStopChannelWithFlushRequest then
        bFlushIrqStrobeNx <= true;
      end if;
    
    -- Set the enable bit to true if the host initiates a start.  
    elsif bHostEnable then
    
      bEnableRequestRegNx <= true;
      
      -- Clear the flushing status bits whenever a new enable occurs.
      bClearFlushingStatus <= true;
      bClearFlushingFailedStatus <= true;
      
      -- Clear the flushing register bit so that we can know on the next access
      -- whether or not the disable was a flush.
      bFlushRegNx <= false;
      
    end if;
    
    
    -- If the controller is already being enabled, we can set it to false when there
    -- is no longer an enable request and it is safe to disable it. 
    if bEnableReg then
      bEnableRegNx <= bEnableRequestRegNx or not bSafeToDisableController;
      
    -- If the controller is not being enabled, we can only enable it when we have a
    -- request to enable it and it is safe to do so.
    elsif not bEnableReg then
      bEnableRegNx <= bEnableRequestRegNx and bSafeToEnableController;
    end if;
  
  end process SetEnableStatus;
  
  
  -- This process keeps track of whether or not the first SATCR write has occurred.  
  -- The tracker must be reset whenever the state transitions from a running state
  -- to a stopped state.  
  TrackSatcrWriteEvent: process(aReset, BusClk)
  begin
    if aReset then
      bSatcrWriteReceived <= false;
    elsif rising_edge(BusClk) then
      if bReset then
        bSatcrWriteReceived <= false;
      else
        if bResetFirstSatcrWriteTracker then
          bSatcrWriteReceived <= false;
        elsif bSatcrWriteEvent then
          bSatcrWriteReceived <= true;
        end if;
      end if;
    end if;
  end process TrackSatcrWriteEvent;
  
  
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

end behavior;