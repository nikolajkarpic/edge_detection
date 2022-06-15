`ifndef TOP_TB
`define TOP_TB

`timescale 1ns/1ns

module top_tb

`inclide "uvm_macros.svh"

import uvm_pkg::*;
import test_pkg::*;

// signals
wire        CLK_TB, RST_TB;
// end if
wire        BRAM_WRITE_EN_OUT_TB;
wire [1:0]  SIGNED_OUT_TB;
// mem_if
wire [15:0] KERNEL_OUT_0_TB;
wire [15:0] KERNEL_OUT_1_TB;
wire [15:0] KERNEL_OUT_2_TB;
wire        PIXEL_SHIFT_EN_OUT_TB;
wire [7:0]  PIXEL_OUT_0_TB;
wire [7:0]  PIXEL_OUT_1_TB;
wire [7:0]  PIXEL_OUT_2_TB;
reg         PIXEL_SHIFT_EN_TB;
reg  [7:0]  PIXEL_DATA_IN_TB;
reg  [7:0]  KERNEL_ADD_0_TB;
reg  [7:0]  KERNEL_ADD_1_TB;
reg  [7:0]  KERNEL_ADD_2_TB;
// addr if
reg         CALC_ADDR_I_TB;
reg         CALC_CONV_ADDR_I_TB;
reg  [6:0]  I_I_TB;
reg  [6:0]  J_I_TB;
reg  [3:0]  k_I_TB;
reg  [3:0]  l_I_TB;
reg         SHIFT_EN_I_TB;
wire        BRAM_SHIFT_EN_OUT_TB;
wire [13:0] BRAM_SHIFTED_OUT_TB;
wire [13:0] CONV_ADDR_OUT_TB;
wire [7:0]  KRENEL_0_ADDR_O_TB;
wire [7:0]  KRENEL_1_ADDR_O_TB;
wire [7:0]  KRENEL_2_ADDR_O_TB;
// pb if
reg         EN_IN_TB;
reg         RESET_SUM_IN_TB;
reg         SUM_OUT_EN_TB;
reg  [7:0]  PIXEL_0_IN_TB;
reg  [7:0]  PIXEL_2_IN_TB;
reg  [7:0]  PIXEL_1_IN_TB;
reg  [15:0] KERNEL_0_IN_TB;
reg  [15:0] KERNEL_1_IN_TB;
reg  [15:0] KERNEL_2_IN_TB;
// interfaces
pb_interface pb_interface_instace(CLK_TB, RST_TB);
assign EN_IN_TB                                  = pb_interface_instace.en_in;
assign RESET_SUM_IN_TB                           = pb_interface_instace.reset_sum_in;
assign BRAM_WRITE_EN_OUT_TB                      = pb_interface_instace.bram_write_enable_out;
assign SUM_OUT_EN_TB                             = pb_interface_instace.sum_out_en;
assign PIXEL_0_IN_TB                             = pb_interface_instace.pixel_0_in;
assign PIXEL_1_IN_TB                             = pb_interface_instace.pixel_1_in;
assign PIXEL_2_IN_TB                             = pb_interface_instace.pixel_2_in;
assign kernel_0_in                               = pb_interface_instace.kernel_0_in;
assign kernel_1_in                               = pb_interface_instace.kernel_1_in;
assign kernel_2_in                               = pb_interface_instace.kernel_2_in;

end_interface end_interface_inst(CLK_TB, RST_TB);
assign end_interface_inst.bram_write_enable_out  = BRAM_WRITE_EN_OUT_TB;
assign end_interface_inst.signed_out             = SIGNED_OUT_TB;

mem_interface mem_interface_inst(CLK_TB, RST_TB);
assign PIXEL_SHIFT_EN_TB                         = mem_interface_inst.pixel_shift_en;
assign PIXEL_DATA_IN_TB                          = mem_interface_inst.pixel_data_in;
assign KERNEL_ADD_0_TB                           = mem_interface_inst.kernel_add_0;
assign KERNEL_ADD_1_TB                           = mem_interface_inst.kernel_add_1;
assign KERNEL_ADD_2_TB                           = mem_interface_inst.kernel_add_2;
assign mem_interface_inst.pixel_out_0            = PIXEL_OUT_0_TB;
assign mem_interface_inst.pixel_out_1            = PIXEL_OUT_1_TB;
assign mem_interface_inst.pixel_out_2            = PIXEL_OUT_2_TB;
assign mem_interface_inst.kernel_out_0           = KERNEL_OUT_0_TB;
assign mem_interface_inst.kernel_out_1           = KERNEL_OUT_1_TB;
assign mem_interface_inst.kernel_out_2           = KERNEL_OUT_2_TB;
assign mem_interface_inst.pixel_shift_en_out     = PIXEL_SHIFT_EN_OUT_TB;

