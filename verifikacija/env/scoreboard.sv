`ifndef SCOREBOARD
`define SCOREBOARD

class scoreboard extends uvm_scoreboard;

// fields

uvm_tlm_analysis_fifo #(end_item) m_afifo_end;
uvm_tlm_analysis_fifo #(mem_item) m_afifo_mem;
uvm_tlm_analysis_fifo #(pb_item) m_afifo_pb;
uvm_tlm_analysis_fifo #(addr_item) m_afifo_addr;
// methods
// constructor
extern virtual function new(string name, uvm_component parent);
// build phase
extern virtual function build_phase(uvm_phase phase);
// run phase
extern virtual task run_phase(uvm_phase phase);
// check phase
extern vidtual void function check_phase(uvm_phase phase);


endclass : scoreboard

`endif // SCOREBOARD

function void scoreboard::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

// build phase
function void scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);

    // analysis FIFOs
    m_afifo_addr = new("m_afifo_addr", this);
    m_afifo_addr = new("m_afifo_mem", this);
    m_afifo_addr = new("m_afifo_end", this);
    m_afifo_addr = new("m_afifo_pb", this);

endfunction : build_phase

// run phase
task scoreboard::run_phase(uvm_phase phase);
    super.run_phase(phase);


endtask : run_phase

//check phase
function void scoreboard::check_phase(uvm_phase phase);
endfunction : check_phase