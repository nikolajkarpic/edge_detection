#ifndef _VP_HPP_
#define _VP_HPP_

#include "common.hpp"
#include "cpu.hpp"
#include "vp_address.hpp"
#include "convolution.hpp"
#include "memory.hpp"


class vp:

    sc_core::sc_module
{
public:
    vp(sc_core::sc_module_name);
protected:
    cpu pb;
    conv ip;
    memory bram;
         
};

#endif //_VP_HPP_