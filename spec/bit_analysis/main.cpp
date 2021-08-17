#include "common.h"
#include "inputOutput.h"
#include "imageProccesing.h"
#include "kernelGeneration.h"

using namespace cv; 
using namespace std; 






int sc_main(int argc, char* argv[]) { 
    
    if (argc < 2){
        cout<< "Program wasn't called properly.\n To run it path to the target image must be passed as an argument.\n Example: ./output /home/user/g3-2021/data/Lenna.png" << endl;
        return 0;
    }

    //numT d(10,3);
    
    SC_float_type SCsigma(BIT_WIDTH, BIT_FLOAT_POINT);
    SCsigma = 1.4;
    SC_int_small_type SCKernelSize;
    SCKernelSize = 9;
    SCimage2D SCArray2D;
    SCkernel2D SCkernel2Dtemp;
    
    SCkernel2Dtemp = SCcreateKernelLoGDescrete(SCKernelSize, SCsigma);

    cout <<"moj krs SC :"<<SCkernel2Dtemp[3][3] << endl;
    
    string path = argv[1];

    string path1 = "/home/donnico/g3-2021/data/Lenna.png";
    image2D temp;

    SCArray2D = SCloadImage(path);
    SCArray2D = SCgrayScale(SCArray2D);
    SCArray2D = SCconvolution2D(SCkernel2Dtemp, SCArray2D);
    SCArray2D = SCzeroCrossingTest(SCArray2D);

    cout << SCArray2D[1][1].blue <<endl;

    //temp = loadImage(path); //loading an image

    //cout << temp[1][1].blue << endl;
    //temp = grayScale(temp); //grayscaling an image


    kernel2D  LoG = createKernelLoGDescrete(KERNEL_SIZE, 1.4); // genererating LoG kernel

    cout << "LOG:"<<LoG[3][3] <<endl;
    //image2D edge = convolution2D(LoG, temp); // convolving grayscaled image with LoG kernel

    //edge = zeroCrossingTest(edge); // doing zerocrossing test
    //showImage(path, edge); //shows image
    SCshowImage(path, SCArray2D);
    return 0;
}