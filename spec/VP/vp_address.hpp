#ifndef _VP_ADDRESS_H_
#define _VP_ADDRESS_H_

#include "common.hpp"

const sc_dt::uint64 VP_ADDR_CPU = 0x43C00000;
const sc_dt::uint64 VP_ADDR_CONVOLUTION = 0x43D00000;
const sc_dt::uint64 CONV_KERNEL = 0x43D00001; // debugging purposes please ignore, put where its actually neeeded
const sc_dt::uint64 CONV_IMG = 0x43D00002; // look above^
const sc_dt::uint64 VP_ADDR_MEMORY = 0x43E00000;
//const sc_dt::uint64 VP_ADDR_CPU = 0x43F00000; //does interconnect need one?


#endif //_VP_ADDRESS_H_