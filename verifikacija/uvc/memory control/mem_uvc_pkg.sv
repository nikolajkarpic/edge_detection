`ifndef MEM_UVC_PKG
`define MEM_UVC_PKG

`inculde "mem_interface.sv"

package mem_uvc_pkg;

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "mem_common.sv"
`include "mem_agent_cfg.sv"
`include "mem_item.sv"
// `include "mem_driver.sv"
// `include "mem_sequencer.sv"
`include "mem_monitor.sv"
//`include "cov.sv"
`include "mem_agent.sv"
`include "mem_env.sv"
// `include "mem_seq_lib.sv"

endpackage : mem_uvc_pkg

`endif // MEM_UVC_pkg