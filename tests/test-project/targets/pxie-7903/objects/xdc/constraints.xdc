
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
# Command Used: write_xdc -force -exclude_physical /home/rfmibuild/myagent/_work/685/s/hw-flexrio/fixedlogic/objects/tool/synth_sasquatchfixedlogic/output/MacallanFixedLogic.xdc
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


#########################################################################################
# Outside LV Window DMA Port Crossings
#
# These constraints are provided by LV FPGA code generation along with TheWindow clock crossing
# constraints.  However, these actually apply to paths that are outside TheWindow.  We have
# moved TheWindow into a component and require set_instance to make the constraint paths work.
# So we must move these constriants outside the group of TheWindow constraints so that they are
# outside TheWindow set_instance group.

set DmaPortCommCrossingFrom [get_cells {HostInterfacex/*/*DmaPortCommIfcIrqInterfacex/DoubleSyncSLx*iDlySigx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]
set DmaPortCommCrossingTo [get_cells {HostInterfacex/*/*DmaPortCommIfcIrqInterfacex/DoubleSyncSLx*DoubleSyncAsyncInBasex/oSig_msx/*FDCPEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $DmaPortCommCrossingFrom -to $DmaPortCommCrossingTo -datapath_only 100.0000000000
#########################################################################################


#########################################################################################
# Dram2DP Crossings
#
# These constraints are normally provided by LV FPGA that places Dram2DP.xdc in the generated files
# folder.  However, Sasquatch needs to customize these constraints so must add them here.  The old
# constraints provided by LV FPGA and Dram2DP.xdc will be ignored by Vivado.
#

set_false_path -from [get_pins -hierarchical {*bNumOfMemBuffers*/C}] \
-to   [all_registers -edge_triggered]

set_false_path -from [get_pins -hierarchical {*bLowLatencyBuffer*/C}] \
-to   [all_registers -edge_triggered]

set_false_path -from [get_pins -hierarchical {*bBaseAddrTable*/C}] \
-to   [all_registers -edge_triggered]

set_false_path -from [get_pins -hierarchical {*bBaggageBits*/C}] \
-to   [all_registers -edge_triggered]

set_false_path -from [get_pins -hierarchical {*Dram2DP*ClearFDCP*/C}] \
-to   [all_registers -edge_triggered]
#########################################################################################

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


## Start add from file LvFpgaSasquatch.xdc
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

# BEGIN_LV_FPGA_PERIOD_CONSTRAINTS



# END_LV_FPGA_PERIOD_CONSTRAINTS

# BEGIN_LV_FPGA_CLIP_CONSTRAINTS



# END_LV_FPGA_CLIP_CONSTRAINTS

set TopInstance0 [current_instance .]
current_instance SasquatchWindowWrapper

# BEGIN_LV_FPGA_FROM_TO_CONSTRAINTS



# END_LV_FPGA_FROM_TO_CONSTRAINTS

current_instance -quiet
current_instance $TopInstance0


# END_LV_FPGA_CONSTRAINTS
################################################################################


## Start add from file GitHubSasquatch.xdc
##############################################################
# Insert custom constraints here for GitHub customized targets
##############################################################

# This section pulls in constraints that are specified in the CustomConstraintsFile setting in projectsettings.ini
#
# BEGIN_GITHUB_CUSTOM_CONSTRAINTS
#

#
# END_GITHUB_CUSTOM_CONSTRAINTS

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



