`ifndef ADDR_UVC_PKG
`define ADDR_UVC_PKG

`inculde "addr_interface.sv"

package addr_uvc_pkg;

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "addr_common.sv"
`include "addr_agent_cfg.sv"
`include "addr_item.sv"
`include "addr_monitor.sv"
//`include "addr_cov.sv"
`include "addr_agent.sv"
`include "addr_env.sv"

endpackage : addr_uvc_pkg

`endif // ADDR_UVC_pkg