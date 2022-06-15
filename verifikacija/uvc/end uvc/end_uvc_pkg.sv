`ifndef END_UVC_PKG
`define END_UVC_PKG

`inculde "end_interface.sv"

package end_uvc_pkg;

`include "uvm_macros.svh"
import uvm_pkg::*;

// `include "common.sv"
`include "end_agent_cfg.sv"
`include "end_item.sv"
`include "end_monitor.sv"
//`include "cov.sv"
`include "end_agent.sv"
`include "end_env.sv"

endpackage : end_uvc_pkg

`endif // UVC_pkg