#ifndef IMAGEPROCCESING_H_INCLUDED
#define IMAGEPROCCESING_H_INCLUDED
#include"common.h"
#include"kernelGeneration.h"

#define RED_VALUE 0.2989
#define GREEN_VALUE 0.5870
#define BLUE_VALUE 0.1140

image2D grayScale(image2D source);

image2D convolution2D(kernel2D kernel, image2D source);

image2D zeroCrossingTest(image2D source);


#endif IMAGEPROCCESING_H_INCLUDED
