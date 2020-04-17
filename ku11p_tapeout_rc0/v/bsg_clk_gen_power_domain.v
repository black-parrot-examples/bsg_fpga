`include "bsg_tag.vh"

module bsg_clk_gen_power_domain

import bsg_tag_pkg::bsg_tag_s;

#(parameter num_clk_endpoint_p = "inv"
, parameter ds_width_p         = 8
, parameter num_adgs_p         = 1
)

( // bsg_tag signals
  input bsg_tag_s                          async_reset_tag_lines_i
, input bsg_tag_s [num_clk_endpoint_p-1:0] osc_tag_lines_i
, input bsg_tag_s [num_clk_endpoint_p-1:0] osc_trigger_tag_lines_i
, input bsg_tag_s [num_clk_endpoint_p-1:0] ds_tag_lines_i
, input bsg_tag_s [num_clk_endpoint_p-1:0] sel_tag_lines_i

// external clock input
, input [num_clk_endpoint_p-1:0] ext_clk_i

// output clocks
, output logic [num_clk_endpoint_p-1:0] clk_o
);
  
  logic [num_clk_endpoint_p-1:0] ext_clk_li;
  assign ext_clk_li = ext_clk_i;
  
  assign clk_o = ext_clk_li;

endmodule
