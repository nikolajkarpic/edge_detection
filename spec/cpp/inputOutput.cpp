#include"inputOutput.h"
#include <string>

using namespace cv;
using namespace std;


image2D loadImage(string path){
	Mat img = imread(path);
    Mat paddedImage;

    copyMakeBorder(img, paddedImage, 5, 5, 5, 5, BORDER_REPLICATE, (0, 0, 0)); //added zero padding to the bottom and left edge

    int width = paddedImage.cols; //gets width of an image
    int height = paddedImage.rows;  //gets height of an image
    
    
    pixel temp; //temp var
    image1D pixelArrayTemp; //temp value to initialize image2D k
    image2D image;

    for (int i = 0; i < height; i++) { //loops through the image
        image.push_back(pixelArrayTemp);
        for (int j = 0; j < width; j++) {
            temp.blue = (int)paddedImage.at<Vec3b>(i, j).val[0]; // this copys value of blue 
            temp.green = (int)paddedImage.at<Vec3b>(i, j).val[1]; // this copys value of green
            temp.red = (int)paddedImage.at<Vec3b>(i, j).val[2]; // this copys value of red 
            image[i].push_back(temp); //adds a pixel in jth positon to ith row
        }
    }
    return image;
}

void showImage(string path, image2D source) {
    Mat img = imread(path);
    int width = source[0].size();
    int height = source.size();
    string newPath = path.replace(path.find("."), 4, "Edge.png");
    //temporary fix, needs to save at any path... Add through arguments.
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            img.ptr<Vec3b>(i)[j].val[0] = (uchar)source[i][j].blue;
            img.ptr<Vec3b>(i)[j].val[1] = (uchar)source[i][j].green;
            img.ptr<Vec3b>(i)[j].val[2] = (uchar)source[i][j].red;
        }
    }
    imwrite(newPath, img);
    imshow("image", img);
    waitKey(0);
    destroyWindow("image");
}
