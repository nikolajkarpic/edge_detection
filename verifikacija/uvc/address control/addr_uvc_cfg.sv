`ifndef ADDR_UVC_PKG
`define ADDR_UVC_PKG

class addr_uvc_cfg extends uvm_object;

    // constructor
    extern function new(string name = "addr_uvc_cfg");
endclass : addr_uvc_cfg

function addr_agent_cfg::new(string name = "addr_uvc_cfg");
    super.new(name);
endfunction : new

`endif // ADDR_UVC_PKG