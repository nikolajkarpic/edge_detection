#include "common.h"
#include "inputOutput.h"
#include "imageProccesing.h"
#include "kernelGeneration.h"

using namespace cv; 
using namespace std; 






int main() { 
    
    
    vector<vector<float>> LOGk = { {0,1,1,2,2,2,1,1,0},
                                    {1,2,4,5,5,5,3,2,1},
                                    {1,4,5,3,0,3,5,4,1},
                                    {2,5,3,-12,-24,-12,3,5,2},
                                    {2,5,0,-24,-40,-24,0,5,2},
                                    {2,5,3,-12,-24,-12,3,5,2},
                                    {1,4,5,3,0,3,5,4,1},
                                    {1,2,4,5,5,5,3,2,1},
                                    {0,1,1,2,2,2,1,1,0}};

    vector<vector<float>> LOGk1 = { {-1,-1,-1},
                                    {-1,8,-1},
                                    {-1,-1,-1} };

    string path = "C:\\FTN\\8_osmi_semestar\\Edge_detection\\Edge_detection_cpp\\data\\Lenna.png";
    image2D temp;



    temp = loadImage(path);

    temp = grayScale(temp);

    kernel2D LoGKernel = createKernelLoG(3, 1);
    kernel2D kernelGauss = createKernelGauss(10, 2.7);

    image2D edge = convolution2D(LOGk1, temp);
    //edge = convolution2D(LoGKernel, temp);

    //cout << temp[1][1].blue << endl;

    edge = zeroCrossingTest(edge);
    showImage(path, edge);



    //cout << temp.at(2).blue << endl;

    //imshow("Image", img); 
    //imshow("ImageGray", imgGray);
    //waitKey(0);

    return 0;
}