addr_interface addr_interface_instance(CLK_TB, RST_TB);
assign CALC_ADDR_I_TB                            = addr_interface_instance.calc_addr_i;
assign CALC_CONV_ADDR_I_TB                       = addr_interface_instance.calc_conv_addr_i;
assign I_I_TB                                    = addr_interface_instance.i_i;
assign J_I_TB                                    = addr_interface_instance.j_i;
assign K_I_TB                                    = addr_interface_instance.k_i;
assign L_I_TB                                    = addr_interface_instance.l_i;
assign SHIFT_EN_I_TB                             = addr_interface_instance.shift_en_i;
assign addr_interface_instance.bram_shift_en_out = BRAM_SHIFT_EN_OUT_TB;
assign addr_interface_instance.bram_shifted_out  = BRAM_SHIFTED_OUT_TB;
assign addr_interface_instance.conv_addr_out     = CONV_ADDR_OUT_TB;
assign addr_interface_instance.kernel_0_addr_o   = KRENEL_0_ADDR_O_TB;
assign addr_interface_instance.kernel_1_addr_o   = KRENEL_1_ADDR_O_TB;
assign addr_interface_instance.kernel_2_addr_o   = KRENEL_2_ADDR_O_TB;
// DUT instance
convolution_ip conv(
    .clk(CLK_TB);
    .reset_in(RST_TB);
    .start_in();
    
    .ready_out();
    .done_out();

    .bram_pixel_data_in(/*signal*/);

    .bram_read_data_out();
    .bram_pixel_addr_out();
    .bram_conv_res_data_out();
    .bram_conv_res_adr_out();
    bram_conv_res_write_en_out();
);
// backdoor signals
assign conv.adr_control.calc_addr_i              = addr_interface_instance.calc_addr_i;
assign conv.adr_control.calc_conv_addr_i         = addr_interface_instance.calc_conv_addr_i;
assign conv.adr_control.i_i                      = addr_interface_instance.i_i;
assign conv.adr_control.j_i                      = addr_interface_instance.j_i;
assign conv.adr_control.k_i                      = addr_interface_instance.k_i;
assign conv.adr_control.l_i                      = addr_interface_instance.l_i;
assign conv.adr_control.shift_en_i               = addr_interface_instance;
assign addr_interface_instance.bram_shift_en_out = conv.adr_control.bram_shift_en_out;
assign addr_interface_instance.bram_shifted_out  = conv.adr_control.bram_shifted_out;
assign addr_interface_instance.conv_addr_out     = conv.adr_control.conv_addr_out;
assign addr_interface_instance.kernel_0_addr_o   = conv.adr_control.kernel_0_addr_o;
assign addr_interface_instance.kernel_1_addr_o   = conv.adr_control.kernel_1_addr_o;
assign addr_interface_instance.kernel_2_addr_o   = conv.adr_control.kernel_2_addr_o;

assign end_interface_inst.bram_write_enable_out  = conv.proccesing_block.bram_write_enable_out;
assign end_interface_inst.signed_out             = conv.proccesing_block.signed_out;

assign conv.memory_controler.pixel_shift_en      = mem_interface_inst.pixel_shift_en;
assign conv.memory_controler.pixel_data_in       = mem_interface_inst.pixel_data_in;
assign conv.memory_controler.r_0_kernel_addr_in  = mem_interface_inst.kernel_add_0;
assign conv.memory_controler.r_1_kernel_addr_in  = mem_interface_inst.kernel_add_1;
assign conv.memory_controler.r_2_kernel_addr_in  = mem_interface_inst.kernel_add_2;
assign mem_interface_inst.pixel_out_0            = conv.memory_controler.pixel_0_data_out;
assign mem_interface_inst.pixel_out_1            = conv.memory_controler.pixel_1_data_out;
assign mem_interface_inst.pixel_out_2            = conv.memory_controler.pixel_2_data_out;
assign mem_interface_inst.kernel_out_0           = conv.memory_controler.r_0_kernel_data_out;
assign mem_interface_inst.kernel_out_1           = conv.memory_controler.r_1_kernel_data_out;
assign mem_interface_inst.kernel_out_2           = conv.memory_controler.r_2_kernel_data_out;
assign mem_interface_inst.pixel_shift_en_out     = conv.memory_controler.pixel_shift_en_out;

assign conv.proccesing_block.en_in               = pb_interface_instace.en_in;
assign conv.proccesing_block.reset_sum_in        = pb_interface_instace.reset_sum_in;
assign conv.proccesing_block.pixel_0_in          = pb_interface_instace.pixel_0_in;
assign conv.proccesing_block.pixel_1_in          = pb_interface_instace.pixel_1_in;
assign conv.proccesing_block.pixel_2_in          = pb_interface_instace.pixel_2_in;
assign conv.proccesing_block.kernel_0_in         = pb_interface_instace.kernel_0_in;
assign conv.proccesing_block.kernel_1_in         = pb_interface_instace.kernel_1_in;
assign conv.proccesing_block.kernel_2_in         = pb_interface_instace.kernel_2_in;
// run test
initial begin : run_test
    run_test();
end

endmodule : top_tb

`endif // TOP_TB