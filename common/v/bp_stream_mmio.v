/**
 *  bp_stream_mmio.v
 *
 */

`include "bp_common_defines.svh"
`include "bp_be_defines.svh"
`include "bp_me_defines.svh"


module bp_stream_mmio

  import bp_common_pkg::*;
  import bp_be_pkg::*;
  import bp_me_pkg::*;

 #(parameter bp_params_e bp_params_p = e_bp_default_cfg
  `declare_bp_proc_params(bp_params_p)
  `declare_bp_bedrock_mem_if_widths(paddr_width_p, did_width_p, lce_id_width_p, lce_assoc_p)

  ,parameter stream_data_width_p = 32
  )

  (input  clk_i
  ,input  reset_i

  ,input  [mem_header_width_lp-1:0]         io_cmd_header_i
  ,input [cce_block_width_p-1:0]            io_cmd_data_i
  ,input                                    io_cmd_v_i
  ,output logic                             io_cmd_ready_o

  ,output logic [mem_header_width_lp-1:0]   io_resp_header_o
  ,output [cce_block_width_p-1:0]           io_resp_data_o
  ,output logic                             io_resp_v_o
  ,input                                    io_resp_yumi_i

  ,input                                    stream_v_i
  ,input  [stream_data_width_p-1:0]         stream_data_i
  ,output logic                             stream_ready_o

  ,output logic                             stream_v_o
  ,output logic [stream_data_width_p-1:0]   stream_data_o
  ,input                                    stream_yumi_i
  );

  `declare_bp_bedrock_mem_if(paddr_width_p, did_width_p, lce_id_width_p, lce_assoc_p);

  // Temporarily support cce_data_size less than stream_data_width_p only
  // Temporarily support response of 64-bits data only
  bp_bedrock_mem_header_s io_cmd_header_li, io_resp_header_lo;
  logic [cce_block_width_p-1:0] io_cmd_data_li, io_resp_data_lo;

  logic io_cmd_v_li, io_cmd_yumi_lo;
  bsg_two_fifo
 #(.width_p(mem_header_width_lp+cce_block_width_p))
 cmd_fifo
  (.clk_i(clk_i)
   ,.reset_i(reset_i)
   ,.data_i({io_cmd_data_i, io_cmd_header_i})
   ,.v_i(io_cmd_v_i)
   ,.ready_o(io_cmd_ready_o)
   ,.data_o({io_cmd_data_li, io_cmd_header_li})
   ,.v_o(io_cmd_v_li)
   ,.yumi_i(io_cmd_yumi_lo)
   );

  // streaming out fifo
  logic out_fifo_v_li, out_fifo_ready_lo;
  logic [stream_data_width_p-1:0] out_fifo_data_li;

  bsg_two_fifo
 #(.width_p(stream_data_width_p)
  ) out_fifo
  (.clk_i  (clk_i)
  ,.reset_i(reset_i)
  ,.data_i (out_fifo_data_li)
  ,.v_i    (out_fifo_v_li)
  ,.ready_o(out_fifo_ready_lo)
  ,.data_o (stream_data_o)
  ,.v_o    (stream_v_o)
  ,.yumi_i (stream_yumi_i)
  );

  // cmd_queue fifo
  logic queue_fifo_v_li, queue_fifo_ready_lo;
  logic queue_fifo_v_lo, queue_fifo_yumi_li;

  bsg_fifo_1r1w_small
 #(.width_p(mem_header_width_lp)
  ,.els_p  (16)
  ) queue_fifo
  (.clk_i  (clk_i)
  ,.reset_i(reset_i)
  ,.data_i (io_cmd_header_li)
  ,.v_i    (queue_fifo_v_li)
  ,.ready_o(queue_fifo_ready_lo)
  ,.data_o (io_resp_header_lo)
  ,.v_o    (queue_fifo_v_lo)
  ,.yumi_i (queue_fifo_yumi_li)
  );

  logic [1:0] state_r, state_n;

  always_ff @(posedge clk_i)
    if (reset_i)
      begin
        state_r <= '0;
      end
    else
      begin
        state_r <= state_n;
      end

  always_comb
  begin
    state_n = state_r;
    io_cmd_yumi_lo = 1'b0;
    queue_fifo_v_li = 1'b0;
    out_fifo_v_li = 1'b0;
    out_fifo_data_li = io_cmd_data_li;

    if (state_r == 0)
      begin
        if (io_cmd_v_li & out_fifo_ready_lo & queue_fifo_ready_lo)
          begin
            out_fifo_v_li = 1'b1;
            out_fifo_data_li = io_cmd_header_li.addr;
            state_n = 1;
          end
      end
    else if (state_r == 1)
      begin
        if (io_cmd_v_li & out_fifo_ready_lo & queue_fifo_ready_lo)
          begin
            out_fifo_v_li = 1'b1;
            io_cmd_yumi_lo = 1'b1;
            queue_fifo_v_li = 1'b1;
            state_n = 0;
          end
      end
  end

  // resp fifo
  logic io_resp_v_li, io_resp_ready_lo;

  bsg_two_fifo
 #(.width_p(mem_header_width_lp+cce_block_width_p)
  ) resp_fifo
  (.clk_i  (clk_i)
  ,.reset_i(reset_i)
  ,.data_i ({io_resp_data_lo, io_resp_header_lo})
  ,.v_i    (io_resp_v_li)
  ,.ready_o(io_resp_ready_lo)
  ,.data_o ({io_resp_data_o, io_resp_header_o})
  ,.v_o    (io_resp_v_o)
  ,.yumi_i (io_resp_yumi_i)
  );

  logic sipo_v_lo, sipo_yumi_li;
  logic [dword_width_gp-1:0] sipo_data_lo;;

  bsg_serial_in_parallel_out_full
 #(.width_p(stream_data_width_p)
  ,.els_p  (dword_width_gp/stream_data_width_p)
  ) sipo
  (.clk_i  (clk_i)
  ,.reset_i(reset_i)
  ,.v_i    (stream_v_i)
  ,.ready_o(stream_ready_o)
  ,.data_i (stream_data_i)
  ,.data_o (sipo_data_lo)
  ,.v_o    (sipo_v_lo)
  ,.yumi_i (sipo_yumi_li)
  );

  always_comb
  begin
    io_resp_v_li = 1'b0;
    queue_fifo_yumi_li = 1'b0;
    sipo_yumi_li = 1'b0;
    io_resp_data_lo = '0;
    if (queue_fifo_v_lo & io_resp_ready_lo)
      begin
        case (io_resp_header_lo.msg_type)
          e_bedrock_mem_rd
          ,e_bedrock_mem_uc_rd:
          begin
            if (sipo_v_lo)
              begin
                io_resp_data_lo = sipo_data_lo;
                io_resp_v_li = 1'b1;
                queue_fifo_yumi_li = 1'b1;
                sipo_yumi_li = 1'b1;
              end
          end
          e_bedrock_mem_uc_wr
          ,e_bedrock_mem_wr   :
          begin
            io_resp_v_li = 1'b1;
            queue_fifo_yumi_li = 1'b1;
          end
          default: begin
          end
        endcase
      end
  end

endmodule
