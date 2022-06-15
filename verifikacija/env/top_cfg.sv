`ifndef TOP_CFG
`define TOP_CFG

class top_cfg extends uvm_object;

// config for uvc-s
end_cfg  m_end_cfg;
mem_cfg  m_end_cfg;
pb_cfg   m_pb_cfg;
addr_cfg m_addr_cfg;
// registration macros
`uvm_component_utils_begin(top_cfg)

    `uvm_field_object(m_end_cfg,UVM_ALL_ON)
    `uvm_field_object(m_mem_cfg,UVM_ALL_ON)
    `uvm_field_object(m_pb_cfg,UVM_ALL_ON)
    `uvm_field_object(m_addr_cfg,UVM_ALL_ON)

`uvm_component_utils_end

endclass : top_cfg

`endif // TOP_CFG