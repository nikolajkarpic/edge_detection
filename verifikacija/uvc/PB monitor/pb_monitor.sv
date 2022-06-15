`ifndef PB_MONITOR
`define PB_MONITOR

class pb_monitor extends uvm_monitor;

`uvm_component_utils(pb_monitor)

uvm_analysis_port #(pb_item) m_aport;

virtual interface pb_interface m_vif;

pb_item m_item;
pb_item m_item_cloned;

//constructor
exter function new (string name, uvm_component parent);

extern virtual function void build_phase(uvm_phase phase);
extern virtual task handle_reset();
extern virtual task collect_item();
extern virtual task run_phase(uvm_phase phase);
extern virtual function void print_item (item it);

endclass : pb_monitor

function pb_monitor::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void pb_monitor::build_phase(uvm_phase phase);

    super.build_phase(phase);
    // get interface form config db
    if(!uvm_config_db#(virtual pb_interface)::get(this,"","m_vif",m_vif)) begin
        `uvm_fatal(get_type_name(), "Failed to get virtual interface from config DB")
    end
    // create port
    m_aport = new("m_aport",this);

endfunction : build_phase

task pb_monitor::run_phase(uvm_phase phase);

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

task pb_monitor::handle_reset();
    // wait reset asertion
    @(posedge m_vif.RST);
    `uvm_info(get_type_name(), "Reset asserted.", UVM_HIGH)

endtask : handle_reset

task pb_monitor::collect_item();

    // wait reset de aserted
    wait(m_vif.RST == 0);
    `uvm_info(get_type_name(), "Reset deasserted. starting to collect items...", UVM_HIGH)
    @(posedge m_vif.CLK);
    fork
        forever begin
            m_item = pb_item::type_id::create("m_item", this);
            // logic for receivimg items
            repeat(27) begin // needs 81 (27*3) pixels and kernel to calculate
                @(posedge m_vif.CLK iff m_vif.en_in == 1)
                m_item.pixel_0_in.push_back(m_vif.pixel_0_in);
                m_item.pixel_1_in.push_back(m_vif.pixel_1_in);
                m_item.pixel_2_in.push_back(m_vif.pixel_2_in);
                m_item.kernel_0_in.push_back(m_vif.kernel_0_in);
                m_item.kernel_1_in.push_back(m_vif.kernel_1_in);
                m_item.kernel_2_in.push_back(m_vif.kernel_2_in);
            end
            // packet type set
            m_item.p_type = DAT;
            // send a copy of the item
            $cast(m_item_cloned, m_item.clone());
            print_item(m_item);
            m_aport.write(m_item_cloned);
        end // forever begin
        forever begin
            @(posedge m_vif.CLK iff m_vif.en_in == 1)
            // packet type set
            m_item.p_type = EN;
            // send a copy of the item
            $cast(m_item_cloned, m_item.clone());
            print_item(m_item);
            m_aport.write(m_item_cloned);
        end
        forever begin
            @(posedge m_vif.CLK iff m_vif.sum_out_en == 1)
            // packet type set
            m_item.p_type = SUM_OUT;
            // send a copy of the item
            $cast(m_item_cloned, m_item.clone());
            print_item(m_item);
            m_aport.write(m_item_cloned);
        end
    join
endtask : collect_item

finction void pb_monitor::print_item(item it);
    `uvm_info(get_type_name(), $sformatf("Item collected: \n%s", it.sprint()), UVM_HIGH)
endfunction : print_item

`endif // PB_MONITORR