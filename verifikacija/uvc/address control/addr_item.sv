`ifndef ADDR_ITEM
`define ADDR_ITEM

class addr_item extends uvm_sequence_item;

    //fields
    bit [6:0] i_i;
    bit [6:0] j_i;
    bit [3:0] k_i;
    bit [3:0] l_i;
    bit [13:0] bram_shifted_out;
    bit [13:0] conv_addr_out;
    bit [7:0] kernel_0_addr_o;
    bit [7:0] kernel_1_addr_o;
    bit [7:0] kernel_2_addr_o;
    addr_packet_type p_type;
    // registration macros
    `uvm_component_utils_begin(addr_item)
        //field registration
        `uvm_field_enum(addr_packet_type, p_type, UVM_ALL_ON)
        `uvm_field_int(kernel_0_addr_o, UVM_ALL_ON)
        `uvm_field_int(kernel_1_addr_o, UVM_ALL_ON)
        `uvm_field_int(kernel_2_addr_o, UVM_ALL_ON)
        `uvm_field_int(i_i, UVM_ALL_ON)
        `uvm_field_int(j_i, UVM_ALL_ON)
        `uvm_field_int(k_i, UVM_ALL_ON)
        `uvm_field_int(l_i, UVM_ALL_ON)
        `uvm_field_int(bram_shifted_out, UVM_ALL_ON)
        `uvm_field_int(conv_addr_out, UVM_ALL_ON)
    `uvm_component_utils_end

endclass : addr_item

`endif // addr_item