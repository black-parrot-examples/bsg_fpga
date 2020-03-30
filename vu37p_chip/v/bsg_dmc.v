module bsg_dmc
  import bsg_tag_pkg::bsg_tag_s;
  import bsg_dmc_pkg::bsg_dmc_s;
 #(parameter  num_adgs_p         = 1
  ,parameter  ui_addr_width_p    = "inv"
  ,parameter  ui_data_width_p    = "inv"
  ,parameter  burst_data_width_p = "inv"
  ,parameter  dq_data_width_p    = "inv"
  ,localparam ui_mask_width_lp   = ui_data_width_p >> 3
  ,localparam dfi_data_width_lp  = dq_data_width_p << 1
  ,localparam dfi_mask_width_lp  = (dq_data_width_p >> 3) << 1
  ,localparam dq_group_lp        = dq_data_width_p >> 3)
  // Tag lines
  (input bsg_tag_s                   async_reset_tag_i
  ,input bsg_tag_s [dq_group_lp-1:0] bsg_dly_tag_i
  ,input bsg_tag_s [dq_group_lp-1:0] bsg_dly_trigger_tag_i
  ,input bsg_tag_s                   bsg_ds_tag_i
  // 
  ,input bsg_dmc_s                   dmc_p_i
  //
  ,input                             sys_reset_i
  // User interface signals
  ,input       [ui_addr_width_p-1:0] app_addr_i
  ,input                       [2:0] app_cmd_i
  ,input                             app_en_i
  ,output                            app_rdy_o
  ,input                             app_wdf_wren_i
  ,input       [ui_data_width_p-1:0] app_wdf_data_i
  ,input      [ui_mask_width_lp-1:0] app_wdf_mask_i
  ,input                             app_wdf_end_i
  ,output                            app_wdf_rdy_o
  ,output                            app_rd_data_valid_o
  ,output      [ui_data_width_p-1:0] app_rd_data_o
  ,output                            app_rd_data_end_o
  // Reserved to be compatible with Xilinx IPs
  ,input                             app_ref_req_i
  ,output                            app_ref_ack_o
  ,input                             app_zq_req_i
  ,output                            app_zq_ack_o
  ,input                             app_sr_req_i
  ,output                            app_sr_active_o
  // Status signal
  ,output                            init_calib_complete_o
  // DDR interface signals
  // Command and Address interface
  ,output                            ddr_ck_p_o
  ,output                            ddr_ck_n_o
  ,output                            ddr_cke_o
  ,output                      [2:0] ddr_ba_o
  ,output                     [15:0] ddr_addr_o
  ,output                            ddr_cs_n_o
  ,output                            ddr_ras_n_o
  ,output                            ddr_cas_n_o
  ,output                            ddr_we_n_o
  ,output                            ddr_reset_n_o
  ,output                            ddr_odt_o
  // Data interface
  ,output          [dq_group_lp-1:0] ddr_dm_oen_o
  ,output          [dq_group_lp-1:0] ddr_dm_o
  ,output          [dq_group_lp-1:0] ddr_dqs_p_oen_o
  ,output          [dq_group_lp-1:0] ddr_dqs_p_ien_o
  ,output          [dq_group_lp-1:0] ddr_dqs_p_o
  ,input           [dq_group_lp-1:0] ddr_dqs_p_i
  ,output          [dq_group_lp-1:0] ddr_dqs_n_oen_o
  ,output          [dq_group_lp-1:0] ddr_dqs_n_ien_o
  ,output          [dq_group_lp-1:0] ddr_dqs_n_o
  ,input           [dq_group_lp-1:0] ddr_dqs_n_i
  ,output      [dq_data_width_p-1:0] ddr_dq_oen_o
  ,output      [dq_data_width_p-1:0] ddr_dq_o
  ,input       [dq_data_width_p-1:0] ddr_dq_i
  // Clock interface signals
  ,input                             ui_clk_i
  ,input                             dfi_clk_2x_i
  ,output                            dfi_clk_1x_o
  //
  ,output                            ui_clk_sync_rst_o
  // Reserved to be compatible with Xilinx IPs
  ,output                     [11:0] device_temp_o
);

  assign app_rdy_o = '0;
  assign app_wdf_rdy_o = '0;
  assign app_rd_data_valid_o = '0;
  assign app_rd_data_o = '0;
  assign app_rd_data_end_o = '0;
  assign app_ref_ack_o = '0;
  assign app_zq_ack_o = '0;
  assign app_sr_active_o = '0;
  assign init_calib_complete_o = '0;

endmodule
