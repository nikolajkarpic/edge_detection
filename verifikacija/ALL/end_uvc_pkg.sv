`ifndef END_UVC_PKG
`define END_UVC_PKG

`include "end_interface.sv"

package end_uvc_pkg;

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "end_common.sv"
`include "end_agent_cfg.sv"
`include "end_uvc_cfg.sv"
`include "end_item.sv"
`include "end_sequence.sv"
`include "end_monitor.sv"
`include "end_slave_driver.sv"
`include "end_sequencer.sv"
//`include "cov.sv"
`include "end_agent.sv"
`include "end_env.sv"

endpackage : end_uvc_pkg

`endif // UVC_pkg