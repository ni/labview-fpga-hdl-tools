# 
# This file was automatically processed for release on GitHub
# All comments were removed and this header was added
# 
# 
# Copyright (c) 2025 National Instruments Corporation
# 
# All rights reserved.
# 
# 

# Constraints for an Aurora 12 port, 4 lane implementation using GTY transievers

#vreview_group Ni7903AuroraStreamingConstraints
#vreview_closed http:
#vreview_closed http:
#vreview_reviewers kygreen dhearn amoch

set LineRateInGbs 28.0
set RefClkInGHz [expr 175.0/1000]

### MGT Refclk period expression: [expr 1/RefclkInGHz] ###
### This is needed to constrain the GT Wizard powergood delay circuit ###
create_clock -name MgtRefClk0 -period [expr 1/$RefClkInGHz] [get_ports MgtRefClk_p[0]]
create_clock -name MgtRefClk1 -period [expr 1/$RefClkInGHz] [get_ports MgtRefClk_p[1]]
create_clock -name MgtRefClk2 -period [expr 1/$RefClkInGHz] [get_ports MgtRefClk_p[2]]
create_clock -name MgtRefClk3 -period [expr 1/$RefClkInGHz] [get_ports MgtRefClk_p[3]]
create_clock -name MgtRefClk4 -period [expr 1/$RefClkInGHz] [get_ports MgtRefClk_p[4]]
create_clock -name MgtRefClk5 -period [expr 1/$RefClkInGHz] [get_ports MgtRefClk_p[5]]
create_clock -name MgtRefClk6 -period [expr 1/$RefClkInGHz] [get_ports MgtRefClk_p[6]]
create_clock -name MgtRefClk7 -period [expr 1/$RefClkInGHz] [get_ports MgtRefClk_p[7]]
create_clock -name MgtRefClk8 -period [expr 1/$RefClkInGHz] [get_ports MgtRefClk_p[8]]
create_clock -name MgtRefClk9 -period [expr 1/$RefClkInGHz] [get_ports MgtRefClk_p[9]]
create_clock -name MgtRefClk10 -period [expr 1/$RefClkInGHz] [get_ports MgtRefClk_p[10]]
create_clock -name MgtRefClk11 -period [expr 1/$RefClkInGHz] [get_ports MgtRefClk_p[11]]

############################### User clock constraints ##############################
### OUTCLK period expression: [expr INT_DATAWIDTH/LineRateInGbs] ###
### USERCLK2 period will be auto-derived thru BUFG_GT       ###
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]


create_clock -period [expr 64/$LineRateInGbs] -name port0_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port0_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port1_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port1_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port2_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port2_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port3_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port3_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port4_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port4_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port5_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port5_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port6_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port6_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port7_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port7_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port8_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port8_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port9_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port9_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port10_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port10_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port11_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port11_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]


########################### UltraScale Digital Monitor clock ###########################
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[0].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[1].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[2].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[3].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[4].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[5].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[6].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[7].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[8].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[9].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[10].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[11].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[12].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[13].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[14].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[15].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[16].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[17].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[18].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[19].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[20].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[21].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[22].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[23].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[24].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[25].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[26].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[27].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[28].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[29].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[30].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[31].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[32].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[33].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[34].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[35].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[36].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[37].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[38].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[39].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[40].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[41].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[42].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[43].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[44].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[45].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[46].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/GenGtwizDMonClk[47].DMonClk_bufg_instN/O}]

########################### False Paths - UltraScale GT Wizard ExDes ###########################
set_false_path -to [get_cells -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[*].Aurora_PortN/*bit_synchronizer*inst/i_in_meta_reg}]
set_false_path -to [get_cells -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[*].Aurora_PortN/*reset_synchronizer*inst/rst_in_*_reg}]
set_false_path -to [get_cells -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[*].Aurora_PortN/*gtwiz_userclk_tx_active_*_reg}]
set_false_path -to [get_cells -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[*].Aurora_PortN/*gtwiz_userclk_rx_active_*_reg}]

###########################       False Paths - Aurora Core          ###########################
set_false_path -to [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/*aurora64b66b_*_cdc_to*/D}]

##############################################################
####################### Port 0 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port0_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port0_txusrclk2"] -to $port0_TNM_TxResetDone_out -datapath_only 10.0

set port0_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port0_rxusrclk2"] -to $port0_TNM_RxResetDone_out -datapath_only 10.0

set port0_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port0_rxusrclk2"] -to $port0_TNM_RxPrbsLocked_out -datapath_only 10.0

