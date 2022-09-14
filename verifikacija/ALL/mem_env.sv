`ifndef MEM_ENV
`define MEM_ENV

class mem_env extends uvm_env;

    `uvm_component_utils(mem_env)

    mem_uvc_cfg m_cfg;
    mem_agent m_agent;

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);

endclass : mem_env

function mem_env::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void mem_env::build_phase(uvm_phase phase);

    super.build_phase(phase);
    if(!uvm_config_db #(mem_uvc_cfg)::get(this, "", "m_cfg", m_cfg)) begin
        `uvm_fatal(get_type_name(), "Failed to get cfg from conig db")
    end

    m_agent = mem_agent::type_id::create("m_agent", this);
    //uvm_config_db#(mem_agent_cfg)::set(this, "m_agent", "m_cfg", m_cfg.m_agent_cfg);

endfunction : build_phase

`endif // ENV