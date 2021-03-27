//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
//Date        : Sun Mar 22 22:52:07 2020
//Host        : dhcp196-212.ece.uw.edu running 64-bit CentOS Linux release 7.7.1908 (Core)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

`include "bp_common_defines.svh"
`include "bp_fe_defines.svh"
`include "bp_be_defines.svh"
`include "bp_me_defines.svh"
`include "bp_top_defines.svh"

module design_1_wrapper

 import bp_common_pkg::*;
 import bp_be_pkg::*;
 import bp_me_pkg::*;
 import bsg_noc_pkg::*;
 import bsg_wormhole_router_pkg::*;
 import bsg_cache_pkg::*;

 #(parameter bp_params_e bp_params_p = e_bp_multicore_1_cfg
   `declare_bp_proc_params(bp_params_p)
   `declare_bp_bedrock_mem_if_widths(paddr_width_p, cce_block_width_p, lce_id_width_p, lce_assoc_p, cce)
   
  ,parameter load_nbf_p = 1
   
  ,localparam cache_addr_width_p = 30 - `BSG_SAFE_CLOG2(1) // one cache_dma
  ,localparam axi_id_width_p     = 1
  ,localparam axi_addr_width_p   = 30
  ,localparam axi_data_width_p   = 256
  ,localparam axi_burst_len_p    = 2
  
  ,localparam cce_instr_ram_addr_width_lp = `BSG_SAFE_CLOG2(num_cce_instr_ram_els_p)
  ,localparam cce_ucode_filename_lp = "mesi.mem"
  )

   (pci_express_x4_rxn,
    pci_express_x4_rxp,
    pci_express_x4_txn,
    pci_express_x4_txp,

    PCIE0_FPGA_CPERSTN,PCIE0_FPGA_CPRSNT,PCIE0_FPGA_CPWRON,PCIE0_FPGA_CWAKE, PCIE0_SWITCH,
    PCIE1_FPGA_CPERSTN,PCIE1_FPGA_CPRSNT,PCIE1_FPGA_CPWRON,PCIE1_FPGA_CWAKE, PCIE1_SWITCH,
    
    pcie_refclk_clk_n,
    pcie_refclk_clk_p,
    rstn,
    led);
  input [3:0]pci_express_x4_rxn;
  input [3:0]pci_express_x4_rxp;
  output [3:0]pci_express_x4_txn;
  output [3:0]pci_express_x4_txp;

  inout PCIE0_FPGA_CPERSTN,PCIE0_FPGA_CPRSNT,PCIE0_FPGA_CPWRON,PCIE0_FPGA_CWAKE, PCIE0_SWITCH;
  inout PCIE1_FPGA_CPERSTN,PCIE1_FPGA_CPRSNT,PCIE1_FPGA_CPWRON,PCIE1_FPGA_CWAKE, PCIE1_SWITCH;

  input [0:0]pcie_refclk_clk_n;
  input [0:0]pcie_refclk_clk_p;
  input rstn;
  output [3:0] led;

  wire [31:0]m_axi_lite_araddr;
  wire [2:0]m_axi_lite_arprot;
  wire m_axi_lite_arready;
  wire m_axi_lite_arvalid;
  wire [31:0]m_axi_lite_awaddr;
  wire [2:0]m_axi_lite_awprot;
  wire m_axi_lite_awready;
  wire m_axi_lite_awvalid;
  wire m_axi_lite_bready;
  wire [1:0]m_axi_lite_bresp;
  wire m_axi_lite_bvalid;
  wire [31:0]m_axi_lite_rdata;
  wire m_axi_lite_rready;
  wire [1:0]m_axi_lite_rresp;
  wire m_axi_lite_rvalid;
  wire [31:0]m_axi_lite_wdata;
  wire m_axi_lite_wready;
  wire [3:0]m_axi_lite_wstrb;
  wire m_axi_lite_wvalid;

  wire apb_complete;
  wire mig_clk;
  wire [0:0]mig_rstn;

  wire [3:0]pci_express_x4_rxn;
  wire [3:0]pci_express_x4_rxp;
  wire [3:0]pci_express_x4_txn;
  wire [3:0]pci_express_x4_txp;

  wire pcie_clk;
  wire pcie_lnk_up;
  wire pcie_perstn;
  
  wire PCIE0_FPGA_CPERSTN,PCIE0_FPGA_CPRSNT,PCIE0_FPGA_CPWRON,PCIE0_FPGA_CWAKE, PCIE0_SWITCH;
  wire PCIE1_FPGA_CPERSTN,PCIE1_FPGA_CPRSNT,PCIE1_FPGA_CPWRON,PCIE1_FPGA_CWAKE, PCIE1_SWITCH;
  
  assign PCIE0_FPGA_CPRSNT = 1'b1;
  assign PCIE1_FPGA_CPRSNT = 1'b1;
  assign PCIE0_FPGA_CWAKE  = 1'b0;
  assign PCIE1_FPGA_CWAKE  = 1'b0;
  assign pcie_perstn = !PCIE0_FPGA_CPERSTN;

  wire [0:0]pcie_refclk_clk_n;
  wire [0:0]pcie_refclk_clk_p;

  wire [0:0]pcie_rstn;
  wire rstn;
  wire [3:0] led;

  wire [21:0]s_apb_paddr = '0;
  wire s_apb_penable = 1'b0;
  wire [31:0]s_apb_prdata;
  wire s_apb_pready;
  wire s_apb_psel = 1'b0;
  wire s_apb_pslverr;
  wire [31:0]s_apb_pwdata = '0;
  wire s_apb_pwrite = 1'b0;

  wire [29:0]s_axi_araddr;
  wire [1:0]s_axi_arburst;
  wire [3:0]s_axi_arcache;
  wire [0:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire [0:0]s_axi_arlock;
  wire [2:0]s_axi_arprot;
  wire [3:0]s_axi_arqos;
  wire s_axi_arready;
  wire [3:0]s_axi_arregion;
  wire [2:0]s_axi_arsize;
  wire s_axi_arvalid;

  wire [29:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [3:0]s_axi_awcache;
  wire [0:0]s_axi_awid;
  wire [7:0]s_axi_awlen;
  wire [0:0]s_axi_awlock;
  wire [2:0]s_axi_awprot;
  wire [3:0]s_axi_awqos;
  wire s_axi_awready;
  wire [3:0]s_axi_awregion;
  wire [2:0]s_axi_awsize;
  wire s_axi_awvalid;

  wire [0:0]s_axi_bid;
  wire s_axi_bready;
  wire [1:0]s_axi_bresp;
  wire s_axi_bvalid;

  wire [255:0]s_axi_rdata;
  wire [0:0]s_axi_rid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire [1:0]s_axi_rresp;
  wire s_axi_rvalid;

  wire [255:0]s_axi_wdata;
  wire s_axi_wlast;
  wire s_axi_wready;
  wire [31:0]s_axi_wstrb;
  wire s_axi_wvalid;


  wire m_axi_lite_v_lo, m_axi_lite_yumi_li;
  wire [31:0] m_axi_lite_addr_lo, m_axi_lite_data_lo;
  wire m_axi_lite_v_li, m_axi_lite_ready_lo;
  wire [31:0] m_axi_lite_data_li;
  
  // LEDs
  assign led[0] = pcie_lnk_up;
  assign led[1] = apb_complete;
  
  // mig_reset
  logic mig_reset;
  bsg_dff #(.width_p(1)) mig_dff
  (.clk_i (mig_clk)
  ,.data_i(~mig_rstn | ~apb_complete)
  ,.data_o(mig_reset)
  );
  
  // m_axi_lite adapter
  bsg_m_axi_lite_to_fifo
 #(.addr_width_p(32)
  ,.data_width_p(32)
  ,.buffer_size_p(16)
  ,.num_repeater_nodes_p(4)
  ) m_axi_lite_adapter
  (.pcie_clk_i  (pcie_clk)
  ,.pcie_reset_i(~pcie_rstn)
  
  // read address
  ,.araddr_i (m_axi_lite_araddr)
  ,.arprot_i (m_axi_lite_arprot)
  ,.arready_o(m_axi_lite_arready)
  ,.arvalid_i(m_axi_lite_arvalid)
  // read data
  ,.rdata_o  (m_axi_lite_rdata)
  ,.rready_i (m_axi_lite_rready)
  ,.rresp_o  (m_axi_lite_rresp)
  ,.rvalid_o (m_axi_lite_rvalid)
  // write address
  ,.awaddr_i (m_axi_lite_awaddr)
  ,.awprot_i (m_axi_lite_awprot)
  ,.awready_o(m_axi_lite_awready)
  ,.awvalid_i(m_axi_lite_awvalid)
  // write data
  ,.wdata_i  (m_axi_lite_wdata)
  ,.wready_o (m_axi_lite_wready)
  ,.wstrb_i  (m_axi_lite_wstrb)
  ,.wvalid_i (m_axi_lite_wvalid)
  // write response
  ,.bready_i (m_axi_lite_bready)
  ,.bresp_o  (m_axi_lite_bresp)
  ,.bvalid_o (m_axi_lite_bvalid)
  
  ,.clk_i    (mig_clk)
  ,.reset_i  (mig_reset)
  // fifo output
  ,.v_o      (m_axi_lite_v_lo)
  ,.addr_o   (m_axi_lite_addr_lo)
  ,.data_o   (m_axi_lite_data_lo)
  ,.yumi_i   (m_axi_lite_yumi_li)
  // fifo input
  ,.v_i      (m_axi_lite_v_li)
  ,.data_i   (m_axi_lite_data_li)
  ,.ready_o  (m_axi_lite_ready_lo)
  );
  
  `declare_bp_bedrock_mem_if(paddr_width_p, cce_block_width_p, lce_id_width_p, lce_assoc_p, cce)
  bp_bedrock_cce_mem_msg_s proc_cmd_lo;
  logic proc_cmd_v_lo, proc_cmd_ready_li;
  bp_bedrock_cce_mem_msg_s proc_resp_li;
  logic proc_resp_v_li, proc_resp_yumi_lo;
  
  bp_bedrock_cce_mem_msg_s proc_cmd_li;
  logic proc_cmd_v_li, proc_cmd_yumi_lo;
  bp_bedrock_cce_mem_msg_s proc_resp_lo;
  logic proc_resp_v_lo, proc_resp_ready_li;

  `declare_bsg_cache_wh_header_flit_s(mem_noc_flit_width_p, mem_noc_cord_width_p, mem_noc_len_width_p, mem_noc_cid_width_p);
  `declare_bsg_cache_dma_pkt_s(caddr_width_p);
  bsg_cache_dma_pkt_s [num_cce_p-1:0] dma_pkt_lo;
  logic [num_cce_p-1:0] dma_pkt_v_lo, dma_pkt_yumi_li;
  logic [num_cce_p-1:0][l2_fill_width_p-1:0] dma_data_lo;
  logic [num_cce_p-1:0] dma_data_v_lo, dma_data_yumi_li;
  logic [num_cce_p-1:0][l2_fill_width_p-1:0] dma_data_li;
  logic [num_cce_p-1:0] dma_data_v_li, dma_data_ready_and_lo;

