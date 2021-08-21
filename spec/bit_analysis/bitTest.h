#ifndef BITTEST_H_INCLUDED
#define BITTEST_H_INCLUDED

#include "common.h"
#include "kernelGeneration.h"
#include "imageProccesing.h"

int comparePixels(image2D temp, SCimage2D SCtemp);

// float kernelDeviation(kernel2D modelKernel, SCkernel2D SCkernel);

// float convolutionDeviation(image2D modelKernel, SCimage2D SCkernel);

#endif //BITTEST_H_INCLUDED