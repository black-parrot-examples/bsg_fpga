module bp_nonsynth_tb_top_wrapper

#( parameter icache_trace_p              = 0
  ,parameter dcache_trace_p              = 0
  ,parameter lce_trace_p                 = 0
  ,parameter cce_trace_p                 = 0
  ,parameter dram_trace_p                = 0
  ,parameter vm_trace_p                  = 0
  ,parameter cmt_trace_p                 = 0
  ,parameter core_profile_p              = 0
  ,parameter pc_profile_p                = 0
  ,parameter br_profile_p                = 0
  ,parameter cosim_p                     = 0

  ,parameter checkpoint_p                = 0
  ,parameter cosim_memsize_p             = 0
  ,parameter cosim_cfg_file_p            = "prog.cfg"
  ,parameter cosim_instr_p               = 0
  ,parameter warmup_instr_p              = 0

  ,parameter  axi_data_width_p             = 64
  ,parameter  axi_addr_width_p             = 32
  ,parameter  axi_strb_width_lp            = 8)

 (input   clk_i
 , input reset_i

 //=========================NBF AXI Wrapper=================
 // WRITE ADDRESS CHANNEL SIGNALS
 , output [axi_addr_width_p-1:0]        m_axi_lite_awaddr_o
 , output [2:0]                         m_axi_lite_awprot_o
 , output                               m_axi_lite_awvalid_o
 , input                                m_axi_lite_awready_i
 // WRITE DATA CHANNEL SIGNALS
 , output [axi_data_width_p-1:0]        m_axi_lite_wdata_o
 , output [axi_strb_width_lp-1:0]       m_axi_lite_wstrb_o
 , output                               m_axi_lite_wvalid_o
 , input                                m_axi_lite_wready_i
 // WRITE RESPONSE CHANNEL SIGNALS
 , input [1:0]                          m_axi_lite_bresp_i  
 , input                                m_axi_lite_bvalid_i 
 , output                               m_axi_lite_bready_o
 // READ ADDRESS CHANNEL SIGNALS
 , output  [axi_addr_width_p-1:0]       m_axi_lite_araddr_o
 , output  [2:0]                        m_axi_lite_arprot_o
 , output                               m_axi_lite_arvalid_o
 , input                                m_axi_lite_arready_i
 // READ DATA CHANNEL SIGNALS
 , input [axi_data_width_p-1:0]         m_axi_lite_rdata_i
 , input [1:0]                          m_axi_lite_rresp_i
 , input                                m_axi_lite_rvalid_i
 , output                               m_axi_lite_rready_o
 //========================HOST AXI Wrapper=================
 // WRITE ADDRESS CHANNEL SIGNALS
 , input [axi_addr_width_p-1:0]        s_axi_lite_awaddr_i
 , input [2:0]                         s_axi_lite_awprot_i
 , input                               s_axi_lite_awvalid_i
 , output                              s_axi_lite_awready_o
 // WRITE DATA CHANNEL SIGNALS
 , input [axi_data_width_p-1:0]        s_axi_lite_wdata_i
 , input [axi_strb_width_lp-1:0]       s_axi_lite_wstrb_i
 , input                               s_axi_lite_wvalid_i
 , output                              s_axi_lite_wready_o
 // WRITE RESPONSE CHANNEL SIGNALS
 , output [1:0]                        s_axi_lite_bresp_o 
 , output                              s_axi_lite_bvalid_o
 , input                               s_axi_lite_bready_i
 // READ ADDRESS CHANNEL SIGNALS
 , input [axi_addr_width_p-1:0]        s_axi_lite_araddr_i
 , input [2:0]                         s_axi_lite_arprot_i
 , input                               s_axi_lite_arvalid_i
 , output                              s_axi_lite_arready_o
 // READ DATA CHANNEL SIGNALS
 , output  [axi_data_width_p-1:0]      s_axi_lite_rdata_o
 , output  [1:0]                       s_axi_lite_rresp_o
 , output                              s_axi_lite_rvalid_o
 , input                               s_axi_lite_rready_i
 );

