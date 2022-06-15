`ifndef TOP_ENV_PKG
`define TOP_ENV_PKG

package top_env_pkg;

`include "uvm_macros.svh"
import uvm_pkg::*;

// import uvc pkg-s
import addr_uvc_pkg::*;
import end_uvc_pkg::*;
import mem_uvc_pkg::*;
import pb_uvc_pkg::*;
//include env files
`include "top_env.sv"
`include "top_cfg.sv"
`include "scoreboard.sv"
`include "vsequencer.sv"

endpackage : top_env_pkg

`endif // TOP_ENV_PKG