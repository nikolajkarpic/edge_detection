`ifndef END_SEQUENCE
`define END_SEQUENCE

class end_sequence extends uvm_sequence #(end_item);

    // registration macro
    `uvm_object_utils(end_sequence)
    // sequencer pointer macro
    `uvm_declare_p_sequencer(end_sequencer)

    // item fields
    bit [7:0]  s_bram_pixel_data_in;
    bit [13:0] s_bram_pixel_addr_out;
    bit        s_bram_read_data_en_out;
    
    bit [1:0]  s_bram_conv_res_data_out;
    bit [13:0] s_bram_conv_res_adr_out;
    bit        s_bram_conv_res_write_en_out;

    bit [7:0]  s_data [10000];
    // constraints
    constraint dat_val {
        foreach (s_data[i])
            s_data[i] == img1[i];
    }
    // constuctor
    extern function new(string name = "end_sequence");
    // body task
    extern virtual task body();

endclass : end_sequence

// constructor
function end_sequence::new(string name = "end_sequence");
    super.new(name);
endfunction : new

// body task
task end_sequence::body();
    REQ req = end_item::type_id::create("req");

    start_item(req);
    if(!req.randomize() with { foreach(s_data[i]) data[i] == s_data[i]; }) begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end
    finish_item(req);
endtask : body

`endif // END_SEQUENCE