bp_nonsynth_tb_top 
#( .icache_trace_p(icache_trace_p   )
  ,.dcache_trace_p(dcache_trace_p   )
  ,.lce_trace_p   (lce_trace_p      )
  ,.cce_trace_p   (cce_trace_p      )
  ,.dram_trace_p  (dram_trace_p     )
  ,.vm_trace_p    (vm_trace_p       )
  ,.cmt_trace_p   (cmt_trace_p      )
  ,.core_profile_p(core_profile_p   )
  ,.pc_profile_p  (pc_profile_p     )
  ,.br_profile_p  (br_profile_p     )
  ,.cosim_p       (cosim_p          )

  ,.checkpoint_p    (checkpoint_p    ) 
  ,.cosim_memsize_p (cosim_memsize_p ) 
  ,.cosim_cfg_file_p(cosim_cfg_file_p) 
  ,.cosim_instr_p   (cosim_instr_p   ) 
  ,.warmup_instr_p  (warmup_instr_p  ) 

  ,.axi_data_width_p (axi_data_width_p)
  ,.axi_addr_width_p (axi_addr_width_p)
 )

bp_nonsynth_pkg

( .clk_i(clk_i)
  ,.reset_i(reset_i)	
  //===========NBF AXI==================
  ,.m_axi_lite_awaddr_o  (m_axi_lite_awaddr_o )
  ,.m_axi_lite_awprot_o  (m_axi_lite_awprot_o )
  ,.m_axi_lite_awvalid_o (m_axi_lite_awvalid_o)
  ,.m_axi_lite_awready_i (m_axi_lite_awready_i)
  ,.m_axi_lite_wdata_o   (m_axi_lite_wdata_o  )
  ,.m_axi_lite_wstrb_o   (m_axi_lite_wstrb_o  )
  ,.m_axi_lite_wvalid_o  (m_axi_lite_wvalid_o )
  ,.m_axi_lite_wready_i  (m_axi_lite_wready_i )
  ,.m_axi_lite_bresp_i   (m_axi_lite_bresp_i  )
  ,.m_axi_lite_bvalid_i  (m_axi_lite_bvalid_i )
  ,.m_axi_lite_bready_o  (m_axi_lite_bready_o )
  ,.m_axi_lite_araddr_o  (m_axi_lite_araddr_o )
  ,.m_axi_lite_arprot_o  (m_axi_lite_arprot_o )
  ,.m_axi_lite_arvalid_o (m_axi_lite_arvalid_o)
  ,.m_axi_lite_arready_i (m_axi_lite_arready_i)
  ,.m_axi_lite_rdata_i   (m_axi_lite_rdata_i  )
  ,.m_axi_lite_rresp_i   (m_axi_lite_rresp_i  )
  ,.m_axi_lite_rvalid_i  (m_axi_lite_rvalid_i )
  ,.m_axi_lite_rready_o  (m_axi_lite_rready_o )
  //============HOST AXI===============
  ,.s_axi_lite_awaddr_i  (s_axi_lite_awaddr_i )
  ,.s_axi_lite_awprot_i  (s_axi_lite_awprot_i )
  ,.s_axi_lite_awvalid_i (s_axi_lite_awvalid_i)
  ,.s_axi_lite_awready_o (s_axi_lite_awready_o)
  ,.s_axi_lite_wdata_i   (s_axi_lite_wdata_i  )
  ,.s_axi_lite_wstrb_i   (s_axi_lite_wstrb_i  )
  ,.s_axi_lite_wvalid_i  (s_axi_lite_wvalid_i )
  ,.s_axi_lite_wready_o  (s_axi_lite_wready_o )
  ,.s_axi_lite_bresp_o   (s_axi_lite_bresp_o  )
  ,.s_axi_lite_bvalid_o  (s_axi_lite_bvalid_o )
  ,.s_axi_lite_bready_i  (s_axi_lite_bready_i )
  ,.s_axi_lite_araddr_i  (s_axi_lite_araddr_i )
  ,.s_axi_lite_arprot_i  (s_axi_lite_arprot_i )
  ,.s_axi_lite_arvalid_i (s_axi_lite_arvalid_i)
  ,.s_axi_lite_arready_o (s_axi_lite_arready_o)
  ,.s_axi_lite_rdata_o   (s_axi_lite_rdata_o  )
  ,.s_axi_lite_rresp_o   (s_axi_lite_rresp_o  )
  ,.s_axi_lite_rvalid_o  (s_axi_lite_rvalid_o )
  ,.s_axi_lite_rready_i  (s_axi_lite_rready_i )
  
  );

endmodule