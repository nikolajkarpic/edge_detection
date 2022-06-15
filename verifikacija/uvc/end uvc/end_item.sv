`ifndef END_ITEM
`define END_ITEM

class end_item extends uvm_sequence_item;

    //fields
    bit [1:0] signed_out;
    // registration macros
    `uvm_component_utils_begin(end_item)
        //field registration
        `uvm_field_int(signed_out, UVM_ALL_ON)
    `uvm_component_utils_end

endclass : end_item

`endif // END_ITEM