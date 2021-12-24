#include "common.h"
#include "inputOutput.h"
#include "imageProccesing.h"
#include "kernelGeneration.h"

using namespace cv; 
using namespace std; 






int main(int argc, char* argv[]) { 
    
    if (argc < 2){
        cout<< "Program wasn't called properly.\n To run it path to the target image must be passed as an argument.\n Example: ./output /home/user/g3-2021/data/Lenna.png" << endl;
        return 0;
    }

    
    string path = argv[1];

    string path1 = "/home/donnico/g3-2021/data/Lenna.png";
    image2D temp;

    temp = loadImage(path); //loading an image

    temp = grayScale(temp); //grayscaling an image


    kernel2D  LoG = createKernelLoGDescrete(KERNEL_SIZE, 1.4); // genererating LoG kernel

    //image2D edge = convolution2D(LoG, temp); // convolving grayscaled image with LoG kernel

    image2D edge = loopUnrolledConv(LoG, temp);

    cout << edge[0].size() << endl << edge.size() << endl;

    edge = zeroCrossingTest(edge); // doing zerocrossing test
    //edge1 = zeroCrossingTest(edge1); // doing zerocrossing test
    showImage(path, edge);
    //showImage(path, edge1); //shows image

    return 0;
}