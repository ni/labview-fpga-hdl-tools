# githubvisible=true

remove_files [get_files]

add_files {..\objects\gathereddeps\DoubleSyncAsyncInBase.vhd}
add_files {..\objects\gathereddeps\DoubleSyncBase.vhd}
add_files {..\objects\gathereddeps\DoubleSyncBool.vhd}
add_files {..\objects\gathereddeps\DoubleSyncSL.vhd}
add_files {..\objects\gathereddeps\DFlopBoolVec.vhd}
add_files {..\objects\gathereddeps\DFlopSLV.vhd}
add_files {..\objects\gathereddeps\DFlopUnsigned.vhd}
add_files {..\objects\gathereddeps\DFlop.vhd}
add_files {..\objects\gathereddeps\GenDataValid.vhd}
add_files {..\objects\gathereddeps\SingleClkFifo.vhd}
add_files {..\objects\gathereddeps\SingleClkFifoFlags.vhd}
add_files {..\objects\gathereddeps\DualPortRAM.vhd}
add_files {..\objects\gathereddeps\DualPortRAM_Vivado.vhd}
add_files {..\objects\gathereddeps\AXI4_Lite_to_DRP.vhd}
add_files {..\objects\gathereddeps\AxiLiteToMgtDrp.vhd}
add_files {..\objects\gathereddeps\MgtTest_DRP_bridge.vhd}
add_files {..\objects\gathereddeps\PXIe659XR_AXI4_Lite_Address_Map.vhd}
add_files {..\objects\gathereddeps\PkgAXI4Lite_GTYE4_Control.vhd}
add_files {..\objects\gathereddeps\UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz.vhd}
add_files {..\objects\gathereddeps\AXI4Lite_GTYE4_Control_Regs4.edf}
add_files {..\objects\gathereddeps\AxiFramingRegx4.edf}
add_files {..\objects\gathereddeps\AxiLiteClockConverterWrapper.edf}
add_files {..\objects\gathereddeps\SasquatchClipFixedLogic.dcp}
add_files {..\objects\gathereddeps\aurora64b66b_framing_crcx4_28p0GHz.dcp}
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

# constraints.xdc is for use for both synthesis and implementation
set_property used_in_synthesis true [get_files constraints.xdc]
set_property used_in_implementation true [get_files constraints.xdc]

# constraints_place.xdc is for use in implementation only
set_property used_in_synthesis false [get_files constraints_place.xdc]
set_property used_in_implementation true [get_files constraints_place.xdc]

exit