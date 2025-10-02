# githubvisible=true

set ProjName {PROJ_NAME}
create_project -force $ProjName [pwd] -part xcvu11p-flgb2104-2-e
set_property target_language VHDL [current_project]

ADD_FILES

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
set_property top TOP_ENTITY [current_fileset]

# constraints.xdc is for use for both synthesis and implementation
set_property used_in_synthesis true [get_files constraints.xdc]
set_property used_in_implementation true [get_files constraints.xdc]

# constraints_place.xdc is for use in implementation only
set_property used_in_synthesis false [get_files constraints_place.xdc]
set_property used_in_implementation true [get_files constraints_place.xdc]

exit