`ifndef PB_ITEM
`define PB_ITEM

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
    `uvm_component_utils_begin(pb_item)
        //field registration
        `uvm_field_enum(pb_packet_type, p_type, UVM_ALL_ON)
        `uvm_field_queue_int(pixel_0_in, UVM_ALL_ON)
        `uvm_field_queue_int(pixel_1_in, UVM_ALL_ON)
        `uvm_field_queue_int(pixel_2_in, UVM_ALL_ON)
        `uvm_field_queue_int(kernel_0_in, UVM_ALL_ON)
        `uvm_field_queue_int(kernel_1_in, UVM_ALL_ON)
        `uvm_field_queue_int(kernel_2_in, UVM_ALL_ON)
        `uvm_field_int(en_in)
        `uvm_field_int(reset_sum_in)
        `uvm_field_int(bram_write_enable_out)

    `uvm_component_utils_end

endclass : pb_item

`endif // PB_ITEM