set port0_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port0_TNM_lRxLpmEn -to $port0_TNM_rRxLpmEn -datapath_only 10.0

set port0_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port0_TNM_lRxHoldReg -to $port0_TNM_rRxHoldReg_ms -datapath_only 10.0

set port0_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port0_TNM_lRxOvrdReg -to $port0_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port0_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port0_TNM_lRxPolarityReg -to $port0_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port0_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port0_TNM_lTxPolarityReg -to $port0_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port0_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port0_TNM_PulseSync_iDlySigx -to $port0_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port0_TNM_PulseSync_oSigx    -to $port0_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port0_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port0_TNM_HandShake_iStoredData        -to $port0_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port0_TNM_HandShake_iPushToggle        -to $port0_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port0_TNM_HandShake_oPushToggleToReady -to $port0_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 1 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port1_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port1_txusrclk2"] -to $port1_TNM_TxResetDone_out -datapath_only 10.0

set port1_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port1_rxusrclk2"] -to $port1_TNM_RxResetDone_out -datapath_only 10.0

set port1_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port1_rxusrclk2"] -to $port1_TNM_RxPrbsLocked_out -datapath_only 10.0

set port1_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port1_TNM_lRxLpmEn -to $port1_TNM_rRxLpmEn -datapath_only 10.0

set port1_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port1_TNM_lRxHoldReg -to $port1_TNM_rRxHoldReg_ms -datapath_only 10.0

set port1_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port1_TNM_lRxOvrdReg -to $port1_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port1_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port1_TNM_lRxPolarityReg -to $port1_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port1_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port1_TNM_lTxPolarityReg -to $port1_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port1_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port1_TNM_PulseSync_iDlySigx -to $port1_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port1_TNM_PulseSync_oSigx    -to $port1_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port1_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port1_TNM_HandShake_iStoredData        -to $port1_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port1_TNM_HandShake_iPushToggle        -to $port1_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port1_TNM_HandShake_oPushToggleToReady -to $port1_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 2 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port2_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port2_txusrclk2"] -to $port2_TNM_TxResetDone_out -datapath_only 10.0

set port2_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port2_rxusrclk2"] -to $port2_TNM_RxResetDone_out -datapath_only 10.0

set port2_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port2_rxusrclk2"] -to $port2_TNM_RxPrbsLocked_out -datapath_only 10.0

set port2_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port2_TNM_lRxLpmEn -to $port2_TNM_rRxLpmEn -datapath_only 10.0

set port2_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port2_TNM_lRxHoldReg -to $port2_TNM_rRxHoldReg_ms -datapath_only 10.0

set port2_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port2_TNM_lRxOvrdReg -to $port2_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port2_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port2_TNM_lRxPolarityReg -to $port2_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port2_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port2_TNM_lTxPolarityReg -to $port2_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port2_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port2_TNM_PulseSync_iDlySigx -to $port2_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port2_TNM_PulseSync_oSigx    -to $port2_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port2_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port2_TNM_HandShake_iStoredData        -to $port2_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port2_TNM_HandShake_iPushToggle        -to $port2_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port2_TNM_HandShake_oPushToggleToReady -to $port2_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 3 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port3_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port3_txusrclk2"] -to $port3_TNM_TxResetDone_out -datapath_only 10.0

set port3_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port3_rxusrclk2"] -to $port3_TNM_RxResetDone_out -datapath_only 10.0

set port3_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port3_rxusrclk2"] -to $port3_TNM_RxPrbsLocked_out -datapath_only 10.0

set port3_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port3_TNM_lRxLpmEn -to $port3_TNM_rRxLpmEn -datapath_only 10.0

set port3_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port3_TNM_lRxHoldReg -to $port3_TNM_rRxHoldReg_ms -datapath_only 10.0

set port3_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port3_TNM_lRxOvrdReg -to $port3_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port3_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port3_TNM_lRxPolarityReg -to $port3_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port3_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port3_TNM_lTxPolarityReg -to $port3_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port3_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port3_TNM_PulseSync_iDlySigx -to $port3_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port3_TNM_PulseSync_oSigx    -to $port3_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port3_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port3_TNM_HandShake_iStoredData        -to $port3_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port3_TNM_HandShake_iPushToggle        -to $port3_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port3_TNM_HandShake_oPushToggleToReady -to $port3_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 4 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port4_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port4_txusrclk2"] -to $port4_TNM_TxResetDone_out -datapath_only 10.0

set port4_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port4_rxusrclk2"] -to $port4_TNM_RxResetDone_out -datapath_only 10.0

