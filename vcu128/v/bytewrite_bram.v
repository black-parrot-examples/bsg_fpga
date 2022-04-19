// BRAM with byte-enable on write
// from Xilinx example code

module bytewrite_bram
  #(parameter SIZE = 1024
    , parameter ADDR_WIDTH = 10
    , parameter COL_WIDTH = 8
    , parameter NB_COL = 4
    )
  (input clk
   , input [NB_COL-1:0] we
   , input [ADDR_WIDTH-1:0] addr
   , input [NB_COL*COL_WIDTH-1:0] data_i
   , output reg [NB_COL*COL_WIDTH-1:0] data_o
   );

  (* ram_style = "block" *) reg [NB_COL*COL_WIDTH-1:0] RAM [SIZE-1:0];

  always @(posedge clk) begin
    data_o <= RAM[addr];
  end

  generate genvar i;
  for (i = 0; i < NB_COL; i = i+1) begin
    always @(posedge clk) begin
      if (we[i]) begin
        RAM[addr][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= data_i[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
      end
    end
  end
  endgenerate
endmodule
