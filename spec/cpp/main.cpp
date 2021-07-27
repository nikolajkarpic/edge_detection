#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp> 
#include <opencv2/imgproc.hpp> 
#include <iostream> 
#include <vector>



using namespace cv; 
using namespace std; 


struct pixel
{
    int red;
    int green;
    int blue;
};



int main() { 
    string path = "C:\\FTN\\8_osmi_semestar\\Edge_detection\\Edge_detection_cpp\\data\\Lenna.png"; 
    Mat img = imread(path); 
    
    int width = img.cols;
    int height = img.rows;
    Mat imgBlur = Mat::zeros(cv::Size(height,width), CV_64FC1);
    Mat imgGray = img.clone();
    Vec3b pixelTemp;

    pixel temp;

    //pixel slika[width * height];
    vector<pixel> slika;
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            //Vec3i color = img.at<Vec3i>(Point(i, j));
            //imgGray.at<Vec3b>(i, j) = img.at<Vec3b>(i, j);
            pixelTemp = img.at<Vec3b>(i, j);
            temp.red = (int)img.at<Vec3b>(i, j).val[0];
            temp.green = (int)img.at<Vec3b>(i, j).val[1];
            temp.blue = (int)img.at<Vec3b>(i, j).val[2];
            slika.push_back(temp);
            
            imgGray.at<Vec3b>(i, j).val[0] = (uchar)temp.blue;

            //imgGray.at<Vec3b>(i, j) = Vec3b(100, 100, 100);
        }
    }

    cout << slika.at(2).blue << endl;

    imshow("Image", img); 
    imshow("ImageGray", imgGray);
    waitKey(0);

    return 0;
}