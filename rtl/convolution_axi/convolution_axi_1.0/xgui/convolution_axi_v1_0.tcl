# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_S00_AXI_DATA_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_S00_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_HIGHADDR" -parent ${Page_0}


}

proc update_PARAM_VALUE.BRAM_size { PARAM_VALUE.BRAM_size } {
	# Procedure called to update BRAM_size when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BRAM_size { PARAM_VALUE.BRAM_size } {
	# Procedure called to validate BRAM_size
	return true
}

proc update_PARAM_VALUE.DEFAULT_IMG_SIZE { PARAM_VALUE.DEFAULT_IMG_SIZE } {
	# Procedure called to update DEFAULT_IMG_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEFAULT_IMG_SIZE { PARAM_VALUE.DEFAULT_IMG_SIZE } {
	# Procedure called to validate DEFAULT_IMG_SIZE
	return true
}

proc update_PARAM_VALUE.DEPTH { PARAM_VALUE.DEPTH } {
	# Procedure called to update DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEPTH { PARAM_VALUE.DEPTH } {
	# Procedure called to validate DEPTH
	return true
}

proc update_PARAM_VALUE.KERNEL_SIZE { PARAM_VALUE.KERNEL_SIZE } {
	# Procedure called to update KERNEL_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.KERNEL_SIZE { PARAM_VALUE.KERNEL_SIZE } {
	# Procedure called to validate KERNEL_SIZE
	return true
}

proc update_PARAM_VALUE.SIGNED_UNSIGNED { PARAM_VALUE.SIGNED_UNSIGNED } {
	# Procedure called to update SIGNED_UNSIGNED when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIGNED_UNSIGNED { PARAM_VALUE.SIGNED_UNSIGNED } {
	# Procedure called to validate SIGNED_UNSIGNED
	return true
}

proc update_PARAM_VALUE.SIZE { PARAM_VALUE.SIZE } {
	# Procedure called to update SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIZE { PARAM_VALUE.SIZE } {
	# Procedure called to validate SIZE
	return true
}

proc update_PARAM_VALUE.WIDTH_adr { PARAM_VALUE.WIDTH_adr } {
	# Procedure called to update WIDTH_adr when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_adr { PARAM_VALUE.WIDTH_adr } {
	# Procedure called to validate WIDTH_adr
	return true
}

proc update_PARAM_VALUE.WIDTH_bram_adr { PARAM_VALUE.WIDTH_bram_adr } {
	# Procedure called to update WIDTH_bram_adr when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_bram_adr { PARAM_VALUE.WIDTH_bram_adr } {
	# Procedure called to validate WIDTH_bram_adr
	return true
}

proc update_PARAM_VALUE.WIDTH_bram_in_out_adr { PARAM_VALUE.WIDTH_bram_in_out_adr } {
	# Procedure called to update WIDTH_bram_in_out_adr when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_bram_in_out_adr { PARAM_VALUE.WIDTH_bram_in_out_adr } {
	# Procedure called to validate WIDTH_bram_in_out_adr
	return true
}

proc update_PARAM_VALUE.WIDTH_conv_out_data { PARAM_VALUE.WIDTH_conv_out_data } {
	# Procedure called to update WIDTH_conv_out_data when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_conv_out_data { PARAM_VALUE.WIDTH_conv_out_data } {
	# Procedure called to validate WIDTH_conv_out_data
	return true
}

proc update_PARAM_VALUE.WIDTH_data { PARAM_VALUE.WIDTH_data } {
	# Procedure called to update WIDTH_data when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_data { PARAM_VALUE.WIDTH_data } {
	# Procedure called to validate WIDTH_data
	return true
}

proc update_PARAM_VALUE.WIDTH_img_size { PARAM_VALUE.WIDTH_img_size } {
	# Procedure called to update WIDTH_img_size when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_img_size { PARAM_VALUE.WIDTH_img_size } {
	# Procedure called to validate WIDTH_img_size
	return true
}

proc update_PARAM_VALUE.WIDTH_kernel { PARAM_VALUE.WIDTH_kernel } {
	# Procedure called to update WIDTH_kernel when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_kernel { PARAM_VALUE.WIDTH_kernel } {
	# Procedure called to validate WIDTH_kernel
	return true
}

