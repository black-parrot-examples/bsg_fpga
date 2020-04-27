//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
//Date        : Sat Mar 21 23:31:31 2020
//Host        : dhcp196-212.ece.uw.edu running 64-bit CentOS Linux release 7.7.1908 (Core)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper

 import bp_common_pkg::*;
 import bp_common_aviary_pkg::*;
 import bp_be_pkg::*;
 import bp_common_rv64_pkg::*;
 import bp_cce_pkg::*;
 import bp_common_cfg_link_pkg::*;
 import bsg_noc_pkg::*;
 import bsg_wormhole_router_pkg::*;
 import bsg_cache_pkg::*;
  
 #(parameter bp_params_e bp_params_p = e_bp_single_core_cfg
   `declare_bp_proc_params(bp_params_p)
   `declare_bp_me_if_widths(paddr_width_p, cce_block_width_p, lce_id_width_p, lce_assoc_p)
   
  ,localparam cache_addr_width_p = 30 - `BSG_SAFE_CLOG2(1) // one cache_dma
  ,localparam axi_id_width_p     = 1
  ,localparam axi_addr_width_p   = 30
  ,localparam axi_data_width_p   = 256
  ,localparam axi_burst_len_p    = 2
  
  ,localparam cce_instr_ram_addr_width_lp = `BSG_SAFE_CLOG2(num_cce_instr_ram_els_p)
  ,localparam cce_ucode_filename_lp = "bp_cce_inst_rom_mesi.mem"
  )

   (ddr4_sdram_c1_act_n,
    ddr4_sdram_c1_adr,
    ddr4_sdram_c1_ba,
    ddr4_sdram_c1_bg,
    ddr4_sdram_c1_ck_c,
    ddr4_sdram_c1_ck_t,
    ddr4_sdram_c1_cke,
    ddr4_sdram_c1_cs_n,
    ddr4_sdram_c1_dm_n,
    ddr4_sdram_c1_dq,
    ddr4_sdram_c1_dqs_c,
    ddr4_sdram_c1_dqs_t,
    ddr4_sdram_c1_odt,
    ddr4_sdram_c1_reset_n,
    default_sysclk1_300_clk_n,
    default_sysclk1_300_clk_p,

    pci_express_x4_rxn,
    pci_express_x4_rxp,
    pci_express_x4_txn,
    pci_express_x4_txp,

    pcie_perstn,
    pcie_refclk_clk_n,
    pcie_refclk_clk_p,
    reset,
    led);
  output ddr4_sdram_c1_act_n;
  output [16:0]ddr4_sdram_c1_adr;
  output [1:0]ddr4_sdram_c1_ba;
  output ddr4_sdram_c1_bg;
  output ddr4_sdram_c1_ck_c;
  output ddr4_sdram_c1_ck_t;
  output ddr4_sdram_c1_cke;
  output ddr4_sdram_c1_cs_n;
  inout [3:0]ddr4_sdram_c1_dm_n;
  inout [31:0]ddr4_sdram_c1_dq;
  inout [3:0]ddr4_sdram_c1_dqs_c;
  inout [3:0]ddr4_sdram_c1_dqs_t;
  output ddr4_sdram_c1_odt;
  output ddr4_sdram_c1_reset_n;

  input default_sysclk1_300_clk_n;
  input default_sysclk1_300_clk_p;

  input [3:0]pci_express_x4_rxn;
  input [3:0]pci_express_x4_rxp;
  output [3:0]pci_express_x4_txn;
  output [3:0]pci_express_x4_txp;

  input pcie_perstn;
  input pcie_refclk_clk_n;
  input pcie_refclk_clk_p;
  input reset;
  output [7:0] led;

  wire ddr4_sdram_c1_act_n;
  wire [16:0]ddr4_sdram_c1_adr;
  wire [1:0]ddr4_sdram_c1_ba;
  wire ddr4_sdram_c1_bg;
  wire ddr4_sdram_c1_ck_c;
  wire ddr4_sdram_c1_ck_t;
  wire ddr4_sdram_c1_cke;
  wire ddr4_sdram_c1_cs_n;
  wire [3:0]ddr4_sdram_c1_dm_n;
  wire [31:0]ddr4_sdram_c1_dq;
  wire [3:0]ddr4_sdram_c1_dqs_c;
  wire [3:0]ddr4_sdram_c1_dqs_t;
  wire ddr4_sdram_c1_odt;
  wire ddr4_sdram_c1_reset_n;

  wire default_sysclk1_300_clk_n;
  wire default_sysclk1_300_clk_p;

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

  wire mig_calib_done;
  wire mig_clk;
  wire [0:0]mig_rstn;

  wire [3:0]pci_express_x4_rxn;
  wire [3:0]pci_express_x4_rxp;
  wire [3:0]pci_express_x4_txn;
  wire [3:0]pci_express_x4_txp;

  wire pcie_clk;
  wire pcie_lnk_up;
  wire pcie_perstn;

  wire pcie_refclk_clk_n;
  wire pcie_refclk_clk_p;

  wire [0:0]pcie_rstn;
  wire reset;
  wire [7:0] led;

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
  assign led[1] = mig_calib_done;
  
  // m_axi_lite adapter
  bsg_m_axi_lite_to_fifo
 #(.addr_width_p(32)
  ,.data_width_p(32)
  ,.buffer_size_p(16)
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
  ,.reset_i  (~mig_rstn)
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
  
