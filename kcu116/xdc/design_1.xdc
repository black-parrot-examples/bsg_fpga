
# Internal Vref for DDR4 Data IO (Bank 67)
set_property INTERNAL_VREF 0.840 [get_iobanks 67]

# LED
set_property PACKAGE_PIN C9  [get_ports {led[0]}]
set_property PACKAGE_PIN D9  [get_ports {led[1]}]
set_property PACKAGE_PIN E10 [get_ports {led[2]}]
set_property PACKAGE_PIN E11 [get_ports {led[3]}]
set_property PACKAGE_PIN F9  [get_ports {led[4]}]
set_property PACKAGE_PIN F10 [get_ports {led[5]}]
set_property PACKAGE_PIN G9  [get_ports {led[6]}]
set_property PACKAGE_PIN G10 [get_ports {led[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

# RESET
set_property PACKAGE_PIN E13 [get_ports {reset}]
set_property IOSTANDARD LVCMOS33 [get_ports {reset}]
set_property PULLTYPE PULLDOWN [get_ports {reset}]

# Timing constraint
set_clock_groups -name async_mig_pcie -asynchronous -group [get_clocks -include_generated_clocks design_1_i/xdma_0/inst/pcie4_ip_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i/design_1_xdma_0_0_pcie4_ip_gt_i/inst/gen_gtwizard_gtye4_top.design_1_xdma_0_0_pcie4_ip_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[1].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK] -group [get_clocks -include_generated_clocks mmcm_clkout1]
