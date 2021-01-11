# This script will:
# 1. Create a block design
# 2. Setup the block design
# 3. Setup IOs and connections
# 4. Exclude memory map (optional)
# 5. Block design cleanup and validation

# create a block design
create_bd_design "design_1" 

# 100 MHz Clock
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0
set_property name clk_wiz_100MHz [get_bd_cells clk_wiz_0]
set_property -dict [list CONFIG.CLK_IN1_BOARD_INTERFACE {sys_diff_clock} CONFIG.RESET_BOARD_INTERFACE {reset} CONFIG.RESET_TYPE {ACTIVE_LOW} CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} CONFIG.CLKIN1_JITTER_PS {50.0} CONFIG.MMCM_CLKFBOUT_MULT_F {5.000} CONFIG.MMCM_CLKIN1_PERIOD {5.000} CONFIG.MMCM_CLKIN2_PERIOD {10.0} CONFIG.RESET_PORT {resetn} CONFIG.CLKOUT1_JITTER {112.316} CONFIG.CLKOUT1_PHASE_ERROR {89.971}] [get_bd_cells clk_wiz_100MHz]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {sys_diff_clock ( System differential clock ) } Manual_Source {Auto}}  [get_bd_intf_pins clk_wiz_100MHz/CLK_IN1_D]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {reset ( Reset ) } Manual_Source {New External Port (ACTIVE_LOW)}}  [get_bd_pins clk_wiz_100MHz/resetn]
endgroup

# 100 MHz Processor Reset
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
set_property name rst_clk_wiz_100MHz [get_bd_cells proc_sys_reset_0]
set_property -dict [list CONFIG.RESET_BOARD_INTERFACE {reset}] [get_bd_cells rst_clk_wiz_100MHz]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/clk_wiz_100MHz/clk_out1 (100 MHz)" }  [get_bd_pins rst_clk_wiz_100MHz/slowest_sync_clk]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {reset ( Reset ) } Manual_Source {Auto}}  [get_bd_pins rst_clk_wiz_100MHz/ext_reset_in]
connect_bd_net [get_bd_pins clk_wiz_100MHz/locked] [get_bd_pins rst_clk_wiz_100MHz/dcm_locked]
endgroup

# BlackParrot
startgroup
create_bd_cell -type ip -vlnv bjump.org:user:BlackParrot:0.2020.12.22 BlackParrot_0
set_property -dict [list CONFIG.axi_lite_data_width_p {64}] [get_bd_cells BlackParrot_0]
connect_bd_net [get_bd_pins BlackParrot_0/clk_i] [get_bd_pins clk_wiz_100MHz/clk_out1]
endgroup

# AXI Interconnect
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0
set_property -dict [list CONFIG.NUM_MI {1} CONFIG.ENABLE_ADVANCED_OPTIONS {1}] [get_bd_cells axi_interconnect_0]
connect_bd_net [get_bd_pins clk_wiz_100MHz/clk_out1] [get_bd_pins axi_interconnect_0/S00_ACLK]
connect_bd_intf_net [get_bd_intf_pins BlackParrot_0/M_AXI_FULL_DRAM] -boundary_type upper [get_bd_intf_pins axi_interconnect_0/S00_AXI]
endgroup

# Memory Interface Generator (MIG) must change AXI Width to 64bits manually
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0
apply_board_connection -board_interface "ddr3_sdram" -ip_intf "mig_7series_0/mig_ddr_interface" -diagram "design_1"
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins mig_7series_0/S_AXI]
connect_bd_net [get_bd_ports reset] [get_bd_pins mig_7series_0/sys_rst]
connect_bd_net [get_bd_pins mig_7series_0/ui_clk] [get_bd_pins axi_interconnect_0/ACLK]
connect_bd_net [get_bd_pins mig_7series_0/ui_clk] [get_bd_pins axi_interconnect_0/M00_ACLK]
connect_bd_net [get_bd_pins mig_7series_0/aresetn] [get_bd_pins inv_logic_gate_2/Res]
endgroup

