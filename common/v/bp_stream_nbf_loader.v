/**
 *  bp_stream_nbf_loader.v
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

  ,parameter stream_data_width_p = 32
  ,parameter clear_freeze_p = 0

  ,parameter nbf_opcode_width_p = 8
  ,parameter nbf_addr_width_p = paddr_width_p
  ,parameter nbf_data_width_p = dword_width_gp

  ,localparam nbf_width_lp = nbf_opcode_width_p + nbf_addr_width_p + nbf_data_width_p
  ,localparam nbf_num_flits_lp = `BSG_CDIV(nbf_width_lp, stream_data_width_p)
  )

  (input                                    clk_i
  ,input                                    reset_i
  ,output logic                             done_o

  ,output logic [mem_header_width_lp-1:0]   io_cmd_header_o
  ,output logic [cce_block_width_p-1:0]     io_cmd_data_o
  ,output logic                             io_cmd_v_o
  ,input                                    io_cmd_yumi_i

  ,input  [mem_header_width_lp-1:0]         io_resp_header_i
  ,input [cce_block_width_p-1:0]            io_resp_data_i
  ,input                                    io_resp_v_i
  ,output logic                             io_resp_ready_o

  ,input                                    stream_v_i
  ,input  [stream_data_width_p-1:0]         stream_data_i
  ,output logic                             stream_ready_o
  );

  // response network not used
  wire unused_resp = &{io_resp_header_i, io_resp_data_i, io_resp_v_i};
  assign io_resp_ready_o = 1'b1;

  // nbf credit counter
  logic [`BSG_WIDTH(io_noc_max_credits_p)-1:0] credit_count_lo;
  wire credits_full_lo  = (credit_count_lo == io_noc_max_credits_p);
  wire credits_empty_lo = (credit_count_lo == '0);

  bsg_flow_counter
 #(.els_p  (io_noc_max_credits_p)
  ) nbf_counter
  (.clk_i  (clk_i)
  ,.reset_i(reset_i)
  ,.v_i    (io_cmd_yumi_i)
  ,.ready_i(1'b1)
  ,.yumi_i (io_resp_v_i)
  ,.count_o(credit_count_lo)
  );

  // bp_nbf packet
  typedef struct packed {
    logic [nbf_opcode_width_p-1:0] opcode;
    logic [nbf_addr_width_p-1:0]   addr;
    logic [nbf_data_width_p-1:0]   data;
  } bp_nbf_s;

  // bp_cce packet
  `declare_bp_bedrock_mem_if(paddr_width_p, did_width_p, lce_id_width_p, lce_assoc_p);
  `bp_cast_o(bp_bedrock_mem_header_s, io_cmd_header);

  // read nbf file
  logic incoming_nbf_v_lo, incoming_nbf_yumi_li;
  logic [nbf_num_flits_lp-1:0][stream_data_width_p-1:0] incoming_nbf;

  bsg_serial_in_parallel_out_full
 #(.width_p(stream_data_width_p)
  ,.els_p  (nbf_num_flits_lp)
  ) sipo
  (.clk_i  (clk_i)
  ,.reset_i(reset_i)
  ,.v_i    (stream_v_i)
  ,.ready_o(stream_ready_o)
  ,.data_i (stream_data_i)
  ,.data_o (incoming_nbf)
  ,.v_o    (incoming_nbf_v_lo)
  ,.yumi_i (incoming_nbf_yumi_li)
  );

  bp_nbf_s curr_nbf;
  assign curr_nbf = nbf_width_lp'(incoming_nbf);

  logic [paddr_width_p-1:0] counter_r, counter_n;
  logic [1:0] state_r, state_n;

  assign done_o = (state_r == 3) & credits_empty_lo;

  `declare_bp_memory_map(paddr_width_p, caddr_width_p);
  bp_local_addr_s freeze_addr;

  localparam sel_width_lp = `BSG_SAFE_CLOG2(nbf_data_width_p>>3);
  localparam size_width_lp = `BSG_SAFE_CLOG2(sel_width_lp);
  bsg_bus_pack
   #(.in_width_p(nbf_data_width_p), .out_width_p(cce_block_width_p))
   cmd_bus_pack
    (.data_i(curr_nbf.data)
     ,.sel_i('0) // We are aligned
     ,.size_i(io_cmd_header_cast_o.size[0+:size_width_lp])
     ,.data_o(io_cmd_data_o)
     );

 // combinational
  always_comb
  begin

    // TODO: This is probably why unicore wasn't working
    io_cmd_header_cast_o.payload = '0;
    io_cmd_header_cast_o.payload.did = '1;
    io_cmd_header_cast_o.addr = curr_nbf.addr;
    io_cmd_header_cast_o.msg_type = e_bedrock_mem_uc_wr;
    io_cmd_header_cast_o.subop = e_bedrock_store;

    freeze_addr.nonlocal = '0;
    freeze_addr.tile     = counter_r;
    freeze_addr.dev      = cfg_dev_gp;
    freeze_addr.addr     = cfg_reg_freeze_gp;

    case (curr_nbf.opcode)
      2: io_cmd_header_cast_o.size = e_bedrock_msg_size_4;
      3: io_cmd_header_cast_o.size = e_bedrock_msg_size_8;
      default: io_cmd_header_cast_o.size = e_bedrock_msg_size_4;
    endcase

    state_n = state_r;
    counter_n = counter_r;
    io_cmd_v_o = 1'b0;
    incoming_nbf_yumi_li = 1'b0;

    if (state_r == 0)
      begin
        if (~reset_i)
          begin
            io_cmd_v_o = ~credits_full_lo;
            io_cmd_header_cast_o.addr = counter_r;
            io_cmd_header_cast_o.size = e_bedrock_msg_size_8;
            if (io_cmd_yumi_i)
              begin
                counter_n = counter_r + 'h8;
                if (counter_r == 'h84000000)
                  begin
                    counter_n = '0;
                    state_n = 1;
                  end
              end
          end
      end
    else if (state_r == 1)
      begin
        if (incoming_nbf_v_lo)
          begin
            io_cmd_v_o = ~credits_full_lo;
            incoming_nbf_yumi_li = io_cmd_yumi_i;
            if (curr_nbf.opcode == 8'hFF)
              begin
                if (clear_freeze_p == 0)
                  begin
                    io_cmd_header_cast_o.addr = '0;
                    io_cmd_header_cast_o.size = e_bedrock_msg_size_8;
                    if (io_cmd_yumi_i)
                      begin
                        state_n = 3;
                      end
                  end
                else
                  begin
                    io_cmd_v_o = 1'b0;
                    incoming_nbf_yumi_li = 1'b0;
                    state_n = 2;
                  end
              end
          end
      end
    else if (state_r == 2)
      begin
        io_cmd_v_o = ~credits_full_lo;
        io_cmd_header_cast_o.addr = freeze_addr;
        io_cmd_header_cast_o.size = e_bedrock_msg_size_8;
        if (io_cmd_yumi_i)
          begin
            counter_n = counter_r + 'd1;
            if (counter_r == num_core_p-1)
              begin
                counter_n = '0;
                state_n = 3;
              end
          end
      end

  end

  // sequential
  always_ff @(posedge clk_i)
    if (reset_i)
      begin
        state_r <= '0;
        counter_r <= 'h080000000;
      end
    else
      begin
        state_r <= state_n;
        counter_r <= counter_n;
      end

endmodule
