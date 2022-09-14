`ifndef END_MONITOR
`define END_MONITOR

class end_monitor extends uvm_monitor;

`uvm_component_utils(end_monitor)

uvm_analysis_port #(end_item) m_aport;

virtual interface end_interface m_vif;

end_item m_item;
end_item m_item_cloned;

//constructor
extern function new (string name, uvm_component parent);

extern virtual function void build_phase(uvm_phase phase);
extern virtual task handle_reset();
extern virtual task collect_item();
extern virtual task run_phase(uvm_phase phase);
extern virtual function void print_item (end_item it);

endclass : end_monitor

function end_monitor::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void end_monitor::build_phase(uvm_phase phase);

    super.build_phase(phase);
    // get interface form config db
    if(!uvm_config_db#(virtual end_interface)::get(this,"","m_vif",m_vif)) begin
        `uvm_fatal(get_type_name(), "Failed to get virtual interface from config DB")
    end
    // create port
    m_aport = new("m_aport",this);

endfunction : build_phase

task end_monitor::run_phase(uvm_phase phase);

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

task end_monitor::handle_reset();
    // wait reset asertion
    @(posedge m_vif.RST);
    `uvm_info(get_type_name(), "Reset asserted.", UVM_HIGH)

endtask : handle_reset

task end_monitor::collect_item();

    // wait reset de aserted
    wait(m_vif.RST == 0);
    `uvm_info(get_type_name(), "Reset deasserted. starting to collect items", UVM_HIGH)
    fork
        forever begin
            m_item = end_item::type_id::create("m_item", this);
            @(posedge m_vif.CLK iff m_vif.bram_read_data_en_out == 1);
            @(posedge m_vif.CLK);
            
            m_item.bram_pixel_data_in <= m_vif.bram_pixel_data_in;
            m_item.bram_pixel_addr_out <= m_vif.bram_pixel_addr_out;
            m_item.end_trans_type <= IN_DAT;

            $cast(m_item_cloned, m_item.clone());
            print_item(m_item);
            m_aport.write(m_item_cloned);
        end // forever
        forever begin
            m_item = end_item::type_id::create("m_item", this);
            @(posedge m_vif.CLK iff m_vif.bram_conv_res_write_en_out == 1);
            // logic for receivimg items
            
            m_item.t_type <= OUT_DAT;
            m_item.bram_conv_res_adr_out <= m_vif.bram_conv_res_adr_out;
            m_item.bram_conv_res_data_out <= m_vif.bram_conv_res_data_out;
            
            $cast(m_item_cloned, m_item.clone());
            print_item(m_item);
            m_aport.write(m_item_cloned);
        end // forever
        forever begin
            m_item = end_item::type_id::create("m_item", this);
            @(posedge m_vif.CLK iff m_vif.start == 1);
            // logic for receivimg items
            
            m_item.t_type = START;

            $cast(m_item_cloned, m_item.clone());
            print_item(m_item);
            m_aport.write(m_item_cloned);
        end // forever
        forever begin
            m_item = end_item::type_id::create("m_item", this);
            @(posedge m_vif.CLK iff m_vif.done_out == 1);
            // logic for receivimg items
            
            m_item.t_type = DONE;

            $cast(m_item_cloned, m_item.clone());
            print_item(m_item);
            m_aport.write(m_item_cloned);
        end // forever
    join
     

endtask : collect_item

function void end_monitor::print_item(end_item it);
    `uvm_info(get_type_name(), $sformatf("Item collected: \n%s", it.sprint()), UVM_HIGH)
endfunction : print_item

`endif // END_MONITORR