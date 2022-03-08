#include "imageProccesing.h"

using namespace cv;
using namespace std;


image2D convolution2D(kernel2D kernel, image2D source)
{
	int imageWIDTH = source[0].size();
	int imageHeight = source.size();

	int kernelWIDTH = kernel[0].size();
	int kernelHeight = kernel.size();

	pixel tempPixel;
	image1D tempPixelArray;
	image2D imageResult;
	long double sum = 0.0;

	for (int i = 0; i < imageHeight - kernelHeight + 1; i++) {
		imageResult.push_back(tempPixelArray);
		for (int j = 0; j < imageWIDTH - kernelWIDTH +1; j++) {
			sum = 0.0;
			for (int k = 0; k < kernelHeight; k++) {
				for (int l = 0; l < kernelWIDTH; l++) {
					sum = sum + (kernel[k][l] * source[i + k][j + l].red);
					
				}
			}
			
			if (sum < 0) {
				sum = -1;
			}
			else if(sum > 0) {
				sum = 1;
			}
			else {
				sum = 0;
			}
			
			tempPixel.convResult = sum;
			imageResult[i].push_back(tempPixel);
		}
	}
	return imageResult;
}


image2D grayScale(image2D source)
{
	int WIDTH = source[0].size(); //gets widht of an image for loops
	int height = source.size();		//gets height of an image for loops
	
	
	// temporary values 
	long double grayValue;
	image2D tempImage;
	image1D tempPixelArray;
	pixel tempPixel;

	//lopps through the image 
	for (int i = 0; i < height; i++) {
		tempImage.push_back(tempPixelArray); 
		for (int j = 0; j < WIDTH; j++) {
			grayValue = source[i][j].blue * BLUE_VALUE + source[i][j].red * RED_VALUE + source[i][j].green * GREEN_VALUE; //gets grayscale value of pixels
			tempPixel.blue = (int)grayValue; //assigns each chanel to grayscale value and typecasts float to integer
			tempPixel.red = (int)grayValue;
			tempPixel.green = (int)grayValue;

			tempImage[i].push_back(tempPixel);//iserts pixel with grayscale values at the end of the vector
		}
	}

	return tempImage; //returns the grayscale image
}

image2D zeroCrossingTest(image2D source)
{
	image2D imageResult;
	image1D tempPixelArray;
	pixel tempPixel;
	int sourceWIDTH = source[0].size();
	int sourceHeight = source.size();

	matrix1D tempRow;
	matrix2D tempMatrix;
	
	int negCouter = 0;
	int posCoutner = 0;

	for (int i = 1; i < sourceHeight - 1; i++) {
		imageResult.push_back(tempPixelArray);
		for (int j = 1; j < sourceWIDTH - 1; j++) {
			negCouter = 0;
			posCoutner = 0;
			for (int k = -1; k < 2; k++) {
				for (int l = -1; l < 2; l++) {
					if (k != 0 && l != 0) {
						if (source[i + k][j + l].convResult < 0) {
							negCouter++;
						}else if(source[i + k][j + l].convResult > 0) {
							posCoutner++;
						}
					}
				}
			}
			tempPixel.red = 255;
			tempPixel.green = 255;
			tempPixel.blue = 255;
			if (negCouter > 0 && posCoutner > 0) {
				tempPixel.red = 0;
				tempPixel.blue = 0;
				tempPixel.green = 0;
			}
			imageResult[i-1].push_back(tempPixel);
		}
	}

	return imageResult;
}


