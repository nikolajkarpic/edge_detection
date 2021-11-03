#include "vp.hpp"

using namespace sc_core;

vp::vp(sc_module_name name):

    sc_module(name),
    pb ("cpu"),
    ip ("convolution"),
    bram ("memory")
{
    pb.mem_isoc.bind(bram.cpu_tsoc);
    SC_REPORT_INFO("VP", "Platform is constructed");
}