set port4_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port4_rxusrclk2"] -to $port4_TNM_RxPrbsLocked_out -datapath_only 10.0

set port4_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port4_TNM_lRxLpmEn -to $port4_TNM_rRxLpmEn -datapath_only 10.0

set port4_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port4_TNM_lRxHoldReg -to $port4_TNM_rRxHoldReg_ms -datapath_only 10.0

set port4_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port4_TNM_lRxOvrdReg -to $port4_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port4_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port4_TNM_lRxPolarityReg -to $port4_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port4_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port4_TNM_lTxPolarityReg -to $port4_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port4_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port4_TNM_PulseSync_iDlySigx -to $port4_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port4_TNM_PulseSync_oSigx    -to $port4_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port4_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port4_TNM_HandShake_iStoredData        -to $port4_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port4_TNM_HandShake_iPushToggle        -to $port4_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port4_TNM_HandShake_oPushToggleToReady -to $port4_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 5 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port5_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port5_txusrclk2"] -to $port5_TNM_TxResetDone_out -datapath_only 10.0

set port5_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port5_rxusrclk2"] -to $port5_TNM_RxResetDone_out -datapath_only 10.0

set port5_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port5_rxusrclk2"] -to $port5_TNM_RxPrbsLocked_out -datapath_only 10.0

set port5_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port5_TNM_lRxLpmEn -to $port5_TNM_rRxLpmEn -datapath_only 10.0

set port5_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port5_TNM_lRxHoldReg -to $port5_TNM_rRxHoldReg_ms -datapath_only 10.0

set port5_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port5_TNM_lRxOvrdReg -to $port5_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port5_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port5_TNM_lRxPolarityReg -to $port5_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port5_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port5_TNM_lTxPolarityReg -to $port5_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port5_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port5_TNM_PulseSync_iDlySigx -to $port5_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port5_TNM_PulseSync_oSigx    -to $port5_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port5_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port5_TNM_HandShake_iStoredData        -to $port5_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port5_TNM_HandShake_iPushToggle        -to $port5_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port5_TNM_HandShake_oPushToggleToReady -to $port5_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 6 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port6_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port6_txusrclk2"] -to $port6_TNM_TxResetDone_out -datapath_only 10.0

set port6_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port6_rxusrclk2"] -to $port6_TNM_RxResetDone_out -datapath_only 10.0

set port6_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port6_rxusrclk2"] -to $port6_TNM_RxPrbsLocked_out -datapath_only 10.0

set port6_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port6_TNM_lRxLpmEn -to $port6_TNM_rRxLpmEn -datapath_only 10.0

set port6_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port6_TNM_lRxHoldReg -to $port6_TNM_rRxHoldReg_ms -datapath_only 10.0

set port6_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port6_TNM_lRxOvrdReg -to $port6_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port6_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port6_TNM_lRxPolarityReg -to $port6_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port6_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port6_TNM_lTxPolarityReg -to $port6_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port6_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port6_TNM_PulseSync_iDlySigx -to $port6_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port6_TNM_PulseSync_oSigx    -to $port6_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port6_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port6_TNM_HandShake_iStoredData        -to $port6_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port6_TNM_HandShake_iPushToggle        -to $port6_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port6_TNM_HandShake_oPushToggleToReady -to $port6_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 7 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port7_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port7_txusrclk2"] -to $port7_TNM_TxResetDone_out -datapath_only 10.0

set port7_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port7_rxusrclk2"] -to $port7_TNM_RxResetDone_out -datapath_only 10.0

set port7_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port7_rxusrclk2"] -to $port7_TNM_RxPrbsLocked_out -datapath_only 10.0

set port7_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port7_TNM_lRxLpmEn -to $port7_TNM_rRxLpmEn -datapath_only 10.0

set port7_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port7_TNM_lRxHoldReg -to $port7_TNM_rRxHoldReg_ms -datapath_only 10.0

set port7_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port7_TNM_lRxOvrdReg -to $port7_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port7_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port7_TNM_lRxPolarityReg -to $port7_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port7_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port7_TNM_lTxPolarityReg -to $port7_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port7_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port7_TNM_PulseSync_iDlySigx -to $port7_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port7_TNM_PulseSync_oSigx    -to $port7_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port7_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port7_TNM_HandShake_iStoredData        -to $port7_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port7_TNM_HandShake_iPushToggle        -to $port7_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port7_TNM_HandShake_oPushToggleToReady -to $port7_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 8 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port8_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port8_txusrclk2"] -to $port8_TNM_TxResetDone_out -datapath_only 10.0

