# Timing constraint
create_clock -name pcie_refclk_clk_p -period 10 [get_ports pcie_refclk_clk_p]

# PCIe Refclk
set_property PACKAGE_PIN AR14 [get_ports {pcie_refclk_clk_n}]
set_property PACKAGE_PIN AR15 [get_ports {pcie_refclk_clk_p}]

# PCIe Sideband
set_property PACKAGE_PIN BF41     [get_ports {pcie_perstn}]
set_property IOSTANDARD  LVCMOS12 [get_ports {pcie_perstn}]

# LEDs
set_property PACKAGE_PIN BH24    [get_ports {led[0]}]
set_property PACKAGE_PIN BG24    [get_ports {led[1]}]
set_property PACKAGE_PIN BG25    [get_ports {led[2]}]
set_property PACKAGE_PIN BF25    [get_ports {led[3]}]
set_property PACKAGE_PIN BF26    [get_ports {led[4]}]
set_property PACKAGE_PIN BF27    [get_ports {led[5]}]
set_property PACKAGE_PIN BG27    [get_ports {led[6]}]
set_property PACKAGE_PIN BG28    [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[*]}]

# Reset
set_property PACKAGE_PIN BL25     [get_ports {rstn}]
set_property PULLTYPE    PULLUP   [get_ports {rstn}]
set_property IOSTANDARD  LVCMOS18 [get_ports {rstn}]

# Timing
#set_clock_groups -name async_mig_pcie -asynchronous -group [get_clocks -include_generated_clocks design_1_i/xdma_0/inst/pcie4_ip_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i/design_1_xdma_0_0_pcie4_ip_gt_i/inst/gen_gtwizard_gtye4_top.design_1_xdma_0_0_pcie4_ip_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[33].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK] -group [get_clocks -include_generated_clocks clk_out1_design_1_clk_wiz_0_0]

# Floorplanning
#create_pblock pblock_xdma_0
#add_cells_to_pblock [get_pblocks pblock_xdma_0] [get_cells -quiet [list design_1_i/xdma_0]]
#resize_pblock [get_pblocks pblock_xdma_0] -add {CLOCKREGION_X5Y2:CLOCKREGION_X7Y3}
#
#create_pblock pblock_tile_y0x0
#add_cells_to_pblock [get_pblocks pblock_tile_y0x0] [get_cells -quiet [list proc/cc/y[0].x[0].tile_node/tile]]
#resize_pblock [get_pblocks pblock_tile_y0x0] -add {CLOCKREGION_X0Y4:CLOCKREGION_X3Y5}
#
#create_pblock pblock_tile_y0x1
#add_cells_to_pblock [get_pblocks pblock_tile_y0x1] [get_cells -quiet [list proc/cc/y[0].x[1].tile_node/tile]]
#resize_pblock [get_pblocks pblock_tile_y0x1] -add {CLOCKREGION_X4Y4:CLOCKREGION_X7Y5}
#
#create_pblock pblock_tile_y1x0
#add_cells_to_pblock [get_pblocks pblock_tile_y1x0] [get_cells -quiet [list proc/cc/y[1].x[0].tile_node/tile]]
#resize_pblock [get_pblocks pblock_tile_y1x0] -add {CLOCKREGION_X0Y6:CLOCKREGION_X3Y7}
#
#create_pblock pblock_tile_y1x1
#add_cells_to_pblock [get_pblocks pblock_tile_y1x1] [get_cells -quiet [list proc/cc/y[1].x[1].tile_node/tile]]
#resize_pblock [get_pblocks pblock_tile_y1x1] -add {CLOCKREGION_X4Y6:CLOCKREGION_X7Y7}

# HBM dbg_hub
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets */*/*APB_0_PCLK]

# Bitstream
set_property BITSTREAM.GENERAL.COMPRESS        True  [current_design]
