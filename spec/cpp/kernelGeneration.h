#ifndef KERNELGENERATION_H_INCLUDED
#define KERNELGENERATION_H_INCLUDED

#define PI_KG 3.14
#include"common.h"
#include<cmath>

using namespace cv;
using namespace std;

typedef vector< vector <float> > kernel2D;
typedef vector <float> kernel1D;

kernel2D createKernelLoG(int size, float sigma);

kernel2D createKernelGauss(int size, float sigma);

#endif KERNELGENERATION_H_INCLUDED