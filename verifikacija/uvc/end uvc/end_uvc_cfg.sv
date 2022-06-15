`ifndef END_UVC_PKG
`define END_UVC_PKG

class end_uvc_cfg extends uvm_object;

    // constructor
    extern function new(string name = "end_uvc_cfg");
endclass : end_uvc_cfg

function end_agent_cfg::new(string name = "end_uvc_cfg");
    super.new(name);
endfunction : new

`endif // END_UVC_PKG