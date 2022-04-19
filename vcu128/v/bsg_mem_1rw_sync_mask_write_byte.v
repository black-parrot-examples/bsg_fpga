/*
 * Name:
 *  bsg_mem_1rw_sync_mask_write_byte.v
 *
 * This memory properly maps to Xilinx BRAM with byte-enable writes.
 *
 */

`include "bsg_defines.v"

module bsg_mem_1rw_sync_mask_write_byte
  #(parameter `BSG_INV_PARAM(els_p)
    , parameter addr_width_lp = `BSG_SAFE_CLOG2(els_p)
    , parameter `BSG_INV_PARAM(data_width_p)
    , parameter latch_last_read_p=0
    , parameter write_mask_width_lp = data_width_p>>3
    , parameter enable_clock_gating_p=0
    )
  (input                                               clk_i
   , input                                             reset_i
   , input                                             v_i
   , input                                             w_i
   , input [addr_width_lp-1:0]                         addr_i
   , input [`BSG_SAFE_MINUS(data_width_p, 1):0]        data_i
   , input [`BSG_SAFE_MINUS(write_mask_width_lp, 1):0] write_mask_i
   , output logic [`BSG_SAFE_MINUS(data_width_p, 1):0] data_o
   );

  wire unused = reset_i;

  // data out from RAM
  logic [`BSG_SAFE_MINUS(data_width_p, 1):0] data_lo;

  // last read register
  if (latch_last_read_p) begin: llr
    logic read_en_r;
    wire read_en = v_i & ~w_i;
    bsg_dff
      #(.width_p(1))
      read_en_dff
        (.clk_i(clk_i)
         ,.data_i(read_en)
         ,.data_o(read_en_r)
         );

    bsg_dff_en_bypass
      #(.width_p(data_width_p))
      dff_bypass
        (.clk_i(clk_i)
         ,.en_i(read_en_r)
         ,.data_i(data_lo)
         ,.data_o(data_o)
         );

  end else begin: no_llr
    assign data_o = data_lo;
  end

  // params for byte-enable RAM instance
  localparam col_width_p = 8;
  localparam num_col_p = `BSG_CDIV(data_width_p, col_width_p);

  logic [`BSG_SAFE_MINUS(write_mask_width_lp, 1):0] we;
  assign we = write_mask_i & {write_mask_width_lp{w_i}};

  // instantiate RAM
  bytewrite_bram
    #(.SIZE(els_p)
      ,.ADDR_WIDTH(addr_width_lp)
      ,.COL_WIDTH(col_width_p)
      ,.NB_COL(num_col_p)
      )
    mem_bytewrite
     (.clk(clk_i)
      ,.we(we)
      ,.addr(addr_i)
      ,.data_i(data_i)
      ,.data_o(data_lo)
      );

endmodule

`BSG_ABSTRACT_MODULE(bsg_mem_1rw_sync_mask_write_byte)

