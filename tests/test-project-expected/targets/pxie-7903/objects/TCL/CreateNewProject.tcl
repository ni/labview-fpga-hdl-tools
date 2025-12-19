# githubvisible=true

set ProjName {MySasquatchProj}
create_project -force $ProjName [pwd] -part xcvu11p-flgb2104-2-e
set_property target_language VHDL [current_project]

add_files {..\..\..\deps\flexrio-aurora-clip\aurora64b66b_framing_crcx4_28p0GHz\Source\vhdl\AXI4_Lite_to_DRP.vhd}
add_files {..\..\..\deps\flexrio-aurora-clip\aurora64b66b_framing_crcx4_28p0GHz\Source\vhdl\AxiLiteToMgtDrp.vhd}
add_files {..\..\..\deps\flexrio-aurora-clip\aurora64b66b_framing_crcx4_28p0GHz\Source\vhdl\MgtTest_DRP_bridge.vhd}
add_files {..\..\..\deps\flexrio-aurora-clip\aurora64b66b_framing_crcx4_28p0GHz\Source\vhdl\PXIe659XR_AXI4_Lite_Address_Map.vhd}
add_files {..\..\..\deps\flexrio-aurora-clip\aurora64b66b_framing_crcx4_28p0GHz\Source\vhdl\PkgAXI4Lite_GTYE4_Control.vhd}
add_files {..\..\..\deps\flexrio-aurora-clip\aurora64b66b_framing_crcx4_28p0GHz\Source\vhdl\UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz.vhd}
add_files {..\..\..\deps\flexrio-aurora-clip\aurora64b66b_framing_crcx4_28p0GHz\Target\AXI4Lite_GTYE4_Control_Regs4.edf}
add_files {..\..\..\deps\flexrio-aurora-clip\aurora64b66b_framing_crcx4_28p0GHz\Target\AxiFramingRegx4.edf}
add_files {..\..\..\deps\flexrio-aurora-clip\aurora64b66b_framing_crcx4_28p0GHz\Target\AxiLiteClockConverterWrapper.edf}
add_files {..\..\..\deps\flexrio-aurora-clip\aurora64b66b_framing_crcx4_28p0GHz\Target\SasquatchClipFixedLogic.dcp}
add_files {..\..\..\deps\flexrio-aurora-clip\aurora64b66b_framing_crcx4_28p0GHz\Target\aurora64b66b_framing_crcx4_28p0GHz.dcp}
add_files {..\..\..\deps\flexrio-deps\flexrio-deps\DFlop.vhd}
add_files {..\..\..\deps\flexrio-deps\flexrio-deps\DFlopBoolVec.vhd}
add_files {..\..\..\deps\flexrio-deps\flexrio-deps\DFlopSLV.vhd}
add_files {..\..\..\deps\flexrio-deps\flexrio-deps\DFlopUnsigned.vhd}
add_files {..\..\..\deps\flexrio-deps\flexrio-deps\DoubleSyncAsyncInBase.vhd}
add_files {..\..\..\deps\flexrio-deps\flexrio-deps\DoubleSyncBase.vhd}
add_files {..\..\..\deps\flexrio-deps\flexrio-deps\DoubleSyncBool.vhd}
add_files {..\..\..\deps\flexrio-deps\flexrio-deps\DoubleSyncSL.vhd}
add_files {..\..\..\deps\flexrio-deps\flexrio-deps\DualPortRAM.vhd}
add_files {..\..\..\deps\flexrio-deps\flexrio-deps\DualPortRAM_Vivado.vhd}
add_files {..\..\..\deps\flexrio-deps\flexrio-deps\GenDataValid.vhd}
add_files {..\..\..\deps\flexrio-deps\flexrio-deps\SingleClkFifo.vhd}
add_files {..\..\..\deps\flexrio-deps\flexrio-deps\SingleClkFifoFlags.vhd}
add_files {..\..\common\rtl-lvfpga\G3UspGtyHostInterface.vhd}
add_files {..\..\common\rtl-lvfpga\IoRefClkSelect.vhd}
add_files {..\..\common\rtl-lvfpga\SasquatchIoBuffers.vhd}
add_files {..\..\common\rtl-lvfpga\SasquatchIoBuffersStage1.vhd}
add_files {..\..\common\rtl-lvfpga\lvgen\PkgCommIntConfiguration.vhd}
add_files {..\..\common\rtl-lvfpga\lvgen\PkgDmaPortCommIfcRegs.vhd}
add_files {..\..\common\rtl-lvfpga\packages\PkgSasquatch.vhd}
add_files {..\objects\rtl-lvfpga\lvgen\TheWindow.vhd}
add_files {..\rtl-lvfpga\PkgFlexRioTargetConfig.vhd}
add_files {..\rtl-lvfpga\SasquatchTopTemplate.vhd}
add_files {..\xdc\constraints_place.xdc}
add_files {..\objects\xdc\constraints.xdc}

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

set_property steps.synth_design.args.flatten_hierarchy "full" [get_runs -filter is_synthesis]
set_property steps.synth_design.args.keep_equivalent_registers "true" [get_runs -filter is_synthesis]
set_property steps.synth_design.tcl.pre {$PPRDIR/../TCL/PreSynthesize.tcl} [get_runs -filter is_synthesis]
set_property steps.opt_design.args.directive "Explore" [get_runs -filter !is_synthesis]
set_property steps.opt_design.args.is_enabled "true" [get_runs -filter !is_synthesis]
set_property steps.place_design.args.directive "Explore" [get_runs -filter !is_synthesis]
set_property steps.phys_opt_design.args.directive "Explore" [get_runs -filter !is_synthesis]
set_property steps.phys_opt_design.args.is_enabled "true" [get_runs -filter !is_synthesis]
set_property steps.route_design.args.directive "Explore" [get_runs -filter !is_synthesis]
set_property steps.write_bitstream.args.bin_file "true" [get_runs -filter !is_synthesis]
set_property steps.write_bitstream.tcl.pre {$PPRDIR/../TCL/PreGenerateBitfile.tcl} [get_runs -filter !is_synthesis]
set_property steps.post_route_phys_opt_design.args.is_enabled "false" [get_runs -filter !is_synthesis]
set_property steps.write_bitstream.tcl.post {$PPRDIR/../TCL/PostGenerateBitfile.tcl} [get_runs -filter !is_synthesis]
set_property top SasquatchTopTemplate [current_fileset]

# constraints.xdc is for use for both synthesis and implementation
set_property used_in_synthesis true [get_files constraints.xdc]
set_property used_in_implementation true [get_files constraints.xdc]

# constraints_place.xdc is for use in implementation only
set_property used_in_synthesis false [get_files constraints_place.xdc]
set_property used_in_implementation true [get_files constraints_place.xdc]

exit