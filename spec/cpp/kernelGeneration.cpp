#include "kernelGeneration.h"

using namespace cv;
using namespace std;

kernel2D createKernelLoGDescrete(int size, long double sigma)
{
	kernel2D returnKernel;
	kernel1D temp;
	long double kernelValue;

	for (int i = 0; i < size; i++) {
		returnKernel.push_back(temp);
		for (int j = 0; j < size; j++) {
			kernelValue = calculateLoGValue((i - (size - 1) / 2), (j - (size - 1) / 2), sigma);
			returnKernel[i].push_back(kernelValue);
		}
	}
	return returnKernel;
}

long double calculateLoGValue(long double x, long double y, long double sigma)
{
	long double kernelValue = -(1 / (sigma * sigma * sigma * sigma * PI_KG)) * (1 - (x * x + y * y) / (2 * sigma * sigma)) * (exp(-(x * x + y * y) / (2 * sigma * sigma)));
	kernelValue = roundLoGValue(kernelValue, sigma);

	return kernelValue;
}

long double roundLoGValue(long double x, long double sigma) {

	long double val = x * (-40 / (-1 / (sigma * sigma * sigma * sigma * PI_KG) * (1 - (0 * 0 + 0 * 0) / (2 * sigma * sigma))));

	return val;
}


