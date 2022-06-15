`ifndef MEM_ITEM
`define MEM_ITEM

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
    `uvm_component_utils_begin(mem_item)
        //field registration
        `uvm_field_enum(mem_packet_type, p_type, UVM_ALL_ON)
        `uvm_field_int(kernel_add_0, UVM_ALL_ON)
        `uvm_field_int(kernel_add_1, UVM_ALL_ON)
        `uvm_field_int(kernel_add_2, UVM_ALL_ON)
        `uvm_field_int(pixel_out_0, UVM_ALL_ON)
        `uvm_field_int(pixel_out_1, UVM_ALL_ON)
        `uvm_field_int(pixel_out_2, UVM_ALL_ON)
        `uvm_field_int(pixel_data, UVM_ALL_ON)
        `uvm_field_int(kernel_out1, UVM_ALL_ON)
        `uvm_field_int(kernel_out2, UVM_ALL_ON)
        `uvm_field_int(kernel_data, UVM_ALL_ON)
    `uvm_component_utils_end

endclass : mem_item

`endif // MEM_ITEM