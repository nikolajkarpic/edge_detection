#ifndef IMAGEPROCCESING_H_INCLUDED
#define IMAGEPROCCESING_H_INCLUDED
#include"common.h"
#include"kernelGeneration.h"

#define RED_VALUE 0.2989
#define GREEN_VALUE 0.5870
#define BLUE_VALUE 0.1140

image2D grayScale(image2D source);
SCimage2D SCgrayScale(SCimage2D source, int BIT_WIDTH_PASS);

image2D convolution2D(kernel2D kernel, image2D source);
SCimage2D SCconvolution2D(SCkernel2D kernel, SCimage2D source, int BIT_WIDTH_PASS);

image2D zeroCrossingTest(image2D source);
SCimage2D SCzeroCrossingTest(SCimage2D source);



#endif //IMAGEPROCCESING_H_INCLUDED
