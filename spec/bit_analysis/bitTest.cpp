#include "bitTest.h"

//returns the nuber of different pixels
int comparePixels(image2D temp, SCimage2D SCtemp){
	int counter = 0;

	int WIDTH = temp[0].size();
	int Height = temp.size();

	for (int i = 0; i < Height; i++) {
		for (int j = 0; j < WIDTH; j++) {
			if(temp[i][j].blue != SCtemp[i][j].blue)
				counter++;
		}
	}
	return counter;
}

// float kernelDeviation(kernel2D modelKernel, SCkernel2D SCkernel){
// 	float SCaverageDeviation = 0;
//     float averageDeviation = 0;
// 	int WIDTH = modelKernel[0].size();
// 	int Height = modelKernel.size();
// 	int size = modelKernel[0].size() * modelKernel.size();
// 	for (int i = 0; i < Height; i++) {
// 		for (int j = 0; j < WIDTH; j++) {
// 			//cout << SCkernel[i][j] << endl;
// 			averageDeviation = averageDeviation + abs(modelKernel[i][j] - SCkernel[i][j].to_float());
// 			averageDeviation = averageDeviation/2;
			
// 			//cout << diviation << endl;
// 		}
// 	}
//     float deviation;
//     for (int i = 0; i < Height; i++) {
// 		for (int j = 0; j < WIDTH; j++) {
// 			//cout << SCkernel[i][j] << endl;
// 			deviation = abs(averageDeviation - abs(modelKernel[i][j] - SCkernel[i][j].to_float()));
// 			deviation = deviation/2;
			
// 			//cout << diviation << endl;
// 		}
// 	}
// 	return ((int)(deviation*10000))/100.0;
// }

// float convolutionDeviation(image2D modelKernel, SCimage2D SCkernel){
//     float deviation = 0;
// 	int WIDTH = modelKernel[0].size();
// 	int Height = modelKernel.size();
// 	int size = modelKernel[0].size() * modelKernel.size();
// 	for (int i = 0; i < Height; i++) {
// 		for (int j = 0; j < WIDTH; j++) {
// 			deviation = deviation + abs(modelKernel[i][j].blue/SCkernel[i][j].d.to_float());
// 			deviation = deviation/2;
// 		}
// 	}
// 	return deviation*100;

// }