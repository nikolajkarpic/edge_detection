start_gui
create_project edge_detection D:/ftn/psds/edge_detection -part xc7z010clg400-1
set_property board_part digilentinc.com:zybo:part0:2.0 [current_project]
set_property target_language VHDL [current_project]
set_property simulator_language VHDL [current_project]
import_files -norecurse {C:/FTN/edge_detection/rtl/convolution/accumulate_sum.vhd C:/FTN/edge_detection/rtl/convolution/memory_submodule.vhd C:/FTN/edge_detection/rtl/convolution/memory_control.vhd C:/FTN/edge_detection/rtl/convolution/MAC.vhd C:/FTN/edge_detection/rtl/convolution/convolution_axi_v1_0_S00_AXI.vhd C:/FTN/edge_detection/rtl/convolution/FSM.vhd C:/FTN/edge_detection/rtl/convolution/convolution_axi_v1_0.vhd C:/FTN/edge_detection/rtl/convolution/PB_group.vhd C:/FTN/edge_detection/rtl/convolution/adress_controler.vhd C:/FTN/edge_detection/rtl/convolution/bram.vhd C:/FTN/edge_detection/rtl/convolution/convolutin_ip.vhd}
update_compile_order -fileset sources_1
update_compile_order -fileset sources_1
ipx::package_project -root_dir d:/ftn/psds/edge_detection/edge_detection.srcs/sources_1/imports/convolution -vendor xilinx.com -library user -taxonomy /UserIP
set_property core_revision 2 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property  ip_repo_paths  d:/ftn/psds/edge_detection/edge_detection.srcs/sources_1/imports/convolution [current_project]
update_ip_catalog
create_bd_design "design_1"
update_compile_order -fileset sources_1
startgroup
create_bd_cell -type ip -vlnv xilinx.com:user:convolution_axi_v1_0:1.0 convolution_axi_v1_0_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_1
endgroup
set_property location {1 228 -131} [get_bd_cells processing_system7_0]
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/axi_bram_ctrl_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI SmartConnect} master_apm {0}}  [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/axi_bram_ctrl_1/S_AXI} ddr_seg {Auto} intc_ip {New AXI SmartConnect} master_apm {0}}  [get_bd_intf_pins axi_bram_ctrl_1/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/convolution_axi_v1_0_0/s00_axi} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins convolution_axi_v1_0_0/s00_axi]
endgroup
set_property location {2 548 26} [get_bd_cells rst_ps7_0_50M]
set_property location {2 525 -184} [get_bd_cells axi_bram_ctrl_1]
set_property location {1 124 -340} [get_bd_cells processing_system7_0]
set_property location {1 185 -118} [get_bd_cells rst_ps7_0_50M]
set_property location {2 542 27} [get_bd_cells axi_bram_ctrl_1]
set_property location {2 543 -149} [get_bd_cells axi_bram_ctrl_0]
startgroup
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1}] [get_bd_cells axi_bram_ctrl_0]
endgroup
startgroup
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1}] [get_bd_cells axi_bram_ctrl_1]
endgroup
connect_bd_net [get_bd_pins axi_bram_ctrl_0/bram_addr_a] [get_bd_pins convolution_axi_v1_0_0/bram_pixel_adr_in]
connect_bd_net [get_bd_pins axi_bram_ctrl_0/bram_wrdata_a] [get_bd_pins convolution_axi_v1_0_0/bram_pixel_data_in]
connect_bd_net [get_bd_pins axi_bram_ctrl_0/bram_en_a] [get_bd_pins convolution_axi_v1_0_0/bram_write_data_en_in]
connect_bd_net [get_bd_pins convolution_axi_v1_0_0/bram_sign_data_out] [get_bd_pins axi_bram_ctrl_1/bram_rddata_a]
connect_bd_net [get_bd_pins axi_bram_ctrl_1/bram_addr_a] [get_bd_pins convolution_axi_v1_0_0/bram_sign_read_adr]
connect_bd_net [get_bd_pins axi_bram_ctrl_1/bram_en_a] [get_bd_pins convolution_axi_v1_0_0/bram_read_sign_data_en]
delete_bd_objs [get_bd_nets axi_bram_ctrl_0_bram_en_a]
connect_bd_net [get_bd_pins axi_bram_ctrl_0/bram_we_a] [get_bd_pins convolution_axi_v1_0_0/bram_write_data_en_in]
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
save_bd_design
close_bd_design [get_bd_designs design_1]
