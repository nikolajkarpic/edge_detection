`ifndef PB_INTERFACE
`define PB_INTERFACE

interface pb_interface(input CLK, input RST);

    `include "uvm_macros.svh"

    // signals
    logic en_in;
    logic reset_sum_in;
    logic bram_write_enable_out;
    logic sum_out_en;
    logic [7:0] pixel_0_in;
    logic [7:0] pixel_1_in;
    logic [7:0] pixel_2_in;
    logic [15:0] kernel_0_in;
    logic [15:0] kernel_1_in;
    logic [15:0] kernel_2_in;


endinterface : pb_interface

`endif // PB_INTERFACE