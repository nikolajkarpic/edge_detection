#ifndef _VP_ADDRESS_H_
#define _VP_ADDRESS_H_

#include "common.hpp"
#include "memory.hpp"
#include "convolution.hpp"

const sc_dt::uint64 CONV_IMG = 0; //local addresses for convolution
const sc_dt::uint64 CONV_KERNEL = 1;

const sc_dt::uint64 VP_ADDR_CPU = 0x43C00000; //cpu addr
const sc_dt::uint64 VP_ADDR_CONVOLUTION = 0x43D00000; //conv addr 
const sc_dt::uint64 VP_ADDR_CONVOLUTION_IMAGE = VP_ADDR_CONVOLUTION + CONV_IMG; //address for img 
const sc_dt::uint64 VP_ADDR_CONVOLUTION_KERNEL  = VP_ADDR_CONVOLUTION + CONV_KERNEL; //address for kernel

//Memory addresses:

const sc_dt::uint64 MEMORY_IMG = 0;
const sc_dt::uint64 MEMORY_KERNEL = 1;
//const sc_dt::uint64 MEMORY_CONV_RESULT = 2;

const sc_dt::uint64 VP_ADDR_MEMORY = 0x43E00000; //memory addr
const sc_dt::uint64 VP_ADDR_MEMORY_IMAGE = VP_ADDR_MEMORY + MEMORY_IMG; //address for img in memory
const sc_dt::uint64 VP_ADDR_MEMORY_KERNEL = VP_ADDR_MEMORY + MEMORY_KERNEL; //address for kernel in memory 
//const sc_dt::uint64 VP_ADDR_MEMORY_CONV_RESULT = VP_ADDR_MEMORY + MEMORY_CONV_RESULT; //address for conv_result in memory


#endif //_VP_ADDRESS_H_
