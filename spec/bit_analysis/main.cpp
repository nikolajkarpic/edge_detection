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
 
    string path = argv[1];
    string path1 = "/home/donnico/g3-2021/data/Lenna.png";
    image2D temp;

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
    while (f < 7){
        while(i < 27) {
            SC_float_type SCsigma(i, BIT_FLOAT_POINT);
            SCsigma = 1.4;
            SC_int_small_type SCKernelSize;
            SCKernelSize = 9;
            SCkernel2Dtemp = SCcreateKernelLoGDescrete(SCKernelSize, SCsigma, i);

            SCArray2D = SCloadImage(pathPass);
            SCArray2D = SCgrayScale(SCArray2D, i);
            SCArray2D = SCconvolution2D(SCkernel2Dtemp, SCArray2D, i);
            SCArray2D = SCzeroCrossingTest(SCArray2D);
            
            pathTemp = pathPass;
            numToStringIner = to_string(f) +"_"+ to_string(i) + "bit_" + "Edge.png";
            pathTemp = pathTemp.replace(pathTemp.find(to_string(f)), 5, numToStringIner);
            cout << pathTemp << endl;
            //pathTemp = pathPass;
            SCshowImage(pathPass, pathTemp, SCArray2D);
            i = i + 2; 

        }
        
        pathPass = pathPass.replace(pathPass.find(to_string(f)), 5, to_string(f+1)+".png");
        cout<<pathPass<<endl;
        f ++;
        i = 18;
    }
    
    return 0;
}