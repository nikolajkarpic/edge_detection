`ifndef TOP_TB
`define TOP_TB

`timescale 1ns/1ns

module top_tb;

`include "uvm_macros.svh"
import uvm_pkg::*;
import test_pkg::*;

// signals
wire        CLK_TB;
wire        RST_TB;
// end if
wire [13:0] BRAM_CONV_RES_ADR_OUT_TB;
wire        BRAM_CONV_RES_WRITE_EN_OUT_TB;
wire [1:0]  BRAM_CONV_RES_DATA_OUT_TB;
wire [13:0] BRAM_PIXEL_ADDR_OUT_TB;
wire [7:0]  BRAM_PIXEL_DATA_IN_TB;
reg         BRAM_READ_DATA_EN_OUT_TB;
reg         START_TB;
reg         RESET_IN_TB;
wire        DONE_OUT_TB;
wire        READY_OUT_TB;


// mem_if
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
reg  [3:0]  K_I_TB;
reg  [3:0]  L_I_TB;
reg         SHIFT_EN_I_TB;
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
assign SUM_OUT_EN_TB                             = pb_interface_instace.sum_out_en;
assign PIXEL_0_IN_TB                             = pb_interface_instace.pixel_0_in;
assign PIXEL_1_IN_TB                             = pb_interface_instace.pixel_1_in;
assign PIXEL_2_IN_TB                             = pb_interface_instace.pixel_2_in;
assign KERNEL_0_IN_TB                            = pb_interface_instace.kernel_0_in;
assign KERNEL_1_IN_TB                            = pb_interface_instace.kernel_1_in;
assign KERNEL_2_IN_TB                            = pb_interface_instace.kernel_2_in;

end_interface end_interface_inst(CLK_TB, RST_TB);
assign end_interface_inst.bram_conv_res_write_en_out  = BRAM_CONV_RES_WRITE_EN_OUT_TB;
assign end_interface_inst.bram_conv_res_data_out      = BRAM_CONV_RES_DATA_OUT_TB;
assign end_interface_inst.bram_conv_res_adr_out       = BRAM_CONV_RES_ADR_OUT_TB;
assign end_interface_inst.bram_read_data_en_out       = BRAM_READ_DATA_EN_OUT_TB;
assign end_interface_inst.bram_pixel_addr_out         = BRAM_PIXEL_ADDR_OUT_TB;
assign BRAM_PIXEL_DATA_IN_TB                          = end_interface_inst.bram_pixel_data_in;
assign START_TB                                       = end_interface_inst.start;
assign RESET_IN_TB                                    = end_interface_inst.reset_in;
assign end_interface_inst.ready_out                   = READY_OUT_TB;
assign end_interface_inst.done_out                    = DONE_OUT_TB;

mem_interface mem_interface_inst(CLK_TB, RST_TB);
assign PIXEL_SHIFT_EN_TB                         = mem_interface_inst.pixel_shift_en;
assign PIXEL_DATA_IN_TB                          = mem_interface_inst.pixel_data_in;
assign KERNEL_ADD_0_TB                           = mem_interface_inst.kernel_add_0;
assign KERNEL_ADD_1_TB                           = mem_interface_inst.kernel_add_1;
assign KERNEL_ADD_2_TB                           = mem_interface_inst.kernel_add_2;

addr_interface addr_interface_instance(CLK_TB, RST_TB);
assign CALC_ADDR_I_TB                            = addr_interface_instance.calc_addr_i;
assign CALC_CONV_ADDR_I_TB                       = addr_interface_instance.calc_conv_addr_i;
assign I_I_TB                                    = addr_interface_instance.i_i;
assign J_I_TB                                    = addr_interface_instance.j_i;
assign K_I_TB                                    = addr_interface_instance.k_i;
assign L_I_TB                                    = addr_interface_instance.l_i;
assign SHIFT_EN_I_TB                             = addr_interface_instance.shift_en_i;
// DUT instance
convolution_ip conv(
    .clk(CLK_TB),
    .reset_in(RST_TB),
    .start_in(START_TB),
    
    .ready_out(READY_OUT_TB),
    .done_out(DONE_OUT_TB),

    .bram_pixel_data_in(BRAM_PIXEL_DATA_IN_TB),

    .bram_read_data_out(BRAM_READ_DATA_EN_OUT_TB),
    .bram_pixel_addr_out(BRAM_PIXEL_ADDR_OUT_TB),
    .bram_conv_res_data_out(BRAM_CONV_RES_DATA_OUT_TB),
    .bram_conv_res_adr_out(BRAM_CONV_RES_ADR_OUT_TB),
    .bram_conv_res_write_en_out(BRAM_CONV_RES_WRITE_EN_OUT_TB)
);
// backdoor signals
assign conv.adr_control.calc_addr_i              = CALC_ADDR_I_TB;
assign conv.adr_control.calc_conv_addr_i         = CALC_CONV_ADDR_I_TB;
assign conv.adr_control.i_i                      = I_I_TB;
assign conv.adr_control.j_i                      = J_I_TB;
assign conv.adr_control.k_i                      = K_I_TB;
assign conv.adr_control.l_i                      = L_I_TB;
assign conv.adr_control.shift_en_i               = SHIFT_EN_I_TB;

assign conv.memory_controler.pixel_shift_en      = PIXEL_SHIFT_EN_TB;
assign conv.memory_controler.pixel_data_in       = PIXEL_DATA_IN_TB;
assign conv.memory_controler.r_0_kernel_addr_in  = KERNEL_ADD_0_TB;
assign conv.memory_controler.r_1_kernel_addr_in  = KERNEL_ADD_1_TB;
assign conv.memory_controler.r_2_kernel_addr_in  = KERNEL_ADD_2_TB;

assign conv.proccesing_block.en_in               = EN_IN_TB;
assign conv.proccesing_block.reset_sum_in        = RESET_SUM_IN_TB;
assign conv.proccesing_block.pixel_0_in          = PIXEL_0_IN_TB;
assign conv.proccesing_block.pixel_1_in          = PIXEL_1_IN_TB;
assign conv.proccesing_block.pixel_2_in          = PIXEL_2_IN_TB;
assign conv.proccesing_block.kernel_0_in         = KERNEL_0_IN_TB;
assign conv.proccesing_block.kernel_1_in         = KERNEL_1_IN_TB;
assign conv.proccesing_block.kernel_2_in         = KERNEL_2_IN_TB;

// run test
initial begin : run_test_block
    run_test();
end

endmodule : top_tb

`endif // TOP_TB