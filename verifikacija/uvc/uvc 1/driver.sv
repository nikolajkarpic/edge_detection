`ifndef DRIVER
`define DRIVER

class driver extends uvm_driver #(item);

    `uvm_component_utils(driver)

    virtual interface intf;

    agent_cfg m_cfg;

    REQ m_req;
    RSP m_rsp;

    // methods
    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task process_item(item it, output item rsp);
    extern virtual task handle_reset();
    extern virtual function void print_item(item it);

endclass : driver

function driver::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void driver::build_phase(uvm_phase phase);

    super.build_phase(phase);

    // get interface
    if(!uvm_config_db #(intf)::get(this, "", "m_vif", m_vif)) begin
        `uvm_fatal(get_type_name(), "Failed to get virtual interface form config db")
    end
    // get configuration
    if(!uvm_config_db #(agent_cfg)::get(this, "", "m_cfg", m_cfg)) begin
        `uvm_fatal(get_type_name(), "Failed to get configuration form config db")
    end

endfunction : build_phase

task driver::run_phase(uvm_phase phase);

    super.run_phase(phase);

    // init signals

    wait(m_vif.RST == 0)
    forever begin
        seq_item_port.get_next_item(m_req);
        fork
            begin
                handle_reset();
            end
            begin
                process_item(m_req, m_rsp);
            end
        join_any
        disable fork;
        m_rsp.set_id_info(m_req);
        seq_item_port.item_done(m_rsp);
    end
endtask : run_phase

task driver::process_item(item it, output item rsp);

    item resp;
    if(!$cast(resp, it.clone())) `uvm_fatal(get_type_name(), "Failed cast to rsp item")
    // wait for reset to deassert
    wait(m_vif.RST == 0)
    // print item

    @(posedge m_vif.CLK);
    // print_item(it);

    // logic for driving item and setting resp

    rsp = resp;
endtask : process_item

finction void monitor::print_item(item it);
    `uvm_info(get_type_name(), $sformatf("Item collected: \n%s", it.sprint()), UVM_HIGH)
endfunction : print_item

`endif // DRIVER