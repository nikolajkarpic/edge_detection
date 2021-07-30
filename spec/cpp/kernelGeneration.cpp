#include "kernelGeneration.h"

kernel2D createKernelLoG(int size, float sigma)
{
	kernel2D kernelLoG;
	kernel1D tempKernel;
	float kernelValue;

	//loops through the kernel
	for (int i = 0; i < size; i++) {
		kernelLoG.push_back(tempKernel);
		for (int j = 0; j < size; j++) {
			//kernelValue = -(1 / (pow(sigma, 4))) * (pow(i, 2) + pow(j, 2) - 2 * pow(sigma, 2)) * (exp(-1*(pow(i, 2) + pow(j, 2)) / (2 * pow(sigma, 2)))); // formula for LoG kernel generation
			kernelValue = -(1 /( sigma * sigma * sigma * sigma*PI_KG)) * (1 - (i * i + j * j) / (2 * sigma * sigma)) * (exp(-(i * i + j * j) / (2 * sigma * sigma)));
			//kernelValue = (int)(-(1 / (PI_KG * pow(sigma, 4)))) * (1 - (pow(j, 2) + pow(i, 2)) / (2 * pow(sigma, 2))) * exp(-(pow(j, 2) + pow(i, 2)) / (2 * pow(sigma, 2)));

			cout <<"[" << i<< "," << j << "]" << kernelValue << endl;
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
			kernelGauss[i].push_back(kernelValue);
			//cout << "[" << i << "," << j << "]" << kernelValue << endl;
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
			returnKernel[i].push_back(kernelValue);
		}
	}
	return returnKernel;
}

float calculateLoGValue(int x, int y, float sigma)
{
	float kernelValue = -(1 / (sigma * sigma * sigma * sigma * PI_KG)) * (1 - (x * x + y * y) / (2 * sigma * sigma)) * (exp(-(x * x + y * y) / (2 * sigma * sigma)));
	kernelValue = roundLoGValue(kernelValue, sigma);

	return kernelValue;
}

float roundLoGValue(float x, float sigma) {

	float val = x * (-40 / -(1 / (sigma * sigma * sigma * sigma * PI_KG)) * (1 - (0 * 0 + 0 * 0) / (2 * sigma * sigma)));

	return val;
}


