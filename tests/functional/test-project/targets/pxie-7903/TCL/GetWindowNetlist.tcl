# githubvisible=true

set_property top TheWindow [current_fileset]
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-mode out_of_context} -objects [get_runs synth_1]
set_msg_config -id {*INFO*} -suppress
set_msg_config -id {*WARNING*} -suppress
set_msg_config -string {Parameter} -suppress
set_msg_config -string {CRITICAL WARNING} -suppress
reset_run synth_1
launch_runs synth_1 -jobs 11
wait_on_run synth_1
open_run synth_1 -name synth_1
write_edif -security_mode all TheWindow -force