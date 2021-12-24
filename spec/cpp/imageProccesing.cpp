#include "imageProccesing.h"

using namespace cv;
using namespace std;


image2D convolution2D(kernel2D kernel, image2D source)
{
	int imageWidth = source[0].size();
	int imageHeight = source.size();

	int kernelWidth = kernel[0].size();
	int kernelHeight = kernel.size();

	pixel tempPixel;
	image1D tempPixelArray;
	image2D imageResult;
	long double sum = 0.0;

	for (int i = 0; i < imageHeight - kernelHeight + 1; i++) {
		imageResult.push_back(tempPixelArray);
		for (int j = 0; j < imageWidth - kernelWidth +1; j++) {
			sum = 0.0;
			for (int k = 0; k < kernelHeight; k++) {
				for (int l = 0; l < kernelWidth; l++) {
					sum = sum + (kernel[k][l] * source[i + k][j + l].red);
					//cout << "i: " << i << " j: " << j << " k: "<< k << " l: "<< l <<" sum: " << sum << endl;
				}
				//cout << sum << endl;
			}
			//tempPixel.blue = (int)sum;
			//tempPixel.red = (int)sum;
			//tempPixel.green = (int)sum;
			tempPixel.convResult = sum;
			imageResult[i].push_back(tempPixel);
		}
	}
	return imageResult;
}


image2D grayScale(image2D source)
{
	int width = source[0].size(); //gets widht of an image for loops
	int height = source.size();		//gets height of an image for loops
	
	
	// temporary values 
	long double grayValue;
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

image2D zeroCrossingTest(image2D source)
{
	image2D imageResult;
	image1D tempPixelArray;
	pixel tempPixel;
	int sourceWidth = source[0].size();
	int sourceHeight = source.size();

	matrix1D tempRow;
	matrix2D tempMatrix;
	
	int negCouter = 0;
	int posCoutner = 0;

	for (int i = 1; i < sourceHeight - 1; i++) {
		imageResult.push_back(tempPixelArray);
		for (int j = 1; j < sourceWidth - 1; j++) {
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


image2D loopUnrolledConv(kernel2D kernel, image2D source){

	int imageWidth = source[0].size();
	int imageHeight = source.size();

	int kernelSize = kernel[0].size();
	//int kernelHeight = kernel[0].size();
	pixel tempPixel;

	cout << imageHeight << endl << imageWidth << endl;

	image1D temp1D(imageWidth  - kernelSize +1 , tempPixel);
	image2D result(imageHeight - kernelSize + 1, temp1D);


	int i = 0;
	int j = 0;
	int k = 0;
	int l = 0;
	int convOut = 0;
	double sum = 0;
	//cout << kernelSize - 1<< endl;
	i = 0;
	l1 :j = 0;
		
		//cout << "usao u l1" << endl;    
	l2 :    k = 0;
	        sum = 0.0;
			//cout << "usao u l2" << endl;
	l3 :        l = 0;
				//cout << "usao u l3" << endl;
	l4 :            sum = sum + (kernel[k][l] * source[i + k][j + l].red) + (kernel[k][l + 1] * source[i + k][j + l + 1].red) + (kernel[k][l + 2] * source[i + k][j + l + 2].red);
	                //sum = sum + (kernel[k][l + 1] * source[i + k][j + l + 1].red);
	                //sum = sum + (kernel[k][l + 2] * source[i + k][j + l + 2].red);
					//cout << sum << endl;
					//cout << "i: " << i << " j: " << j << " k: "<< k << " l: "<< l <<" sum: " << sum << endl;
	                //cout << l << endl;
	                if (l == kernelSize - 3)
	                {
						//cout << "Usao u prfi if" << endl;
	                    if(k == kernelSize - 1){
							//cout << "usao u drugi if"<< endl;
							//cout << sum << endl;
	                        goto l5;
	                    }else {
	                    	k = k + 1;
							//cout << "k:" << k << endl;
	                    	goto l3;
						}
	                }
	                else
	                {
						l = l + 3;
	                    goto l4;
	                }
					
	l5 ://cout << "usao u l5" << endl;
	 	if (sum < 0){
	       convOut = -1; 
	    }else if(sum > 0){
	        convOut = 1;
	    }else{
	        convOut = 0;
	    }
		//cout << convOut << endl;
		//cout << "i: " << i << " j: " << j << " sum: " << sum << endl;
	    result[i][j].convResult = convOut;
	    
	    if (j == imageWidth - kernelSize ){
	        if(i == imageHeight - kernelSize){
	            goto stop;
	        }else{
				//cout << "i:" << i << endl;
	        	i = i + 1;
	        	goto l1;
			}
	    } else{
			//cout << "j:" << j << endl;
			j = j + 1;
	        goto l2;
	    }

	stop : cout << "dosao do kraja" << endl;
			return result;

}