#include "vp.hpp"

using namespace sc_core;

vp::vp(sc_module_name name):

    sc_module(name),
    pb ("cpu"),
    ip ("convolution")

{

    SC_REPORT_INFO("VP", "Platform is constructed");
}