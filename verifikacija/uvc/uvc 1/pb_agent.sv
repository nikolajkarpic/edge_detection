`ifndef PB_AGENT
`define PB_AGENT

class pb_agent extends uvm_agent;

    `uvm_component_utils(agent)

    `uvm_analysis_port#(pb_item) m_aport;

    pb_agent_cfg m_cfg;

    pb_monitor m_monitor;
    // coverage instance

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass : pb_agent

function void pb_agent::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void pb_agent::connect_phase(phase);
   
    m_monitor.m_aport.connect(m_aport);
    /*if(m_cfgm_has_coverage == 1) begin
        m_cov.m_cfg = m_cfg;
    end*/
endfunction : connect_phase

`endif // PB_AGENT