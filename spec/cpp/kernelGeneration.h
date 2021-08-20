#ifndef KERNELGENERATION_H_INCLUDED
#define KERNELGENERATION_H_INCLUDED



#define PI_KG 3.14
#include"common.h"
#include<cmath>



typedef std::vector< std::vector <float> > kernel2D;
typedef std::vector <float> kernel1D;

kernel2D createKernelLoG(int size, float sigma);

kernel2D createKernelGauss(int size, float sigma);

kernel2D createKernelLoGDescrete(int size, float sigma);

float calculateLoGValue(int x, int y, float sigma);

float roundLoGValue(float x, float sigma);

#endif //KERNELGENERATION_H_INCLUDED