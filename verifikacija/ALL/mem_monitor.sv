`ifndef MEM_MONITOR
`define MEM_MONITOR

class mem_monitor extends uvm_monitor;

`uvm_component_utils(mem_monitor)

uvm_analysis_port #(mem_item) m_aport;

virtual interface mem_interface m_vif;

mem_item m_item;
mem_item m_item_cloned;

//constructor
extern function new (string name, uvm_component parent);

extern virtual function void build_phase(uvm_phase phase);
extern virtual task handle_reset();
extern virtual task collect_item();
extern virtual task run_phase(uvm_phase phase);
extern virtual function void print_item (mem_item it);

endclass : mem_monitor

function mem_monitor::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void mem_monitor::build_phase(uvm_phase phase);

    super.build_phase(phase);
    // get interface form config db
    if(!uvm_config_db#(virtual mem_interface)::get(this,"","m_vif",m_vif)) begin
        `uvm_fatal(get_type_name(), "Failed to get virtual interface from config DB")
    end
    // create port
    m_aport = new("m_aport",this);

endfunction : build_phase

task mem_monitor::run_phase(uvm_phase phase);

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

task mem_monitor::handle_reset();
    // wait reset asertion
    @(posedge m_vif.RST);
    `uvm_info(get_type_name(), "Reset asserted.", UVM_HIGH)

endtask : handle_reset

task mem_monitor::collect_item();

    // wait reset de aserted
    wait(m_vif.RST == 0);
    `uvm_info(get_type_name(), "Reset deasserted. starting to collect items", UVM_HIGH)
    @(posedge m_vif.CLK);
    fork
        forever begin
            m_item = mem_item::type_id::create("m_item", this);
            // logic for receivimg items
            @(posedge m_vif.CLK iff m_vif.pixel_shift_en)
            m_item.pixel_data <= m_vif.pixel_data_in;
            // set packet type
            m_item.p_type = SHIFT;
            // send a copy of the item
            $cast(m_item_cloned, m_item.clone());
            print_item(m_item);
            m_aport.write(m_item_cloned);
        end // forever begin
        forever begin
            m_item = mem_item::type_id::create("m_item", this);
            fork
                @(m_vif.pixel_out_0);
                @(m_vif.pixel_out_1);
                @(m_vif.pixel_out_2);
            join_any
            disable fork;
            m_item.pixel_out_0 <= m_vif.pixel_out_0;
            m_item.pixel_out_1 <= m_vif.pixel_out_1;
            m_item.pixel_out_2 <= m_vif.pixel_out_2;
            // set packet type
            m_item.p_type = DAT_OUT;
            // send a copy of the item
            $cast(m_item_cloned, m_item.clone());
            print_item(m_item);
            m_aport.write(m_item_cloned);
        end // forever begin
        forever begin
            m_item = mem_item::type_id::create("m_item", this);
            fork
                @(m_vif.kernel_out_0);
                @(m_vif.kernel_out_1);
                @(m_vif.kernel_out_2);
            join_any
            disable fork;
            m_item.kernel_out_0 <= m_vif.kernel_out_0;
            m_item.kernel_out_1 <= m_vif.kernel_out_1;
            m_item.kernel_out_2 <= m_vif.kernel_out_2;
            // set packet type
            m_item.p_type = KERN_OUT;
            // send a copy of the item
            $cast(m_item_cloned, m_item.clone());
            print_item(m_item);
            m_aport.write(m_item_cloned);
        end // forever begin
    join
endtask : collect_item

function void mem_monitor::print_item(mem_item it);
    `uvm_info(get_type_name(), $sformatf("Item collected: \n%s", it.sprint()), UVM_HIGH)
endfunction : print_item

`endif // MONITORR