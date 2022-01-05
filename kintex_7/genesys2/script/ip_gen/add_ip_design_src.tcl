# Create project
set ip_proj_name <ip_proj_name_of_your_choice>
set ip_proj_path <path_to_your_ip_proj>
set bp_ip_path  <path_to_your_bp_ip_location>
create_project $ip_proj_name $ip_proj_path -part xc7k325tffg900-2
set_property board_part digilentinc.com:genesys2:part0:1.1 [current_project]

# Turn off automatic hierarchy updates and automatic compilation order update
# If adding all the source file causes Vivado to freeze, it is suggested that you use the 
# following command and perform manual hierarchy and compilation order update after 
# adding all of the design sources
# set_property source_mgmt_mode None [current_project]

# Add design sources
startgroup
add_files -norecurse [join "
  $bp_ip_path/src/axi_lite_to_bp_lite_client.sv
  $bp_ip_path/src/bp_be_bypass.sv
  $bp_ip_path/src/bp_be_calculator_top.sv
  $bp_ip_path/src/bp_be_csr.sv
  $bp_ip_path/src/bp_be_ctl_defines.svh
  $bp_ip_path/src/bp_be_dcache_decoder.sv
  $bp_ip_path/src/bp_be_dcache_pipeline.svh
  $bp_ip_path/src/bp_be_dcache_pkt.svh
  $bp_ip_path/src/bp_be_dcache.sv
  $bp_ip_path/src/bp_be_dcache_tag_info.svh
  $bp_ip_path/src/bp_be_dcache_wbuf_entry.svh
  $bp_ip_path/src/bp_be_dcache_wbuf_queue.sv
  $bp_ip_path/src/bp_be_dcache_wbuf.sv
  $bp_ip_path/src/bp_be_detector.sv
  $bp_ip_path/src/bp_be_director.sv
  $bp_ip_path/src/bp_be_fp_to_rec.sv
  $bp_ip_path/src/bp_be_instr_decoder.sv
  $bp_ip_path/src/bp_be_internal_if_defines.svh
  $bp_ip_path/src/bp_be_issue_queue.sv
  $bp_ip_path/src/bp_be_mem_defines.svh
  $bp_ip_path/src/bp_be_pipe_aux.sv
  $bp_ip_path/src/bp_be_pipe_ctl.sv
  $bp_ip_path/src/bp_be_pipe_fma.sv
  $bp_ip_path/src/bp_be_pipe_int.sv
  $bp_ip_path/src/bp_be_pipe_long.sv
  $bp_ip_path/src/bp_be_pipe_mem.sv
  $bp_ip_path/src/bp_be_pipe_sys.sv
  $bp_ip_path/src/bp_be_pkg.sv
  $bp_ip_path/src/bp_be_ptw.sv
  $bp_ip_path/src/bp_be_rec_to_fp.sv
  $bp_ip_path/src/bp_be_regfile.sv
  $bp_ip_path/src/bp_be_scheduler.sv
  $bp_ip_path/src/bp_be_top.sv
  $bp_ip_path/src/bp_burst_to_lite.sv
  $bp_ip_path/src/bp_cce_inst.svh
  $bp_ip_path/src/bp_cce_loopback.sv
  $bp_ip_path/src/bp_cfg.sv
  $bp_ip_path/src/bp_clint_slice.sv
  $bp_ip_path/src/bp_common_aviary_defines.svh
  $bp_ip_path/src/bp_common_aviary_pkg.sv
  $bp_ip_path/src/bp_common_bedrock_if.svh
  $bp_ip_path/src/bp_common_cache_engine_if.svh
  $bp_ip_path/src/bp_common_core_if.svh
  $bp_ip_path/src/bp_common_csr_defines.svh
  $bp_ip_path/src/bp_common_defines.svh
  $bp_ip_path/src/bp_common_pkg.sv
  $bp_ip_path/src/bp_common_rv64_defines.svh
  $bp_ip_path/src/bp_core_minimal.sv
  $bp_ip_path/src/bp_fe_bht.sv
  $bp_ip_path/src/bp_fe_btb.sv
  $bp_ip_path/src/bp_fe_defines.svh
  $bp_ip_path/src/bp_fe_icache.sv
  $bp_ip_path/src/bp_fe_icache.svh
  $bp_ip_path/src/bp_fe_instr_scan.sv
  $bp_ip_path/src/bp_fe_pc_gen.sv
  $bp_ip_path/src/bp_fe_pkg.sv
  $bp_ip_path/src/bp_fe_top.sv
  $bp_ip_path/src/bp_lite_to_axi_lite_master.sv
  $bp_ip_path/src/bp_lite_to_burst.sv
  $bp_ip_path/src/bp_logo.png
  $bp_ip_path/src/bp_me_cache_slice.sv
  $bp_ip_path/src/bp_me_cce_to_cache.sv
  $bp_ip_path/src/bp_me_cord_to_id.sv
  $bp_ip_path/src/bp_mem_to_axi_master.sv
  $bp_ip_path/src/bp_mem_wormhole.svh
  $bp_ip_path/src/bp_me_pkg.sv
  $bp_ip_path/src/bp_mmu.sv
  $bp_ip_path/src/bp_pma.sv
  $bp_ip_path/src/bp_tlb.sv
  $bp_ip_path/src/bp_uce.sv
  $bp_ip_path/src/bp_unicore_axi_wrapper_top_timing_ooc.xdc
  $bp_ip_path/src/bp_unicore_axi_wrapper_top_timing.xdc
  $bp_ip_path/src/bp_unicore.sv
  $bp_ip_path/src/bp_unicore_with_axi_wrapper.sv
  $bp_ip_path/src/bp_unicore_with_axi_wrapper_top.v
  $bp_ip_path/src/compareRecFN.v
  $bp_ip_path/src/divSqrtRecFN_small.v
  $bp_ip_path/src/fNToRecFN.v
  $bp_ip_path/src/HardFloat_consts.vi
  $bp_ip_path/src/HardFloat_localFuncs.vi
  $bp_ip_path/src/HardFloat_primitives.v
  $bp_ip_path/src/HardFloat_rawFN.v
  $bp_ip_path/src/HardFloat_specialize.v
  $bp_ip_path/src/HardFloat_specialize.vi
  $bp_ip_path/src/iNToRecFN.v
  $bp_ip_path/src/isSigNaNRecFN.v
  $bp_ip_path/src/mulAddRecFN.v
  $bp_ip_path/src/recFNToFN.v
  $bp_ip_path/src/recFNToIN.v
  $bp_ip_path/src/recFNToRecFN.v
  $bp_ip_path/src/bsg_adder_cin.sv
  $bp_ip_path/src/bsg_adder_one_hot.sv
  $bp_ip_path/src/bsg_arb_fixed.sv
  $bp_ip_path/src/bsg_buf.sv
  $bp_ip_path/src/bsg_bus_pack.sv
  $bp_ip_path/src/bsg_cache_decode.sv
  $bp_ip_path/src/bsg_cache_dma.sv
  $bp_ip_path/src/bsg_cache_miss.sv
  $bp_ip_path/src/bsg_cache_pkg.sv
  $bp_ip_path/src/bsg_cache_sbuf_queue.sv
  $bp_ip_path/src/bsg_cache_sbuf.sv
  $bp_ip_path/src/bsg_cache.sv
  $bp_ip_path/src/bsg_cam_1r1w_replacement.sv
  $bp_ip_path/src/bsg_cam_1r1w.sv
  $bp_ip_path/src/bsg_cam_1r1w_sync.sv
  $bp_ip_path/src/bsg_cam_1r1w_tag_array.sv
  $bp_ip_path/src/bsg_circular_ptr.sv
  $bp_ip_path/src/bsg_clkgate_optional.sv
  $bp_ip_path/src/bsg_counter_clear_up.sv
  $bp_ip_path/src/bsg_counter_set_en.sv
  $bp_ip_path/src/bsg_counter_up_down.sv
  $bp_ip_path/src/bsg_crossbar_o_by_i.sv
  $bp_ip_path/src/bsg_decode.sv
  $bp_ip_path/src/bsg_decode_with_v.sv
  $bp_ip_path/src/bsg_defines.v
  $bp_ip_path/src/bsg_dff_chain.sv
  $bp_ip_path/src/bsg_dff_en_bypass.sv
  $bp_ip_path/src/bsg_dff_en.sv
  $bp_ip_path/src/bsg_dff_reset_en_bypass.sv
  $bp_ip_path/src/bsg_dff_reset_en.sv
  $bp_ip_path/src/bsg_dff_reset_set_clear.sv
  $bp_ip_path/src/bsg_dff_reset.sv
  $bp_ip_path/src/bsg_dff.sv
  $bp_ip_path/src/bsg_dlatch.sv
  $bp_ip_path/src/bsg_encode_one_hot.sv
  $bp_ip_path/src/bsg_expand_bitmask.sv
  $bp_ip_path/src/bsg_fifo_1r1w_small_hardened.sv
  $bp_ip_path/src/bsg_fifo_1r1w_small.sv
  $bp_ip_path/src/bsg_fifo_1r1w_small_unhardened.sv
  $bp_ip_path/src/bsg_fifo_tracker.sv
  $bp_ip_path/src/bsg_flow_counter.sv
  $bp_ip_path/src/bsg_idiv_iterative_controller.sv
  $bp_ip_path/src/bsg_idiv_iterative.sv
  $bp_ip_path/src/bsg_lru_pseudo_tree_decode.sv
  $bp_ip_path/src/bsg_lru_pseudo_tree_encode.sv
  $bp_ip_path/src/bsg_mem_1r1w_one_hot.sv
  $bp_ip_path/src/bsg_mem_1r1w.sv
  $bp_ip_path/src/bsg_mem_1r1w_sync.sv
  $bp_ip_path/src/bsg_mem_1r1w_sync_synth.sv
  $bp_ip_path/src/bsg_mem_1r1w_synth.sv
  $bp_ip_path/src/bsg_mem_1rw_sync_mask_write_bit.sv
  $bp_ip_path/src/bsg_mem_1rw_sync_mask_write_bit_synth.sv
  $bp_ip_path/src/bsg_mem_1rw_sync_mask_write_byte.sv
  $bp_ip_path/src/bsg_mem_1rw_sync_mask_write_byte_synth.sv
  $bp_ip_path/src/bsg_mem_1rw_sync.sv
  $bp_ip_path/src/bsg_mem_1rw_sync_synth.sv
  $bp_ip_path/src/bsg_mem_2r1w_sync.sv
  $bp_ip_path/src/bsg_mem_2r1w_sync_synth.sv
  $bp_ip_path/src/bsg_mem_3r1w_sync.sv
  $bp_ip_path/src/bsg_mem_3r1w_sync_synth.sv
  $bp_ip_path/src/bsg_mux_bitwise.sv
  $bp_ip_path/src/bsg_muxi2_gatestack.sv
  $bp_ip_path/src/bsg_mux_one_hot.sv
  $bp_ip_path/src/bsg_mux_segmented.sv
  $bp_ip_path/src/bsg_mux.sv
  $bp_ip_path/src/bsg_nand.sv
  $bp_ip_path/src/bsg_noc_links.vh
  $bp_ip_path/src/bsg_noc_pkg.v
  $bp_ip_path/src/bsg_nor2.sv
  $bp_ip_path/src/bsg_nor3.sv
  $bp_ip_path/src/bsg_one_fifo.sv
  $bp_ip_path/src/bsg_parallel_in_serial_out_dynamic.sv
  $bp_ip_path/src/bsg_priority_encode_one_hot_out.sv
  $bp_ip_path/src/bsg_priority_encode.sv
  $bp_ip_path/src/bsg_reduce.sv
  $bp_ip_path/src/bsg_rotate_left.sv
  $bp_ip_path/src/bsg_rotate_right.sv
  $bp_ip_path/src/bsg_scan.sv
  $bp_ip_path/src/bsg_serial_in_parallel_out_dynamic.sv
  $bp_ip_path/src/bsg_shift_reg.sv
  $bp_ip_path/src/bsg_strobe.sv
  $bp_ip_path/src/bsg_two_fifo.sv
  $bp_ip_path/src/bsg_wormhole_router_pkg.sv
  $bp_ip_path/src/bsg_wormhole_router.vh
  $bp_ip_path/src/bsg_xnor.sv
"]

set_property file_type SystemVerilog [get_files [join "
  $bp_ip_path/src/bsg_noc_pkg.v
  $bp_ip_path/src/divSqrtRecFN_small.v
"]]

set_property top bp_unicore_with_axi_wrapper_top [current_fileset]
set_property top bp_unicore_with_axi_wrapper_top [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
endgroup

# run the following if you turned off the automatic hierarchy update and compilation 
# order update
# set_property source_mgmt_mode All [current_project]
# update_compile_order -fileset sources_1
# update_compile_order -fileset sources_1

ipx::package_project -root_dir $bp_ip_path -vendor user.org -library user -taxonomy /UserIP -force
