 `ifndef TEST_IMG
 `define TEST_IMG

class test_img extends test_base;

    // registration macro
    `uvm_component_utils(test_img)
    // fields

    // constraints

    // sequences
    // vseq_img m_vseq_img;

    // constructor
    extern function new(string name, uvm_component parent);
    // run phase
    extern virtual task run_phase(uvm_phase phase);
    // set default configuration
    extern virtual function void set_default_configuration();

endclass : test_img

 // constructor
 function test_img::new(string name, uvm_component parent);
    super.new(name, parent);
 endfunction : new

 //run phase
 task test_img::run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);
    `uvm_info(get_type_name(), $sformatf("TEST STARTED"), UVM_LOW)

    // create, randomize and start sequence
    // m_vseq_img = vseq_img::type_id::create("m_vseq_img");
    // asset(m_vseq_img.randomize());
    // m_vseq_img.start(m_top_env.m_vsequencer);

    phase.drop_objection(this);
    `uvm_info(get_type_name(), $sformatf("TEST ENDED"), UVM_LOW)
 endtask : run_phase

 // set default config
function void test_img::set_default_configuration();
endfunction : set_default_configuration
   
 `endif // TEST_IMG