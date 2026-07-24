
###################################################################################
##
## 
##
###################################################################################

#LabVIEWFPGA_Macro macro_ClipConstraints_Place

## Start add from file TandemBscan.xdc
## -----------------------------------------------
## BSCAN components
## -----------------------------------------------

# LOC for Board Control Microblaze Debug Core
set MicroBlazeBScan [get_cells FixedLogicWrapperx/MacallanFixedLogicx/BoardControlx/BoardControlMicroblaze_i/BoardControlMicroblazeBdx/mdm_0/U0/Use_E2.BSCAN_I/Use_E2.BSCANE2_I]
set_property LOC CONFIG_SITE_X0Y0 [get_cells $MicroBlazeBScan]
set_property BEL BSCAN2           [get_cells $MicroBlazeBScan]

# LOC for MIG Bank 0 and 1 Debug Cores
set DramBScans [get_cells dbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_inst/SERIES7_BSCAN.bscan_inst]
set_property LOC CONFIG_SITE_X0Y0 [get_cells $DramBScans]
set_property BEL BSCAN1 [get_cells $DramBScans]

# Add BSCAN blocks to PBlock, and set Tandem property. This should be a catch-all.
set_property HD.TANDEM 1 [get_cells -of_objects [get_bels CONFIG_SITE_X0Y0/BSCAN*]]
add_cells_to_pblock $pciePblock [get_cells -of_objects [get_bels CONFIG_SITE_X0Y0/BSCAN*]]



