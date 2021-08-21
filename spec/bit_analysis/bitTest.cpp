#include "bitTest.h"

//returns the nuber of different pixels
int comparePixels(image2D temp, SCimage2D SCtemp){
	int counter = 0;

	int Width = temp[0].size();
	int Height = temp.size();

	for (int i = 0; i < Height; i++) {
		for (int j = 0; j < Width; j++) {
			if(temp[i][j].blue != SCtemp[i][j].blue)
				counter++;
		}
	}
	return counter;
}

