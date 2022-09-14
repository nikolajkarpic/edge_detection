`ifndef END_INTERFACE
`define END_INTERFACE

interface end_interface(input CLK, input RST);

    `include "uvm_macros.svh"

    // signals
    logic [13:0] bram_pixel_addr_out;
    logic        bram_read_data_en_out;
    logic [7:0]  bram_pixel_data_in;

    logic [1:0]  bram_conv_res_data_out;
    logic        bram_conv_res_write_en_out;
    logic [13:0] bram_conv_res_adr_out;

    logic reset_in;
    logic start;
    logic readry_out;
    logic done_out;
    
endinterface : end_interface

`endif // END_INTERFACE