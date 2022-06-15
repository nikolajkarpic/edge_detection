`ifndef SEQUENCER
`define SEQUENCER

class sequencer extends uvm_sequenceer #(item);

    `uvm_component_utils(sequencer)

    // config refernce
    agent_cfg m_cfg;

    extern function new(string name, uvm_component parent);

    extern virtual function void build_phase(uvm_phase phase);

endclass : sequencer

function sequencer::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void sequencer::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction : build_phase

`endif // SEQUENCER