#ifndef KERNELGENERATION_H_INCLUDED
#define KERNELGENERATION_H_INCLUDED



#define PI_KG 3.14159265358979323846
#include"common.h"
#include<cmath>





kernel2D createKernelLoG(int size, float sigma);

kernel2D createKernelGauss(int size, float sigma);

kernel2D createKernelLoGDescrete(int size, float sigma);

float calculateLoGValue(int x, int y, float sigma);

float roundLoGValue(float x, float sigma);

SCkernel2D SCcreateKernelLoGDescrete(SC_int_small_type size, SC_float_type sigma, int BIT_WIDTH_PASS);

SC_float_type SCcalculateLoGValue(SC_int_small_type x, SC_int_small_type y, SC_float_type sigma, int BIT_WIDTH_PASS);

SC_float_type SCroundLoGValue(SC_float_type x, SC_float_type sigma, int BIT_WIDTH_PASS);



#endif //KERNELGENERATION_H_INCLUDED
