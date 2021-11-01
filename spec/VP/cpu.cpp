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
    FILE *fp;
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
        if (i <2){
            i++;
        }

             if (i <2){
            i++;
            }
        
    }

    inFile.close();
    cout <<"Loaded image from file."<< endl;
}

void createKernel(){


}

SCkernel2D SCcreateKernelLoGDescrete(SC_int_small_type size, SC_float_type sigma, int BIT_WIDTH_PASS)
{
	SCkernel2D returnKernel;
	SCkernel1D temp;
	SC_float_type kernelValue(BIT_WIDTH_PASS,BIT_FLOAT_POINT);

	for (int i = 0; i < size; i++) {
		returnKernel.push_back(temp);
		for (int j = 0; j < size; j++) {
			kernelValue = SCcalculateLoGValue((i - (size - 1) / 2), (j - (size - 1) / 2), sigma);
			returnKernel[i].push_back(kernelValue);
		}
	}
	return returnKernel;
}

SC_float_type SCcalculateLoGValue(SC_int_small_type x, SC_int_small_type y, SC_float_type sigma, int BIT_WIDTH_PASS)
{
	SC_float_type kernelValue(BIT_WIDTH_PASS,BIT_FLOAT_POINT);
	kernelValue = -(1 / (sigma * sigma * sigma * sigma * PI_KG)) * (1 - (x * x + y * y) / (2 * sigma * sigma)) * (exp(-(x * x + y * y) / (2 * sigma * sigma)));
	kernelValue = SCroundLoGValue(kernelValue, sigma);
	return kernelValue;
}

SC_float_type SCroundLoGValue(SC_float_type x, SC_float_type sigma, int BIT_WIDTH_PASS) {

	SC_float_type val(BIT_WIDTH_PASS, BIT_FLOAT_POINT);
	val = x * (-40 / -(1 / (sigma * sigma * sigma * sigma * PI_KG)) * (1 - (0 * 0 + 0 * 0) / (2 * sigma * sigma)));
	return val;
}