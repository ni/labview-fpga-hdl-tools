# LOC for Board Control Microblaze Debug Core
set MicroBlazeBScan [get_cells UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst/SasquatchClipFixedLogicx/FamConfigMicroblazex/FamConfigMicroblazeBdx/mdm_0/U0/Use_E2.BSCAN_I/Use_E2.BSCANE2_I]
set_property LOC CONFIG_SITE_X0Y0 [get_cells $MicroBlazeBScan]
set_property BEL BSCAN2           [get_cells $MicroBlazeBScan]
