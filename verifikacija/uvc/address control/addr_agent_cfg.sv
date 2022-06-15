`ifndef ADDR_AGENTCFG
`define ADDR_AGENTCFG

class addr_agent_cfg extends uvm_object;

    bit is_master;
    bit m_has_coverage;
    bit m_has_checks;
    uvm_active_pasive_enum m_is_active = UVM_ACTIVE;

    `uvm_component_utils_begin(addr_agent_cfg)
        `uvm_field_enum(uvm_active_pasive_enum, m_is_active, UVM_ALL_ON)
        `uvm_field_int(is_master, UVM_ALL_ON)
        `uvm_field_int(m_has_checks, UVM_ALL_ON)
        `uvm_field_int(m_has_coverage, UVM_ALL_ON)
    `uvm_component_utils_end

    function new(string name = "addr_agent_cfg")
        super.new(name);
    endfunction : new

endclass : addr_agent_cfg

`endif // ADDR_AGENTCFG