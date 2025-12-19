#LabVIEWFPGA_Macro macro_ClipConstraints

set_false_path -from [get_pins {*bNumOfMemBuffers*/C -hierarchical}] \
               -to   [all_registers -edge_triggered]

set_false_path -from [get_pins {*bLowLatencyBuffer*/C -hierarchical}] \
               -to   [all_registers -edge_triggered]

set_false_path -from [get_pins {*bBaseAddrTable*/C -hierarchical}] \
               -to   [all_registers -edge_triggered]

set_false_path -from [get_pins {*bBaggageBits*/C -hierarchical}] \
               -to   [all_registers -edge_triggered]

set_false_path -from [get_pins {*Dram2DP*ClearFDCP*/C -hierarchical}] \
               -to   [all_registers -edge_triggered]