set port8_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port8_rxusrclk2"] -to $port8_TNM_RxResetDone_out -datapath_only 10.0

set port8_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port8_rxusrclk2"] -to $port8_TNM_RxPrbsLocked_out -datapath_only 10.0

set port8_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port8_TNM_lRxLpmEn -to $port8_TNM_rRxLpmEn -datapath_only 10.0

set port8_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port8_TNM_lRxHoldReg -to $port8_TNM_rRxHoldReg_ms -datapath_only 10.0

set port8_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port8_TNM_lRxOvrdReg -to $port8_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port8_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port8_TNM_lRxPolarityReg -to $port8_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port8_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port8_TNM_lTxPolarityReg -to $port8_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port8_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port8_TNM_PulseSync_iDlySigx -to $port8_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port8_TNM_PulseSync_oSigx    -to $port8_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port8_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port8_TNM_HandShake_iStoredData        -to $port8_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port8_TNM_HandShake_iPushToggle        -to $port8_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port8_TNM_HandShake_oPushToggleToReady -to $port8_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 9 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port9_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port9_txusrclk2"] -to $port9_TNM_TxResetDone_out -datapath_only 10.0

set port9_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port9_rxusrclk2"] -to $port9_TNM_RxResetDone_out -datapath_only 10.0

set port9_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port9_rxusrclk2"] -to $port9_TNM_RxPrbsLocked_out -datapath_only 10.0

set port9_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port9_TNM_lRxLpmEn -to $port9_TNM_rRxLpmEn -datapath_only 10.0

set port9_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port9_TNM_lRxHoldReg -to $port9_TNM_rRxHoldReg_ms -datapath_only 10.0

set port9_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port9_TNM_lRxOvrdReg -to $port9_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port9_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port9_TNM_lRxPolarityReg -to $port9_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port9_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port9_TNM_lTxPolarityReg -to $port9_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port9_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port9_TNM_PulseSync_iDlySigx -to $port9_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port9_TNM_PulseSync_oSigx    -to $port9_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port9_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port9_TNM_HandShake_iStoredData        -to $port9_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port9_TNM_HandShake_iPushToggle        -to $port9_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port9_TNM_HandShake_oPushToggleToReady -to $port9_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 10 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port10_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port10_txusrclk2"] -to $port10_TNM_TxResetDone_out -datapath_only 10.0

set port10_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port10_rxusrclk2"] -to $port10_TNM_RxResetDone_out -datapath_only 10.0

set port10_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port10_rxusrclk2"] -to $port10_TNM_RxPrbsLocked_out -datapath_only 10.0

set port10_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port10_TNM_lRxLpmEn -to $port10_TNM_rRxLpmEn -datapath_only 10.0

set port10_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port10_TNM_lRxHoldReg -to $port10_TNM_rRxHoldReg_ms -datapath_only 10.0

set port10_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port10_TNM_lRxOvrdReg -to $port10_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port10_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port10_TNM_lRxPolarityReg -to $port10_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port10_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port10_TNM_lTxPolarityReg -to $port10_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port10_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port10_TNM_PulseSync_iDlySigx -to $port10_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port10_TNM_PulseSync_oSigx    -to $port10_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port10_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port10_TNM_HandShake_iStoredData        -to $port10_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port10_TNM_HandShake_iPushToggle        -to $port10_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port10_TNM_HandShake_oPushToggleToReady -to $port10_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 11 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port11_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port11_txusrclk2"] -to $port11_TNM_TxResetDone_out -datapath_only 10.0

set port11_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port11_rxusrclk2"] -to $port11_TNM_RxResetDone_out -datapath_only 10.0

set port11_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port11_rxusrclk2"] -to $port11_TNM_RxPrbsLocked_out -datapath_only 10.0

set port11_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port11_TNM_lRxLpmEn -to $port11_TNM_rRxLpmEn -datapath_only 10.0

set port11_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port11_TNM_lRxHoldReg -to $port11_TNM_rRxHoldReg_ms -datapath_only 10.0

set port11_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port11_TNM_lRxOvrdReg -to $port11_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port11_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port11_TNM_lRxPolarityReg -to $port11_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port11_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port11_TNM_lTxPolarityReg -to $port11_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port11_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port11_TNM_PulseSync_iDlySigx -to $port11_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port11_TNM_PulseSync_oSigx    -to $port11_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port11_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port11_TNM_HandShake_iStoredData        -to $port11_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port11_TNM_HandShake_iPushToggle        -to $port11_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port11_TNM_HandShake_oPushToggleToReady -to $port11_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

