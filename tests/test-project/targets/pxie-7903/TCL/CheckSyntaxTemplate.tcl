# githubvisible=true

open_project PROJECT_FILE_NAME

source PRE_SYNTH_TCL_PATH

set_property top TOP_ENTITY_NAME [current_fileset]

synth_design -rtl -top TOP_ENTITY_NAME -part FPGA_PART_NAME

puts "NIHDL_CHECK_SYNTAX=PASSED"

close_project
