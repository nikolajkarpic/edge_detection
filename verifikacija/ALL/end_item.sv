`ifndef END_ITEM
`define END_ITEM

`include "uvm_macros.svh"
import uvm_pkg::*;

class end_item extends uvm_sequence_item;

    //fields
    bit [7:0]  bram_pixel_data_in;
    bit [13:0] bram_pixel_addr_out;
    bit        bram_read_data_en_out;
    
    bit [1:0]  bram_conv_res_data_out;
    bit [13:0] bram_conv_res_adr_out;
    bit        bram_conv_res_write_en_out;

    bit [7:0]  data [10000];
    // registration macros
    `uvm_object_utils_begin(end_item)
        //field registration
        `uvm_field_int(bram_conv_res_data_out,     UVM_ALL_ON)
        `uvm_field_int(bram_conv_res_adr_out,      UVM_ALL_ON)
        `uvm_field_int(bram_conv_res_write_en_out, UVM_ALL_ON)

        `uvm_field_int(bram_pixel_addr_out,     UVM_ALL_ON)
        `uvm_field_int(bram_pixel_data_in,      UVM_ALL_ON)
        `uvm_field_int(bram_read_data_en_out,   UVM_ALL_ON)
        `uvm_field_sarray_int(data,             UVM_ALL_ON)
    `uvm_object_utils_end
    
    extern function new (string name = "end_item");

endclass : end_item

function end_item::new(string name = "end_item");
    super.new(name);
endfunction : new

`endif // END_ITEM