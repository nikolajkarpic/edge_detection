`ifndef VSEQUENCER
`define VSEQUENCER

class vsequencer extends uvm_sequencer;

    // factory registration macro
    `uvm_component_utils(vsequencer)
    // sequencer reference

    // methods
    // constructor
    extern function new(string name, uvm_component parent);

endclass : vsequencer

function vsequencer::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

`endif // VSEQUENCER