`declare_bsg_ready_and_link_sif_s(io_noc_flit_width_p, bp_io_noc_ral_link_s);
`declare_bsg_ready_and_link_sif_s(mem_noc_flit_width_p, bp_mem_noc_ral_link_s);
`declare_bp_me_if(paddr_width_p, cce_block_width_p, lce_id_width_p, lce_assoc_p)

bp_io_noc_ral_link_s [E:P] cmd_link_li, cmd_link_lo;
bp_io_noc_ral_link_s [E:P] resp_link_li, resp_link_lo;

bp_cce_mem_msg_s dram_cmd_li;
logic            dram_cmd_v_li, dram_cmd_yumi_lo;
bp_cce_mem_msg_s dram_resp_lo;
logic            dram_resp_v_lo, dram_resp_ready_li;

bp_cce_mem_msg_s nbf_dram_cmd_li;
logic            nbf_dram_cmd_v_li, nbf_dram_cmd_yumi_lo;
bp_cce_mem_msg_s nbf_dram_resp_lo;
logic            nbf_dram_resp_v_lo, nbf_dram_resp_ready_li;

bp_cce_mem_msg_s a_dram_cmd_li;
logic            a_dram_cmd_v_li, a_dram_cmd_yumi_lo;
bp_cce_mem_msg_s a_dram_resp_lo;
logic            a_dram_resp_v_lo, a_dram_resp_ready_li;

bp_cce_mem_msg_s b_dram_cmd_li;
logic            b_dram_cmd_v_li, b_dram_cmd_yumi_lo;
bp_cce_mem_msg_s b_dram_resp_lo;
logic            b_dram_resp_v_lo, b_dram_resp_ready_li;

bp_io_noc_ral_link_s proc_cmd_link_li, proc_cmd_link_lo;
bp_io_noc_ral_link_s proc_resp_link_li, proc_resp_link_lo;

bp_mem_noc_ral_link_s dram_cmd_link_lo, dram_resp_link_li;

bp_cce_mem_msg_s       host_cmd_li;
logic                  host_cmd_v_li, host_cmd_yumi_lo;
bp_cce_mem_msg_s       host_resp_lo;
logic                  host_resp_v_lo, host_resp_ready_li;

bp_cce_mem_msg_s       load_cmd_lo;
logic                  load_cmd_v_lo, load_cmd_ready_li;
bp_cce_mem_msg_s       load_resp_li;
logic                  load_resp_v_li, load_resp_yumi_lo;

bp_cce_mem_msg_s       cfg_cmd_lo;
logic                  cfg_cmd_v_lo, cfg_cmd_ready_li;
bp_cce_mem_msg_s       cfg_resp_li;
logic                  cfg_resp_v_li, cfg_resp_ready_lo;

bp_cce_mem_msg_s       nbf_cmd_lo;
logic                  nbf_cmd_v_lo, nbf_cmd_ready_li;
bp_cce_mem_msg_s       nbf_resp_li;
logic                  nbf_resp_v_li, nbf_resp_ready_lo;

wire [io_noc_did_width_p-1:0] dram_did_li = '1;
wire [io_noc_did_width_p-1:0] proc_did_li = 1;

bp_io_noc_ral_link_s stub_cmd_link_li, stub_resp_link_li;
bp_io_noc_ral_link_s stub_cmd_link_lo, stub_resp_link_lo;
assign stub_cmd_link_li  = '0;
assign stub_resp_link_li = '0;

// Chip
bp_processor
 #(.bp_params_p(bp_params_p))
 proc
  (.core_clk_i(mig_clk)
   ,.core_reset_i(~mig_rstn)
   
   ,.coh_clk_i(mig_clk)
   ,.coh_reset_i(~mig_rstn)

   ,.io_clk_i(mig_clk)
   ,.io_reset_i(~mig_rstn)

   ,.mem_clk_i(mig_clk)
   ,.mem_reset_i(~mig_rstn)

   ,.my_did_i(proc_did_li)
   ,.host_did_i(dram_did_li)

   ,.io_cmd_link_i({proc_cmd_link_li, stub_cmd_link_li})
   ,.io_cmd_link_o({proc_cmd_link_lo, stub_cmd_link_lo})

   ,.io_resp_link_i({proc_resp_link_li, stub_resp_link_li})
   ,.io_resp_link_o({proc_resp_link_lo, stub_resp_link_lo})

   ,.dram_cmd_link_o(dram_cmd_link_lo)
   ,.dram_resp_link_i(dram_resp_link_li)
   );

wire [io_noc_cord_width_p-1:0] dst_cord_lo = 1;

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
   ,.reset_i(~mig_rstn)

   ,.mem_cmd_i(load_cmd_lo)
   ,.mem_cmd_v_i(load_cmd_v_lo)
   ,.mem_cmd_ready_o(load_cmd_ready_li)

   ,.mem_resp_o(load_resp_li)
   ,.mem_resp_v_o(load_resp_v_li)
   ,.mem_resp_yumi_i(load_resp_yumi_lo)

   ,.my_cord_i(io_noc_cord_width_p'(dram_did_li))
   ,.my_cid_i('0)
   ,.dst_cord_i(dst_cord_lo)
   ,.dst_cid_i('0)

   ,.mem_cmd_o(host_cmd_li)
   ,.mem_cmd_v_o(host_cmd_v_li)
   ,.mem_cmd_yumi_i(host_cmd_yumi_lo)

   ,.mem_resp_i(host_resp_lo)
   ,.mem_resp_v_i(host_resp_v_lo)
   ,.mem_resp_ready_o(host_resp_ready_li)

   ,.cmd_link_i(proc_cmd_link_lo)
   ,.cmd_link_o(proc_cmd_link_li)
   ,.resp_link_i(proc_resp_link_lo)
   ,.resp_link_o(proc_resp_link_li)
   );

bp_me_cce_to_mem_link_client
 #(.bp_params_p(bp_params_p)
   ,.num_outstanding_req_p(mem_noc_max_credits_p)
   ,.flit_width_p(mem_noc_flit_width_p)
   ,.cord_width_p(mem_noc_cord_width_p)
   ,.cid_width_p(mem_noc_cid_width_p)
   ,.len_width_p(mem_noc_len_width_p)
   )
 dram_link
  (.clk_i(mig_clk)
   ,.reset_i(~mig_rstn)

   ,.mem_cmd_o(b_dram_cmd_li)
   ,.mem_cmd_v_o(b_dram_cmd_v_li)
   ,.mem_cmd_yumi_i(b_dram_cmd_yumi_lo)

   ,.mem_resp_i(b_dram_resp_lo)
   ,.mem_resp_v_i(b_dram_resp_v_lo)
   ,.mem_resp_ready_o(b_dram_resp_ready_li)

   ,.cmd_link_i(dram_cmd_link_lo)
   ,.resp_link_o(dram_resp_link_li)
   );


logic nbf_done_lo, cfg_done_lo, dram_sel_lo;
    
    assign nbf_cmd_lo = '0;
    assign nbf_cmd_v_lo = '0;
    assign nbf_resp_ready_lo = '0;
    
    logic [7:0] counter_r, counter_n;
    logic nbf_done_r;
    always_ff @(posedge mig_clk)
      begin
        if (~mig_rstn)
          begin
            counter_r <= 1;
            nbf_done_r <= 0;
          end
        else if (nbf_done_lo)
          begin
            if (counter_r == 0)
              begin
                nbf_done_r <= 1;
              end
            else
              begin
                counter_r <= counter_r + 1;
              end
          end
      end
    assign dram_sel_lo = nbf_done_r;
       
    bp_nbf_to_cce_mem
   #(.bp_params_p(bp_params_p)
    ) nbf_adapter
    (.clk_i(mig_clk)
    ,.reset_i(~mig_rstn)

    ,.io_cmd_i(nbf_dram_cmd_li)
    ,.io_cmd_v_i(nbf_dram_cmd_v_li)
    ,.io_cmd_yumi_o(nbf_dram_cmd_yumi_lo)

    ,.io_resp_o(nbf_dram_resp_lo)
    ,.io_resp_v_o(nbf_dram_resp_v_lo)
    ,.io_resp_ready_i(nbf_dram_resp_ready_li)

    ,.mem_cmd_o(a_dram_cmd_li)
    ,.mem_cmd_v_o(a_dram_cmd_v_li)
    ,.mem_cmd_yumi_i(a_dram_cmd_yumi_lo)

    ,.mem_resp_i(a_dram_resp_lo)
    ,.mem_resp_v_i(a_dram_resp_v_lo)
    ,.mem_resp_ready_o(a_dram_resp_ready_li)
    );
    

always_comb
  begin
    if (dram_sel_lo)
      begin
        dram_cmd_li = b_dram_cmd_li;
        dram_cmd_v_li = b_dram_cmd_v_li;
        b_dram_cmd_yumi_lo = dram_cmd_yumi_lo;
        
        b_dram_resp_lo = dram_resp_lo;
        b_dram_resp_v_lo = dram_resp_v_lo;
        dram_resp_ready_li = b_dram_resp_ready_li;
        
        a_dram_cmd_yumi_lo = a_dram_cmd_v_li;
        a_dram_resp_lo = '0;
        a_dram_resp_v_lo = 1'b0;
      end
    else
      begin
        dram_cmd_li = a_dram_cmd_li;
        dram_cmd_v_li = a_dram_cmd_v_li;
        a_dram_cmd_yumi_lo = dram_cmd_yumi_lo;
        
        a_dram_resp_lo = dram_resp_lo;
        a_dram_resp_v_lo = dram_resp_v_lo;
        dram_resp_ready_li = a_dram_resp_ready_li;
        
        b_dram_cmd_yumi_lo = b_dram_cmd_v_li;
        b_dram_resp_lo = '0;
        b_dram_resp_v_lo = 1'b0;
      end
  end


bp_cce_mmio_cfg_loader
  #(.bp_params_p(bp_params_p)
    ,.inst_width_p(`bp_cce_inst_width)
    ,.inst_ram_addr_width_p(cce_instr_ram_addr_width_lp)
    ,.inst_ram_els_p(num_cce_instr_ram_els_p)
    ,.cce_ucode_filename_p(cce_ucode_filename_lp)
    ,.skip_ram_init_p(0)
    ,.clear_freeze_p(1)
    )
  cfg_loader
  (.clk_i(mig_clk)
   ,.reset_i(~mig_rstn | ~dram_sel_lo)
   
   ,.io_cmd_o(cfg_cmd_lo)
   ,.io_cmd_v_o(cfg_cmd_v_lo)
   ,.io_cmd_yumi_i(cfg_cmd_ready_li & cfg_cmd_v_lo)
   
   ,.io_resp_i(cfg_resp_li)
   ,.io_resp_v_i(cfg_resp_v_li)
   ,.io_resp_ready_o(cfg_resp_ready_lo)
   
   ,.done_o(cfg_done_lo)
  );

