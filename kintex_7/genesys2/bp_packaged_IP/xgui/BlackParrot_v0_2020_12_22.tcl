# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set axi_full_addr_width_p [ipgui::add_param $IPINST -name "axi_full_addr_width_p" -parent ${Page_0} -widget comboBox]
  set_property tooltip {AXI4 Full Address Width} ${axi_full_addr_width_p}
  set axi_full_burst_type_p [ipgui::add_param $IPINST -name "axi_full_burst_type_p" -parent ${Page_0} -widget comboBox]
  set_property tooltip {00: fixed (for FIFO) 01: incr (for MEM) 10: wrapped} ${axi_full_burst_type_p}
  set axi_full_data_width_p [ipgui::add_param $IPINST -name "axi_full_data_width_p" -parent ${Page_0} -widget comboBox]
  set_property tooltip {AXI4 Full Data Width} ${axi_full_data_width_p}
  set axi_full_id_width_p [ipgui::add_param $IPINST -name "axi_full_id_width_p" -parent ${Page_0}]
  set_property tooltip {select how many devices} ${axi_full_id_width_p}
  set axi_lite_addr_width_p [ipgui::add_param $IPINST -name "axi_lite_addr_width_p" -parent ${Page_0} -widget comboBox]
  set_property tooltip {AXI4-Lite only supports an address width of 32 or 64bits (Xilinx only supports 32-bits)} ${axi_lite_addr_width_p}
  set axi_lite_data_width_p [ipgui::add_param $IPINST -name "axi_lite_data_width_p" -parent ${Page_0} -widget comboBox]
  set_property tooltip {AXI4-Lite Data Width (Xilinx only supports 32-bit)} ${axi_lite_data_width_p}
  set bp_params_p [ipgui::add_param $IPINST -name "bp_params_p" -parent ${Page_0}]
  set_property tooltip {Selects BlackParrot Configuration} ${bp_params_p}


}

proc update_PARAM_VALUE.axi_full_addr_width_p { PARAM_VALUE.axi_full_addr_width_p } {
	# Procedure called to update axi_full_addr_width_p when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.axi_full_addr_width_p { PARAM_VALUE.axi_full_addr_width_p } {
	# Procedure called to validate axi_full_addr_width_p
	return true
}

proc update_PARAM_VALUE.axi_full_burst_type_p { PARAM_VALUE.axi_full_burst_type_p } {
	# Procedure called to update axi_full_burst_type_p when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.axi_full_burst_type_p { PARAM_VALUE.axi_full_burst_type_p } {
	# Procedure called to validate axi_full_burst_type_p
	return true
}

proc update_PARAM_VALUE.axi_full_data_width_p { PARAM_VALUE.axi_full_data_width_p } {
	# Procedure called to update axi_full_data_width_p when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.axi_full_data_width_p { PARAM_VALUE.axi_full_data_width_p } {
	# Procedure called to validate axi_full_data_width_p
	return true
}

proc update_PARAM_VALUE.axi_full_id_width_p { PARAM_VALUE.axi_full_id_width_p } {
	# Procedure called to update axi_full_id_width_p when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.axi_full_id_width_p { PARAM_VALUE.axi_full_id_width_p } {
	# Procedure called to validate axi_full_id_width_p
	return true
}

proc update_PARAM_VALUE.axi_full_strb_width_lp { PARAM_VALUE.axi_full_strb_width_lp } {
	# Procedure called to update axi_full_strb_width_lp when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.axi_full_strb_width_lp { PARAM_VALUE.axi_full_strb_width_lp } {
	# Procedure called to validate axi_full_strb_width_lp
	return true
}

proc update_PARAM_VALUE.axi_lite_addr_width_p { PARAM_VALUE.axi_lite_addr_width_p } {
	# Procedure called to update axi_lite_addr_width_p when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.axi_lite_addr_width_p { PARAM_VALUE.axi_lite_addr_width_p } {
	# Procedure called to validate axi_lite_addr_width_p
	return true
}

proc update_PARAM_VALUE.axi_lite_data_width_p { PARAM_VALUE.axi_lite_data_width_p } {
	# Procedure called to update axi_lite_data_width_p when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.axi_lite_data_width_p { PARAM_VALUE.axi_lite_data_width_p } {
	# Procedure called to validate axi_lite_data_width_p
	return true
}

proc update_PARAM_VALUE.axi_lite_strb_width_lp { PARAM_VALUE.axi_lite_strb_width_lp } {
	# Procedure called to update axi_lite_strb_width_lp when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.axi_lite_strb_width_lp { PARAM_VALUE.axi_lite_strb_width_lp } {
	# Procedure called to validate axi_lite_strb_width_lp
	return true
}

proc update_PARAM_VALUE.bp_params_p { PARAM_VALUE.bp_params_p } {
	# Procedure called to update bp_params_p when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.bp_params_p { PARAM_VALUE.bp_params_p } {
	# Procedure called to validate bp_params_p
	return true
}


proc update_MODELPARAM_VALUE.bp_params_p { MODELPARAM_VALUE.bp_params_p PARAM_VALUE.bp_params_p } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.bp_params_p}] ${MODELPARAM_VALUE.bp_params_p}
}

proc update_MODELPARAM_VALUE.axi_lite_addr_width_p { MODELPARAM_VALUE.axi_lite_addr_width_p PARAM_VALUE.axi_lite_addr_width_p } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.axi_lite_addr_width_p}] ${MODELPARAM_VALUE.axi_lite_addr_width_p}
}

proc update_MODELPARAM_VALUE.axi_lite_data_width_p { MODELPARAM_VALUE.axi_lite_data_width_p PARAM_VALUE.axi_lite_data_width_p } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.axi_lite_data_width_p}] ${MODELPARAM_VALUE.axi_lite_data_width_p}
}

proc update_MODELPARAM_VALUE.axi_lite_strb_width_lp { MODELPARAM_VALUE.axi_lite_strb_width_lp PARAM_VALUE.axi_lite_strb_width_lp } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.axi_lite_strb_width_lp}] ${MODELPARAM_VALUE.axi_lite_strb_width_lp}
}

proc update_MODELPARAM_VALUE.axi_full_addr_width_p { MODELPARAM_VALUE.axi_full_addr_width_p PARAM_VALUE.axi_full_addr_width_p } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.axi_full_addr_width_p}] ${MODELPARAM_VALUE.axi_full_addr_width_p}
}

proc update_MODELPARAM_VALUE.axi_full_data_width_p { MODELPARAM_VALUE.axi_full_data_width_p PARAM_VALUE.axi_full_data_width_p } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.axi_full_data_width_p}] ${MODELPARAM_VALUE.axi_full_data_width_p}
}

proc update_MODELPARAM_VALUE.axi_full_id_width_p { MODELPARAM_VALUE.axi_full_id_width_p PARAM_VALUE.axi_full_id_width_p } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.axi_full_id_width_p}] ${MODELPARAM_VALUE.axi_full_id_width_p}
}

proc update_MODELPARAM_VALUE.axi_full_burst_type_p { MODELPARAM_VALUE.axi_full_burst_type_p PARAM_VALUE.axi_full_burst_type_p } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.axi_full_burst_type_p}] ${MODELPARAM_VALUE.axi_full_burst_type_p}
}

proc update_MODELPARAM_VALUE.axi_full_strb_width_lp { MODELPARAM_VALUE.axi_full_strb_width_lp PARAM_VALUE.axi_full_strb_width_lp } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.axi_full_strb_width_lp}] ${MODELPARAM_VALUE.axi_full_strb_width_lp}
}

