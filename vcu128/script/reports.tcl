#
# reports.tcl
#
# Description:
#   Generate post-implementation utilization and timing reports
#

set script_file "reports.tcl"

# arguments
set project_name "vcu128_bp"
set depth 12

# Help information for this script
proc print_help {} {
  variable script_file
  puts "\nDescription:"
  puts "Run synthesis and implementation.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--depth <n>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                          name is the name of the project from where this"
  puts "                          script was generated.\n"
  puts "\[--depth <n>\]           Hierarchical depth for reports.\n"
  puts "\[--help\]                Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--project_name" { incr i; set project_name [lindex $::argv $i] }
      "--depth"        { incr i; set depth [lindex $::argv $i] }
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

puts "Generating Utilization and Timing Reports for $project_name"

# open project
open_project $project_name/$project_name.xpr
open_run impl_1
report_utilization -file $project_name/reports/utilization.txt
report_utilization -file $project_name/reports/utilization_hierarchical.txt -hierarchical -hierarchical_depth $depth
# spreadsheet can only be generated from GUI mode
#report_utilization -name utilization_1 -spreadsheet_file $project_name/reports/utilization.xlsx -spreadsheet_table Hierarchy -spreadsheet_depth $depth

