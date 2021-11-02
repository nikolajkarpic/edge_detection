#include "cpu.hpp"

using namespace sc_core;
using namespace sc_dt;
using namespace std;

SC_HAS_PROCESS(cpu);
cpu::cpu(sc_module_name name):
	sc_module(name)
{

    //SC_THREAD(proces); // Is it thread tho?
    SC_REPORT_INFO("CPU", "Platform is constructed");
}

void cpu::scanFromFile(){
    ifstream inFile;
    inFile.open("/home/donnico/edge_detection/data/input2.png");
    matrix1D inputArrayTmp;
    int i = 0;
    int j = 0;
    int x;
    //SC_pixel_value_type pixelValue;
    
        while(inFile >> x){
            if (i == 0){
                rows = x;
            }
            if (i == 1){
                cols = x;
            }


            if (i > 1){
            inputArrayTmp.push_back(x);
            if (j == (cols - 1)){ // In file it will say number of rows and colums starting at 1 but cpp starts coutning from 0
                j = 0;
                inputArray.push_back(inputArrayTmp);
                inputArrayTmp.clear();
                continue;
            }
            j++;
        }
        if (i < 2){
            i++;
        }

             if (i < 2){
            i++;
            }
        
    }

    inFile.close();
    cout << "Loaded image from file." << endl;
}


void cpu::createKernelLoGDescrete()
{
	SCkernel1D tempKernel;
    SC_float_type (BIT_WIDTH_KERNEL,BIT_WIDTH_KERNEL_POINT);
	float kernelValue;

	for (int i = 0; i < KERNEL_SIZE; i++) {
		kernel.push_back(tempKernel);
		for (int j = 0; j < KERNEL_SIZE; j++) {
			kernelValue = calculateLoGValue((i - (KERNEL_SIZE - 1) / 2), (j - (KERNEL_SIZE - 1) / 2));

			kernel[i].push_back(kernelValue);
		}
	}
    cout << "Kernel generated." << endl;
}

float cpu::calculateLoGValue(int x, int y)
{
	float kernelValue = -(1 / (SIGMA * SIGMA * SIGMA * SIGMA * PI_KG)) * (1 - (x * x + y * y) / (2 * SIGMA * SIGMA)) * (exp(-(x * x + y * y) / (2 * SIGMA * SIGMA)));
	kernelValue = roundLoGValue(kernelValue);
	return kernelValue;
}

float cpu::roundLoGValue(float x) {

	float val = x * (-40 / -(1 / (SIGMA * SIGMA * SIGMA * SIGMA * PI_KG)) * (1 - (0 * 0 + 0 * 0) / (2 * SIGMA * SIGMA)));
	return val;
}

void cpu::writeImageToFile(){

    ofstream outFile;
    outFile.open("/home/donnico/edge_detection/data/input2TXT.txt");
    for (int l = 0; l < outputArray.size(); l ++){    
        for (int k = 0; k < outputArray[0].size(); k++){
            outFile << outputArray[l][k] << " ";
        }
        outFile << endl;
    }
    outFile.close();
    cout << "Image written to txt file.";
}