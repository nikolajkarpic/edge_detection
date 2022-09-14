`ifndef END_SLAVE_DRIVER
`define END_SLAVE_DRIVER

class end_slave_driver extends uvm_driver #(end_item);

    // registration macro
    `uvm_component_utils(end_slave_driver)

    //virtual interface
    virtual interface end_interface m_vif;

    // config reference
    end_agent_cfg m_cfg;

    // request item
    REQ m_req;

    // constructor
    extern function new(string name, uvm_component parent);
    // build phase
    extern virtual function void build_phase(uvm_phase phase);
    // run phase
    extern virtual task run_phase(uvm_phase phase);
    // process item
    extern virtual task process_item(end_item item);

    extern virtual task handle_reset();

endclass : end_slave_driver

// constructor

function end_slave_driver::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

// build phase

function void end_slave_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);

    // get interface
    if(!uvm_config_db#(virtual end_interface)::get(this, "", "m_vif", m_vif)) begin
        `uvm_fatal(get_type_name(), "Failed to get virtual interface from config DB!")
    end
    // get configuration
    if(!uvm_config_db#(end_agent_cfg)::get(this, "", "m_cfg", m_cfg)) begin
        `uvm_fatal(get_type_name(), "Failed to get configuration object from config DB!")
    end
endfunction : build_phase

// run phase
task end_slave_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);

    // init signals
    m_vif.bram_pixel_data_in = 0;
    // wait reset
    wait(m_vif.RST == 0);
    m_vif.start <= 1;
    forever begin
        seq_item_port.get_next_item(m_req);
        fork
            begin
                handle_reset();
            end
            begin
                process_item(m_req);
            end
        join_any
        disable fork;
        seq_item_port.item_done();
    end // forever begin

endtask : run_phase

// process item
task end_slave_driver::process_item(end_item item);
    bit [13:0] br;
    //wait reset
    wait(m_vif.RST == 0) // wait until reset id deasserted
    //drive signals
    @(posedge m_vif.CLK iff m_vif.bram_read_data_en_out == 1)
    m_vif.bram_pixel_data_in <= item.data[m_vif.bram_pixel_addr_out];
endtask : process_item

task end_slave_driver::handle_reset();
    // wait reset assertion
    @(posedge m_vif.RST);
    `uvm_info(get_type_name(), "Reset asserted.", UVM_HIGH)
endtask : handle_reset

`endif // END_SLAVE_DRIVER