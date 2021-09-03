#ifndef KERNELGENERATION_H_INCLUDED
#define KERNELGENERATION_H_INCLUDED



#define PI_KG 3.14
#include"common.h"
#include<cmath>



typedef std::vector< std::vector <long double> > kernel2D;
typedef std::vector <long double> kernel1D;

kernel2D createKernelLoG(int size, long double sigma);

kernel2D createKernelGauss(int size, long double sigma);

kernel2D createKernelLoGDescrete(int size, long double sigma);

long double calculateLoGValue(long double x, long double y, long double sigma);

long double roundLoGValue(long double x, long double sigma);

#endif //KERNELGENERATION_H_INCLUDED