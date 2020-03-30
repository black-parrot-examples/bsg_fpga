/**
 * bp_me_cce_to_wormhole_link_master.v
 */
 
`include "bp_mem_wormhole.vh"

module bp_me_cce_to_xui
 import bp_cce_pkg::*;
 import bp_common_pkg::*;
 import bp_common_aviary_pkg::*;
 import bp_me_pkg::*;
 #(parameter bp_params_e bp_params_p = e_bp_inv_cfg
   `declare_bp_proc_params(bp_params_p)
   `declare_bp_me_if_widths(paddr_width_p, cce_block_width_p, lce_id_width_p, lce_assoc_p)

   , parameter flit_width_p = "inv"
   , parameter cord_width_p = "inv"
   , parameter cid_width_p  = "inv"
   , parameter len_width_p  = "inv"

   , localparam bsg_ready_and_link_sif_width_lp = `bsg_ready_and_link_sif_width(flit_width_p)
   )
  (input                                 clk_i
   , input                               reset_i

   // CCE-MEM Interface
   , input  [cce_mem_msg_width_lp-1:0]   mem_cmd_i
   , input                               mem_cmd_v_i
   , output                              mem_cmd_ready_o
                                          
   , output [cce_mem_msg_width_lp-1:0]   mem_resp_o
   , output logic                        mem_resp_v_o
   , input                               mem_resp_yumi_i
                                         
   // xilinx user interface
   , output [paddr_width_p-1:0]          app_addr_o
   , output [2:0]                        app_cmd_o
   , output                              app_en_o
   , input                               app_rdy_i
   , output                              app_wdf_wren_o
   , output [cce_block_width_p-1:0]      app_wdf_data_o
   , output [(cce_block_width_p>>3)-1:0] app_wdf_mask_o
   , output                              app_wdf_end_o
   , input                               app_wdf_rdy_i
   , input                               app_rd_data_valid_i
   , input [cce_block_width_p-1:0]       app_rd_data_i
   , input                               app_rd_data_end_i
   );
   
   assign mem_cmd_ready_o = 1'b1;
   assign mem_resp_o = '0;
   assign mem_resp_v_o = 1'b0;
   
   assign app_addr_o = '0;
   assign app_cmd_o = '0;
   assign app_en_o = '0;
   assign app_wdf_wren_o = '0;
   assign app_wdf_data_o = '0;
   assign app_wdf_mask_o = '0;
   assign app_wdf_end_o = '0;

endmodule

