#ifndef COMMON_H_INCLUDED
#define COMMON_H_INCLUDED

#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp> 
#include <opencv2/imgproc.hpp> 
#include <iostream> 
#include <vector>

#define KERNEL_SIZE 9

//struct that holds red green blue values of a pixel.
//opencv uses blue green red convetion (BGR)
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

#endif // COMMON_H_INCLUDED