# This script will:
# 1) create a HDL wrapper for your block design
# 2) generate output products and launch synthesis (such as sim files)
# 3) add simulation files
# 4) launch simulation

# Create HDL wrapper
startgroup
set dir [get_property DIRECTORY [current_project]]
set name [get_property NAME [current_project]]
set bdFile [get_files ${dir}/${name}.srcs/sources_1/bd/*.bd]
make_wrapper -files [get_files $bdFile] -top
add_files -norecurse [get_files ${dir}/${name}.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v]
endgroup

# Generate output products and launch synthesis
export_ip_user_files -of_objects [get_ips design_1_BlackParrot_0_0] -no_script -sync -force -quiet
generate_target all [get_files $bdFile]
export_simulation -of_objects [get_files ${dir}/project_4.srcs/sources_1/bd/design_1/design_1.bd] -directory ${dir}/project_4.ip_user_files/sim_scripts -ip_user_files_dir ${dir}/project_4.ip_user_files -ipstatic_source_dir ${dir}/project_4.ip_user_files/ipstatic -lib_map_path [list {modelsim=${dir}/project_4.cache/compile_simlib/modelsim} {questa=${dir}/project_4.cache/compile_simlib/questa} {ies=${dir}/project_4.cache/compile_simlib/ies} {xcelium=${dir}/project_4.cache/compile_simlib/xcelium} {vcs=${vcs_lib_path}} {riviera=${dir}/project_4.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
report_ip_status -name ip_status
launch_runs -jobs 72 design_1_synth_1

# Add simulation files
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse [join “
  $bp_ip_path/tb/axi_lite_to_bp_lite_client.sv
  $bp_ip_path/tb/bp_be_pkg.sv
  $bp_ip_path/tb/bp_common_aviary_defines.svh
  $bp_ip_path/tb/bp_common_aviary_pkg.sv
  $bp_ip_path/tb/bp_common_bedrock_if.svh
  $bp_ip_path/tb/bp_common_cache_engine_if.svh
  $bp_ip_path/tb/bp_common_core_if.svh
  $bp_ip_path/tb/bp_common_csr_defines.svh
  $bp_ip_path/tb/bp_common_defines.svh
  $bp_ip_path/tb/bp_common_pkg.sv
  $bp_ip_path/tb/bp_common_rv64_defines.svh
  $bp_ip_path/tb/bp_lite_to_axi_lite_master.sv
  $bp_ip_path/tb/bp_me_pkg.sv
  $bp_ip_path/tb/bp_nonsynth_host.sv
  $bp_ip_path/tb/bp_nonsynth_if_verif.sv
  $bp_ip_path/tb/bp_nonsynth_nbf_loader.sv
  $bp_ip_path/tb/bp_nonsynth_tb_top.sv
  $bp_ip_path/tb/bp_nonsynth_tb_top_wrapper.v
  $bp_ip_path/tb/bsg_buf.sv
  $bp_ip_path/tb/bsg_bus_pack.sv
  $bp_ip_path/tb/bsg_circular_ptr.sv
  $bp_ip_path/tb/bsg_clkgate_optional.sv
  $bp_ip_path/tb/bsg_counter_up_down.sv
  $bp_ip_path/tb/bsg_decode.sv
  $bp_ip_path/tb/bsg_decode_with_v.sv
  $bp_ip_path/tb/bsg_defines.v
  $bp_ip_path/tb/bsg_dff_en.sv
  $bp_ip_path/tb/bsg_dff_reset_en.sv
  $bp_ip_path/tb/bsg_dff_reset.sv
  $bp_ip_path/tb/bsg_dff.sv
  $bp_ip_path/tb/bsg_dlatch.sv
  $bp_ip_path/tb/bsg_fifo_1r1w_small_hardened.sv
  $bp_ip_path/tb/bsg_fifo_1r1w_small.sv
  $bp_ip_path/tb/bsg_fifo_1r1w_small_unhardened.sv
  $bp_ip_path/tb/bsg_fifo_tracker.sv
  $bp_ip_path/tb/bsg_flow_counter.sv
  $bp_ip_path/tb/bsg_mem_1r1w.sv
  $bp_ip_path/tb/bsg_mem_1r1w_sync.sv
  $bp_ip_path/tb/bsg_mem_1r1w_sync_synth.sv
  $bp_ip_path/tb/bsg_mem_1r1w_synth.sv
  $bp_ip_path/tb/bsg_muxi2_gatestack.sv
  $bp_ip_path/tb/bsg_mux.sv
  $bp_ip_path/tb/bsg_nand.sv
  $bp_ip_path/tb/bsg_noc_links.vh
  $bp_ip_path/tb/bsg_noc_pkg.v
  $bp_ip_path/tb/bsg_nonsynth_test_rom.sv
  $bp_ip_path/tb/bsg_nor3.sv
  $bp_ip_path/tb/bsg_reduce.sv
  $bp_ip_path/tb/bsg_rotate_right.sv
  $bp_ip_path/tb/bsg_strobe.sv
  $bp_ip_path/tb/bsg_two_fifo.sv
  $bp_ip_path/tb/bsg_xnor.sv
  $bp_ip_path/tb/ddr3_model_parameters.vh
  $bp_ip_path/tb/ddr3_model.sv
  $bp_ip_path/tb/sim_tb_top.v
  $bp_ip_path/tb/wiredly.v
  $bp_ip_path/tb/bootrom.mem
  $bp_ip_path/tb/mem_init.txt
  $bp_ip_path/tb/prog.nbf
“]
set_property file_type SystemVerilog [get_files  $bp_ip_path/tb/bsg_noc_pkg.v]
set_property file_type SystemVerilog [get_files  $bp_ip_path/tb/sim_tb_top.v]
set_property file_type {Verilog Header} [get_files  $bp_ip_path/tb/bsg_defines.v]
update_compile_order -fileset sim_1

# Launch simulation
launch_simulation -install_path $vcs_bin_path 