proc update_PARAM_VALUE.WIDTH_kernel_addr { PARAM_VALUE.WIDTH_kernel_addr } {
	# Procedure called to update WIDTH_kernel_addr when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_kernel_addr { PARAM_VALUE.WIDTH_kernel_addr } {
	# Procedure called to validate WIDTH_kernel_addr
	return true
}

proc update_PARAM_VALUE.WIDTH_kernel_adr { PARAM_VALUE.WIDTH_kernel_adr } {
	# Procedure called to update WIDTH_kernel_adr when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_kernel_adr { PARAM_VALUE.WIDTH_kernel_adr } {
	# Procedure called to validate WIDTH_kernel_adr
	return true
}

proc update_PARAM_VALUE.WIDTH_kernel_data { PARAM_VALUE.WIDTH_kernel_data } {
	# Procedure called to update WIDTH_kernel_data when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_kernel_data { PARAM_VALUE.WIDTH_kernel_data } {
	# Procedure called to validate WIDTH_kernel_data
	return true
}

proc update_PARAM_VALUE.WIDTH_kernel_size { PARAM_VALUE.WIDTH_kernel_size } {
	# Procedure called to update WIDTH_kernel_size when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_kernel_size { PARAM_VALUE.WIDTH_kernel_size } {
	# Procedure called to validate WIDTH_kernel_size
	return true
}

proc update_PARAM_VALUE.WIDTH_num_of_pixels_in_bram { PARAM_VALUE.WIDTH_num_of_pixels_in_bram } {
	# Procedure called to update WIDTH_num_of_pixels_in_bram when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_num_of_pixels_in_bram { PARAM_VALUE.WIDTH_num_of_pixels_in_bram } {
	# Procedure called to validate WIDTH_num_of_pixels_in_bram
	return true
}

proc update_PARAM_VALUE.WIDTH_pixel { PARAM_VALUE.WIDTH_pixel } {
	# Procedure called to update WIDTH_pixel when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_pixel { PARAM_VALUE.WIDTH_pixel } {
	# Procedure called to validate WIDTH_pixel
	return true
}

proc update_PARAM_VALUE.WIDTH_sum { PARAM_VALUE.WIDTH_sum } {
	# Procedure called to update WIDTH_sum when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_sum { PARAM_VALUE.WIDTH_sum } {
	# Procedure called to validate WIDTH_sum
	return true
}

proc update_PARAM_VALUE.num_of_pixels { PARAM_VALUE.num_of_pixels } {
	# Procedure called to update num_of_pixels when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.num_of_pixels { PARAM_VALUE.num_of_pixels } {
	# Procedure called to validate num_of_pixels
	return true
}

proc update_PARAM_VALUE.reg_nuber { PARAM_VALUE.reg_nuber } {
	# Procedure called to update reg_nuber when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.reg_nuber { PARAM_VALUE.reg_nuber } {
	# Procedure called to validate reg_nuber
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.SIZE { MODELPARAM_VALUE.SIZE PARAM_VALUE.SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SIZE}] ${MODELPARAM_VALUE.SIZE}
}

proc update_MODELPARAM_VALUE.WIDTH_num_of_pixels_in_bram { MODELPARAM_VALUE.WIDTH_num_of_pixels_in_bram PARAM_VALUE.WIDTH_num_of_pixels_in_bram } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_num_of_pixels_in_bram}] ${MODELPARAM_VALUE.WIDTH_num_of_pixels_in_bram}
}

proc update_MODELPARAM_VALUE.DEFAULT_IMG_SIZE { MODELPARAM_VALUE.DEFAULT_IMG_SIZE PARAM_VALUE.DEFAULT_IMG_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEFAULT_IMG_SIZE}] ${MODELPARAM_VALUE.DEFAULT_IMG_SIZE}
}

proc update_MODELPARAM_VALUE.WIDTH_data { MODELPARAM_VALUE.WIDTH_data PARAM_VALUE.WIDTH_data } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_data}] ${MODELPARAM_VALUE.WIDTH_data}
}

proc update_MODELPARAM_VALUE.WIDTH_adr { MODELPARAM_VALUE.WIDTH_adr PARAM_VALUE.WIDTH_adr } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_adr}] ${MODELPARAM_VALUE.WIDTH_adr}
}

proc update_MODELPARAM_VALUE.WIDTH_bram_adr { MODELPARAM_VALUE.WIDTH_bram_adr PARAM_VALUE.WIDTH_bram_adr } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_bram_adr}] ${MODELPARAM_VALUE.WIDTH_bram_adr}
}

