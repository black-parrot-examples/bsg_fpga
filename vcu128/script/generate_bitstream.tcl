set script_jobs 8

if { $::argc > 0 } {
  set script_jobs [lindex $argv 0]
}

puts "Running synthesis and implementation with $script_jobs jobs"

# open project
open_project vcu128_bp/vcu128_bp.xpr

# auto update compile order
update_compile_order -fileset sources_1

# run implementation
reset_run synth_1
launch_runs synth_1 -jobs $script_jobs
wait_on_run synth_1

reset_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs $script_jobs
wait_on_run impl_1
