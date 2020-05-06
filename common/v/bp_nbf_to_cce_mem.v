/**
 *  bp_nbf_to_cce_mem.v
 *
 */

module bp_nbf_to_cce_mem

  import bp_common_pkg::*;
  import bp_common_aviary_pkg::*;
  import bp_cce_pkg::*;
  import bp_me_pkg::*;
  
 #(parameter bp_params_e bp_params_p = e_bp_inv_cfg
  `declare_bp_proc_params(bp_params_p)
  `declare_bp_me_if_widths(paddr_width_p, cce_block_width_p, lce_id_width_p, lce_assoc_p)
  
  ,localparam byte_width_lp = 8
  ,localparam block_offset_lp = `BSG_SAFE_CLOG2(cce_block_width_p/byte_width_lp)
  )

  (input  clk_i
  ,input  reset_i
  
  ,input  [cce_mem_msg_width_lp-1:0]        io_cmd_i
  ,input                                    io_cmd_v_i
  ,output                                   io_cmd_yumi_o
  
  ,output [cce_mem_msg_width_lp-1:0]        io_resp_o
  ,output                                   io_resp_v_o
  ,input                                    io_resp_ready_i
  
  ,output [cce_mem_msg_width_lp-1:0]        mem_cmd_o
  ,output                                   mem_cmd_v_o
  ,input                                    mem_cmd_yumi_i
  
  ,input  [cce_mem_msg_width_lp-1:0]        mem_resp_i
  ,input                                    mem_resp_v_i
  ,output                                   mem_resp_ready_o
  );
  
  // response input not used
  wire unused_resp = &{mem_resp_i, mem_resp_v_i};
  assign mem_resp_ready_o = 1'b1;
  
  // bp_cce packet
  `declare_bp_me_if(paddr_width_p, cce_block_width_p, lce_id_width_p, lce_assoc_p);
  
  bp_cce_mem_msg_s io_cmd, io_resp, mem_cmd;
  logic io_cmd_yumi_lo, mem_cmd_v_lo;
  
  assign io_cmd    = io_cmd_i;
  assign mem_cmd_o = mem_cmd;
  
  assign io_cmd_yumi_o = io_cmd_yumi_lo;
  assign mem_cmd_v_o   = mem_cmd_v_lo;
  
  // Handle io response
  assign io_resp.data            = '0;
  assign io_resp.header.payload  = io_cmd.header.payload;
  assign io_resp.header.addr     = io_cmd.header.addr;
  assign io_resp.header.msg_type = io_cmd.header.msg_type;
  assign io_resp.header.size     = io_cmd.header.size;
  
  logic io_resp_fifo_ready_lo;
  
  bsg_two_fifo
 #(.width_p(cce_mem_msg_width_lp)
  ) resp_fifo
  (.clk_i  (clk_i)
  ,.reset_i(reset_i)
  ,.data_i (io_resp)
  ,.v_i    (io_cmd_yumi_o)
  ,.ready_o(io_resp_fifo_ready_lo)
  ,.data_o (io_resp_o)
  ,.v_o    (io_resp_v_o)
  ,.yumi_i (io_resp_v_o & io_resp_ready_i)
  );
  
  logic [3:0] state_r, state_n;
  logic [cce_block_width_p-1:0] words_r, words_n;
  logic [paddr_width_p-1:0] addr_r, addr_n;
  
  always_ff @(posedge clk_i)
  begin
    if (reset_i)
      begin
        state_r <= '0;
        words_r <= '0;
        addr_r  <= '0;
      end
    else
      begin
        state_r <= state_n;
        words_r <= words_n;
        addr_r  <= addr_n;
      end
  end
  
  wire [block_offset_lp-1:0] io_cmd_byte_idx = io_cmd.header.addr[block_offset_lp-1:0];
 
 // combinational
  always_comb 
  begin
    
    state_n = state_r;
    words_n = words_r;
    addr_n  = addr_r;
    
    io_cmd_yumi_lo          = 1'b0;
    mem_cmd_v_lo            = 1'b0;
    mem_cmd.data            = words_r;
    mem_cmd.header.payload  = '0;
    mem_cmd.header.addr     = {addr_r[paddr_width_p-1:block_offset_lp], (block_offset_lp)'(0)};
    mem_cmd.header.msg_type = e_cce_mem_wr;
    mem_cmd.header.size     = e_mem_msg_size_64;
    
    if (state_r == 0)
      begin
        if (io_cmd_v_i)
          begin
            addr_n = io_cmd.header.addr;
            words_n = '0;
            state_n = 1;
          end
      end
    else if (state_r == 1)
      begin
        if (io_cmd_v_i)
          begin
            if (io_cmd.header.addr[paddr_width_p-1:block_offset_lp] != addr_r[paddr_width_p-1:block_offset_lp])
              begin
                state_n = 2;
              end
            else if (io_resp_fifo_ready_lo)
              begin
                case (io_cmd.header.size)
                  e_mem_msg_size_4 : words_n[byte_width_lp*io_cmd_byte_idx+:byte_width_lp*4 ] = io_cmd.data[0+:byte_width_lp*4 ];
                  e_mem_msg_size_8 : words_n[byte_width_lp*io_cmd_byte_idx+:byte_width_lp*8 ] = io_cmd.data[0+:byte_width_lp*8 ];
                  e_mem_msg_size_16: words_n[byte_width_lp*io_cmd_byte_idx+:byte_width_lp*16] = io_cmd.data[0+:byte_width_lp*16];
                  e_mem_msg_size_32: words_n[byte_width_lp*io_cmd_byte_idx+:byte_width_lp*32] = io_cmd.data[0+:byte_width_lp*32];
                  e_mem_msg_size_64: words_n[byte_width_lp*io_cmd_byte_idx+:byte_width_lp*64] = io_cmd.data[0+:byte_width_lp*64];
                  default:;
                endcase
                io_cmd_yumi_lo = 1'b1;
              end
          end
      end
    else if (state_r == 2)
      begin
        mem_cmd_v_lo = 1'b1;
        if (mem_cmd_yumi_i)
          begin
            state_n = 0;
          end
      end
    
  end

endmodule
