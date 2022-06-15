`ifndef AGENT
`define AGENT

class agent extends uvm_agent;

    `uvm_component_utils(agent)

    `uvm_analysis_port#(/*item_type*/) m_aport;

    /*config type*/ m_config;

    // driver instance
    // sequencer instance
    monitor m_monitor;
    // coverage instance

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass : agent

function void agent::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void agent::connect_phase(phase);
   /*  if(m_cfg.m_is_active == UVM_ACTIVE) begin
        m_driver.seq_item_por.connect(m_sequencer.seq_item_export);
    end
    m_monitor.m_aport.connect(m_aport);
    if(m_cfg,m_has_coverage == 1) begin
        m_cov.m_cfg = m_cfg;
    end
    if(m_cfg.m_is_active == UVM_ACTIVE) begin
        m_sequencer.m_cfg = m_cfg;
    end */
endfunction : connect_phase

`endif // AGENT