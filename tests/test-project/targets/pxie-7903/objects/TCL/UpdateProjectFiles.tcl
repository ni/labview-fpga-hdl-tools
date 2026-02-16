# githubvisible=true

remove_files [get_files]

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
add_files {..\objects\GeneratedHDL\PkgTheWindowFlatWrapper.vhd}
add_files {..\objects\GeneratedHDL\TheWindow.vhd}
add_files {..\objects\GeneratedHDL\TheWindowFlatWrapper.vhd}
add_files {..\rtl-lvfpga\SasquatchTopTemplate.vhd}
add_files {..\xdc\constraints_place.xdc}
add_files {..\objects\xdc\constraints.xdc}

# constraints.xdc is for use for both synthesis and implementation
set_property used_in_synthesis true [get_files constraints.xdc]
set_property used_in_implementation true [get_files constraints.xdc]

# constraints_place.xdc is for use in implementation only
set_property used_in_synthesis false [get_files constraints_place.xdc]
set_property used_in_implementation true [get_files constraints_place.xdc]

exit