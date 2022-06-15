`ifndef TOP_ENV
`define TOP_ENV

class top_env extends uvm_env;

    `uvm_component_utils(top_env)

    // config referance
    top_cfg m_cfg;
    // scoreboard instance
    scoreboard m_scoreboard;
    // virtual sequenceer instance
    vsequencer m_vsequencer;
    // component instance (uvc-s)
    addr_env m_addr_env;
    pb_env m_pb_env;
    mem_env m_mem_env;
    end_env m_end_env;
    // methods
    // constructor
    extern function new(string name, uvm_component parent);
    //build phase
    extern virtual function build_phase(uvm_phase phase);
    // connect phase
    extern virtual function connect_phase(uvm_phase phase);

endclass : top_env

function top_env::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void top_env::build_phase(uvm_phase phase);
    super.build_phase(phase);

    // get config
    if(!uvm_config_db#(top_cfg)::get(this, "","m_cfg", m_cfg)) begin
        `uvm_fatal(get_type_name(),"Failed to get configuration object from config DB!")
    end
    // set config
    uvm_config_db#(end_cfg)::set(this, "end_cfg", "m_cfg", m_cfg.m_end_cfg);
    uvm_config_db#(mem_cfg)::set(this, "mem_cfg", "m_cfg", m_cfg.m_mem_cfg);
    uvm_config_db#(pb_cfg)::set(this, "pb_cfg", "m_cfg", m_cfg.m_pb_cfg);
    uvm_config_db#(addr_cfg)::set(this, "addr_cfg", "m_cfg", m_cfg.m_addr_cfg);
    // create componenmt
    m_end_env = end_env::type_id::create("end_env", this);
    m_mem_env = mem_env::type_id::create("mem_env", this);
    m_pb_env = pb_env::type_id::create("pb_env", this);
    m_addr_env = addr_env::type_id::create("addr_env", this);

    m_vsequencer = vsequencer::type_id::create("m_vsequencer", this);
    m_scoreboard = scoreboard::type_id::create("m_scoreboard", this);

endfunction : build_phase

function void top_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    m_end_env.m_agent.m_aport.connect(m_scoreboard.m_afifo_end.analysis_export);
    m_mem_env.m_agent.m_aport.connect(m_scoreboard.m_afifo_mem.analysis_export);
    m_pb_env.m_agent.m_aport.connect(m_scoreboard.m_afifo_pb.analysis_export);
    m_addr_env.m_agent.m_aport.connect(m_scoreboard.m_afifo_addr.analysis_export);
endfunction : connect_phase

`endif // TOP_ENV