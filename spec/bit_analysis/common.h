#ifndef COMMON_H_INCLUDED
#define COMMON_H_INCLUDED

#define SC_INCLUDE_FX
#include <systemc>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp> 
#include <opencv2/imgproc.hpp> 
#include <iostream> 
#include <vector>

#define KERNEL_SIZE 9
#define BIT_WIDTH 27
#define BIT_FLOAT_POINT 17



typedef sc_dt :: sc_fix_fast SC_float_type;
typedef sc_dt :: sc_uint <11> SC_int_big_type;
typedef sc_dt :: sc_uint <4> SC_int_small_type;
typedef sc_dt :: sc_uint <8> SC_pixel_value_type;

typedef std::vector < SC_float_type > SCkernel1D;
typedef std::vector < std::vector < SC_float_type> > SCkernel2D;

typedef std::vector< std::vector <float> > kernel2D;
typedef std::vector <float> kernel1D;


//struct that holds red green blue values of a pixel.
//opencv uses blue green red convetion (BGR)
struct SCpixel
{
    SC_pixel_value_type blue;
    SC_pixel_value_type green;
    SC_pixel_value_type red;
    SC_float_type d;
};

struct pixel
{
    int blue;
    int green;
    int red;
};

typedef std::vector < std::vector < pixel > > image2D;// vector of vector of pixels, represents an image
typedef std::vector < pixel > image1D; //vector of pixels, represents an row of pixels
typedef std::vector < int > matrix1D;
typedef std::vector < matrix1D > matrix2D;

typedef std::vector < std::vector < SCpixel> > SCimage2D;
typedef std::vector < SCpixel > SCimage1D; 


#endif // COMMON_H_INCLUDED