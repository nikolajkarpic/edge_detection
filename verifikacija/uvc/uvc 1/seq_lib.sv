`ifndef SEQ_LIB
`define SEQ_LIB

class seq_lib extends uvm_sequence #(item);

    `uvm_object_utils(seq_lib)
    // sequencer pointer macro
    `uvm_declare_p_sequencer(sequencer);
    // item fields

    // constraints

    extern function new(string name = "seq_lib");
    extern task body();

endclass : seq_lib

function seq_lib::new(string name = "seq_lib");
    super.new(name);
endfunction : new

task seq_lib::body();

    REQ req = item::type_id::create("req");
    RSP rsp;

    start_item(req);

    if(!req.randomize() /*with{}*/) begin
        `uvm_fatal(get_type_name(), "Failed to randomize")
    end
    finish_item(req);
    get_response(rsp);

endtask : body

`endif // SEQ_LIB