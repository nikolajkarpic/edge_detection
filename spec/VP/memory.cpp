#include "memory.hpp"

using namespace std;
using namespace sc_core;
using namespace tlm;
using namespace sc_dt;

memory::memory(sc_module_name name):
  sc_module(name),
  cpu_tsoc("cpu_tsoc")
  //conv_tsoc("conv_tsoc")
{
	cpu_tsoc.register_b_transport(this, &memory::b_transport);
	//conv_tsoc.register_b_transport(this, &memory::b_transport);
    
    SC_REPORT_INFO("Memory", "Platform is constructed.");
}

void memory::b_transport(pl_t& pl, sc_time& offset){
    tlm_command cmd = pl.get_command();
	uint64 address = pl.get_address();
	unsigned char* data = pl.get_data_ptr();
	unsigned int len = pl.get_data_length();


    switch(cmd){

        case TLM_WRITE_COMMAND:{
            switch(address){
                case VP_ADDR_MEMORY_KERNEL:
                    kernel = *((SCkernel2D*)pl.get_data_ptr());
                    //  //TESTING PURPOSES INGORE:

                    // for(int u = 0; u < kernel.size(); u++){    
                    //     for (int f = 0; f < kernel[0].size(); f++){
                    //         cout << kernel[u][f] << " ";
                    //     }
                    //     cout << endl;
                        
                    // }
                    // cout << "*********************************************************************************************************" << endl;
                    //ENDING TESTING PURPOSES
                    SC_REPORT_INFO("Memory", "Kernel recieved.");
                    break;
                case VP_ADDR_MEMORY_IMAGE:
                    inputImage = *((SCimg2D*)pl.get_data_ptr());
                    //TESTING PURPOSES INGORE:

                    // for(int u = 0; u < inputImage.size(); u++){    
                    //     for (int f = 0; f < inputImage[0].size(); f++){
                    //         cout << inputImage[u][f] << " ";
                    //     }
                    //     cout << endl;
                    // }
                    // cout << "*********************************************************************************************************" << endl;
                    //ENDING TESTING PURPOSES
                    SC_REPORT_INFO("Memory", "Image recieved.");
                    break;
                
            }
        }


    }
}