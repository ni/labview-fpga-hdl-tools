# githubvisible=true

remove_files [get_files]

add_files {..\..\..\dependencies\githubdeps\fpgaDigitalDesigns.25.1.0f405\source\rvi\Vivado\HDL\CommonFiles\NiCores\ClockCrossing\DoubleSync\DoubleSyncAsyncInBase.vhd}
add_files {..\..\..\dependencies\githubdeps\fpgaDigitalDesigns.25.1.0f405\source\rvi\Vivado\HDL\CommonFiles\NiCores\ClockCrossing\DoubleSync\DoubleSyncBase.vhd}
add_files {..\..\..\dependencies\githubdeps\fpgaDigitalDesigns.25.1.0f405\source\rvi\Vivado\HDL\CommonFiles\NiCores\ClockCrossing\DoubleSync\DoubleSyncBool.vhd}
add_files {..\..\..\dependencies\githubdeps\fpgaDigitalDesigns.25.1.0f405\source\rvi\Vivado\HDL\CommonFiles\NiCores\ClockCrossing\DoubleSync\DoubleSyncSL.vhd}
add_files {..\..\..\dependencies\githubdeps\fpgaDigitalDesigns.25.1.0f405\source\rvi\Vivado\HDL\CommonFiles\NiCores\DFlop\DFlopBoolVec.vhd}
add_files {..\..\..\dependencies\githubdeps\fpgaDigitalDesigns.25.1.0f405\source\rvi\Vivado\HDL\CommonFiles\NiCores\DFlop\DFlopSLV.vhd}
add_files {..\..\..\dependencies\githubdeps\fpgaDigitalDesigns.25.1.0f405\source\rvi\Vivado\HDL\CommonFiles\NiCores\DFlop\DFlopUnsigned.vhd}
add_files {..\..\..\dependencies\githubdeps\fpgaDigitalDesigns.25.1.0f405\source\rvi\Vivado\HDL\CommonFiles\NiCores\DFlopBase\Xilinx\DFlop.vhd}
add_files {..\..\..\dependencies\githubdeps\fpgaDigitalDesigns.25.1.0f405\source\rvi\Vivado\HDL\CommonFiles\NiCores\FIFO\Common\GenDataValid.vhd}
add_files {..\..\..\dependencies\githubdeps\fpgaDigitalDesigns.25.1.0f405\source\rvi\Vivado\HDL\CommonFiles\NiCores\FIFO\SingleClock\SingleClkFifo.vhd}
add_files {..\..\..\dependencies\githubdeps\fpgaDigitalDesigns.25.1.0f405\source\rvi\Vivado\HDL\CommonFiles\NiCores\FIFO\SingleClock\SingleClkFifoFlags.vhd}
add_files {..\..\..\dependencies\githubdeps\fpgaDigitalDesigns.25.1.0f405\source\rvi\Vivado\HDL\CommonFiles\NiCores\Xilinx\RAM\DualPortRAM.vhd}
add_files {..\..\..\dependencies\githubdeps\fpgaDigitalDesigns.25.1.0f405\source\rvi\Vivado\HDL\CommonFiles\NiCores\Xilinx\RAM\DualPortRAM_Vivado.vhd}
add_files {..\objects\gatheredfiles\AXI4_Lite_to_DRP.vhd}
add_files {..\objects\gatheredfiles\AxiLiteToMgtDrp.vhd}
add_files {..\objects\gatheredfiles\MgtTest_DRP_bridge.vhd}
add_files {..\objects\gatheredfiles\PXIe659XR_AXI4_Lite_Address_Map.vhd}
add_files {..\objects\gatheredfiles\PkgAXI4Lite_GTYE4_Control.vhd}
add_files {..\objects\gatheredfiles\UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz.vhd}
add_files {..\objects\gatheredfiles\AXI4Lite_GTYE4_Control_Regs4.edf}
add_files {..\objects\gatheredfiles\AxiFramingRegx4.edf}
add_files {..\objects\gatheredfiles\AxiLiteClockConverterWrapper.edf}
add_files {..\objects\gatheredfiles\SasquatchClipFixedLogic.dcp}
add_files {..\objects\gatheredfiles\aurora64b66b_framing_crcx4_28p0GHz.dcp}
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