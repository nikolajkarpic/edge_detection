`ifndef END_SEQUENCER
`define END_SEQUENCER

class end_sequencer extends uvm_sequencer #(end_item);

    // registration macro
    `uvm_component_utils(end_sequencer)
    // configuration reference
    end_agent_cfg m_cfg;
    // constructor
    extern function new (string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);

endclass : end_sequencer

// constructor
function end_sequencer::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void end_sequencer::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction : build_phase

`endif // END_SEQUENCER