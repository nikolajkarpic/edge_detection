`ifndef ADDR_INTERFACE
`define ADDR_INTERFACE

interface addr_interface(input CLK, input RST);

    `include "uvm_macros.svh"

    // signals
    logic calc_addr_i;
    logic calc_conv_addr_i;
    logic [6:0] i_i;
    logic [6:0] j_i;
    logic [3:0] k_i;
    logic [3:0] l_i;
    logic shift_en_i;
    logic bram_shift_en_out;
    logic [13:0] bram_shifted_out;
    logic [13:0] conv_addr_out;
    logic [7:0] kernel_0_addr_o;
    logic [7:0] kernel_1_addr_o;
    logic [7:0] kernel_2_addr_o;

endinterface : addr_interface

`endif // ADDR_INTERFACE