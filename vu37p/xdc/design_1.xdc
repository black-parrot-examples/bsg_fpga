
# PCIe Refclk
set_property PACKAGE_PIN U14 [get_ports {pcie_refclk_clk_n}]
set_property PACKAGE_PIN U15 [get_ports {pcie_refclk_clk_p}]

# PCIe x4 channel
# First step: reset locations to default
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_rxn[0]}]
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_rxn[1]}]
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_rxn[2]}]
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_rxn[3]}]
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_rxp[0]}]
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_rxp[1]}]
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_rxp[2]}]
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_rxp[3]}]
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_txn[0]}]
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_txn[1]}]
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_txn[2]}]
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_txn[3]}]
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_txp[0]}]
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_txp[1]}]
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_txp[2]}]
set_property PACKAGE_PIN {}  [get_ports {pci_express_x4_txp[3]}]

# Second step: set new locations
set_property PACKAGE_PIN R5  [get_ports {pci_express_x4_rxn[0]}]
set_property PACKAGE_PIN P3  [get_ports {pci_express_x4_rxn[1]}]
set_property PACKAGE_PIN N1  [get_ports {pci_express_x4_rxn[2]}]
set_property PACKAGE_PIN M3  [get_ports {pci_express_x4_rxn[3]}]
set_property PACKAGE_PIN R6  [get_ports {pci_express_x4_rxp[0]}]
set_property PACKAGE_PIN P4  [get_ports {pci_express_x4_rxp[1]}]
set_property PACKAGE_PIN N2  [get_ports {pci_express_x4_rxp[2]}]
set_property PACKAGE_PIN M4  [get_ports {pci_express_x4_rxp[3]}]
set_property PACKAGE_PIN P8  [get_ports {pci_express_x4_txn[0]}]
set_property PACKAGE_PIN N6  [get_ports {pci_express_x4_txn[1]}]
set_property PACKAGE_PIN N10 [get_ports {pci_express_x4_txn[2]}]
set_property PACKAGE_PIN M8  [get_ports {pci_express_x4_txn[3]}]
set_property PACKAGE_PIN P9  [get_ports {pci_express_x4_txp[0]}]
set_property PACKAGE_PIN N7  [get_ports {pci_express_x4_txp[1]}]
set_property PACKAGE_PIN N11 [get_ports {pci_express_x4_txp[2]}]
set_property PACKAGE_PIN M9  [get_ports {pci_express_x4_txp[3]}]

# PCIe Sideband
set_property PACKAGE_PIN BL45 [get_ports {PCIE0_FPGA_CPERSTN}]
set_property PACKAGE_PIN BM47 [get_ports {PCIE0_FPGA_CPRSNT}]
set_property PACKAGE_PIN BL46 [get_ports {PCIE0_FPGA_CPWRON}]
set_property PACKAGE_PIN BL47 [get_ports {PCIE0_FPGA_CWAKE}]
set_property PACKAGE_PIN BN45 [get_ports {PCIE0_SWITCH}]
set_property PACKAGE_PIN H34  [get_ports {PCIE1_FPGA_CPERSTN}]
set_property PACKAGE_PIN H38  [get_ports {PCIE1_FPGA_CPRSNT}]
set_property PACKAGE_PIN H35  [get_ports {PCIE1_FPGA_CPWRON}]
set_property PACKAGE_PIN H37  [get_ports {PCIE1_FPGA_CWAKE}]
set_property PACKAGE_PIN BM45 [get_ports {PCIE1_SWITCH}]
set_property IOSTANDARD LVCMOS18 [get_ports {PCIE?_SWITCH PCIE?_FPGA_*}]

# LEDs
set_property PACKAGE_PIN BP46 [get_ports {led[0]}]
set_property PACKAGE_PIN BN46 [get_ports {led[1]}]
set_property PACKAGE_PIN BP44 [get_ports {led[2]}]
set_property PACKAGE_PIN BP43 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[*]}]

# Reset
set_property PACKAGE_PIN BM44 [get_ports {rstn}]
set_property IOSTANDARD LVCMOS18 [get_ports {rstn}]
set_property PULLTYPE PULLUP [get_ports {rstn}]

# Timing
set_clock_groups -name async_mig_pcie -asynchronous -group [get_clocks -include_generated_clocks design_1_i/xdma_0/inst/pcie4_ip_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i/design_1_xdma_0_0_pcie4_ip_gt_i/inst/gen_gtwizard_gtye4_top.design_1_xdma_0_0_pcie4_ip_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[33].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK] -group [get_clocks -include_generated_clocks clk_out1_design_1_clk_wiz_0_0]

# Floorplanning
create_pblock pblock_xdma_0
add_cells_to_pblock [get_pblocks pblock_xdma_0] [get_cells -quiet [list design_1_i/xdma_0]]
resize_pblock [get_pblocks pblock_xdma_0] -add {CLOCKREGION_X5Y8:CLOCKREGION_X7Y9}

create_pblock pblock_proc
add_cells_to_pblock [get_pblocks pblock_proc] [get_cells -quiet [list proc]]
resize_pblock [get_pblocks pblock_proc] -add {CLOCKREGION_X4Y0:CLOCKREGION_X7Y3}

# HBM dbg_hub
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets */*/*APB_0_PCLK]
