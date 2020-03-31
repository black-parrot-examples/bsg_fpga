
# open project
open_project vu37p_test/vu37p_test.xpr

# auto update compile order
update_compile_order -fileset sources_1

# run implementation
reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1

reset_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
