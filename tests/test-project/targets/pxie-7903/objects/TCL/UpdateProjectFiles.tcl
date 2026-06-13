# githubvisible=true

remove_files [get_files]

add_files {..\..\..\deps\flexrio-deps\flexrio-deps-usp\DFlop.vhd}
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
