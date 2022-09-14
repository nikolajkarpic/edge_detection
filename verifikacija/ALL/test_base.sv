`ifndef TEST_BASE
`define TEST_BASE

class test_base extends uvm_test;

    //registration macro
    `uvm_component_utils(test_base)
    //component instance
    top_env m_top_env;
    //config instance
    top_cfg m_cfg;
    //fields

    //constraints

    //constructor
    extern function new(string name, uvm_component parent);
    //build phase
    extern virtual function void build_phase(uvm_phase phase);
    //end of elaboration phase
    extern virtual function void end_of_elaboration_phase(uvm_phase phase);
    //set default configuration
    extern virtual function void set_default_configuration();

endclass : test_base

function test_base::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void test_base::build_phase(uvm_phase phase);

    // create component
    m_top_env = top_env::type_id::create("m_top_env", this);

    // create and set config
    m_cfg = top_cfg::type_id::create("m_cfg", this);
    set_default_configuration();

    // TODO set config for all who need it

    // enable monitor recording
    set_config_int("*", "recording_detail", 1);
    // define verbosity
    uvm_top.set_report_verbosity_level(UVM_HIGH);
endfunction : build_phase

function void test_base::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    // allow additional time before stoping
    uvm_test_done.set_drain_time(this, 10ms);
endfunction : end_of_elaboration_phase

function void test_base::set_default_configuration();
    // define default config
    
    // for address control
    // ...
endfunction : set_default_configuration

    

`endif // TEST_BASE