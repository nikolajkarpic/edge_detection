`ifndef PB_AGENTCFG
`define PB_AGENTCFG

class pb_agent_cfg extends uvm_object;

    bit is_master;
    bit m_has_coverage;
    bit m_has_checks;
    uvm_active_pasive_enum m_is_active = UVM_ACTIVE;

    `uvm_component_utils_begin(agent_cfg)
        `uvm_field_enum(uvm_active_pasive_enum, m_is_active, UVM_ALL_ON)
        `uvm_field_int(is_master, UVM_ALL_ON)
        `uvm_field_int(m_has_checks, UVM_ALL_ON)
        `uvm_field_int(m_has_coverage, UVM_ALL_ON)
    `uvm_component_utils_end

    function new(string name = "agent_cfg")
        super.new(name);
    endfunction : new

endclass : pb_agent_cfg

`endif // PB_AGENTCFG