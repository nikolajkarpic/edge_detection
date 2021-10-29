#ifndef COMMON_H_INCLUDED
#define COMMON_H_INCLUDED

#define SC_INCLUDE_FX
#include <systemc>
#include <iostream> 
#include <vector>
#include <fstream>

#define KERNEL_SIZE 9
#define BIT_WIDTH_CONV_OUT 32 //27 conv out // SC_float_type sum(10, 32)
#define BIT_WIDTH_KERNEL 16 // 17 kernel // SC_float_type kernel_val(7, 16)

typedef sc_dt :: sc_fix_fast SC_float_type;
//typedef sc_dt :: sc_uint <11> SC_int_big_type;
//typedef sc_dt :: sc_uint <4> SC_int_small_type; 
typedef sc_dt :: sc_uint <8> SC_pixel_value_type; // 0 255
typedef sc_dt :: sc_int <2> SC_conv_out_t; // -1 0 1
typedef std::vector < std::vector< SC_pixel_value_type > > SCimg2D 


// types for calculating kernel
typedef std::vector < SC_float_type > SCkernel1D;
typedef std::vector < std::vector < SC_float_type> > SCkernel2D;


#endif // COMMON_H_INCLUDED
