#include "vp.hpp"

using namespace sc_core;

vp::vp(sc_module_name name):

    sc_module(name),
    soft ("cpu"),
    hard ("convolution"),
    ic ("interconnect"),
    bram ("memory")
{
    //pb.mem_isoc.bind(bram.cpu_tsoc);
    soft.CPU_ic_mem_isoc.bind(ic.IC_cpu_tsoc);
    soft.CPU_ic_conv_isoc.bind(ic.IC_cpu_conv_tsoc);
    ic.IC_mem_isoc.bind(bram.MEM_ic_tsoc);
    ic.IC_cpu_isoc.bind(soft.CPU_conv_ic_tsoc);
    ic.IC_conv_isoc.bind(hard.CONV_ic_tsoc);
    hard.CONV_ic_isoc.bind(ic.IC_conv_tsoc);
    hard.CONV_mem_isoc.bind(bram.MEM_conv_tsoc);
    
    SC_REPORT_INFO("VP", "Platform is constructed");
}