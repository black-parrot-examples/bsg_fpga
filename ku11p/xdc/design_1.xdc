

# Internal Vref for DDR4 Data IO (Bank 67)
set_property INTERNAL_VREF 0.840 [get_iobanks 67]

# System reset pin
set_property PACKAGE_PIN J16      [get_ports {reset}]
set_property IOSTANDARD  LVCMOS33 [get_ports {reset}]

# PCIe pin assignment
set_property PACKAGE_PIN P5 [get_ports {pcie_refclk_clk_n}]
set_property PACKAGE_PIN P6 [get_ports {pcie_refclk_clk_p}]

set_property PACKAGE_PIN AF20     [get_ports {pcie_perstn}]
set_property IOSTANDARD  LVCMOS18 [get_ports {pcie_perstn}]

# DDR4 Pin Assignment
set_property PACKAGE_PIN Y30    [get_ports {ddr4_sdram_act_n      }]
set_property PACKAGE_PIN AA28   [get_ports {ddr4_sdram_adr[0]     }]
set_property PACKAGE_PIN AD28   [get_ports {ddr4_sdram_adr[1]     }]
set_property PACKAGE_PIN AC28   [get_ports {ddr4_sdram_adr[2]     }]
set_property PACKAGE_PIN AA29   [get_ports {ddr4_sdram_adr[3]     }]
set_property PACKAGE_PIN AA30   [get_ports {ddr4_sdram_adr[4]     }]
set_property PACKAGE_PIN AH30   [get_ports {ddr4_sdram_adr[5]     }]
set_property PACKAGE_PIN AE30   [get_ports {ddr4_sdram_adr[6]     }]
set_property PACKAGE_PIN AH29   [get_ports {ddr4_sdram_adr[7]     }]
set_property PACKAGE_PIN AE29   [get_ports {ddr4_sdram_adr[8]     }]
set_property PACKAGE_PIN AE27   [get_ports {ddr4_sdram_adr[9]     }]
set_property PACKAGE_PIN Y27    [get_ports {ddr4_sdram_adr[10]    }]
set_property PACKAGE_PIN AJ30   [get_ports {ddr4_sdram_adr[11]    }]
set_property PACKAGE_PIN Y29    [get_ports {ddr4_sdram_adr[12]    }]
set_property PACKAGE_PIN AJ29   [get_ports {ddr4_sdram_adr[13]    }]
set_property PACKAGE_PIN AB28   [get_ports {ddr4_sdram_adr[14]    }]
set_property PACKAGE_PIN AF29   [get_ports {ddr4_sdram_adr[15]    }]
set_property PACKAGE_PIN AF30   [get_ports {ddr4_sdram_adr[16]    }]
set_property PACKAGE_PIN AC29   [get_ports {ddr4_sdram_ba[0]      }]
set_property PACKAGE_PIN AG28   [get_ports {ddr4_sdram_ba[1]      }]
set_property PACKAGE_PIN AC30   [get_ports {ddr4_sdram_bg[0]      }]
set_property PACKAGE_PIN AG30   [get_ports {ddr4_sdram_bg[1]      }]
set_property PACKAGE_PIN AF28   [get_ports {ddr4_sdram_ck_c       }]
set_property PACKAGE_PIN AF27   [get_ports {ddr4_sdram_ck_t       }]
set_property PACKAGE_PIN AB30   [get_ports {ddr4_sdram_cke        }]
set_property PACKAGE_PIN W29    [get_ports {ddr4_sdram_cs_n       }]
                                
set_property PACKAGE_PIN M27    [get_ports {ddr4_sdram_dm_n[0]    }]
set_property PACKAGE_PIN R26    [get_ports {ddr4_sdram_dm_n[1]    }]
set_property PACKAGE_PIN P23    [get_ports {ddr4_sdram_dm_n[2]    }]
set_property PACKAGE_PIN W22    [get_ports {ddr4_sdram_dm_n[3]    }]
                                
