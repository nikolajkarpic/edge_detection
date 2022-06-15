`ifndef PB_UVC_PKG
`define PB_UVC_PKG

class pb_uvc_cfg extends uvm_object;

    // constructor
    extern function new(string name = "pb_uvc_cfg");
endclass : pb_uvc_cfg

function pb_agent_cfg::new(string name = "pb_uvc_cfg");
    super.new(name);
endfunction : new

`endif // PB_UVC_PKG