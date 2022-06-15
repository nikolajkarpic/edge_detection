`ifndef MEM_INTERFACE
`define MEM_INTERFACE

interface mem_interface(input CLK, input RST);

    `include "uvm_macros.svh"

    // signals
    logic pixel_shift_en;
    logic [7:0] pixel_data_in;
    logic [7:0] kernel_add_0;
    logic [7:0] kernel_add_1;
    logic [7:0] kernel_add_2;
    logic [7:0] pixel_out_0;
    logic [7:0] pixel_out_1;
    logic [7:0] pixel_out_2;
    logic [15:0] kernel_out_0;
    logic [15:0] kernel_out_1;
    logic [15:0] kernel_out_2;
    logic pixel_shift_en_out;

endinterface : mem_interface

`endif // MEM_INTERFACE