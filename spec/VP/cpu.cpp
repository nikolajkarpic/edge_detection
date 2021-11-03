#include "cpu.hpp"

using namespace sc_core;
using namespace sc_dt;
using namespace std;

SC_HAS_PROCESS(cpu);
cpu::cpu(sc_module_name name):
	sc_module(name)
{

    SC_THREAD(CPU_process); // Is it thread tho?
    SC_REPORT_INFO("CPU", "Platform is constructed");
}

void cpu::scanFromFile(){
    ifstream inFile;
    inFile.open("/home/donnico/FTN/edge_detection/spec/VP/VPtest.txt");
    matrix1D inputArrayTmp;
    int i = 0;
    int j = 0;
    int x;
        while(inFile >> x){
            if (i == 0){
                rows = x;
                cout << "ROWS:"<< rows << endl;
            }
            if (i == 1){
                cols = x;
                cout << "COLS:"<< cols << endl;
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
    }

    inFile.close();

    //TESTING PURPOSES INGORE

    // for (int u = 0; u < inputArray.size(); u ++){    
    //     for (int f = 0; f < inputArray[0].size(); f++){
    //         cout << inputArray[u][f] << " ";
    //     }
    //     cout << endl;
    // }

    //ENDING TESTING PURPOSES

    SC_REPORT_INFO("CPU", "Loaded image from file.");
}


void cpu::createKernelLoGDescrete() //kernel generation works
{
	SCkernel1D tempKernel;
    SC_float_type kernelValueSC(BIT_WIDTH_KERNEL,BIT_WIDTH_KERNEL_POINT) ;
	float kernelValue;

	for (int i = 0; i < KERNEL_SIZE; i++) {
		kernel.push_back(tempKernel);
		for (int j = 0; j < KERNEL_SIZE; j++) {
			kernelValue = calculateLoGValue((i - (KERNEL_SIZE - 1) / 2), (j - (KERNEL_SIZE - 1) / 2));
            kernelValueSC = kernelValue;
			kernel[i].push_back(kernelValueSC);
		}
	}

    //TESTING PURPOSES INGORE

    // for (int u = 0; u < kernel.size(); u ++){    
    //     for (int f = 0; f < kernel[0].size(); f++){
    //         cout << kernel[u][f] << " ";
    //     }
    //     cout << endl;
    // }

    //ENDING TESTING PURPOSES
    SC_REPORT_INFO("CPU", "Kernel generated.");
}

float cpu::calculateLoGValue(int x, int y)
{
	float kernelValue = -(1 / (SIGMA * SIGMA * SIGMA * SIGMA * PI_KG)) * (1 - (x * x + y * y) / (2 * SIGMA * SIGMA)) * (exp(-(x * x + y * y) / (2 * SIGMA * SIGMA)));
	kernelValue = roundLoGValue(kernelValue);
	return kernelValue;
}

float cpu::roundLoGValue(float x) {

	float val = x * (-40 / -(1 / (SIGMA * SIGMA * SIGMA * SIGMA * PI_KG)) * (1 - (0 * 0 + 0 * 0) / (2 * SIGMA * SIGMA)));
    //TESTING PURPOSES IGNORE
    //cout << val <<endl;
    //EDNIGN TESTING 
	return val;
}

void cpu::writeImageToFile(){
    //TESTING PUROPES INGMORE
    outputArray = inputArray;
    //END TESTING
    ofstream outFile;
    outFile.open("/home/donnico/FTN/edge_detection/spec/VP/outFile.txt");
    for (int l = 0; l < outputArray.size(); l ++){    
        for (int k = 0; k < outputArray[0].size(); k++){
            outFile << outputArray[l][k] << " ";
        }
        outFile << endl;
    }
    
    //TESTING PURPOSES INGORE
    //outFile << "Majmuneee";
    // for (int u = 0; u < outputArray.size(); u ++){    
    //     for (int f = 0; f < outputArray[0].size(); f++){
    //         cout << outputArray[u][f] << " ";
    //     }
    //     cout << endl;
    // }

    //ENDING TESTING PURPOSES

    outFile.close();
    SC_REPORT_INFO("CPU", "Image written to txt file.");
}

void cpu::zeroCrossingTest(){
    //TESTING PURPOSES
    //convOut = inputArray;
    //ENDING TEST
    int sourceHeight = convOut.size();
    int sourceWidth = convOut[1].size();

    int negCouter;
    int posCoutner;
    matrix1D tempMatrixRow;

    for (int i = 1; i < sourceHeight - 1; i++) {
		convOut.push_back(tempMatrixRow);
		for (int j = 1; j < sourceWidth - 1; j++) {
			negCouter = 0;
			posCoutner = 0;
			for (int k = -1; k < 2; k++) {
				for (int l = -1; l < 2; l++) {
					if (k != 0 && l != 0) {
                        cout<< "kurcina" << endl;
						if (convOut[i + k][j + l] < 0) {
							negCouter++;
						}else if(convOut[i + k][j + l] > 0) {
							posCoutner++;
						}
					}
				}
			}
			outputArray[i - 1].push_back(NO_EDGE);
			if (negCouter > 0 && posCoutner > 0) {
                outputArray[i - 1].push_back(EDGE);
			}
		}
	}
    SC_REPORT_INFO("CPU", "Zero crossing done.");
}

void cpu::CPU_process(){
    sc_time loct;
	tlm_generic_payload pl;
    tlm_utils::tlm_quantumkeeper qk;
    qk.reset();

    createKernelLoGDescrete();

    pl.set_address(VP_ADDR_MEMORY_KERNEL);
	pl.set_command(TLM_WRITE_COMMAND);	
	pl.set_data_length(kernel.size());
	pl.set_data_ptr((unsigned char*)&kernel);
	pl.set_response_status (TLM_INCOMPLETE_RESPONSE);

	SC_REPORT_INFO("CPU", "Kernel sent to memory.");
	//int_isoc->b_transport(pl, loct);
	//qk.set_and_sync(loct);
	//loct += sc_time(5, SC_NS);

    scanFromFile();

    pl.set_address(VP_ADDR_MEMORY_IMAGE);
	pl.set_command(TLM_WRITE_COMMAND);	
	pl.set_data_length(inputArray.size());
	pl.set_data_ptr((unsigned char*)&inputArray);
	pl.set_response_status (TLM_INCOMPLETE_RESPONSE);

	SC_REPORT_INFO("CPU", "Image sent to memory.");
	//int_isoc->b_transport(pl, loct);
	//qk.set_and_sync(loct);
	//loct += sc_time(5, SC_NS);

    //zeroCrossingTest(); // ZC can be tested after convolution is made. Untill then it stays commented.

    writeImageToFile();

    //cout<< "IT WORKS" <<endl;


}


//void cpu::b_transport_conv(){
//  This should be used for loading result of convolution, implement after conv is done.

//}