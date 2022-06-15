`ifndef END_ENV
`define END_ENV

class end_env extends uvm_env;

    `uvm_component_utils(end_env)

    uvc_cfg m_cfg;
    end_agent m_agent;

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);

endclass : end_env

function end_env::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void end_env::build_phase(uvm_phase phase);

    super.build_phase(phase);
    if(!uvm_config_db #(uvc_cfg)::get(this, "", "m_cfg", m_cfg)) begin
        `uvm_fatal(get_type_name(), "Failed to get cfg from conig db")
    end

    m_agent = end_agent::type_id::create("m_agent", this);
    uvm_config_db#(end_agent_cfg)::set(this, "m_agent", "m_cfg", m_cfg.m_agent_cfg);

endfunction : build_phase

`endif // END_ENV