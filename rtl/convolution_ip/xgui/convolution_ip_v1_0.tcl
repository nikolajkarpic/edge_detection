# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BRAM_size" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEFAULT_IMG_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEPTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "KERNEL_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SIGNED_UNSIGNED" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_adr" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_bram_adr" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_bram_in_out_adr" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_conv_out_data" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_data" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_img_size" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_kernel" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_kernel_addr" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_kernel_adr" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_kernel_data" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_kernel_size" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_num_of_pixels_in_bram" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_pixel" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_sum" -parent ${Page_0}
  ipgui::add_param $IPINST -name "num_of_pixels" -parent ${Page_0}
  ipgui::add_param $IPINST -name "reg_nuber" -parent ${Page_0}


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

