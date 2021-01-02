module bp_unicore_with_axi_wrapper_top
#(
   // BP CONFIG PARAMS
   parameter bp_params_p = 0
   // AXI4-LITE PARAMS
   , parameter axi_lite_addr_width_p   = 32
   , parameter axi_lite_data_width_p   = 64
   , parameter axi_lite_strb_width_lp = axi_lite_data_width_p/8
   
   // AXI4-FULL PARAMS
   , parameter axi_full_addr_width_p   = 64
   , parameter axi_full_data_width_p   = 64
   , parameter axi_full_id_width_p     = 1
   , parameter axi_full_burst_type_p   = 2'b01 //INCR type
   , parameter axi_full_strb_width_lp = axi_full_data_width_p/8
   //, parameter dword_width_lp         = axi_full_data_width_p
 )

(input clk_i
  , input reset_i
  
  //========================Outgoing I/O==========================
  , output [axi_lite_addr_width_p-1:0]  m_axi_lite_awaddr_o
  , output [2:0]                        m_axi_lite_awprot_o
  , output                              m_axi_lite_awvalid_o
  , input                               m_axi_lite_awready_i
  
  , output [axi_lite_data_width_p-1:0]  m_axi_lite_wdata_o
  , output [axi_lite_strb_width_lp-1:0] m_axi_lite_wstrb_o
  , output                              m_axi_lite_wvalid_o
  , input                               m_axi_lite_wready_i
  
  , input [1:0]                         m_axi_lite_bresp_i 
  , input                               m_axi_lite_bvalid_i
  , output                              m_axi_lite_bready_o

  , output [axi_lite_addr_width_p-1:0]  m_axi_lite_araddr_o
  , output [2:0]                        m_axi_lite_arprot_o
  , output                              m_axi_lite_arvalid_o
  , input                               m_axi_lite_arready_i

  , input [axi_lite_data_width_p-1:0]   m_axi_lite_rdata_i
  , input [1:0]                         m_axi_lite_rresp_i
  , input                               m_axi_lite_rvalid_i
  , output                              m_axi_lite_rready_o

  //========================Incoming I/O========================
  , input [axi_lite_addr_width_p-1:0]    s_axi_lite_awaddr_i
  , input [2:0]                          s_axi_lite_awprot_i
  , input                                s_axi_lite_awvalid_i
  , output                               s_axi_lite_awready_o

  , input [axi_lite_data_width_p-1:0]    s_axi_lite_wdata_i
  , input [axi_lite_strb_width_lp-1:0]   s_axi_lite_wstrb_i
  , input                                s_axi_lite_wvalid_i
  , output                               s_axi_lite_wready_o

  , output  [1:0]                        s_axi_lite_bresp_o 
  , output                               s_axi_lite_bvalid_o
  , input                                s_axi_lite_bready_i

  , input [axi_lite_addr_width_p-1:0]    s_axi_lite_araddr_i
  , input [2:0]                          s_axi_lite_arprot_i
  , input                                s_axi_lite_arvalid_i
  , output                               s_axi_lite_arready_o

  , output  [axi_lite_data_width_p-1:0]  s_axi_lite_rdata_o
  , output  [1:0]                        s_axi_lite_rresp_o
  , output                               s_axi_lite_rvalid_o
  , input                                s_axi_lite_rready_i

  //======================Memory Requests======================
  , output  [axi_full_id_width_p-1:0]    m_axi_awid_o   
  , output  [axi_full_addr_width_p-1:0]  m_axi_awaddr_o 
  , output  [7:0]                        m_axi_awlen_o  
  , output  [2:0]                        m_axi_awsize_o 
  , output  [1:0]                        m_axi_awburst_o
  , output  [3:0]                        m_axi_awcache_o
  , output  [2:0]                        m_axi_awprot_o 
  , output  [3:0]                        m_axi_awqos_o  
  , output                               m_axi_awvalid_o
  , input                                m_axi_awready_i

  , output  [axi_full_id_width_p-1:0]    m_axi_wid_o   
  , output  [axi_full_data_width_p-1:0]  m_axi_wdata_o 
  , output  [axi_full_strb_width_lp-1:0] m_axi_wstrb_o 
  , output                               m_axi_wlast_o 
  , output                               m_axi_wvalid_o
  , input                                m_axi_wready_i

  , input [axi_full_id_width_p-1:0]      m_axi_bid_i   
  , input [1:0]                          m_axi_bresp_i 
  , input                                m_axi_bvalid_i
  , output                               m_axi_bready_o

  , output  [axi_full_id_width_p-1:0]    m_axi_arid_o   
  , output  [axi_full_addr_width_p-1:0]  m_axi_araddr_o 
  , output  [7:0]                        m_axi_arlen_o  
  , output  [2:0]                        m_axi_arsize_o 
  , output  [1:0]                        m_axi_arburst_o
  , output  [3:0]                        m_axi_arcache_o
  , output  [2:0]                        m_axi_arprot_o 
  , output  [3:0]                        m_axi_arqos_o  
  , output                               m_axi_arvalid_o
  , input                                m_axi_arready_i

  , input [axi_full_id_width_p-1:0]      m_axi_rid_i   
  , input [axi_full_data_width_p-1:0]    m_axi_rdata_i 
  , input [1:0]                          m_axi_rresp_i 
  , input                                m_axi_rlast_i 
  , input                                m_axi_rvalid_i
  , output                               m_axi_rready_o
  );

 bp_unicore_with_axi_wrapper

 #(.axi_lite_addr_width_p (axi_lite_addr_width_p)
  ,.axi_lite_data_width_p (axi_lite_data_width_p)
  ,.axi_full_addr_width_p (axi_full_addr_width_p)
  ,.axi_full_data_width_p (axi_full_data_width_p)
  ,.axi_full_id_width_p   (axi_full_id_width_p)
  ,.axi_full_burst_type_p (axi_full_burst_type_p)
  ,.bp_params_p           (bp_params_p)
  )

 bp_uni

 (.clk_i(clk_i)
 ,.reset_i(reset_i)

 ,.m_axi_lite_awaddr_o (m_axi_lite_awaddr_o) 
 ,.m_axi_lite_awprot_o (m_axi_lite_awprot_o)
 ,.m_axi_lite_awvalid_o (m_axi_lite_awvalid_o)
 ,.m_axi_lite_awready_i (m_axi_lite_awready_i)
 ,.m_axi_lite_wdata_o(m_axi_lite_wdata_o)
 ,.m_axi_lite_wstrb_o(m_axi_lite_wstrb_o)
 ,.m_axi_lite_wvalid_o(m_axi_lite_wvalid_o)
 ,.m_axi_lite_wready_i(m_axi_lite_wready_i)
 ,.m_axi_lite_bresp_i (m_axi_lite_bresp_i )
 ,.m_axi_lite_bvalid_i(m_axi_lite_bvalid_i)
 ,.m_axi_lite_bready_o(m_axi_lite_bready_o)
 ,.m_axi_lite_araddr_o(m_axi_lite_araddr_o)
 ,.m_axi_lite_arprot_o(m_axi_lite_arprot_o)
 ,.m_axi_lite_arvalid_o(m_axi_lite_arvalid_o)
 ,.m_axi_lite_arready_i(m_axi_lite_arready_i)
 ,.m_axi_lite_rdata_i(m_axi_lite_rdata_i)
 ,.m_axi_lite_rresp_i(m_axi_lite_rresp_i)
 ,.m_axi_lite_rvalid_i(m_axi_lite_rvalid_i)
 ,.m_axi_lite_rready_o(m_axi_lite_rready_o)

 ,.s_axi_lite_awaddr_i(s_axi_lite_awaddr_i)
 ,.s_axi_lite_awprot_i(s_axi_lite_awprot_i)
 ,.s_axi_lite_awvalid_i(s_axi_lite_awvalid_i)
 ,.s_axi_lite_awready_o(s_axi_lite_awready_o)
 ,.s_axi_lite_wdata_i(s_axi_lite_wdata_i)
 ,.s_axi_lite_wstrb_i(s_axi_lite_wstrb_i)
 ,.s_axi_lite_wvalid_i(s_axi_lite_wvalid_i)
 ,.s_axi_lite_wready_o(s_axi_lite_wready_o)
 ,.s_axi_lite_bresp_o (s_axi_lite_bresp_o )
 ,.s_axi_lite_bvalid_o(s_axi_lite_bvalid_o)
 ,.s_axi_lite_bready_i(s_axi_lite_bready_i)
 ,.s_axi_lite_araddr_i(s_axi_lite_araddr_i)
 ,.s_axi_lite_arprot_i(s_axi_lite_arprot_i)
 ,.s_axi_lite_arvalid_i(s_axi_lite_arvalid_i)
 ,.s_axi_lite_arready_o(s_axi_lite_arready_o)
 ,.s_axi_lite_rdata_o(s_axi_lite_rdata_o)
 ,.s_axi_lite_rresp_o(s_axi_lite_rresp_o)
 ,.s_axi_lite_rvalid_o(s_axi_lite_rvalid_o)
 ,.s_axi_lite_rready_i(s_axi_lite_rready_i)

 ,.m_axi_awid_o   (m_axi_awid_o   )
 ,.m_axi_awaddr_o (m_axi_awaddr_o )
 ,.m_axi_awlen_o  (m_axi_awlen_o  )
 ,.m_axi_awsize_o (m_axi_awsize_o )
 ,.m_axi_awburst_o(m_axi_awburst_o)
 ,.m_axi_awcache_o(m_axi_awcache_o)
 ,.m_axi_awprot_o (m_axi_awprot_o )
 ,.m_axi_awqos_o  (m_axi_awqos_o  )
 ,.m_axi_awvalid_o(m_axi_awvalid_o)
 ,.m_axi_awready_i(m_axi_awready_i)
 ,.m_axi_wid_o   (m_axi_wid_o   )
 ,.m_axi_wdata_o (m_axi_wdata_o )
 ,.m_axi_wstrb_o (m_axi_wstrb_o )
 ,.m_axi_wlast_o (m_axi_wlast_o )
 ,.m_axi_wvalid_o(m_axi_wvalid_o)
 ,.m_axi_wready_i(m_axi_wready_i)
 ,.m_axi_bid_i   (m_axi_bid_i   )
 ,.m_axi_bresp_i (m_axi_bresp_i )
 ,.m_axi_bvalid_i(m_axi_bvalid_i)
 ,.m_axi_bready_o(m_axi_bready_o)
 ,.m_axi_arid_o   (m_axi_arid_o   )
 ,.m_axi_araddr_o (m_axi_araddr_o )
 ,.m_axi_arlen_o  (m_axi_arlen_o  )
 ,.m_axi_arsize_o (m_axi_arsize_o )
 ,.m_axi_arburst_o(m_axi_arburst_o)
 ,.m_axi_arcache_o(m_axi_arcache_o)
 ,.m_axi_arprot_o (m_axi_arprot_o )
 ,.m_axi_arqos_o  (m_axi_arqos_o  )
 ,.m_axi_arvalid_o(m_axi_arvalid_o)
 ,.m_axi_arready_i(m_axi_arready_i)
 ,.m_axi_rid_i   (m_axi_rid_i   )
 ,.m_axi_rdata_i (m_axi_rdata_i )
 ,.m_axi_rresp_i (m_axi_rresp_i )
 ,.m_axi_rlast_i (m_axi_rlast_i )
 ,.m_axi_rvalid_i(m_axi_rvalid_i)
 ,.m_axi_rready_o(m_axi_rready_o)
 );

endmodule