# Other logic gates and connection
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0
set_property name inv_logic_gate_0 [get_bd_cells util_vector_logic_0]
set_property -dict [list CONFIG.C_SIZE {1} CONFIG.C_OPERATION {not} CONFIG.LOGO_FILE {data/sym_notgate.png}] [get_bd_cells inv_logic_gate_0]
copy_bd_objs /  [get_bd_cells {inv_logic_gate_0}]
copy_bd_objs /  [get_bd_cells {inv_logic_gate_0}]
create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0
set_property name or_logic_gate [get_bd_cells util_vector_logic_0]
set_property -dict [list CONFIG.C_SIZE {1} CONFIG.C_OPERATION {or} CONFIG.LOGO_FILE {data/sym_orgate.png}] [get_bd_cells or_logic_gate]
connect_bd_net [get_bd_pins mig_7series_0/init_calib_complete] [get_bd_pins inv_logic_gate_0/Op1]
connect_bd_net [get_bd_pins inv_logic_gate_0/Res] [get_bd_pins or_logic_gate/Op1]
connect_bd_net [get_bd_pins rst_clk_wiz_100MHz/mb_reset] [get_bd_pins or_logic_gate/Op2]
connect_bd_net [get_bd_pins or_logic_gate/Res] [get_bd_pins BlackParrot_0/reset_i]
connect_bd_net [get_bd_pins inv_logic_gate_1/Op1] [get_bd_pins or_logic_gate/Res]
connect_bd_net [get_bd_pins inv_logic_gate_1/Res] [get_bd_pins axi_interconnect_0/S00_ARESETN]
connect_bd_net [get_bd_pins mig_7series_0/ui_clk_sync_rst] [get_bd_pins inv_logic_gate_2/Op1]
connect_bd_net [get_bd_pins inv_logic_gate_2/Res] [get_bd_pins axi_interconnect_0/ARESETN]
connect_bd_net [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins inv_logic_gate_2/Res]
set_property CONFIG.ASSOCIATED_BUSIF {S_AXI_BP_IO_IN} [get_bd_ports /clk_100MHz_out]
set_property CONFIG.ASSOCIATED_BUSIF {S_AXI_BP_IO_IN:M_AXI_BP_IO_OUT} [get_bd_ports /clk_100MHz_out]
endgroup

# IO interface
startgroup
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_BP_IO_IN
set_property -dict [list CONFIG.CLK_DOMAIN {design_1_clk_wiz_0_0_clk_out1} CONFIG.PROTOCOL {AXI4LITE} CONFIG.DATA_WIDTH {64} CONFIG.HAS_BURST {0} CONFIG.HAS_CACHE {0} CONFIG.HAS_LOCK {0} CONFIG.HAS_QOS {0} CONFIG.HAS_REGION {0}] [get_bd_intf_ports S_AXI_BP_IO_IN]
connect_bd_intf_net [get_bd_intf_ports S_AXI_BP_IO_IN] [get_bd_intf_pins BlackParrot_0/S_AXI_LITE_IO_IN]
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_BP_IO_OUT
set_property -dict [list CONFIG.CLK_DOMAIN {design_1_clk_wiz_0_0_clk_out1} CONFIG.PROTOCOL {AXI4LITE} CONFIG.DATA_WIDTH {64} CONFIG.HAS_BURST {0} CONFIG.HAS_CACHE {0} CONFIG.HAS_LOCK {0} CONFIG.HAS_QOS {0} CONFIG.HAS_REGION {0}] [get_bd_intf_ports M_AXI_BP_IO_OUT]
connect_bd_intf_net [get_bd_intf_ports M_AXI_BP_IO_OUT] [get_bd_intf_pins BlackParrot_0/M_AXI_LITE_IO_OUT]
create_bd_port -dir O init_calib_complete
connect_bd_net [get_bd_ports init_calib_complete] [get_bd_pins mig_7series_0/init_calib_complete]
create_bd_port -dir O -type rst reset_100MHz_out
connect_bd_net [get_bd_ports reset_100MHz_out] [get_bd_pins or_logic_gate/Res]
create_bd_port -dir O -type clk clk_100MHz_out
connect_bd_net [get_bd_ports clk_100MHz_out] [get_bd_pins clk_wiz_100MHz/clk_out1]
endgroup

# Exclude memory segment
exclude_bd_addr_seg [get_bd_addr_segs BlackParrot_0/S_AXI_LITE_IO_IN/Reg] -target_address_space [get_bd_addr_spaces S_AXI_BP_IO_IN]

# Block design cleanup and validation
regenerate_bd_layout
save_bd_design
validate_bd_design
