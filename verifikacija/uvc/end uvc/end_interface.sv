`ifndef END_INTERFACE
`define END_INTERFACE

interface end_interface(input CLK, input RST);

    `include "uvm_macros.svh"

    // signals
    logic bram_write_enable_out;
    logic [1:0] signed_out;
endinterface : end_interface

`endif // END_INTERFACE