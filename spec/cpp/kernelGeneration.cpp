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
			kernelValue = -(1 / (pow(sigma, 4)) * (pow(i, 2) + pow(j, 2) - 2 * pow(sigma, 2)) * (exp(-(pow(i, 2) + pow(j, 2)) / (2 * pow(sigma, 2))))); // formula for LoG kernel generation
			kernelLoG[i].push_back(kernelValue); //adds kernel value at the end of the row
		}
	}

	return kernelLoG; //returns kernel
}

