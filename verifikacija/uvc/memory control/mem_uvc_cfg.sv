`ifndef MEM_UVC_PKG
`define MEM_UVC_PKG

class mem_uvc_cfg extends uvm_object;

    // constructor
    extern function new(string name = "mem_uvc_cfg");
endclass : mem_uvc_cfg

function mem_agent_cfg::new(string name = "mem_uvc_cfg");
    super.new(name);
endfunction : new

`endif // MEM_UVC_PKG