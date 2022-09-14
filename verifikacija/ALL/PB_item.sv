`ifndef PB_ITEM
`define PB_ITEM

`include "uvm_macros.svh"
`include "pb_common.sv"
import uvm_pkg::*;

class pb_item extends uvm_sequence_item;

    //fields
    pb_packet_type p_type;
    rand bit [7:0] pixel_0_in[$];
    rand bit [7:0] pixel_1_in[$];
    rand bit [7:0] pixel_2_in[$];
    rand bit [15:0] kernel_0_in[$];
    rand bit [15:0] kernel_1_in[$];
    rand bit [15:0] kernel_2_in[$];
    // registration macros
    `uvm_object_utils_begin(pb_item)
        `uvm_field_enum(pb_packet_type, p_type, UVM_ALL_ON)
        `uvm_field_queue_int(pixel_0_in, UVM_ALL_ON)
        `uvm_field_queue_int(pixel_1_in, UVM_ALL_ON)
        `uvm_field_queue_int(pixel_2_in, UVM_ALL_ON)
        `uvm_field_queue_int(kernel_0_in, UVM_ALL_ON)
        `uvm_field_queue_int(kernel_1_in, UVM_ALL_ON)
        `uvm_field_queue_int(kernel_2_in, UVM_ALL_ON)
    `uvm_object_utils_end
    
    extern function new(string name = "pb_item");

endclass : pb_item

function pb_item::new(string name = "pb_item");
    super.new(name);
endfunction : new

`endif // PB_ITEM