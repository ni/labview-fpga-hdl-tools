
###################################################################################
##
##
##
###################################################################################
## Start add from file DramConstraints.xdc

###################################################################################
##
##
##
###################################################################################
## Start add from file SasquatchBank0Dram.xdc
# DRAM Clock creation
# The DRAM Reference Clock is 133.33 MHz for now
create_clock -name DramRefClk0 -period 7.5 [get_ports Dram0RefClk_p]

# Treat Vivado schizophrenia by manually locking MMCM and BUFG to the correct bank where DRAM refclk is located
#set_property LOC MMCM_X0Y5   [get_cells SasquatchDramx/GenBank0.Bank0Dram/Bank0Dram/ddr4_0x/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst]
set_property CLOCK_DEDICATED_ROUTE SAME_CMT_COLUMN [get_nets {SasquatchDramx/GenBank0.Bank0Dram/Bank0Dram/DramRefClk}]

#set_property DONT_TOUCH TRUE [get_cells SasquatchDramx/GenBank0.Bank0Dram/Bank0Dram/ddr4_0x/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst]
#set_property DONT_TOUCH TRUE [get_nets  SasquatchDramx/GenBank0.Bank0Dram/Bank0Dram/DramRefClkPin]
#set_property CLOCK_REGION X2Y5 [get_cells -hier -filter {NAME =~ SasquatchDramx/GenBank0.Bank0Dram/Bank0Dram/DramRefClkBufg}]

set_property IS_LOC_FIXED 0 [get_cells {SasquatchDramx/GenBank0.Bank0Dram/Bank0Dram/ddr4_0x/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst}]
set_property LOC {} [get_cells {SasquatchDramx/GenBank0.Bank0Dram/Bank0Dram/ddr4_0x/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst}]

# Pins

set_property PACKAGE_PIN N16 [get_ports dr0DramAct_n]
set_property PACKAGE_PIN P13 [get_ports {dr0DramAddr[0]}]
set_property PACKAGE_PIN P16 [get_ports {dr0DramAddr[10]}]
set_property PACKAGE_PIN K16 [get_ports {dr0DramAddr[11]}]
set_property PACKAGE_PIN M16 [get_ports {dr0DramAddr[12]}]
set_property PACKAGE_PIN R15 [get_ports {dr0DramAddr[13]}]
set_property PACKAGE_PIN D14 [get_ports {dr0DramAddr[14]}]
set_property PACKAGE_PIN J13 [get_ports {dr0DramAddr[15]}]
set_property PACKAGE_PIN H13 [get_ports {dr0DramAddr[16]}]
set_property PACKAGE_PIN L13 [get_ports {dr0DramAddr[1]}]
set_property PACKAGE_PIN P14 [get_ports {dr0DramAddr[2]}]
set_property PACKAGE_PIN M14 [get_ports {dr0DramAddr[3]}]
set_property PACKAGE_PIN P15 [get_ports {dr0DramAddr[4]}]
set_property PACKAGE_PIN N14 [get_ports {dr0DramAddr[5]}]
set_property PACKAGE_PIN H16 [get_ports {dr0DramAddr[6]}]
set_property PACKAGE_PIN R16 [get_ports {dr0DramAddr[7]}]
set_property PACKAGE_PIN K15 [get_ports {dr0DramAddr[8]}]
set_property PACKAGE_PIN N13 [get_ports {dr0DramAddr[9]}]
set_property PACKAGE_PIN H17 [get_ports {dr0DramBankAddr[0]}]
set_property PACKAGE_PIN K13 [get_ports {dr0DramBankAddr[1]}]
set_property PACKAGE_PIN F14 [get_ports {dr0DramBg[0]}]
set_property PACKAGE_PIN J16 [get_ports {Dram0Clk_p}]
set_property PACKAGE_PIN J15 [get_ports {Dram0Clk_n}]
set_property PACKAGE_PIN C13 [get_ports {dr0DramClkEn}]
set_property PACKAGE_PIN L15 [get_ports {dr0DramCs_n}]
set_property PACKAGE_PIN G14 [get_ports {dr0DramDmDbi_n[0]}]
set_property PACKAGE_PIN D13 [get_ports {dr0DramDmDbi_n[1]}]
set_property PACKAGE_PIN N17 [get_ports {dr0DramDmDbi_n[2]}]
set_property PACKAGE_PIN L17 [get_ports {dr0DramDmDbi_n[3]}]
set_property PACKAGE_PIN H19 [get_ports {dr0DramDmDbi_n[4]}]
set_property PACKAGE_PIN D19 [get_ports {dr0DramDmDbi_n[5]}]
set_property PACKAGE_PIN R21 [get_ports {dr0DramDmDbi_n[6]}]
set_property PACKAGE_PIN L25 [get_ports {dr0DramDmDbi_n[7]}]
set_property PACKAGE_PIN G25 [get_ports {dr0DramDmDbi_n[8]}]
set_property PACKAGE_PIN C22 [get_ports {dr0DramDmDbi_n[9]}]
set_property PACKAGE_PIN E13 [get_ports {dr0DramDq[0]}]
set_property PACKAGE_PIN A13 [get_ports {dr0DramDq[10]}]
set_property PACKAGE_PIN A17 [get_ports {dr0DramDq[11]}]
set_property PACKAGE_PIN B14 [get_ports {dr0DramDq[12]}]
set_property PACKAGE_PIN B16 [get_ports {dr0DramDq[13]}]
set_property PACKAGE_PIN C14 [get_ports {dr0DramDq[14]}]
set_property PACKAGE_PIN B17 [get_ports {dr0DramDq[15]}]
set_property PACKAGE_PIN P18 [get_ports {dr0DramDq[16]}]
set_property PACKAGE_PIN M19 [get_ports {dr0DramDq[17]}]
set_property PACKAGE_PIN N18 [get_ports {dr0DramDq[18]}]
set_property PACKAGE_PIN M20 [get_ports {dr0DramDq[19]}]
set_property PACKAGE_PIN D15 [get_ports {dr0DramDq[1]}]
set_property PACKAGE_PIN P20 [get_ports {dr0DramDq[20]}]
set_property PACKAGE_PIN N21 [get_ports {dr0DramDq[21]}]
set_property PACKAGE_PIN R20 [get_ports {dr0DramDq[22]}]
set_property PACKAGE_PIN M21 [get_ports {dr0DramDq[23]}]
set_property PACKAGE_PIN L20 [get_ports {dr0DramDq[24]}]
set_property PACKAGE_PIN J20 [get_ports {dr0DramDq[25]}]
set_property PACKAGE_PIN L18 [get_ports {dr0DramDq[26]}]
set_property PACKAGE_PIN J18 [get_ports {dr0DramDq[27]}]
set_property PACKAGE_PIN L19 [get_ports {dr0DramDq[28]}]
set_property PACKAGE_PIN K20 [get_ports {dr0DramDq[29]}]
set_property PACKAGE_PIN F15 [get_ports {dr0DramDq[2]}]
set_property PACKAGE_PIN K18 [get_ports {dr0DramDq[30]}]
set_property PACKAGE_PIN J19 [get_ports {dr0DramDq[31]}]
set_property PACKAGE_PIN F17 [get_ports {dr0DramDq[32]}]
set_property PACKAGE_PIN F20 [get_ports {dr0DramDq[33]}]
set_property PACKAGE_PIN F19 [get_ports {dr0DramDq[34]}]
set_property PACKAGE_PIN E21 [get_ports {dr0DramDq[35]}]
set_property PACKAGE_PIN F18 [get_ports {dr0DramDq[36]}]
set_property PACKAGE_PIN G19 [get_ports {dr0DramDq[37]}]
set_property PACKAGE_PIN E20 [get_ports {dr0DramDq[38]}]
set_property PACKAGE_PIN G20 [get_ports {dr0DramDq[39]}]
set_property PACKAGE_PIN D16 [get_ports {dr0DramDq[3]}]
set_property PACKAGE_PIN A20 [get_ports {dr0DramDq[40]}]
set_property PACKAGE_PIN B21 [get_ports {dr0DramDq[41]}]
set_property PACKAGE_PIN B20 [get_ports {dr0DramDq[42]}]
set_property PACKAGE_PIN D20 [get_ports {dr0DramDq[43]}]
set_property PACKAGE_PIN B19 [get_ports {dr0DramDq[44]}]
set_property PACKAGE_PIN C21 [get_ports {dr0DramDq[45]}]
set_property PACKAGE_PIN A19 [get_ports {dr0DramDq[46]}]
set_property PACKAGE_PIN D21 [get_ports {dr0DramDq[47]}]
set_property PACKAGE_PIN N23 [get_ports {dr0DramDq[48]}]
set_property PACKAGE_PIN P25 [get_ports {dr0DramDq[49]}]
set_property PACKAGE_PIN F13 [get_ports {dr0DramDq[4]}]
set_property PACKAGE_PIN M25 [get_ports {dr0DramDq[50]}]
set_property PACKAGE_PIN R25 [get_ports {dr0DramDq[51]}]
set_property PACKAGE_PIN N22 [get_ports {dr0DramDq[52]}]
set_property PACKAGE_PIN P23 [get_ports {dr0DramDq[53]}]
set_property PACKAGE_PIN M24 [get_ports {dr0DramDq[54]}]
set_property PACKAGE_PIN M22 [get_ports {dr0DramDq[55]}]
set_property PACKAGE_PIN J24 [get_ports {dr0DramDq[56]}]
set_property PACKAGE_PIN K22 [get_ports {dr0DramDq[57]}]
set_property PACKAGE_PIN J23 [get_ports {dr0DramDq[58]}]
set_property PACKAGE_PIN K23 [get_ports {dr0DramDq[59]}]
set_property PACKAGE_PIN E16 [get_ports {dr0DramDq[5]}]
set_property PACKAGE_PIN H23 [get_ports {dr0DramDq[60]}]
set_property PACKAGE_PIN L23 [get_ports {dr0DramDq[61]}]
set_property PACKAGE_PIN H24 [get_ports {dr0DramDq[62]}]
set_property PACKAGE_PIN L22 [get_ports {dr0DramDq[63]}]
set_property PACKAGE_PIN G22 [get_ports {dr0DramDq[64]}]
set_property PACKAGE_PIN D24 [get_ports {dr0DramDq[65]}]
set_property PACKAGE_PIN F22 [get_ports {dr0DramDq[66]}]
set_property PACKAGE_PIN D23 [get_ports {dr0DramDq[67]}]
set_property PACKAGE_PIN F24 [get_ports {dr0DramDq[68]}]
set_property PACKAGE_PIN E25 [get_ports {dr0DramDq[69]}]
set_property PACKAGE_PIN G15 [get_ports {dr0DramDq[6]}]
set_property PACKAGE_PIN F23 [get_ports {dr0DramDq[70]}]
set_property PACKAGE_PIN D25 [get_ports {dr0DramDq[71]}]
set_property PACKAGE_PIN A24 [get_ports {dr0DramDq[72]}]
set_property PACKAGE_PIN A25 [get_ports {dr0DramDq[73]}]
set_property PACKAGE_PIN B24 [get_ports {dr0DramDq[74]}]
set_property PACKAGE_PIN B26 [get_ports {dr0DramDq[75]}]
set_property PACKAGE_PIN C23 [get_ports {dr0DramDq[76]}]
set_property PACKAGE_PIN B25 [get_ports {dr0DramDq[77]}]
set_property PACKAGE_PIN C24 [get_ports {dr0DramDq[78]}]
set_property PACKAGE_PIN C26 [get_ports {dr0DramDq[79]}]
set_property PACKAGE_PIN E15 [get_ports {dr0DramDq[7]}]
set_property PACKAGE_PIN A14 [get_ports {dr0DramDq[8]}]
set_property PACKAGE_PIN C16 [get_ports {dr0DramDq[9]}]
set_property PACKAGE_PIN G17 [get_ports {dr0DramDqs_p[0]}]
set_property PACKAGE_PIN G16 [get_ports {dr0DramDqs_n[0]}]
set_property PACKAGE_PIN B15 [get_ports {dr0DramDqs_p[1]}]
set_property PACKAGE_PIN A15 [get_ports {dr0DramDqs_n[1]}]
set_property PACKAGE_PIN P19 [get_ports {dr0DramDqs_p[2]}]
set_property PACKAGE_PIN N19 [get_ports {dr0DramDqs_n[2]}]
set_property PACKAGE_PIN J21 [get_ports {dr0DramDqs_p[3]}]
set_property PACKAGE_PIN H21 [get_ports {dr0DramDqs_n[3]}]
set_property PACKAGE_PIN E18 [get_ports {dr0DramDqs_p[4]}]
set_property PACKAGE_PIN E17 [get_ports {dr0DramDqs_n[4]}]
set_property PACKAGE_PIN D18 [get_ports {dr0DramDqs_p[5]}]
set_property PACKAGE_PIN C18 [get_ports {dr0DramDqs_n[5]}]
set_property PACKAGE_PIN P24 [get_ports {dr0DramDqs_p[6]}]
set_property PACKAGE_PIN N24 [get_ports {dr0DramDqs_n[6]}]
set_property PACKAGE_PIN K25 [get_ports {dr0DramDqs_p[7]}]
set_property PACKAGE_PIN J25 [get_ports {dr0DramDqs_n[7]}]
set_property PACKAGE_PIN E23 [get_ports {dr0DramDqs_p[8]}]
set_property PACKAGE_PIN E22 [get_ports {dr0DramDqs_n[8]}]
set_property PACKAGE_PIN A23 [get_ports {dr0DramDqs_p[9]}]
set_property PACKAGE_PIN A22 [get_ports {dr0DramDqs_n[9]}]
set_property PACKAGE_PIN L14 [get_ports {dr0DramOdt}]
set_property PACKAGE_PIN F25 [get_ports dr0DramReset_n]
set_property PACKAGE_PIN J14 [get_ports Dram0RefClk_p]
set_property PACKAGE_PIN H14 [get_ports Dram0RefClk_n]

set_property PACKAGE_PIN H22    [get_ports dr0DramTestMode          ]

######################################################
# Pin Properties
######################################################
## IO Standards
set_property IOSTANDARD DIFF_POD12_DCI  [get_ports {dr0DramDqs_?[*]}]
set_property IOSTANDARD DIFF_SSTL12_DCI [get_ports Dram0Clk_?]
set_property IOSTANDARD LVCMOS12        [get_ports dr0DramReset_n]
set_property DRIVE      8               [get_ports dr0DramReset_n]
set_property IOSTANDARD POD12_DCI       [get_ports {dr0DramDmDbi_n[*]}]
set_property IOSTANDARD POD12_DCI       [get_ports {dr0DramDq[*]}]
set_property IOSTANDARD SSTL12_DCI      [get_ports dr0DramAct_n]
set_property IOSTANDARD SSTL12_DCI      [get_ports {dr0DramAddr[*]}]
set_property IOSTANDARD SSTL12_DCI      [get_ports {dr0DramBankAddr[*]}]
set_property IOSTANDARD SSTL12_DCI      [get_ports {dr0DramBg[*]}]
set_property IOSTANDARD SSTL12_DCI      [get_ports dr0DramClkEn]
set_property IOSTANDARD SSTL12_DCI      [get_ports dr0DramOdt]
set_property IOSTANDARD SSTL12_DCI      [get_ports dr0DramCs_n]
set_property IOSTANDARD DIFF_SSTL12_DCI [get_ports Dram0RefClk_?]
set_property IOSTANDARD LVCMOS12        [get_ports dr0DramTestMode]
set_property DRIVE      8               [get_ports dr0DramTestMode]

# SLEW RATE
set_property SLEW             FAST       [get_ports dr0DramAct_n]
set_property SLEW             FAST       [get_ports {dr0DramAddr[*]}]
set_property SLEW             FAST       [get_ports {dr0DramBankAddr[*]}]
set_property SLEW             FAST       [get_ports {dr0DramBg[*]}]
set_property SLEW             FAST       [get_ports Dram0Clk_?]
set_property SLEW             FAST       [get_ports dr0DramClkEn]
set_property SLEW             FAST       [get_ports {dr0DramDmDbi_n[*]}]
set_property SLEW             FAST       [get_ports {dr0DramDq[*]}]
set_property SLEW             FAST       [get_ports {dr0DramDqs_?[*]}]
set_property SLEW             FAST       [get_ports dr0DramOdt]
set_property SLEW             FAST       [get_ports dr0DramCs_n]

# Output Impedance
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports dr0DramAct_n]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports {dr0DramAddr[*]}]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports {dr0DramBankAddr[?]}]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports {dr0DramBg[*]}]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports Dram0Clk_?]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports dr0DramClkEn]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports {dr0DramDmDbi_n[?]}]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports {dr0DramDq[*]}]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports {dr0DramDqs_?[?]}]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports dr0DramOdt]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports dr0DramCs_n]

# Low Power
set_property IBUF_LOW_PWR     FALSE      [get_ports {dr0DramDmDbi_n[?]}]
set_property IBUF_LOW_PWR     FALSE      [get_ports {dr0DramDq[*]}]
set_property IBUF_LOW_PWR     FALSE      [get_ports {dr0DramDqs_?[?]}]

# ODT RTT
set_property ODT              RTT_40     [get_ports {dr0DramDmDbi_n[?]}]
set_property ODT              RTT_40     [get_ports {dr0DramDq[*]}]
set_property ODT              RTT_40     [get_ports {dr0DramDqs_?[?]}]
set_property ODT              RTT_48     [get_ports {Dram0RefClk_?}]

# Equalization
set_property EQUALIZATION     EQ_LEVEL2  [get_ports {dr0DramDmDbi_n[?]}]
set_property EQUALIZATION     EQ_LEVEL2  [get_ports {dr0DramDq[*]}]
set_property EQUALIZATION     EQ_LEVEL2  [get_ports {dr0DramDqs_?[?]}]

# Pre Emphasis
set_property PRE_EMPHASIS     RDRV_240   [get_ports {dr0DramDmDbi_n[?]}]
set_property PRE_EMPHASIS     RDRV_240   [get_ports {dr0DramDq[*]}]
set_property PRE_EMPHASIS     RDRV_240   [get_ports {dr0DramDqs_?[?]}]

# Data Rate DDR
set_property DATA_RATE        DDR        [get_ports {dr0DramDmDbi_n[?]}]
set_property DATA_RATE        DDR        [get_ports {dr0DramDq[*]}]
set_property DATA_RATE        DDR        [get_ports {dr0DramDqs_?[?]}]
set_property DATA_RATE        DDR        [get_ports Dram0Clk_?]

# Data Rate SDR
set_property DATA_RATE        SDR        [get_ports {dr0DramAddr[*]}]
set_property DATA_RATE        SDR        [get_ports {dr0DramBankAddr[?]}]
set_property DATA_RATE        SDR        [get_ports {dr0DramBg[*]}]
set_property DATA_RATE        SDR        [get_ports dr0DramAct_n]
set_property DATA_RATE        SDR        [get_ports dr0DramOdt]
set_property DATA_RATE        SDR        [get_ports dr0DramClkEn]
set_property DATA_RATE        SDR        [get_ports dr0DramCs_n]


#############
# Interface
#############
create_interface Ddr4_Bank0
set_property INTERFACE Ddr4_Bank0 \
[get_ports dr0DramAct_n] \
[get_ports {dr0DramAddr[*]}] \
[get_ports {dr0DramBankAddr[*]}] \
[get_ports {dr0DramBg[*]}]\
[get_ports Dram0Clk_?]\
[get_ports dr0DramClkEn]\
[get_ports {dr0DramDmDbi_n[*]}]\
[get_ports {dr0DramDq[*]}]\
[get_ports {dr0DramDqs_?[*]}]\
[get_ports dr0DramOdt] \
[get_ports dr0DramCs_n] \
[get_ports {Dram0RefClk_?}] \
[get_ports dr0DramReset_n] \
[get_ports dr0DramTestMode]


## Start add from file SasquatchBank1Dram.xdc
# DRAM Clock creation
# The DRAM Reference Clock is 133.33 MHz for now
create_clock -name DramRefClk1 -period 7.5 [get_ports Dram1RefClk_p]

# Treat Vivado schizophrenia by manually locking MMCM and BUFG to the correct bank where DRAM refclk is located
#set_property LOC MMCM_X0Y2   [get_cells SasquatchDramx/GenBank1.Bank1Dram/Bank1Dram/ddr4_0x/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst]
set_property CLOCK_DEDICATED_ROUTE SAME_CMT_COLUMN [get_nets {SasquatchDramx/GenBank1.Bank1Dram/Bank1Dram/DramRefClk}]

#set_property DONT_TOUCH TRUE [get_cells SasquatchDramx/GenBank1.Bank1Dram/Bank1Dram/ddr4_0x/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst]
#set_property DONT_TOUCH TRUE [get_nets  SasquatchDramx/GenBank1.Bank1Dram/Bank1Dram/DramRefClkPin]
#set_property CLOCK_REGION X2Y2 [get_cells -hier -filter {NAME =~ SasquatchDramx/GenBank1.Bank1Dram/Bank1Dram/DramRefClkBufg}]

set_property IS_LOC_FIXED 0 [get_cells {SasquatchDramx/GenBank1.Bank1Dram/Bank1Dram/ddr4_0x/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst}]
set_property LOC {} [get_cells {SasquatchDramx/GenBank1.Bank1Dram/Bank1Dram/ddr4_0x/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst}]

# Pins

set_property PACKAGE_PIN U31 [get_ports {dr1DramAct_n}]
set_property PACKAGE_PIN V33 [get_ports {dr1DramAddr[0]}]
set_property PACKAGE_PIN U34 [get_ports {dr1DramAddr[10]}]
set_property PACKAGE_PIN V31 [get_ports {dr1DramAddr[11]}]
set_property PACKAGE_PIN T30 [get_ports {dr1DramAddr[12]}]
set_property PACKAGE_PIN R33 [get_ports {dr1DramAddr[13]}]
set_property PACKAGE_PIN M32 [get_ports {dr1DramAddr[14]}]
set_property PACKAGE_PIN R31 [get_ports {dr1DramAddr[15]}]
set_property PACKAGE_PIN P30 [get_ports {dr1DramAddr[16]}]
set_property PACKAGE_PIN T34 [get_ports {dr1DramAddr[1]}]
set_property PACKAGE_PIN V32 [get_ports {dr1DramAddr[2]}]
set_property PACKAGE_PIN T32 [get_ports {dr1DramAddr[3]}]
set_property PACKAGE_PIN U32 [get_ports {dr1DramAddr[4]}]
set_property PACKAGE_PIN P33 [get_ports {dr1DramAddr[5]}]
set_property PACKAGE_PIN M34 [get_ports {dr1DramAddr[6]}]
set_property PACKAGE_PIN P34 [get_ports {dr1DramAddr[7]}]
set_property PACKAGE_PIN N34 [get_ports {dr1DramAddr[8]}]
set_property PACKAGE_PIN T33 [get_ports {dr1DramAddr[9]}]
set_property PACKAGE_PIN L34 [get_ports {dr1DramBankAddr[0]}]
set_property PACKAGE_PIN R32 [get_ports {dr1DramBankAddr[1]}]
set_property PACKAGE_PIN K34 [get_ports {dr1DramBg[0]}]
set_property PACKAGE_PIN P31 [get_ports {Dram1Clk_p}]
set_property PACKAGE_PIN N31 [get_ports {Dram1Clk_n}]
set_property PACKAGE_PIN F30 [get_ports {dr1DramClkEn}]
set_property PACKAGE_PIN R30 [get_ports {dr1DramCs_n}]
set_property PACKAGE_PIN M31 [get_ports {dr1DramDmDbi_n[0]}]
set_property PACKAGE_PIN G30 [get_ports {dr1DramDmDbi_n[1]}]
set_property PACKAGE_PIN H37 [get_ports {dr1DramDmDbi_n[2]}]
set_property PACKAGE_PIN E40 [get_ports {dr1DramDmDbi_n[3]}]
set_property PACKAGE_PIN C36 [get_ports {dr1DramDmDbi_n[4]}]
set_property PACKAGE_PIN B34 [get_ports {dr1DramDmDbi_n[5]}]
set_property PACKAGE_PIN T28 [get_ports {dr1DramDmDbi_n[6]}]
set_property PACKAGE_PIN M29 [get_ports {dr1DramDmDbi_n[7]}]
set_property PACKAGE_PIN J26 [get_ports {dr1DramDmDbi_n[8]}]
set_property PACKAGE_PIN C27 [get_ports {dr1DramDmDbi_n[9]}]
set_property PACKAGE_PIN J31 [get_ports {dr1DramDq[0]}]
set_property PACKAGE_PIN F33 [get_ports {dr1DramDq[10]}]
set_property PACKAGE_PIN G32 [get_ports {dr1DramDq[11]}]
set_property PACKAGE_PIN E33 [get_ports {dr1DramDq[12]}]
set_property PACKAGE_PIN H31 [get_ports {dr1DramDq[13]}]
set_property PACKAGE_PIN E32 [get_ports {dr1DramDq[14]}]
set_property PACKAGE_PIN G31 [get_ports {dr1DramDq[15]}]
set_property PACKAGE_PIN G37 [get_ports {dr1DramDq[16]}]
set_property PACKAGE_PIN F35 [get_ports {dr1DramDq[17]}]
set_property PACKAGE_PIN F37 [get_ports {dr1DramDq[18]}]
set_property PACKAGE_PIN F34 [get_ports {dr1DramDq[19]}]
set_property PACKAGE_PIN K31 [get_ports {dr1DramDq[1]}]
set_property PACKAGE_PIN J35 [get_ports {dr1DramDq[20]}]
set_property PACKAGE_PIN G34 [get_ports {dr1DramDq[21]}]
set_property PACKAGE_PIN J36 [get_ports {dr1DramDq[22]}]
set_property PACKAGE_PIN H34 [get_ports {dr1DramDq[23]}]
set_property PACKAGE_PIN E39 [get_ports {dr1DramDq[24]}]
set_property PACKAGE_PIN C38 [get_ports {dr1DramDq[25]}]
set_property PACKAGE_PIN D39 [get_ports {dr1DramDq[26]}]
set_property PACKAGE_PIN C39 [get_ports {dr1DramDq[27]}]
set_property PACKAGE_PIN E38 [get_ports {dr1DramDq[28]}]
set_property PACKAGE_PIN D38 [get_ports {dr1DramDq[29]}]
set_property PACKAGE_PIN K33 [get_ports {dr1DramDq[2]}]
set_property PACKAGE_PIN B40 [get_ports {dr1DramDq[30]}]
set_property PACKAGE_PIN A40 [get_ports {dr1DramDq[31]}]
set_property PACKAGE_PIN A38 [get_ports {dr1DramDq[32]}]
set_property PACKAGE_PIN A35 [get_ports {dr1DramDq[33]}]
set_property PACKAGE_PIN A37 [get_ports {dr1DramDq[34]}]
set_property PACKAGE_PIN B35 [get_ports {dr1DramDq[35]}]
set_property PACKAGE_PIN E36 [get_ports {dr1DramDq[36]}]
set_property PACKAGE_PIN E35 [get_ports {dr1DramDq[37]}]
set_property PACKAGE_PIN D36 [get_ports {dr1DramDq[38]}]
set_property PACKAGE_PIN D35 [get_ports {dr1DramDq[39]}]
set_property PACKAGE_PIN M30 [get_ports {dr1DramDq[3]}]
set_property PACKAGE_PIN C34 [get_ports {dr1DramDq[40]}]
set_property PACKAGE_PIN B32 [get_ports {dr1DramDq[41]}]
set_property PACKAGE_PIN D33 [get_ports {dr1DramDq[42]}]
set_property PACKAGE_PIN C31 [get_ports {dr1DramDq[43]}]
set_property PACKAGE_PIN D34 [get_ports {dr1DramDq[44]}]
set_property PACKAGE_PIN C32 [get_ports {dr1DramDq[45]}]
set_property PACKAGE_PIN C33 [get_ports {dr1DramDq[46]}]
set_property PACKAGE_PIN D31 [get_ports {dr1DramDq[47]}]
set_property PACKAGE_PIN P26 [get_ports {dr1DramDq[48]}]
set_property PACKAGE_PIN R26 [get_ports {dr1DramDq[49]}]
set_property PACKAGE_PIN K32 [get_ports {dr1DramDq[4]}]
set_property PACKAGE_PIN N26 [get_ports {dr1DramDq[50]}]
set_property PACKAGE_PIN T26 [get_ports {dr1DramDq[51]}]
set_property PACKAGE_PIN P28 [get_ports {dr1DramDq[52]}]
set_property PACKAGE_PIN T27 [get_ports {dr1DramDq[53]}]
set_property PACKAGE_PIN N28 [get_ports {dr1DramDq[54]}]
set_property PACKAGE_PIN R27 [get_ports {dr1DramDq[55]}]
set_property PACKAGE_PIN H27 [get_ports {dr1DramDq[56]}]
set_property PACKAGE_PIN L28 [get_ports {dr1DramDq[57]}]
set_property PACKAGE_PIN J28 [get_ports {dr1DramDq[58]}]
set_property PACKAGE_PIN K28 [get_ports {dr1DramDq[59]}]
set_property PACKAGE_PIN L30 [get_ports {dr1DramDq[5]}]
set_property PACKAGE_PIN H28 [get_ports {dr1DramDq[60]}]
set_property PACKAGE_PIN M27 [get_ports {dr1DramDq[61]}]
set_property PACKAGE_PIN J29 [get_ports {dr1DramDq[62]}]
set_property PACKAGE_PIN L27 [get_ports {dr1DramDq[63]}]
set_property PACKAGE_PIN E28 [get_ports {dr1DramDq[64]}]
set_property PACKAGE_PIN F27 [get_ports {dr1DramDq[65]}]
set_property PACKAGE_PIN G29 [get_ports {dr1DramDq[66]}]
set_property PACKAGE_PIN E27 [get_ports {dr1DramDq[67]}]
set_property PACKAGE_PIN D28 [get_ports {dr1DramDq[68]}]
set_property PACKAGE_PIN G27 [get_ports {dr1DramDq[69]}]
set_property PACKAGE_PIN L33 [get_ports {dr1DramDq[6]}]
set_property PACKAGE_PIN H29 [get_ports {dr1DramDq[70]}]
set_property PACKAGE_PIN G26 [get_ports {dr1DramDq[71]}]
set_property PACKAGE_PIN B30 [get_ports {dr1DramDq[72]}]
set_property PACKAGE_PIN B29 [get_ports {dr1DramDq[73]}]
set_property PACKAGE_PIN A30 [get_ports {dr1DramDq[74]}]
set_property PACKAGE_PIN C29 [get_ports {dr1DramDq[75]}]
set_property PACKAGE_PIN D30 [get_ports {dr1DramDq[76]}]
set_property PACKAGE_PIN D29 [get_ports {dr1DramDq[77]}]
set_property PACKAGE_PIN E30 [get_ports {dr1DramDq[78]}]
set_property PACKAGE_PIN A29 [get_ports {dr1DramDq[79]}]
set_property PACKAGE_PIN L32 [get_ports {dr1DramDq[7]}]
set_property PACKAGE_PIN F32 [get_ports {dr1DramDq[8]}]
set_property PACKAGE_PIN H32 [get_ports {dr1DramDq[9]}]
set_property PACKAGE_PIN K30 [get_ports {dr1DramDqs_p[0]}]
set_property PACKAGE_PIN J30 [get_ports {dr1DramDqs_n[0]}]
set_property PACKAGE_PIN J33 [get_ports {dr1DramDqs_p[1]}]
set_property PACKAGE_PIN H33 [get_ports {dr1DramDqs_n[1]}]
set_property PACKAGE_PIN H36 [get_ports {dr1DramDqs_p[2]}]
set_property PACKAGE_PIN G36 [get_ports {dr1DramDqs_n[2]}]
set_property PACKAGE_PIN B39 [get_ports {dr1DramDqs_p[3]}]
set_property PACKAGE_PIN A39 [get_ports {dr1DramDqs_n[3]}]
set_property PACKAGE_PIN B36 [get_ports {dr1DramDqs_p[4]}]
set_property PACKAGE_PIN B37 [get_ports {dr1DramDqs_n[4]}]
set_property PACKAGE_PIN A32 [get_ports {dr1DramDqs_p[5]}]
set_property PACKAGE_PIN A33 [get_ports {dr1DramDqs_n[5]}]
set_property PACKAGE_PIN P29 [get_ports {dr1DramDqs_p[6]}]
set_property PACKAGE_PIN N29 [get_ports {dr1DramDqs_n[6]}]
set_property PACKAGE_PIN K26 [get_ports {dr1DramDqs_p[7]}]
set_property PACKAGE_PIN K27 [get_ports {dr1DramDqs_n[7]}]
set_property PACKAGE_PIN F28 [get_ports {dr1DramDqs_p[8]}]
set_property PACKAGE_PIN F29 [get_ports {dr1DramDqs_n[8]}]
set_property PACKAGE_PIN A27 [get_ports {dr1DramDqs_p[9]}]
set_property PACKAGE_PIN A28 [get_ports {dr1DramDqs_n[9]}]
set_property PACKAGE_PIN U30 [get_ports {dr1DramOdt}]
set_property PACKAGE_PIN B31 [get_ports dr1DramReset_n]
set_property PACKAGE_PIN N32 [get_ports Dram1RefClk_p]
set_property PACKAGE_PIN N33 [get_ports Dram1RefClk_n]

set_property PACKAGE_PIN  E26   [get_ports dr1DramTestMode          ]

######################################################
# Pin Properties
######################################################
## IO Standards
set_property IOSTANDARD DIFF_POD12_DCI  [get_ports {dr1DramDqs_?[*]}]
set_property IOSTANDARD DIFF_SSTL12_DCI [get_ports Dram1Clk_?]
set_property IOSTANDARD LVCMOS12        [get_ports dr1DramReset_n]
set_property DRIVE      8               [get_ports dr1DramReset_n]
set_property IOSTANDARD POD12_DCI       [get_ports {dr1DramDmDbi_n[*]}]
set_property IOSTANDARD POD12_DCI       [get_ports {dr1DramDq[*]}]
set_property IOSTANDARD SSTL12_DCI      [get_ports dr1DramAct_n]
set_property IOSTANDARD SSTL12_DCI      [get_ports {dr1DramAddr[*]}]
set_property IOSTANDARD SSTL12_DCI      [get_ports {dr1DramBankAddr[*]}]
set_property IOSTANDARD SSTL12_DCI      [get_ports {dr1DramBg[*]}]
set_property IOSTANDARD SSTL12_DCI      [get_ports dr1DramClkEn]
set_property IOSTANDARD SSTL12_DCI      [get_ports dr1DramOdt]
set_property IOSTANDARD SSTL12_DCI      [get_ports dr1DramCs_n]
set_property IOSTANDARD DIFF_SSTL12_DCI [get_ports Dram1RefClk_?]
set_property IOSTANDARD LVCMOS12        [get_ports dr1DramTestMode]
set_property DRIVE      8               [get_ports dr1DramTestMode]

# SLEW RATE
set_property SLEW             FAST       [get_ports dr1DramAct_n]
set_property SLEW             FAST       [get_ports {dr1DramAddr[*]}]
set_property SLEW             FAST       [get_ports {dr1DramBankAddr[*]}]
set_property SLEW             FAST       [get_ports {dr1DramBg[*]}]
set_property SLEW             FAST       [get_ports Dram1Clk_?]
set_property SLEW             FAST       [get_ports dr1DramClkEn]
set_property SLEW             FAST       [get_ports {dr1DramDmDbi_n[*]}]
set_property SLEW             FAST       [get_ports {dr1DramDq[*]}]
set_property SLEW             FAST       [get_ports {dr1DramDqs_?[*]}]
set_property SLEW             FAST       [get_ports dr1DramOdt]
set_property SLEW             FAST       [get_ports dr1DramCs_n]

# Output Impedance
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports dr1DramAct_n]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports {dr1DramAddr[*]}]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports {dr1DramBankAddr[?]}]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports {dr1DramBg[*]}]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports Dram1Clk_?]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports dr1DramClkEn]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports {dr1DramDmDbi_n[?]}]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports {dr1DramDq[*]}]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports {dr1DramDqs_?[?]}]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports dr1DramOdt]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports dr1DramCs_n]

# Low Power
set_property IBUF_LOW_PWR     FALSE      [get_ports {dr1DramDmDbi_n[?]}]
set_property IBUF_LOW_PWR     FALSE      [get_ports {dr1DramDq[*]}]
set_property IBUF_LOW_PWR     FALSE      [get_ports {dr1DramDqs_?[?]}]

# ODT RTT
set_property ODT              RTT_40     [get_ports {dr1DramDmDbi_n[?]}]
set_property ODT              RTT_40     [get_ports {dr1DramDq[*]}]
set_property ODT              RTT_40     [get_ports {dr1DramDqs_?[?]}]
set_property ODT              RTT_48     [get_ports {Dram1RefClk_?}]

# Equalization
set_property EQUALIZATION     EQ_LEVEL2  [get_ports {dr1DramDmDbi_n[?]}]
set_property EQUALIZATION     EQ_LEVEL2  [get_ports {dr1DramDq[*]}]
set_property EQUALIZATION     EQ_LEVEL2  [get_ports {dr1DramDqs_?[?]}]

# Pre Emphasis
set_property PRE_EMPHASIS     RDRV_240   [get_ports {dr1DramDmDbi_n[?]}]
set_property PRE_EMPHASIS     RDRV_240   [get_ports {dr1DramDq[*]}]
set_property PRE_EMPHASIS     RDRV_240   [get_ports {dr1DramDqs_?[?]}]

# Data Rate DDR
set_property DATA_RATE        DDR        [get_ports {dr1DramDmDbi_n[?]}]
set_property DATA_RATE        DDR        [get_ports {dr1DramDq[*]}]
set_property DATA_RATE        DDR        [get_ports {dr1DramDqs_?[?]}]
set_property DATA_RATE        DDR        [get_ports Dram1Clk_?]

# Data Rate SDR
set_property DATA_RATE        SDR        [get_ports {dr1DramAddr[*]}]
set_property DATA_RATE        SDR        [get_ports {dr1DramBankAddr[?]}]
set_property DATA_RATE        SDR        [get_ports {dr1DramBg[*]}]
set_property DATA_RATE        SDR        [get_ports dr1DramAct_n]
set_property DATA_RATE        SDR        [get_ports dr1DramOdt]
set_property DATA_RATE        SDR        [get_ports dr1DramClkEn]
set_property DATA_RATE        SDR        [get_ports dr1DramCs_n]


#############
# Interface
#############
create_interface Ddr4_Bank1
set_property INTERFACE Ddr4_Bank1 \
[get_ports dr1DramAct_n] \
[get_ports {dr1DramAddr[*]}] \
[get_ports {dr1DramBankAddr[*]}] \
[get_ports {dr1DramBg[*]}]\
[get_ports Dram1Clk_?]\
[get_ports dr1DramClkEn]\
[get_ports {dr1DramDmDbi_n[*]}]\
[get_ports {dr1DramDq[*]}]\
[get_ports {dr1DramDqs_?[*]}]\
[get_ports dr1DramOdt]\
[get_ports dr1DramCs_n] \
[get_ports {Dram1RefClk_?}] \
[get_ports dr1DramReset_n] \
[get_ports dr1DramTestMode]



set ddr4_00 [current_instance .]
current_instance SasquatchDramx/GenBank0.Bank0Dram/Bank0Dram/ddr4_0x
## Start add from file ddr4_0_mod.xdc
set ddr4_0Inst [current_instance .]

####################################################################################
# Generated by Vivado 2021.1 built on 'Thu Jun 10 19:36:07 MDT 2021' by 'xbuild'
# Command Used: write_xdc -force -exclude_physical /home/rfmibuild/myagent/_work/498/s/hw-flexrio/ipcores/vendorip/dram/objects/tool/synth_dram/virtexultrascaleplus/sasquatch/ddr4_0/vivado/output/constraint/ddr4_0.xdc
####################################################################################


####################################################################################
# Constraints from file : 'bd_9054_microblaze_I_0.xdc'
####################################################################################

current_instance inst/u_ddr4_mem_intfc/u_ddr_cal_riu/mcs0/U0/microblaze_I/U0
set_false_path -through [get_ports -scoped_to_current_instance Reset]

####################################################################################
# Constraints from file : 'bd_9054_rst_0_0.xdc'
####################################################################################

current_instance -quiet
current_instance $ddr4_0Inst
current_instance inst/u_ddr4_mem_intfc/u_ddr_cal_riu/mcs0/U0/rst_0/U0
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'bd_9054_ilmb_0.xdc'
####################################################################################

current_instance -quiet
current_instance $ddr4_0Inst
current_instance inst/u_ddr4_mem_intfc/u_ddr_cal_riu/mcs0/U0/ilmb/U0
set_false_path -through [get_ports -scoped_to_current_instance SYS_Rst]

####################################################################################
# Constraints from file : 'bd_9054_dlmb_0.xdc'
####################################################################################

current_instance -quiet
current_instance $ddr4_0Inst
current_instance inst/u_ddr4_mem_intfc/u_ddr_cal_riu/mcs0/U0/dlmb/U0
set_false_path -through [get_ports -scoped_to_current_instance SYS_Rst]

####################################################################################
# Constraints from file : 'ddr4_0.xdc'
####################################################################################

current_instance -quiet
current_instance $ddr4_0Inst
current_instance inst
set_false_path -hold -to [get_pins */*/*/*/*/*.u_xiphy_control/xiphy_control/RIU_ADDR*]
set_false_path -hold -to [get_pins */*/*/*/*/*.u_xiphy_control/xiphy_control/RIU_WR_DATA*]
set_max_delay -datapath_only -from [get_pins */*/*/u_ddr_cal_addr_decode/io_ready_lvl_reg/C] -to [get_pins {*/u_io_ready_lvl_sync/SYNC[*].sync_reg_reg[0]/D}] 5.000
set_max_delay -datapath_only -from [get_pins {*/*/*/u_ddr_cal_addr_decode/io_read_data_reg[*]/C}] -to [get_pins {*/u_io_read_data_sync/SYNC[*].sync_reg_reg[0]/D}] 5.000
set_max_delay -datapath_only -from [get_pins */*/*/phy_ready_riuclk_reg/C] -to [get_pins {*/u_phy2clb_phy_ready_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */*/*/bisc_complete_riuclk_reg/C] -to [get_pins {*/u_phy2clb_bisc_complete_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */*/io_addr_strobe_lvl_riuclk_reg/C] -to [get_pins {*/u_io_addr_strobe_lvl_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */*/io_write_strobe_riuclk_reg/C] -to [get_pins {*/u_io_write_strobe_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins {*/*/io_address_riuclk_reg[*]/C}] -to [get_pins {*/u_io_addr_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins {*/*/io_write_data_riuclk_reg[*]/C}] -to [get_pins {*/u_io_write_data_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */en_vtc_in_reg/C] -to [get_pins {*/u_en_vtc_sync/SYNC[*].sync_reg_reg[0]/D}] 10.000
set_max_delay -datapath_only -from [get_pins {*/*/riu2clb_valid_r1_riuclk_reg[*]/C}] -to [get_pins {*/u_riu2clb_valid_sync/SYNC[*].sync_reg_reg[0]/D}] 10.000
set_max_delay -datapath_only -from [get_pins {*/*/*/phy2clb_fixdly_rdy_low_riuclk_int_reg[*]/C}] -to [get_pins {*/u_phy2clb_fixdly_rdy_low/SYNC[*].sync_reg_reg[0]/D}] 10.000
set_max_delay -datapath_only -from [get_pins {*/*/*/phy2clb_fixdly_rdy_upp_riuclk_int_reg[*]/C}] -to [get_pins {*/u_phy2clb_fixdly_rdy_upp/SYNC[*].sync_reg_reg[0]/D}] 10.000
set_max_delay -datapath_only -from [get_pins {*/*/*/phy2clb_phy_rdy_low_riuclk_int_reg[*]/C}] -to [get_pins {*/u_phy2clb_phy_rdy_low/SYNC[*].sync_reg_reg[0]/D}] 10.000
set_max_delay -datapath_only -from [get_pins {*/*/*/phy2clb_phy_rdy_upp_riuclk_int_reg[*]/C}] -to [get_pins {*/u_phy2clb_phy_rdy_upp/SYNC[*].sync_reg_reg[0]/D}] 10.000
set_max_delay -datapath_only -from [get_pins */rst_r1_reg/C] -to [get_pins {*/u_fab_rst_sync/SYNC[*].sync_reg_reg[0]/D}] 10.000
set_max_delay -datapath_only -from [get_pins */*/*/clb2phy_t_b_addr_riuclk_reg/C] -to [get_pins {*/*/*/clb2phy_t_b_addr_i_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */*/*/*/slave_en_lvl_reg/C] -to [get_pins {*/*/*/*/u_slave_en_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */*/*/*/slave_we_r_reg/C] -to [get_pins {*/*/*/*/u_slave_we_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins {*/*/*/*/slave_addr_r_reg[*]/C}] -to [get_pins {*/*/*/*/u_slave_addr_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins {*/*/*/*/slave_di_r_reg[*]/C}] -to [get_pins {*/*/*/*/u_slave_di_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */*/*/*/slave_rdy_cptd_sclk_reg/C] -to [get_pins {*/*/*/*/u_slave_rdy_cptd_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */*/*/*/slave_rdy_lvl_fclk_reg/C] -to [get_pins {*/*/*/*/u_slave_rdy_sync/SYNC[*].sync_reg_reg[0]/D}] 12.000
set_max_delay -datapath_only -from [get_pins {*/*/*/*/slave_do_fclk_reg[*]/C}] -to [get_pins {*/*/*/*/u_slave_do_sync/SYNC[*].sync_reg_reg[0]/D}] 12.000
set_false_path -through [get_pins u_ddr4_infrastructure/sys_rst]
set_false_path -from [get_pins */input_rst_design_reg/C] -to [get_pins {*/rst_div_sync_r_reg[0]/D}]
set_false_path -from [get_pins */input_rst_design_reg/C] -to [get_pins {*/rst_riu_sync_r_reg[0]/D}]
set_false_path -from [get_pins */input_rst_design_reg/C] -to [get_pins {*/rst_mb_sync_r_reg[0]/D}]
set_false_path -from [get_pins */rst_async_riu_div_reg/C] -to [get_pins {*/rst_div_sync_r_reg[0]/D}]
set_false_path -from [get_pins */rst_async_mb_reg/C] -to [get_pins {*/rst_mb_sync_r_reg[0]/D}]
set_false_path -from [get_pins */rst_async_riu_div_reg/C] -to [get_pins {*/rst_riu_sync_r_reg[0]/D}]

# Vivado Generated miscellaneous constraints

#revert back to original instance
current_instance -quiet
current_instance $ddr4_0Inst



current_instance -quiet
current_instance $ddr4_00
set ddr4_00 [current_instance .]
current_instance SasquatchDramx/GenBank1.Bank1Dram/Bank1Dram/ddr4_0x
## Start add from file ddr4_0_mod.xdc
set ddr4_0Inst [current_instance .]

####################################################################################
# Generated by Vivado 2021.1 built on 'Thu Jun 10 19:36:07 MDT 2021' by 'xbuild'
# Command Used: write_xdc -force -exclude_physical /home/rfmibuild/myagent/_work/498/s/hw-flexrio/ipcores/vendorip/dram/objects/tool/synth_dram/virtexultrascaleplus/sasquatch/ddr4_0/vivado/output/constraint/ddr4_0.xdc
####################################################################################


####################################################################################
# Constraints from file : 'bd_9054_microblaze_I_0.xdc'
####################################################################################

current_instance inst/u_ddr4_mem_intfc/u_ddr_cal_riu/mcs0/U0/microblaze_I/U0
set_false_path -through [get_ports -scoped_to_current_instance Reset]

####################################################################################
# Constraints from file : 'bd_9054_rst_0_0.xdc'
####################################################################################

current_instance -quiet
current_instance $ddr4_0Inst
current_instance inst/u_ddr4_mem_intfc/u_ddr_cal_riu/mcs0/U0/rst_0/U0
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'bd_9054_ilmb_0.xdc'
####################################################################################

current_instance -quiet
current_instance $ddr4_0Inst
current_instance inst/u_ddr4_mem_intfc/u_ddr_cal_riu/mcs0/U0/ilmb/U0
set_false_path -through [get_ports -scoped_to_current_instance SYS_Rst]

####################################################################################
# Constraints from file : 'bd_9054_dlmb_0.xdc'
####################################################################################

current_instance -quiet
current_instance $ddr4_0Inst
current_instance inst/u_ddr4_mem_intfc/u_ddr_cal_riu/mcs0/U0/dlmb/U0
set_false_path -through [get_ports -scoped_to_current_instance SYS_Rst]

####################################################################################
# Constraints from file : 'ddr4_0.xdc'
####################################################################################

current_instance -quiet
current_instance $ddr4_0Inst
current_instance inst
set_false_path -hold -to [get_pins */*/*/*/*/*.u_xiphy_control/xiphy_control/RIU_ADDR*]
set_false_path -hold -to [get_pins */*/*/*/*/*.u_xiphy_control/xiphy_control/RIU_WR_DATA*]
set_max_delay -datapath_only -from [get_pins */*/*/u_ddr_cal_addr_decode/io_ready_lvl_reg/C] -to [get_pins {*/u_io_ready_lvl_sync/SYNC[*].sync_reg_reg[0]/D}] 5.000
set_max_delay -datapath_only -from [get_pins {*/*/*/u_ddr_cal_addr_decode/io_read_data_reg[*]/C}] -to [get_pins {*/u_io_read_data_sync/SYNC[*].sync_reg_reg[0]/D}] 5.000
set_max_delay -datapath_only -from [get_pins */*/*/phy_ready_riuclk_reg/C] -to [get_pins {*/u_phy2clb_phy_ready_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */*/*/bisc_complete_riuclk_reg/C] -to [get_pins {*/u_phy2clb_bisc_complete_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */*/io_addr_strobe_lvl_riuclk_reg/C] -to [get_pins {*/u_io_addr_strobe_lvl_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */*/io_write_strobe_riuclk_reg/C] -to [get_pins {*/u_io_write_strobe_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins {*/*/io_address_riuclk_reg[*]/C}] -to [get_pins {*/u_io_addr_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins {*/*/io_write_data_riuclk_reg[*]/C}] -to [get_pins {*/u_io_write_data_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */en_vtc_in_reg/C] -to [get_pins {*/u_en_vtc_sync/SYNC[*].sync_reg_reg[0]/D}] 10.000
set_max_delay -datapath_only -from [get_pins {*/*/riu2clb_valid_r1_riuclk_reg[*]/C}] -to [get_pins {*/u_riu2clb_valid_sync/SYNC[*].sync_reg_reg[0]/D}] 10.000
set_max_delay -datapath_only -from [get_pins {*/*/*/phy2clb_fixdly_rdy_low_riuclk_int_reg[*]/C}] -to [get_pins {*/u_phy2clb_fixdly_rdy_low/SYNC[*].sync_reg_reg[0]/D}] 10.000
set_max_delay -datapath_only -from [get_pins {*/*/*/phy2clb_fixdly_rdy_upp_riuclk_int_reg[*]/C}] -to [get_pins {*/u_phy2clb_fixdly_rdy_upp/SYNC[*].sync_reg_reg[0]/D}] 10.000
set_max_delay -datapath_only -from [get_pins {*/*/*/phy2clb_phy_rdy_low_riuclk_int_reg[*]/C}] -to [get_pins {*/u_phy2clb_phy_rdy_low/SYNC[*].sync_reg_reg[0]/D}] 10.000
set_max_delay -datapath_only -from [get_pins {*/*/*/phy2clb_phy_rdy_upp_riuclk_int_reg[*]/C}] -to [get_pins {*/u_phy2clb_phy_rdy_upp/SYNC[*].sync_reg_reg[0]/D}] 10.000
set_max_delay -datapath_only -from [get_pins */rst_r1_reg/C] -to [get_pins {*/u_fab_rst_sync/SYNC[*].sync_reg_reg[0]/D}] 10.000
set_max_delay -datapath_only -from [get_pins */*/*/clb2phy_t_b_addr_riuclk_reg/C] -to [get_pins {*/*/*/clb2phy_t_b_addr_i_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */*/*/*/slave_en_lvl_reg/C] -to [get_pins {*/*/*/*/u_slave_en_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */*/*/*/slave_we_r_reg/C] -to [get_pins {*/*/*/*/u_slave_we_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins {*/*/*/*/slave_addr_r_reg[*]/C}] -to [get_pins {*/*/*/*/u_slave_addr_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins {*/*/*/*/slave_di_r_reg[*]/C}] -to [get_pins {*/*/*/*/u_slave_di_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */*/*/*/slave_rdy_cptd_sclk_reg/C] -to [get_pins {*/*/*/*/u_slave_rdy_cptd_sync/SYNC[*].sync_reg_reg[0]/D}] 3.000
set_max_delay -datapath_only -from [get_pins */*/*/*/slave_rdy_lvl_fclk_reg/C] -to [get_pins {*/*/*/*/u_slave_rdy_sync/SYNC[*].sync_reg_reg[0]/D}] 12.000
set_max_delay -datapath_only -from [get_pins {*/*/*/*/slave_do_fclk_reg[*]/C}] -to [get_pins {*/*/*/*/u_slave_do_sync/SYNC[*].sync_reg_reg[0]/D}] 12.000
set_false_path -through [get_pins u_ddr4_infrastructure/sys_rst]
set_false_path -from [get_pins */input_rst_design_reg/C] -to [get_pins {*/rst_div_sync_r_reg[0]/D}]
set_false_path -from [get_pins */input_rst_design_reg/C] -to [get_pins {*/rst_riu_sync_r_reg[0]/D}]
set_false_path -from [get_pins */input_rst_design_reg/C] -to [get_pins {*/rst_mb_sync_r_reg[0]/D}]
set_false_path -from [get_pins */rst_async_riu_div_reg/C] -to [get_pins {*/rst_div_sync_r_reg[0]/D}]
set_false_path -from [get_pins */rst_async_mb_reg/C] -to [get_pins {*/rst_mb_sync_r_reg[0]/D}]
set_false_path -from [get_pins */rst_async_riu_div_reg/C] -to [get_pins {*/rst_riu_sync_r_reg[0]/D}]

# Vivado Generated miscellaneous constraints

#revert back to original instance
current_instance -quiet
current_instance $ddr4_0Inst



current_instance -quiet
current_instance $ddr4_00



## Start include, file cfmake_uspg3x8_vu11p.xml
## Start add from file ClockingUltrascalePlus.xdc
##################### TIMING CONSTRAINTS #######################

################################################################################
##Clock Creation and naming
################################################################################

## Osc100ClkIn is given the ReliableClk name because that's its primary function.
create_clock -name ReliableClk -period 10.0  [get_ports Osc100ClkIn]
## Backplane Clock
create_clock -name PxieClk100  -period 10.0  [get_ports PxieClk100_p]

## These naming assignments without periods will rename the auto-generated clocks to
## something manageable and constant (from whatever Xilinx came up with) without breaking
## the auto-propagated waveform (period/phase/jitter).
# Since we are not using Clk40 I will comment it to prevent it from generating critical warnings
set clockingInstance TimingEnginex/TimingStage1x/ReliableClkPllx
set PllPin0 [get_pins $clockingInstance/inst/mmcme4_adv_inst/CLKOUT0]
set PllPin1 [get_pins $clockingInstance/inst/mmcme4_adv_inst/CLKOUT1]
set PllPin2 [get_pins $clockingInstance/inst/mmcme4_adv_inst/CLKOUT2]
#I'm commenting Clk40 until we actualy use it to prevent it from generating critical warnings
set PllClk40  [get_clocks -of_objects $PllPin0]
set PllClk80  [get_clocks -of_objects $PllPin1]
set DlyRefClk [get_clocks -of_objects $PllPin2]

## Aditionally, we'll use clock aliases (essentially, we'll just save the proper clock in a
## variable), so that the different uses of the above clocks can be changed in a single
## place. If different clocks become different things, they should be changed here.
set BusClk $PllClk80
set DmaClk [get_clocks -of [get_nets DmaClk]]

## These are some annoying clocks that keep showing up in our timing reports. They don't
## really need to be constrained: they're "happen once" strobes or very slow (JTAG)
## clocks. They're used internally to some Xilinx IP, Xilinx doesn't take the time to
## constrain them, and then Xilinx complains that they're not constrained. *Sigh*


set SasquatchTopTemplate1 [current_instance .]
current_instance HostInterfacex/Inchwormx/InchwormNetlist
## Start add from file InchwormNetlistTiming.xdc

###################################################################################
##
##
##
###################################################################################

#######################################################################
# Timing constraints for the InChWORM netlist. Physical constraints are provided on a
#  separate file depending on the given part and location of the corresponding PCIe IP
#  core desired to be used by the InChWORM
# Assumptions:
#  - Current instance is Inchworm netlist
#  - Clock40 for authentication has been created.
#######################################################################

## Start add from file CommonPcieConstraints.xdc
#######################################################################
# File: CommonPcieConstraints.xdc
#
# Common timing constraints for all PCIe Inchworm netlists.
# Usage assumptions (to be satisfied by user):
#   - Current instance is Inchworm netlist
# Netlist assumptions (to be satisfied at netlist synthesis):
#   - Netlist wraps the PCIe IP in an instance called PcieIpWrapper
#   - PcieIpWrapper instantiates the Pcie IP with instance name PcieIp
#   - PcieIpWrapper instantiates the Pcie RefClk IBUFDS with instance name PcieRefClkIBufds
#   - Reset is routed to the hard IP with net named aPcieRst_n
# Note that this does not include the Xilinx PCIe IP generated constraints (to be written
#   in vivado for each netlist).
#######################################################################

# PCIe reset is treated as asynchronous even if it is extended with synchronous logic.
# Note that this is the reset to the netlist an not the reset from the connector.
# Constraining the reset from the connector is left to the user.
set_false_path -through [get_nets aPcieRst_n]

# PCIe reference clock going to the transceivers in order to recover the system clocks and
#  other generated clocks that will be created automatically.
create_clock -name PcieRefClk -period 10 [get_ports -scoped_to_current_instance PcieRefClk_p]

# Disabling recovery/removal on the generated internal bus reset (aBusReset output port
#  of netlist). This covers also InChWORM internal flops that are designed to be safe
#  on asynchronous reset deassertion.
set_false_path -through [get_pins PcieIpWrapper/PcieIp/inst/user_reset_reg*/Q]

set_property DONT_TOUCH TRUE [get_cells PcieIpWrapper/PcieIp/inst]

## Start add from file PcieIpCoreTiming.xdc
#######################################################################
# File: PcieIpCoreTiming.xdc
#
# Automatically created in Vivado from generated IP constraints
#######################################################################

# Timing constraints related to PCIe Core.

# Backing up current instance
set inchworm_netlist_instance [current_instance .]

#######################################################################
# Constraints from file : 'ip_pcie4_uscale_plus_X1Y0.xdc'
#######################################################################

current_instance PcieIpWrapper/PcieIp/inst
create_clock -period 2.000 [get_pins -filter REF_PIN_NAME=~TXOUTCLK -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
create_clock -period 1000.000 [get_pins gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_intclk/O]
set_case_analysis 1 [get_pins -filter {REF_PIN_NAME=~TXOUTCLKSEL[2]} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME=~TXOUTCLKSEL[1]} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_case_analysis 1 [get_pins -filter {REF_PIN_NAME=~TXOUTCLKSEL[0]} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME=~TXRATE[0]} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME=~RXRATE[0]} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_case_analysis 1 [get_pins -filter {REF_PIN_NAME=~TXRATE[1]} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_case_analysis 1 [get_pins -filter {REF_PIN_NAME=~RXRATE[1]} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME=~TXRATE[2]} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME=~RXRATE[2]} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_false_path -from [get_pins -filter REF_PIN_NAME=~TXUSRCLK2 -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]] -to [get_pins {gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_rst_i/sync_txresetdone/sync_vec[*].sync_cell_i/sync_reg[0]/D}]
set_false_path -from [get_pins -filter REF_PIN_NAME=~RXUSRCLK2 -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]] -to [get_pins {gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_rst_i/sync_phystatus/sync_vec[*].sync_cell_i/sync_reg[0]/D}]
set_false_path -from [get_pins -filter REF_PIN_NAME=~RXUSRCLK2 -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]] -to [get_pins {gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_rst_i/sync_rxresetdone/sync_vec[*].sync_cell_i/sync_reg[0]/D}]
set_case_analysis 1 [get_pins {gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_pclk/DIV[0]}]
set_case_analysis 0 [get_pins {gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_pclk/DIV[1]}]
set_case_analysis 0 [get_pins {gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_pclk/DIV[2]}]
set_multicycle_path -setup -end -through [get_pins [get_pins pcie_4_0_pipe_inst/pcie_4_0_e4_inst/*AXIS*] -filter DIRECTION==IN] 2
set_multicycle_path -hold -end -through [get_pins [get_pins pcie_4_0_pipe_inst/pcie_4_0_e4_inst/*AXIS*] -filter DIRECTION==IN] 1
set_multicycle_path -setup -start -through [get_pins [get_pins pcie_4_0_pipe_inst/pcie_4_0_e4_inst/*AXIS*] -filter DIRECTION==OUT] 2
set_multicycle_path -hold -start -through [get_pins [get_pins pcie_4_0_pipe_inst/pcie_4_0_e4_inst/*AXIS*] -filter DIRECTION==OUT] 1
set_multicycle_path -setup -end -through [get_pins [get_pins {pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECQPIPELINEEMPTY pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECQNPUSERCREDITRCVD pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIEPOSTEDREQDELIVERED pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECOMPLDELIVERED* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/AXIUSER* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/CFG* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/CONF* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECQNPREQ* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIERQTAG* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIETFC* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/USERSPARE*}] -filter DIRECTION==IN] 2
set_multicycle_path -hold -end -through [get_pins [get_pins {pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECQPIPELINEEMPTY pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECQNPUSERCREDITRCVD pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIEPOSTEDREQDELIVERED pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECOMPLDELIVERED* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/AXIUSER* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/CFG* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/CONF* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECQNPREQ* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIERQTAG* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIETFC* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/USERSPARE*}] -filter DIRECTION==IN] 1
set_multicycle_path -setup -start -through [get_pins [get_pins {pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECQPIPELINEEMPTY pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECQNPUSERCREDITRCVD pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIEPOSTEDREQDELIVERED pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECOMPLDELIVERED* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/AXIUSER* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/CFG* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/CONF* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECQNPREQ* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIERQTAG* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIETFC* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/USERSPARE*}] -filter DIRECTION==OUT] 2
set_multicycle_path -hold -start -through [get_pins [get_pins {pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECQPIPELINEEMPTY pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECQNPUSERCREDITRCVD pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIEPOSTEDREQDELIVERED pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECOMPLDELIVERED* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/AXIUSER* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/CFG* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/CONF* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIECQNPREQ* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIERQTAG* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/PCIETFC* pcie_4_0_pipe_inst/pcie_4_0_e4_inst/USERSPARE*}] -filter DIRECTION==OUT] 1
set_false_path -to [get_pins -hier {*sync_reg[0]/D}]
set_false_path -to [get_pins {gt_top_i/diablo_gt.diablo_gt_phy_wrapper/rst_psrst_n_r_reg[*]/CLR}]
set_false_path -to [get_pins {gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_rst_i/prst_n_r_reg[*]/CLR}]
set_false_path -through [get_pins -filter REF_PIN_NAME=~RXELECIDLE -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_false_path -through [get_pins -filter REF_PIN_NAME=~PCIERATEGEN3 -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_false_path -through [get_pins -filter REF_PIN_NAME=~RXPRGDIVRESETDONE -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_false_path -through [get_pins -filter REF_PIN_NAME=~TXPRGDIVRESETDONE -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_false_path -through [get_pins -filter REF_PIN_NAME=~PCIESYNCTXSYNCDONE -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_false_path -through [get_pins -filter REF_PIN_NAME=~GTPOWERGOOD -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_false_path -through [get_pins -filter REF_PIN_NAME=~CPLLLOCK -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]
set_false_path -through [get_pins -filter REF_PIN_NAME=~PIPETXMARGIN* -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.PCIE.* }]]
set_false_path -through [get_pins -filter REF_PIN_NAME=~PIPETXSWING -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.PCIE.* }]]
set_false_path -through [get_pins -filter REF_PIN_NAME=~PCIEPERST0B -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.PCIE.* }]]
set_false_path -to [get_pins user_lnk_up_reg/CLR]
set_false_path -to [get_pins user_reset_reg/PRE]

#######################################################################
# Constraints from file : 'PcieUspG3x8TandemHardIp_gt.xdc'
#######################################################################


# Restoring netlist instance
current_instance -quiet
current_instance -quiet $inchworm_netlist_instance

current_instance PcieIpWrapper/PcieIp/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i
create_clock -period 8.000 [get_pins -filter REF_PIN_NAME=~*O -of_objects [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[0].*bufg_gt_txoutclkmon_inst}]]
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[0].*U_TXOUTCLK_FREQ_COUNTER/testclk_cnt_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[0].*U_TXOUTCLK_FREQ_COUNTER/freq_cnt_o_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[0].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[0].*U_TXOUTCLK_FREQ_COUNTER/tstclk_rst_dly1_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[0].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[0].*U_TXOUTCLK_FREQ_COUNTER/testclk_en_dly1_reg*}] -quiet
create_clock -period 8.000 [get_pins -filter REF_PIN_NAME=~*O -of_objects [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[1].*bufg_gt_txoutclkmon_inst}]]
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[1].*U_TXOUTCLK_FREQ_COUNTER/testclk_cnt_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[1].*U_TXOUTCLK_FREQ_COUNTER/freq_cnt_o_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[1].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[1].*U_TXOUTCLK_FREQ_COUNTER/tstclk_rst_dly1_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[1].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[1].*U_TXOUTCLK_FREQ_COUNTER/testclk_en_dly1_reg*}] -quiet
create_clock -period 8.000 [get_pins -filter REF_PIN_NAME=~*O -of_objects [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[2].*bufg_gt_txoutclkmon_inst}]]
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[2].*U_TXOUTCLK_FREQ_COUNTER/testclk_cnt_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[2].*U_TXOUTCLK_FREQ_COUNTER/freq_cnt_o_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[2].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[2].*U_TXOUTCLK_FREQ_COUNTER/tstclk_rst_dly1_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[2].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[2].*U_TXOUTCLK_FREQ_COUNTER/testclk_en_dly1_reg*}] -quiet
create_clock -period 8.000 [get_pins -filter REF_PIN_NAME=~*O -of_objects [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[3].*bufg_gt_txoutclkmon_inst}]]
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[3].*U_TXOUTCLK_FREQ_COUNTER/testclk_cnt_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[3].*U_TXOUTCLK_FREQ_COUNTER/freq_cnt_o_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[3].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[3].*U_TXOUTCLK_FREQ_COUNTER/tstclk_rst_dly1_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[3].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[3].*U_TXOUTCLK_FREQ_COUNTER/testclk_en_dly1_reg*}] -quiet
create_clock -period 8.000 [get_pins -filter REF_PIN_NAME=~*O -of_objects [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[4].*bufg_gt_txoutclkmon_inst}]]
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[4].*U_TXOUTCLK_FREQ_COUNTER/testclk_cnt_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[4].*U_TXOUTCLK_FREQ_COUNTER/freq_cnt_o_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[4].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[4].*U_TXOUTCLK_FREQ_COUNTER/tstclk_rst_dly1_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[4].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[4].*U_TXOUTCLK_FREQ_COUNTER/testclk_en_dly1_reg*}] -quiet
create_clock -period 8.000 [get_pins -filter REF_PIN_NAME=~*O -of_objects [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[5].*bufg_gt_txoutclkmon_inst}]]
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[5].*U_TXOUTCLK_FREQ_COUNTER/testclk_cnt_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[5].*U_TXOUTCLK_FREQ_COUNTER/freq_cnt_o_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[5].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[5].*U_TXOUTCLK_FREQ_COUNTER/tstclk_rst_dly1_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[5].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[5].*U_TXOUTCLK_FREQ_COUNTER/testclk_en_dly1_reg*}] -quiet
create_clock -period 8.000 [get_pins -filter REF_PIN_NAME=~*O -of_objects [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[6].*bufg_gt_txoutclkmon_inst}]]
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[6].*U_TXOUTCLK_FREQ_COUNTER/testclk_cnt_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[6].*U_TXOUTCLK_FREQ_COUNTER/freq_cnt_o_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[6].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[6].*U_TXOUTCLK_FREQ_COUNTER/tstclk_rst_dly1_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[6].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[6].*U_TXOUTCLK_FREQ_COUNTER/testclk_en_dly1_reg*}] -quiet
create_clock -period 8.000 [get_pins -filter REF_PIN_NAME=~*O -of_objects [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[7].*bufg_gt_txoutclkmon_inst}]]
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[7].*U_TXOUTCLK_FREQ_COUNTER/testclk_cnt_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[7].*U_TXOUTCLK_FREQ_COUNTER/freq_cnt_o_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[7].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[7].*U_TXOUTCLK_FREQ_COUNTER/tstclk_rst_dly1_reg*}] -quiet
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[7].*U_TXOUTCLK_FREQ_COUNTER/state_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *gen_cpll_cal_inst[7].*U_TXOUTCLK_FREQ_COUNTER/testclk_en_dly1_reg*}] -quiet
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *bit_synchronizer*inst/i_in_meta_reg}]
set_false_path -to [get_pins -filter REF_PIN_NAME=~*D -of_objects [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_meta*}]]
set_false_path -to [get_pins -filter REF_PIN_NAME=~*PRE -of_objects [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_meta*}]]
set_false_path -to [get_pins -filter REF_PIN_NAME=~*PRE -of_objects [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_sync1*}]]
set_false_path -to [get_pins -filter REF_PIN_NAME=~*PRE -of_objects [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_sync2*}]]
set_false_path -to [get_pins -filter REF_PIN_NAME=~*PRE -of_objects [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_sync3*}]]
set_false_path -to [get_pins -filter REF_PIN_NAME=~*PRE -of_objects [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_out*}]]

# Restoring netlist instance
current_instance -quiet
current_instance -quiet $inchworm_netlist_instance

set_clock_groups -asynchronous -group [get_clocks PcieRefClk] -group [get_clocks -of_objects [get_pins -filter REF_PIN_NAME=~TXOUTCLK -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins -filter REF_PIN_NAME=~TXOUTCLK -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ ADVANCED.GT.* }]]] -group [get_clocks PcieRefClk]
set_clock_groups -asynchronous -group [get_clocks PcieRefClk] -group [get_clocks -of_objects [get_pins -filter REF_PIN_NAME=~O -of_objects [get_cells -hierarchical -filter NAME=~*/bufg_gt_intclk]]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins -filter REF_PIN_NAME=~O -of_objects [get_cells -hierarchical -filter NAME=~*/bufg_gt_intclk]]] -group [get_clocks PcieRefClk]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins -filter REF_PIN_NAME=~O -of_objects [get_cells -hierarchical -filter NAME=~*/bufg_gt_intclk]]] -group [get_clocks -of_objects [get_pins -filter REF_PIN_NAME=~O -of_objects [get_cells -hierarchical -filter NAME=~*/bufg_gt_pclk]]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins -filter REF_PIN_NAME=~O -of_objects [get_cells -hierarchical -filter NAME=~*/bufg_gt_pclk]]] -group [get_clocks -of_objects [get_pins -filter REF_PIN_NAME=~O -of_objects [get_cells -hierarchical -filter NAME=~*/bufg_gt_intclk]]]
set_clock_groups -asynchronous -group [get_clocks PcieRefClk] -group [get_clocks -of_objects [get_pins -filter REF_PIN_NAME=~O -of_objects [get_cells -hierarchical -filter NAME=~*/bufg_gt_pclk]]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins -filter REF_PIN_NAME=~O -of_objects [get_cells -hierarchical -filter NAME=~*/bufg_gt_pclk]]] -group [get_clocks PcieRefClk]
set_clock_groups -asynchronous -group [get_clocks PcieRefClk] -group [get_clocks -of_objects [get_pins -filter REF_PIN_NAME=~O -of_objects [get_cells -hierarchical -filter NAME=~*/bufg_gt_userclk]]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins -filter REF_PIN_NAME=~O -of_objects [get_cells -hierarchical -filter NAME=~*/bufg_gt_userclk]]] -group [get_clocks PcieRefClk]

# Restoring netlist instance
current_instance -quiet
current_instance -quiet $inchworm_netlist_instance



set InchwormNetlist0 [current_instance .]
current_instance AtmelAuthenticationTopx
## Start add from file AtmelAuthenticationTiming.xdc

###################################################################################
##
##
##
###################################################################################

#######################################################################
# Timing constraints for the Atmel Authentication IP.
# Created with cfmake consisting entirely of references to nicores instances.
# Assumptions:
#  - current_instance is the instance of AtmelAuthenticationTop
#      (e.g. AtmelAuthenticationTopx in Inchworm netlist)
#  - Clocks to this entity have been defined (DmaClock and Clk40Mhz)
#      * Note that on PCIe InChWORM, DmaClock is expected to be defined by the
#        corresponding PCIe IP constraints.
#######################################################################

set BasePath CryptoTopGluex/CryptoRegportClockCrossing/RequestHandshake
## Start include, file HandshakeSLV_RSD.xml
set HandshakeSlvRsdPath $BasePath
set BasePath $BasePath/HBx
## Start add from file HandshakeBaseRSD.xdc
# ---------------------------------------------------------------------------------------
# HandshakeBaseRSD
# ---------------------------------------------------------------------------------------
# Save incoming path
set HandshakeBaseRsdPath $BasePath

# Data
set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iStoredDatax/*/*"      -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oData   [get_cells "$BasePath/*oDataFlopx/*/*"        -filter {IS_SEQUENTIAL==true}]
# Toggle
set TNM_HS_iTog    [get_cells "$BasePath/*iPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog_ms [get_cells "$BasePath/*oPushToggle0_msx/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"       -filter {IS_SEQUENTIAL==true}]
# Ready
set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReadyx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"  -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"     -filter {IS_SEQUENTIAL==true}]

# Find out the minimum period of the clocks related to the previous groups.
set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]

# The datapath clock crossings must be less than 2X the period of the destination clock.
set_max_delay  -from $TNM_HS_iData   -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# Toggle
set_false_path -from $TNM_HS_iTog    -to $TNM_HS_oTog_ms
set_max_delay  -from $TNM_HS_oTog_ms -to $TNM_HS_oTog -datapath_only [expr 0.5 * $T_OClkMin]

# The return ready path isn't very important here.
set_false_path -from $TNM_HS_oRdy    -to $TNM_HS_iRdy_ms
set_max_delay  -from $TNM_HS_iRdy_ms -to $TNM_HS_iRdy -datapath_only [expr 0.5 * $T_IClkMin]


set BasePath $HandshakeSlvRsdPath


set BasePath CryptoTopGluex/CryptoRegportClockCrossing/ResponseHandshake
## Start include, file HandshakeSLV_RSD.xml
set HandshakeSlvRsdPath $BasePath
set BasePath $BasePath/HBx
## Start add from file HandshakeBaseRSD.xdc
# ---------------------------------------------------------------------------------------
# HandshakeBaseRSD
# ---------------------------------------------------------------------------------------
# Save incoming path
set HandshakeBaseRsdPath $BasePath

# Data
set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iStoredDatax/*/*"      -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oData   [get_cells "$BasePath/*oDataFlopx/*/*"        -filter {IS_SEQUENTIAL==true}]
# Toggle
set TNM_HS_iTog    [get_cells "$BasePath/*iPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog_ms [get_cells "$BasePath/*oPushToggle0_msx/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"       -filter {IS_SEQUENTIAL==true}]
# Ready
set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReadyx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"  -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"     -filter {IS_SEQUENTIAL==true}]

# Find out the minimum period of the clocks related to the previous groups.
set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]

# The datapath clock crossings must be less than 2X the period of the destination clock.
set_max_delay  -from $TNM_HS_iData   -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# Toggle
set_false_path -from $TNM_HS_iTog    -to $TNM_HS_oTog_ms
set_max_delay  -from $TNM_HS_oTog_ms -to $TNM_HS_oTog -datapath_only [expr 0.5 * $T_OClkMin]

# The return ready path isn't very important here.
set_false_path -from $TNM_HS_oRdy    -to $TNM_HS_iRdy_ms
set_max_delay  -from $TNM_HS_iRdy_ms -to $TNM_HS_iRdy -datapath_only [expr 0.5 * $T_IClkMin]


set BasePath $HandshakeSlvRsdPath


set BasePath CryptoTopGluex/ResetSyncDeassertClk40
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath



# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

set BasePath $ResetSyncDeassertPath


set BasePath CryptoTopGluex/ResetSyncDeassertDmaClock
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath



# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

set BasePath $ResetSyncDeassertPath


set BasePath CryptoTopGluex/KillSynch
## Start include, file DoubleSyncBool.xml
set DoubleSyncBoolPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncBoolPath


set BasePath CryptoTopGluex/DmaClockDoubleSync
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath CryptoTopGluex/ClkDoubleSync
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath CryptoTopGluex/AppRdyDoubleSync
## Start include, file DoubleSyncSL.xml
set DoubleSyncSlPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlPath






current_instance -quiet
current_instance $InchwormNetlist0



set SasquatchTopTemplate2 [current_instance .]
current_instance PcieIpWrapper/PcieIp/inst

set_property LOC PCIE40E4_X0Y0 [get_cells pcie4_uscale_plus_0_pcie_4_0_pipe_inst/pcie_4_0_e4_inst]
set_property USER_CLOCK_ROOT X7Y0 [get_nets -of_objects [get_pins bufg_gt_sysclk/O]]
set_property USER_CLOCK_ROOT X7Y0 [get_nets -of_objects [get_pins -hierarchical -filter NAME=~*/phy_clk_i/bufg_gt_intclk/O]]
set_property USER_CLOCK_ROOT X7Y0 [get_nets -of_objects [get_pins -hierarchical -filter NAME=~*/phy_clk_i/bufg_gt_coreclk/O]]
set_property USER_CLOCK_ROOT X7Y0 [get_nets -of_objects [get_pins -hierarchical -filter NAME=~*/phy_clk_i/bufg_gt_userclk/O]]
set_property USER_CLOCK_ROOT X7Y0 [get_nets -of_objects [get_pins -hierarchical -filter NAME=~*/phy_clk_i/bufg_gt_pclk/O]]
set_property USER_CLOCK_ROOT X7Y0 [get_nets -of_objects [get_pins -hierarchical -filter NAME=~*/phy_clk_i/bufg_gt_mcapclk/O]]


current_instance -quiet
current_instance $SasquatchTopTemplate2

current_instance -quiet
current_instance $SasquatchTopTemplate1

# In order to simplify constraint-writing, we want to give DmaClk a "DmaClk" name.
set DmaClkPins [get_pins -of [get_clocks -of [get_nets DmaClk]]]
create_generated_clock -name DmaClk     $DmaClkPins

set SasquatchTopTemplate1 [current_instance .]
current_instance HostInterfacex/IFifox/IFifoNetlistx
## Start add from file MacallanIFifoN.xdc

###################################################################################
##
##
##
###################################################################################
set MacallanIFifoN0 [current_instance .]
current_instance IFifoCorex
set MacallanIFifoN1 [current_instance .]
current_instance GenAxiStream[0].iFifoWrAxiStreamx/IFifoWriterx
## Start include, file IFifoWriter.xml
set BasePath DmaPortOutStrmFifox
## Start add from file DmaPortOutStrmFifo.xdc
set FlagPath "$BasePath/DmaPortOutStrmFifoFlagsx"
set DpramPath "$BasePath/DmaPortOutStrmDPRAMx"

# ------------------------------------------------------------------------------------
# Create Groups
# ------------------------------------------------------------------------------------

# IClk to OClk Pointer Crossing

# Ack
set TNM_Ptr_oAck [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/oAck*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_iAck_ms [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/iAckRcvd_ms*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_iAck [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/iAckRcvd_*" -filter {IS_SEQUENTIAL==true}]

# Toggle
set TNM_Ptr_iTog [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/iTogglePush*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_oPush_ms [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/oPushRcvd_ms*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_oPush [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/oPushRcvd*" -filter {IS_SEQUENTIAL==true}]

# Data
set TNM_Ptr_iData [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/iDataToPush*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_oData [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/DataReg/GenFlops[*].DFlopx/*" -filter {IS_SEQUENTIAL==true}]

# OClk to IClk Pointer Crossing
set TNM_Ptr_oRdGray [get_cells "$FlagPath/oReadSamplePtrUnsGray*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_iRdGray_ms       [get_cells "$FlagPath/iReadSamplePtrUnsGray_ms*"    -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_iRdGray          [get_cells "$FlagPath/iReadSamplePtrUnsGray_*"    -filter {IS_SEQUENTIAL==true}]

# Fifo Output Data Flop
set TNM_Fifo_oDataFlop     [get_cells "$DpramPath/SimpleDualPortRAM_ByteEnable/GenerateByteWideRams[*].oDataOutAry_reg*" -filter {IS_SEQUENTIAL==true}]

# ------------------------------------------------------------------------------------
# Find Clock Periods
# ------------------------------------------------------------------------------------

set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_Ptr_iAck_ms]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_Ptr_oAck]] ,])"]

# ------------------------------------------------------------------------------------
# Apply proper constraints
# ------------------------------------------------------------------------------------
# Ack DS, with metastable path
set_false_path -from $TNM_Ptr_oAck -to $TNM_Ptr_iAck_ms
set_max_delay -from $TNM_Ptr_iAck_ms -to $TNM_Ptr_iAck [expr 0.5 * $T_IClkMin]

# PushToggle DS, with Metastable Path
set_false_path -from $TNM_Ptr_iTog -to $TNM_Ptr_oPush_ms
set_max_delay -from $TNM_Ptr_oPush_ms -to $TNM_Ptr_oPush [expr 0.5 * $T_OClkMin]

# Path for Pointer Data cannot exceed 2x destination clocks.
set_max_delay -from $TNM_Ptr_iData -to $TNM_Ptr_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# We limit Gray clock-crossing path to 1/2 clock cycle of the *source* clock.
set_max_delay -from $TNM_Ptr_oRdGray -to $TNM_Ptr_iRdGray_ms -datapath_only [expr 0.5 * $T_OClkMin]
set_max_delay -from $TNM_Ptr_iRdGray_ms -to $TNM_Ptr_iRdGray [expr 0.5 * $T_IClkMin]

# We need to tell Vivado to ignore the asynchronous path from the RAM Write Clock (which
# is the IClk domain) to the output FF.
set_false_path -from [get_clocks -of $TNM_Ptr_iAck_ms] -to $TNM_Fifo_oDataFlop


set BasePath DisabledToDmaClk
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]





current_instance -quiet
current_instance $MacallanIFifoN1
set MacallanIFifoN1 [current_instance .]
current_instance GenAxiStream[1].iFifoWrAxiStreamx/IFifoWriterx
## Start include, file IFifoWriter.xml
set BasePath DmaPortOutStrmFifox
## Start add from file DmaPortOutStrmFifo.xdc
set FlagPath "$BasePath/DmaPortOutStrmFifoFlagsx"
set DpramPath "$BasePath/DmaPortOutStrmDPRAMx"

# ------------------------------------------------------------------------------------
# Create Groups
# ------------------------------------------------------------------------------------

# IClk to OClk Pointer Crossing

# Ack
set TNM_Ptr_oAck [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/oAck*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_iAck_ms [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/iAckRcvd_ms*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_iAck [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/iAckRcvd_*" -filter {IS_SEQUENTIAL==true}]

# Toggle
set TNM_Ptr_iTog [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/iTogglePush*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_oPush_ms [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/oPushRcvd_ms*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_oPush [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/oPushRcvd*" -filter {IS_SEQUENTIAL==true}]

# Data
set TNM_Ptr_iData [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/iDataToPush*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_oData [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/DataReg/GenFlops[*].DFlopx/*" -filter {IS_SEQUENTIAL==true}]

# OClk to IClk Pointer Crossing
set TNM_Ptr_oRdGray [get_cells "$FlagPath/oReadSamplePtrUnsGray*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_iRdGray_ms       [get_cells "$FlagPath/iReadSamplePtrUnsGray_ms*"    -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_iRdGray          [get_cells "$FlagPath/iReadSamplePtrUnsGray_*"    -filter {IS_SEQUENTIAL==true}]

# Fifo Output Data Flop
set TNM_Fifo_oDataFlop     [get_cells "$DpramPath/SimpleDualPortRAM_ByteEnable/GenerateByteWideRams[*].oDataOutAry_reg*" -filter {IS_SEQUENTIAL==true}]

# ------------------------------------------------------------------------------------
# Find Clock Periods
# ------------------------------------------------------------------------------------

set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_Ptr_iAck_ms]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_Ptr_oAck]] ,])"]

# ------------------------------------------------------------------------------------
# Apply proper constraints
# ------------------------------------------------------------------------------------
# Ack DS, with metastable path
set_false_path -from $TNM_Ptr_oAck -to $TNM_Ptr_iAck_ms
set_max_delay -from $TNM_Ptr_iAck_ms -to $TNM_Ptr_iAck [expr 0.5 * $T_IClkMin]

# PushToggle DS, with Metastable Path
set_false_path -from $TNM_Ptr_iTog -to $TNM_Ptr_oPush_ms
set_max_delay -from $TNM_Ptr_oPush_ms -to $TNM_Ptr_oPush [expr 0.5 * $T_OClkMin]

# Path for Pointer Data cannot exceed 2x destination clocks.
set_max_delay -from $TNM_Ptr_iData -to $TNM_Ptr_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# We limit Gray clock-crossing path to 1/2 clock cycle of the *source* clock.
set_max_delay -from $TNM_Ptr_oRdGray -to $TNM_Ptr_iRdGray_ms -datapath_only [expr 0.5 * $T_OClkMin]
set_max_delay -from $TNM_Ptr_iRdGray_ms -to $TNM_Ptr_iRdGray [expr 0.5 * $T_IClkMin]

# We need to tell Vivado to ignore the asynchronous path from the RAM Write Clock (which
# is the IClk domain) to the output FF.
set_false_path -from [get_clocks -of $TNM_Ptr_iAck_ms] -to $TNM_Fifo_oDataFlop


set BasePath DisabledToDmaClk
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]





current_instance -quiet
current_instance $MacallanIFifoN1
set MacallanIFifoN1 [current_instance .]
current_instance GenLvFpga[2].iFifoWrLvfpgax/IFifoWriterx
## Start include, file IFifoWriter.xml
set BasePath DmaPortOutStrmFifox
## Start add from file DmaPortOutStrmFifo.xdc
set FlagPath "$BasePath/DmaPortOutStrmFifoFlagsx"
set DpramPath "$BasePath/DmaPortOutStrmDPRAMx"

# ------------------------------------------------------------------------------------
# Create Groups
# ------------------------------------------------------------------------------------

# IClk to OClk Pointer Crossing

# Ack
set TNM_Ptr_oAck [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/oAck*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_iAck_ms [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/iAckRcvd_ms*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_iAck [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/iAckRcvd_*" -filter {IS_SEQUENTIAL==true}]

# Toggle
set TNM_Ptr_iTog [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/iTogglePush*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_oPush_ms [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/oPushRcvd_ms*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_oPush [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/oPushRcvd*" -filter {IS_SEQUENTIAL==true}]

# Data
set TNM_Ptr_iData [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/iDataToPush*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_oData [get_cells "$FlagPath/IClkToOClkCrossing.SyncToOClk/DataReg/GenFlops[*].DFlopx/*" -filter {IS_SEQUENTIAL==true}]

# OClk to IClk Pointer Crossing
set TNM_Ptr_oRdGray [get_cells "$FlagPath/oReadSamplePtrUnsGray*" -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_iRdGray_ms       [get_cells "$FlagPath/iReadSamplePtrUnsGray_ms*"    -filter {IS_SEQUENTIAL==true}]
set TNM_Ptr_iRdGray          [get_cells "$FlagPath/iReadSamplePtrUnsGray_*"    -filter {IS_SEQUENTIAL==true}]

# Fifo Output Data Flop
set TNM_Fifo_oDataFlop     [get_cells "$DpramPath/SimpleDualPortRAM_ByteEnable/GenerateByteWideRams[*].oDataOutAry_reg*" -filter {IS_SEQUENTIAL==true}]

# ------------------------------------------------------------------------------------
# Find Clock Periods
# ------------------------------------------------------------------------------------

set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_Ptr_iAck_ms]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_Ptr_oAck]] ,])"]

# ------------------------------------------------------------------------------------
# Apply proper constraints
# ------------------------------------------------------------------------------------
# Ack DS, with metastable path
set_false_path -from $TNM_Ptr_oAck -to $TNM_Ptr_iAck_ms
set_max_delay -from $TNM_Ptr_iAck_ms -to $TNM_Ptr_iAck [expr 0.5 * $T_IClkMin]

# PushToggle DS, with Metastable Path
set_false_path -from $TNM_Ptr_iTog -to $TNM_Ptr_oPush_ms
set_max_delay -from $TNM_Ptr_oPush_ms -to $TNM_Ptr_oPush [expr 0.5 * $T_OClkMin]

# Path for Pointer Data cannot exceed 2x destination clocks.
set_max_delay -from $TNM_Ptr_iData -to $TNM_Ptr_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# We limit Gray clock-crossing path to 1/2 clock cycle of the *source* clock.
set_max_delay -from $TNM_Ptr_oRdGray -to $TNM_Ptr_iRdGray_ms -datapath_only [expr 0.5 * $T_OClkMin]
set_max_delay -from $TNM_Ptr_iRdGray_ms -to $TNM_Ptr_iRdGray [expr 0.5 * $T_IClkMin]

# We need to tell Vivado to ignore the asynchronous path from the RAM Write Clock (which
# is the IClk domain) to the output FF.
set_false_path -from [get_clocks -of $TNM_Ptr_iAck_ms] -to $TNM_Fifo_oDataFlop


set BasePath DisabledToDmaClk
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]





current_instance -quiet
current_instance $MacallanIFifoN1
set MacallanIFifoN1 [current_instance .]
current_instance GenAxiStream[0].iFifoRdAxiStreamx/GenerateHs.IFifoReaderHsx
## Start include, file IFifoReaderHs.xml
set BasePath HandshakeBaseResetCrossx
## Start add from file HandshakeBaseResetCross.xdc
# ---------------------------------------------------------------------------------------
# HandshakeBaseResetCross
# ---------------------------------------------------------------------------------------
# Save incoming path
set HandshakeBaseResetCrossPath $BasePath

#First create the groups that will be needed later in the -from/to constraints
set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iStoredDatax/*/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oData   [get_cells "$BasePath/BlkOut.oDataFlopx/*/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iTog    [get_cells "$BasePath/BlkIn.iPushTogglex/*/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog_ms [get_cells "$BasePath/BlkOut.oPushToggle0_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"          -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReadyx/*/*"  -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
# Unique to HSBaseResetCross
set TNM_IR_c1ResetFast [get_cells "$BasePath/BlkOut.SyncIReset/c1ResetFastLclx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_IR_c2Reset_ms  [get_cells "$BasePath/BlkOut.SyncIReset/c2Reset_msx/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_IR_c2Reset     [get_cells "$BasePath/BlkOut.SyncIReset/c2ResetLclx/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_IR_c1Reset_ms  [get_cells "$BasePath/BlkOut.SyncIReset/c1ResetFromClk2_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_IR_c1Reset     [get_cells "$BasePath/BlkOut.SyncIReset/c1ResetFromClk2x/*" -filter {IS_SEQUENTIAL==true}]

set TNM_OR_c1ResetFast [get_cells "$BasePath/BlkOut.SyncOReset/c1ResetFastLclx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_OR_c2Reset_ms  [get_cells "$BasePath/BlkOut.SyncOReset/c2Reset_msx/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_OR_c2Reset     [get_cells "$BasePath/BlkOut.SyncOReset/c2ResetLclx/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_OR_c1Reset_ms  [get_cells "$BasePath/BlkOut.SyncOReset/c1ResetFromClk2_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_OR_c1Reset     [get_cells "$BasePath/BlkOut.SyncOReset/c1ResetFromClk2x/*" -filter {IS_SEQUENTIAL==true}]

#Second, find out the minimum period of the clocks related to the previous groups.
set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]
#Third, create constraints that are a function of those clocks

# ------------------------------------------------------------------------------------
# "Regular" Handshake Crossings
# ------------------------------------------------------------------------------------
# The datapath clock crossings must be less than 2X the period of the destination clock.
set_max_delay -from $TNM_HS_iData       -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# Make the Toggle be 1 Output clock cycle to make sure it propagates fast.
set_max_delay -from $TNM_HS_iTog        -to $TNM_HS_oTog_ms -datapath_only [expr 1 * $T_OClkMin]
set_max_delay -from $TNM_HS_oTog_ms     -to $TNM_HS_oTog [expr 0.5 * $T_OClkMin]

# The return ready path isn't very important here.
set_false_path -from $TNM_HS_oRdy       -to $TNM_HS_iRdy_ms
set_max_delay  -from $TNM_HS_iRdy_ms    -to $TNM_HS_iRdy [expr 0.5 * $T_IClkMin]

# ------------------------------------------------------------------------------------
# Reset Crossing Handshake - SyncIReset
# ------------------------------------------------------------------------------------

# Set the maximum delay on the iIResetFast net to be less than 2 IClk periods. Since the
# path we are trying to constrain is from Q of iIResetFast to the async reset pin of
# iPushToggle we don't use "datapath_only".
set_max_delay -from $TNM_IR_c1ResetFast -to $TNM_HS_iTog [expr 2 * $T_IClkMin]

# Constrain the path from iIResetFast to oIReset_ms to ensure oIReset will not arrive too
# late to clear bad toggles.
set_max_delay -from $TNM_IR_c1ResetFast -to $TNM_IR_c2Reset_ms -datapath_only [expr 0.5 * $T_OClkMin]
set_max_delay -from $TNM_IR_c2Reset_ms  -to $TNM_IR_c2Reset  [expr 0.5 * $T_OClkMin]

# And the return reset from c2 to c1 needs to come in under 1 cycle.
set_max_delay -from $TNM_IR_c2Reset -to $TNM_IR_c1Reset_ms -datapath_only [expr 1 * $T_IClkMin]
set_max_delay -from $TNM_IR_c1Reset_ms  -to $TNM_IR_c1Reset  [expr 0.5 * $T_IClkMin]

# ------------------------------------------------------------------------------------
# Reset Crossing Handshake - SyncOReset
# ------------------------------------------------------------------------------------
# Sync O Reset doesn't have the same stringent timing needs that SyncIReset does. It's
# sufficient for the metastable paths to be well constrained, but all clock crossings can
# be false paths. Note that the clock periods are inverted relative to the above since
# SyncOReset "faces" in the opposite direction.

set_false_path -from $TNM_OR_c1ResetFast -to $TNM_OR_c2Reset_ms
set_max_delay -from $TNM_OR_c2Reset_ms -to $TNM_OR_c2Reset [expr 0.5 * $T_IClkMin]

set_false_path -from $TNM_OR_c2Reset -to $TNM_OR_c1Reset_ms
set_max_delay -from $TNM_OR_c1Reset_ms -to $TNM_OR_c1Reset [expr 0.5 * $T_OClkMin]


set MacallanIFifoN3 [current_instance .]
current_instance ReadDisablerx
set BasePath DisableToUserClk
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath DisabledToDmaClk
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]



current_instance -quiet
current_instance $MacallanIFifoN3



current_instance -quiet
current_instance $MacallanIFifoN1
set MacallanIFifoN1 [current_instance .]
current_instance GenAxiStream[1].iFifoRdAxiStreamx/GenerateHs.IFifoReaderHsx
## Start include, file IFifoReaderHs.xml
set BasePath HandshakeBaseResetCrossx
## Start add from file HandshakeBaseResetCross.xdc
# ---------------------------------------------------------------------------------------
# HandshakeBaseResetCross
# ---------------------------------------------------------------------------------------
# Save incoming path
set HandshakeBaseResetCrossPath $BasePath

#First create the groups that will be needed later in the -from/to constraints
set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iStoredDatax/*/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oData   [get_cells "$BasePath/BlkOut.oDataFlopx/*/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iTog    [get_cells "$BasePath/BlkIn.iPushTogglex/*/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog_ms [get_cells "$BasePath/BlkOut.oPushToggle0_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"          -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReadyx/*/*"  -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
# Unique to HSBaseResetCross
set TNM_IR_c1ResetFast [get_cells "$BasePath/BlkOut.SyncIReset/c1ResetFastLclx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_IR_c2Reset_ms  [get_cells "$BasePath/BlkOut.SyncIReset/c2Reset_msx/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_IR_c2Reset     [get_cells "$BasePath/BlkOut.SyncIReset/c2ResetLclx/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_IR_c1Reset_ms  [get_cells "$BasePath/BlkOut.SyncIReset/c1ResetFromClk2_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_IR_c1Reset     [get_cells "$BasePath/BlkOut.SyncIReset/c1ResetFromClk2x/*" -filter {IS_SEQUENTIAL==true}]

set TNM_OR_c1ResetFast [get_cells "$BasePath/BlkOut.SyncOReset/c1ResetFastLclx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_OR_c2Reset_ms  [get_cells "$BasePath/BlkOut.SyncOReset/c2Reset_msx/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_OR_c2Reset     [get_cells "$BasePath/BlkOut.SyncOReset/c2ResetLclx/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_OR_c1Reset_ms  [get_cells "$BasePath/BlkOut.SyncOReset/c1ResetFromClk2_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_OR_c1Reset     [get_cells "$BasePath/BlkOut.SyncOReset/c1ResetFromClk2x/*" -filter {IS_SEQUENTIAL==true}]

#Second, find out the minimum period of the clocks related to the previous groups.
set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]
#Third, create constraints that are a function of those clocks

# ------------------------------------------------------------------------------------
# "Regular" Handshake Crossings
# ------------------------------------------------------------------------------------
# The datapath clock crossings must be less than 2X the period of the destination clock.
set_max_delay -from $TNM_HS_iData       -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# Make the Toggle be 1 Output clock cycle to make sure it propagates fast.
set_max_delay -from $TNM_HS_iTog        -to $TNM_HS_oTog_ms -datapath_only [expr 1 * $T_OClkMin]
set_max_delay -from $TNM_HS_oTog_ms     -to $TNM_HS_oTog [expr 0.5 * $T_OClkMin]

# The return ready path isn't very important here.
set_false_path -from $TNM_HS_oRdy       -to $TNM_HS_iRdy_ms
set_max_delay  -from $TNM_HS_iRdy_ms    -to $TNM_HS_iRdy [expr 0.5 * $T_IClkMin]

# ------------------------------------------------------------------------------------
# Reset Crossing Handshake - SyncIReset
# ------------------------------------------------------------------------------------

# Set the maximum delay on the iIResetFast net to be less than 2 IClk periods. Since the
# path we are trying to constrain is from Q of iIResetFast to the async reset pin of
# iPushToggle we don't use "datapath_only".
set_max_delay -from $TNM_IR_c1ResetFast -to $TNM_HS_iTog [expr 2 * $T_IClkMin]

# Constrain the path from iIResetFast to oIReset_ms to ensure oIReset will not arrive too
# late to clear bad toggles.
set_max_delay -from $TNM_IR_c1ResetFast -to $TNM_IR_c2Reset_ms -datapath_only [expr 0.5 * $T_OClkMin]
set_max_delay -from $TNM_IR_c2Reset_ms  -to $TNM_IR_c2Reset  [expr 0.5 * $T_OClkMin]

# And the return reset from c2 to c1 needs to come in under 1 cycle.
set_max_delay -from $TNM_IR_c2Reset -to $TNM_IR_c1Reset_ms -datapath_only [expr 1 * $T_IClkMin]
set_max_delay -from $TNM_IR_c1Reset_ms  -to $TNM_IR_c1Reset  [expr 0.5 * $T_IClkMin]

# ------------------------------------------------------------------------------------
# Reset Crossing Handshake - SyncOReset
# ------------------------------------------------------------------------------------
# Sync O Reset doesn't have the same stringent timing needs that SyncIReset does. It's
# sufficient for the metastable paths to be well constrained, but all clock crossings can
# be false paths. Note that the clock periods are inverted relative to the above since
# SyncOReset "faces" in the opposite direction.

set_false_path -from $TNM_OR_c1ResetFast -to $TNM_OR_c2Reset_ms
set_max_delay -from $TNM_OR_c2Reset_ms -to $TNM_OR_c2Reset [expr 0.5 * $T_IClkMin]

set_false_path -from $TNM_OR_c2Reset -to $TNM_OR_c1Reset_ms
set_max_delay -from $TNM_OR_c1Reset_ms -to $TNM_OR_c1Reset [expr 0.5 * $T_OClkMin]


set MacallanIFifoN3 [current_instance .]
current_instance ReadDisablerx
set BasePath DisableToUserClk
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath DisabledToDmaClk
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]



current_instance -quiet
current_instance $MacallanIFifoN3



current_instance -quiet
current_instance $MacallanIFifoN1
set MacallanIFifoN1 [current_instance .]
current_instance GenLvFpga[2].iFifoRdLvFpgax/GenerateHs.IFifoReaderHsx
## Start include, file IFifoReaderHs.xml
set BasePath HandshakeBaseResetCrossx
## Start add from file HandshakeBaseResetCross.xdc
# ---------------------------------------------------------------------------------------
# HandshakeBaseResetCross
# ---------------------------------------------------------------------------------------
# Save incoming path
set HandshakeBaseResetCrossPath $BasePath

#First create the groups that will be needed later in the -from/to constraints
set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iStoredDatax/*/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oData   [get_cells "$BasePath/BlkOut.oDataFlopx/*/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iTog    [get_cells "$BasePath/BlkIn.iPushTogglex/*/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog_ms [get_cells "$BasePath/BlkOut.oPushToggle0_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"          -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReadyx/*/*"  -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
# Unique to HSBaseResetCross
set TNM_IR_c1ResetFast [get_cells "$BasePath/BlkOut.SyncIReset/c1ResetFastLclx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_IR_c2Reset_ms  [get_cells "$BasePath/BlkOut.SyncIReset/c2Reset_msx/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_IR_c2Reset     [get_cells "$BasePath/BlkOut.SyncIReset/c2ResetLclx/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_IR_c1Reset_ms  [get_cells "$BasePath/BlkOut.SyncIReset/c1ResetFromClk2_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_IR_c1Reset     [get_cells "$BasePath/BlkOut.SyncIReset/c1ResetFromClk2x/*" -filter {IS_SEQUENTIAL==true}]

set TNM_OR_c1ResetFast [get_cells "$BasePath/BlkOut.SyncOReset/c1ResetFastLclx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_OR_c2Reset_ms  [get_cells "$BasePath/BlkOut.SyncOReset/c2Reset_msx/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_OR_c2Reset     [get_cells "$BasePath/BlkOut.SyncOReset/c2ResetLclx/*"     -filter {IS_SEQUENTIAL==true}]
set TNM_OR_c1Reset_ms  [get_cells "$BasePath/BlkOut.SyncOReset/c1ResetFromClk2_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_OR_c1Reset     [get_cells "$BasePath/BlkOut.SyncOReset/c1ResetFromClk2x/*" -filter {IS_SEQUENTIAL==true}]

#Second, find out the minimum period of the clocks related to the previous groups.
set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]
#Third, create constraints that are a function of those clocks

# ------------------------------------------------------------------------------------
# "Regular" Handshake Crossings
# ------------------------------------------------------------------------------------
# The datapath clock crossings must be less than 2X the period of the destination clock.
set_max_delay -from $TNM_HS_iData       -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# Make the Toggle be 1 Output clock cycle to make sure it propagates fast.
set_max_delay -from $TNM_HS_iTog        -to $TNM_HS_oTog_ms -datapath_only [expr 1 * $T_OClkMin]
set_max_delay -from $TNM_HS_oTog_ms     -to $TNM_HS_oTog [expr 0.5 * $T_OClkMin]

# The return ready path isn't very important here.
set_false_path -from $TNM_HS_oRdy       -to $TNM_HS_iRdy_ms
set_max_delay  -from $TNM_HS_iRdy_ms    -to $TNM_HS_iRdy [expr 0.5 * $T_IClkMin]

# ------------------------------------------------------------------------------------
# Reset Crossing Handshake - SyncIReset
# ------------------------------------------------------------------------------------

# Set the maximum delay on the iIResetFast net to be less than 2 IClk periods. Since the
# path we are trying to constrain is from Q of iIResetFast to the async reset pin of
# iPushToggle we don't use "datapath_only".
set_max_delay -from $TNM_IR_c1ResetFast -to $TNM_HS_iTog [expr 2 * $T_IClkMin]

# Constrain the path from iIResetFast to oIReset_ms to ensure oIReset will not arrive too
# late to clear bad toggles.
set_max_delay -from $TNM_IR_c1ResetFast -to $TNM_IR_c2Reset_ms -datapath_only [expr 0.5 * $T_OClkMin]
set_max_delay -from $TNM_IR_c2Reset_ms  -to $TNM_IR_c2Reset  [expr 0.5 * $T_OClkMin]

# And the return reset from c2 to c1 needs to come in under 1 cycle.
set_max_delay -from $TNM_IR_c2Reset -to $TNM_IR_c1Reset_ms -datapath_only [expr 1 * $T_IClkMin]
set_max_delay -from $TNM_IR_c1Reset_ms  -to $TNM_IR_c1Reset  [expr 0.5 * $T_IClkMin]

# ------------------------------------------------------------------------------------
# Reset Crossing Handshake - SyncOReset
# ------------------------------------------------------------------------------------
# Sync O Reset doesn't have the same stringent timing needs that SyncIReset does. It's
# sufficient for the metastable paths to be well constrained, but all clock crossings can
# be false paths. Note that the clock periods are inverted relative to the above since
# SyncOReset "faces" in the opposite direction.

set_false_path -from $TNM_OR_c1ResetFast -to $TNM_OR_c2Reset_ms
set_max_delay -from $TNM_OR_c2Reset_ms -to $TNM_OR_c2Reset [expr 0.5 * $T_IClkMin]

set_false_path -from $TNM_OR_c2Reset -to $TNM_OR_c1Reset_ms
set_max_delay -from $TNM_OR_c1Reset_ms -to $TNM_OR_c1Reset [expr 0.5 * $T_OClkMin]


set MacallanIFifoN3 [current_instance .]
current_instance ReadDisablerx
set BasePath DisableToUserClk
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath DisabledToDmaClk
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]



current_instance -quiet
current_instance $MacallanIFifoN3



current_instance -quiet
current_instance $MacallanIFifoN1
set MacallanIFifoN1 [current_instance .]
current_instance GenResets[0].iFifoSyncResetMgrx
## Start include, file iFifoSyncResetMgr.xml
set BasePath ToUserClkDS
## Start include, file DoubleSyncBoolRSD.xml
set DoubleSyncBoolRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncBoolRsdPath


set BasePath ToDmaClkDS
## Start include, file DoubleSyncBoolRSD.xml
set DoubleSyncBoolRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncBoolRsdPath


set BasePath ToDmaClkToggling
## Start include, file DoubleSyncBoolRSD.xml
set DoubleSyncBoolRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncBoolRsdPath





current_instance -quiet
current_instance $MacallanIFifoN1
set MacallanIFifoN1 [current_instance .]
current_instance GenResets[1].iFifoSyncResetMgrx
## Start include, file iFifoSyncResetMgr.xml
set BasePath ToUserClkDS
## Start include, file DoubleSyncBoolRSD.xml
set DoubleSyncBoolRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncBoolRsdPath


set BasePath ToDmaClkDS
## Start include, file DoubleSyncBoolRSD.xml
set DoubleSyncBoolRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncBoolRsdPath


set BasePath ToDmaClkToggling
## Start include, file DoubleSyncBoolRSD.xml
set DoubleSyncBoolRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncBoolRsdPath





current_instance -quiet
current_instance $MacallanIFifoN1
set MacallanIFifoN1 [current_instance .]
current_instance GenResets[2].iFifoSyncResetMgrx
## Start include, file iFifoSyncResetMgr.xml
set BasePath ToUserClkDS
## Start include, file DoubleSyncBoolRSD.xml
set DoubleSyncBoolRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncBoolRsdPath


set BasePath ToDmaClkDS
## Start include, file DoubleSyncBoolRSD.xml
set DoubleSyncBoolRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncBoolRsdPath


set BasePath ToDmaClkToggling
## Start include, file DoubleSyncBoolRSD.xml
set DoubleSyncBoolRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncBoolRsdPath





current_instance -quiet
current_instance $MacallanIFifoN1

current_instance -quiet
current_instance $MacallanIFifoN0

# RSD Reset
set_false_path -from [get_cells RsdBusClk/acReset_reg] -to [get_clocks -of [get_nets DmaClk]]





current_instance -quiet
current_instance $SasquatchTopTemplate1


## Start include, file cfmakesasquatch_common.xml
set SasquatchTopTemplate1 [current_instance .]
current_instance HostInterfacex/IwCompanionx/IwCompanionNx
## Start add from file IwCompanion.xdc

###################################################################################
##
##
##
###################################################################################
set BasePath DmaClockRSD
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath



# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

set BasePath $ResetSyncDeassertPath


set BasePath BusClkRSD
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath



# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

set BasePath $ResetSyncDeassertPath


set BasePath LV_RegPortClockCrossing
## Start include, file BaRegPortClockCrossing.xml
set BaRegPortClockCrossingPath $BasePath
set BasePath $BaRegPortClockCrossingPath/RequestHandshake
## Start include, file HandshakeSLV_RSD.xml
set HandshakeSlvRsdPath $BasePath
set BasePath $BasePath/HBx
## Start add from file HandshakeBaseRSD.xdc
# ---------------------------------------------------------------------------------------
# HandshakeBaseRSD
# ---------------------------------------------------------------------------------------
# Save incoming path
set HandshakeBaseRsdPath $BasePath

# Data
set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iStoredDatax/*/*"      -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oData   [get_cells "$BasePath/*oDataFlopx/*/*"        -filter {IS_SEQUENTIAL==true}]
# Toggle
set TNM_HS_iTog    [get_cells "$BasePath/*iPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog_ms [get_cells "$BasePath/*oPushToggle0_msx/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"       -filter {IS_SEQUENTIAL==true}]
# Ready
set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReadyx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"  -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"     -filter {IS_SEQUENTIAL==true}]

# Find out the minimum period of the clocks related to the previous groups.
set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]

# The datapath clock crossings must be less than 2X the period of the destination clock.
set_max_delay  -from $TNM_HS_iData   -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# Toggle
set_false_path -from $TNM_HS_iTog    -to $TNM_HS_oTog_ms
set_max_delay  -from $TNM_HS_oTog_ms -to $TNM_HS_oTog -datapath_only [expr 0.5 * $T_OClkMin]

# The return ready path isn't very important here.
set_false_path -from $TNM_HS_oRdy    -to $TNM_HS_iRdy_ms
set_max_delay  -from $TNM_HS_iRdy_ms -to $TNM_HS_iRdy -datapath_only [expr 0.5 * $T_IClkMin]


set BasePath $HandshakeSlvRsdPath


set BasePath $BaRegPortClockCrossingPath/ResponseHandshake
## Start include, file HandshakeSLV_RSD.xml
set HandshakeSlvRsdPath $BasePath
set BasePath $BasePath/HBx
## Start add from file HandshakeBaseRSD.xdc
# ---------------------------------------------------------------------------------------
# HandshakeBaseRSD
# ---------------------------------------------------------------------------------------
# Save incoming path
set HandshakeBaseRsdPath $BasePath

# Data
set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iStoredDatax/*/*"      -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oData   [get_cells "$BasePath/*oDataFlopx/*/*"        -filter {IS_SEQUENTIAL==true}]
# Toggle
set TNM_HS_iTog    [get_cells "$BasePath/*iPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog_ms [get_cells "$BasePath/*oPushToggle0_msx/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"       -filter {IS_SEQUENTIAL==true}]
# Ready
set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReadyx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"  -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"     -filter {IS_SEQUENTIAL==true}]

# Find out the minimum period of the clocks related to the previous groups.
set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]

# The datapath clock crossings must be less than 2X the period of the destination clock.
set_max_delay  -from $TNM_HS_iData   -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# Toggle
set_false_path -from $TNM_HS_iTog    -to $TNM_HS_oTog_ms
set_max_delay  -from $TNM_HS_oTog_ms -to $TNM_HS_oTog -datapath_only [expr 0.5 * $T_OClkMin]

# The return ready path isn't very important here.
set_false_path -from $TNM_HS_oRdy    -to $TNM_HS_iRdy_ms
set_max_delay  -from $TNM_HS_iRdy_ms -to $TNM_HS_iRdy -datapath_only [expr 0.5 * $T_IClkMin]


set BasePath $HandshakeSlvRsdPath


set BasePath $BaRegPortClockCrossingPath


set IwCompanion0 [current_instance .]
current_instance FakeConfigPortx
## Start include, file FakeConfigPort.xml
set BasePath GaDs[*].GaDsBit
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath





current_instance -quiet
current_instance $IwCompanion0




current_instance -quiet
current_instance $SasquatchTopTemplate1
set SasquatchTopTemplate1 [current_instance .]
current_instance TimingEnginex
## Start add from file PxieUspTimingEngine.xdc

###################################################################################
##
##
##
###################################################################################
set PxieUspTimingEngine0 [current_instance .]
current_instance TimingStage1x
set BasePath PonResetExpander
## Start include, file FilterBoolean.xml
set BasePath $BasePath/FilterStdLogicx
## Start include, file FilterStdLogic.xml
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath







# Prevent recovery analysis on this signal which is used as a fully-asynchronous
# reset despite being the output of a FF.

set_false_path -from [get_cells PonResetExpander/FilterStdLogicx/cOSigLcl_reg*]

set PxieUspTimingEngine1 [current_instance .]
current_instance AllClocksTogglingx
## Start include, file allclockstoggling.xml
set BasePath GenerateSyncs[0].ResetSyncDeassertx
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath



# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

set BasePath $ResetSyncDeassertPath


set BasePath GenerateSyncs[0].DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath


set BasePath GenerateSyncs[1].ResetSyncDeassertx
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath



# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

set BasePath $ResetSyncDeassertPath


set BasePath GenerateSyncs[1].DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath


set BasePath GenerateSyncs[2].ResetSyncDeassertx
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath



# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

set BasePath $ResetSyncDeassertPath


set BasePath GenerateSyncs[2].DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath





current_instance -quiet
current_instance $PxieUspTimingEngine1
set BasePath RsdDlyRefClk
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath



# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

set BasePath $ResetSyncDeassertPath


set PxieUspTimingEngine1 [current_instance .]
current_instance LatchSync100x
set BasePath LatchSync100Blk.MakeDlyReadyReset
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath



current_instance -quiet
current_instance $PxieUspTimingEngine1
set PxieUspTimingEngine1 [current_instance .]
current_instance ReliableClkPllx
## Start add from file ReliableClkPll.xdc

# file: ReliableClkPll.xdc
#
# (c) Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.
#
# This file contains confidential and proprietary information
# of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Xilinx, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the
# possibility of the same.
#
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Xilinx products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.
#

# Input clock periods. These duplicate the values entered for the
# input clocks. You can use these to time your system. If required
# commented constraints can be used in the top level xdc
#----------------------------------------------------------------
#create_clock -period 10.000 [get_ports PxieClk100Lcl]
#set_input_jitter [get_clocks -of_objects [get_ports PxieClk100Lcl]] 0.1


set_false_path -to [get_cells  -hier {*seq_reg*[0]} -filter {is_sequential}]
set_property PHASESHIFT_MODE LATENCY [get_cells -hierarchical *adv*]


## Start add from file ReliableClkPll_late.xdc

# file: ReliableClkPll_late.xdc
#
# (c) Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.
#
# This file contains confidential and proprietary information
# of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Xilinx, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the
# possibility of the same.
#
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Xilinx products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.
#

set_false_path -to [get_cells  -hier {*seq_reg*[0]} -filter {is_sequential}]






current_instance -quiet
current_instance $PxieUspTimingEngine1

current_instance -quiet
current_instance $PxieUspTimingEngine0
set PxieUspTimingEngine0 [current_instance .]
current_instance TimingPcieBlockx
## Start include, file timingpcieblock.xml
set BasePath PcieResetDS
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath


set BasePath PcieCheckDelay
## Start include, file FilterBoolean.xml
set BasePath $BasePath/FilterStdLogicx
## Start include, file FilterStdLogic.xml
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath






set_false_path -from [get_cells PowerOnDelayHack.rPcieResetOut_n_reg*]



current_instance -quiet
current_instance $PxieUspTimingEngine0
set PxieUspTimingEngine0 [current_instance .]
current_instance TimingStage2x
## Start include, file timingstage2.xml
set BasePath PonResetExpander
## Start include, file FilterBoolean.xml
set BasePath $BasePath/FilterStdLogicx
## Start include, file FilterStdLogic.xml
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath






set BasePath aBusResetMinFilter
## Start include, file FilterBoolean.xml
set BasePath $BasePath/FilterStdLogicx
## Start include, file FilterStdLogic.xml
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath






set BasePath BusClkBusResetRsd
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath



# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

set BasePath $ResetSyncDeassertPath


set BasePath DramReset
## Start include, file FilterBoolean.xml
set BasePath $BasePath/FilterStdLogicx
## Start include, file FilterStdLogic.xml
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath






set BasePath DramPllLockedDS
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath


set BasePath Dram0PhyInitDoneDS
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath Dram1PhyInitDoneDS
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath RsdDlyRefClk
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath



# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

set BasePath $ResetSyncDeassertPath


set BasePath LockedStatusDS
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath Clk10EnableDS
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath



# Timing Ignore for any signals that are the outputs of FFs but are treated as
# fully-asynchronous resets. In effect we're avoiding reset recovery analysis.

set resetOrigin [get_cells { \
PonResetExpander/FilterStdLogicx/cOSigLcl_reg* \
aBusResetMinFilter/FilterStdLogicx/cOSigLcl_reg* \
DramReset/FilterStdLogicx/cOSigLcl_reg* } ]

set_false_path -from [get_cells $resetOrigin]

# Also timing ignore on rDramReady because it'll be double-synchronized into the
# user's preferred clock domain.
set_false_path -from [get_cells rDramReady_reg*]





current_instance -quiet
current_instance $PxieUspTimingEngine0
## Start add from file TimingEngine.xdc
# Moving the PLL to reliable clock caused the placement of derived clocks to conflict.
# This constraint allows labview generated PLLs to be placed in non-optimal locations
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets TimingStage1x/PxieClk100]

## Reset false paths

# Here are some other pins we want false-pathed, which are synchronous signals being used
# as asynchronous resets where we don't want to make the whole signal a false path, just
# this particular usage.
set FalsePaths [get_pins {\
TimingStage1x/RsdDlyRefClk/aReset \
TimingStage2x/RsdDlyRefClk/rPllClocksValidStg1 \
TimingStage2x/aIntClk10} ]

set_false_path -through [get_pins $FalsePaths]

# Group the 80MHz PllClk80 and 240MHz MbClk clocks into a group to reduce skew between clocks
set_property CLOCK_DELAY_GROUP MicroBlazeClockGrp [get_nets {TimingStage1x/ReliableClkPllx/inst/PllClk80 TimingStage1x/ReliableClkPllx/inst/MbClk}]





current_instance -quiet
current_instance $SasquatchTopTemplate1
set SasquatchTopTemplate1 [current_instance .]
current_instance FixedLogicWrapperx/MacallanFixedLogicx
## Start add from file MacallanFixedLogic.xdc

###################################################################################
##
##
##
###################################################################################
set BasePath DmaClockRSD
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath



# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

set BasePath $ResetSyncDeassertPath


set BasePath BusClockRSD
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath



# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

set BasePath $ResetSyncDeassertPath


set BasePath BusClkDiagramRSD
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath


set BasePath $DoubleSyncBoolAsyncInPath



# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

set BasePath $ResetSyncDeassertPath


set MacallanFixedLogic0 [current_instance .]
current_instance BoardControlx/AxiStreamCpldSidebandx/SidebandTxx
set BasePath FifoFullDs
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath



current_instance -quiet
current_instance $MacallanFixedLogic0
set MacallanFixedLogic0 [current_instance .]
current_instance BoardControlx/AxiStreamCpldSidebandx/SidebandRxx
set BasePath RxDataDs
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlAsyncInPath



current_instance -quiet
current_instance $MacallanFixedLogic0
set MacallanFixedLogic0 [current_instance .]
current_instance BusRegPortClockCrossing
set BasePath RequestHandshake
## Start include, file HandshakeSLV_RSD.xml
set HandshakeSlvRsdPath $BasePath
set BasePath $BasePath/HBx
## Start add from file HandshakeBaseRSD.xdc
# ---------------------------------------------------------------------------------------
# HandshakeBaseRSD
# ---------------------------------------------------------------------------------------
# Save incoming path
set HandshakeBaseRsdPath $BasePath

# Data
set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iStoredDatax/*/*"      -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oData   [get_cells "$BasePath/*oDataFlopx/*/*"        -filter {IS_SEQUENTIAL==true}]
# Toggle
set TNM_HS_iTog    [get_cells "$BasePath/*iPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog_ms [get_cells "$BasePath/*oPushToggle0_msx/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"       -filter {IS_SEQUENTIAL==true}]
# Ready
set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReadyx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"  -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"     -filter {IS_SEQUENTIAL==true}]

# Find out the minimum period of the clocks related to the previous groups.
set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]

# The datapath clock crossings must be less than 2X the period of the destination clock.
set_max_delay  -from $TNM_HS_iData   -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# Toggle
set_false_path -from $TNM_HS_iTog    -to $TNM_HS_oTog_ms
set_max_delay  -from $TNM_HS_oTog_ms -to $TNM_HS_oTog -datapath_only [expr 0.5 * $T_OClkMin]

# The return ready path isn't very important here.
set_false_path -from $TNM_HS_oRdy    -to $TNM_HS_iRdy_ms
set_max_delay  -from $TNM_HS_iRdy_ms -to $TNM_HS_iRdy -datapath_only [expr 0.5 * $T_IClkMin]


set BasePath $HandshakeSlvRsdPath


set BasePath ResponseHandshake
## Start include, file HandshakeSLV_RSD.xml
set HandshakeSlvRsdPath $BasePath
set BasePath $BasePath/HBx
## Start add from file HandshakeBaseRSD.xdc
# ---------------------------------------------------------------------------------------
# HandshakeBaseRSD
# ---------------------------------------------------------------------------------------
# Save incoming path
set HandshakeBaseRsdPath $BasePath

# Data
set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iStoredDatax/*/*"      -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oData   [get_cells "$BasePath/*oDataFlopx/*/*"        -filter {IS_SEQUENTIAL==true}]
# Toggle
set TNM_HS_iTog    [get_cells "$BasePath/*iPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog_ms [get_cells "$BasePath/*oPushToggle0_msx/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"       -filter {IS_SEQUENTIAL==true}]
# Ready
set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReadyx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"  -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"     -filter {IS_SEQUENTIAL==true}]

# Find out the minimum period of the clocks related to the previous groups.
set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]

# The datapath clock crossings must be less than 2X the period of the destination clock.
set_max_delay  -from $TNM_HS_iData   -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# Toggle
set_false_path -from $TNM_HS_iTog    -to $TNM_HS_oTog_ms
set_max_delay  -from $TNM_HS_oTog_ms -to $TNM_HS_oTog -datapath_only [expr 0.5 * $T_OClkMin]

# The return ready path isn't very important here.
set_false_path -from $TNM_HS_oRdy    -to $TNM_HS_iRdy_ms
set_max_delay  -from $TNM_HS_iRdy_ms -to $TNM_HS_iRdy -datapath_only [expr 0.5 * $T_IClkMin]


set BasePath $HandshakeSlvRsdPath



current_instance -quiet
current_instance $MacallanFixedLogic0
set MacallanFixedLogic0 [current_instance .]
current_instance BoardControlx
set BasePath IrqFromFixedLogicDS
## Start include, file DoubleSyncSL_RSD.xml
set DoubleSyncSlRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlRsdPath



current_instance -quiet
current_instance $MacallanFixedLogic0
## Start add from file FixedLogic.xdc

set_property LOC SYSMONE4_X0Y0 [get_cells BoardControlx/SysMon0/SYSMONE1x]
set_property LOC SYSMONE4_X0Y1 [get_cells BoardControlx/SysMon1/SYSMONE1x]
set_property LOC SYSMONE4_X0Y2 [get_cells BoardControlx/SysMon2/SYSMONE1x]




## Start add from file MacallanFixedLogic_mod.xdc
set MacallanFixedLogicInst [current_instance .]

####################################################################################
# Generated by Vivado 2021.1 built on 'Thu Jun 10 19:36:07 MDT 2021' by 'xbuild'
# Command Used: write_xdc -force -exclude_physical /home/rfmibuild/myagent/_work/1366/s/hw-flexrio/fixedlogic/objects/tool/synth_sasquatchfixedlogic/output/MacallanFixedLogic.xdc
####################################################################################


####################################################################################
# Constraints from file : 'xpm_cdc_gray.tcl'
####################################################################################

current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_1/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.rd_pntr_cdc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.wr_pntr_cdc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.rd_pntr_cdc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_1/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.wr_pntr_cdc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_1/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.rd_pntr_cdc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_1/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.wr_pntr_cdc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.wr_pntr_cdc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.rd_pntr_cdc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_1/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.wr_pntr_cdc_dc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.wr_pntr_cdc_dc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.wr_pntr_cdc_dc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_1/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.wr_pntr_cdc_dc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_1/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.rd_pntr_cdc_dc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.rd_pntr_cdc_dc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.rd_pntr_cdc_dc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_1/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.rd_pntr_cdc_dc_inst
set_max_delay -datapath_only -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000
set_bus_skew -from [get_cells src_gray_ff_reg*] -to [get_cells {dest_graysync_ff_reg[0]*}] 1000.000

####################################################################################
# Constraints from file : 'xpm_cdc_sync_rst.tcl'
####################################################################################

current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_1/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/xpm_fifo_rst_inst/gen_rst_ic.rrst_wr_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/xpm_fifo_rst_inst/gen_rst_ic.wrst_rd_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/xpm_fifo_rst_inst/gen_rst_ic.rrst_wr_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_1/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/xpm_fifo_rst_inst/gen_rst_ic.wrst_rd_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_1/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/xpm_fifo_rst_inst/gen_rst_ic.rrst_wr_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_1/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/xpm_fifo_rst_inst/gen_rst_ic.wrst_rd_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/xpm_fifo_rst_inst/gen_rst_ic.wrst_rd_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $MacallanFixedLogicInst
current_instance BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/xpm_fifo_rst_inst/gen_rst_ic.rrst_wr_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]

# Vivado Generated miscellaneous constraints

#revert back to original instance
current_instance -quiet
current_instance $MacallanFixedLogicInst



current_instance -quiet
current_instance $SasquatchTopTemplate1
## Start add from file TimingCommon.xdc
##################### TIMING CONSTRAINTS #######################

#########################################################################################
# Stage2Done
#
# The timing of this pin is unimportant. We'll set an absurd output delay.
set_output_delay -max -5 [get_ports aFpgaStage2Done]
set_output_delay -min 5 [get_ports aFpgaStage2Done]

#########################################################################################
## CPLD Sideband
#########################################################################################

set BusClkSourcePin [get_pins -of_objects [get_clocks $BusClk]]

create_generated_clock \
-name SidebandClk \
-source [get_pins $BusClkSourcePin] \
-multiply_by 1 \
-invert [get_ports SidebandClk]

set SidebandIntfTsu       2.000; # destination device setup time requirement
set SidebandIntfThd       2.000; # destination device hold time requirement
set SidebandIntfTraceSkew 1.000; # Allowed skew between traces

set SidebandDataOutPins [get_ports sSidebandDataOut*]

# Output Delay Constraints
set_output_delay \
-clock [get_clocks SidebandClk] \
-max [expr $SidebandIntfTsu + $SidebandIntfTraceSkew] \
[get_ports $SidebandDataOutPins];

set_output_delay \
-clock [get_clocks SidebandClk] \
-min [expr - ($SidebandIntfThd + $SidebandIntfTraceSkew)] \
[get_ports $SidebandDataOutPins];

# False path FAM output enable to all the pins
set_false_path -from [get_pins FixedLogicWrapperx/MacallanFixedLogicx/BoardControlx/BoardControlAxiRegistersx/CommonAxiRegistersx/bFamOutputsEnabledLcl_reg/C] -to [get_ports]

## Start add from file TimingSasquatch.xdc
###################
## PXIe Sync and clock generation
###################

set InputClock   [get_clocks PxieClk100]
set T_InputClock [get_property PERIOD $InputClock]; # Period of input clock
set InputPorts   pPxieSync100_p;                    # List of input ports

set Sync100Setup 3.0
set Sync100Hold  1.0

set Sync100SetupDlyMax [expr $T_InputClock - $Sync100Setup]

set SignalPropMin 0.15
set SignalPropMax 0.8

set PxiClk100BufPropMin 0.15
set PxiClk100BufPropMax 0.22

set PxiSync100BufPropMin 0.07
set PxiSync100BufPropMax 0.13

# Setup calculations
set MaxDataDelay [expr $Sync100SetupDlyMax + $SignalPropMax + $PxiSync100BufPropMax]
set MinClockDelay [expr $SignalPropMin + $PxiClk100BufPropMin]

# Hold calculations
set MinDataDelay [expr $Sync100Hold + $SignalPropMin + $PxiSync100BufPropMin]
set MaxClockDelay [expr $SignalPropMax + $PxiClk100BufPropMax]

# Input Delay Constraint
set_input_delay -clock $InputClock \
-max [expr $MaxDataDelay - $MinClockDelay] \
[get_ports $InputPorts]

set_input_delay -clock $InputClock \
-min [expr $MinDataDelay - $MaxClockDelay] \
[get_ports $InputPorts]

# We also want to put that FF in an IOB for better timing:
set_property IOB TRUE [get_ports $InputPorts]

## Calculations for Clk10 Generator

set SignalPropMin 0.0
set SignalPropMax 1

set LvpeclFlopTsu       0.1
set LvpeclFlopTh        0.5

set PxiClk100BufSkewMax 0.28

#########################################################################################
# Global Address
#
# These pins are static signals that should settle way before the FPGA is even configured
# (let alone out of reset), and will not change thereafter. But they still need input
# delays to pass Xilinx's timing check. We'll make those input delays really preposterous.

set InputPorts [get_ports {aPxiGa[?]}]
set_input_delay -max -5 [get_ports $InputPorts]
set_input_delay -min 5 [get_ports $InputPorts]

#########################################################################################
# Stage 1 output tristates
set_false_path -through [get_nets SasquatchIoBuffersStage1x/aStage2Enabled]


## Start add from file PinsSasquatch.xdc
######################################################
# Configuration setup
######################################################
# We've tied CFGBVS to GND to support 1.8V configuration
set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
# Temporarily placing this in here to avoid dealing with XML resource files

set_property config_mode S_SELECTMAP [current_design]

# CSO_B may NOT be used in stage 2 logic for Tandem PROM using slave SelectMap
set_property PROHIBIT TRUE [get_sites  AL28 ]

###################################################
# HSS
###################################################
set_property PACKAGE_PIN BA40 [get_ports MgtRefClk_p[0]]
set_property PACKAGE_PIN AV38 [get_ports MgtRefClk_p[1]]
set_property PACKAGE_PIN AR36 [get_ports MgtRefClk_p[2]]
set_property PACKAGE_PIN AL36 [get_ports MgtRefClk_p[3]]
set_property PACKAGE_PIN AD11 [get_ports MgtRefClk_p[4]]
set_property PACKAGE_PIN Y11  [get_ports MgtRefClk_p[5]]
set_property PACKAGE_PIN T11  [get_ports MgtRefClk_p[6]]
set_property PACKAGE_PIN M11  [get_ports MgtRefClk_p[7]]
set_property PACKAGE_PIN AG36 [get_ports MgtRefClk_p[8]]
set_property PACKAGE_PIN AC36 [get_ports MgtRefClk_p[9]]
set_property PACKAGE_PIN W36  [get_ports MgtRefClk_p[10]]
set_property PACKAGE_PIN R36  [get_ports MgtRefClk_p[11]]

# The zHD connector signals TX0 and TX1 as well as RX0 and RX1 are swapped on the schematic,
# similar to all other cabled PCIe NI products, to simplify the layout routing
set_property PACKAGE_PIN BD42 [get_ports MgtPortTxLane0_p]
set_property PACKAGE_PIN BF42 [get_ports MgtPortTxLane1_p]
set_property PACKAGE_PIN BB42 [get_ports MgtPortTxLane2_p]
set_property PACKAGE_PIN AW40 [get_ports MgtPortTxLane3_p]
set_property PACKAGE_PIN AT38 [get_ports MgtPortTxLane4_p]
set_property PACKAGE_PIN AU40 [get_ports MgtPortTxLane5_p]
set_property PACKAGE_PIN AR40 [get_ports MgtPortTxLane6_p]
set_property PACKAGE_PIN AP38 [get_ports MgtPortTxLane7_p]
set_property PACKAGE_PIN AM38 [get_ports MgtPortTxLane8_p]
set_property PACKAGE_PIN AN40 [get_ports MgtPortTxLane9_p]
set_property PACKAGE_PIN AL40 [get_ports MgtPortTxLane10_p]
set_property PACKAGE_PIN AK38 [get_ports MgtPortTxLane11_p]
set_property PACKAGE_PIN AH38 [get_ports MgtPortTxLane12_p]
set_property PACKAGE_PIN AJ40 [get_ports MgtPortTxLane13_p]
set_property PACKAGE_PIN AG40 [get_ports MgtPortTxLane14_p]
set_property PACKAGE_PIN AF38 [get_ports MgtPortTxLane15_p]
set_property PACKAGE_PIN AD7  [get_ports MgtPortTxLane16_p]
set_property PACKAGE_PIN AE9  [get_ports MgtPortTxLane17_p]
set_property PACKAGE_PIN AC9  [get_ports MgtPortTxLane18_p]
set_property PACKAGE_PIN AB7  [get_ports MgtPortTxLane19_p]
set_property PACKAGE_PIN Y7   [get_ports MgtPortTxLane20_p]
set_property PACKAGE_PIN AA9  [get_ports MgtPortTxLane21_p]
set_property PACKAGE_PIN W9   [get_ports MgtPortTxLane22_p]
set_property PACKAGE_PIN V7   [get_ports MgtPortTxLane23_p]
set_property PACKAGE_PIN T7   [get_ports MgtPortTxLane24_p]
set_property PACKAGE_PIN U9   [get_ports MgtPortTxLane25_p]
set_property PACKAGE_PIN R9   [get_ports MgtPortTxLane26_p]
set_property PACKAGE_PIN P7   [get_ports MgtPortTxLane27_p]
set_property PACKAGE_PIN M7   [get_ports MgtPortTxLane28_p]
set_property PACKAGE_PIN N9   [get_ports MgtPortTxLane29_p]
set_property PACKAGE_PIN L9   [get_ports MgtPortTxLane30_p]
set_property PACKAGE_PIN K7   [get_ports MgtPortTxLane31_p]
set_property PACKAGE_PIN AD38 [get_ports MgtPortTxLane32_p]
set_property PACKAGE_PIN AE40 [get_ports MgtPortTxLane33_p]
set_property PACKAGE_PIN AC40 [get_ports MgtPortTxLane34_p]
set_property PACKAGE_PIN AB38 [get_ports MgtPortTxLane35_p]
set_property PACKAGE_PIN Y38  [get_ports MgtPortTxLane36_p]
set_property PACKAGE_PIN AA40 [get_ports MgtPortTxLane37_p]
set_property PACKAGE_PIN W40  [get_ports MgtPortTxLane38_p]
set_property PACKAGE_PIN V38  [get_ports MgtPortTxLane39_p]
set_property PACKAGE_PIN T38  [get_ports MgtPortTxLane40_p]
set_property PACKAGE_PIN U40  [get_ports MgtPortTxLane41_p]
set_property PACKAGE_PIN R40  [get_ports MgtPortTxLane42_p]
set_property PACKAGE_PIN P38  [get_ports MgtPortTxLane43_p]
set_property PACKAGE_PIN M38  [get_ports MgtPortTxLane44_p]
set_property PACKAGE_PIN N40  [get_ports MgtPortTxLane45_p]
set_property PACKAGE_PIN L40  [get_ports MgtPortTxLane46_p]
set_property PACKAGE_PIN J40  [get_ports MgtPortTxLane47_p]

# The zHD connector signals TX0 and TX1 as well as RX0 and RX1 are swapped on the schematic,
# similar to all other cabled PCIe NI products, to simplify the layout routing
set_property PACKAGE_PIN BA45 [get_ports MgtPortRxLane0_p]
set_property PACKAGE_PIN BC45 [get_ports MgtPortRxLane1_p]
set_property PACKAGE_PIN AW45 [get_ports MgtPortRxLane2_p]
set_property PACKAGE_PIN AV43 [get_ports MgtPortRxLane3_p]
set_property PACKAGE_PIN AT43 [get_ports MgtPortRxLane4_p]
set_property PACKAGE_PIN AU45 [get_ports MgtPortRxLane5_p]
set_property PACKAGE_PIN AR45 [get_ports MgtPortRxLane6_p]
set_property PACKAGE_PIN AP43 [get_ports MgtPortRxLane7_p]
set_property PACKAGE_PIN AM43 [get_ports MgtPortRxLane8_p]
set_property PACKAGE_PIN AN45 [get_ports MgtPortRxLane9_p]
set_property PACKAGE_PIN AL45 [get_ports MgtPortRxLane10_p]
set_property PACKAGE_PIN AK43 [get_ports MgtPortRxLane11_p]
set_property PACKAGE_PIN AH43 [get_ports MgtPortRxLane12_p]
set_property PACKAGE_PIN AJ45 [get_ports MgtPortRxLane13_p]
set_property PACKAGE_PIN AG45 [get_ports MgtPortRxLane14_p]
set_property PACKAGE_PIN AF43 [get_ports MgtPortRxLane15_p]
set_property PACKAGE_PIN AD2  [get_ports MgtPortRxLane16_p]
set_property PACKAGE_PIN AE4  [get_ports MgtPortRxLane17_p]
set_property PACKAGE_PIN AC4  [get_ports MgtPortRxLane18_p]
set_property PACKAGE_PIN AB2  [get_ports MgtPortRxLane19_p]
set_property PACKAGE_PIN Y2   [get_ports MgtPortRxLane20_p]
set_property PACKAGE_PIN AA4  [get_ports MgtPortRxLane21_p]
set_property PACKAGE_PIN W4   [get_ports MgtPortRxLane22_p]
set_property PACKAGE_PIN V2   [get_ports MgtPortRxLane23_p]
set_property PACKAGE_PIN T2   [get_ports MgtPortRxLane24_p]
set_property PACKAGE_PIN U4   [get_ports MgtPortRxLane25_p]
set_property PACKAGE_PIN R4   [get_ports MgtPortRxLane26_p]
set_property PACKAGE_PIN P2   [get_ports MgtPortRxLane27_p]
set_property PACKAGE_PIN M2   [get_ports MgtPortRxLane28_p]
set_property PACKAGE_PIN N4   [get_ports MgtPortRxLane29_p]
set_property PACKAGE_PIN L4   [get_ports MgtPortRxLane30_p]
set_property PACKAGE_PIN K2   [get_ports MgtPortRxLane31_p]
set_property PACKAGE_PIN AD43 [get_ports MgtPortRxLane32_p]
set_property PACKAGE_PIN AE45 [get_ports MgtPortRxLane33_p]
set_property PACKAGE_PIN AC45 [get_ports MgtPortRxLane34_p]
set_property PACKAGE_PIN AB43 [get_ports MgtPortRxLane35_p]
set_property PACKAGE_PIN Y43  [get_ports MgtPortRxLane36_p]
set_property PACKAGE_PIN AA45 [get_ports MgtPortRxLane37_p]
set_property PACKAGE_PIN W45  [get_ports MgtPortRxLane38_p]
set_property PACKAGE_PIN V43  [get_ports MgtPortRxLane39_p]
set_property PACKAGE_PIN T43  [get_ports MgtPortRxLane40_p]
set_property PACKAGE_PIN U45  [get_ports MgtPortRxLane41_p]
set_property PACKAGE_PIN R45  [get_ports MgtPortRxLane42_p]
set_property PACKAGE_PIN P43  [get_ports MgtPortRxLane43_p]
set_property PACKAGE_PIN M43  [get_ports MgtPortRxLane44_p]
set_property PACKAGE_PIN N45  [get_ports MgtPortRxLane45_p]
set_property PACKAGE_PIN L45  [get_ports MgtPortRxLane46_p]
set_property PACKAGE_PIN K43  [get_ports MgtPortRxLane47_p]

set_property PACKAGE_PIN BF13 [get_ports aLmkI2cSda]
set_property PACKAGE_PIN BF14 [get_ports aLmkI2cScl]
set_property IOSTANDARD LVCMOS18 [get_ports aLmkI2cSda]
set_property IOSTANDARD LVCMOS18 [get_ports aLmkI2cScl]

set_property PACKAGE_PIN BB24 [get_ports aLmk1Pdn_n]
set_property PACKAGE_PIN BA24 [get_ports aLmk2Pdn_n]
set_property PACKAGE_PIN BC22 [get_ports aLmk1Gpio0]
set_property PACKAGE_PIN BB22 [get_ports aLmk2Gpio0]
set_property PACKAGE_PIN BA23 [get_ports aLmk1Status0]
set_property PACKAGE_PIN BA22 [get_ports aLmk1Status1]
set_property PACKAGE_PIN AY22 [get_ports aLmk2Status0]
set_property PACKAGE_PIN AY23 [get_ports aLmk2Status1]

set_property IOSTANDARD LVCMOS18 [get_ports aLmk1Pdn_n]
set_property IOSTANDARD LVCMOS18 [get_ports aLmk2Pdn_n]
set_property IOSTANDARD LVCMOS18 [get_ports aLmk1Gpio0]
set_property IOSTANDARD LVCMOS18 [get_ports aLmk2Gpio0]
set_property IOSTANDARD LVCMOS18 [get_ports aLmk1Status0]
set_property IOSTANDARD LVCMOS18 [get_ports aLmk1Status1]
set_property IOSTANDARD LVCMOS18 [get_ports aLmk2Status0]
set_property IOSTANDARD LVCMOS18 [get_ports aLmk2Status1]

set_property PACKAGE_PIN BE15 [get_ports  aIPassVccPowerFault_n]
set_property IOSTANDARD LVCMOS18 [get_ports aIPassVccPowerFault_n]

set_property PACKAGE_PIN BD20 [get_ports  aIPassPrsnt_n[0]]
set_property PACKAGE_PIN BF23 [get_ports  aIPassPrsnt_n[1]]
set_property PACKAGE_PIN BD24 [get_ports  aIPassPrsnt_n[2]]
set_property PACKAGE_PIN AR23 [get_ports  aIPassPrsnt_n[3]]
set_property PACKAGE_PIN AP24 [get_ports  aIPassPrsnt_n[4]]
set_property PACKAGE_PIN AM22 [get_ports  aIPassPrsnt_n[5]]
set_property PACKAGE_PIN AM24 [get_ports  aIPassPrsnt_n[6]]
set_property PACKAGE_PIN AM21 [get_ports  aIPassPrsnt_n[7]]
set_property IOSTANDARD LVCMOS18 [get_ports aIPassPrsnt_n[*]]

set_property PACKAGE_PIN BE20 [get_ports  aIPassIntr_n[0]]
set_property PACKAGE_PIN BF22 [get_ports  aIPassIntr_n[1]]
set_property PACKAGE_PIN BE22 [get_ports  aIPassIntr_n[2]]
set_property PACKAGE_PIN AT23 [get_ports  aIPassIntr_n[3]]
set_property PACKAGE_PIN AN24 [get_ports  aIPassIntr_n[4]]
set_property PACKAGE_PIN AL22 [get_ports  aIPassIntr_n[5]]
set_property PACKAGE_PIN AL24 [get_ports  aIPassIntr_n[6]]
set_property PACKAGE_PIN AL21 [get_ports  aIPassIntr_n[7]]
set_property IOSTANDARD LVCMOS18 [get_ports aIPassIntr_n[*]]

set_property PACKAGE_PIN BD21 [get_ports  aIPassSCL[0]]
set_property PACKAGE_PIN BE21 [get_ports  aIPassSDA[0]]
set_property PACKAGE_PIN BF24 [get_ports  aIPassSCL[1]]
set_property PACKAGE_PIN BE23 [get_ports  aIPassSDA[1]]
set_property PACKAGE_PIN BD23 [get_ports  aIPassSCL[2]]
set_property PACKAGE_PIN BC21 [get_ports  aIPassSDA[2]]
set_property PACKAGE_PIN BC24 [get_ports  aIPassSCL[3]]
set_property PACKAGE_PIN BB21 [get_ports  aIPassSDA[3]]
set_property PACKAGE_PIN BB20 [get_ports  aIPassSCL[4]]
set_property PACKAGE_PIN BA20 [get_ports  aIPassSDA[4]]
set_property PACKAGE_PIN AN21 [get_ports  aIPassSCL[5]]
set_property PACKAGE_PIN AN22 [get_ports  aIPassSDA[5]]
set_property PACKAGE_PIN AU24 [get_ports  aIPassSCL[6]]
set_property PACKAGE_PIN AT24 [get_ports  aIPassSDA[6]]
set_property PACKAGE_PIN AP23 [get_ports  aIPassSCL[7]]
set_property PACKAGE_PIN AN23 [get_ports  aIPassSDA[7]]
set_property PACKAGE_PIN BA30 [get_ports  aIPassSCL[8] ]
set_property PACKAGE_PIN BA32 [get_ports  aIPassSDA[8] ]
set_property PACKAGE_PIN BB29 [get_ports  aIPassSCL[9] ]
set_property PACKAGE_PIN BE30 [get_ports  aIPassSDA[9] ]
set_property PACKAGE_PIN BB32 [get_ports  aIPassSCL[10]]
set_property PACKAGE_PIN BA29 [get_ports  aIPassSDA[10]]
set_property PACKAGE_PIN BE32 [get_ports  aIPassSCL[11]]
set_property PACKAGE_PIN BD31 [get_ports  aIPassSDA[11]]
set_property IOSTANDARD LVCMOS18 [get_ports aIPassSCL[*]]
set_property IOSTANDARD LVCMOS18 [get_ports aIPassSDA[*]]

set_property PACKAGE_PIN AL30 [get_ports  aPortExpReset_n]
set_property PACKAGE_PIN AN31 [get_ports  aPortExpIntr_n ]
set_property PACKAGE_PIN AY32 [get_ports  aPortExpSda    ]
set_property PACKAGE_PIN AY30 [get_ports  aPortExpScl    ]

set_property IOSTANDARD LVCMOS18 [get_ports  aPortExpReset_n]
set_property IOSTANDARD LVCMOS18 [get_ports  aPortExpIntr_n ]
set_property IOSTANDARD LVCMOS18 [get_ports  aPortExpSda    ]
set_property IOSTANDARD LVCMOS18 [get_ports  aPortExpScl    ]

###################################################
# Management
###################################################
set_property PACKAGE_PIN AY26 [get_ports Osc100ClkIn]

set_property PACKAGE_PIN BE16 [get_ports bBaseSmbScl]
set_property PACKAGE_PIN BF15 [get_ports bBaseSmbSda]
set_property PACKAGE_PIN AR13 [get_ports aBaseSmbAlert_n]

set_property PACKAGE_PIN AP31 [get_ports  bMezzSmbScl]
set_property PACKAGE_PIN AP29 [get_ports  bMezzSmbSda]

set_property PACKAGE_PIN BE13 [get_ports bConfigI2cScl]
set_property PACKAGE_PIN BD13 [get_ports bConfigI2cSda]

set_property PACKAGE_PIN BB15 [get_ports bPwrSupplyPmbScl]
set_property PACKAGE_PIN BB16 [get_ports bPwrSupplyPmbSda]
set_property PACKAGE_PIN AY16 [get_ports aPwrSupplyPmbAlert_n]

set_property PACKAGE_PIN AR16 [get_ports aIoRefClk100En]

set_property PACKAGE_PIN BA28 [get_ports aAuthSda]

set_property PACKAGE_PIN AW23 [get_ports SidebandClk]
set_property PACKAGE_PIN AV23 [get_ports {sSidebandDataOut[0]}]
set_property PACKAGE_PIN AU22 [get_ports {sSidebandDataOut[1]}]
set_property PACKAGE_PIN AV22 [get_ports {sSidebandDataOut[2]}]
set_property PACKAGE_PIN AT22 [get_ports {sSidebandDataOut[3]}]
set_property PACKAGE_PIN AV24 [get_ports aSidebandDataIn]
set_property PACKAGE_PIN AR22 [get_ports aSidebandFifoFull]
#schematic signal name is Fpga_Cpld_Spare
set_property PACKAGE_PIN AW24 [get_ports aFpgaStage2Done]

set_property PACKAGE_PIN AM14 [get_ports aFldUpdJtagSel]
set_property PACKAGE_PIN AN13 [get_ports bFldUpdJtagTck]
set_property PACKAGE_PIN AL15 [get_ports bFldUpdJtagTdi]
set_property PACKAGE_PIN AM15 [get_ports aFldUpdJtagTdo]
set_property PACKAGE_PIN AL14 [get_ports bFldUpdJtagTms]


set_property PROHIBIT TRUE [get_sites AM26 ];  # fFpgaConfigData[4]
set_property PROHIBIT TRUE [get_sites AN26 ];  # fFpgaConfigData[5]
set_property PROHIBIT TRUE [get_sites AL25 ];  # fFpgaConfigData[6]
set_property PROHIBIT TRUE [get_sites AM25 ];  # fFpgaConfigData[7]

set_property IOSTANDARD LVCMOS18 [get_ports Osc100ClkIn]

set_property IOSTANDARD LVCMOS18 [get_ports bBaseSmb*]
set_property IOSTANDARD LVCMOS18 [get_ports aBaseSmbAlert_n]

set_property IOSTANDARD LVCMOS18 [get_ports bMezzSmb*]

set_property IOSTANDARD LVCMOS18 [get_ports bConfigI2c*]

set_property IOSTANDARD LVCMOS18 [get_ports bPwrSupplyPmb*]
set_property IOSTANDARD LVCMOS18 [get_ports aPwrSupplyPmbAlert_n]

set_property IOSTANDARD LVCMOS18 [get_ports aIoRefClk*]

set_property IOSTANDARD LVCMOS18 [get_ports aAuthSda]

set_property IOSTANDARD LVCMOS18 [get_ports SidebandClk]
set_property IOSTANDARD LVCMOS18 [get_ports sSidebandDataOut[*]]
set_property IOSTANDARD LVCMOS18 [get_ports aSidebandDataIn]
set_property IOSTANDARD LVCMOS18 [get_ports aSidebandFifoFull]
set_property IOSTANDARD LVCMOS18 [get_ports aFpgaStage2Done]

set_property IOSTANDARD LVCMOS18 [get_ports *FldUpdJtag*]

set_property PACKAGE_PIN BD14 [get_ports  aI2cBusEnable]
set_property IOSTANDARD LVCMOS18 [get_ports  aI2cBusEnable]

set_property PACKAGE_PIN BA12 [get_ports  a3v3VDPwrSync  ]
set_property PACKAGE_PIN AP13 [get_ports  a1v2PwrSync    ]
set_property PACKAGE_PIN AY11 [get_ports  a0v9PwrSync    ]
set_property PACKAGE_PIN BC13 [get_ports  aDdr4VttPwrEn  ]
set_property PACKAGE_PIN AP14 [get_ports  aMgtavttPwrSync]
set_property PACKAGE_PIN BB12 [get_ports  a0v85PwrSync   ]
set_property PACKAGE_PIN BD15 [get_ports  a1v8fpgaPwrSync]
set_property PACKAGE_PIN AN14 [get_ports  a3v8PwrSync    ]
set_property PACKAGE_PIN AY31 [get_ports  a3v3OptPwrSync ]


set_property IOSTANDARD LVCMOS18 [get_ports  a3v3VDPwrSync  ]
set_property IOSTANDARD LVCMOS18 [get_ports  a1v2PwrSync    ]
set_property IOSTANDARD LVCMOS18 [get_ports  a0v9PwrSync    ]
set_property IOSTANDARD LVCMOS18 [get_ports  aDdr4VttPwrEn  ]
set_property IOSTANDARD LVCMOS18 [get_ports  aMgtavttPwrSync]
set_property IOSTANDARD LVCMOS18 [get_ports  a0v85PwrSync   ]
set_property IOSTANDARD LVCMOS18 [get_ports  a1v8fpgaPwrSync]
set_property IOSTANDARD LVCMOS18 [get_ports  a3v8PwrSync    ]
set_property IOSTANDARD LVCMOS18 [get_ports  a3v3OptPwrSync ]

set_property PACKAGE_PIN AW30 [get_ports aFpgaB2bSpare1]
set_property PACKAGE_PIN AM31 [get_ports aFpgaB2bSpare2]
set_property IOSTANDARD LVCMOS18 [get_ports aFpgaB2bSpare*]

set_property PACKAGE_PIN A18 [get_ports dr0DramAlert_n]
set_property PACKAGE_PIN C28 [get_ports dr1DramAlert_n]
set_property IOSTANDARD LVCMOS12 [get_ports dr*DramAlert_n]

set_property PACKAGE_PIN AP21 [get_ports aPllCtrlStatusEn_n]
set_property IOSTANDARD LVCMOS18 [get_ports aPllCtrlStatusEn_n]

######################################################
# PCIe
######################################################
set_property PACKAGE_PIN AR26 [get_ports aPcieRst_n]
set_property PACKAGE_PIN AT10 [get_ports PcieRefClk_n]
set_property PACKAGE_PIN AT11 [get_ports PcieRefClk_p]

set_property package_pin BF4 [get_ports PcieTx_n[0]]
set_property package_pin BF5 [get_ports PcieTx_p[0]]
set_property package_pin BD4 [get_ports PcieTx_n[1]]
set_property package_pin BD5 [get_ports PcieTx_p[1]]
set_property package_pin BB4 [get_ports PcieTx_n[2]]
set_property package_pin BB5 [get_ports PcieTx_p[2]]
set_property package_pin AV6 [get_ports PcieTx_n[3]]
set_property package_pin AV7 [get_ports PcieTx_p[3]]
set_property package_pin AU8 [get_ports PcieTx_n[4]]
set_property package_pin AU9 [get_ports PcieTx_p[4]]
set_property package_pin AT6 [get_ports PcieTx_n[5]]
set_property package_pin AT7 [get_ports PcieTx_p[5]]
set_property package_pin AR8 [get_ports PcieTx_n[6]]
set_property package_pin AR9 [get_ports PcieTx_p[6]]
set_property package_pin AP6 [get_ports PcieTx_n[7]]
set_property package_pin AP7 [get_ports PcieTx_p[7]]

set_property package_pin BC1 [get_ports PcieRx_n[0]]
set_property package_pin BC2 [get_ports PcieRx_p[0]]
set_property package_pin BA1 [get_ports PcieRx_n[1]]
set_property package_pin BA2 [get_ports PcieRx_p[1]]
set_property package_pin AW3 [get_ports PcieRx_n[2]]
set_property package_pin AW4 [get_ports PcieRx_p[2]]
set_property package_pin AV1 [get_ports PcieRx_n[3]]
set_property package_pin AV2 [get_ports PcieRx_p[3]]
set_property package_pin AU3 [get_ports PcieRx_n[4]]
set_property package_pin AU4 [get_ports PcieRx_p[4]]
set_property package_pin AT1 [get_ports PcieRx_n[5]]
set_property package_pin AT2 [get_ports PcieRx_p[5]]
set_property package_pin AR3 [get_ports PcieRx_n[6]]
set_property package_pin AR4 [get_ports PcieRx_p[6]]
set_property package_pin AP1 [get_ports PcieRx_n[7]]
set_property package_pin AP2 [get_ports PcieRx_p[7]]



set_property IOSTANDARD LVCMOS18 [get_ports aPcieRst_n]
set_property PULLUP     true     [get_ports aPcieRst_n]

create_interface PCIe
set_property INTERFACE PCIe [get_ports { PcieRx_p[7] PcieRx_p[6] PcieRx_p[5] PcieRx_p[4] PcieRx_p[3] PcieRx_p[2] PcieRx_p[1] PcieRx_p[0] PcieRx_n[7] PcieRx_n[6] PcieRx_n[5] PcieRx_n[4] PcieRx_n[3] PcieRx_n[2] PcieRx_n[1] PcieRx_n[0] PcieTx_p[7] PcieTx_p[6] PcieTx_p[5] PcieTx_p[4] PcieTx_p[3] PcieTx_p[2] PcieTx_p[1] PcieTx_p[0] PcieTx_n[7] PcieTx_n[6] PcieTx_n[5] PcieTx_n[4] PcieTx_n[3] PcieTx_n[2] PcieTx_n[1] PcieTx_n[0] PcieRefClk_p PcieRefClk_n}]


##############
# PXI
##############
set_property PACKAGE_PIN AV13 [get_ports {aPxiTrigData[0]}]
set_property PACKAGE_PIN AT14 [get_ports {aPxiTrigData[1]}]
set_property PACKAGE_PIN AU13 [get_ports {aPxiTrigData[2]}]
set_property PACKAGE_PIN AU16 [get_ports {aPxiTrigData[3]}]
set_property PACKAGE_PIN AP15 [get_ports {aPxiTrigData[4]}]
set_property PACKAGE_PIN BB14 [get_ports {aPxiTrigData[5]}]
set_property PACKAGE_PIN AY15 [get_ports {aPxiTrigData[6]}]
set_property PACKAGE_PIN AW16 [get_ports {aPxiTrigData[7]}]
set_property PACKAGE_PIN AU15 [get_ports {aPxiTrigDir[0]}]
set_property PACKAGE_PIN AT13 [get_ports {aPxiTrigDir[1]}]
set_property PACKAGE_PIN AY12 [get_ports {aPxiTrigDir[2]}]
set_property PACKAGE_PIN AV16 [get_ports {aPxiTrigDir[3]}]
set_property PACKAGE_PIN AW15 [get_ports {aPxiTrigDir[4]}]
set_property PACKAGE_PIN BC14 [get_ports {aPxiTrigDir[5]}]
set_property PACKAGE_PIN BA14 [get_ports {aPxiTrigDir[6]}]
set_property PACKAGE_PIN AY13 [get_ports {aPxiTrigDir[7]}]
set_property PACKAGE_PIN AT15 [get_ports aPxiTrigOutEn_n]

set_property PACKAGE_PIN BF25 [get_ports {aPxiGa[0]}]
set_property PACKAGE_PIN BE25 [get_ports {aPxiGa[1]}]
set_property PACKAGE_PIN BE26 [get_ports {aPxiGa[2]}]
set_property PACKAGE_PIN BD26 [get_ports {aPxiGa[3]}]
set_property PACKAGE_PIN BE28 [get_ports {aPxiGa[4]}]

set_property PACKAGE_PIN BA15 [get_ports aPxiStarData]

set_property PACKAGE_PIN AW14 [get_ports aPxieDStarB_p]
set_property PACKAGE_PIN AW13 [get_ports aPxieDStarB_n]
set_property PACKAGE_PIN AU14 [get_ports aPxieDStarC_p]
set_property PACKAGE_PIN AV14 [get_ports aPxieDStarC_n]


set_property PACKAGE_PIN AW28 [get_ports PxieClk100_p]
set_property PACKAGE_PIN AY28 [get_ports PxieClk100_n]
set_property PACKAGE_PIN BB25 [get_ports pPxieSync100_n]
set_property PACKAGE_PIN BA25 [get_ports pPxieSync100_p]


set_property IOSTANDARD LVCMOS18 [get_ports aPxiTrigDir[*] ]
set_property IOSTANDARD LVCMOS18 [get_ports aPxiTrigData[*]]
set_property IOSTANDARD LVCMOS18 [get_ports aPxiTrigOutEn_n]

set_property IOSTANDARD LVCMOS18 [get_ports aPxiGa[*]]
set_property IOSTANDARD LVCMOS18 [get_ports aPxiStarData ]

set_property IOSTANDARD LVDS     [get_ports aPxieDStarB_p   ]
set_property IOSTANDARD LVDS     [get_ports aPxieDStarC_p   ]
set_property DIFF_TERM_ADV TERM_100 [get_ports aPxieDStarB_p]
make_diff_pair_ports aPxieDStarB_p aPxieDStarB_n -quiet
make_diff_pair_ports aPxieDStarC_p aPxieDStarC_n -quiet

set_property IOSTANDARD LVDS     [get_ports PxieClk100_p  ]
set_property IOSTANDARD LVDS     [get_ports pPxieSync100_p]
make_diff_pair_ports PxieClk100_p PxieClk100_n -quiet
make_diff_pair_ports pPxieSync100_p pPxieSync100_n -quiet

create_interface PXI
set_property INTERFACE PXI [get_ports { aPxiGa[4] aPxiGa[3] aPxiGa[2] aPxiGa[1] aPxiGa[0] aPxiStarData aPxiTrigData[7] aPxiTrigData[6] aPxiTrigData[5] aPxiTrigData[4] aPxiTrigData[3] aPxiTrigData[2] aPxiTrigData[1] aPxiTrigData[0] aPcieRst_n aPxieDStarB_n aPxieDStarB_p aPxieDStarC_n aPxieDStarC_p pPxieSync100_n pPxieSync100_p PxieClk100_p PxieClk100_n Osc100ClkIn}]

##############
# DIO
##############
set_property PACKAGE_PIN AR31 [get_ports  aDio[0]]
set_property PACKAGE_PIN AT29 [get_ports  aDio[1]]
set_property PACKAGE_PIN AU29 [get_ports  aDio[2]]
set_property PACKAGE_PIN AT30 [get_ports  aDio[3]]
set_property PACKAGE_PIN AV29 [get_ports  aDio[4]]
set_property PACKAGE_PIN AU31 [get_ports  aDio[5]]
set_property PACKAGE_PIN AW29 [get_ports  aDio[6]]
set_property PACKAGE_PIN AU30 [get_ports  aDio[7]]
set_property IOSTANDARD LVCMOS18 [get_ports aDio[*]]

set_property PACKAGE_PIN AL29 [get_ports  aFpgaReady_n]
set_property IOSTANDARD LVCMOS18 [get_ports aFpgaReady_n]


###################################################
# System Monitor
###################################################
set_property PACKAGE_PIN AY18 [get_ports aSysMon_3v3AMezz_Divided_p];     # AD5
set_property PACKAGE_PIN BA18 [get_ports aSysMon_3v3AMezz_Divided_n];     # AGND

set_property PACKAGE_PIN AV21 [get_ports aSysMon_3v3VDMezz_Divided_p];    # AD4
set_property PACKAGE_PIN AW21 [get_ports aSysMon_3v3VDMezz_Divided_n];    # AGND

set_property PACKAGE_PIN AW20 [get_ports aSysMon_VccioMezz_Divided_p];    # AD12
set_property PACKAGE_PIN AY20 [get_ports aSysMon_VccioMezz_Divided_n];    # AGND

set_property PACKAGE_PIN BB19 [get_ports aSysMon_0v9MgtAvcc_Divided_p];   # AD6
set_property PACKAGE_PIN BC18 [get_ports aSysMon_0v9MgtAvcc_Divided_n];   # AGND

set_property PACKAGE_PIN AY17 [get_ports aSysMon_1v2MgtAvtt_Divided_p];   # AD13
set_property PACKAGE_PIN BA17 [get_ports aSysMon_1v2MgtAvtt_Divided_n];   # AGND

set_property PACKAGE_PIN AP20 [get_ports aSysMon_3v3A_Divided_p];         # AD2
set_property PACKAGE_PIN AR20 [get_ports aSysMon_3v3A_Divided_n];         # AGND

set_property PACKAGE_PIN AT18 [get_ports aSysMon_3v8_Divided_p];          # AD11
set_property PACKAGE_PIN AU17 [get_ports aSysMon_3v8_Divided_n];          # AGND

set_property PACKAGE_PIN AN18 [get_ports aSysMon_3v3D_Divided_p];         # AD9
set_property PACKAGE_PIN AN17 [get_ports aSysMon_3v3D_Divided_n];         # AGND

set_property PACKAGE_PIN AL17 [get_ports aSysMon_DramVpp_Divided_p];      # AD0
set_property PACKAGE_PIN AM17 [get_ports aSysMon_DramVpp_Divided_n];      # AGND

set_property PACKAGE_PIN AR17 [get_ports aSysMon_1v8A_Divided_p];         # AD3
set_property PACKAGE_PIN AT17 [get_ports aSysMon_1v8A_Divided_n];         # AGND

set_property PACKAGE_PIN AM16 [get_ports aSysMon_Dram0Vtt_Sense_p];       # AD8
set_property PACKAGE_PIN AN16 [get_ports aSysMon_Dram0Vtt_Sense_n];       # AGND

set_property PACKAGE_PIN AP18 [get_ports aSysMon_1v8MgtVccaux_Divided_p]; # AD10
set_property PACKAGE_PIN AR18 [get_ports aSysMon_1v8MgtVccaux_Divided_n]; # AGND

set_property PACKAGE_PIN AN19 [get_ports aSysMon_DramVref_Sense_p];       # AD1
set_property PACKAGE_PIN AP19 [get_ports aSysMon_DramVref_Sense_n];       # AGND

set_property PACKAGE_PIN BB17 [get_ports aSysMon_1v2_Divided_p];          # AD14
set_property PACKAGE_PIN BC17 [get_ports aSysMon_1v2_Divided_n];          # AGND

set_property IOSTANDARD ANALOG [get_ports {aSysMon_*}]




## Start add from file PBlocksVU11P.xdc
############################
# TANDEM CONSTRAINTS SECTION
############################

## -------------------------------------------------
## PCIe IP PBlock
## -------------------------------------------------
set pciePblock [create_pblock  PcieGen3x8_USP_HardIp_Stage1_main]

resize_pblock $pciePblock -add {SLICE_X217Y0:SLICE_X232Y119 \
RAMB18_X12Y0:RAMB18_X13Y47 \
RAMB36_X12Y0:RAMB36_X13Y23 \
DSP48E2_X31Y0:DSP48E2_X31Y47 \
GTYE4_CHANNEL_X1Y0:GTYE4_CHANNEL_X1Y7 \
GTYE4_COMMON_X1Y0:GTYE4_COMMON_X1Y1 \
PCIE40E4_X0Y0 \
CONFIG_SITE_X0Y0 \
LAGUNA_X28Y0:LAGUNA_X31Y119 \
}

## -------------------------------------------------
## Bank 65 (Config Bank) Pblock
## -------------------------------------------------
set cfgiobPblock [create_pblock  Stage1_cfgiob]

resize_pblock $cfgiobPblock -quiet -add [get_sites -of_objects [get_tiles -pu -of_objects [get_tiles -of_objects [get_sites MMCM_X0Y1]]]]



## Start add from file TandemSasquatch.xdc
## -------------------------------------------------
## Tandem IP_BLOCK Properties
## -------------------------------------------------

# It's unclear what the HD_TANDEM_IP_PBLOCK property does, but Xilinx started adding these
# properties to their PCIe IP circa 2016.3, and 2017.2 bitgen doesn't seem to do the right
# thing without them. We expect that $pciePblock and $cfgiobPorts are PBlocks that have
# been declared beforehand.
set_property HD.TANDEM_IP_PBLOCK Stage1_Main      $pciePblock
set_property HD.TANDEM_IP_PBLOCK Stage1_Config_IO $cfgiobPblock

## -------------------------------------------------
## Locations
## -------------------------------------------------

# Create some shorthand to the location of the InchWorm Netlist
set inchwormPath {HostInterfacex/Inchwormx/InchwormNetlist}
set hardIpPath "${inchwormPath}/PcieIpWrapper/PcieIp/inst"

# The following DONT_TOUCH property is extremely important to have when compiling for a
# Tandem flow. This property ensures that the XILINX "PcieGen3x8_USP_HardIpx/inst" IP ports
# are not optimized out during compilation and, therefore, preserves the critical TANDEM
# pins such as "mcap_eos_in" and "mcap_design_switch"
set_property DONT_TOUCH TRUE [get_cells $hardIpPath]

## -----------------------------------------------
## PCIe Core and Ports
## -----------------------------------------------

set_property HD.TANDEM 1 [get_ports PcieRefClk_*]
set_property HD.TANDEM 1 [get_ports PcieRx_*]
set_property HD.TANDEM 1 [get_ports PcieTx_*]

set_property HD.TANDEM 1 [get_pins ${hardIpPath}/ext_qpll1lock_out]
set_property HD.TANDEM 1 [get_pins ${hardIpPath}/ext_qpll1outclk_out]
set_property HD.TANDEM 1 [get_pins ${hardIpPath}/ext_qpll1outrefclk_out]
set_property HD.TANDEM 1 [get_pins ${hardIpPath}/mcap_eos_in]

set_property HD.TANDEM 1 [get_cells ${inchwormPath}/PcieIpWrapper/PcieRefClkIBufds]
set_property HD.TANDEM 1 [get_cells $hardIpPath]
set_property HD.TANDEM 1 [get_cells TimingEnginex/TimingPcieBlockx]

add_cells_to_pblock [get_pblocks $pciePblock] [get_cells $inchwormPath/PcieIpWrapper/PcieRefClkIBufds]
add_cells_to_pblock [get_pblocks $pciePblock] [get_cells $hardIpPath]
add_cells_to_pblock [get_pblocks $pciePblock] [get_cells TimingEnginex/TimingPcieBlockx]


## -------------------------------------------------
## Config Bank (Bank 65) Ports and Cells
## -------------------------------------------------

# We need to get all the ports connecting to the config bank (Bank 65) added to tandem.
set cfgiobPorts [get_ports -filter {IOBANK == 65}]
set_property HD.TANDEM 1 $cfgiobPorts

# Add specific clocking and I/O cells that need to be in the Stage1 PBlock but give us trouble when we're trying to use a cover-all constraint in Vivado 2015.4. They're all conveniently packed into appropriately named cells.
set cfgiobCellsTiming [get_cells TimingEnginex/TimingStage1x ]
set cfgiobCellsIO     [get_cells SasquatchIoBuffersStage1x/*]

# Add to Tandem and Pblock
set_property HD.TANDEM 1 $cfgiobCellsTiming
set_property HD.TANDEM 1 $cfgiobCellsIO
add_cells_to_pblock      $cfgiobPblock $cfgiobCellsTiming $cfgiobCellsIO

## -------------------------------------------------
## PCIe Block
## -------------------------------------------------

# Assigning to pcie PBlock
set_property HD.TANDEM 1 [get_cells TimingEnginex/TimingPcieBlockx]
add_cells_to_pblock [get_pblocks $pciePblock] [get_cells TimingEnginex/TimingPcieBlockx]

## -------------------------------------------------
## Tandem DRC Checks
## -------------------------------------------------

# There's a DRC Check that makes sure no Stage 2 cells wind up in Stage 1, but it's a
# Warning. We want to always break in this case, so we'll promote it to an error. This
# "promotion" is commented out because it turns out that there are some cells (notably the
# abBusReset BUFG) which wind up in stage1, and that's ok.
# set_property SEVERITY {Error} [get_drc_checks HDTC-14]

## Start add from file LvFpga.xdc

################################################################################
# The "LabVIEWFPGA_Macro" comments are replaced by LV FPGA when it generates constraints
#
# The BEGIN and END LV FPGA CONSTRAINTS tags are used to extract the LabVIEW FPGA
# generated constraints out of the constraints.xdc file in the Vivado Project Export
# for use in the GitHub Vivado workflow.
#
# In the GitHub Vivado workflow, the PERIOD_AND_CLIP and FROM_TO sections are there so
# that we can set the current instance around just the FROM_TO constraints.

# BEGIN_LV_FPGA_CONSTRAINTS

# BEGIN_LV_FPGA_PERIOD_AND_CLIP_CONSTRAINTS

set ToplevelClockPeriod 12.490



#niFpga_Keep


set RoutingClipInstanceRestore [current_instance .]
current_instance SasquatchWindow/theCLIPs/Routing_CLIP1/RegisteredRouting_1
#########################################################################################
## Clock Crossing
#########################################################################################

# # this data is resynced across from the Clk100 to the bus clock.
# set_false_path \
#     -from [get_pins {*/SyncPulse.sSyncPulseTimestampReg_reg[*]/C}] \
#     -to   [get_pins {*/SyncPulse.bSyncPulseTimestampReg_ms_reg[*]/D}]

# This might be a little too liberal, but it gets the job done
set hsPath */HBx

set_false_path \
    -from [get_pins ${hsPath}/BlkIn.iLclStoredData_reg[*]/C] \
    -to   [get_pins ${hsPath}/BlkOut.ODataFlop/GenFlops[*].DFlopx/GenClr.ClearFDCPEx/D]

set_false_path \
    -from [get_pins ${hsPath}/BlkIn.iPushToggle_reg/C] \
    -to   [get_pins ${hsPath}/BlkOut.oPushToggle0_ms_reg/D]

set_false_path \
    -from [get_pins ${hsPath}/BlkOut.oPushToggleToReady_reg/C] \
    -to   [get_pins ${hsPath}/BlkRdy.iRdyPushToggle_ms_reg/D]

# Specialize boolean handshake
set_false_path \
    -from [get_pins */HandshakeBasex/BlkIn.iPushToggle_reg/C] \
    -to   [get_pins */HandshakeBasex/BlkOut.oPushToggle0_ms_reg/D]

set_false_path \
    -from [get_pins SyncPulse.sSyncPulseAssert_reg/C] \
    -to   [get_pins TClkBlock.Measurement.TdcAssertSender.dSyncPulseCap_ms_reg/D]

set_false_path \
    -from [get_pins TClkBlock.Measurement.TdcAssertSender.dTDCAssertLcl_reg/C] \
    -to   [get_pins TClkBlock.Measurement.DeassertSender.sTDCAssert_ms_reg/D]

set_false_path \
    -from [get_pins TClkBlock.Measurement.DeassertSender.sTdcDeassertTclk_reg/C] \
    -to   [get_pins TClkBlock.Measurement.TdcAssertSender.dTdcDeassertTclk_ms_reg/D]

# added for GPIO to GPIO debug register
# Note, a -from constraint might be a good idea on this
#set_false_path -to [get_pins RoutingRegisterInterfaceBlock.gpio_ms_reg[*]/D]

set_false_path -to [get_pins TClkBlock.Measurement.DoubleSynchronizeSignals.*_ms_reg/D]

#########################################################################################
## Trigger Routing Exceptions
#########################################################################################

set base "RoutingMuxBlock.PxiTriggerRouting_1"

########## Exception for PxiTrigger Muxes

# We want the PxiTrigger routing matrix to be (almost) fully asynchronous, in that we
# don't want timing analyzed through the PXI Triggers. There is one exception to this:
# timing should be analyzed for the Sync Pulse Generator, because we need to meet Clk10
# timing on it.

# If we had no synchronous paths in our routing matrix, all we would have to do to achieve
# a fully asynchronous matrix would be to false-path all outputs of the matrix, namely all
# the PXI Triggers. But because of our Sync Pulse Exception, we can't do that. Instead,
# we'll false-path all _inputs_ to the matrix (Data as well as Selectors), with the
# exception of the Sync Pulse, of course.

# First, grab all the PxiTrigger Mux cells.
set muxes [get_cells $base/PxiTrigToBusGen[*].PxiTrigToBusMux]

# Now false-path all the selector pins from each mux
set selectors [get_pins -of $muxes -filter {NAME =~ *aInputSel[*]}]
set_false_path -through $selectors

# Now grab the input vector elements:
set inputs [get_pins -of $muxes -filter {NAME =~ *aInputVec[*]}]
# and filter out input pin 2, since that's the one sourced by aSourceSyncPulse.
set inputs [filter $inputs {NAME !~ *aInputVec[2]}]
# We can false path the remaining paths.
set_false_path -through $inputs

########## Exception for Destination Muxes

# Analogously to the above, we want a routing matrix that is asynchronous to all destinations except for the Sync Pulse Synchronizer. All other destinations will be double-synchronized into the
# user's clock domain upon entering the diagram, and we want to prevent spurious
# clock-domain crossings.

# To achieve this, we need to do 2 things:
#
#  1. False path the output of all routing muxes, except for the one that goes to the Sync
#     Pulse Synchronizer.
#
#  2. For the Sync Pulse Synchronizer, false path the mux selectors and all mux inputs
#     which are _not_ PXI Triggers, so that the timing analyzer doesn't see a potential
#     clock-crossing path between one of the local FPGA sources and the Sync Pulse
#     Synchronizer.
#
# Of course, we could do #2 to all Muxes, but that's not necessary once their outputs have
# been false-pathed.

# First we need to gather all the DestinationMux cells
set muxes [get_cells $base/DestinationGen[*].DestinationMux]

# Filter out Destination 0, which is always the Sync Pulse.
set muxes [filter $muxes {NAME !~ *DestinationGen[0].DestinationMux}]

# Grab the output pins for all the selected muxes, false-path them.
set outputs [get_pins -of $muxes -filter {NAME =~ *aMuxOut}]
set_false_path -through $outputs

# Now grab _only_ mux 0.
set muxes [get_cells $base/DestinationGen[0].DestinationMux]

# Get and false-path its selectors.
set selectors [get_pins -of $muxes -filter {NAME =~ *aInputSel[*]}]
set_false_path -through $selectors

# Now grab the input vector elements:
set inputs [get_pins -of $muxes -filter {NAME =~ *aInputVec[*]}]
# and filter out input pins 2-10, since those are the PxiTriggers (including Star).
set inputs [filter -regexp $inputs {NAME !~ ".*aInputVec\[([2-9]|10)\]"}]
# We can false path the remaining paths.
set_false_path -through $inputs

########## Exception for Debug Registers

# There are two sets of registers that track the status of the destinations and gpio. We
# will false-path the input to those, since they are double-synchronized.

set destregs [get_cells RoutingRegisterInterfaceBlock.dest_ms_reg*]
set destpins [get_pins -of $destregs -filter {REF_PIN_NAME == D}]

set_false_path -through $destpins

set gpioregs [get_cells RoutingRegisterInterfaceBlock.gpio_ms_reg*]
set gpiopins [get_pins -of $gpioregs -filter {REF_PIN_NAME == D}]

set_false_path -through $gpiopins

#########################################################################################
## Sync Pulse Identity
#########################################################################################

# We need to identify the FFs that generate / consume the SyncPulse, and store their name
# in a variable. Then the top-level constraints for each target will use that information
# to properly constrain the trigger path.

set TriggerClipSyncPulseSrc [get_cells SyncPulse.aSourceSyncPulseInt_reg]
set TriggerClipSyncPulseDest [get_cells SyncPulse.sSyncPulseCap_ms_reg]
current_instance
current_instance $RoutingClipInstanceRestore


#niFpga_EndKeep





# END_LV_FPGA_PERIOD_AND_CLIP_CONSTRAINTS

# BEGIN_LV_FPGA_FROM_TO_CONSTRAINTS

set TNM_Custom1 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLV_Ackx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLV_Ackx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLV_Ackx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLV_Ackx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom5 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLV_Ackx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom6 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLV_Ackx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom8 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLV_Ackx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom9 [get_cells {*iReset_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom10 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLV_Ackx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom12 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLV_Ackx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom13 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*PulseSyncBoolx/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom14 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*PulseSyncBoolx/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom15 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*PulseSyncBoolx/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom16 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*PulseSyncBoolx/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom17 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*PulseSyncBoolx/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom19 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLVx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom20 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLVx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom21 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLVx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom22 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLVx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom23 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLVx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom24 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLVx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom26 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLVx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom28 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLVx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom30 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort4/*HandshakeSLVx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom61 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLV_Ackx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom62 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLV_Ackx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom63 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLV_Ackx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom64 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLV_Ackx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom65 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLV_Ackx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom66 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLV_Ackx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom68 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLV_Ackx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom70 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLV_Ackx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom72 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLV_Ackx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom73 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*PulseSyncBoolx/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom74 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*PulseSyncBoolx/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom75 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*PulseSyncBoolx/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom76 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*PulseSyncBoolx/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom77 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*PulseSyncBoolx/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom79 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLVx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom80 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLVx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom81 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLVx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom82 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLVx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom83 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLVx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom84 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLVx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom86 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLVx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom88 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLVx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom90 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort5/*HandshakeSLVx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom121 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLV_Ackx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom122 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLV_Ackx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom123 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLV_Ackx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom124 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLV_Ackx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom125 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLV_Ackx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom126 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLV_Ackx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom128 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLV_Ackx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom130 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLV_Ackx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom132 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLV_Ackx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom133 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*PulseSyncBoolx/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom134 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*PulseSyncBoolx/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom135 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*PulseSyncBoolx/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom136 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*PulseSyncBoolx/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom137 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*PulseSyncBoolx/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom139 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLVx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom140 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLVx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom141 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLVx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom142 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLVx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom143 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLVx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom144 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLVx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom146 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLVx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom148 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLVx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom150 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort6/*HandshakeSLVx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom181 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLV_Ackx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom182 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLV_Ackx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom183 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLV_Ackx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom184 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLV_Ackx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom185 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLV_Ackx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom186 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLV_Ackx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom188 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLV_Ackx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom190 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLV_Ackx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom192 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLV_Ackx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom193 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*PulseSyncBoolx/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom194 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*PulseSyncBoolx/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom195 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*PulseSyncBoolx/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom196 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*PulseSyncBoolx/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom197 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*PulseSyncBoolx/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom199 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLVx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom200 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLVx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom201 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLVx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom202 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLVx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom203 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLVx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom204 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLVx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom206 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLVx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom208 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLVx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom210 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort7/*HandshakeSLVx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom241 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLV_Ackx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom242 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLV_Ackx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom243 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLV_Ackx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom244 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLV_Ackx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom245 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLV_Ackx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom246 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLV_Ackx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom248 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLV_Ackx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom250 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLV_Ackx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom252 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLV_Ackx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom253 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*PulseSyncBoolx/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom254 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*PulseSyncBoolx/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom255 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*PulseSyncBoolx/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom256 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*PulseSyncBoolx/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom257 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*PulseSyncBoolx/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom259 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLVx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom260 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLVx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom261 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLVx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom262 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLVx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom263 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLVx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom264 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLVx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom266 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLVx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom268 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLVx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom270 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort0/*HandshakeSLVx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom301 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLV_Ackx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom302 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLV_Ackx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom303 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLV_Ackx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom304 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLV_Ackx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom305 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLV_Ackx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom306 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLV_Ackx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom308 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLV_Ackx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom310 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLV_Ackx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom312 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLV_Ackx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom313 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*PulseSyncBoolx/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom314 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*PulseSyncBoolx/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom315 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*PulseSyncBoolx/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom316 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*PulseSyncBoolx/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom317 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*PulseSyncBoolx/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom319 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLVx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom320 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLVx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom321 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLVx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom322 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLVx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom323 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLVx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom324 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLVx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom326 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLVx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom328 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLVx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom330 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort1/*HandshakeSLVx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom361 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLV_Ackx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom362 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLV_Ackx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom363 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLV_Ackx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom364 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLV_Ackx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom365 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLV_Ackx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom366 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLV_Ackx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom368 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLV_Ackx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom370 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLV_Ackx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom372 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLV_Ackx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom373 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*PulseSyncBoolx/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom374 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*PulseSyncBoolx/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom375 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*PulseSyncBoolx/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom376 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*PulseSyncBoolx/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom377 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*PulseSyncBoolx/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom379 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLVx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom380 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLVx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom381 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLVx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom382 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLVx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom383 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLVx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom384 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLVx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom386 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLVx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom388 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLVx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom390 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort2/*HandshakeSLVx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom421 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLV_Ackx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom422 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLV_Ackx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom423 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLV_Ackx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom424 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLV_Ackx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom425 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLV_Ackx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom426 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLV_Ackx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom428 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLV_Ackx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom430 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLV_Ackx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom432 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLV_Ackx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom433 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*PulseSyncBoolx/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom434 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*PulseSyncBoolx/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom435 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*PulseSyncBoolx/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom436 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*PulseSyncBoolx/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom437 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*PulseSyncBoolx/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom439 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLVx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom440 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLVx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom441 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLVx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom442 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLVx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom443 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLVx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom444 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLVx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom446 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLVx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom448 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLVx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom450 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort3/*HandshakeSLVx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom481 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLV_Ackx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom482 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLV_Ackx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom483 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLV_Ackx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom484 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLV_Ackx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom485 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLV_Ackx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom486 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLV_Ackx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom488 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLV_Ackx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom490 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLV_Ackx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom492 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLV_Ackx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom493 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*PulseSyncBoolx/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom494 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*PulseSyncBoolx/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom495 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*PulseSyncBoolx/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom496 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*PulseSyncBoolx/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom497 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*PulseSyncBoolx/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom499 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLVx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom500 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLVx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom501 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLVx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom502 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLVx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom503 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLVx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom504 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLVx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom506 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLVx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom508 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLVx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom510 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort8/*HandshakeSLVx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom541 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLV_Ackx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom542 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLV_Ackx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom543 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLV_Ackx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom544 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLV_Ackx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom545 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLV_Ackx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom546 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLV_Ackx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom548 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLV_Ackx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom550 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLV_Ackx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom552 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLV_Ackx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom553 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*PulseSyncBoolx/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom554 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*PulseSyncBoolx/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom555 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*PulseSyncBoolx/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom556 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*PulseSyncBoolx/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom557 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*PulseSyncBoolx/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom559 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLVx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom560 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLVx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom561 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLVx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom562 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLVx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom563 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLVx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom564 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLVx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom566 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLVx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom568 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLVx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom570 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort9/*HandshakeSLVx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom601 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLV_Ackx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom602 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLV_Ackx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom603 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLV_Ackx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom604 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLV_Ackx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom605 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLV_Ackx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom606 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLV_Ackx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom608 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLV_Ackx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom610 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLV_Ackx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom612 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLV_Ackx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom613 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*PulseSyncBoolx/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom614 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*PulseSyncBoolx/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom615 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*PulseSyncBoolx/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom616 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*PulseSyncBoolx/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom617 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*PulseSyncBoolx/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom619 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLVx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom620 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLVx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom621 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLVx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom622 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLVx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom623 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLVx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom624 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLVx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom626 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLVx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom628 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLVx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom630 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort10/*HandshakeSLVx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom661 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLV_Ackx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom662 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLV_Ackx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom663 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLV_Ackx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom664 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLV_Ackx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom665 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLV_Ackx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom666 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLV_Ackx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom668 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLV_Ackx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom670 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLV_Ackx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom672 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLV_Ackx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom673 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*PulseSyncBoolx/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom674 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*PulseSyncBoolx/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom675 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*PulseSyncBoolx/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom676 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*PulseSyncBoolx/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom677 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*PulseSyncBoolx/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom679 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLVx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom680 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLVx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom681 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLVx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom682 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLVx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom683 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLVx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom684 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLVx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom686 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLVx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom688 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLVx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom690 [get_cells {*TimeLoopCoreFromPllClk80ToUserClkPort11/*HandshakeSLVx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom721 [get_cells {*PllClk80Derived5x2C00MHzToInterface/BlkOut.SyncIReset/c1ResetFastLclx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom722 [get_cells {*PllClk80Derived5x2C00MHzToInterface/BlkIn.iPushTogglex*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom723 [get_cells {*PllClk80Derived5x2C00MHzToInterface/BlkIn.i*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom724 [get_cells {*PllClk80Derived5x2C00MHzToInterface/BlkOut.o*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom726 [get_cells {*PllClk80Derived5x2C00MHzToInterface/BlkOut.SyncIReset/c2ResetFe_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom727 [get_cells {*PllClk80Derived5x2C00MHzToInterface/Blk*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom728 [get_cells {*PllClk80Derived5x2C00MHzToInterface/Blk*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom729 [get_cells {*PllClk80Derived5x2C00MHzToInterface/BlkIn.iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom730 [get_cells {*PllClk80Derived5x2C00MHzToInterface/BlkOut.oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom731 [get_cells {*PllClk80Derived5x2C00MHzToInterface/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom732 [get_cells {*PllClk80Derived5x2C00MHzToInterface/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom733 [get_cells {*PllClk80Derived5x2C00MHzToInterface/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom734 [get_cells {*PllClk80Derived5x2C00MHzToInterface/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom735 [get_cells {*PllClk80Derived5x2C00MHzToInterface/BlkOut.SyncIReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom736 [get_cells {*PllClk80Derived5x2C00MHzToInterface/BlkOut.SyncIReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom737 [get_cells {*PllClk80Derived5x2C00MHzToInterface/BlkOut.SyncOReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom738 [get_cells {*PllClk80Derived5x2C00MHzToInterface/BlkOut.SyncOReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom739 [get_cells {*PllClk80Derived5x2C00MHzToInterface/BlkOut.SyncIReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom740 [get_cells {*PllClk80Derived5x2C00MHzToInterface/BlkOut.SyncIReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom741 [get_cells {*PllClk80Derived5x2C00MHzToInterface/BlkOut.SyncOReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom742 [get_cells {*PllClk80Derived5x2C00MHzToInterface/BlkOut.SyncOReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom743 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/BlkOut.SyncIReset/c1ResetFastLclx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom744 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/BlkIn.iPushTogglex*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom745 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/BlkIn.i*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom746 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/BlkOut.o*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom748 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/BlkOut.SyncIReset/c2ResetFe_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom749 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/Blk*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom750 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/Blk*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom751 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/BlkIn.iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom752 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/BlkOut.oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom753 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom754 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom755 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom756 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom757 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/BlkOut.SyncIReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom758 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/BlkOut.SyncIReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom759 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/BlkOut.SyncOReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom760 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/BlkOut.SyncOReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom761 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/BlkOut.SyncIReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom762 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/BlkOut.SyncIReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom763 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/BlkOut.SyncOReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom764 [get_cells {*PllClk80Derived5x2C00MHzFromInterface/BlkOut.SyncOReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom765 [get_cells {*PllClk80ToInterface/BlkOut.SyncIReset/c1ResetFastLclx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom766 [get_cells {*PllClk80ToInterface/BlkIn.iPushTogglex*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom767 [get_cells {*PllClk80ToInterface/BlkIn.i*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom768 [get_cells {*PllClk80ToInterface/BlkOut.o*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom770 [get_cells {*PllClk80ToInterface/BlkOut.SyncIReset/c2ResetFe_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom771 [get_cells {*PllClk80ToInterface/Blk*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom772 [get_cells {*PllClk80ToInterface/Blk*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom773 [get_cells {*PllClk80ToInterface/BlkIn.iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom774 [get_cells {*PllClk80ToInterface/BlkOut.oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom775 [get_cells {*PllClk80ToInterface/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom776 [get_cells {*PllClk80ToInterface/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom777 [get_cells {*PllClk80ToInterface/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom778 [get_cells {*PllClk80ToInterface/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom779 [get_cells {*PllClk80ToInterface/BlkOut.SyncIReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom780 [get_cells {*PllClk80ToInterface/BlkOut.SyncIReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom781 [get_cells {*PllClk80ToInterface/BlkOut.SyncOReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom782 [get_cells {*PllClk80ToInterface/BlkOut.SyncOReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom783 [get_cells {*PllClk80ToInterface/BlkOut.SyncIReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom784 [get_cells {*PllClk80ToInterface/BlkOut.SyncIReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom785 [get_cells {*PllClk80ToInterface/BlkOut.SyncOReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom786 [get_cells {*PllClk80ToInterface/BlkOut.SyncOReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom787 [get_cells {*PllClk80FromInterface/BlkOut.SyncIReset/c1ResetFastLclx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom788 [get_cells {*PllClk80FromInterface/BlkIn.iPushTogglex*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom789 [get_cells {*PllClk80FromInterface/BlkIn.i*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom790 [get_cells {*PllClk80FromInterface/BlkOut.o*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom792 [get_cells {*PllClk80FromInterface/BlkOut.SyncIReset/c2ResetFe_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom793 [get_cells {*PllClk80FromInterface/Blk*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom794 [get_cells {*PllClk80FromInterface/Blk*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom795 [get_cells {*PllClk80FromInterface/BlkIn.iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom796 [get_cells {*PllClk80FromInterface/BlkOut.oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom797 [get_cells {*PllClk80FromInterface/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom798 [get_cells {*PllClk80FromInterface/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom799 [get_cells {*PllClk80FromInterface/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom800 [get_cells {*PllClk80FromInterface/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom801 [get_cells {*PllClk80FromInterface/BlkOut.SyncIReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom802 [get_cells {*PllClk80FromInterface/BlkOut.SyncIReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom803 [get_cells {*PllClk80FromInterface/BlkOut.SyncOReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom804 [get_cells {*PllClk80FromInterface/BlkOut.SyncOReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom805 [get_cells {*PllClk80FromInterface/BlkOut.SyncIReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom806 [get_cells {*PllClk80FromInterface/BlkOut.SyncIReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom807 [get_cells {*PllClk80FromInterface/BlkOut.SyncOReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom808 [get_cells {*PllClk80FromInterface/BlkOut.SyncOReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom809 [get_cells {*n_bushold/*ShiftRegister/SyncBusReset/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom810 [get_cells {*n_bushold/*ShiftRegister/SyncBusReset/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom811 [get_cells {*n_bushold/*ShiftRegister/SyncBusReset/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom812 [get_cells {*n_bushold/*ShiftRegister/SyncBusReset/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom813 [get_cells {*n_bushold/*ShiftRegister/SyncBusReset/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom815 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort11*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom816 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort11*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom817 [get_cells {*DoubleSyncSLVFromPllClk80ToPllClk80Derived5x2C00MHz*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom818 [get_cells {*DoubleSyncSLVFromPllClk80ToPllClk80Derived5x2C00MHz*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom819 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort10*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom820 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort10*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom821 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort9*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom822 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort9*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom823 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort8*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom824 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort8*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom825 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort3*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom826 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort3*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom827 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort2*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom828 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort2*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom829 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort1*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom830 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort1*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom831 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort0*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom832 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort0*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom833 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort7*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom834 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort7*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom835 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort6*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom836 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort6*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom837 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort5*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom838 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort5*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom839 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort4*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom840 [get_cells {*DoubleSyncSLVFromPllClk80ToUserClkPort4*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom843 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort4/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom844 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort4/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom845 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort4/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom846 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort4/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom847 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort4/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom848 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort4/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom850 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort4/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom852 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort4/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom854 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort4/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom897 [get_cells {*DoubleSyncSLVFromPllClk80Derived5x2C00MHzToPllClk80*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom898 [get_cells {*DoubleSyncSLVFromPllClk80Derived5x2C00MHzToPllClk80*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom901 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort5/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom902 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort5/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom903 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort5/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom904 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort5/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom905 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort5/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom906 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort5/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom908 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort5/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom910 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort5/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom912 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort5/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom957 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort6/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom958 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort6/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom959 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort6/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom960 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort6/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom961 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort6/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom962 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort6/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom964 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort6/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom966 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort6/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom968 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort6/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1013 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort7/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1014 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort7/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1015 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort7/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1016 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort7/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1017 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort7/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1018 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort7/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1020 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort7/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1022 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort7/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1024 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort7/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1069 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort0/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1070 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort0/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1071 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort0/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1072 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort0/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1073 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort0/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1074 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort0/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1076 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort0/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1078 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort0/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1080 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort0/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1125 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort1/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1126 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort1/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1127 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort1/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1128 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort1/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1129 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort1/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1130 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort1/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1132 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort1/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1134 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort1/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1136 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort1/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1181 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort2/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1182 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort2/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1183 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort2/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1184 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort2/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1185 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort2/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1186 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort2/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1188 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort2/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1190 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort2/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1192 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort2/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1231 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort3/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1232 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort3/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1233 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort3/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1234 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort3/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1235 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort3/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1236 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort3/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1238 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort3/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1240 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort3/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1242 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort3/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1287 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort8/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1288 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort8/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1289 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort8/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1290 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort8/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1291 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort8/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1292 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort8/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1294 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort8/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1296 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort8/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1298 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort8/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1343 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort9/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1344 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort9/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1345 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort9/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1346 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort9/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1347 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort9/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1348 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort9/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1350 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort9/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1352 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort9/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1354 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort9/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1399 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort10/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1400 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort10/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1401 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort10/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1402 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort10/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1403 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort10/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1404 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort10/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1406 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort10/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1408 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort10/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1410 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort10/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1463 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort11/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1464 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort11/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1465 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort11/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1466 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort11/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1467 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort11/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1468 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort11/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1470 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort11/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1472 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort11/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1474 [get_cells {*HandshakeSLVFromPllClk80ToUserClkPort11/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1509 [get_cells {*HandshakeSLVFromUserClkPort0ToPllClk80/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1510 [get_cells {*HandshakeSLVFromUserClkPort0ToPllClk80/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1511 [get_cells {*HandshakeSLVFromUserClkPort0ToPllClk80/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1512 [get_cells {*HandshakeSLVFromUserClkPort0ToPllClk80/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1513 [get_cells {*HandshakeSLVFromUserClkPort0ToPllClk80/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1514 [get_cells {*HandshakeSLVFromUserClkPort0ToPllClk80/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1516 [get_cells {*HandshakeSLVFromUserClkPort0ToPllClk80/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1518 [get_cells {*HandshakeSLVFromUserClkPort0ToPllClk80/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1520 [get_cells {*HandshakeSLVFromUserClkPort0ToPllClk80/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1605 [get_cells {*DoubleSyncSLVFromUserClkPort0ToPllClk80*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1606 [get_cells {*DoubleSyncSLVFromUserClkPort0ToPllClk80*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1625 [get_cells {*HandshakeSLVFromPllClk80Derived5x2C00MHzToPllClk80/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1626 [get_cells {*HandshakeSLVFromPllClk80Derived5x2C00MHzToPllClk80/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1627 [get_cells {*HandshakeSLVFromPllClk80Derived5x2C00MHzToPllClk80/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1628 [get_cells {*HandshakeSLVFromPllClk80Derived5x2C00MHzToPllClk80/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1629 [get_cells {*HandshakeSLVFromPllClk80Derived5x2C00MHzToPllClk80/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1630 [get_cells {*HandshakeSLVFromPllClk80Derived5x2C00MHzToPllClk80/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1632 [get_cells {*HandshakeSLVFromPllClk80Derived5x2C00MHzToPllClk80/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1634 [get_cells {*HandshakeSLVFromPllClk80Derived5x2C00MHzToPllClk80/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1636 [get_cells {*HandshakeSLVFromPllClk80Derived5x2C00MHzToPllClk80/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1641 [get_cells {*HandshakeSLVFromUserClkPort1ToPllClk80/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1642 [get_cells {*HandshakeSLVFromUserClkPort1ToPllClk80/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1643 [get_cells {*HandshakeSLVFromUserClkPort1ToPllClk80/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1644 [get_cells {*HandshakeSLVFromUserClkPort1ToPllClk80/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1645 [get_cells {*HandshakeSLVFromUserClkPort1ToPllClk80/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1646 [get_cells {*HandshakeSLVFromUserClkPort1ToPllClk80/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1648 [get_cells {*HandshakeSLVFromUserClkPort1ToPllClk80/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1650 [get_cells {*HandshakeSLVFromUserClkPort1ToPllClk80/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1652 [get_cells {*HandshakeSLVFromUserClkPort1ToPllClk80/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1737 [get_cells {*DoubleSyncSLVFromUserClkPort1ToPllClk80*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1738 [get_cells {*DoubleSyncSLVFromUserClkPort1ToPllClk80*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1773 [get_cells {*HandshakeSLVFromUserClkPort2ToPllClk80/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1774 [get_cells {*HandshakeSLVFromUserClkPort2ToPllClk80/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1775 [get_cells {*HandshakeSLVFromUserClkPort2ToPllClk80/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1776 [get_cells {*HandshakeSLVFromUserClkPort2ToPllClk80/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1777 [get_cells {*HandshakeSLVFromUserClkPort2ToPllClk80/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1778 [get_cells {*HandshakeSLVFromUserClkPort2ToPllClk80/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1780 [get_cells {*HandshakeSLVFromUserClkPort2ToPllClk80/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1782 [get_cells {*HandshakeSLVFromUserClkPort2ToPllClk80/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1784 [get_cells {*HandshakeSLVFromUserClkPort2ToPllClk80/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1869 [get_cells {*DoubleSyncSLVFromUserClkPort2ToPllClk80*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1870 [get_cells {*DoubleSyncSLVFromUserClkPort2ToPllClk80*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1889 [get_cells {*HandshakeSLVFromUserClkPort3ToPllClk80/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1890 [get_cells {*HandshakeSLVFromUserClkPort3ToPllClk80/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1891 [get_cells {*HandshakeSLVFromUserClkPort3ToPllClk80/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1892 [get_cells {*HandshakeSLVFromUserClkPort3ToPllClk80/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1893 [get_cells {*HandshakeSLVFromUserClkPort3ToPllClk80/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1894 [get_cells {*HandshakeSLVFromUserClkPort3ToPllClk80/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1896 [get_cells {*HandshakeSLVFromUserClkPort3ToPllClk80/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1898 [get_cells {*HandshakeSLVFromUserClkPort3ToPllClk80/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1900 [get_cells {*HandshakeSLVFromUserClkPort3ToPllClk80/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1985 [get_cells {*DoubleSyncSLVFromUserClkPort3ToPllClk80*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom1986 [get_cells {*DoubleSyncSLVFromUserClkPort3ToPllClk80*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2021 [get_cells {*HandshakeSLVFromUserClkPort4ToPllClk80/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2022 [get_cells {*HandshakeSLVFromUserClkPort4ToPllClk80/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2023 [get_cells {*HandshakeSLVFromUserClkPort4ToPllClk80/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2024 [get_cells {*HandshakeSLVFromUserClkPort4ToPllClk80/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2025 [get_cells {*HandshakeSLVFromUserClkPort4ToPllClk80/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2026 [get_cells {*HandshakeSLVFromUserClkPort4ToPllClk80/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2028 [get_cells {*HandshakeSLVFromUserClkPort4ToPllClk80/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2030 [get_cells {*HandshakeSLVFromUserClkPort4ToPllClk80/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2032 [get_cells {*HandshakeSLVFromUserClkPort4ToPllClk80/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2117 [get_cells {*DoubleSyncSLVFromUserClkPort4ToPllClk80*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2118 [get_cells {*DoubleSyncSLVFromUserClkPort4ToPllClk80*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2153 [get_cells {*HandshakeSLVFromUserClkPort5ToPllClk80/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2154 [get_cells {*HandshakeSLVFromUserClkPort5ToPllClk80/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2155 [get_cells {*HandshakeSLVFromUserClkPort5ToPllClk80/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2156 [get_cells {*HandshakeSLVFromUserClkPort5ToPllClk80/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2157 [get_cells {*HandshakeSLVFromUserClkPort5ToPllClk80/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2158 [get_cells {*HandshakeSLVFromUserClkPort5ToPllClk80/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2160 [get_cells {*HandshakeSLVFromUserClkPort5ToPllClk80/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2162 [get_cells {*HandshakeSLVFromUserClkPort5ToPllClk80/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2164 [get_cells {*HandshakeSLVFromUserClkPort5ToPllClk80/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2249 [get_cells {*DoubleSyncSLVFromUserClkPort5ToPllClk80*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2250 [get_cells {*DoubleSyncSLVFromUserClkPort5ToPllClk80*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2285 [get_cells {*HandshakeSLVFromUserClkPort6ToPllClk80/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2286 [get_cells {*HandshakeSLVFromUserClkPort6ToPllClk80/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2287 [get_cells {*HandshakeSLVFromUserClkPort6ToPllClk80/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2288 [get_cells {*HandshakeSLVFromUserClkPort6ToPllClk80/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2289 [get_cells {*HandshakeSLVFromUserClkPort6ToPllClk80/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2290 [get_cells {*HandshakeSLVFromUserClkPort6ToPllClk80/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2292 [get_cells {*HandshakeSLVFromUserClkPort6ToPllClk80/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2294 [get_cells {*HandshakeSLVFromUserClkPort6ToPllClk80/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2296 [get_cells {*HandshakeSLVFromUserClkPort6ToPllClk80/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2381 [get_cells {*DoubleSyncSLVFromUserClkPort6ToPllClk80*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2382 [get_cells {*DoubleSyncSLVFromUserClkPort6ToPllClk80*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2417 [get_cells {*HandshakeSLVFromUserClkPort7ToPllClk80/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2418 [get_cells {*HandshakeSLVFromUserClkPort7ToPllClk80/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2419 [get_cells {*HandshakeSLVFromUserClkPort7ToPllClk80/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2420 [get_cells {*HandshakeSLVFromUserClkPort7ToPllClk80/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2421 [get_cells {*HandshakeSLVFromUserClkPort7ToPllClk80/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2422 [get_cells {*HandshakeSLVFromUserClkPort7ToPllClk80/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2424 [get_cells {*HandshakeSLVFromUserClkPort7ToPllClk80/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2426 [get_cells {*HandshakeSLVFromUserClkPort7ToPllClk80/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2428 [get_cells {*HandshakeSLVFromUserClkPort7ToPllClk80/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2513 [get_cells {*DoubleSyncSLVFromUserClkPort7ToPllClk80*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2514 [get_cells {*DoubleSyncSLVFromUserClkPort7ToPllClk80*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2549 [get_cells {*HandshakeSLVFromUserClkPort8ToPllClk80/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2550 [get_cells {*HandshakeSLVFromUserClkPort8ToPllClk80/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2551 [get_cells {*HandshakeSLVFromUserClkPort8ToPllClk80/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2552 [get_cells {*HandshakeSLVFromUserClkPort8ToPllClk80/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2553 [get_cells {*HandshakeSLVFromUserClkPort8ToPllClk80/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2554 [get_cells {*HandshakeSLVFromUserClkPort8ToPllClk80/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2556 [get_cells {*HandshakeSLVFromUserClkPort8ToPllClk80/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2558 [get_cells {*HandshakeSLVFromUserClkPort8ToPllClk80/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2560 [get_cells {*HandshakeSLVFromUserClkPort8ToPllClk80/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2645 [get_cells {*DoubleSyncSLVFromUserClkPort8ToPllClk80*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2646 [get_cells {*DoubleSyncSLVFromUserClkPort8ToPllClk80*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2681 [get_cells {*HandshakeSLVFromUserClkPort9ToPllClk80/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2682 [get_cells {*HandshakeSLVFromUserClkPort9ToPllClk80/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2683 [get_cells {*HandshakeSLVFromUserClkPort9ToPllClk80/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2684 [get_cells {*HandshakeSLVFromUserClkPort9ToPllClk80/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2685 [get_cells {*HandshakeSLVFromUserClkPort9ToPllClk80/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2686 [get_cells {*HandshakeSLVFromUserClkPort9ToPllClk80/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2688 [get_cells {*HandshakeSLVFromUserClkPort9ToPllClk80/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2690 [get_cells {*HandshakeSLVFromUserClkPort9ToPllClk80/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2692 [get_cells {*HandshakeSLVFromUserClkPort9ToPllClk80/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2777 [get_cells {*DoubleSyncSLVFromUserClkPort9ToPllClk80*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2778 [get_cells {*DoubleSyncSLVFromUserClkPort9ToPllClk80*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2813 [get_cells {*HandshakeSLVFromUserClkPort10ToPllClk80/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2814 [get_cells {*HandshakeSLVFromUserClkPort10ToPllClk80/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2815 [get_cells {*HandshakeSLVFromUserClkPort10ToPllClk80/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2816 [get_cells {*HandshakeSLVFromUserClkPort10ToPllClk80/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2817 [get_cells {*HandshakeSLVFromUserClkPort10ToPllClk80/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2818 [get_cells {*HandshakeSLVFromUserClkPort10ToPllClk80/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2820 [get_cells {*HandshakeSLVFromUserClkPort10ToPllClk80/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2822 [get_cells {*HandshakeSLVFromUserClkPort10ToPllClk80/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2824 [get_cells {*HandshakeSLVFromUserClkPort10ToPllClk80/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2909 [get_cells {*DoubleSyncSLVFromUserClkPort10ToPllClk80*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2910 [get_cells {*DoubleSyncSLVFromUserClkPort10ToPllClk80*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2945 [get_cells {*HandshakeSLVFromUserClkPort11ToPllClk80/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2946 [get_cells {*HandshakeSLVFromUserClkPort11ToPllClk80/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2947 [get_cells {*HandshakeSLVFromUserClkPort11ToPllClk80/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2948 [get_cells {*HandshakeSLVFromUserClkPort11ToPllClk80/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2949 [get_cells {*HandshakeSLVFromUserClkPort11ToPllClk80/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2950 [get_cells {*HandshakeSLVFromUserClkPort11ToPllClk80/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2952 [get_cells {*HandshakeSLVFromUserClkPort11ToPllClk80/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2954 [get_cells {*HandshakeSLVFromUserClkPort11ToPllClk80/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom2956 [get_cells {*HandshakeSLVFromUserClkPort11ToPllClk80/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3041 [get_cells {*DoubleSyncSLVFromUserClkPort11ToPllClk80*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3042 [get_cells {*DoubleSyncSLVFromUserClkPort11ToPllClk80*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3077 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLV_Ackx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3078 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLV_Ackx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3079 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLV_Ackx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3080 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLV_Ackx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3081 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLV_Ackx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3082 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLV_Ackx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3084 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLV_Ackx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3086 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLV_Ackx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3088 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLV_Ackx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3089 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*PulseSyncBoolx/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3090 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*PulseSyncBoolx/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3091 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*PulseSyncBoolx/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3092 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*PulseSyncBoolx/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3093 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*PulseSyncBoolx/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3095 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLVx/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3096 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLVx/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3097 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLVx/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3098 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLVx/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3099 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLVx/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3100 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLVx/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3102 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLVx/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3104 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLVx/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3106 [get_cells {*TimeLoopCoreFromPllClk80ToPllClk80Derived5x2C00MHz/*HandshakeSLVx/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3407 [get_cells {*FPGAwHandshaken24/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3408 [get_cells {*FPGAwHandshaken24/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3409 [get_cells {*FPGAwHandshaken24/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3410 [get_cells {*FPGAwHandshaken24/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3411 [get_cells {*FPGAwHandshaken24/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3412 [get_cells {*FPGAwHandshaken24/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3414 [get_cells {*FPGAwHandshaken24/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3416 [get_cells {*FPGAwHandshaken24/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3418 [get_cells {*FPGAwHandshaken24/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3419 [get_cells {*FPGAwFIFOn23*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3420 [get_cells {*FPGAwFIFOn23*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3421 [get_cells {*FPGAwFIFOn23*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3422 [get_cells {*FPGAwFIFOn23*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3423 [get_cells {*FPGAwFIFOn23*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3425 [get_cells {*FPGAwFIFOn23*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3426 [get_cells {*FPGAwFIFOn23*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3427 [get_cells {*FPGAwFIFOn23*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3428 [get_cells {*FPGAwFIFOn23*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3429 [get_cells {*FPGAwFIFOn23*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3431 [get_cells {*FPGAwFIFOn23*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3432 [get_cells {*FPGAwFIFOn23*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3433 [get_cells {*FPGAwFIFOn23/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3434 [get_cells {*FPGAwFIFOn23/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3436 [get_cells {*FPGAwFIFOn23/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3437 [get_cells {*FPGAwFIFOn23/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3438 [get_cells {*FPGAwFIFOn23/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3440 [get_cells {*FPGAwFIFOn23/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3441 [get_cells {*FPGAwFIFOn22*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3442 [get_cells {*FPGAwFIFOn22*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3443 [get_cells {*FPGAwFIFOn22*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3444 [get_cells {*FPGAwFIFOn22*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3445 [get_cells {*FPGAwFIFOn22*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3447 [get_cells {*FPGAwFIFOn22*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3448 [get_cells {*FPGAwFIFOn22*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3449 [get_cells {*FPGAwFIFOn22*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3450 [get_cells {*FPGAwFIFOn22*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3451 [get_cells {*FPGAwFIFOn22*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3453 [get_cells {*FPGAwFIFOn22*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3454 [get_cells {*FPGAwFIFOn22*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3455 [get_cells {*FPGAwFIFOn22/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3456 [get_cells {*FPGAwFIFOn22/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3458 [get_cells {*FPGAwFIFOn22/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3459 [get_cells {*FPGAwFIFOn22/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3460 [get_cells {*FPGAwFIFOn22/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3462 [get_cells {*FPGAwFIFOn22/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3463 [get_cells {*FPGAwHandshaken39/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3464 [get_cells {*FPGAwHandshaken39/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3465 [get_cells {*FPGAwHandshaken39/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3466 [get_cells {*FPGAwHandshaken39/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3467 [get_cells {*FPGAwHandshaken39/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3468 [get_cells {*FPGAwHandshaken39/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3470 [get_cells {*FPGAwHandshaken39/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3472 [get_cells {*FPGAwHandshaken39/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3474 [get_cells {*FPGAwHandshaken39/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3475 [get_cells {*FPGAwHandshaken44/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3476 [get_cells {*FPGAwHandshaken44/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3477 [get_cells {*FPGAwHandshaken44/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3478 [get_cells {*FPGAwHandshaken44/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3479 [get_cells {*FPGAwHandshaken44/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3480 [get_cells {*FPGAwHandshaken44/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3482 [get_cells {*FPGAwHandshaken44/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3484 [get_cells {*FPGAwHandshaken44/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3486 [get_cells {*FPGAwHandshaken44/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3487 [get_cells {*FPGAwHandshaken45/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3488 [get_cells {*FPGAwHandshaken45/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3489 [get_cells {*FPGAwHandshaken45/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3490 [get_cells {*FPGAwHandshaken45/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3491 [get_cells {*FPGAwHandshaken45/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3492 [get_cells {*FPGAwHandshaken45/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3494 [get_cells {*FPGAwHandshaken45/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3496 [get_cells {*FPGAwHandshaken45/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3498 [get_cells {*FPGAwHandshaken45/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3499 [get_cells {*FPGAwHandshaken47/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3500 [get_cells {*FPGAwHandshaken47/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3501 [get_cells {*FPGAwHandshaken47/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3502 [get_cells {*FPGAwHandshaken47/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3503 [get_cells {*FPGAwHandshaken47/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3504 [get_cells {*FPGAwHandshaken47/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3506 [get_cells {*FPGAwHandshaken47/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3508 [get_cells {*FPGAwHandshaken47/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3510 [get_cells {*FPGAwHandshaken47/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3511 [get_cells {*FPGAwHandshaken48/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3512 [get_cells {*FPGAwHandshaken48/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3513 [get_cells {*FPGAwHandshaken48/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3514 [get_cells {*FPGAwHandshaken48/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3515 [get_cells {*FPGAwHandshaken48/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3516 [get_cells {*FPGAwHandshaken48/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3518 [get_cells {*FPGAwHandshaken48/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3520 [get_cells {*FPGAwHandshaken48/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3522 [get_cells {*FPGAwHandshaken48/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3523 [get_cells {*FPGAwFIFOn21*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3524 [get_cells {*FPGAwFIFOn21*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3525 [get_cells {*FPGAwFIFOn21*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3526 [get_cells {*FPGAwFIFOn21*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3527 [get_cells {*FPGAwFIFOn21*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3529 [get_cells {*FPGAwFIFOn21*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3530 [get_cells {*FPGAwFIFOn21*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3531 [get_cells {*FPGAwFIFOn21*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3532 [get_cells {*FPGAwFIFOn21*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3533 [get_cells {*FPGAwFIFOn21*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3535 [get_cells {*FPGAwFIFOn21*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3536 [get_cells {*FPGAwFIFOn21*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3537 [get_cells {*FPGAwFIFOn21/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3538 [get_cells {*FPGAwFIFOn21/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3540 [get_cells {*FPGAwFIFOn21/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3541 [get_cells {*FPGAwFIFOn21/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3542 [get_cells {*FPGAwFIFOn21/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3544 [get_cells {*FPGAwFIFOn21/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3545 [get_cells {*FPGAwFIFOn20*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3546 [get_cells {*FPGAwFIFOn20*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3547 [get_cells {*FPGAwFIFOn20*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3548 [get_cells {*FPGAwFIFOn20*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3549 [get_cells {*FPGAwFIFOn20*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3551 [get_cells {*FPGAwFIFOn20*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3552 [get_cells {*FPGAwFIFOn20*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3553 [get_cells {*FPGAwFIFOn20*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3554 [get_cells {*FPGAwFIFOn20*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3555 [get_cells {*FPGAwFIFOn20*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3557 [get_cells {*FPGAwFIFOn20*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3558 [get_cells {*FPGAwFIFOn20*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3559 [get_cells {*FPGAwFIFOn20/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3560 [get_cells {*FPGAwFIFOn20/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3562 [get_cells {*FPGAwFIFOn20/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3563 [get_cells {*FPGAwFIFOn20/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3564 [get_cells {*FPGAwFIFOn20/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3566 [get_cells {*FPGAwFIFOn20/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3567 [get_cells {*FPGAwHandshaken77/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3568 [get_cells {*FPGAwHandshaken77/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3569 [get_cells {*FPGAwHandshaken77/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3570 [get_cells {*FPGAwHandshaken77/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3571 [get_cells {*FPGAwHandshaken77/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3572 [get_cells {*FPGAwHandshaken77/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3574 [get_cells {*FPGAwHandshaken77/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3576 [get_cells {*FPGAwHandshaken77/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3578 [get_cells {*FPGAwHandshaken77/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3579 [get_cells {*FPGAwHandshaken82/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3580 [get_cells {*FPGAwHandshaken82/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3581 [get_cells {*FPGAwHandshaken82/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3582 [get_cells {*FPGAwHandshaken82/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3583 [get_cells {*FPGAwHandshaken82/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3584 [get_cells {*FPGAwHandshaken82/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3586 [get_cells {*FPGAwHandshaken82/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3588 [get_cells {*FPGAwHandshaken82/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3590 [get_cells {*FPGAwHandshaken82/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3591 [get_cells {*FPGAwHandshaken83/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3592 [get_cells {*FPGAwHandshaken83/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3593 [get_cells {*FPGAwHandshaken83/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3594 [get_cells {*FPGAwHandshaken83/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3595 [get_cells {*FPGAwHandshaken83/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3596 [get_cells {*FPGAwHandshaken83/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3598 [get_cells {*FPGAwHandshaken83/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3600 [get_cells {*FPGAwHandshaken83/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3602 [get_cells {*FPGAwHandshaken83/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3603 [get_cells {*FPGAwHandshaken85/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3604 [get_cells {*FPGAwHandshaken85/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3605 [get_cells {*FPGAwHandshaken85/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3606 [get_cells {*FPGAwHandshaken85/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3607 [get_cells {*FPGAwHandshaken85/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3608 [get_cells {*FPGAwHandshaken85/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3610 [get_cells {*FPGAwHandshaken85/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3612 [get_cells {*FPGAwHandshaken85/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3614 [get_cells {*FPGAwHandshaken85/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3615 [get_cells {*FPGAwHandshaken86/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3616 [get_cells {*FPGAwHandshaken86/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3617 [get_cells {*FPGAwHandshaken86/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3618 [get_cells {*FPGAwHandshaken86/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3619 [get_cells {*FPGAwHandshaken86/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3620 [get_cells {*FPGAwHandshaken86/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3622 [get_cells {*FPGAwHandshaken86/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3624 [get_cells {*FPGAwHandshaken86/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3626 [get_cells {*FPGAwHandshaken86/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3627 [get_cells {*FPGAwFIFOn19*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3628 [get_cells {*FPGAwFIFOn19*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3629 [get_cells {*FPGAwFIFOn19*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3630 [get_cells {*FPGAwFIFOn19*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3631 [get_cells {*FPGAwFIFOn19*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3633 [get_cells {*FPGAwFIFOn19*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3634 [get_cells {*FPGAwFIFOn19*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3635 [get_cells {*FPGAwFIFOn19*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3636 [get_cells {*FPGAwFIFOn19*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3637 [get_cells {*FPGAwFIFOn19*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3639 [get_cells {*FPGAwFIFOn19*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3640 [get_cells {*FPGAwFIFOn19*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3641 [get_cells {*FPGAwFIFOn19/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3642 [get_cells {*FPGAwFIFOn19/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3644 [get_cells {*FPGAwFIFOn19/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3645 [get_cells {*FPGAwFIFOn19/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3646 [get_cells {*FPGAwFIFOn19/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3648 [get_cells {*FPGAwFIFOn19/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3649 [get_cells {*FPGAwFIFOn18*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3650 [get_cells {*FPGAwFIFOn18*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3651 [get_cells {*FPGAwFIFOn18*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3652 [get_cells {*FPGAwFIFOn18*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3653 [get_cells {*FPGAwFIFOn18*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3655 [get_cells {*FPGAwFIFOn18*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3656 [get_cells {*FPGAwFIFOn18*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3657 [get_cells {*FPGAwFIFOn18*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3658 [get_cells {*FPGAwFIFOn18*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3659 [get_cells {*FPGAwFIFOn18*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3661 [get_cells {*FPGAwFIFOn18*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3662 [get_cells {*FPGAwFIFOn18*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3663 [get_cells {*FPGAwFIFOn18/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3664 [get_cells {*FPGAwFIFOn18/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3666 [get_cells {*FPGAwFIFOn18/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3667 [get_cells {*FPGAwFIFOn18/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3668 [get_cells {*FPGAwFIFOn18/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3670 [get_cells {*FPGAwFIFOn18/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3671 [get_cells {*FPGAwHandshaken115/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3672 [get_cells {*FPGAwHandshaken115/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3673 [get_cells {*FPGAwHandshaken115/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3674 [get_cells {*FPGAwHandshaken115/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3675 [get_cells {*FPGAwHandshaken115/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3676 [get_cells {*FPGAwHandshaken115/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3678 [get_cells {*FPGAwHandshaken115/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3680 [get_cells {*FPGAwHandshaken115/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3682 [get_cells {*FPGAwHandshaken115/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3683 [get_cells {*FPGAwHandshaken120/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3684 [get_cells {*FPGAwHandshaken120/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3685 [get_cells {*FPGAwHandshaken120/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3686 [get_cells {*FPGAwHandshaken120/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3687 [get_cells {*FPGAwHandshaken120/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3688 [get_cells {*FPGAwHandshaken120/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3690 [get_cells {*FPGAwHandshaken120/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3692 [get_cells {*FPGAwHandshaken120/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3694 [get_cells {*FPGAwHandshaken120/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3695 [get_cells {*FPGAwHandshaken121/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3696 [get_cells {*FPGAwHandshaken121/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3697 [get_cells {*FPGAwHandshaken121/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3698 [get_cells {*FPGAwHandshaken121/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3699 [get_cells {*FPGAwHandshaken121/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3700 [get_cells {*FPGAwHandshaken121/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3702 [get_cells {*FPGAwHandshaken121/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3704 [get_cells {*FPGAwHandshaken121/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3706 [get_cells {*FPGAwHandshaken121/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3707 [get_cells {*FPGAwHandshaken123/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3708 [get_cells {*FPGAwHandshaken123/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3709 [get_cells {*FPGAwHandshaken123/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3710 [get_cells {*FPGAwHandshaken123/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3711 [get_cells {*FPGAwHandshaken123/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3712 [get_cells {*FPGAwHandshaken123/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3714 [get_cells {*FPGAwHandshaken123/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3716 [get_cells {*FPGAwHandshaken123/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3718 [get_cells {*FPGAwHandshaken123/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3719 [get_cells {*FPGAwHandshaken124/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3720 [get_cells {*FPGAwHandshaken124/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3721 [get_cells {*FPGAwHandshaken124/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3722 [get_cells {*FPGAwHandshaken124/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3723 [get_cells {*FPGAwHandshaken124/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3724 [get_cells {*FPGAwHandshaken124/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3726 [get_cells {*FPGAwHandshaken124/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3728 [get_cells {*FPGAwHandshaken124/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3730 [get_cells {*FPGAwHandshaken124/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3731 [get_cells {*FPGAwFIFOn17*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3732 [get_cells {*FPGAwFIFOn17*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3733 [get_cells {*FPGAwFIFOn17*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3734 [get_cells {*FPGAwFIFOn17*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3735 [get_cells {*FPGAwFIFOn17*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3737 [get_cells {*FPGAwFIFOn17*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3738 [get_cells {*FPGAwFIFOn17*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3739 [get_cells {*FPGAwFIFOn17*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3740 [get_cells {*FPGAwFIFOn17*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3741 [get_cells {*FPGAwFIFOn17*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3743 [get_cells {*FPGAwFIFOn17*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3744 [get_cells {*FPGAwFIFOn17*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3745 [get_cells {*FPGAwFIFOn17/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3746 [get_cells {*FPGAwFIFOn17/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3748 [get_cells {*FPGAwFIFOn17/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3749 [get_cells {*FPGAwFIFOn17/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3750 [get_cells {*FPGAwFIFOn17/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3752 [get_cells {*FPGAwFIFOn17/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3753 [get_cells {*FPGAwFIFOn16*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3754 [get_cells {*FPGAwFIFOn16*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3755 [get_cells {*FPGAwFIFOn16*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3756 [get_cells {*FPGAwFIFOn16*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3757 [get_cells {*FPGAwFIFOn16*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3759 [get_cells {*FPGAwFIFOn16*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3760 [get_cells {*FPGAwFIFOn16*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3761 [get_cells {*FPGAwFIFOn16*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3762 [get_cells {*FPGAwFIFOn16*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3763 [get_cells {*FPGAwFIFOn16*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3765 [get_cells {*FPGAwFIFOn16*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3766 [get_cells {*FPGAwFIFOn16*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3767 [get_cells {*FPGAwFIFOn16/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3768 [get_cells {*FPGAwFIFOn16/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3770 [get_cells {*FPGAwFIFOn16/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3771 [get_cells {*FPGAwFIFOn16/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3772 [get_cells {*FPGAwFIFOn16/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3774 [get_cells {*FPGAwFIFOn16/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3775 [get_cells {*FPGAwHandshaken153/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3776 [get_cells {*FPGAwHandshaken153/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3777 [get_cells {*FPGAwHandshaken153/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3778 [get_cells {*FPGAwHandshaken153/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3779 [get_cells {*FPGAwHandshaken153/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3780 [get_cells {*FPGAwHandshaken153/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3782 [get_cells {*FPGAwHandshaken153/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3784 [get_cells {*FPGAwHandshaken153/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3786 [get_cells {*FPGAwHandshaken153/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3787 [get_cells {*FPGAwHandshaken158/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3788 [get_cells {*FPGAwHandshaken158/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3789 [get_cells {*FPGAwHandshaken158/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3790 [get_cells {*FPGAwHandshaken158/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3791 [get_cells {*FPGAwHandshaken158/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3792 [get_cells {*FPGAwHandshaken158/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3794 [get_cells {*FPGAwHandshaken158/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3796 [get_cells {*FPGAwHandshaken158/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3798 [get_cells {*FPGAwHandshaken158/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3799 [get_cells {*FPGAwHandshaken159/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3800 [get_cells {*FPGAwHandshaken159/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3801 [get_cells {*FPGAwHandshaken159/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3802 [get_cells {*FPGAwHandshaken159/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3803 [get_cells {*FPGAwHandshaken159/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3804 [get_cells {*FPGAwHandshaken159/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3806 [get_cells {*FPGAwHandshaken159/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3808 [get_cells {*FPGAwHandshaken159/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3810 [get_cells {*FPGAwHandshaken159/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3811 [get_cells {*FPGAwHandshaken161/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3812 [get_cells {*FPGAwHandshaken161/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3813 [get_cells {*FPGAwHandshaken161/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3814 [get_cells {*FPGAwHandshaken161/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3815 [get_cells {*FPGAwHandshaken161/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3816 [get_cells {*FPGAwHandshaken161/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3818 [get_cells {*FPGAwHandshaken161/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3820 [get_cells {*FPGAwHandshaken161/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3822 [get_cells {*FPGAwHandshaken161/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3823 [get_cells {*FPGAwHandshaken162/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3824 [get_cells {*FPGAwHandshaken162/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3825 [get_cells {*FPGAwHandshaken162/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3826 [get_cells {*FPGAwHandshaken162/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3827 [get_cells {*FPGAwHandshaken162/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3828 [get_cells {*FPGAwHandshaken162/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3830 [get_cells {*FPGAwHandshaken162/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3832 [get_cells {*FPGAwHandshaken162/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3834 [get_cells {*FPGAwHandshaken162/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3835 [get_cells {*FPGAwFIFOn15*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3836 [get_cells {*FPGAwFIFOn15*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3837 [get_cells {*FPGAwFIFOn15*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3838 [get_cells {*FPGAwFIFOn15*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3839 [get_cells {*FPGAwFIFOn15*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3841 [get_cells {*FPGAwFIFOn15*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3842 [get_cells {*FPGAwFIFOn15*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3843 [get_cells {*FPGAwFIFOn15*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3844 [get_cells {*FPGAwFIFOn15*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3845 [get_cells {*FPGAwFIFOn15*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3847 [get_cells {*FPGAwFIFOn15*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3848 [get_cells {*FPGAwFIFOn15*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3849 [get_cells {*FPGAwFIFOn15/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3850 [get_cells {*FPGAwFIFOn15/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3852 [get_cells {*FPGAwFIFOn15/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3853 [get_cells {*FPGAwFIFOn15/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3854 [get_cells {*FPGAwFIFOn15/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3856 [get_cells {*FPGAwFIFOn15/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3857 [get_cells {*FPGAwFIFOn14*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3858 [get_cells {*FPGAwFIFOn14*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3859 [get_cells {*FPGAwFIFOn14*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3860 [get_cells {*FPGAwFIFOn14*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3861 [get_cells {*FPGAwFIFOn14*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3863 [get_cells {*FPGAwFIFOn14*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3864 [get_cells {*FPGAwFIFOn14*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3865 [get_cells {*FPGAwFIFOn14*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3866 [get_cells {*FPGAwFIFOn14*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3867 [get_cells {*FPGAwFIFOn14*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3869 [get_cells {*FPGAwFIFOn14*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3870 [get_cells {*FPGAwFIFOn14*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3871 [get_cells {*FPGAwFIFOn14/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3872 [get_cells {*FPGAwFIFOn14/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3874 [get_cells {*FPGAwFIFOn14/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3875 [get_cells {*FPGAwFIFOn14/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3876 [get_cells {*FPGAwFIFOn14/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3878 [get_cells {*FPGAwFIFOn14/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3879 [get_cells {*FPGAwHandshaken191/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3880 [get_cells {*FPGAwHandshaken191/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3881 [get_cells {*FPGAwHandshaken191/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3882 [get_cells {*FPGAwHandshaken191/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3883 [get_cells {*FPGAwHandshaken191/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3884 [get_cells {*FPGAwHandshaken191/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3886 [get_cells {*FPGAwHandshaken191/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3888 [get_cells {*FPGAwHandshaken191/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3890 [get_cells {*FPGAwHandshaken191/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3891 [get_cells {*FPGAwHandshaken196/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3892 [get_cells {*FPGAwHandshaken196/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3893 [get_cells {*FPGAwHandshaken196/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3894 [get_cells {*FPGAwHandshaken196/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3895 [get_cells {*FPGAwHandshaken196/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3896 [get_cells {*FPGAwHandshaken196/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3898 [get_cells {*FPGAwHandshaken196/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3900 [get_cells {*FPGAwHandshaken196/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3902 [get_cells {*FPGAwHandshaken196/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3903 [get_cells {*FPGAwHandshaken197/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3904 [get_cells {*FPGAwHandshaken197/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3905 [get_cells {*FPGAwHandshaken197/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3906 [get_cells {*FPGAwHandshaken197/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3907 [get_cells {*FPGAwHandshaken197/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3908 [get_cells {*FPGAwHandshaken197/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3910 [get_cells {*FPGAwHandshaken197/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3912 [get_cells {*FPGAwHandshaken197/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3914 [get_cells {*FPGAwHandshaken197/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3915 [get_cells {*FPGAwHandshaken199/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3916 [get_cells {*FPGAwHandshaken199/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3917 [get_cells {*FPGAwHandshaken199/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3918 [get_cells {*FPGAwHandshaken199/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3919 [get_cells {*FPGAwHandshaken199/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3920 [get_cells {*FPGAwHandshaken199/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3922 [get_cells {*FPGAwHandshaken199/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3924 [get_cells {*FPGAwHandshaken199/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3926 [get_cells {*FPGAwHandshaken199/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3927 [get_cells {*FPGAwHandshaken200/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3928 [get_cells {*FPGAwHandshaken200/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3929 [get_cells {*FPGAwHandshaken200/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3930 [get_cells {*FPGAwHandshaken200/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3931 [get_cells {*FPGAwHandshaken200/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3932 [get_cells {*FPGAwHandshaken200/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3934 [get_cells {*FPGAwHandshaken200/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3936 [get_cells {*FPGAwHandshaken200/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3938 [get_cells {*FPGAwHandshaken200/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3939 [get_cells {*FPGAwFIFOn13*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3940 [get_cells {*FPGAwFIFOn13*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3941 [get_cells {*FPGAwFIFOn13*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3942 [get_cells {*FPGAwFIFOn13*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3943 [get_cells {*FPGAwFIFOn13*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3945 [get_cells {*FPGAwFIFOn13*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3946 [get_cells {*FPGAwFIFOn13*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3947 [get_cells {*FPGAwFIFOn13*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3948 [get_cells {*FPGAwFIFOn13*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3949 [get_cells {*FPGAwFIFOn13*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3951 [get_cells {*FPGAwFIFOn13*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3952 [get_cells {*FPGAwFIFOn13*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3953 [get_cells {*FPGAwFIFOn13/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3954 [get_cells {*FPGAwFIFOn13/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3956 [get_cells {*FPGAwFIFOn13/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3957 [get_cells {*FPGAwFIFOn13/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3958 [get_cells {*FPGAwFIFOn13/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3960 [get_cells {*FPGAwFIFOn13/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3961 [get_cells {*FPGAwFIFOn12*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3962 [get_cells {*FPGAwFIFOn12*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3963 [get_cells {*FPGAwFIFOn12*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3964 [get_cells {*FPGAwFIFOn12*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3965 [get_cells {*FPGAwFIFOn12*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3967 [get_cells {*FPGAwFIFOn12*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3968 [get_cells {*FPGAwFIFOn12*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3969 [get_cells {*FPGAwFIFOn12*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3970 [get_cells {*FPGAwFIFOn12*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3971 [get_cells {*FPGAwFIFOn12*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3973 [get_cells {*FPGAwFIFOn12*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3974 [get_cells {*FPGAwFIFOn12*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3975 [get_cells {*FPGAwFIFOn12/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3976 [get_cells {*FPGAwFIFOn12/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3978 [get_cells {*FPGAwFIFOn12/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3979 [get_cells {*FPGAwFIFOn12/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3980 [get_cells {*FPGAwFIFOn12/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3982 [get_cells {*FPGAwFIFOn12/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3983 [get_cells {*FPGAwHandshaken229/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3984 [get_cells {*FPGAwHandshaken229/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3985 [get_cells {*FPGAwHandshaken229/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3986 [get_cells {*FPGAwHandshaken229/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3987 [get_cells {*FPGAwHandshaken229/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3988 [get_cells {*FPGAwHandshaken229/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3990 [get_cells {*FPGAwHandshaken229/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3992 [get_cells {*FPGAwHandshaken229/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3994 [get_cells {*FPGAwHandshaken229/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3995 [get_cells {*FPGAwHandshaken234/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3996 [get_cells {*FPGAwHandshaken234/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3997 [get_cells {*FPGAwHandshaken234/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3998 [get_cells {*FPGAwHandshaken234/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom3999 [get_cells {*FPGAwHandshaken234/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4000 [get_cells {*FPGAwHandshaken234/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4002 [get_cells {*FPGAwHandshaken234/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4004 [get_cells {*FPGAwHandshaken234/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4006 [get_cells {*FPGAwHandshaken234/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4007 [get_cells {*FPGAwHandshaken235/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4008 [get_cells {*FPGAwHandshaken235/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4009 [get_cells {*FPGAwHandshaken235/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4010 [get_cells {*FPGAwHandshaken235/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4011 [get_cells {*FPGAwHandshaken235/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4012 [get_cells {*FPGAwHandshaken235/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4014 [get_cells {*FPGAwHandshaken235/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4016 [get_cells {*FPGAwHandshaken235/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4018 [get_cells {*FPGAwHandshaken235/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4019 [get_cells {*FPGAwHandshaken237/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4020 [get_cells {*FPGAwHandshaken237/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4021 [get_cells {*FPGAwHandshaken237/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4022 [get_cells {*FPGAwHandshaken237/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4023 [get_cells {*FPGAwHandshaken237/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4024 [get_cells {*FPGAwHandshaken237/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4026 [get_cells {*FPGAwHandshaken237/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4028 [get_cells {*FPGAwHandshaken237/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4030 [get_cells {*FPGAwHandshaken237/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4031 [get_cells {*FPGAwHandshaken238/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4032 [get_cells {*FPGAwHandshaken238/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4033 [get_cells {*FPGAwHandshaken238/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4034 [get_cells {*FPGAwHandshaken238/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4035 [get_cells {*FPGAwHandshaken238/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4036 [get_cells {*FPGAwHandshaken238/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4038 [get_cells {*FPGAwHandshaken238/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4040 [get_cells {*FPGAwHandshaken238/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4042 [get_cells {*FPGAwHandshaken238/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4043 [get_cells {*FPGAwFIFOn11*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4044 [get_cells {*FPGAwFIFOn11*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4045 [get_cells {*FPGAwFIFOn11*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4046 [get_cells {*FPGAwFIFOn11*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4047 [get_cells {*FPGAwFIFOn11*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4049 [get_cells {*FPGAwFIFOn11*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4050 [get_cells {*FPGAwFIFOn11*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4051 [get_cells {*FPGAwFIFOn11*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4052 [get_cells {*FPGAwFIFOn11*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4053 [get_cells {*FPGAwFIFOn11*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4055 [get_cells {*FPGAwFIFOn11*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4056 [get_cells {*FPGAwFIFOn11*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4057 [get_cells {*FPGAwFIFOn11/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4058 [get_cells {*FPGAwFIFOn11/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4060 [get_cells {*FPGAwFIFOn11/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4061 [get_cells {*FPGAwFIFOn11/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4062 [get_cells {*FPGAwFIFOn11/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4064 [get_cells {*FPGAwFIFOn11/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4065 [get_cells {*FPGAwFIFOn10*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4066 [get_cells {*FPGAwFIFOn10*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4067 [get_cells {*FPGAwFIFOn10*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4068 [get_cells {*FPGAwFIFOn10*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4069 [get_cells {*FPGAwFIFOn10*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4071 [get_cells {*FPGAwFIFOn10*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4072 [get_cells {*FPGAwFIFOn10*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4073 [get_cells {*FPGAwFIFOn10*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4074 [get_cells {*FPGAwFIFOn10*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4075 [get_cells {*FPGAwFIFOn10*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4077 [get_cells {*FPGAwFIFOn10*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4078 [get_cells {*FPGAwFIFOn10*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4079 [get_cells {*FPGAwFIFOn10/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4080 [get_cells {*FPGAwFIFOn10/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4082 [get_cells {*FPGAwFIFOn10/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4083 [get_cells {*FPGAwFIFOn10/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4084 [get_cells {*FPGAwFIFOn10/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4086 [get_cells {*FPGAwFIFOn10/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4087 [get_cells {*FPGAwHandshaken267/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4088 [get_cells {*FPGAwHandshaken267/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4089 [get_cells {*FPGAwHandshaken267/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4090 [get_cells {*FPGAwHandshaken267/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4091 [get_cells {*FPGAwHandshaken267/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4092 [get_cells {*FPGAwHandshaken267/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4094 [get_cells {*FPGAwHandshaken267/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4096 [get_cells {*FPGAwHandshaken267/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4098 [get_cells {*FPGAwHandshaken267/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4099 [get_cells {*FPGAwHandshaken272/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4100 [get_cells {*FPGAwHandshaken272/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4101 [get_cells {*FPGAwHandshaken272/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4102 [get_cells {*FPGAwHandshaken272/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4103 [get_cells {*FPGAwHandshaken272/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4104 [get_cells {*FPGAwHandshaken272/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4106 [get_cells {*FPGAwHandshaken272/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4108 [get_cells {*FPGAwHandshaken272/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4110 [get_cells {*FPGAwHandshaken272/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4111 [get_cells {*FPGAwHandshaken273/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4112 [get_cells {*FPGAwHandshaken273/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4113 [get_cells {*FPGAwHandshaken273/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4114 [get_cells {*FPGAwHandshaken273/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4115 [get_cells {*FPGAwHandshaken273/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4116 [get_cells {*FPGAwHandshaken273/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4118 [get_cells {*FPGAwHandshaken273/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4120 [get_cells {*FPGAwHandshaken273/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4122 [get_cells {*FPGAwHandshaken273/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4123 [get_cells {*FPGAwHandshaken275/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4124 [get_cells {*FPGAwHandshaken275/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4125 [get_cells {*FPGAwHandshaken275/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4126 [get_cells {*FPGAwHandshaken275/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4127 [get_cells {*FPGAwHandshaken275/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4128 [get_cells {*FPGAwHandshaken275/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4130 [get_cells {*FPGAwHandshaken275/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4132 [get_cells {*FPGAwHandshaken275/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4134 [get_cells {*FPGAwHandshaken275/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4135 [get_cells {*FPGAwHandshaken276/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4136 [get_cells {*FPGAwHandshaken276/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4137 [get_cells {*FPGAwHandshaken276/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4138 [get_cells {*FPGAwHandshaken276/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4139 [get_cells {*FPGAwHandshaken276/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4140 [get_cells {*FPGAwHandshaken276/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4142 [get_cells {*FPGAwHandshaken276/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4144 [get_cells {*FPGAwHandshaken276/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4146 [get_cells {*FPGAwHandshaken276/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4147 [get_cells {*FPGAwFIFOn9*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4148 [get_cells {*FPGAwFIFOn9*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4149 [get_cells {*FPGAwFIFOn9*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4150 [get_cells {*FPGAwFIFOn9*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4151 [get_cells {*FPGAwFIFOn9*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4153 [get_cells {*FPGAwFIFOn9*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4154 [get_cells {*FPGAwFIFOn9*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4155 [get_cells {*FPGAwFIFOn9*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4156 [get_cells {*FPGAwFIFOn9*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4157 [get_cells {*FPGAwFIFOn9*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4159 [get_cells {*FPGAwFIFOn9*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4160 [get_cells {*FPGAwFIFOn9*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4161 [get_cells {*FPGAwFIFOn9/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4162 [get_cells {*FPGAwFIFOn9/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4164 [get_cells {*FPGAwFIFOn9/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4165 [get_cells {*FPGAwFIFOn9/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4166 [get_cells {*FPGAwFIFOn9/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4168 [get_cells {*FPGAwFIFOn9/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4169 [get_cells {*FPGAwFIFOn8*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4170 [get_cells {*FPGAwFIFOn8*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4171 [get_cells {*FPGAwFIFOn8*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4172 [get_cells {*FPGAwFIFOn8*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4173 [get_cells {*FPGAwFIFOn8*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4175 [get_cells {*FPGAwFIFOn8*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4176 [get_cells {*FPGAwFIFOn8*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4177 [get_cells {*FPGAwFIFOn8*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4178 [get_cells {*FPGAwFIFOn8*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4179 [get_cells {*FPGAwFIFOn8*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4181 [get_cells {*FPGAwFIFOn8*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4182 [get_cells {*FPGAwFIFOn8*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4183 [get_cells {*FPGAwFIFOn8/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4184 [get_cells {*FPGAwFIFOn8/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4186 [get_cells {*FPGAwFIFOn8/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4187 [get_cells {*FPGAwFIFOn8/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4188 [get_cells {*FPGAwFIFOn8/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4190 [get_cells {*FPGAwFIFOn8/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4191 [get_cells {*FPGAwHandshaken305/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4192 [get_cells {*FPGAwHandshaken305/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4193 [get_cells {*FPGAwHandshaken305/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4194 [get_cells {*FPGAwHandshaken305/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4195 [get_cells {*FPGAwHandshaken305/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4196 [get_cells {*FPGAwHandshaken305/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4198 [get_cells {*FPGAwHandshaken305/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4200 [get_cells {*FPGAwHandshaken305/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4202 [get_cells {*FPGAwHandshaken305/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4203 [get_cells {*FPGAwHandshaken310/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4204 [get_cells {*FPGAwHandshaken310/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4205 [get_cells {*FPGAwHandshaken310/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4206 [get_cells {*FPGAwHandshaken310/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4207 [get_cells {*FPGAwHandshaken310/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4208 [get_cells {*FPGAwHandshaken310/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4210 [get_cells {*FPGAwHandshaken310/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4212 [get_cells {*FPGAwHandshaken310/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4214 [get_cells {*FPGAwHandshaken310/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4215 [get_cells {*FPGAwHandshaken311/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4216 [get_cells {*FPGAwHandshaken311/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4217 [get_cells {*FPGAwHandshaken311/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4218 [get_cells {*FPGAwHandshaken311/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4219 [get_cells {*FPGAwHandshaken311/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4220 [get_cells {*FPGAwHandshaken311/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4222 [get_cells {*FPGAwHandshaken311/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4224 [get_cells {*FPGAwHandshaken311/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4226 [get_cells {*FPGAwHandshaken311/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4227 [get_cells {*FPGAwHandshaken313/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4228 [get_cells {*FPGAwHandshaken313/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4229 [get_cells {*FPGAwHandshaken313/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4230 [get_cells {*FPGAwHandshaken313/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4231 [get_cells {*FPGAwHandshaken313/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4232 [get_cells {*FPGAwHandshaken313/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4234 [get_cells {*FPGAwHandshaken313/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4236 [get_cells {*FPGAwHandshaken313/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4238 [get_cells {*FPGAwHandshaken313/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4239 [get_cells {*FPGAwHandshaken314/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4240 [get_cells {*FPGAwHandshaken314/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4241 [get_cells {*FPGAwHandshaken314/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4242 [get_cells {*FPGAwHandshaken314/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4243 [get_cells {*FPGAwHandshaken314/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4244 [get_cells {*FPGAwHandshaken314/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4246 [get_cells {*FPGAwHandshaken314/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4248 [get_cells {*FPGAwHandshaken314/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4250 [get_cells {*FPGAwHandshaken314/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4251 [get_cells {*FPGAwFIFOn7*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4252 [get_cells {*FPGAwFIFOn7*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4253 [get_cells {*FPGAwFIFOn7*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4254 [get_cells {*FPGAwFIFOn7*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4255 [get_cells {*FPGAwFIFOn7*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4257 [get_cells {*FPGAwFIFOn7*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4258 [get_cells {*FPGAwFIFOn7*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4259 [get_cells {*FPGAwFIFOn7*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4260 [get_cells {*FPGAwFIFOn7*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4261 [get_cells {*FPGAwFIFOn7*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4263 [get_cells {*FPGAwFIFOn7*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4264 [get_cells {*FPGAwFIFOn7*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4265 [get_cells {*FPGAwFIFOn7/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4266 [get_cells {*FPGAwFIFOn7/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4268 [get_cells {*FPGAwFIFOn7/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4269 [get_cells {*FPGAwFIFOn7/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4270 [get_cells {*FPGAwFIFOn7/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4272 [get_cells {*FPGAwFIFOn7/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4273 [get_cells {*FPGAwFIFOn6*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4274 [get_cells {*FPGAwFIFOn6*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4275 [get_cells {*FPGAwFIFOn6*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4276 [get_cells {*FPGAwFIFOn6*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4277 [get_cells {*FPGAwFIFOn6*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4279 [get_cells {*FPGAwFIFOn6*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4280 [get_cells {*FPGAwFIFOn6*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4281 [get_cells {*FPGAwFIFOn6*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4282 [get_cells {*FPGAwFIFOn6*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4283 [get_cells {*FPGAwFIFOn6*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4285 [get_cells {*FPGAwFIFOn6*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4286 [get_cells {*FPGAwFIFOn6*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4287 [get_cells {*FPGAwFIFOn6/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4288 [get_cells {*FPGAwFIFOn6/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4290 [get_cells {*FPGAwFIFOn6/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4291 [get_cells {*FPGAwFIFOn6/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4292 [get_cells {*FPGAwFIFOn6/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4294 [get_cells {*FPGAwFIFOn6/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4295 [get_cells {*FPGAwHandshaken343/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4296 [get_cells {*FPGAwHandshaken343/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4297 [get_cells {*FPGAwHandshaken343/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4298 [get_cells {*FPGAwHandshaken343/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4299 [get_cells {*FPGAwHandshaken343/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4300 [get_cells {*FPGAwHandshaken343/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4302 [get_cells {*FPGAwHandshaken343/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4304 [get_cells {*FPGAwHandshaken343/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4306 [get_cells {*FPGAwHandshaken343/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4307 [get_cells {*FPGAwHandshaken348/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4308 [get_cells {*FPGAwHandshaken348/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4309 [get_cells {*FPGAwHandshaken348/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4310 [get_cells {*FPGAwHandshaken348/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4311 [get_cells {*FPGAwHandshaken348/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4312 [get_cells {*FPGAwHandshaken348/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4314 [get_cells {*FPGAwHandshaken348/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4316 [get_cells {*FPGAwHandshaken348/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4318 [get_cells {*FPGAwHandshaken348/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4319 [get_cells {*FPGAwHandshaken349/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4320 [get_cells {*FPGAwHandshaken349/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4321 [get_cells {*FPGAwHandshaken349/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4322 [get_cells {*FPGAwHandshaken349/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4323 [get_cells {*FPGAwHandshaken349/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4324 [get_cells {*FPGAwHandshaken349/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4326 [get_cells {*FPGAwHandshaken349/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4328 [get_cells {*FPGAwHandshaken349/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4330 [get_cells {*FPGAwHandshaken349/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4331 [get_cells {*FPGAwHandshaken351/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4332 [get_cells {*FPGAwHandshaken351/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4333 [get_cells {*FPGAwHandshaken351/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4334 [get_cells {*FPGAwHandshaken351/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4335 [get_cells {*FPGAwHandshaken351/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4336 [get_cells {*FPGAwHandshaken351/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4338 [get_cells {*FPGAwHandshaken351/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4340 [get_cells {*FPGAwHandshaken351/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4342 [get_cells {*FPGAwHandshaken351/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4343 [get_cells {*FPGAwHandshaken352/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4344 [get_cells {*FPGAwHandshaken352/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4345 [get_cells {*FPGAwHandshaken352/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4346 [get_cells {*FPGAwHandshaken352/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4347 [get_cells {*FPGAwHandshaken352/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4348 [get_cells {*FPGAwHandshaken352/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4350 [get_cells {*FPGAwHandshaken352/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4352 [get_cells {*FPGAwHandshaken352/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4354 [get_cells {*FPGAwHandshaken352/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4355 [get_cells {*FPGAwFIFOn5*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4356 [get_cells {*FPGAwFIFOn5*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4357 [get_cells {*FPGAwFIFOn5*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4358 [get_cells {*FPGAwFIFOn5*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4359 [get_cells {*FPGAwFIFOn5*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4361 [get_cells {*FPGAwFIFOn5*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4362 [get_cells {*FPGAwFIFOn5*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4363 [get_cells {*FPGAwFIFOn5*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4364 [get_cells {*FPGAwFIFOn5*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4365 [get_cells {*FPGAwFIFOn5*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4367 [get_cells {*FPGAwFIFOn5*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4368 [get_cells {*FPGAwFIFOn5*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4369 [get_cells {*FPGAwFIFOn5/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4370 [get_cells {*FPGAwFIFOn5/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4372 [get_cells {*FPGAwFIFOn5/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4373 [get_cells {*FPGAwFIFOn5/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4374 [get_cells {*FPGAwFIFOn5/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4376 [get_cells {*FPGAwFIFOn5/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4377 [get_cells {*FPGAwFIFOn4*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4378 [get_cells {*FPGAwFIFOn4*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4379 [get_cells {*FPGAwFIFOn4*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4380 [get_cells {*FPGAwFIFOn4*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4381 [get_cells {*FPGAwFIFOn4*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4383 [get_cells {*FPGAwFIFOn4*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4384 [get_cells {*FPGAwFIFOn4*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4385 [get_cells {*FPGAwFIFOn4*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4386 [get_cells {*FPGAwFIFOn4*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4387 [get_cells {*FPGAwFIFOn4*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4389 [get_cells {*FPGAwFIFOn4*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4390 [get_cells {*FPGAwFIFOn4*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4391 [get_cells {*FPGAwFIFOn4/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4392 [get_cells {*FPGAwFIFOn4/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4394 [get_cells {*FPGAwFIFOn4/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4395 [get_cells {*FPGAwFIFOn4/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4396 [get_cells {*FPGAwFIFOn4/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4398 [get_cells {*FPGAwFIFOn4/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4399 [get_cells {*FPGAwHandshaken381/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4400 [get_cells {*FPGAwHandshaken381/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4401 [get_cells {*FPGAwHandshaken381/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4402 [get_cells {*FPGAwHandshaken381/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4403 [get_cells {*FPGAwHandshaken381/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4404 [get_cells {*FPGAwHandshaken381/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4406 [get_cells {*FPGAwHandshaken381/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4408 [get_cells {*FPGAwHandshaken381/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4410 [get_cells {*FPGAwHandshaken381/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4411 [get_cells {*FPGAwHandshaken386/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4412 [get_cells {*FPGAwHandshaken386/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4413 [get_cells {*FPGAwHandshaken386/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4414 [get_cells {*FPGAwHandshaken386/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4415 [get_cells {*FPGAwHandshaken386/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4416 [get_cells {*FPGAwHandshaken386/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4418 [get_cells {*FPGAwHandshaken386/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4420 [get_cells {*FPGAwHandshaken386/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4422 [get_cells {*FPGAwHandshaken386/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4423 [get_cells {*FPGAwHandshaken387/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4424 [get_cells {*FPGAwHandshaken387/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4425 [get_cells {*FPGAwHandshaken387/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4426 [get_cells {*FPGAwHandshaken387/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4427 [get_cells {*FPGAwHandshaken387/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4428 [get_cells {*FPGAwHandshaken387/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4430 [get_cells {*FPGAwHandshaken387/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4432 [get_cells {*FPGAwHandshaken387/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4434 [get_cells {*FPGAwHandshaken387/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4435 [get_cells {*FPGAwHandshaken389/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4436 [get_cells {*FPGAwHandshaken389/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4437 [get_cells {*FPGAwHandshaken389/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4438 [get_cells {*FPGAwHandshaken389/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4439 [get_cells {*FPGAwHandshaken389/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4440 [get_cells {*FPGAwHandshaken389/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4442 [get_cells {*FPGAwHandshaken389/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4444 [get_cells {*FPGAwHandshaken389/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4446 [get_cells {*FPGAwHandshaken389/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4447 [get_cells {*FPGAwHandshaken390/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4448 [get_cells {*FPGAwHandshaken390/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4449 [get_cells {*FPGAwHandshaken390/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4450 [get_cells {*FPGAwHandshaken390/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4451 [get_cells {*FPGAwHandshaken390/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4452 [get_cells {*FPGAwHandshaken390/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4454 [get_cells {*FPGAwHandshaken390/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4456 [get_cells {*FPGAwHandshaken390/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4458 [get_cells {*FPGAwHandshaken390/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4459 [get_cells {*FPGAwFIFOn3*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4460 [get_cells {*FPGAwFIFOn3*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4461 [get_cells {*FPGAwFIFOn3*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4462 [get_cells {*FPGAwFIFOn3*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4463 [get_cells {*FPGAwFIFOn3*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4465 [get_cells {*FPGAwFIFOn3*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4466 [get_cells {*FPGAwFIFOn3*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4467 [get_cells {*FPGAwFIFOn3*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4468 [get_cells {*FPGAwFIFOn3*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4469 [get_cells {*FPGAwFIFOn3*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4471 [get_cells {*FPGAwFIFOn3*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4472 [get_cells {*FPGAwFIFOn3*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4473 [get_cells {*FPGAwFIFOn3/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4474 [get_cells {*FPGAwFIFOn3/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4476 [get_cells {*FPGAwFIFOn3/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4477 [get_cells {*FPGAwFIFOn3/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4478 [get_cells {*FPGAwFIFOn3/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4480 [get_cells {*FPGAwFIFOn3/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4481 [get_cells {*FPGAwFIFOn2*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4482 [get_cells {*FPGAwFIFOn2*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4483 [get_cells {*FPGAwFIFOn2*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4484 [get_cells {*FPGAwFIFOn2*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4485 [get_cells {*FPGAwFIFOn2*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4487 [get_cells {*FPGAwFIFOn2*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4488 [get_cells {*FPGAwFIFOn2*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4489 [get_cells {*FPGAwFIFOn2*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4490 [get_cells {*FPGAwFIFOn2*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4491 [get_cells {*FPGAwFIFOn2*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4493 [get_cells {*FPGAwFIFOn2*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4494 [get_cells {*FPGAwFIFOn2*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4495 [get_cells {*FPGAwFIFOn2/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4496 [get_cells {*FPGAwFIFOn2/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4498 [get_cells {*FPGAwFIFOn2/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4499 [get_cells {*FPGAwFIFOn2/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4500 [get_cells {*FPGAwFIFOn2/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4502 [get_cells {*FPGAwFIFOn2/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4503 [get_cells {*FPGAwHandshaken419/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4504 [get_cells {*FPGAwHandshaken419/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4505 [get_cells {*FPGAwHandshaken419/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4506 [get_cells {*FPGAwHandshaken419/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4507 [get_cells {*FPGAwHandshaken419/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4508 [get_cells {*FPGAwHandshaken419/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4510 [get_cells {*FPGAwHandshaken419/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4512 [get_cells {*FPGAwHandshaken419/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4514 [get_cells {*FPGAwHandshaken419/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4515 [get_cells {*FPGAwHandshaken424/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4516 [get_cells {*FPGAwHandshaken424/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4517 [get_cells {*FPGAwHandshaken424/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4518 [get_cells {*FPGAwHandshaken424/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4519 [get_cells {*FPGAwHandshaken424/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4520 [get_cells {*FPGAwHandshaken424/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4522 [get_cells {*FPGAwHandshaken424/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4524 [get_cells {*FPGAwHandshaken424/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4526 [get_cells {*FPGAwHandshaken424/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4527 [get_cells {*FPGAwHandshaken425/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4528 [get_cells {*FPGAwHandshaken425/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4529 [get_cells {*FPGAwHandshaken425/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4530 [get_cells {*FPGAwHandshaken425/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4531 [get_cells {*FPGAwHandshaken425/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4532 [get_cells {*FPGAwHandshaken425/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4534 [get_cells {*FPGAwHandshaken425/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4536 [get_cells {*FPGAwHandshaken425/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4538 [get_cells {*FPGAwHandshaken425/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4539 [get_cells {*FPGAwHandshaken427/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4540 [get_cells {*FPGAwHandshaken427/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4541 [get_cells {*FPGAwHandshaken427/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4542 [get_cells {*FPGAwHandshaken427/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4543 [get_cells {*FPGAwHandshaken427/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4544 [get_cells {*FPGAwHandshaken427/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4546 [get_cells {*FPGAwHandshaken427/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4548 [get_cells {*FPGAwHandshaken427/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4550 [get_cells {*FPGAwHandshaken427/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4551 [get_cells {*FPGAwHandshaken428/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4552 [get_cells {*FPGAwHandshaken428/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4553 [get_cells {*FPGAwHandshaken428/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4554 [get_cells {*FPGAwHandshaken428/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4555 [get_cells {*FPGAwHandshaken428/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4556 [get_cells {*FPGAwHandshaken428/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4558 [get_cells {*FPGAwHandshaken428/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4560 [get_cells {*FPGAwHandshaken428/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4562 [get_cells {*FPGAwHandshaken428/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4563 [get_cells {*FPGAwFIFOn0*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4564 [get_cells {*FPGAwFIFOn0*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4565 [get_cells {*FPGAwFIFOn0*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4566 [get_cells {*FPGAwFIFOn0*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4567 [get_cells {*FPGAwFIFOn0*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4569 [get_cells {*FPGAwFIFOn0*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4570 [get_cells {*FPGAwFIFOn0*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4571 [get_cells {*FPGAwFIFOn0*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4572 [get_cells {*FPGAwFIFOn0*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4573 [get_cells {*FPGAwFIFOn0*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4575 [get_cells {*FPGAwFIFOn0*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4576 [get_cells {*FPGAwFIFOn0*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4577 [get_cells {*FPGAwFIFOn0/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4578 [get_cells {*FPGAwFIFOn0/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4580 [get_cells {*FPGAwFIFOn0/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4581 [get_cells {*FPGAwFIFOn0/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4582 [get_cells {*FPGAwFIFOn0/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4584 [get_cells {*FPGAwFIFOn0/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4585 [get_cells {*FPGAwFIFOn1*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4586 [get_cells {*FPGAwFIFOn1*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4587 [get_cells {*FPGAwFIFOn1*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4588 [get_cells {*FPGAwFIFOn1*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4589 [get_cells {*FPGAwFIFOn1*ClearControl/NiFpgaFifoPortResetx/Crossing.PushToPop*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4591 [get_cells {*FPGAwFIFOn1*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4592 [get_cells {*FPGAwFIFOn1*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4593 [get_cells {*FPGAwFIFOn1*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4594 [get_cells {*FPGAwFIFOn1*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4595 [get_cells {*FPGAwFIFOn1*ClearControl/NiFpgaFifoPortResetx/Crossing.PopToPush*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4597 [get_cells {*FPGAwFIFOn1*ClearControl*DoubleSyncBasex*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4598 [get_cells {*FPGAwFIFOn1*ClearControl*DoubleSyncBasex*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4599 [get_cells {*FPGAwFIFOn1/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4600 [get_cells {*FPGAwFIFOn1/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4602 [get_cells {*FPGAwFIFOn1/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4603 [get_cells {*FPGAwFIFOn1/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToOClkx/cAddrAGrayx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4604 [get_cells {*FPGAwFIFOn1/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGray_msx/GenFlops[*].DFlopx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4606 [get_cells {*FPGAwFIFOn1/TypeSelector/GenerateBlockRamFifo.GenerateDualClockFifo.BlockRamFifo/NiFpgaFifox/NiFpgaFifoFlagsx*SyncToIClkx/cAddrBGrayx/GenFlops[*].DFlopx/*FDCPEx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4607 [get_cells {*FPGAwHandshaken463/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4608 [get_cells {*FPGAwHandshaken463/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4609 [get_cells {*FPGAwHandshaken463/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4610 [get_cells {*FPGAwHandshaken463/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4611 [get_cells {*FPGAwHandshaken463/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4612 [get_cells {*FPGAwHandshaken463/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4614 [get_cells {*FPGAwHandshaken463/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4616 [get_cells {*FPGAwHandshaken463/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4618 [get_cells {*FPGAwHandshaken463/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4619 [get_cells {*FPGAwHandshaken467/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4620 [get_cells {*FPGAwHandshaken467/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4621 [get_cells {*FPGAwHandshaken467/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4622 [get_cells {*FPGAwHandshaken467/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4623 [get_cells {*FPGAwHandshaken467/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4624 [get_cells {*FPGAwHandshaken467/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4626 [get_cells {*FPGAwHandshaken467/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4628 [get_cells {*FPGAwHandshaken467/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4630 [get_cells {*FPGAwHandshaken467/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4631 [get_cells {*FPGAwHandshaken468/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4632 [get_cells {*FPGAwHandshaken468/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4633 [get_cells {*FPGAwHandshaken468/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4634 [get_cells {*FPGAwHandshaken468/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4635 [get_cells {*FPGAwHandshaken468/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4636 [get_cells {*FPGAwHandshaken468/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4638 [get_cells {*FPGAwHandshaken468/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4640 [get_cells {*FPGAwHandshaken468/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4642 [get_cells {*FPGAwHandshaken468/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4643 [get_cells {*FPGAwHandshaken470/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4644 [get_cells {*FPGAwHandshaken470/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4645 [get_cells {*FPGAwHandshaken470/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4646 [get_cells {*FPGAwHandshaken470/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4647 [get_cells {*FPGAwHandshaken470/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4648 [get_cells {*FPGAwHandshaken470/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4650 [get_cells {*FPGAwHandshaken470/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4652 [get_cells {*FPGAwHandshaken470/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4654 [get_cells {*FPGAwHandshaken470/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4655 [get_cells {*FPGAwHandshaken471/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4656 [get_cells {*FPGAwHandshaken471/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4657 [get_cells {*FPGAwHandshaken471/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4658 [get_cells {*FPGAwHandshaken471/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4659 [get_cells {*FPGAwHandshaken471/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4660 [get_cells {*FPGAwHandshaken471/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4662 [get_cells {*FPGAwHandshaken471/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4664 [get_cells {*FPGAwHandshaken471/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4666 [get_cells {*FPGAwHandshaken471/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4667 [get_cells {*DmaPortCommIfcIrqInterfacex/DoubleSyncSLx*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4668 [get_cells {*DmaPortCommIfcIrqInterfacex/DoubleSyncSLx*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4669 [get_cells {*DmaPortCommIfcLvFpgaIrq*bIpIrq_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4670 [get_cells {*DmaPortCommIfcLvFpgaIrq*bIpIrq*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4671 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/BlkOut.SyncIReset/c1ResetFastLclx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4672 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/BlkIn.iPushTogglex*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4673 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/BlkIn.i*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4674 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/BlkOut.o*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4676 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/BlkOut.SyncIReset/c2ResetFe_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4677 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/Blk*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4678 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/Blk*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4679 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/BlkIn.iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4680 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/BlkOut.oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4681 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4682 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4683 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4684 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4685 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/BlkOut.SyncIReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4686 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/BlkOut.SyncIReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4687 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/BlkOut.SyncIReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4688 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/BlkOut.SyncIReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4689 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/BlkOut.SyncOReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4690 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/BlkOut.SyncOReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4691 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/BlkOut.SyncOReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4692 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToBusClkDomain/BlkOut.SyncOReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4693 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/BlkOut.SyncIReset/c1ResetFastLclx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4694 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/BlkIn.iPushTogglex*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4695 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/BlkIn.i*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4696 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/BlkOut.o*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4698 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/BlkOut.SyncIReset/c2ResetFe_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4699 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/Blk*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4700 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/Blk*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4701 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/BlkIn.iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4702 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/BlkOut.oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4703 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4704 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4705 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4706 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4707 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/BlkOut.SyncIReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4708 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/BlkOut.SyncIReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4709 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/BlkOut.SyncIReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4710 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/BlkOut.SyncIReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4711 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/BlkOut.SyncOReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4712 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/BlkOut.SyncOReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4713 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/BlkOut.SyncOReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4714 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflowStopRequest/BlkOut.SyncOReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4715 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/BlkOut.SyncIReset/c1ResetFastLclx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4716 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/BlkIn.iPushTogglex*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4717 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/BlkIn.i*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4718 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/BlkOut.o*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4720 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/BlkOut.SyncIReset/c2ResetFe_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4721 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/Blk*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4722 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/Blk*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4723 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/BlkIn.iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4724 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/BlkOut.oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4725 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4726 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4727 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4728 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4729 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/BlkOut.SyncIReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4730 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/BlkOut.SyncIReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4731 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/BlkOut.SyncIReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4732 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/BlkOut.SyncIReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4733 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/BlkOut.SyncOReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4734 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/BlkOut.SyncOReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4735 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/BlkOut.SyncOReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4736 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeUnderflow/BlkOut.SyncOReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4737 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/BlkOut.SyncIReset/c1ResetFastLclx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4738 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/BlkIn.iPushTogglex*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4739 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/BlkIn.i*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4740 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/BlkOut.o*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4742 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/BlkOut.SyncIReset/c2ResetFe_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4743 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/Blk*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4744 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/Blk*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4745 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/BlkIn.iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4746 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/BlkOut.oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4747 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4748 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4749 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4750 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4751 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/BlkOut.SyncIReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4752 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/BlkOut.SyncIReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4753 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/BlkOut.SyncIReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4754 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/BlkOut.SyncIReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4755 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/BlkOut.SyncOReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4756 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/BlkOut.SyncOReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4757 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/BlkOut.SyncOReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4758 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeFullCount/BlkOut.SyncOReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4759 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncIReset/c1ResetFastLclx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4760 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/BlkIn.iPushTogglex*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4761 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/BlkIn.i*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4762 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.o*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4764 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncIReset/c2ResetFe_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4765 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/Blk*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4766 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/Blk*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4767 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/BlkIn.iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4768 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4769 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4770 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4771 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4772 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4773 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncIReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4774 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncIReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4775 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncIReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4776 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncIReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4777 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncOReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4778 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncOReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4779 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncOReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4780 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncOReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4781 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/BlkOut.SyncIReset/c1ResetFastLclx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4782 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/BlkIn.iPushTogglex*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4783 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/BlkIn.i*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4784 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/BlkOut.o*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4786 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/BlkOut.SyncIReset/c2ResetFe_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4787 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/Blk*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4788 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/Blk*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4789 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/BlkIn.iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4790 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/BlkOut.oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4791 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4792 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4793 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4794 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4795 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/BlkOut.SyncIReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4796 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/BlkOut.SyncIReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4797 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/BlkOut.SyncIReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4798 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/BlkOut.SyncIReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4799 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/BlkOut.SyncOReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4800 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/BlkOut.SyncOReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4801 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/BlkOut.SyncOReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4802 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StartEnableChain*HandshakeTransitionRequest/BlkOut.SyncOReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4803 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncIReset/c1ResetFastLclx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4804 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/BlkIn.iPushTogglex*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4805 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/BlkIn.i*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4806 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.o*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4808 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncIReset/c2ResetFe_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4809 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/Blk*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4810 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/Blk*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4811 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/BlkIn.iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4812 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4813 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4814 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4815 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4816 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4817 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncIReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4818 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncIReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4819 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncIReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4820 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncIReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4821 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncOReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4822 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncOReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4823 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncOReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4824 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionTimeoutRequest/BlkOut.SyncOReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4825 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/BlkOut.SyncIReset/c1ResetFastLclx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4826 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/BlkIn.iPushTogglex*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4827 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/BlkIn.i*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4828 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/BlkOut.o*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4830 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/BlkOut.SyncIReset/c2ResetFe_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4831 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/Blk*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4832 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/Blk*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4833 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/BlkIn.iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4834 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/BlkOut.oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4835 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4836 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4837 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4838 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4839 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/BlkOut.SyncIReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4840 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/BlkOut.SyncIReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4841 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/BlkOut.SyncIReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4842 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/BlkOut.SyncIReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4843 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/BlkOut.SyncOReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4844 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/BlkOut.SyncOReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4845 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/BlkOut.SyncOReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4846 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*StopEnableChain*HandshakeTransitionRequest/BlkOut.SyncOReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4847 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToDefaultClkDomain/*iLclStoredData*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4848 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToDefaultClkDomain/*ODataFlop**FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4849 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToDefaultClkDomain/*iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4850 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToDefaultClkDomain/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4851 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToDefaultClkDomain/*oPushToggleToReady*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4852 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToDefaultClkDomain/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4854 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToDefaultClkDomain/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4856 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToDefaultClkDomain/*iReset*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4858 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0]*HandshakeStateToDefaultClkDomain/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4859 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortOutStrmFifox/DmaPortOutStrmFifoFlagsx/IClkToOClkCrossing.SyncToOClk/oAck*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4860 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortOutStrmFifox/DmaPortOutStrmFifoFlagsx/IClkToOClkCrossing.SyncToOClk/iAckRcvd_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4862 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortOutStrmFifox/DmaPortOutStrmFifoFlagsx/IClkToOClkCrossing.SyncToOClk/iAckRcvd*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4863 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortOutStrmFifox/DmaPortOutStrmFifoFlagsx/IClkToOClkCrossing.SyncToOClk/iTogglePush*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4864 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortOutStrmFifox/DmaPortOutStrmFifoFlagsx/IClkToOClkCrossing.SyncToOClk/oPushRcvd_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4866 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortOutStrmFifox/DmaPortOutStrmFifoFlagsx/IClkToOClkCrossing.SyncToOClk/oPushRcvd*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4867 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortOutStrmFifox/DmaPortOutStrmFifoFlagsx/IClkToOClkCrossing.SyncToOClk/iDataToPush*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4868 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortOutStrmFifox/DmaPortOutStrmFifoFlagsx/IClkToOClkCrossing.SyncToOClk/DataReg/GenFlops[*].DFlopx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4869 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortOutStrmFifox/DmaPortOutStrmFifoFlagsx/oReadSamplePtrUnsGray*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4870 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortOutStrmFifox/DmaPortOutStrmFifoFlagsx/iReadSamplePtrUnsGray*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4871 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortOutStrmFifox/DmaPortOutStrmFifoFlagsx/i*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4872 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[0].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortOutStrmFifox/DmaPortOutStrmFifoFlagsx/i*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4873 [get_cells {*SyncStopRequestStrobeToViClk*PulseSyncBasex/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4874 [get_cells {*SyncStopRequestStrobeToViClk*PulseSyncBasex/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4875 [get_cells {*SyncStopRequestStrobeToViClk*PulseSyncBasex/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4876 [get_cells {*SyncStopRequestStrobeToViClk*PulseSyncBasex/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4877 [get_cells {*SyncStopRequestStrobeToViClk*PulseSyncBasex/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4879 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/PopSynchNeeded.FromPopDblSync*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4880 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/PopSynchNeeded.FromPopDblSync*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4881 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/PopSynchNeeded.ToPopDblSync*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4882 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/PopSynchNeeded.ToPopDblSync*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4883 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.PushToPop/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4884 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.PushToPop/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4885 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.PushToPop/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4886 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.PushToPop/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4887 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.PushToPop/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4889 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.PopToPush/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4890 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.PopToPush/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4891 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.PopToPush/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4892 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.PopToPush/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4893 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.PopToPush/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4895 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.ClearToPop*oRegisteredSigAck*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4896 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.ClearToPop*PulseSyncBasex*iSigOut_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4897 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.ClearToPop/*iHoldSigInx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4898 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.ClearToPop/*oHoldSigIn_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4899 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.ClearToPop/*oLocalSigOutx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4900 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.ClearToPop/*iSigOut_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4901 [get_cells {*DmaPortCommIfcFifosx/DmaBlk.DmaComponents[*].DmaOutput.DmaPortCommIfcOutputFifoInterfacex/DmaPortCommIfcComponentEnableChainx/Output.FifoClearController/NiFpgaFifoPortResetx/Crossing.ClearToPop/*oLocalSigOutCEx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4903 [get_cells {*ViControlx*BusClkToReliableClkHS/BlkOut.SyncIReset/c1ResetFastLclx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4904 [get_cells {*ViControlx*BusClkToReliableClkHS/BlkIn.iPushTogglex*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4905 [get_cells {*ViControlx*BusClkToReliableClkHS/BlkIn.i*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4906 [get_cells {*ViControlx*BusClkToReliableClkHS/BlkOut.o*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4908 [get_cells {*ViControlx*BusClkToReliableClkHS/BlkOut.SyncIReset/c2ResetFe_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4909 [get_cells {*ViControlx*BusClkToReliableClkHS/Blk*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4910 [get_cells {*ViControlx*BusClkToReliableClkHS/Blk*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4911 [get_cells {*ViControlx*BusClkToReliableClkHS/BlkIn.iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4912 [get_cells {*ViControlx*BusClkToReliableClkHS/BlkOut.oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4913 [get_cells {*ViControlx*BusClkToReliableClkHS/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4914 [get_cells {*ViControlx*BusClkToReliableClkHS/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4915 [get_cells {*ViControlx*BusClkToReliableClkHS/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4916 [get_cells {*ViControlx*BusClkToReliableClkHS/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4917 [get_cells {*ViControlx*BusClkToReliableClkHS/BlkOut.SyncIReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4918 [get_cells {*ViControlx*BusClkToReliableClkHS/BlkOut.SyncIReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4919 [get_cells {*ViControlx*BusClkToReliableClkHS/BlkOut.SyncOReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4920 [get_cells {*ViControlx*BusClkToReliableClkHS/BlkOut.SyncOReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4921 [get_cells {*ViControlx*BusClkToReliableClkHS/BlkOut.SyncIReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4922 [get_cells {*ViControlx*BusClkToReliableClkHS/BlkOut.SyncIReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4923 [get_cells {*ViControlx*BusClkToReliableClkHS/BlkOut.SyncOReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4924 [get_cells {*ViControlx*BusClkToReliableClkHS/BlkOut.SyncOReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4925 [get_cells {*ViControlx*rEnableIn*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4926 [get_cells {*ViControlx*tEnableIn_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4927 [get_cells {*ViControlx*rEnableClear*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4928 [get_cells {*ViControlx*tEnableClear_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4930 [get_cells {*ViControlx*bEnableIn_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4932 [get_cells {*ViControlx*bEnableClear_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4933 [get_cells {*ViControlx*rDerivedClkLostLock*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4934 [get_cells {*ViControlx*bDerivedClkLostLock_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4935 [get_cells {*ViControlx*rGatedClkStartupErr*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4936 [get_cells {*ViControlx*bGatedClkStartupErr_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4937 [get_cells {*ViControlx*rEnableDeassertionErr*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4938 [get_cells {*ViControlx*bEnableDeassertionErr_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4939 [get_cells {*DiagramResetx*rDiagramResetAssertionErr*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4940 [get_cells {*ViControlx*bDiagramResetAssertionErr_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4941 [get_cells {*ViControlx*tDiagramEnableOutReg*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4942 [get_cells {*ViControlx*bEnableOut_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4943 [get_cells {*DiagramResetx*BusClkToReliableClkHS/BlkOut.SyncIReset/c1ResetFastLclx*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4944 [get_cells {*DiagramResetx*BusClkToReliableClkHS/BlkIn.iPushTogglex*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4945 [get_cells {*DiagramResetx*BusClkToReliableClkHS/BlkIn.i*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4946 [get_cells {*DiagramResetx*BusClkToReliableClkHS/BlkOut.o*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4948 [get_cells {*DiagramResetx*BusClkToReliableClkHS/BlkOut.SyncIReset/c2ResetFe_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4949 [get_cells {*DiagramResetx*BusClkToReliableClkHS/Blk*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4950 [get_cells {*DiagramResetx*BusClkToReliableClkHS/Blk*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4951 [get_cells {*DiagramResetx*BusClkToReliableClkHS/BlkIn.iPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4952 [get_cells {*DiagramResetx*BusClkToReliableClkHS/BlkOut.oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4953 [get_cells {*DiagramResetx*BusClkToReliableClkHS/*oPushToggle0_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4954 [get_cells {*DiagramResetx*BusClkToReliableClkHS/*oPushToggle1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4955 [get_cells {*DiagramResetx*BusClkToReliableClkHS/*iRdyPushToggle_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4956 [get_cells {*DiagramResetx*BusClkToReliableClkHS/*iRdyPushToggle*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4957 [get_cells {*DiagramResetx*BusClkToReliableClkHS/BlkOut.SyncIReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4958 [get_cells {*DiagramResetx*BusClkToReliableClkHS/BlkOut.SyncIReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4959 [get_cells {*DiagramResetx*BusClkToReliableClkHS/BlkOut.SyncOReset*c1*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4960 [get_cells {*DiagramResetx*BusClkToReliableClkHS/BlkOut.SyncOReset*c1*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4961 [get_cells {*DiagramResetx*BusClkToReliableClkHS/BlkOut.SyncIReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4962 [get_cells {*DiagramResetx*BusClkToReliableClkHS/BlkOut.SyncIReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4963 [get_cells {*DiagramResetx*BusClkToReliableClkHS/BlkOut.SyncOReset*c2*_ms*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4964 [get_cells {*DiagramResetx*BusClkToReliableClkHS/BlkOut.SyncOReset*c2*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4965 [get_cells {*DiagramResetx*rSafeToEnableGatedClksLoc*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4966 [get_cells {*DiagramResetx*rDiagramResetForHost*} -filter {IS_SEQUENTIAL==true}]
set TNM_Custom4967 [get_cells {*DiagramResetx*bDiagramResetForHost_ms*} -filter {IS_SEQUENTIAL==true}]


set_max_delay -from $TNM_Custom1 -to $TNM_Custom2 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3 -to $TNM_Custom4 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom5 -to $TNM_Custom6 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4 -to $TNM_Custom8 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom10 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom6 -to $TNM_Custom12 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom13 -to $TNM_Custom14 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom15 -to $TNM_Custom16 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom17 -to $TNM_Custom16 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom19 -to $TNM_Custom20 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom21 -to $TNM_Custom22 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom23 -to $TNM_Custom24 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom22 -to $TNM_Custom26 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom28 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom24 -to $TNM_Custom30 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom61 -to $TNM_Custom62 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom63 -to $TNM_Custom64 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom65 -to $TNM_Custom66 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom64 -to $TNM_Custom68 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom70 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom66 -to $TNM_Custom72 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom73 -to $TNM_Custom74 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom75 -to $TNM_Custom76 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom77 -to $TNM_Custom76 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom79 -to $TNM_Custom80 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom81 -to $TNM_Custom82 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom83 -to $TNM_Custom84 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom82 -to $TNM_Custom86 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom88 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom84 -to $TNM_Custom90 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom121 -to $TNM_Custom122 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom123 -to $TNM_Custom124 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom125 -to $TNM_Custom126 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom124 -to $TNM_Custom128 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom130 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom126 -to $TNM_Custom132 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom133 -to $TNM_Custom134 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom135 -to $TNM_Custom136 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom137 -to $TNM_Custom136 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom139 -to $TNM_Custom140 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom141 -to $TNM_Custom142 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom143 -to $TNM_Custom144 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom142 -to $TNM_Custom146 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom148 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom144 -to $TNM_Custom150 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom181 -to $TNM_Custom182 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom183 -to $TNM_Custom184 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom185 -to $TNM_Custom186 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom184 -to $TNM_Custom188 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom190 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom186 -to $TNM_Custom192 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom193 -to $TNM_Custom194 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom195 -to $TNM_Custom196 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom197 -to $TNM_Custom196 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom199 -to $TNM_Custom200 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom201 -to $TNM_Custom202 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom203 -to $TNM_Custom204 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom202 -to $TNM_Custom206 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom208 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom204 -to $TNM_Custom210 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom241 -to $TNM_Custom242 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom243 -to $TNM_Custom244 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom245 -to $TNM_Custom246 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom244 -to $TNM_Custom248 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom250 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom246 -to $TNM_Custom252 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom253 -to $TNM_Custom254 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom255 -to $TNM_Custom256 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom257 -to $TNM_Custom256 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom259 -to $TNM_Custom260 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom261 -to $TNM_Custom262 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom263 -to $TNM_Custom264 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom262 -to $TNM_Custom266 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom268 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom264 -to $TNM_Custom270 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom301 -to $TNM_Custom302 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom303 -to $TNM_Custom304 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom305 -to $TNM_Custom306 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom304 -to $TNM_Custom308 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom310 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom306 -to $TNM_Custom312 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom313 -to $TNM_Custom314 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom315 -to $TNM_Custom316 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom317 -to $TNM_Custom316 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom319 -to $TNM_Custom320 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom321 -to $TNM_Custom322 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom323 -to $TNM_Custom324 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom322 -to $TNM_Custom326 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom328 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom324 -to $TNM_Custom330 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom361 -to $TNM_Custom362 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom363 -to $TNM_Custom364 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom365 -to $TNM_Custom366 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom364 -to $TNM_Custom368 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom370 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom366 -to $TNM_Custom372 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom373 -to $TNM_Custom374 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom375 -to $TNM_Custom376 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom377 -to $TNM_Custom376 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom379 -to $TNM_Custom380 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom381 -to $TNM_Custom382 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom383 -to $TNM_Custom384 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom382 -to $TNM_Custom386 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom388 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom384 -to $TNM_Custom390 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom421 -to $TNM_Custom422 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom423 -to $TNM_Custom424 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom425 -to $TNM_Custom426 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom424 -to $TNM_Custom428 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom430 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom426 -to $TNM_Custom432 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom433 -to $TNM_Custom434 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom435 -to $TNM_Custom436 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom437 -to $TNM_Custom436 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom439 -to $TNM_Custom440 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom441 -to $TNM_Custom442 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom443 -to $TNM_Custom444 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom442 -to $TNM_Custom446 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom448 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom444 -to $TNM_Custom450 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom481 -to $TNM_Custom482 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom483 -to $TNM_Custom484 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom485 -to $TNM_Custom486 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom484 -to $TNM_Custom488 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom490 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom486 -to $TNM_Custom492 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom493 -to $TNM_Custom494 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom495 -to $TNM_Custom496 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom497 -to $TNM_Custom496 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom499 -to $TNM_Custom500 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom501 -to $TNM_Custom502 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom503 -to $TNM_Custom504 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom502 -to $TNM_Custom506 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom508 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom504 -to $TNM_Custom510 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom541 -to $TNM_Custom542 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom543 -to $TNM_Custom544 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom545 -to $TNM_Custom546 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom544 -to $TNM_Custom548 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom550 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom546 -to $TNM_Custom552 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom553 -to $TNM_Custom554 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom555 -to $TNM_Custom556 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom557 -to $TNM_Custom556 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom559 -to $TNM_Custom560 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom561 -to $TNM_Custom562 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom563 -to $TNM_Custom564 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom562 -to $TNM_Custom566 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom568 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom564 -to $TNM_Custom570 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom601 -to $TNM_Custom602 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom603 -to $TNM_Custom604 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom605 -to $TNM_Custom606 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom604 -to $TNM_Custom608 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom610 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom606 -to $TNM_Custom612 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom613 -to $TNM_Custom614 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom615 -to $TNM_Custom616 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom617 -to $TNM_Custom616 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom619 -to $TNM_Custom620 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom621 -to $TNM_Custom622 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom623 -to $TNM_Custom624 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom622 -to $TNM_Custom626 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom628 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom624 -to $TNM_Custom630 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom661 -to $TNM_Custom662 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom663 -to $TNM_Custom664 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom665 -to $TNM_Custom666 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom664 -to $TNM_Custom668 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom670 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom666 -to $TNM_Custom672 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom673 -to $TNM_Custom674 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom675 -to $TNM_Custom676 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom677 -to $TNM_Custom676 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom679 -to $TNM_Custom680 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom681 -to $TNM_Custom682 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom683 -to $TNM_Custom684 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom682 -to $TNM_Custom686 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom688 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom684 -to $TNM_Custom690 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom721 -to $TNM_Custom722  9.7990001000
set_max_delay -from $TNM_Custom731 -to $TNM_Custom732 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom733 -to $TNM_Custom734 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom735 -to $TNM_Custom736 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom737 -to $TNM_Custom738 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom739 -to $TNM_Custom740 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom741 -to $TNM_Custom742 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom743 -to $TNM_Custom744  24.4975002500
set_max_delay -from $TNM_Custom753 -to $TNM_Custom754 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom755 -to $TNM_Custom756 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom757 -to $TNM_Custom758 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom759 -to $TNM_Custom760 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom761 -to $TNM_Custom762 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom763 -to $TNM_Custom764 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom765 -to $TNM_Custom766  24.4975002500
set_max_delay -from $TNM_Custom775 -to $TNM_Custom776 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom777 -to $TNM_Custom778 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom779 -to $TNM_Custom780 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom781 -to $TNM_Custom782 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom783 -to $TNM_Custom784 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom785 -to $TNM_Custom786 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom787 -to $TNM_Custom788  24.4975002500
set_max_delay -from $TNM_Custom797 -to $TNM_Custom798 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom799 -to $TNM_Custom800 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom801 -to $TNM_Custom802 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom803 -to $TNM_Custom804 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom805 -to $TNM_Custom806 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom807 -to $TNM_Custom808 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom809 -to $TNM_Custom810 -datapath_only 29.2470003000
set_max_delay -from $TNM_Custom811 -to $TNM_Custom812 -datapath_only 29.2470003000
set_max_delay -from $TNM_Custom813 -to $TNM_Custom812 -datapath_only 29.2470003000
set_max_delay -from $TNM_Custom815 -to $TNM_Custom816 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom817 -to $TNM_Custom818 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom819 -to $TNM_Custom820 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom821 -to $TNM_Custom822 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom823 -to $TNM_Custom824 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom825 -to $TNM_Custom826 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom827 -to $TNM_Custom828 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom829 -to $TNM_Custom830 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom831 -to $TNM_Custom832 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom833 -to $TNM_Custom834 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom835 -to $TNM_Custom836 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom837 -to $TNM_Custom838 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom839 -to $TNM_Custom840 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom839 -to $TNM_Custom840 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom843 -to $TNM_Custom844 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom845 -to $TNM_Custom846 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom847 -to $TNM_Custom848 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom846 -to $TNM_Custom850 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom852 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom848 -to $TNM_Custom854 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom817 -to $TNM_Custom818 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom897 -to $TNM_Custom898 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom837 -to $TNM_Custom838 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom901 -to $TNM_Custom902 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom903 -to $TNM_Custom904 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom905 -to $TNM_Custom906 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom904 -to $TNM_Custom908 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom910 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom906 -to $TNM_Custom912 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom835 -to $TNM_Custom836 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom957 -to $TNM_Custom958 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom959 -to $TNM_Custom960 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom961 -to $TNM_Custom962 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom960 -to $TNM_Custom964 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom966 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom962 -to $TNM_Custom968 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom833 -to $TNM_Custom834 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom1013 -to $TNM_Custom1014 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom1015 -to $TNM_Custom1016 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom1017 -to $TNM_Custom1018 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom1016 -to $TNM_Custom1020 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom1022 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom1018 -to $TNM_Custom1024 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom831 -to $TNM_Custom832 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom1069 -to $TNM_Custom1070 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom1071 -to $TNM_Custom1072 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom1073 -to $TNM_Custom1074 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom1072 -to $TNM_Custom1076 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom1078 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom1074 -to $TNM_Custom1080 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom829 -to $TNM_Custom830 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom1125 -to $TNM_Custom1126 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom1127 -to $TNM_Custom1128 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom1129 -to $TNM_Custom1130 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom1128 -to $TNM_Custom1132 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom1134 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom1130 -to $TNM_Custom1136 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom827 -to $TNM_Custom828 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom1181 -to $TNM_Custom1182 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom1183 -to $TNM_Custom1184 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom1185 -to $TNM_Custom1186 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom1184 -to $TNM_Custom1188 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom1190 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom1186 -to $TNM_Custom1192 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom825 -to $TNM_Custom826 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom1231 -to $TNM_Custom1232 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom1233 -to $TNM_Custom1234 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom1235 -to $TNM_Custom1236 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom1234 -to $TNM_Custom1238 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom1240 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom1236 -to $TNM_Custom1242 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom823 -to $TNM_Custom824 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom1287 -to $TNM_Custom1288 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom1289 -to $TNM_Custom1290 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom1291 -to $TNM_Custom1292 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom1290 -to $TNM_Custom1294 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom1296 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom1292 -to $TNM_Custom1298 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom821 -to $TNM_Custom822 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom1343 -to $TNM_Custom1344 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom1345 -to $TNM_Custom1346 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom1347 -to $TNM_Custom1348 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom1346 -to $TNM_Custom1350 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom1352 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom1348 -to $TNM_Custom1354 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom819 -to $TNM_Custom820 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom1399 -to $TNM_Custom1400 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom1401 -to $TNM_Custom1402 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom1403 -to $TNM_Custom1404 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom1402 -to $TNM_Custom1406 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom1408 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom1404 -to $TNM_Custom1410 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom815 -to $TNM_Custom816 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom1463 -to $TNM_Custom1464 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom1465 -to $TNM_Custom1466 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom1467 -to $TNM_Custom1468 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom1466 -to $TNM_Custom1470 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom1472 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom1468 -to $TNM_Custom1474 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom1509 -to $TNM_Custom1510 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom1511 -to $TNM_Custom1512 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom1513 -to $TNM_Custom1514 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom1512 -to $TNM_Custom1516 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom1518 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom1514 -to $TNM_Custom1520 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom1605 -to $TNM_Custom1606 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom1625 -to $TNM_Custom1626 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom1627 -to $TNM_Custom1628 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom1629 -to $TNM_Custom1630 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom1628 -to $TNM_Custom1632 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom1634 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom1630 -to $TNM_Custom1636 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom1641 -to $TNM_Custom1642 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom1643 -to $TNM_Custom1644 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom1645 -to $TNM_Custom1646 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom1644 -to $TNM_Custom1648 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom1650 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom1646 -to $TNM_Custom1652 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom1737 -to $TNM_Custom1738 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom1773 -to $TNM_Custom1774 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom1775 -to $TNM_Custom1776 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom1777 -to $TNM_Custom1778 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom1776 -to $TNM_Custom1780 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom1782 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom1778 -to $TNM_Custom1784 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom1869 -to $TNM_Custom1870 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom1889 -to $TNM_Custom1890 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom1891 -to $TNM_Custom1892 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom1893 -to $TNM_Custom1894 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom1892 -to $TNM_Custom1896 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom1898 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom1894 -to $TNM_Custom1900 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom1985 -to $TNM_Custom1986 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom2021 -to $TNM_Custom2022 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom2023 -to $TNM_Custom2024 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom2025 -to $TNM_Custom2026 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom2024 -to $TNM_Custom2028 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom2030 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom2026 -to $TNM_Custom2032 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom2117 -to $TNM_Custom2118 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom2153 -to $TNM_Custom2154 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom2155 -to $TNM_Custom2156 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom2157 -to $TNM_Custom2158 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom2156 -to $TNM_Custom2160 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom2162 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom2158 -to $TNM_Custom2164 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom2249 -to $TNM_Custom2250 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom2285 -to $TNM_Custom2286 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom2287 -to $TNM_Custom2288 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom2289 -to $TNM_Custom2290 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom2288 -to $TNM_Custom2292 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom2294 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom2290 -to $TNM_Custom2296 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom2381 -to $TNM_Custom2382 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom2417 -to $TNM_Custom2418 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom2419 -to $TNM_Custom2420 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom2421 -to $TNM_Custom2422 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom2420 -to $TNM_Custom2424 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom2426 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom2422 -to $TNM_Custom2428 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom2513 -to $TNM_Custom2514 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom2549 -to $TNM_Custom2550 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom2551 -to $TNM_Custom2552 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom2553 -to $TNM_Custom2554 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom2552 -to $TNM_Custom2556 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom2558 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom2554 -to $TNM_Custom2560 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom2645 -to $TNM_Custom2646 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom2681 -to $TNM_Custom2682 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom2683 -to $TNM_Custom2684 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom2685 -to $TNM_Custom2686 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom2684 -to $TNM_Custom2688 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom2690 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom2686 -to $TNM_Custom2692 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom2777 -to $TNM_Custom2778 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom2813 -to $TNM_Custom2814 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom2815 -to $TNM_Custom2816 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom2817 -to $TNM_Custom2818 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom2816 -to $TNM_Custom2820 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom2822 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom2818 -to $TNM_Custom2824 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom2909 -to $TNM_Custom2910 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom2945 -to $TNM_Custom2946 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom2947 -to $TNM_Custom2948 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom2949 -to $TNM_Custom2950 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom2948 -to $TNM_Custom2952 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom2954 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom2950 -to $TNM_Custom2956 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3041 -to $TNM_Custom3042 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom3077 -to $TNM_Custom3078 -datapath_only 8.7990001000
set_max_delay -from $TNM_Custom3079 -to $TNM_Custom3080 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3081 -to $TNM_Custom3082 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3080 -to $TNM_Custom3084 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3086 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3082 -to $TNM_Custom3088 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3089 -to $TNM_Custom3090 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3091 -to $TNM_Custom3092 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3093 -to $TNM_Custom3092 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3095 -to $TNM_Custom3096 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom3097 -to $TNM_Custom3098 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3099 -to $TNM_Custom3100 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3098 -to $TNM_Custom3102 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3104 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3100 -to $TNM_Custom3106 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3407 -to $TNM_Custom3408 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom3409 -to $TNM_Custom3410 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3411 -to $TNM_Custom3412 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3410 -to $TNM_Custom3414 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3416 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3412 -to $TNM_Custom3418 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3419 -to $TNM_Custom3420 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3421 -to $TNM_Custom3422 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3423 -to $TNM_Custom3422 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3425 -to $TNM_Custom3426 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3427 -to $TNM_Custom3428 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3429 -to $TNM_Custom3428 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3431 -to $TNM_Custom3432 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom3433 -to $TNM_Custom3434 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3434 -to $TNM_Custom3436 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3437 -to $TNM_Custom3438 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3438 -to $TNM_Custom3440 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3441 -to $TNM_Custom3442 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3443 -to $TNM_Custom3444 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3445 -to $TNM_Custom3444 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3447 -to $TNM_Custom3448 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3449 -to $TNM_Custom3450 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3451 -to $TNM_Custom3450 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3453 -to $TNM_Custom3454 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom3455 -to $TNM_Custom3456 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3456 -to $TNM_Custom3458 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3459 -to $TNM_Custom3460 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3460 -to $TNM_Custom3462 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3463 -to $TNM_Custom3464 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3465 -to $TNM_Custom3466 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3467 -to $TNM_Custom3468 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3466 -to $TNM_Custom3470 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3472 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3468 -to $TNM_Custom3474 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3475 -to $TNM_Custom3476 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3477 -to $TNM_Custom3478 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3479 -to $TNM_Custom3480 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3478 -to $TNM_Custom3482 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3484 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3480 -to $TNM_Custom3486 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3487 -to $TNM_Custom3488 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom3489 -to $TNM_Custom3490 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3491 -to $TNM_Custom3492 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3490 -to $TNM_Custom3494 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3496 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3492 -to $TNM_Custom3498 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3499 -to $TNM_Custom3500 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3501 -to $TNM_Custom3502 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3503 -to $TNM_Custom3504 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3502 -to $TNM_Custom3506 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3508 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3504 -to $TNM_Custom3510 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3511 -to $TNM_Custom3512 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom3513 -to $TNM_Custom3514 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3515 -to $TNM_Custom3516 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3514 -to $TNM_Custom3518 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3520 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3516 -to $TNM_Custom3522 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3523 -to $TNM_Custom3524 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3525 -to $TNM_Custom3526 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3527 -to $TNM_Custom3526 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3529 -to $TNM_Custom3530 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3531 -to $TNM_Custom3532 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3533 -to $TNM_Custom3532 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3535 -to $TNM_Custom3536 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom3537 -to $TNM_Custom3538 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3538 -to $TNM_Custom3540 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3541 -to $TNM_Custom3542 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3542 -to $TNM_Custom3544 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3545 -to $TNM_Custom3546 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3547 -to $TNM_Custom3548 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3549 -to $TNM_Custom3548 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3551 -to $TNM_Custom3552 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3553 -to $TNM_Custom3554 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3555 -to $TNM_Custom3554 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3557 -to $TNM_Custom3558 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom3559 -to $TNM_Custom3560 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3560 -to $TNM_Custom3562 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3563 -to $TNM_Custom3564 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3564 -to $TNM_Custom3566 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3567 -to $TNM_Custom3568 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3569 -to $TNM_Custom3570 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3571 -to $TNM_Custom3572 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3570 -to $TNM_Custom3574 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3576 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3572 -to $TNM_Custom3578 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3579 -to $TNM_Custom3580 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3581 -to $TNM_Custom3582 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3583 -to $TNM_Custom3584 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3582 -to $TNM_Custom3586 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3588 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3584 -to $TNM_Custom3590 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3591 -to $TNM_Custom3592 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom3593 -to $TNM_Custom3594 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3595 -to $TNM_Custom3596 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3594 -to $TNM_Custom3598 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3600 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3596 -to $TNM_Custom3602 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3603 -to $TNM_Custom3604 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3605 -to $TNM_Custom3606 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3607 -to $TNM_Custom3608 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3606 -to $TNM_Custom3610 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3612 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3608 -to $TNM_Custom3614 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3615 -to $TNM_Custom3616 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom3617 -to $TNM_Custom3618 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3619 -to $TNM_Custom3620 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3618 -to $TNM_Custom3622 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3624 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3620 -to $TNM_Custom3626 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3627 -to $TNM_Custom3628 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3629 -to $TNM_Custom3630 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3631 -to $TNM_Custom3630 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3633 -to $TNM_Custom3634 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3635 -to $TNM_Custom3636 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3637 -to $TNM_Custom3636 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3639 -to $TNM_Custom3640 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom3641 -to $TNM_Custom3642 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3642 -to $TNM_Custom3644 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3645 -to $TNM_Custom3646 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3646 -to $TNM_Custom3648 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3649 -to $TNM_Custom3650 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3651 -to $TNM_Custom3652 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3653 -to $TNM_Custom3652 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3655 -to $TNM_Custom3656 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3657 -to $TNM_Custom3658 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3659 -to $TNM_Custom3658 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3661 -to $TNM_Custom3662 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom3663 -to $TNM_Custom3664 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3664 -to $TNM_Custom3666 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3667 -to $TNM_Custom3668 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3668 -to $TNM_Custom3670 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3671 -to $TNM_Custom3672 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3673 -to $TNM_Custom3674 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3675 -to $TNM_Custom3676 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3674 -to $TNM_Custom3678 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3680 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3676 -to $TNM_Custom3682 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3683 -to $TNM_Custom3684 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3685 -to $TNM_Custom3686 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3687 -to $TNM_Custom3688 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3686 -to $TNM_Custom3690 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3692 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3688 -to $TNM_Custom3694 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3695 -to $TNM_Custom3696 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom3697 -to $TNM_Custom3698 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3699 -to $TNM_Custom3700 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3698 -to $TNM_Custom3702 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3704 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3700 -to $TNM_Custom3706 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3707 -to $TNM_Custom3708 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3709 -to $TNM_Custom3710 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3711 -to $TNM_Custom3712 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3710 -to $TNM_Custom3714 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3716 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3712 -to $TNM_Custom3718 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3719 -to $TNM_Custom3720 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom3721 -to $TNM_Custom3722 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3723 -to $TNM_Custom3724 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3722 -to $TNM_Custom3726 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3728 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3724 -to $TNM_Custom3730 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3731 -to $TNM_Custom3732 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3733 -to $TNM_Custom3734 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3735 -to $TNM_Custom3734 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3737 -to $TNM_Custom3738 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3739 -to $TNM_Custom3740 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3741 -to $TNM_Custom3740 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3743 -to $TNM_Custom3744 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom3745 -to $TNM_Custom3746 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3746 -to $TNM_Custom3748 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3749 -to $TNM_Custom3750 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3750 -to $TNM_Custom3752 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3753 -to $TNM_Custom3754 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3755 -to $TNM_Custom3756 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3757 -to $TNM_Custom3756 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3759 -to $TNM_Custom3760 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3761 -to $TNM_Custom3762 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3763 -to $TNM_Custom3762 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3765 -to $TNM_Custom3766 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom3767 -to $TNM_Custom3768 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3768 -to $TNM_Custom3770 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3771 -to $TNM_Custom3772 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3772 -to $TNM_Custom3774 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3775 -to $TNM_Custom3776 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3777 -to $TNM_Custom3778 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3779 -to $TNM_Custom3780 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3778 -to $TNM_Custom3782 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3784 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3780 -to $TNM_Custom3786 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3787 -to $TNM_Custom3788 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3789 -to $TNM_Custom3790 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3791 -to $TNM_Custom3792 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3790 -to $TNM_Custom3794 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3796 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3792 -to $TNM_Custom3798 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3799 -to $TNM_Custom3800 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom3801 -to $TNM_Custom3802 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3803 -to $TNM_Custom3804 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3802 -to $TNM_Custom3806 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3808 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3804 -to $TNM_Custom3810 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3811 -to $TNM_Custom3812 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3813 -to $TNM_Custom3814 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3815 -to $TNM_Custom3816 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3814 -to $TNM_Custom3818 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3820 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3816 -to $TNM_Custom3822 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3823 -to $TNM_Custom3824 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom3825 -to $TNM_Custom3826 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3827 -to $TNM_Custom3828 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3826 -to $TNM_Custom3830 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3832 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3828 -to $TNM_Custom3834 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3835 -to $TNM_Custom3836 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3837 -to $TNM_Custom3838 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3839 -to $TNM_Custom3838 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3841 -to $TNM_Custom3842 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3843 -to $TNM_Custom3844 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3845 -to $TNM_Custom3844 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3847 -to $TNM_Custom3848 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom3849 -to $TNM_Custom3850 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3850 -to $TNM_Custom3852 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3853 -to $TNM_Custom3854 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3854 -to $TNM_Custom3856 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3857 -to $TNM_Custom3858 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3859 -to $TNM_Custom3860 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3861 -to $TNM_Custom3860 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3863 -to $TNM_Custom3864 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3865 -to $TNM_Custom3866 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3867 -to $TNM_Custom3866 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3869 -to $TNM_Custom3870 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom3871 -to $TNM_Custom3872 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3872 -to $TNM_Custom3874 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3875 -to $TNM_Custom3876 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3876 -to $TNM_Custom3878 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3879 -to $TNM_Custom3880 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3881 -to $TNM_Custom3882 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3883 -to $TNM_Custom3884 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3882 -to $TNM_Custom3886 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3888 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3884 -to $TNM_Custom3890 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3891 -to $TNM_Custom3892 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3893 -to $TNM_Custom3894 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3895 -to $TNM_Custom3896 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3894 -to $TNM_Custom3898 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3900 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3896 -to $TNM_Custom3902 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3903 -to $TNM_Custom3904 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom3905 -to $TNM_Custom3906 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3907 -to $TNM_Custom3908 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3906 -to $TNM_Custom3910 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3912 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3908 -to $TNM_Custom3914 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3915 -to $TNM_Custom3916 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3917 -to $TNM_Custom3918 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3919 -to $TNM_Custom3920 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3918 -to $TNM_Custom3922 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3924 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3920 -to $TNM_Custom3926 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom3927 -to $TNM_Custom3928 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom3929 -to $TNM_Custom3930 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3931 -to $TNM_Custom3932 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3930 -to $TNM_Custom3934 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3936 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3932 -to $TNM_Custom3938 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3939 -to $TNM_Custom3940 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3941 -to $TNM_Custom3942 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3943 -to $TNM_Custom3942 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3945 -to $TNM_Custom3946 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3947 -to $TNM_Custom3948 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3949 -to $TNM_Custom3948 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3951 -to $TNM_Custom3952 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom3953 -to $TNM_Custom3954 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3954 -to $TNM_Custom3956 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3957 -to $TNM_Custom3958 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3958 -to $TNM_Custom3960 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3961 -to $TNM_Custom3962 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3963 -to $TNM_Custom3964 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3965 -to $TNM_Custom3964 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3967 -to $TNM_Custom3968 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3969 -to $TNM_Custom3970 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3971 -to $TNM_Custom3970 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom3973 -to $TNM_Custom3974 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom3975 -to $TNM_Custom3976 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3976 -to $TNM_Custom3978 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3979 -to $TNM_Custom3980 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom3980 -to $TNM_Custom3982 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3983 -to $TNM_Custom3984 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3985 -to $TNM_Custom3986 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3987 -to $TNM_Custom3988 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3986 -to $TNM_Custom3990 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom3992 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3988 -to $TNM_Custom3994 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom3995 -to $TNM_Custom3996 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom3997 -to $TNM_Custom3998 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom3999 -to $TNM_Custom4000 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom3998 -to $TNM_Custom4002 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4004 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4000 -to $TNM_Custom4006 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4007 -to $TNM_Custom4008 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom4009 -to $TNM_Custom4010 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4011 -to $TNM_Custom4012 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4010 -to $TNM_Custom4014 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4016 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4012 -to $TNM_Custom4018 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4019 -to $TNM_Custom4020 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4021 -to $TNM_Custom4022 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4023 -to $TNM_Custom4024 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4022 -to $TNM_Custom4026 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4028 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4024 -to $TNM_Custom4030 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4031 -to $TNM_Custom4032 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom4033 -to $TNM_Custom4034 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4035 -to $TNM_Custom4036 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4034 -to $TNM_Custom4038 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4040 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4036 -to $TNM_Custom4042 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4043 -to $TNM_Custom4044 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4045 -to $TNM_Custom4046 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4047 -to $TNM_Custom4046 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4049 -to $TNM_Custom4050 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4051 -to $TNM_Custom4052 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4053 -to $TNM_Custom4052 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4055 -to $TNM_Custom4056 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4057 -to $TNM_Custom4058 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4058 -to $TNM_Custom4060 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4061 -to $TNM_Custom4062 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4062 -to $TNM_Custom4064 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4065 -to $TNM_Custom4066 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4067 -to $TNM_Custom4068 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4069 -to $TNM_Custom4068 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4071 -to $TNM_Custom4072 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4073 -to $TNM_Custom4074 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4075 -to $TNM_Custom4074 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4077 -to $TNM_Custom4078 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4079 -to $TNM_Custom4080 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4080 -to $TNM_Custom4082 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4083 -to $TNM_Custom4084 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4084 -to $TNM_Custom4086 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4087 -to $TNM_Custom4088 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4089 -to $TNM_Custom4090 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4091 -to $TNM_Custom4092 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4090 -to $TNM_Custom4094 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4096 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4092 -to $TNM_Custom4098 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4099 -to $TNM_Custom4100 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4101 -to $TNM_Custom4102 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4103 -to $TNM_Custom4104 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4102 -to $TNM_Custom4106 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4108 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4104 -to $TNM_Custom4110 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4111 -to $TNM_Custom4112 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom4113 -to $TNM_Custom4114 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4115 -to $TNM_Custom4116 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4114 -to $TNM_Custom4118 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4120 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4116 -to $TNM_Custom4122 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4123 -to $TNM_Custom4124 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4125 -to $TNM_Custom4126 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4127 -to $TNM_Custom4128 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4126 -to $TNM_Custom4130 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4132 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4128 -to $TNM_Custom4134 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4135 -to $TNM_Custom4136 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom4137 -to $TNM_Custom4138 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4139 -to $TNM_Custom4140 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4138 -to $TNM_Custom4142 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4144 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4140 -to $TNM_Custom4146 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4147 -to $TNM_Custom4148 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4149 -to $TNM_Custom4150 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4151 -to $TNM_Custom4150 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4153 -to $TNM_Custom4154 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4155 -to $TNM_Custom4156 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4157 -to $TNM_Custom4156 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4159 -to $TNM_Custom4160 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4161 -to $TNM_Custom4162 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4162 -to $TNM_Custom4164 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4165 -to $TNM_Custom4166 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4166 -to $TNM_Custom4168 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4169 -to $TNM_Custom4170 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4171 -to $TNM_Custom4172 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4173 -to $TNM_Custom4172 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4175 -to $TNM_Custom4176 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4177 -to $TNM_Custom4178 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4179 -to $TNM_Custom4178 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4181 -to $TNM_Custom4182 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4183 -to $TNM_Custom4184 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4184 -to $TNM_Custom4186 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4187 -to $TNM_Custom4188 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4188 -to $TNM_Custom4190 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4191 -to $TNM_Custom4192 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4193 -to $TNM_Custom4194 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4195 -to $TNM_Custom4196 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4194 -to $TNM_Custom4198 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4200 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4196 -to $TNM_Custom4202 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4203 -to $TNM_Custom4204 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4205 -to $TNM_Custom4206 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4207 -to $TNM_Custom4208 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4206 -to $TNM_Custom4210 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4212 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4208 -to $TNM_Custom4214 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4215 -to $TNM_Custom4216 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom4217 -to $TNM_Custom4218 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4219 -to $TNM_Custom4220 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4218 -to $TNM_Custom4222 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4224 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4220 -to $TNM_Custom4226 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4227 -to $TNM_Custom4228 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4229 -to $TNM_Custom4230 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4231 -to $TNM_Custom4232 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4230 -to $TNM_Custom4234 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4236 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4232 -to $TNM_Custom4238 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4239 -to $TNM_Custom4240 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom4241 -to $TNM_Custom4242 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4243 -to $TNM_Custom4244 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4242 -to $TNM_Custom4246 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4248 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4244 -to $TNM_Custom4250 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4251 -to $TNM_Custom4252 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4253 -to $TNM_Custom4254 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4255 -to $TNM_Custom4254 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4257 -to $TNM_Custom4258 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4259 -to $TNM_Custom4260 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4261 -to $TNM_Custom4260 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4263 -to $TNM_Custom4264 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4265 -to $TNM_Custom4266 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4266 -to $TNM_Custom4268 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4269 -to $TNM_Custom4270 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4270 -to $TNM_Custom4272 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4273 -to $TNM_Custom4274 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4275 -to $TNM_Custom4276 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4277 -to $TNM_Custom4276 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4279 -to $TNM_Custom4280 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4281 -to $TNM_Custom4282 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4283 -to $TNM_Custom4282 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4285 -to $TNM_Custom4286 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4287 -to $TNM_Custom4288 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4288 -to $TNM_Custom4290 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4291 -to $TNM_Custom4292 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4292 -to $TNM_Custom4294 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4295 -to $TNM_Custom4296 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4297 -to $TNM_Custom4298 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4299 -to $TNM_Custom4300 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4298 -to $TNM_Custom4302 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4304 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4300 -to $TNM_Custom4306 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4307 -to $TNM_Custom4308 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4309 -to $TNM_Custom4310 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4311 -to $TNM_Custom4312 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4310 -to $TNM_Custom4314 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4316 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4312 -to $TNM_Custom4318 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4319 -to $TNM_Custom4320 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom4321 -to $TNM_Custom4322 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4323 -to $TNM_Custom4324 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4322 -to $TNM_Custom4326 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4328 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4324 -to $TNM_Custom4330 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4331 -to $TNM_Custom4332 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4333 -to $TNM_Custom4334 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4335 -to $TNM_Custom4336 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4334 -to $TNM_Custom4338 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4340 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4336 -to $TNM_Custom4342 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4343 -to $TNM_Custom4344 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom4345 -to $TNM_Custom4346 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4347 -to $TNM_Custom4348 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4346 -to $TNM_Custom4350 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4352 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4348 -to $TNM_Custom4354 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4355 -to $TNM_Custom4356 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4357 -to $TNM_Custom4358 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4359 -to $TNM_Custom4358 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4361 -to $TNM_Custom4362 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4363 -to $TNM_Custom4364 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4365 -to $TNM_Custom4364 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4367 -to $TNM_Custom4368 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4369 -to $TNM_Custom4370 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4370 -to $TNM_Custom4372 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4373 -to $TNM_Custom4374 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4374 -to $TNM_Custom4376 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4377 -to $TNM_Custom4378 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4379 -to $TNM_Custom4380 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4381 -to $TNM_Custom4380 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4383 -to $TNM_Custom4384 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4385 -to $TNM_Custom4386 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4387 -to $TNM_Custom4386 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4389 -to $TNM_Custom4390 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4391 -to $TNM_Custom4392 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4392 -to $TNM_Custom4394 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4395 -to $TNM_Custom4396 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4396 -to $TNM_Custom4398 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4399 -to $TNM_Custom4400 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4401 -to $TNM_Custom4402 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4403 -to $TNM_Custom4404 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4402 -to $TNM_Custom4406 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4408 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4404 -to $TNM_Custom4410 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4411 -to $TNM_Custom4412 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4413 -to $TNM_Custom4414 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4415 -to $TNM_Custom4416 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4414 -to $TNM_Custom4418 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4420 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4416 -to $TNM_Custom4422 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4423 -to $TNM_Custom4424 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom4425 -to $TNM_Custom4426 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4427 -to $TNM_Custom4428 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4426 -to $TNM_Custom4430 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4432 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4428 -to $TNM_Custom4434 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4435 -to $TNM_Custom4436 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4437 -to $TNM_Custom4438 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4439 -to $TNM_Custom4440 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4438 -to $TNM_Custom4442 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4444 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4440 -to $TNM_Custom4446 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4447 -to $TNM_Custom4448 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom4449 -to $TNM_Custom4450 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4451 -to $TNM_Custom4452 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4450 -to $TNM_Custom4454 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4456 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4452 -to $TNM_Custom4458 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4459 -to $TNM_Custom4460 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4461 -to $TNM_Custom4462 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4463 -to $TNM_Custom4462 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4465 -to $TNM_Custom4466 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4467 -to $TNM_Custom4468 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4469 -to $TNM_Custom4468 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4471 -to $TNM_Custom4472 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4473 -to $TNM_Custom4474 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4474 -to $TNM_Custom4476 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4477 -to $TNM_Custom4478 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4478 -to $TNM_Custom4480 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4481 -to $TNM_Custom4482 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4483 -to $TNM_Custom4484 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4485 -to $TNM_Custom4484 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4487 -to $TNM_Custom4488 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4489 -to $TNM_Custom4490 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4491 -to $TNM_Custom4490 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4493 -to $TNM_Custom4494 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4495 -to $TNM_Custom4496 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4496 -to $TNM_Custom4498 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4499 -to $TNM_Custom4500 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4500 -to $TNM_Custom4502 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4503 -to $TNM_Custom4504 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4505 -to $TNM_Custom4506 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4507 -to $TNM_Custom4508 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4506 -to $TNM_Custom4510 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4512 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4508 -to $TNM_Custom4514 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4515 -to $TNM_Custom4516 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4517 -to $TNM_Custom4518 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4519 -to $TNM_Custom4520 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4518 -to $TNM_Custom4522 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4524 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4520 -to $TNM_Custom4526 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4527 -to $TNM_Custom4528 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom4529 -to $TNM_Custom4530 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4531 -to $TNM_Custom4532 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4530 -to $TNM_Custom4534 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4536 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4532 -to $TNM_Custom4538 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4539 -to $TNM_Custom4540 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4541 -to $TNM_Custom4542 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4543 -to $TNM_Custom4544 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4542 -to $TNM_Custom4546 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4548 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4544 -to $TNM_Custom4550 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4551 -to $TNM_Custom4552 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom4553 -to $TNM_Custom4554 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4555 -to $TNM_Custom4556 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4554 -to $TNM_Custom4558 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4560 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4556 -to $TNM_Custom4562 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4563 -to $TNM_Custom4564 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4565 -to $TNM_Custom4566 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4567 -to $TNM_Custom4566 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4569 -to $TNM_Custom4570 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4571 -to $TNM_Custom4572 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4573 -to $TNM_Custom4572 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4575 -to $TNM_Custom4576 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4577 -to $TNM_Custom4578 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4578 -to $TNM_Custom4580 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4581 -to $TNM_Custom4582 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4582 -to $TNM_Custom4584 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4585 -to $TNM_Custom4586 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4587 -to $TNM_Custom4588 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4589 -to $TNM_Custom4588 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4591 -to $TNM_Custom4592 -datapath_only 14.6985001500
set_max_delay -from $TNM_Custom4593 -to $TNM_Custom4594 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4595 -to $TNM_Custom4594 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4597 -to $TNM_Custom4598 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4599 -to $TNM_Custom4600 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4600 -to $TNM_Custom4602 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4603 -to $TNM_Custom4604 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4604 -to $TNM_Custom4606 -datapath_only 2.4497500250
set_max_delay -from $TNM_Custom4607 -to $TNM_Custom4608 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4609 -to $TNM_Custom4610 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4611 -to $TNM_Custom4612 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4610 -to $TNM_Custom4614 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4616 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4612 -to $TNM_Custom4618 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4619 -to $TNM_Custom4620 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4621 -to $TNM_Custom4622 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4623 -to $TNM_Custom4624 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4622 -to $TNM_Custom4626 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4628 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4624 -to $TNM_Custom4630 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4631 -to $TNM_Custom4632 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom4633 -to $TNM_Custom4634 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4635 -to $TNM_Custom4636 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4634 -to $TNM_Custom4638 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4640 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4636 -to $TNM_Custom4642 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4643 -to $TNM_Custom4644 -datapath_only 3.6995000500
set_max_delay -from $TNM_Custom4645 -to $TNM_Custom4646 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4647 -to $TNM_Custom4648 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4646 -to $TNM_Custom4650 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4652 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4648 -to $TNM_Custom4654 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4655 -to $TNM_Custom4656 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom4657 -to $TNM_Custom4658 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4659 -to $TNM_Custom4660 -datapath_only 7.0492500750
set_max_delay -from $TNM_Custom4658 -to $TNM_Custom4662 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4664 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4660 -to $TNM_Custom4666 -datapath_only 1.1748750125
set_max_delay -from $TNM_Custom4667 -to $TNM_Custom4668 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4669 -to $TNM_Custom4670 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4671 -to $TNM_Custom4672  24.4975002500
set_max_delay -from $TNM_Custom4681 -to $TNM_Custom4682 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4683 -to $TNM_Custom4684 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4685 -to $TNM_Custom4686 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4687 -to $TNM_Custom4688 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4689 -to $TNM_Custom4690 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4691 -to $TNM_Custom4692 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4693 -to $TNM_Custom4694  24.4975002500
set_max_delay -from $TNM_Custom4703 -to $TNM_Custom4704 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4705 -to $TNM_Custom4706 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4707 -to $TNM_Custom4708 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4709 -to $TNM_Custom4710 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4711 -to $TNM_Custom4712 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4713 -to $TNM_Custom4714 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4715 -to $TNM_Custom4716  24.4975002500
set_max_delay -from $TNM_Custom4725 -to $TNM_Custom4726 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4727 -to $TNM_Custom4728 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4729 -to $TNM_Custom4730 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4731 -to $TNM_Custom4732 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4733 -to $TNM_Custom4734 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4735 -to $TNM_Custom4736 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4737 -to $TNM_Custom4738  24.4975002500
set_max_delay -from $TNM_Custom4747 -to $TNM_Custom4748 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4749 -to $TNM_Custom4750 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4751 -to $TNM_Custom4752 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4753 -to $TNM_Custom4754 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4755 -to $TNM_Custom4756 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4757 -to $TNM_Custom4758 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4759 -to $TNM_Custom4760  24.4975002500
set_max_delay -from $TNM_Custom4769 -to $TNM_Custom4770 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4771 -to $TNM_Custom4772 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4773 -to $TNM_Custom4774 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4775 -to $TNM_Custom4776 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4777 -to $TNM_Custom4778 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4779 -to $TNM_Custom4780 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4781 -to $TNM_Custom4782  24.4975002500
set_max_delay -from $TNM_Custom4791 -to $TNM_Custom4792 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4793 -to $TNM_Custom4794 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4795 -to $TNM_Custom4796 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4797 -to $TNM_Custom4798 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4799 -to $TNM_Custom4800 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4801 -to $TNM_Custom4802 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4803 -to $TNM_Custom4804  24.4975002500
set_max_delay -from $TNM_Custom4813 -to $TNM_Custom4814 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4815 -to $TNM_Custom4816 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4817 -to $TNM_Custom4818 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4819 -to $TNM_Custom4820 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4821 -to $TNM_Custom4822 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4823 -to $TNM_Custom4824 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4825 -to $TNM_Custom4826  24.4975002500
set_max_delay -from $TNM_Custom4835 -to $TNM_Custom4836 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4837 -to $TNM_Custom4838 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4839 -to $TNM_Custom4840 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4841 -to $TNM_Custom4842 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4843 -to $TNM_Custom4844 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4845 -to $TNM_Custom4846 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4847 -to $TNM_Custom4848 -datapath_only 23.4975002500
set_max_delay -from $TNM_Custom4849 -to $TNM_Custom4850 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4851 -to $TNM_Custom4852 -datapath_only 11.2488001200
set_max_delay -from $TNM_Custom4850 -to $TNM_Custom4854 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom9 -to $TNM_Custom4856 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4852 -to $TNM_Custom4858 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4859 -to $TNM_Custom4860 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4860 -to $TNM_Custom4862 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4863 -to $TNM_Custom4864 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4864 -to $TNM_Custom4866 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4867 -to $TNM_Custom4868 -datapath_only 24.4975002500
set_max_delay -from $TNM_Custom4869 -to $TNM_Custom4870 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4871 -to $TNM_Custom4872 -datapath_only 1.8748000200
set_max_delay -from $TNM_Custom4873 -to $TNM_Custom4874 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4875 -to $TNM_Custom4876 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4877 -to $TNM_Custom4876 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4879 -to $TNM_Custom4880 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4881 -to $TNM_Custom4882 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4883 -to $TNM_Custom4884 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4885 -to $TNM_Custom4886 -datapath_only 11.2488001200
set_max_delay -from $TNM_Custom4887 -to $TNM_Custom4886 -datapath_only 11.2488001200
set_max_delay -from $TNM_Custom4889 -to $TNM_Custom4890 -datapath_only 11.2488001200
set_max_delay -from $TNM_Custom4891 -to $TNM_Custom4892 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4893 -to $TNM_Custom4892 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4895 -to $TNM_Custom4896 -datapath_only 11.2488001200
set_max_delay -from $TNM_Custom4897 -to $TNM_Custom4898 -datapath_only 36.7462503750
set_max_delay -from $TNM_Custom4899 -to $TNM_Custom4900 -datapath_only 11.2488001200
set_max_delay -from $TNM_Custom4901 -to $TNM_Custom4900 -datapath_only 11.2488001200
set_max_delay -from $TNM_Custom4903 -to $TNM_Custom4904  24.4975002500
set_max_delay -from $TNM_Custom4913 -to $TNM_Custom4914 -datapath_only 4.8745000500
set_max_delay -from $TNM_Custom4915 -to $TNM_Custom4916 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4917 -to $TNM_Custom4918 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4919 -to $TNM_Custom4920 -datapath_only 4.8745000500
set_max_delay -from $TNM_Custom4921 -to $TNM_Custom4922 -datapath_only 4.8745000500
set_max_delay -from $TNM_Custom4923 -to $TNM_Custom4924 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4925 -to $TNM_Custom4926 -datapath_only 73.4925007499
set_max_delay -from $TNM_Custom4927 -to $TNM_Custom4928 -datapath_only 73.4925007499
set_max_delay -from $TNM_Custom4925 -to $TNM_Custom4930 -datapath_only 12.2487501250
set_max_delay -from $TNM_Custom4927 -to $TNM_Custom4932 -datapath_only 12.2487501250
set_max_delay -from $TNM_Custom4933 -to $TNM_Custom4934 -datapath_only 73.4925007499
set_max_delay -from $TNM_Custom4935 -to $TNM_Custom4936 -datapath_only 73.4925007499
set_max_delay -from $TNM_Custom4937 -to $TNM_Custom4938 -datapath_only 73.4925007499
set_max_delay -from $TNM_Custom4939 -to $TNM_Custom4940 -datapath_only 73.4925007499
set_max_delay -from $TNM_Custom4941 -to $TNM_Custom4942 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4943 -to $TNM_Custom4944  24.4975002500
set_max_delay -from $TNM_Custom4953 -to $TNM_Custom4954 -datapath_only 4.8745000500
set_max_delay -from $TNM_Custom4955 -to $TNM_Custom4956 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4957 -to $TNM_Custom4958 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4959 -to $TNM_Custom4960 -datapath_only 4.8745000500
set_max_delay -from $TNM_Custom4961 -to $TNM_Custom4962 -datapath_only 4.8745000500
set_max_delay -from $TNM_Custom4963 -to $TNM_Custom4964 -datapath_only 6.1243750625
set_max_delay -from $TNM_Custom4965  -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4966 -to $TNM_Custom4967 -datapath_only 12.2487501250
set_max_delay -from $TNM_Custom4945 -to $TNM_Custom4946 -datapath_only 19.4980002000
set_max_delay -from $TNM_Custom4905 -to $TNM_Custom4906 -datapath_only 19.4980002000
set_max_delay -from $TNM_Custom745 -to $TNM_Custom746 -datapath_only 9.7990001000
set_max_delay -from $TNM_Custom789 -to $TNM_Custom790 -datapath_only 24.4975002500
set_max_delay -from $TNM_Custom4827 -to $TNM_Custom4828 -datapath_only 7.4992000800
set_max_delay -from $TNM_Custom4805 -to $TNM_Custom4806 -datapath_only 7.4992000800
set_max_delay -from $TNM_Custom4783 -to $TNM_Custom4784 -datapath_only 7.4992000800
set_max_delay -from $TNM_Custom4761 -to $TNM_Custom4762 -datapath_only 7.4992000800
set_max_delay -from $TNM_Custom4739 -to $TNM_Custom4740 -datapath_only 7.4992000800
set_max_delay -from $TNM_Custom4717 -to $TNM_Custom4718 -datapath_only 7.4992000800
set_max_delay -from $TNM_Custom4695 -to $TNM_Custom4696 -datapath_only 7.4992000800
set_max_delay -from $TNM_Custom4673 -to $TNM_Custom4674 -datapath_only 7.4992000800
set_max_delay -from $TNM_Custom767 -to $TNM_Custom768 -datapath_only 24.4975002500
set_max_delay -from $TNM_Custom723 -to $TNM_Custom724 -datapath_only 24.4975002500
set_max_delay -from $TNM_Custom793 -to $TNM_Custom794 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom771 -to $TNM_Custom772 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom749 -to $TNM_Custom750 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom727 -to $TNM_Custom728 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4949 -to $TNM_Custom4950 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4909 -to $TNM_Custom4910 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4831 -to $TNM_Custom4832 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4809 -to $TNM_Custom4810 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4787 -to $TNM_Custom4788 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4765 -to $TNM_Custom4766 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4743 -to $TNM_Custom4744 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4721 -to $TNM_Custom4722 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4699 -to $TNM_Custom4700 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4677 -to $TNM_Custom4678 -datapath_only 100.0000000000
set_max_delay -from $TNM_Custom4951 -to $TNM_Custom4952 -datapath_only 9.7490001000
set_max_delay -from $TNM_Custom4943 -to $TNM_Custom4948 -datapath_only 9.7490001000
set_max_delay -from $TNM_Custom4911 -to $TNM_Custom4912 -datapath_only 9.7490001000
set_max_delay -from $TNM_Custom4903 -to $TNM_Custom4908 -datapath_only 9.7490001000
set_max_delay -from $TNM_Custom751 -to $TNM_Custom752 -datapath_only 4.8995000500
set_max_delay -from $TNM_Custom743 -to $TNM_Custom748 -datapath_only 4.8995000500
set_max_delay -from $TNM_Custom795 -to $TNM_Custom796 -datapath_only 12.2487501250
set_max_delay -from $TNM_Custom787 -to $TNM_Custom792 -datapath_only 12.2487501250
set_max_delay -from $TNM_Custom4833 -to $TNM_Custom4834 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom4825 -to $TNM_Custom4830 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom4811 -to $TNM_Custom4812 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom4803 -to $TNM_Custom4808 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom4789 -to $TNM_Custom4790 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom4781 -to $TNM_Custom4786 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom4767 -to $TNM_Custom4768 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom4759 -to $TNM_Custom4764 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom4745 -to $TNM_Custom4746 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom4737 -to $TNM_Custom4742 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom4723 -to $TNM_Custom4724 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom4715 -to $TNM_Custom4720 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom4701 -to $TNM_Custom4702 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom4693 -to $TNM_Custom4698 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom4679 -to $TNM_Custom4680 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom4671 -to $TNM_Custom4676 -datapath_only 3.7496000400
set_max_delay -from $TNM_Custom773 -to $TNM_Custom774 -datapath_only 12.2487501250
set_max_delay -from $TNM_Custom765 -to $TNM_Custom770 -datapath_only 12.2487501250
set_max_delay -from $TNM_Custom729 -to $TNM_Custom730 -datapath_only 12.2487501250
set_max_delay -from $TNM_Custom721 -to $TNM_Custom726 -datapath_only 12.2487501250





# This constraint is required to disable the tools from performing timing 
# analysis on the aDiagramResetLoc net which is meant to be used as an 
# asynchronous reset. This constraint is really only required for 
# Spartan6/Virtex 6/Kintex7/Zynq/Virtex7 and later devices as the tools perform 
# asynchronous reset  recovery timing analysis for these devices, but it doesn't 
# hurt to have them for other devices as well.
# Please note that this constraint is required in addition to having 
# "DISABLE = reg_sr_r;" constraint, as the DISABLE constraint is buggy 
# and does not disable timing analysis for asynchronous resets in certain
# situations.
# It is possible that we would remove the DISABLE constraint and keep
# the timing ignore constraint, but this has not been verified.
#There is no equivalent flag known yet in Vivado for DISABLE=reg_sr_r;
#set_false_path is used to ignore reset recovery checks of  
#asynchronous reset paths on clock domains crossing 
set_false_path -through [get_nets {*DiagramResetx*aDiagramResetLoc*}]



# END_LV_FPGA_FROM_TO_CONSTRAINTS

# END_LV_FPGA_CONSTRAINTS
################################################################################


## Start add from file GitHubSasquatch.xdc
################################################################################

# It is OK to leave these constraints in the LV FPGA target plugin constraints file that is used by
# LV FPGA compile worker compiles.  The added DMA port crossing constriants will be ignored.
# And setting/reverting the current instance will have no affect.

# This section pulls in PERIOD and CLIP constraints extracted from the Vivado Project Export for The Window.
#
# BEGIN_LV_NETLIST_PERIOD_AND_CLIP_CONSTRAINTS
#
#
# END_LV_NETLIST_PERIOD_AND_CLIP_CONSTRAINTS


# GitHub Vivado build needs these constraints that are normally provided by LV FPGA because they are actually
# for clock boundary crossings that are outside of the LV Window.  We must duplicate these constraints outside
# of the LV Window current_instance section so that they are applied properly.
#
set DmaPortCommCrossingFrom [get_cells {*DmaPortCommIfcIrqInterfacex/DoubleSyncSLx*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set DmaPortCommCrossingTo [get_cells {*DmaPortCommIfcIrqInterfacex/DoubleSyncSLx*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $DmaPortCommCrossingFrom -to $DmaPortCommCrossingTo -datapath_only 100.0000000000

set TopInstance0 [current_instance .]
current_instance SasquatchWindow

# This section pulls in FROM-TO constraints extracted from the Vivado Project Export for The Window.
# This must be inserted within the current_instance set to SasquatchWindow because the paths constrained
# in this section are inside of The Window netlist.  In a LabVIEW FPGA compile worker build, The Window
# is HDL and the constraints do not need to be put within the current_instance.
#
# BEGIN_LV_NETLIST_FROM_TO_CONSTRAINTS
#
#
# END_LV_NETLIST_FROM_TO_CONSTRAINTS

current_instance -quiet
current_instance $TopInstance0

##############################################################
# Insert custom constraints here for GitHub customized targets
##############################################################



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
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 64/$LineRateInGbs] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].Aurora_PortN/*/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]


create_clock -period [expr 64/$LineRateInGbs] -name port0_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port0_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port1_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port1_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port2_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port2_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port3_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port3_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port4_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port4_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port5_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port5_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port6_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port6_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port7_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port7_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port8_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port8_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port9_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port9_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port10_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port10_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

create_clock -period [expr 64/$LineRateInGbs] -name port11_rxusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port11_txusrclk2 [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]


########################### UltraScale Digital Monitor clock ###########################
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[0].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[1].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[2].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[3].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[4].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[5].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[6].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[7].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[8].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[9].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[10].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[11].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[12].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[13].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[14].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[15].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[16].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[17].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[18].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[19].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[20].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[21].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[22].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[23].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[24].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[25].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[26].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[27].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[28].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[29].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[30].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[31].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[32].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[33].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[34].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[35].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[36].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[37].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[38].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[39].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[40].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[41].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[42].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[43].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[44].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[45].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[46].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/GenGtwizDMonClk[47].DMonClk_bufg_instN/O}]

########################### False Paths - UltraScale GT Wizard ExDes ###########################
set_false_path -to [get_cells -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[*].Aurora_PortN/*bit_synchronizer*inst/i_in_meta_reg}]
set_false_path -to [get_cells -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[*].Aurora_PortN/*reset_synchronizer*inst/rst_in_*_reg}]
set_false_path -to [get_cells -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[*].Aurora_PortN/*gtwiz_userclk_tx_active_*_reg}]
set_false_path -to [get_cells -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[*].Aurora_PortN/*gtwiz_userclk_rx_active_*_reg}]

###########################       False Paths - Aurora Core          ###########################
set_false_path -to [get_pins -hier -filter {NAME =~ UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/*aurora64b66b_*_cdc_to*/D}]

##############################################################
####################### Port 0 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port0_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port0_txusrclk2"] -to $port0_TNM_TxResetDone_out -datapath_only 10.0

set port0_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port0_rxusrclk2"] -to $port0_TNM_RxResetDone_out -datapath_only 10.0

set port0_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port0_rxusrclk2"] -to $port0_TNM_RxPrbsLocked_out -datapath_only 10.0

set port0_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port0_TNM_lRxLpmEn -to $port0_TNM_rRxLpmEn -datapath_only 10.0

set port0_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port0_TNM_lRxHoldReg -to $port0_TNM_rRxHoldReg_ms -datapath_only 10.0

set port0_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port0_TNM_lRxOvrdReg -to $port0_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port0_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port0_TNM_lRxPolarityReg -to $port0_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port0_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port0_TNM_lTxPolarityReg -to $port0_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port0_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port0_TNM_PulseSync_iDlySigx -to $port0_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port0_TNM_PulseSync_oSigx    -to $port0_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port0_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[0].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port0_TNM_HandShake_iStoredData        -to $port0_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port0_TNM_HandShake_iPushToggle        -to $port0_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port0_TNM_HandShake_oPushToggleToReady -to $port0_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 1 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port1_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port1_txusrclk2"] -to $port1_TNM_TxResetDone_out -datapath_only 10.0

set port1_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port1_rxusrclk2"] -to $port1_TNM_RxResetDone_out -datapath_only 10.0

set port1_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port1_rxusrclk2"] -to $port1_TNM_RxPrbsLocked_out -datapath_only 10.0

set port1_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port1_TNM_lRxLpmEn -to $port1_TNM_rRxLpmEn -datapath_only 10.0

set port1_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port1_TNM_lRxHoldReg -to $port1_TNM_rRxHoldReg_ms -datapath_only 10.0

set port1_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port1_TNM_lRxOvrdReg -to $port1_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port1_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port1_TNM_lRxPolarityReg -to $port1_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port1_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port1_TNM_lTxPolarityReg -to $port1_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port1_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port1_TNM_PulseSync_iDlySigx -to $port1_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port1_TNM_PulseSync_oSigx    -to $port1_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port1_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[1].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port1_TNM_HandShake_iStoredData        -to $port1_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port1_TNM_HandShake_iPushToggle        -to $port1_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port1_TNM_HandShake_oPushToggleToReady -to $port1_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 2 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port2_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port2_txusrclk2"] -to $port2_TNM_TxResetDone_out -datapath_only 10.0

set port2_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port2_rxusrclk2"] -to $port2_TNM_RxResetDone_out -datapath_only 10.0

set port2_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port2_rxusrclk2"] -to $port2_TNM_RxPrbsLocked_out -datapath_only 10.0

set port2_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port2_TNM_lRxLpmEn -to $port2_TNM_rRxLpmEn -datapath_only 10.0

set port2_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port2_TNM_lRxHoldReg -to $port2_TNM_rRxHoldReg_ms -datapath_only 10.0

set port2_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port2_TNM_lRxOvrdReg -to $port2_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port2_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port2_TNM_lRxPolarityReg -to $port2_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port2_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port2_TNM_lTxPolarityReg -to $port2_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port2_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port2_TNM_PulseSync_iDlySigx -to $port2_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port2_TNM_PulseSync_oSigx    -to $port2_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port2_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port2_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[2].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port2_TNM_HandShake_iStoredData        -to $port2_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port2_TNM_HandShake_iPushToggle        -to $port2_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port2_TNM_HandShake_oPushToggleToReady -to $port2_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 3 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port3_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port3_txusrclk2"] -to $port3_TNM_TxResetDone_out -datapath_only 10.0

set port3_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port3_rxusrclk2"] -to $port3_TNM_RxResetDone_out -datapath_only 10.0

set port3_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port3_rxusrclk2"] -to $port3_TNM_RxPrbsLocked_out -datapath_only 10.0

set port3_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port3_TNM_lRxLpmEn -to $port3_TNM_rRxLpmEn -datapath_only 10.0

set port3_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port3_TNM_lRxHoldReg -to $port3_TNM_rRxHoldReg_ms -datapath_only 10.0

set port3_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port3_TNM_lRxOvrdReg -to $port3_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port3_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port3_TNM_lRxPolarityReg -to $port3_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port3_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port3_TNM_lTxPolarityReg -to $port3_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port3_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port3_TNM_PulseSync_iDlySigx -to $port3_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port3_TNM_PulseSync_oSigx    -to $port3_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port3_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port3_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[3].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port3_TNM_HandShake_iStoredData        -to $port3_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port3_TNM_HandShake_iPushToggle        -to $port3_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port3_TNM_HandShake_oPushToggleToReady -to $port3_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 4 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port4_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port4_txusrclk2"] -to $port4_TNM_TxResetDone_out -datapath_only 10.0

set port4_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port4_rxusrclk2"] -to $port4_TNM_RxResetDone_out -datapath_only 10.0

set port4_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port4_rxusrclk2"] -to $port4_TNM_RxPrbsLocked_out -datapath_only 10.0

set port4_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port4_TNM_lRxLpmEn -to $port4_TNM_rRxLpmEn -datapath_only 10.0

set port4_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port4_TNM_lRxHoldReg -to $port4_TNM_rRxHoldReg_ms -datapath_only 10.0

set port4_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port4_TNM_lRxOvrdReg -to $port4_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port4_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port4_TNM_lRxPolarityReg -to $port4_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port4_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port4_TNM_lTxPolarityReg -to $port4_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port4_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port4_TNM_PulseSync_iDlySigx -to $port4_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port4_TNM_PulseSync_oSigx    -to $port4_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port4_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port4_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[4].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port4_TNM_HandShake_iStoredData        -to $port4_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port4_TNM_HandShake_iPushToggle        -to $port4_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port4_TNM_HandShake_oPushToggleToReady -to $port4_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 5 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port5_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port5_txusrclk2"] -to $port5_TNM_TxResetDone_out -datapath_only 10.0

set port5_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port5_rxusrclk2"] -to $port5_TNM_RxResetDone_out -datapath_only 10.0

set port5_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port5_rxusrclk2"] -to $port5_TNM_RxPrbsLocked_out -datapath_only 10.0

set port5_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port5_TNM_lRxLpmEn -to $port5_TNM_rRxLpmEn -datapath_only 10.0

set port5_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port5_TNM_lRxHoldReg -to $port5_TNM_rRxHoldReg_ms -datapath_only 10.0

set port5_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port5_TNM_lRxOvrdReg -to $port5_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port5_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port5_TNM_lRxPolarityReg -to $port5_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port5_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port5_TNM_lTxPolarityReg -to $port5_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port5_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port5_TNM_PulseSync_iDlySigx -to $port5_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port5_TNM_PulseSync_oSigx    -to $port5_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port5_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port5_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[5].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port5_TNM_HandShake_iStoredData        -to $port5_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port5_TNM_HandShake_iPushToggle        -to $port5_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port5_TNM_HandShake_oPushToggleToReady -to $port5_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 6 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port6_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port6_txusrclk2"] -to $port6_TNM_TxResetDone_out -datapath_only 10.0

set port6_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port6_rxusrclk2"] -to $port6_TNM_RxResetDone_out -datapath_only 10.0

set port6_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port6_rxusrclk2"] -to $port6_TNM_RxPrbsLocked_out -datapath_only 10.0

set port6_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port6_TNM_lRxLpmEn -to $port6_TNM_rRxLpmEn -datapath_only 10.0

set port6_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port6_TNM_lRxHoldReg -to $port6_TNM_rRxHoldReg_ms -datapath_only 10.0

set port6_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port6_TNM_lRxOvrdReg -to $port6_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port6_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port6_TNM_lRxPolarityReg -to $port6_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port6_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port6_TNM_lTxPolarityReg -to $port6_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port6_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port6_TNM_PulseSync_iDlySigx -to $port6_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port6_TNM_PulseSync_oSigx    -to $port6_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port6_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port6_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[6].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port6_TNM_HandShake_iStoredData        -to $port6_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port6_TNM_HandShake_iPushToggle        -to $port6_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port6_TNM_HandShake_oPushToggleToReady -to $port6_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 7 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port7_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port7_txusrclk2"] -to $port7_TNM_TxResetDone_out -datapath_only 10.0

set port7_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port7_rxusrclk2"] -to $port7_TNM_RxResetDone_out -datapath_only 10.0

set port7_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port7_rxusrclk2"] -to $port7_TNM_RxPrbsLocked_out -datapath_only 10.0

set port7_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port7_TNM_lRxLpmEn -to $port7_TNM_rRxLpmEn -datapath_only 10.0

set port7_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port7_TNM_lRxHoldReg -to $port7_TNM_rRxHoldReg_ms -datapath_only 10.0

set port7_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port7_TNM_lRxOvrdReg -to $port7_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port7_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port7_TNM_lRxPolarityReg -to $port7_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port7_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port7_TNM_lTxPolarityReg -to $port7_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port7_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port7_TNM_PulseSync_iDlySigx -to $port7_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port7_TNM_PulseSync_oSigx    -to $port7_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port7_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port7_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[7].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port7_TNM_HandShake_iStoredData        -to $port7_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port7_TNM_HandShake_iPushToggle        -to $port7_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port7_TNM_HandShake_oPushToggleToReady -to $port7_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 8 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port8_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port8_txusrclk2"] -to $port8_TNM_TxResetDone_out -datapath_only 10.0

set port8_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port8_rxusrclk2"] -to $port8_TNM_RxResetDone_out -datapath_only 10.0

set port8_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port8_rxusrclk2"] -to $port8_TNM_RxPrbsLocked_out -datapath_only 10.0

set port8_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port8_TNM_lRxLpmEn -to $port8_TNM_rRxLpmEn -datapath_only 10.0

set port8_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port8_TNM_lRxHoldReg -to $port8_TNM_rRxHoldReg_ms -datapath_only 10.0

set port8_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port8_TNM_lRxOvrdReg -to $port8_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port8_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port8_TNM_lRxPolarityReg -to $port8_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port8_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port8_TNM_lTxPolarityReg -to $port8_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port8_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port8_TNM_PulseSync_iDlySigx -to $port8_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port8_TNM_PulseSync_oSigx    -to $port8_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port8_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port8_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[8].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port8_TNM_HandShake_iStoredData        -to $port8_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port8_TNM_HandShake_iPushToggle        -to $port8_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port8_TNM_HandShake_oPushToggleToReady -to $port8_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 9 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port9_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port9_txusrclk2"] -to $port9_TNM_TxResetDone_out -datapath_only 10.0

set port9_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port9_rxusrclk2"] -to $port9_TNM_RxResetDone_out -datapath_only 10.0

set port9_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port9_rxusrclk2"] -to $port9_TNM_RxPrbsLocked_out -datapath_only 10.0

set port9_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port9_TNM_lRxLpmEn -to $port9_TNM_rRxLpmEn -datapath_only 10.0

set port9_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port9_TNM_lRxHoldReg -to $port9_TNM_rRxHoldReg_ms -datapath_only 10.0

set port9_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port9_TNM_lRxOvrdReg -to $port9_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port9_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port9_TNM_lRxPolarityReg -to $port9_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port9_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port9_TNM_lTxPolarityReg -to $port9_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port9_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port9_TNM_PulseSync_iDlySigx -to $port9_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port9_TNM_PulseSync_oSigx    -to $port9_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port9_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port9_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[9].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port9_TNM_HandShake_iStoredData        -to $port9_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port9_TNM_HandShake_iPushToggle        -to $port9_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port9_TNM_HandShake_oPushToggleToReady -to $port9_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 10 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port10_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port10_txusrclk2"] -to $port10_TNM_TxResetDone_out -datapath_only 10.0

set port10_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port10_rxusrclk2"] -to $port10_TNM_RxResetDone_out -datapath_only 10.0

set port10_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port10_rxusrclk2"] -to $port10_TNM_RxPrbsLocked_out -datapath_only 10.0

set port10_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port10_TNM_lRxLpmEn -to $port10_TNM_rRxLpmEn -datapath_only 10.0

set port10_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port10_TNM_lRxHoldReg -to $port10_TNM_rRxHoldReg_ms -datapath_only 10.0

set port10_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port10_TNM_lRxOvrdReg -to $port10_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port10_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port10_TNM_lRxPolarityReg -to $port10_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port10_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port10_TNM_lTxPolarityReg -to $port10_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port10_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port10_TNM_PulseSync_iDlySigx -to $port10_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port10_TNM_PulseSync_oSigx    -to $port10_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port10_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port10_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[10].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port10_TNM_HandShake_iStoredData        -to $port10_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port10_TNM_HandShake_iPushToggle        -to $port10_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port10_TNM_HandShake_oPushToggleToReady -to $port10_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 11 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port11_TNM_TxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port11_txusrclk2"] -to $port11_TNM_TxResetDone_out -datapath_only 10.0

set port11_TNM_RxResetDone_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port11_rxusrclk2"] -to $port11_TNM_RxResetDone_out -datapath_only 10.0

set port11_TNM_RxPrbsLocked_out [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPrbsLocked_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port11_rxusrclk2"] -to $port11_TNM_RxPrbsLocked_out -datapath_only 10.0

set port11_TNM_lRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_rRxLpmEn [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port11_TNM_lRxLpmEn -to $port11_TNM_rRxLpmEn -datapath_only 10.0

set port11_TNM_lRxHoldReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_rRxHoldReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port11_TNM_lRxHoldReg -to $port11_TNM_rRxHoldReg_ms -datapath_only 10.0

set port11_TNM_lRxOvrdReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_rRxOvrdReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port11_TNM_lRxOvrdReg -to $port11_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port11_TNM_lRxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_rRxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port11_TNM_lRxPolarityReg -to $port11_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port11_TNM_lTxPolarityReg    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_tTxPolarityReg_ms [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port11_TNM_lTxPolarityReg -to $port11_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port11_TNM_PulseSync_iDlySigx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_PulseSync_oSig_msx  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_PulseSync_oSigx     [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_PulseSync_AoSig_msx [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port11_TNM_PulseSync_iDlySigx -to $port11_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port11_TNM_PulseSync_oSigx    -to $port11_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port11_TNM_HandShake_iStoredData        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_HandShake_oDataFlop          [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_HandShake_iPushToggle        [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_HandShake_oPushToggle0_ms    [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_HandShake_oPushToggleToReady [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port11_TNM_HandShake_iRdyPushToggle_ms  [get_cells {UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz/AuroraBlock.GenAurora[11].AXI4Lite_GTYE4_Control_Regs4_inst/AXI4Lite_GTYE4_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port11_TNM_HandShake_iStoredData        -to $port11_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port11_TNM_HandShake_iPushToggle        -to $port11_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port11_TNM_HandShake_oPushToggleToReady -to $port11_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0




################################################################################



## Start add from file TimingPxiTrigs.xdc
# This constraints file assumes that there's a Routing CLIP, and that said routing CLIP creates amongst its constraints two variables:

# TriggerClipSyncPulseSrc
# TriggerClipSyncPulseDest

# The two variables identify the source/destination of FFs that we need to constrain wrt
# the PXI Trigger bus. Therefore, this constraints file needs to go after LVFPGA so that
# the variables will exist.

######### Board parameters.

set SignalPropMin 0.15
set SignalPropMax 0.8

set PxiClk100BufPropMin 0.15
set PxiClk100BufPropMax 0.22

# Triggers go through a translation buffer (https://agiledatasheets.natinst.com/TI/SN74LVC1T45.pdf)
# Tranlation buffer VCCA=1.8V, VCCB=3.3V, FpgaToBp = A -> B, BpToFpga = B -> A
set TrigTransBufFpgaToBpPropMax 8.3
set TrigTransBufFpgaToBpPropMin 1.7

set TrigTransBufBpToFpgaPropMax 15.5
set TrigTransBufBpToFpgaPropMin 2.0

# The external clock goes through a buffer and some propagation delays.
set Clk100DlyMax [expr $PxiClk100BufPropMax + $SignalPropMax]
set Clk100DlyMin [expr $PxiClk100BufPropMin + $SignalPropMin]

########## Port Definitions

set PxiTrigs [get_ports aPxiTrigData*]
set PxiStar  [get_ports aPxiStarData]
set Clk100   [get_clocks PxieClk100]

########## FPGA to Backplane

set Clk10TcoMax 20
set Clk10TcoMin  2

# We need to set a multicycle path from the SyncPulse, through the PxiTrig Ports, to
# Clk100 on the outside.

# Remember that a setup multicycle path of '1' is the default, and means that the data is
# latched on the edge following the launch edge. Increasing that multicycle path pushes
# the launch earlier in time relative to the latch edge. So if 1 means "latch on the next clock cycle", we need a value of 10 for "match on the clock cycle that is 10 from now".

set_multicycle_path -setup 10 -from [get_cells $TriggerClipSyncPulseSrc] \
-to [get_ports $PxiTrigs]

set_multicycle_path -hold 9 -from [get_cells $TriggerClipSyncPulseSrc] \
-to [get_ports $PxiTrigs]

# The data is externally slowed down by the 5V tolerant buffer, the translation buffer,
# and by its own propagation delay through the board.
set DataDlyMax [expr $TrigTransBufFpgaToBpPropMax + $SignalPropMax]
set DataDlyMin [expr $TrigTransBufFpgaToBpPropMin + $SignalPropMin]

# For the Max output delay, all our timing budget is in the TcoMax. So our Max delay
# starts with 100 ns (Clk10 period) - TcoMax. From there, we need to add everything that
# hurts us, and subtract everything that helps us. In this case, both the data and clock
# delays hurt us, because delaying either creates a longer TCO in relation with the "true"
# backplane Clk10.
set_output_delay -clock $Clk100 -max [expr (100 - $Clk10TcoMax) + $Clk100DlyMax + $DataDlyMax] \
[get_ports $PxiTrigs]

# Since hold is relative to the current clock edge, TcoMin is subtracted from 0.
set_output_delay -clock $Clk100 -min [expr (0 - $Clk10TcoMin) + $Clk100DlyMin + $DataDlyMin] \
[get_ports $PxiTrigs]

########## Backplane to FPGA

# We need to set a multicycle path from the external Clk100, through the trigger ports,
# into the TriggerClipSyncPulseDest FF.

set_multicycle_path -setup 10 -from [get_ports $PxiTrigs] \
-to [get_cells $TriggerClipSyncPulseDest]

set_multicycle_path -hold 9 -from [get_ports $PxiTrigs] \
-to [get_cells $TriggerClipSyncPulseDest]

# PXI Star needs its own, identical path.
set_multicycle_path -setup 10 -from [get_ports $PxiStar] \
-to [get_cells $TriggerClipSyncPulseDest]

set_multicycle_path -hold 9 -from [get_ports $PxiStar] \
-to [get_cells $TriggerClipSyncPulseDest]

# For input, we have a tsu and th to meet.
set Clk10Tsu 23
set Clk10Th  2

# The data is externally slowed down by the 5V tolerant buffer, the translation buffer,
# and by its own propagation delay through the board.
set DataDlyMax [expr $TrigTransBufBpToFpgaPropMax + $SignalPropMax]
set DataDlyMin [expr $TrigTransBufBpToFpgaPropMin + $SignalPropMin]

# Just like in the output version, Clk10Tsu is the extent of our timing budget. So our Max
# delay starts with 100 ns (Clk10 period) - Tsu., the rest of our helpful stuff will
# reduce from that delay, the rest of our hurtful stuff will add to the delay.

# In input delay calculations, the clock's delay works in our favor, so we subtract the
# minimum for max delay, and subtract the maximum for min delay.
set_input_delay -clock $Clk100 \
-max [expr (100 - $Clk10Tsu) + $DataDlyMax - $Clk100DlyMin] \
[get_ports $PxiTrigs]

# For Th, Th is the minimum guaranteed hold that we get from the trigger sender. So in
# this case it works in our favor.
set_input_delay -clock $Clk100 \
-min [expr $Clk10Th + $DataDlyMin - $Clk100DlyMax] \
[get_ports $PxiTrigs]

########## Backplane to FPGA - Star Trig

# The Star trigger goes through a different buffer (https://agiledatasheets.natinst.com/TI/SN74LVC2G34.pdf),
# so we need timing specifically for it.
set TrigStarBpToFpgaPropMax 8.6
set TrigStarBpToFpgaPropMin 3.2

# Other than the buffer prop delay, everything else is the same.
set DataDlyMax [expr $TrigStarBpToFpgaPropMax + $SignalPropMax]
set DataDlyMin [expr $TrigStarBpToFpgaPropMin + $SignalPropMin]

set_input_delay -clock $Clk100 \
-max [expr (100 - $Clk10Tsu) + $DataDlyMax - $Clk100DlyMin] \
[get_ports $PxiStar]

set_input_delay -clock $Clk100 \
-min [expr $Clk10Th + $DataDlyMin - $Clk100DlyMax] \
[get_ports $PxiStar]


########### Direction control

# The tristate control for the Pxi Triggers comes directly from a BaRegPort, and we don't
# want timing analyzed there. So we'll false-path through the output Tristate pin on the
# iobuffers.
set pxibuffers [get_cells SasquatchIoBuffersx/GenTriggers[*].PxiTrigBuf]
set pxibuffersTpins [get_pins -of $pxibuffers -filter {REF_PIN_NAME == T}]
set_false_path -through $pxibuffersTpins






