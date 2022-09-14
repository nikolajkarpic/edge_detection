`ifndef ADDR_ENV
`define ADDR_ENV

class addr_env extends uvm_env;

    `uvm_component_utils(addr_env)

    addr_uvc_cfg m_cfg;
    addr_agent m_agent;

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);

endclass : addr_env

function addr_env::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void addr_env::build_phase(uvm_phase phase);

    super.build_phase(phase);
    if(!uvm_config_db #(addr_uvc_cfg)::get(this, "", "m_cfg", m_cfg)) begin
        `uvm_fatal(get_type_name(), "Failed to get cfg from conig db")
    end

    m_agent = addr_agent::type_id::create("m_agent", this);
    uvm_config_db#(addr_agent_cfg)::set(this, "m_agent", "m_cfg", m_cfg.m_agent_cfg);

endfunction : build_phase

`endif // ADDR_ENV