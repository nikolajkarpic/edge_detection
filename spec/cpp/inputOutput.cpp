#include"inputOutput.h"

image2D loadImage(string path)
{
	Mat img = imread(path);
    int width = img.cols; //gets width of an image
    int height = img.rows;  //gets height of an image

    Mat imgBlur = Mat::zeros(cv::Size(height, width), CV_64FC1); //makes a copy of a loaded image with 0 as values.
    Mat imgGray = img.clone();

    pixel temp; //temp var

    image1D pixelArrayTemp; //temp value to initialize image2D k
    image2D image;

    for (int i = 0; i < height; i++) { //loops through the image
        image.push_back(pixelArrayTemp);
        for (int j = 0; j < width; j++) {
            temp.blue = (int)img.at<Vec3b>(i, j).val[0]; // this copys value of blue 
            temp.green = (int)img.at<Vec3b>(i, j).val[1]; // this copys value of green
            temp.red = (int)img.at<Vec3b>(i, j).val[2]; // this copys value of red 
            image[i].push_back(temp); //adds a pixel in jth positon to ith row
        }
    }
    return image;
}
