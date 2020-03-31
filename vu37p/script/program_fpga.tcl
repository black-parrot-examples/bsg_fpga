
# open hardware manager
open_hw

# connect to local hardware server
connect_hw_server

# open hardware target with Xilinx virtual cable (xvc)
# in case open target is unsuccessful, close target and open again 
open_hw_target -quiet -xvc_url [lindex $argv 0]
after 1000
close_hw_target
after 1000
open_hw_target -xvc_url [lindex $argv 0]

# set programming file
set_property PROGRAM.FILE ./vu37p_test/vu37p_test.runs/impl_1/design_1_wrapper.bit [get_hw_devices xcvu37p_0]

# program FPGA
puts "Estimated programming time: 2.5 minutes"
program_hw_devices -verbose [get_hw_devices xcvu37p_0]

# exit
close_hw_target