set_property PACKAGE_PIN P28    [get_ports {ddr4_sdram_dq[0]      }]
set_property PACKAGE_PIN N30    [get_ports {ddr4_sdram_dq[1]      }]
set_property PACKAGE_PIN R29    [get_ports {ddr4_sdram_dq[2]      }]
set_property PACKAGE_PIN N28    [get_ports {ddr4_sdram_dq[3]      }]
set_property PACKAGE_PIN P29    [get_ports {ddr4_sdram_dq[4]      }]
set_property PACKAGE_PIN M30    [get_ports {ddr4_sdram_dq[5]      }]
set_property PACKAGE_PIN N29    [get_ports {ddr4_sdram_dq[6]      }]
set_property PACKAGE_PIN L30    [get_ports {ddr4_sdram_dq[7]      }]
set_property PACKAGE_PIN U26    [get_ports {ddr4_sdram_dq[8]      }]
set_property PACKAGE_PIN T28    [get_ports {ddr4_sdram_dq[9]      }]
set_property PACKAGE_PIN V30    [get_ports {ddr4_sdram_dq[10]     }]
set_property PACKAGE_PIN U27    [get_ports {ddr4_sdram_dq[11]     }]
set_property PACKAGE_PIN V26    [get_ports {ddr4_sdram_dq[12]     }]
set_property PACKAGE_PIN T27    [get_ports {ddr4_sdram_dq[13]     }]
set_property PACKAGE_PIN V25    [get_ports {ddr4_sdram_dq[14]     }]
set_property PACKAGE_PIN U30    [get_ports {ddr4_sdram_dq[15]     }]
set_property PACKAGE_PIN N26    [get_ports {ddr4_sdram_dq[16]     }]
set_property PACKAGE_PIN N25    [get_ports {ddr4_sdram_dq[17]     }]
set_property PACKAGE_PIN M26    [get_ports {ddr4_sdram_dq[18]     }]
set_property PACKAGE_PIN M25    [get_ports {ddr4_sdram_dq[19]     }]
set_property PACKAGE_PIN P27    [get_ports {ddr4_sdram_dq[20]     }]
set_property PACKAGE_PIN N24    [get_ports {ddr4_sdram_dq[21]     }]
set_property PACKAGE_PIN P24    [get_ports {ddr4_sdram_dq[22]     }]
set_property PACKAGE_PIN P26    [get_ports {ddr4_sdram_dq[23]     }]
set_property PACKAGE_PIN R25    [get_ports {ddr4_sdram_dq[24]     }]
set_property PACKAGE_PIN T22    [get_ports {ddr4_sdram_dq[25]     }]
set_property PACKAGE_PIN T25    [get_ports {ddr4_sdram_dq[26]     }]
set_property PACKAGE_PIN U23    [get_ports {ddr4_sdram_dq[27]     }]
set_property PACKAGE_PIN U22    [get_ports {ddr4_sdram_dq[28]     }]
set_property PACKAGE_PIN R22    [get_ports {ddr4_sdram_dq[29]     }]
set_property PACKAGE_PIN T24    [get_ports {ddr4_sdram_dq[30]     }]
set_property PACKAGE_PIN T23    [get_ports {ddr4_sdram_dq[31]     }]
                                
set_property PACKAGE_PIN R30    [get_ports {ddr4_sdram_dqs_c[0]   }]
set_property PACKAGE_PIN V29    [get_ports {ddr4_sdram_dqs_c[1]   }]
set_property PACKAGE_PIN M23    [get_ports {ddr4_sdram_dqs_c[2]   }]
set_property PACKAGE_PIN V24    [get_ports {ddr4_sdram_dqs_c[3]   }]
set_property PACKAGE_PIN T30    [get_ports {ddr4_sdram_dqs_t[0]   }]
set_property PACKAGE_PIN V28    [get_ports {ddr4_sdram_dqs_t[1]   }]
set_property PACKAGE_PIN M22    [get_ports {ddr4_sdram_dqs_t[2]   }]
set_property PACKAGE_PIN V23    [get_ports {ddr4_sdram_dqs_t[3]   }]
                                
set_property PACKAGE_PIN W28    [get_ports {ddr4_sdram_odt        }]
set_property PACKAGE_PIN AD29   [get_ports {ddr4_sdram_reset_n    }]
                                
set_property PACKAGE_PIN AD27   [get_ports {sysclk_300_clk_n}]
set_property PACKAGE_PIN AD26   [get_ports {sysclk_300_clk_p}]

# LEDs
set_property PACKAGE_PIN D8  [get_ports {led[0]}]
set_property PACKAGE_PIN D9  [get_ports {led[1]}]
set_property PACKAGE_PIN E10 [get_ports {led[2]}]
set_property PACKAGE_PIN E11 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]


# Timing constraint
set_clock_groups -name async_mig_pcie -asynchronous -group [get_clocks -include_generated_clocks design_1_i/xdma_0/inst/pcie4_ip_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i/design_1_xdma_0_0_pcie4_ip_gt_i/inst/gen_gtwizard_gthe4_top.design_1_xdma_0_0_pcie4_ip_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[*].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK] -group [get_clocks -include_generated_clocks mmcm_clkout1]

# Bitstream
set_property BITSTREAM.GENERAL.COMPRESS        True  [current_design]
