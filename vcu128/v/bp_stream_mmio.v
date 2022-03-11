/**
 *  Name:
 *    bp_stream_mmio.v
 *
 *  Description:
 *    This module provides basic I/O from BP. Each IO command is converted
 *    into two stream beats: address followed by data. I/O reads receive two
 *    stream words in response from stream input channel; I/O writes receive
 *    no response from stream input channel.
 *
 *    Supports 32-bit writes and 64-bit reads
 *
 *    TODO: support 64-bit writes?
 *    TODO: modify host code to support variable sized operations?
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
    , parameter cmd_buffer_els_p = 16
    , parameter stream_data_width_p = 32
    , localparam stream_words_lp = (bedrock_data_width_p/stream_data_width_p)
    )
  (input                                      clk_i
   , input                                    reset_i

   , input  [mem_header_width_lp-1:0]         io_cmd_header_i
   , input                                    io_cmd_header_v_i
   , output logic                             io_cmd_header_ready_and_o
   , input                                    io_cmd_has_data_i
   , input  [bedrock_data_width_p-1:0]        io_cmd_data_i
   , input                                    io_cmd_data_v_i
   , output logic                             io_cmd_data_ready_and_o
   , input                                    io_cmd_last_i

   , output logic [mem_header_width_lp-1:0]   io_resp_header_o
   , output logic                             io_resp_header_v_o
   , input                                    io_resp_header_ready_and_i
   , output logic                             io_resp_has_data_o
   , output logic [bedrock_data_width_p-1:0]  io_resp_data_o
   , output logic                             io_resp_data_v_o
   , input                                    io_resp_data_ready_and_i
   , output logic                             io_resp_last_o

   , input                                    stream_v_i
   , input  [stream_data_width_p-1:0]         stream_data_i
   , output logic                             stream_ready_o

   , output logic                             stream_v_o
   , output logic [stream_data_width_p-1:0]   stream_data_o
   , input                                    stream_yumi_i
   );

  `declare_bp_bedrock_mem_if(paddr_width_p, did_width_p, lce_id_width_p, lce_assoc_p);
  `bp_cast_i(bp_bedrock_mem_header_s, io_cmd_header);
  `bp_cast_o(bp_bedrock_mem_header_s, io_resp_header);

  if (stream_data_width_p != 32)
    $error("stream data width must be 32-bits");
  if (bedrock_data_width_p != 64)
    $error("bedrock data width must be 64-bits");

  // IO Command Header FIFO
  logic io_cmd_header_v_li, io_cmd_header_yumi_lo, io_cmd_has_data_li;
  bp_bedrock_mem_header_s io_cmd_header_li;
  bsg_two_fifo
    #(.width_p(mem_header_width_lp+1))
    cmd_hdr_fifo
     (.clk_i(clk_i)
      ,.reset_i(reset_i)
      ,.data_i({io_cmd_has_data_i, io_cmd_header_cast_i})
      ,.v_i(io_cmd_header_v_i)
      ,.ready_o(io_cmd_header_ready_and_o)
      ,.data_o({io_cmd_has_data_li, io_cmd_header_li})
      ,.v_o(io_cmd_header_v_li)
      ,.yumi_i(io_cmd_header_yumi_lo)
      );

  // IO Command Data FIFO
  logic io_cmd_data_v_li, io_cmd_data_yumi_lo, io_cmd_last_li;
  logic [bedrock_data_width_p-1:0] io_cmd_data_li;
  bsg_two_fifo
    #(.width_p(bedrock_data_width_p+1))
    cmd_data_fifo
     (.clk_i(clk_i)
      ,.reset_i(reset_i)
      ,.data_i({io_cmd_last_i, io_cmd_data_i})
      ,.v_i(io_cmd_data_v_i)
      ,.ready_o(io_cmd_data_ready_and_o)
      ,.data_o({io_cmd_last_li, io_cmd_data_li})
      ,.v_o(io_cmd_data_v_li)
      ,.yumi_i(io_cmd_data_yumi_lo)
      );

  // IO Response Header FIFO
  // response header is identical to command header
  logic resp_hdr_fifo_v_li, resp_hdr_fifo_ready_then_lo;
  logic resp_hdr_fifo_v_lo, resp_hdr_fifo_yumi_li;
  bsg_fifo_1r1w_small
    #(.width_p(mem_header_width_lp)
      ,.els_p(cmd_buffer_els_p)
      ,.ready_THEN_valid_p(1)
      )
    resp_hdr_fifo
     (.clk_i(clk_i)
     ,.reset_i(reset_i)
     // from command FSM
     ,.data_i(io_cmd_header_li)
     ,.v_i(resp_hdr_fifo_v_li)
     ,.ready_o(resp_hdr_fifo_ready_then_lo)
     // to IO response out, control by response FSM
     ,.data_o(io_resp_header_cast_o)
     ,.v_o(resp_hdr_fifo_v_lo)
     ,.yumi_i(resp_hdr_fifo_yumi_li)
     );

  // streaming out fifo
  logic out_fifo_v_li, out_fifo_ready_then_lo;
  logic [stream_data_width_p-1:0] out_fifo_data_li;
  bsg_two_fifo
    #(.width_p(stream_data_width_p)
      ,.ready_THEN_valid_p(1)
      )
    out_fifo
     (.clk_i(clk_i)
     ,.reset_i(reset_i)
     // from FSM
     ,.data_i(out_fifo_data_li)
     ,.v_i(out_fifo_v_li)
     ,.ready_o(out_fifo_ready_then_lo)
     // to stream output
     ,.data_o(stream_data_o)
     ,.v_o(stream_v_o)
     ,.yumi_i(stream_yumi_i)
     );

  // convert two 32-bit stream data inputs to single data word for IO response
  // each IO read command will receive two stream words in response
  logic sipo_v_lo, sipo_yumi_li;
  logic [bedrock_data_width_p-1:0] sipo_data_lo;
  bsg_serial_in_parallel_out_full
    #(.width_p(stream_data_width_p)
      ,.els_p(stream_words_lp)
      )
    stream_data_sipo
     (.clk_i(clk_i)
      ,.reset_i(reset_i)
      // from stream input
      ,.v_i(stream_v_i)
      ,.ready_o(stream_ready_o)
      ,.data_i(stream_data_i)
      // to IO response data output
      ,.data_o(sipo_data_lo)
      ,.v_o(sipo_v_lo)
      ,.yumi_i(sipo_yumi_li)
      );

  /*
   * BP IO Command In FSM
   * writes consume IO cmd data in, reads send a null data stream word
   */

  typedef enum logic [1:0]
  {
    e_reset
    ,e_addr
    ,e_data
    ,e_null_data
  } cmd_state_e;
  cmd_state_e state_r, state_n;

  always_comb begin
    state_n = state_r;

    io_cmd_header_yumi_lo = 1'b0;
    io_cmd_data_yumi_lo = 1'b0;

    resp_hdr_fifo_v_li = 1'b0;

    out_fifo_v_li = 1'b0;
    out_fifo_data_li = '0;

    case (state_r)
      e_reset: begin
        state_n = e_addr;
      end
      // send IO command address to out fifo, enqueue IO command header to
      // resp header fifo. Both FIFOs must be ready
      e_addr: begin
        // consume header if resp hdr fifo and output fifo both ready
        io_cmd_header_yumi_lo = io_cmd_header_v_li
                                & out_fifo_ready_then_lo & resp_hdr_fifo_ready_then_lo;
        // ready-then-valid handshakes
        out_fifo_v_li = io_cmd_header_yumi_lo;
        out_fifo_data_li = io_cmd_header_li.addr;
        resp_hdr_fifo_v_li = io_cmd_header_yumi_lo;

        state_n = io_cmd_header_yumi_lo
                  ? io_cmd_has_data_li
                    ? e_data
                    : e_null_data
                  : state_r;
      end
      // send IO command data to out fifo
      // only sends a single 32-bit stream data word
      e_data: begin
        out_fifo_data_li = io_cmd_data_li[0+:stream_data_width_p];
        // TODO: only single data beats allowed, check last_i raised with valid
        out_fifo_v_li = io_cmd_data_v_li;
        io_cmd_data_yumi_lo = out_fifo_v_li & out_fifo_ready_then_lo;
        state_n = io_cmd_data_yumi_lo ? e_addr : state_r;
      end
      // send null data for IO reads
      e_null_data: begin
        out_fifo_data_li = '0;
        out_fifo_v_li = 1'b1;
        state_n = (out_fifo_v_li & out_fifo_ready_then_lo) ? e_addr : state_r;
      end
      default: begin
        state_n = state_r;
      end
    endcase
  end

  /*
   * BP IO Response Out FSM
   * consume stream data in, forward to IO response out
   */

  typedef enum logic [1:0]
  {
    e_resp_reset
    ,e_resp_hdr
    ,e_resp_data
  } resp_state_e;
  resp_state_e resp_state_r, resp_state_n;

  always_comb begin
    resp_state_n = resp_state_r;

    io_resp_header_v_o = 1'b0;
    io_resp_has_data_o = 1'b0;
    io_resp_data_v_o = 1'b0;
    io_resp_data_o = sipo_data_lo;
    io_resp_last_o = 1'b1;

    resp_hdr_fifo_yumi_li = 1'b0;
    sipo_yumi_li = 1'b0;

    case (resp_state_r)
      e_resp_reset: begin
        resp_state_n = e_resp_hdr;
      end
      e_resp_hdr: begin
        case (io_resp_header_cast_o.msg_type)
          // reads send responses, data comes from sipo
          e_bedrock_mem_rd
          ,e_bedrock_mem_uc_rd: begin
            io_resp_header_v_o = resp_hdr_fifo_v_lo;
            io_resp_has_data_o = 1'b1;
            resp_hdr_fifo_yumi_li = io_resp_header_v_o & io_resp_header_ready_and_i;
            resp_state_n = (io_resp_header_v_o & io_resp_header_ready_and_i)
                           ? e_resp_data
                           : resp_state_r;
          end
          // writes send a header only response
          e_bedrock_mem_wr
          ,e_bedrock_mem_uc_wr: begin
            io_resp_header_v_o = resp_hdr_fifo_v_lo;
            resp_hdr_fifo_yumi_li = io_resp_header_v_o & io_resp_header_ready_and_i;
            resp_state_n = resp_state_r;
          end
          default: begin
            // do nothing
          end
        endcase
      end
      e_resp_data: begin
        io_resp_data_v_o = sipo_v_lo;
        sipo_yumi_li = io_resp_data_v_o & io_resp_data_ready_and_i;
        resp_state_n = sipo_yumi_li
                       ? e_resp_hdr
                       : resp_state_r;
      end
      default: begin
        // do nothing
      end
    endcase
  end

  // sequential logic
  always_ff @(posedge clk_i) begin
    if (reset_i) begin
      state_r <= e_reset;
      resp_state_r <= e_resp_reset;
    end else begin
      state_r <= state_n;
      resp_state_r <= resp_state_n;
    end
  end


endmodule
