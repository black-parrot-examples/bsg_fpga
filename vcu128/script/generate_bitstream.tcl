#
# generate_bitstream.tcl
#
# Description:
#   Run synthesis and implementation
#

set script_file "generate_bitsream.tcl"

# arguments
set jobs 8
set project_name "vcu128_bp"

# Help information for this script
proc print_help {} {
  variable script_file
  puts "\nDescription:"
  puts "Run synthesis and implementation.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--jobs <n>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--jobs <n>\] Number of jobs to run synthesis and implementation with.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--jobs"         { incr i; set jobs [lindex $::argv $i] }
      "--project_name" { incr i; set project_name [lindex $::argv $i] }
      "--help"         { print_help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

puts "Running synthesis and implementation with $jobs jobs"

# open project
open_project $project_name/$project_name.xpr

# auto update compile order
update_compile_order -fileset sources_1

# run implementation
reset_run synth_1
launch_runs synth_1 -jobs $jobs
wait_on_run synth_1

reset_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs $jobs
wait_on_run impl_1
