# githubvisible=true

open_project ${project_file_name}

reset_run synth_1
launch_runs synth_1 -jobs 11
wait_on_run synth_1

launch_runs impl_1 -to_step write_bitstream -jobs 11
wait_on_run impl_1

puts "NIHDL_COMPILE_PROJECT=PASSED"

close_project
