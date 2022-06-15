`ifndef MEM_AGENT
`define MEM_AGENT

class mem_agent extends uvm_agent;

    `uvm_component_utils(mem_agent)

    `uvm_analysis_port#(mem_item) m_aport;

    mem_agent m_config;

    // driver instance
    // sequencer instance
    mem_monitor m_monitor;
    // coverage instance

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass : mem_agent

function void mem_agent::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void mem_agent::connect_phase(phase);
    
    m_monitor.m_aport.connect(m_aport);
    /*if(m_cfgm_has_coverage == 1) begin
        m_cov.m_cfg = m_cfg;
    end*/
endfunction : connect_phase

function void mem_agent::build_phase(phase);
    super.build_phase(phase);
    // create port
    m_aport = new("m_aport", this);
    // get configuration
    if(!uvm_config_db #(mem_agent_cfg)::get(this, "","m_cfg", m_cfg)) begin
        `uvm_fatal(get_type_name(), "Failed to get cofiguration object form cofig DB!")
    end

    m_monitor = mem_monitor::type_id::create("m_monitor", this);

endfunction : build_phase

`endif // MEM_AGENT