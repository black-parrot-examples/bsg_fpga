/**
 *  Name:
 *    bp_stream_nbf_loader.v
 *
 *  Description:
 *    This module converts an incoming fifo stream containing serialized NBF
 *    command flits into BedRock burst IO commands.
 *
 *    Supports NBF writes, finish, and fence
 *
 *    TODO: support NBF reads
 *    TODO: clear memory using block-based accesses
 *
 */

`include "bp_common_defines.svh"
`include "bp_be_defines.svh"
`include "bp_me_defines.svh"

module bp_stream_nbf_loader
  import bp_common_pkg::*;
  import bp_be_pkg::*;
  import bp_me_pkg::*;
  #(parameter bp_params_e bp_params_p = e_bp_default_cfg
    `declare_bp_proc_params(bp_params_p)
    `declare_bp_bedrock_mem_if_widths(paddr_width_p, did_width_p, lce_id_width_p, lce_assoc_p)

    , parameter stream_data_width_p = 32
    // clear dram after reset
    , parameter clear_dram_p = 1
    // first address outside of dram range (default = 256 MiB dram)
    , parameter dram_high_addr_p = dram_base_addr_gp + (2**28)

    , parameter nbf_opcode_width_p = 8
    , parameter nbf_addr_width_p = paddr_width_p
    , parameter nbf_data_width_p = dword_width_gp

    , localparam nbf_width_lp = nbf_opcode_width_p + nbf_addr_width_p + nbf_data_width_p
    , localparam nbf_num_flits_lp = `BSG_CDIV(nbf_width_lp, stream_data_width_p)
    )
  (input                                          clk_i
   , input                                        reset_i
   , output logic                                 done_o

   , output logic [mem_header_width_lp-1:0]       io_cmd_header_o
   , output logic                                 io_cmd_header_v_o
   , input                                        io_cmd_header_ready_and_i
   , output logic                                 io_cmd_has_data_o
   , output logic [bedrock_data_width_p-1:0]      io_cmd_data_o
   , output logic                                 io_cmd_data_v_o
   , input                                        io_cmd_data_ready_and_i
   , output logic                                 io_cmd_last_o

   , input  [mem_header_width_lp-1:0]             io_resp_header_i
   , input                                        io_resp_header_v_i
   , output logic                                 io_resp_header_ready_and_o
   , input                                        io_resp_has_data_i
   , input  [bedrock_data_width_p-1:0]            io_resp_data_i
   , input                                        io_resp_data_v_i
   , output logic                                 io_resp_data_ready_and_o
   , input                                        io_resp_last_i

   , input                                        stream_v_i
   , input  [stream_data_width_p-1:0]             stream_data_i
   , output logic                                 stream_ready_o
   );

  // response network not used
  wire unused_resp = &{io_resp_header_i, io_resp_header_v_i, io_resp_has_data_i
                       ,io_resp_data_i, io_resp_data_v_i, io_resp_last_i};
  assign io_resp_header_ready_and_o = 1'b1;
  assign io_resp_data_ready_and_o = 1'b1;

  // nbf credit counter
  logic [`BSG_WIDTH(io_noc_max_credits_p)-1:0] credit_count_lo;
  wire credits_full_lo  = (credit_count_lo == io_noc_max_credits_p);
  wire credits_empty_lo = (credit_count_lo == '0);

  bsg_flow_counter
    #(.els_p(io_noc_max_credits_p))
    nbf_counter
     (.clk_i(clk_i)
      ,.reset_i(reset_i)
      ,.v_i(io_cmd_header_v_o)
      ,.ready_i(io_cmd_header_ready_and_i)
      ,.yumi_i(io_resp_header_v_i)
      ,.count_o(credit_count_lo)
      );

  // bp_nbf packet
  typedef struct packed {
    logic [nbf_opcode_width_p-1:0] opcode;
    logic [nbf_addr_width_p-1:0]   addr;
    logic [nbf_data_width_p-1:0]   data;
  } bp_nbf_s;

  `declare_bp_bedrock_mem_if(paddr_width_p, did_width_p, lce_id_width_p, lce_assoc_p);
  `bp_cast_o(bp_bedrock_mem_header_s, io_cmd_header);
  wire io_cmd_header_send = io_cmd_header_v_o & io_cmd_header_ready_and_i;
  wire io_cmd_data_send = io_cmd_data_v_o & io_cmd_data_ready_and_i;

  // read nbf file
  logic incoming_nbf_v_lo, incoming_nbf_yumi_li;
  logic [nbf_num_flits_lp-1:0][stream_data_width_p-1:0] incoming_nbf;

  bsg_serial_in_parallel_out_full
    #(.width_p(stream_data_width_p)
      ,.els_p(nbf_num_flits_lp)
      )
    nbf_sipo
     (.clk_i(clk_i)
      ,.reset_i(reset_i)
      ,.v_i(stream_v_i)
      ,.ready_o(stream_ready_o)
      ,.data_i(stream_data_i)
      ,.data_o(incoming_nbf)
      ,.v_o(incoming_nbf_v_lo)
      ,.yumi_i(incoming_nbf_yumi_li)
      );

  bp_nbf_s curr_nbf;
  assign curr_nbf = nbf_width_lp'(incoming_nbf);
  wire is_nbf_finish = (curr_nbf.opcode == 8'hFF);
  wire is_nbf_fence = (curr_nbf.opcode == 8'hFE);

  logic [paddr_width_p-1:0] addr_counter_r, addr_counter_n;

  typedef enum logic [2:0]
  {
    e_reset
    ,e_clear_memory
    ,e_clear_memory_data
    ,e_nbf
    ,e_nbf_data
    ,e_done
  } nbf_state_e;
  nbf_state_e state_r, state_n;

  assign done_o = (state_r == e_done);

  `declare_bp_memory_map(paddr_width_p, caddr_width_p);
  bp_local_addr_s freeze_addr;

  // combinational
  always_comb begin

    state_n = state_r;
    addr_counter_n = addr_counter_r;

    incoming_nbf_yumi_li = 1'b0;

    io_cmd_header_cast_o = '0;
    io_cmd_header_cast_o.payload = '0;
    io_cmd_header_cast_o.msg_type = e_bedrock_mem_uc_wr;
    io_cmd_header_v_o = 1'b0;
    io_cmd_has_data_o = 1'b1;

    io_cmd_data_o = curr_nbf.data;
    io_cmd_data_v_o = 1'b0;
    io_cmd_last_o = 1'b1;

    freeze_addr = '0;
    freeze_addr.nonlocal = '0;
    freeze_addr.tile     = addr_counter_r;
    freeze_addr.dev      = cfg_dev_gp;
    freeze_addr.addr     = cfg_reg_freeze_gp;

    case (state_r)
      e_reset: begin
        state_n = clear_dram_p ? e_clear_memory : e_nbf;
      end
      // clear DRAM
      e_clear_memory: begin
        io_cmd_header_v_o = ~credits_full_lo;
        io_cmd_header_cast_o.addr = addr_counter_r;
        io_cmd_header_cast_o.size = e_bedrock_msg_size_8;

        addr_counter_n = io_cmd_header_send
                         ? addr_counter_r + 'd8
                         : addr_counter_r;

        state_n = io_cmd_header_send ? e_clear_memory_data : state_r;
      end
      e_clear_memory_data: begin
        io_cmd_data_o = '0;
        io_cmd_data_v_o = 1'b1;
        state_n = io_cmd_data_send
                  ? (addr_counter_r >= dram_high_addr_p)
                    ? e_nbf
                    : e_clear_memory
                  : state_r;
      end

      // send NBF commands arriving on stream interface
      e_nbf: begin
        // send command if not finish or fence
        io_cmd_header_v_o = incoming_nbf_v_lo & ~credits_full_lo & ~is_nbf_finish & ~is_nbf_fence;
        io_cmd_header_cast_o.addr = curr_nbf.addr;
        case (curr_nbf.opcode)
          2: io_cmd_header_cast_o.size = e_bedrock_msg_size_4;
          3: io_cmd_header_cast_o.size = e_bedrock_msg_size_8;
          default: io_cmd_header_cast_o.size = e_bedrock_msg_size_4;
        endcase
        // consume nbf command here if finish or fence with no outstanding responses
        incoming_nbf_yumi_li = incoming_nbf_v_lo
                               & (is_nbf_finish | (credits_empty_lo & is_nbf_fence));
        state_n = (incoming_nbf_v_lo & is_nbf_finish)
                  ? e_done
                  : io_cmd_header_send
                    ? e_nbf_data
                    : state_r;
      end
      e_nbf_data: begin
        // data set above
        io_cmd_data_v_o = 1'b1;
        incoming_nbf_yumi_li = io_cmd_data_send;
      end

      // memory initialized, NBF loaded
      e_done: begin
        state_n = state_r;
      end
      default: begin
      end
    endcase
  end // always_comb

  // sequential
  always_ff @(posedge clk_i) begin
    if (reset_i) begin
      state_r <= e_reset;
      addr_counter_r <= dram_base_addr_gp;
    end else begin
      state_r <= state_n;
      addr_counter_r <= addr_counter_n;
    end
  end

endmodule
