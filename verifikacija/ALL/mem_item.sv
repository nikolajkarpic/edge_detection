`ifndef MEM_ITEM
`define MEM_ITEM


`include "uvm_macros.svh"
import uvm_pkg::*;

class mem_item extends uvm_sequence_item;

    //fields
    rand bit [7:0] kernel_add_0;
    rand bit [7:0] kernel_add_1;
    rand bit [7:0] kernel_add_2;
    rand bit [7:0]  pixel_data;
    rand bit [7:0]  pixel_out_0;
    rand bit [7:0]  pixel_out_1;
    rand bit [7:0]  pixel_out_2;
    rand bit [15:0]  kernel_out_0;
    rand bit [15:0]  kernel_out_1;
    rand bit [15:0]  kernel_out_2;
    mem_packet_type p_type;
    // registration macros
    `uvm_object_utils_begin(mem_item)
        //field registration
        `uvm_field_enum(mem_packet_type, p_type, UVM_ALL_ON)
        `uvm_field_int(kernel_add_0, UVM_ALL_ON)
        `uvm_field_int(kernel_add_1, UVM_ALL_ON)
        `uvm_field_int(kernel_add_2, UVM_ALL_ON)
        `uvm_field_int(pixel_out_0, UVM_ALL_ON)
        `uvm_field_int(pixel_out_1, UVM_ALL_ON)
        `uvm_field_int(pixel_out_2, UVM_ALL_ON)
        `uvm_field_int(pixel_data, UVM_ALL_ON)
    `uvm_object_utils_end

extern function new (string name = "mem_item");

endclass : mem_item

function mem_item::new(string name = "mem_item");
    super.new(name);
endfunction : new

`endif // MEM_ITEM