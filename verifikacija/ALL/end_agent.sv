`ifndef END_AGENT
`define END_AGENT

class end_agent extends uvm_agent;

    `uvm_component_utils(end_agent)

    uvm_analysis_port#(end_item) m_aport;

    end_agent_cfg m_cfg;

    // driver instance
    end_slave_driver m_slave_driver;
    // sequencer instance
    end_sequencer m_sequencer;
    // monitor instance
    end_monitor m_monitor;
    // coverage instance

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass : end_agent

function end_agent::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void end_agent::connect_phase(uvm_phase phase);
   
   // connect ports
    if(m_cfg.m_is_active == UVM_ACTIVE) begin
        m_slave_driver.seq_item_port.connect(m_sequencer.seq_item_port);
    end
    m_monitor.m_aport.connect(m_aport);
    // assign config
    if(m_cfg.m_is_active == UVM_ACTIVE) begin
        m_sequencer.m_cfg = m_cfg;
    end

endfunction : connect_phase

function void end_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // create port
    m_aport = new("m_aport", this);
    // get configuration
    if(!uvm_config_db #(end_agent_cfg)::get(this, "","m_cfg", m_cfg)) begin
        `uvm_fatal(get_type_name(), "Failed to get cofiguration object form cofig DB!")
    end
    // create components
    m_monitor = end_monitor::type_id::create("m_monitor", this);

    if(m_cfg.m_is_active == UVM_ACTIVE) begin
        m_slave_driver = end_slave_driver::type_id::create("m_slave_driver", this);
        m_sequencer = m_sequencer::type_id::create("m_sequencer", this);
    end

endfunction : build_phase

`endif // END_AGENT