// Chip
if (multicore_p == 1)
  begin : multicore
      `declare_bsg_ready_and_link_sif_s(io_noc_flit_width_p, bp_io_noc_ral_link_s);
      `declare_bsg_ready_and_link_sif_s(mem_noc_flit_width_p, bp_mem_noc_ral_link_s);
      bp_io_noc_ral_link_s proc_cmd_link_li, proc_cmd_link_lo;
      bp_io_noc_ral_link_s proc_resp_link_li, proc_resp_link_lo;
      bp_mem_noc_ral_link_s [mc_x_dim_p-1:0] dram_cmd_link_lo, dram_resp_link_li;
      bp_io_noc_ral_link_s stub_cmd_link, stub_resp_link;
      wire [io_noc_did_width_p-1:0] dram_did_li = '1;
      wire [io_noc_did_width_p-1:0] proc_did_li = 1;
    
    bp_multicore
     #(.bp_params_p(bp_params_p))
     proc
      (.core_clk_i(mig_clk)
       ,.core_reset_i(mig_reset)
       
       ,.coh_clk_i(mig_clk)
       ,.coh_reset_i(mig_reset)
    
       ,.io_clk_i(mig_clk)
       ,.io_reset_i(mig_reset)
    
       ,.mem_clk_i(mig_clk)
       ,.mem_reset_i(mig_reset)
    
       ,.my_did_i(proc_did_li)
       ,.host_did_i(dram_did_li)
    
       ,.io_cmd_link_i({proc_cmd_link_li, stub_cmd_link})
       ,.io_cmd_link_o({proc_cmd_link_lo, stub_cmd_link})
    
       ,.io_resp_link_i({proc_resp_link_li, stub_resp_link})
       ,.io_resp_link_o({proc_resp_link_lo, stub_resp_link})
    
       ,.dram_cmd_link_o(dram_cmd_link_lo)
       ,.dram_resp_link_i(dram_resp_link_li)
       );
    
    wire [io_noc_cord_width_p-1:0] dst_cord_lo = 1;
    
    logic proc_cmd_ready_lo, proc_resp_ready_lo;
    bp_me_cce_to_mem_link_bidir
     #(.bp_params_p(bp_params_p)
       ,.num_outstanding_req_p(io_noc_max_credits_p)
       ,.flit_width_p(io_noc_flit_width_p)
       ,.cord_width_p(io_noc_cord_width_p)
       ,.cid_width_p(io_noc_cid_width_p)
       ,.len_width_p(io_noc_len_width_p)
       )
     host_link
      (.clk_i(mig_clk)
       ,.reset_i(mig_reset)
    
       ,.mem_cmd_i(proc_cmd_li)
       ,.mem_cmd_v_i(proc_cmd_ready_lo & proc_cmd_v_li)
       ,.mem_cmd_ready_o(proc_cmd_ready_lo)
    
       ,.mem_resp_o(proc_resp_lo)
       ,.mem_resp_v_o(proc_resp_v_lo)
       ,.mem_resp_yumi_i(proc_resp_ready_li & proc_resp_v_lo)
    
       ,.my_cord_i(io_noc_cord_width_p'(dram_did_li))
       ,.my_cid_i('0)
       ,.dst_cord_i(dst_cord_lo)
       ,.dst_cid_i('0)
    
       ,.mem_cmd_o(proc_cmd_lo)
       ,.mem_cmd_v_o(proc_cmd_v_lo)
       ,.mem_cmd_yumi_i(proc_cmd_ready_li & proc_cmd_v_lo)
    
       ,.mem_resp_i(proc_resp_li)
       ,.mem_resp_v_i(proc_resp_ready_lo & proc_resp_v_li)
       ,.mem_resp_ready_o(proc_resp_ready_lo)
    
       ,.cmd_link_i(proc_cmd_link_lo)
       ,.cmd_link_o(proc_cmd_link_li)
       ,.resp_link_i(proc_resp_link_lo)
       ,.resp_link_o(proc_resp_link_li)
       );
      assign proc_cmd_yumi_lo = proc_cmd_ready_lo & proc_cmd_v_li;
      assign proc_resp_yumi_lo = proc_resp_ready_lo & proc_resp_v_li;
    
      localparam cce_per_col_lp = num_cce_p/mc_x_dim_p;
      for (genvar i = 0; i < mc_x_dim_p; i++)
        begin : column
          bsg_cache_wh_header_flit_s header_flit;
          assign header_flit = dram_cmd_link_lo[i];
          wire [`BSG_SAFE_CLOG2(cce_per_col_lp)-1:0] dma_id_li = header_flit.src_cord-1'b1;
          bsg_wormhole_to_cache_dma_fanout
           #(.wh_flit_width_p(mem_noc_flit_width_p)
             ,.wh_cid_width_p(mem_noc_cid_width_p)
             ,.wh_len_width_p(mem_noc_len_width_p)
             ,.wh_cord_width_p(mem_noc_cord_width_p)
    
             ,.num_dma_p(cce_per_col_lp)
             ,.dma_addr_width_p(caddr_width_p)
             ,.dma_burst_len_p(l2_block_size_in_fill_p)
             )
           wh_to_cache_dma
            (.clk_i(mig_clk)
             ,.reset_i(mig_reset)
    
             ,.wh_link_sif_i(dram_cmd_link_lo[i])
             ,.wh_dma_id_i(dma_id_li)
             ,.wh_link_sif_o(dram_resp_link_li[i])
    
             ,.dma_pkt_o(dma_pkt_lo[i*cce_per_col_lp+:cce_per_col_lp])
             ,.dma_pkt_v_o(dma_pkt_v_lo[i*cce_per_col_lp+:cce_per_col_lp])
             ,.dma_pkt_yumi_i(dma_pkt_yumi_li[i*cce_per_col_lp+:cce_per_col_lp])
    
             ,.dma_data_i(dma_data_li[i*cce_per_col_lp+:cce_per_col_lp])
             ,.dma_data_v_i(dma_data_v_li[i*cce_per_col_lp+:cce_per_col_lp])
             ,.dma_data_ready_and_o(dma_data_ready_and_lo[i*cce_per_col_lp+:cce_per_col_lp])
    
             ,.dma_data_o(dma_data_lo[i*cce_per_col_lp+:cce_per_col_lp])
             ,.dma_data_v_o(dma_data_v_lo[i*cce_per_col_lp+:cce_per_col_lp])
             ,.dma_data_yumi_i(dma_data_yumi_li[i*cce_per_col_lp+:cce_per_col_lp])
             );
        end
  end

  logic nbf_done_lo;

  // pcie stream host (NBF and MMIO)
  assign led[3] = nbf_done_lo;
  
  bp_stream_host
 #(.bp_params_p(bp_params_p)
  ,.stream_addr_width_p(32)
  ,.stream_data_width_p(32)
  ) host        
  (.clk_i          (mig_clk)
  ,.reset_i        (mig_reset)
  ,.prog_done_o    (nbf_done_lo)
  
  ,.io_cmd_i       (proc_cmd_lo)
  ,.io_cmd_v_i     (proc_cmd_v_lo)
  ,.io_cmd_ready_o (proc_cmd_ready_li)

  ,.io_resp_o      (proc_resp_li)
  ,.io_resp_v_o    (proc_resp_v_li)
  ,.io_resp_yumi_i (proc_resp_yumi_lo)

  ,.io_cmd_o       (proc_cmd_li)
  ,.io_cmd_v_o     (proc_cmd_v_li)
  ,.io_cmd_yumi_i  (proc_cmd_yumi_lo)

  ,.io_resp_i      (proc_resp_lo)
  ,.io_resp_v_i    (proc_resp_v_lo)
  ,.io_resp_ready_o(proc_resp_ready_li)

  ,.stream_v_i     (m_axi_lite_v_lo)
  ,.stream_addr_i  (m_axi_lite_addr_lo)
  ,.stream_data_i  (m_axi_lite_data_lo)
  ,.stream_yumi_o  (m_axi_lite_yumi_li)
                   
  ,.stream_v_o     (m_axi_lite_v_li)
  ,.stream_data_o  (m_axi_lite_data_li)
  ,.stream_ready_i (m_axi_lite_ready_lo)
  );
  
  // s_axi port
  // not supported
  assign s_axi_arqos    = '0;
  assign s_axi_arregion = '0;
  assign s_axi_awqos    = '0;
  assign s_axi_awregion = '0;

  // Trim dma_pkt for axi remap
  logic [num_cce_p-1:0][cache_addr_width_p+1-1:0] cache_dma_pkt_lo;
  for (genvar i = 0; i < num_cce_p; i++)
    begin : dma_trim
      assign cache_dma_pkt_lo[i] = {dma_pkt_lo[i].write_not_read, dma_pkt_lo[i][0+:cache_addr_width_p]};
    end

  bsg_cache_to_axi 
 #(.addr_width_p         (cache_addr_width_p)
  ,.block_size_in_words_p(l2_block_size_in_fill_p)
  ,.data_width_p         (l2_fill_width_p)
  ,.num_cache_p          (num_cce_p)
  ,.axi_id_width_p       (axi_id_width_p)
  ,.axi_addr_width_p     (axi_addr_width_p)
  ,.axi_data_width_p     (axi_data_width_p)
  ,.axi_burst_len_p      (axi_burst_len_p)
  ) cache_to_axi 
  (.clk_i  (mig_clk)
  ,.reset_i(mig_reset)
  
  ,.dma_pkt_i       (cache_dma_pkt_lo)
  ,.dma_pkt_v_i     (dma_pkt_v_lo)
  ,.dma_pkt_yumi_o  (dma_pkt_yumi_li)
  
  ,.dma_data_o      (dma_data_li)
  ,.dma_data_v_o    (dma_data_v_li)
  ,.dma_data_ready_i(dma_data_ready_and_lo)
  
  ,.dma_data_i      (dma_data_lo)
  ,.dma_data_v_i    (dma_data_v_lo)
  ,.dma_data_yumi_o (dma_data_yumi_li)

  ,.axi_awid_o      (s_axi_awid)
  ,.axi_awaddr_o    (s_axi_awaddr)
  ,.axi_awlen_o     (s_axi_awlen)
  ,.axi_awsize_o    (s_axi_awsize)
  ,.axi_awburst_o   (s_axi_awburst)
  ,.axi_awcache_o   (s_axi_awcache)
  ,.axi_awprot_o    (s_axi_awprot)
  ,.axi_awlock_o    (s_axi_awlock)
  ,.axi_awvalid_o   (s_axi_awvalid)
  ,.axi_awready_i   (s_axi_awready)
                    
  ,.axi_wdata_o     (s_axi_wdata)
  ,.axi_wstrb_o     (s_axi_wstrb)
  ,.axi_wlast_o     (s_axi_wlast)
  ,.axi_wvalid_o    (s_axi_wvalid)
  ,.axi_wready_i    (s_axi_wready)
                    
  ,.axi_bid_i       (s_axi_bid)
  ,.axi_bresp_i     (s_axi_bresp)
  ,.axi_bvalid_i    (s_axi_bvalid)
  ,.axi_bready_o    (s_axi_bready)
                    
  ,.axi_arid_o      (s_axi_arid)
  ,.axi_araddr_o    (s_axi_araddr)
  ,.axi_arlen_o     (s_axi_arlen)
  ,.axi_arsize_o    (s_axi_arsize)
  ,.axi_arburst_o   (s_axi_arburst)
  ,.axi_arcache_o   (s_axi_arcache)
  ,.axi_arprot_o    (s_axi_arprot)
  ,.axi_arlock_o    (s_axi_arlock)
  ,.axi_arvalid_o   (s_axi_arvalid)
  ,.axi_arready_i   (s_axi_arready)
                    
  ,.axi_rid_i       (s_axi_rid)
  ,.axi_rdata_i     (s_axi_rdata)
  ,.axi_rresp_i     (s_axi_rresp)
  ,.axi_rlast_i     (s_axi_rlast)
  ,.axi_rvalid_i    (s_axi_rvalid)
  ,.axi_rready_o    (s_axi_rready)
  );
  
  // LED breathing
  logic led_breath;
  logic [31:0] led_counter_r;
  assign led[2] = led_breath;
  always_ff @(posedge mig_clk)
    if (mig_reset)
      begin
        led_counter_r <= '0;
        led_breath <= 1'b0;
      end
    else
      begin
        led_counter_r <= (led_counter_r == 32'd12500000)? '0 : led_counter_r + 1;
        led_breath <= (led_counter_r == 32'd12500000)? ~led_breath : led_breath;
      end


  design_1 design_1_i
       (.apb_complete(apb_complete),
        .m_axi_lite_araddr(m_axi_lite_araddr),
        .m_axi_lite_arprot(m_axi_lite_arprot),
        .m_axi_lite_arready(m_axi_lite_arready),
        .m_axi_lite_arvalid(m_axi_lite_arvalid),
        .m_axi_lite_awaddr(m_axi_lite_awaddr),
        .m_axi_lite_awprot(m_axi_lite_awprot),
        .m_axi_lite_awready(m_axi_lite_awready),
        .m_axi_lite_awvalid(m_axi_lite_awvalid),
        .m_axi_lite_bready(m_axi_lite_bready),
        .m_axi_lite_bresp(m_axi_lite_bresp),
        .m_axi_lite_bvalid(m_axi_lite_bvalid),
        .m_axi_lite_rdata(m_axi_lite_rdata),
        .m_axi_lite_rready(m_axi_lite_rready),
        .m_axi_lite_rresp(m_axi_lite_rresp),
        .m_axi_lite_rvalid(m_axi_lite_rvalid),
        .m_axi_lite_wdata(m_axi_lite_wdata),
        .m_axi_lite_wready(m_axi_lite_wready),
        .m_axi_lite_wstrb(m_axi_lite_wstrb),
        .m_axi_lite_wvalid(m_axi_lite_wvalid),
        .mig_clk(mig_clk),
        .mig_rstn(mig_rstn),
        .pci_express_x4_rxn(pci_express_x4_rxn),
        .pci_express_x4_rxp(pci_express_x4_rxp),
        .pci_express_x4_txn(pci_express_x4_txn),
        .pci_express_x4_txp(pci_express_x4_txp),
        .pcie_clk(pcie_clk),
        .pcie_lnk_up(pcie_lnk_up),
        .pcie_perstn(pcie_perstn),
        .pcie_refclk_clk_n(pcie_refclk_clk_n),
        .pcie_refclk_clk_p(pcie_refclk_clk_p),
        .pcie_rstn(pcie_rstn),
        .reset(~rstn),
        .s_apb_paddr(s_apb_paddr),
        .s_apb_penable(s_apb_penable),
        .s_apb_prdata(s_apb_prdata),
        .s_apb_pready(s_apb_pready),
        .s_apb_psel(s_apb_psel),
        .s_apb_pslverr(s_apb_pslverr),
        .s_apb_pwdata(s_apb_pwdata),
        .s_apb_pwrite(s_apb_pwrite),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arburst(s_axi_arburst),
        .s_axi_arcache(s_axi_arcache),
        .s_axi_arid(s_axi_arid),
        .s_axi_arlen(s_axi_arlen),
        .s_axi_arlock(s_axi_arlock),
        .s_axi_arprot(s_axi_arprot),
        .s_axi_arqos(s_axi_arqos),
        .s_axi_arready(s_axi_arready),
        .s_axi_arregion(s_axi_arregion),
        .s_axi_arsize(s_axi_arsize),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awburst(s_axi_awburst),
        .s_axi_awcache(s_axi_awcache),
        .s_axi_awid(s_axi_awid),
        .s_axi_awlen(s_axi_awlen),
        .s_axi_awlock(s_axi_awlock),
        .s_axi_awprot(s_axi_awprot),
        .s_axi_awqos(s_axi_awqos),
        .s_axi_awready(s_axi_awready),
        .s_axi_awregion(s_axi_awregion),
        .s_axi_awsize(s_axi_awsize),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bid(s_axi_bid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rid(s_axi_rid),
        .s_axi_rlast(s_axi_rlast),
        .s_axi_rready(s_axi_rready),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wlast(s_axi_wlast),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid));
endmodule
