`ifndef PB_ENV
`define PB_ENV

class pb_env extends uvm_env;

    `uvm_component_utils(pb_env)

    pb_uvc_cfg m_cfg;
    pb_agent m_agent;

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);

endclass : pb_env

function pb_env::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void pb_env::build_phase(uvm_phase phase);

    super.build_phase(phase);
    if(!uvm_config_db #(pb_uvc_cfg)::get(this, "", "m_cfg", m_cfg)) begin
        `uvm_fatal(get_type_name(), "Failed to get cfg from conig db")
    end

    m_agent = pb_agent::type_id::create("m_agent", this);
    //uvm_config_db#(pb_agent_cfg)::set(this, "m_agent", "m_cfg", m_cfg.m_agent_cfg);

endfunction : build_phase

`endif // PB_ENV