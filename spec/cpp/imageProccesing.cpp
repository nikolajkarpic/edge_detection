#include "imageProccesing.h"


image2D grayScale(image2D source)
{
	int width = source[0].size(); //gets widht of an image for loops
	int height = source.size();		//gets height of an image for loops
	
	
	// temporary values 
	float grayValue;
	image2D tempImage;
	image1D tempPixelArray;
	pixel tempPixel;

	//lopps through the image 
	for (int i = 0; i < height; i++) {
		tempImage.push_back(tempPixelArray); 
		for (int j = 0; j < width; j++) {
			grayValue = source[i][j].blue * BLUE_VALUE + source[i][j].red * RED_VALUE + source[i][j].green * GREEN_VALUE; //gets grayscale value of pixels
			tempPixel.blue = (int)grayValue; //assigns each chanel to grayscale value and typecasts float to integer
			tempPixel.red = (int)grayValue;
			tempPixel.green = (int)grayValue;

			tempImage[i].push_back(tempPixel);//iserts pixel with grayscale values at the end of the vector
		}
	}

	return tempImage; //returns the grayscale image
}
