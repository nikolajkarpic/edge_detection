#include "common.h"
#include "inputOutput.h"

using namespace cv; 
using namespace std; 






int main() { 
    
    
    string path = "C:\\FTN\\8_osmi_semestar\\Edge_detection\\Edge_detection_cpp\\data\\Lenna.png";
    image2D temp;

    temp = loadImage(path);

    cout << temp[1][1].blue << endl;

    //cout << temp.at(2).blue << endl;

    //imshow("Image", img); 
    //imshow("ImageGray", imgGray);
    //waitKey(0);

    return 0;
}