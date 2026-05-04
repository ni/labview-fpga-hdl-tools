# githubvisible=true

open_project ${project_file_name}

source ${pre_synth_tcl_path}

set_property top ${top_entity_name} [current_fileset]

synth_design -rtl -top ${top_entity_name} -part ${fpga_part_name}

puts "NIHDL_CHECK_SYNTAX=PASSED"

close_project