proc update_MODELPARAM_VALUE.BRAM_size { MODELPARAM_VALUE.BRAM_size PARAM_VALUE.BRAM_size } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BRAM_size}] ${MODELPARAM_VALUE.BRAM_size}
}

proc update_MODELPARAM_VALUE.num_of_pixels { MODELPARAM_VALUE.num_of_pixels PARAM_VALUE.num_of_pixels } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.num_of_pixels}] ${MODELPARAM_VALUE.num_of_pixels}
}

proc update_MODELPARAM_VALUE.reg_nuber { MODELPARAM_VALUE.reg_nuber PARAM_VALUE.reg_nuber } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.reg_nuber}] ${MODELPARAM_VALUE.reg_nuber}
}

proc update_MODELPARAM_VALUE.WIDTH_conv_out_data { MODELPARAM_VALUE.WIDTH_conv_out_data PARAM_VALUE.WIDTH_conv_out_data } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_conv_out_data}] ${MODELPARAM_VALUE.WIDTH_conv_out_data}
}

proc update_MODELPARAM_VALUE.DEPTH { MODELPARAM_VALUE.DEPTH PARAM_VALUE.DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEPTH}] ${MODELPARAM_VALUE.DEPTH}
}

proc update_MODELPARAM_VALUE.WIDTH_kernel_addr { MODELPARAM_VALUE.WIDTH_kernel_addr PARAM_VALUE.WIDTH_kernel_addr } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_kernel_addr}] ${MODELPARAM_VALUE.WIDTH_kernel_addr}
}

proc update_MODELPARAM_VALUE.WIDTH_img_size { MODELPARAM_VALUE.WIDTH_img_size PARAM_VALUE.WIDTH_img_size } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_img_size}] ${MODELPARAM_VALUE.WIDTH_img_size}
}

proc update_MODELPARAM_VALUE.KERNEL_SIZE { MODELPARAM_VALUE.KERNEL_SIZE PARAM_VALUE.KERNEL_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.KERNEL_SIZE}] ${MODELPARAM_VALUE.KERNEL_SIZE}
}

proc update_MODELPARAM_VALUE.WIDTH_kernel_size { MODELPARAM_VALUE.WIDTH_kernel_size PARAM_VALUE.WIDTH_kernel_size } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_kernel_size}] ${MODELPARAM_VALUE.WIDTH_kernel_size}
}

proc update_MODELPARAM_VALUE.WIDTH_kernel_data { MODELPARAM_VALUE.WIDTH_kernel_data PARAM_VALUE.WIDTH_kernel_data } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_kernel_data}] ${MODELPARAM_VALUE.WIDTH_kernel_data}
}

proc update_MODELPARAM_VALUE.WIDTH_pixel { MODELPARAM_VALUE.WIDTH_pixel PARAM_VALUE.WIDTH_pixel } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_pixel}] ${MODELPARAM_VALUE.WIDTH_pixel}
}

proc update_MODELPARAM_VALUE.WIDTH_kernel { MODELPARAM_VALUE.WIDTH_kernel PARAM_VALUE.WIDTH_kernel } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_kernel}] ${MODELPARAM_VALUE.WIDTH_kernel}
}

proc update_MODELPARAM_VALUE.WIDTH_sum { MODELPARAM_VALUE.WIDTH_sum PARAM_VALUE.WIDTH_sum } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_sum}] ${MODELPARAM_VALUE.WIDTH_sum}
}

proc update_MODELPARAM_VALUE.WIDTH_bram_in_out_adr { MODELPARAM_VALUE.WIDTH_bram_in_out_adr PARAM_VALUE.WIDTH_bram_in_out_adr } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_bram_in_out_adr}] ${MODELPARAM_VALUE.WIDTH_bram_in_out_adr}
}

proc update_MODELPARAM_VALUE.WIDTH_kernel_adr { MODELPARAM_VALUE.WIDTH_kernel_adr PARAM_VALUE.WIDTH_kernel_adr } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_kernel_adr}] ${MODELPARAM_VALUE.WIDTH_kernel_adr}
}

proc update_MODELPARAM_VALUE.SIGNED_UNSIGNED { MODELPARAM_VALUE.SIGNED_UNSIGNED PARAM_VALUE.SIGNED_UNSIGNED } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SIGNED_UNSIGNED}] ${MODELPARAM_VALUE.SIGNED_UNSIGNED}
}