// CFG and NBF are mutex, so we can just use fixed arbitration here
always_comb
  if (~cfg_done_lo)
    begin
      load_cmd_lo = cfg_cmd_lo;
      load_cmd_v_lo = load_cmd_ready_li & cfg_cmd_v_lo;

      nbf_cmd_ready_li = 1'b0;
      cfg_cmd_ready_li = load_cmd_ready_li;

      nbf_resp_li = '0;
      nbf_resp_v_li = 1'b0;

      cfg_resp_li = load_resp_li;
      cfg_resp_v_li = cfg_resp_ready_lo & load_resp_v_li;

      load_resp_yumi_lo = cfg_resp_v_li;
    end
  else
    begin
      load_cmd_lo = nbf_cmd_lo;
      load_cmd_v_lo = load_cmd_ready_li & nbf_cmd_v_lo;

      nbf_cmd_ready_li = load_cmd_ready_li;
      cfg_cmd_ready_li = 1'b0;

      nbf_resp_li = load_resp_li;
      nbf_resp_v_li = nbf_resp_ready_lo & load_resp_v_li;

      cfg_resp_li = '0;
      cfg_resp_v_li = 1'b0;

      load_resp_yumi_lo = nbf_resp_v_li;
    end

  
  // pcie stream host (NBF and MMIO)
  assign led[3] = nbf_done_lo;
  
  bp_stream_host
 #(.bp_params_p(bp_params_p)
  ,.stream_addr_width_p(32)
  ,.stream_data_width_p(32)
  ) host        
  (.clk_i          (mig_clk)
  ,.reset_i        (~mig_rstn)
  ,.prog_done_o    (nbf_done_lo)
  
  ,.io_cmd_i       (host_cmd_li)
  ,.io_cmd_v_i     (host_cmd_v_li)
  ,.io_cmd_yumi_o  (host_cmd_yumi_lo)

  ,.io_resp_o      (host_resp_lo)
  ,.io_resp_v_o    (host_resp_v_lo)
  ,.io_resp_ready_i(host_resp_ready_li)

  ,.io_cmd_o       (nbf_dram_cmd_li)
  ,.io_cmd_v_o     (nbf_dram_cmd_v_li)
  ,.io_cmd_yumi_i  (nbf_dram_cmd_yumi_lo)

  ,.io_resp_i      (nbf_dram_resp_lo)
  ,.io_resp_v_i    (nbf_dram_resp_v_lo)
  ,.io_resp_ready_o(nbf_dram_resp_ready_li)

  ,.stream_v_i     (m_axi_lite_v_lo)
  ,.stream_addr_i  (m_axi_lite_addr_lo)
  ,.stream_data_i  (m_axi_lite_data_lo)
  ,.stream_yumi_o  (m_axi_lite_yumi_li)
                   
  ,.stream_v_o     (m_axi_lite_v_li)
  ,.stream_data_o  (m_axi_lite_data_li)
  ,.stream_ready_i (m_axi_lite_ready_lo)
  );
  
  // CCE to cache dma
  `declare_bsg_cache_dma_pkt_s(paddr_width_p);
  
  bsg_cache_dma_pkt_s dma_pkt_lo;
  logic dma_pkt_v_lo, dma_pkt_yumi_li;
  
  logic [dword_width_p-1:0] dma_data_li;
  logic dma_data_v_li, dma_data_ready_lo;
  
  logic [dword_width_p-1:0] dma_data_lo;
  logic dma_data_v_lo, dma_data_yumi_li;
  
  logic [cache_addr_width_p+1-1:0] cache_dma_pkt_lo;
    assign cache_dma_pkt_lo = {dma_pkt_lo.write_not_read, dma_pkt_lo[cache_addr_width_p-1:0]};

  bp_me_cce_to_cache_dma
 #(.bp_params_p(bp_params_p)
  ) mem_to_dma
  (.clk_i           (mig_clk)
  ,.reset_i         (~mig_rstn)
                    
  ,.dma_pkt_o       (dma_pkt_lo)
  ,.dma_pkt_v_o     (dma_pkt_v_lo)
  ,.dma_pkt_yumi_i  (dma_pkt_yumi_li)

  ,.dma_data_i      (dma_data_li)
  ,.dma_data_v_i    (dma_data_v_li)
  ,.dma_data_ready_o(dma_data_ready_lo)

  ,.dma_data_o      (dma_data_lo)
  ,.dma_data_v_o    (dma_data_v_lo)
  ,.dma_data_yumi_i (dma_data_yumi_li)

  ,.mem_cmd_i       (dram_cmd_li)
  ,.mem_cmd_v_i     (dram_cmd_v_li)
  ,.mem_cmd_yumi_o  (dram_cmd_yumi_lo)

  ,.mem_resp_o      (dram_resp_lo)
  ,.mem_resp_v_o    (dram_resp_v_lo)
  ,.mem_resp_ready_i(dram_resp_ready_li)
  );

  // s_axi port
  // not supported
  assign s_axi_arqos    = '0;
  assign s_axi_arregion = '0;
  assign s_axi_awqos    = '0;
  assign s_axi_awregion = '0;

  bsg_cache_to_axi 
 #(.addr_width_p         (cache_addr_width_p)
  ,.block_size_in_words_p(cce_block_width_p/dword_width_p)
  ,.data_width_p         (dword_width_p)
  ,.num_cache_p          (1)
  ,.tag_fifo_els_p       (1)

  ,.axi_id_width_p       (axi_id_width_p)
  ,.axi_addr_width_p     (axi_addr_width_p)
  ,.axi_data_width_p     (axi_data_width_p)
  ,.axi_burst_len_p      (axi_burst_len_p)
  ) cache_to_axi 
  (.clk_i  (mig_clk)
  ,.reset_i(~mig_rstn)
  
  ,.dma_pkt_i       (cache_dma_pkt_lo)
  ,.dma_pkt_v_i     (dma_pkt_v_lo)
  ,.dma_pkt_yumi_o  (dma_pkt_yumi_li)
  
  ,.dma_data_o      (dma_data_li)
  ,.dma_data_v_o    (dma_data_v_li)
  ,.dma_data_ready_i(dma_data_ready_lo)
  
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
    if (~mig_rstn)
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
       (.ddr4_sdram_c1_act_n(ddr4_sdram_c1_act_n),
        .ddr4_sdram_c1_adr(ddr4_sdram_c1_adr),
        .ddr4_sdram_c1_ba(ddr4_sdram_c1_ba),
        .ddr4_sdram_c1_bg(ddr4_sdram_c1_bg),
        .ddr4_sdram_c1_ck_c(ddr4_sdram_c1_ck_c),
        .ddr4_sdram_c1_ck_t(ddr4_sdram_c1_ck_t),
        .ddr4_sdram_c1_cke(ddr4_sdram_c1_cke),
        .ddr4_sdram_c1_cs_n(ddr4_sdram_c1_cs_n),
        .ddr4_sdram_c1_dm_n(ddr4_sdram_c1_dm_n),
        .ddr4_sdram_c1_dq(ddr4_sdram_c1_dq),
        .ddr4_sdram_c1_dqs_c(ddr4_sdram_c1_dqs_c),
        .ddr4_sdram_c1_dqs_t(ddr4_sdram_c1_dqs_t),
        .ddr4_sdram_c1_odt(ddr4_sdram_c1_odt),
        .ddr4_sdram_c1_reset_n(ddr4_sdram_c1_reset_n),
        .default_sysclk1_300_clk_n(default_sysclk1_300_clk_n),
        .default_sysclk1_300_clk_p(default_sysclk1_300_clk_p),
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
        .mig_calib_done(mig_calib_done),
        .mig_clk(mig_clk),
        .mig_rstn(mig_rstn),
        .pci_express_x4_rxn(pci_express_x4_rxn),
        .pci_express_x4_rxp(pci_express_x4_rxp),
        .pci_express_x4_txn(pci_express_x4_txn),
        .pci_express_x4_txp(pci_express_x4_txp),
        .pcie_clk(pcie_clk),
        .pcie_lnk_up(pcie_lnk_up),
        .pcie_perst(~pcie_perstn),
        .pcie_perstn(pcie_perstn),
        .pcie_refclk_clk_n(pcie_refclk_clk_n),
        .pcie_refclk_clk_p(pcie_refclk_clk_p),
        .pcie_rstn(pcie_rstn),
        .reset(reset),
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
