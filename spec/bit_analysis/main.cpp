#include "common.h"
#include "bitTest.h"
#include "inputOutput.h"
#include "imageProccesing.h"
#include "kernelGeneration.h"


using namespace cv; 
using namespace std; 






int sc_main(int argc, char* argv[]) { 
    
    if (argc != 2){
        cout<< "Program wasn't called properly.\nTo run it path to the target image must be passed as an argument.\nExample: ./output /home/user/g3-2021/data/input1.png" << endl;
        cout<< "For program to execute target image must be named input1.png" << endl;
        return 0;
    }
    stringArray kernelDeviationPrintout;
    string kernelDeviationPrintoutString;
    string path = argv[1];
    string path1 = "/home/donnico/g3-2021/data/Lenna.png";
    image2D temp;
    image2D convolutionModelValues;
    SCimage2D SCArray2D;
    SCkernel2D SCkernel2Dtemp;

    kernel2D  LoG = createKernelLoGDescrete(KERNEL_SIZE, 1.4); // genererating LoG kernel

    string pathTemp;
    string pathPass;
    pathPass = path;
    string numToStringIner;
    string numToStringOuter;
    int i = 18;
    int f = 1;

    int counter = 0;//num of wrong bits
    float Image_size = 0;//full img sise
    float fault = 0;//precentile error
    unsigned char writeEnable = 1;
    //creating a file for storing info about the num of different pixels
    fstream results_txt;
    results_txt.open("results.txt",ios::out);

    while (f < 7){
        //making a perfect image
        cout<<pathPass<<endl;
        temp = loadImage(pathPass);
        temp = grayScale(temp);
        temp = convolution2D(LoG, temp);
        temp = zeroCrossingTest(temp);
        
        showImage(pathPass,temp);
        Image_size = temp[0].size() * temp.size();

        while(i <= 27) {
            SC_float_type SCsigma(i, BIT_FLOAT_POINT);
            SCsigma = 1.4;
            SC_int_small_type SCKernelSize;
            SCKernelSize = 9;
            SCkernel2Dtemp = SCcreateKernelLoGDescrete(SCKernelSize, SCsigma, i);
            SCArray2D = SCloadImage(pathPass);
            SCArray2D = SCgrayScale(SCArray2D, i);
            SCArray2D = SCconvolution2D(SCkernel2Dtemp, SCArray2D, i);

            SCArray2D = SCzeroCrossingTest(SCArray2D);

            //calculating the deviation in percentiles and writting in file
            counter = comparePixels(temp, SCArray2D);
            fault = ( (counter * 1.0) / Image_size) * 100;
            results_txt<<"image: "<< f <<"    num of bits: "<< i <<"     pixel deviation:     "<< fault <<'%'<<endl;
            
            pathTemp = pathPass;
            numToStringIner = to_string(f) +"_"+ to_string(i) + "bit_" + "Edge.png";
            pathTemp = pathTemp.replace(pathTemp.find(to_string(f)), 5, numToStringIner);
            cout << pathTemp << endl;
            //pathTemp = pathPass;
            SCshowImage(pathPass, pathTemp, SCArray2D);
            i = i + 3; 
            
            
        }
        results_txt<<endl;
        pathPass = pathPass.replace(pathPass.find(to_string(f)), 5, to_string(f+1)+".png");
        
        f ++;
        i = 18;

    }
    results_txt.close();
    
    return 0;
}