#include "kernelGeneration.h"

using namespace cv;
using namespace std;

kernel2D createKernelLoG(int size, float sigma)
{
	kernel2D kernelLoG;
	kernel1D tempKernel;
	float kernelValue;

	//loops through the kernel
	for (int i = 0; i < size; i++) {
		kernelLoG.push_back(tempKernel);
		for (int j = 0; j < size; j++) {
			 // formula for LoG kernel generation
			kernelValue = -(1 /( sigma * sigma * sigma * sigma*PI_KG)) * (1 - (i * i + j * j) / (2 * sigma * sigma)) * (exp(-(i * i + j * j) / (2 * sigma * sigma)));
			//kernelValue = (int)(kernelValue * 1000) /1000.0;
			kernelLoG[i].push_back(kernelValue); //adds kernel value at the end of the row
		}
	}

	return kernelLoG; //returns kernel
}



kernel2D createKernelGauss(int size, float sigma)
{
	kernel2D kernelGauss;
	kernel1D tempKernel;

	float kernelValue;

	for (int i = 0; i < size; i++) {
		kernelGauss.push_back(tempKernel);
		for (int j = 0; j < size; j++) {
			kernelValue = (1 / (pow((2 * PI_KG * sigma), 0.5))) * exp((-(j * j) / (2 * sigma * sigma)));
			//kernelValue = (int)(kernelValue * 1000) /1000.0;
			kernelGauss[i].push_back(kernelValue);
		}
	}
	
	return kernelGauss;
}

kernel2D createKernelLoGDescrete(int size, float sigma)
{
	kernel2D returnKernel;
	kernel1D temp;
	float kernelValue;

	for (int i = 0; i < size + 1; i++) {
		returnKernel.push_back(temp);
		for (int j = 0; j < size + 1; j++) {
			kernelValue = calculateLoGValue((i - (size - 1) / 2), (j - (size - 1) / 2), sigma);
			//kernelValue = (int)(kernelValue * 1000.0) /1000.0;
			//cout << kernelValue << endl;
			returnKernel[i].push_back(kernelValue);
		}
	}
	return returnKernel;
}

float calculateLoGValue(int x, int y, float sigma)
{
	float kernelValue = -(1 / (sigma * sigma * sigma * sigma * PI_KG)) * (1 - (x * x + y * y) / (2 * sigma * sigma)) * (exp(-(x * x + y * y) / (2 * sigma * sigma)));
	kernelValue = roundLoGValue(kernelValue, sigma);
	//kernelValue = (int)(kernelValue * 1000.0) / 1000.0;

	return kernelValue;
}

float roundLoGValue(float x, float sigma) {

	float val = x * (-40 / -(1 / (sigma * sigma * sigma * sigma * PI_KG)) * (1 - (0 * 0 + 0 * 0) / (2 * sigma * sigma)));
	//cout << "Rounded value: "<< val << endl;
	//val = (int)(val * 1000.0) / 1000.0;
	return val;
}


SCkernel2D SCcreateKernelLoGDescrete(SC_int_small_type size, SC_float_type sigma, int BIT_WIDTH_PASS)
{
	//kernel2D returnKernelTemp;
	SCkernel2D returnKernel;
	//kernel1D tempTemp;
	SCkernel1D temp;
	SC_float_type kernelValue(BIT_WIDTH_PASS,BIT_FLOAT_POINT);

	for (int i = 0; i < size + 1; i++) {
		returnKernel.push_back(temp);
		for (int j = 0; j < size + 1; j++) {
			kernelValue = calculateLoGValue((i - (size - 1) / 2), (j - (size - 1) / 2), sigma);
			//kernelValue = (int)(kernelValue * 1000.0) /1000.0;
			//cout << kernelValue << endl;
			returnKernel[i].push_back(kernelValue);
		}
	}
	return returnKernel;
}

SC_float_type SCcalculateLoGValue(SC_int_small_type x, SC_int_small_type y, SC_float_type sigma, int BIT_WIDTH_PASS)
{
	SC_float_type kernelValue(BIT_WIDTH_PASS,BIT_FLOAT_POINT);
	kernelValue = -(1 / (sigma * sigma * sigma * sigma * PI_KG)) * (1 - (x * x + y * y) / (2 * sigma * sigma)) * (exp(-(x * x + y * y) / (2 * sigma * sigma)));
	kernelValue = roundLoGValue(kernelValue, sigma);
	//kernelValue = (int)(kernelValue * 1000.0) / 1000.0;

	return kernelValue;
}

SC_float_type SCroundLoGValue(SC_float_type x, SC_float_type sigma, int BIT_WIDTH_PASS) {

	SC_float_type val(BIT_WIDTH_PASS, BIT_FLOAT_POINT);
	val = x * (-40 / -(1 / (sigma * sigma * sigma * sigma * PI_KG)) * (1 - (0 * 0 + 0 * 0) / (2 * sigma * sigma)));
	//cout << "Rounded value: "<< val << endl;
	//val = (int)(val * 1000.0) / 1000.0;
	return val;
}

