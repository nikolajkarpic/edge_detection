`ifndef END_UVC_CFG
`define END_UVC_CFG

class end_uvc_cfg extends uvm_object;

    // constructor
    extern function new(string name = "end_uvc_cfg");
endclass : end_uvc_cfg

function end_uvc_cfg::new(string name = "end_uvc_cfg");
    super.new(name);
endfunction : new

`endif // END_UVC_PKG