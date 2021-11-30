#ifndef _VP_ADDRESS_H_
#define _VP_ADDRESS_H_

#include "common.hpp"
#include "memory.hpp"
#include "convolution.hpp"

const sc_dt::uint64 CONV_IMG = 0x00000000; //local addresses for convolution
const sc_dt::uint64 CONV_KERNEL = 0x00000001;
const sc_dt::uint64 CONV_READY = 0x00000002;

const sc_dt::uint64 VP_ADDR_CPU = 0x43C00000;                                       //cpu addr
const sc_dt::uint64 VP_ADDR_CONVOLUTION = 0x43D00000;                               //conv addr
const sc_dt::uint64 VP_ADDR_CONVOLUTION_IMAGE = VP_ADDR_CONVOLUTION + CONV_IMG;     //address for img
const sc_dt::uint64 VP_ADDR_CONVOLUTION_KERNEL = VP_ADDR_CONVOLUTION + CONV_KERNEL; //address for kernel
const sc_dt::uint64 VP_ADDR_CONVOLUTION_READY = VP_ADDR_CONVOLUTION + CONV_READY;
//Memory addresses:

const sc_dt::uint64 MEMORY_IMG = 0x00000000;
const sc_dt::uint64 MEMORY_KERNEL = 0x00000001;

const sc_dt::uint64 VP_ADDR_MEMORY = 0x43E00000;                            //memory addr
const sc_dt::uint64 VP_ADDR_MEMORY_IMAGE = VP_ADDR_MEMORY + MEMORY_IMG;     //address for img in memory
const sc_dt::uint64 VP_ADDR_MEMORY_KERNEL = VP_ADDR_MEMORY + MEMORY_KERNEL; //address for kernel in memory

#endif //_VP_ADDRESS_H_
