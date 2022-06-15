`ifndef END_AGENT
`define END_AGENT

class end_agent extends uvm_agent;

    `uvm_component_utils(end_agent)

    `uvm_analysis_port#(end_item) m_aport;

    end_agent_cfg m_config;

    // driver instance
    // sequencer instance
    end_monitor m_monitor;
    // coverage instance

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass : end_agent

function void end_agent::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void end_agent::connect_phase(phase);
   
    m_monitor.m_aport.connect(m_aport);
    /*if(m_cfg,m_has_coverage == 1) begin
        m_cov.m_cfg = m_cfg;
    end*/
endfunction : connect_phase

function void end_agent::build_phase(phase);
    super.build_phase(phase);
    // create port
    m_aport = new("m_aport", this);
    // get configuration
    if(!uvm_config_db #(end_agent_cfg)::get(this, "","m_cfg", m_cfg)) begin
        `uvm_fatal(get_type_name(), "Failed to get cofiguration object form cofig DB!")
    end

    m_monitor = end_monitor::type_id::create("m_monitor", this);

endfunction : build_phase

`endif // END_AGENT