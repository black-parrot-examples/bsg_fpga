
`include "bp_common_defines.svh"
`include "bp_be_defines.svh"
`include "bp_me_defines.svh"

module bp_stream_host

  import bp_common_pkg::*;
  import bp_be_pkg::*;
  import bp_me_pkg::*;

 #(parameter bp_params_e bp_params_p = e_bp_default_cfg
  `declare_bp_proc_params(bp_params_p)
  `declare_bp_bedrock_mem_if_widths(paddr_width_p, did_width_p, lce_id_width_p, lce_assoc_p)

  ,parameter stream_addr_width_p = 32
  ,parameter stream_data_width_p = 32
  ,parameter clear_freeze_p = 0

  ,localparam bsg_ready_and_link_sif_width_lp = `bsg_ready_and_link_sif_width(io_noc_flit_width_p)
  )

  (input                                        clk_i
  ,input                                        reset_i
  ,output logic                                 prog_done_o

  ,input  [mem_header_width_lp-1:0]             io_cmd_header_i
  ,input [cce_block_width_p-1:0]                io_cmd_data_i
  ,input                                        io_cmd_v_i
  ,output logic                                 io_cmd_ready_o

  ,output logic [mem_header_width_lp-1:0]       io_resp_header_o
  ,output [cce_block_width_p-1:0]               io_resp_data_o
  ,output logic                                 io_resp_v_o
  ,input                                        io_resp_yumi_i

  ,output logic [mem_header_width_lp-1:0]       io_cmd_header_o
  ,output [cce_block_width_p-1:0]               io_cmd_data_o
  ,output logic                                 io_cmd_v_o
  ,input                                        io_cmd_yumi_i

  ,input  [mem_header_width_lp-1:0]             io_resp_header_i
  ,input [cce_block_width_p-1:0]                io_resp_data_i
  ,input                                        io_resp_v_i
  ,output logic                                 io_resp_ready_o

  ,input                                        stream_v_i
  ,input  [stream_addr_width_p-1:0]             stream_addr_i
  ,input  [stream_data_width_p-1:0]             stream_data_i
  ,output logic                                 stream_yumi_o

  ,output logic                                 stream_v_o
  ,output logic [stream_data_width_p-1:0]       stream_data_o
  ,input                                        stream_ready_i
  );

  `declare_bp_bedrock_mem_if(paddr_width_p, did_width_p, lce_id_width_p, lce_assoc_p);

  // AXI-Lite address map
  //
  // Host software should send data to specific addresses for
  // specific purposes
  //
  logic nbf_v_li, mmio_v_li;
  logic nbf_ready_lo, mmio_ready_lo;;

  assign nbf_v_li  = stream_v_i & (stream_addr_i == 32'h00000010);
  assign mmio_v_li = stream_v_i & (stream_addr_i == 32'h00000020);

  assign stream_yumi_o = (nbf_v_li & nbf_ready_lo) | (mmio_v_li & mmio_ready_lo);

  // nbf loader
  bp_stream_nbf_loader
 #(.bp_params_p(bp_params_p)
  ,.stream_data_width_p(stream_data_width_p)
  ,.clear_freeze_p(clear_freeze_p)
  ) nbf_loader
  (.clk_i          (clk_i)
  ,.reset_i        (reset_i)
  ,.done_o         (prog_done_o)

  ,.io_cmd_header_o(io_cmd_header_o)
  ,.io_cmd_data_o  (io_cmd_data_o)
  ,.io_cmd_v_o     (io_cmd_v_o)
  ,.io_cmd_yumi_i  (io_cmd_yumi_i)

  ,.io_resp_header_i(io_resp_header_i)
  ,.io_resp_data_i (io_resp_data_i)
  ,.io_resp_v_i    (io_resp_v_i)
  ,.io_resp_ready_o(io_resp_ready_o)

  ,.stream_v_i     (nbf_v_li)
  ,.stream_data_i  (stream_data_i)
  ,.stream_ready_o (nbf_ready_lo)
  );

  // mmio
  bp_stream_mmio
 #(.bp_params_p(bp_params_p)
  ,.stream_data_width_p(stream_data_width_p)
  ) mmio
  (.clk_i           (clk_i)
  ,.reset_i         (reset_i)

  ,.io_cmd_header_i (io_cmd_header_i)
  ,.io_cmd_data_i   (io_cmd_data_i)
  ,.io_cmd_v_i      (io_cmd_v_i)
  ,.io_cmd_ready_o  (io_cmd_ready_o)

  ,.io_resp_header_o(io_resp_header_o)
  ,.io_resp_data_o  (io_resp_data_o)
  ,.io_resp_v_o     (io_resp_v_o)
  ,.io_resp_yumi_i  (io_resp_yumi_i)

  ,.stream_v_i      (mmio_v_li)
  ,.stream_data_i   (stream_data_i)
  ,.stream_ready_o  (mmio_ready_lo)

  ,.stream_v_o      (stream_v_o)
  ,.stream_data_o   (stream_data_o)
  ,.stream_yumi_i   (stream_v_o & stream_ready_i)
  );

endmodule

