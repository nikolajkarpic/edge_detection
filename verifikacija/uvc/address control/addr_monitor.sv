`ifndef ADDR_MONITOR
`define ADDR_MONITOR

class addr_monitor extends uvm_monitor;

`uvm_component_utils(addr_monitor)

uvm_analysis_port #(addr_item) m_aport;

virtual interface addr_interface m_vif;

addr_item m_item;
addr_item m_item_cloned;

//constructor
exter function new (string name, uvm_component parent);

extern virtual function void build_phase(uvm_phase phase);
extern virtual task handle_reset();
extern virtual task collect_item();
extern virtual task run_phase(uvm_phase phase);
extern virtual function void print_item (item it);

endclass : addr_monitor

function addr_monitor::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void addr_monitor::build_phase(uvm_phase phase);

    super.build_phase(phase);
    // get interface form config db
    if(!uvm_config_db#(virtual addr_interface)::get(this,"","m_vif",m_vif)) begin
        `uvm_fatal(get_type_name(), "Failed to get virtual interface from config DB")
    end
    // create port
    m_aport = new("m_aport",this);

endfunction : build_phase

task addr_monitor::run_phase(uvm_phase phase);

    forever begin
        fork
            begin
                handle_reset();
            end
            begin
                collect_item();
            end
        join_any
        disable fork;
    end

endtask : run_phase

task addr_monitor::handle_reset();
    // wait reset asertion
    @(posedge m_vif.RST);
    `uvm_info(get_type_name(), "Reset asserted.", UVM_HIGH)

endtask : handle_reset

task addr_monitor::collect_item();

    // wait reset de aserted
    wait(m_vif.RST == 0);
    `uvm_info(get_type_name(), "Reset deasserted. starting to collect items")
    @(posedge m_vif.CLK);
    fork
        forever begin
            m_item = addr_item::type_id::create("m_item", this);
            // logic for receivimg items
            @(posedge m_vif.CLK iff m_vif.calc_conv_addr_i);

            m_item.i_i <= m_vif.i_i;
            m_item.i_i <= m_vif.j_i;
            m_item.p_type = CALC_CONV;

            $cast(m_item_cloned, m_item.clone());
            print_item(m_item);
            m_aport.write(m_item_cloned);
        end // forever begin
        forever begin
            m_item = addr_item::type_id::create("m_item", this);
            // logic for receivimg items
            @(posedge m_vif.CLK iff m_vif.calc_addr_i);

            m_item.i_i <= m_vif.i_i;
            m_item.j_i <= m_vif.j_i;
            m_item.k_i <= m_vif.k_i;
            m_item.l_i <= m_vif.l_i;
            m_item.p_type = CALC_ADDR;
            
            $cast(m_item_cloned, m_item.clone());
            print_item(m_item);
            m_aport.write(m_item_cloned);
        end // forever begin
        forever begin
            m_item = addr_item::type_id::create("m_item", this);
            // logic for receivimg items
            @(posedge m_vif.CLK iff m_vif.shift_en_i);
            m_item.p_type = SHIFT;
            
            $cast(m_item_cloned, m_item.clone());
            print_item(m_item);
            m_aport.write(m_item_cloned);
        end // forever begin
    join
endtask : collect_item

finction void addr_monitor::print_item(addr_item it);
    `uvm_info(get_type_name(), $sformatf("Item collected: \n%s", it.sprint()), UVM_HIGH)
endfunction : print_item

`endif // ADDR_MONITORR