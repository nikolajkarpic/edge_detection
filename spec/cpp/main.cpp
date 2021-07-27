#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp> 
#include <opencv2/imgproc.hpp> 
#include <iostream> 
#include <vector>



using namespace cv; 
using namespace std; 

// stcurt that holds red green blue values of a pixel.
struct pixel
{
    int red;
    int green;
    int blue;
};



int main() { 
    string path = "C:\\FTN\\8_osmi_semestar\\Edge_detection\\Edge_detection_cpp\\data\\Lenna.png"; 
    Mat img = imread(path); 
    
    int width = img.cols; //gets width of an image
    int height = img.rows;  //gets height of an image
    Mat imgBlur = Mat::zeros(cv::Size(height,width), CV_64FC1); //makes a copy of a loaded image with 0 as values.
    Mat imgGray = img.clone();
    Vec3b pixelTemp; //temoporary variable for copying values of pixel

    pixel temp; //temp var

    //pixel slika[width * height];
    vector<pixel> slika;
    for (int i = 0; i < height; i++) { //loops through the image
        for (int j = 0; j < width; j++) {
            //Vec3i color = img.at<Vec3i>(Point(i, j));
            //imgGray.at<Vec3b>(i, j) = img.at<Vec3b>(i, j);
            pixelTemp = img.at<Vec3b>(i, j);
            temp.red = (int)img.at<Vec3b>(i, j).val[0]; // this copys value of red 
            temp.green = (int)img.at<Vec3b>(i, j).val[1]; // this copys value of green
            temp.blue = (int)img.at<Vec3b>(i, j).val[2]; // this copys value of blue 
            slika.push_back(temp); //adds pixel to a vector
            
            imgGray.at<Vec3b>(i, j).val[0] = (uchar)temp.blue; // tests if all of the above works

            //imgGray.at<Vec3b>(i, j) = Vec3b(100, 100, 100);
        }
    }

    cout << slika.at(2).blue << endl;

    imshow("Image", img); 
    imshow("ImageGray", imgGray);
    waitKey(0);

    return 0;
}