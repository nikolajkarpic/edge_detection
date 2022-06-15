`ifndef ADDR_AGENT
`define ADDR_AGENT

class addr_agent extends uvm_agent;

    `uvm_component_utils(addr_agent)

    `uvm_analysis_port#(addr_item) m_aport;

    addr_agent_cfg m_config;

    // driver instance
    // sequencer instance
    addr_monitor m_monitor;
    // coverage instance

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass : addr_agent

function void addr_agent::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void addr_agent::connect_phase(phase);
   
    m_monitor.m_aport.connect(m_aport);
    /*if(m_cfgm_has_coverage == 1) begin
        m_cov.m_cfg = m_cfg;
    end*/
endfunction : connect_phase

function void addr_agent::build_phase(phase);
    super.build_phase(phase);
    // create port
    m_aport = new("m_aport", this);
    // get configuration
    if(!uvm_config_db #(addr_agent_cfg)::get(this, "","m_cfg", m_cfg)) begin
        `uvm_fatal(get_type_name(), "Failed to get cofiguration object form cofig DB!")
    end

    m_monitor = addr_monitor::type_id::create("m_monitor", this);

endfunction : build_phase

`endif // ADDR_AGENT