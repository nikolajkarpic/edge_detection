#include "memory.hpp"

using namespace std;
using namespace sc_core;
using namespace tlm;
using namespace sc_dt;

memory::memory(sc_module_name name) : sc_module(name),
                                      MEM_ic_tsoc("cpu_tsoc")
//conv_tsoc("conv_tsoc")
{
    //cpu_tsoc.register_b_transport(this, &memory::b_transport);
    MEM_ic_tsoc.register_b_transport(this, &memory::b_transport);
    MEM_conv_tsoc.register_b_transport(this, &memory::b_transport);
    SC_REPORT_INFO("Memory", "Platform is constructed.");
}

void memory::b_transport(pl_t &pl, sc_time &offset)
{
    tlm_command cmd = pl.get_command();
    uint64 address = pl.get_address();
    unsigned char *data = pl.get_data_ptr();
    unsigned int len = pl.get_data_length();

    switch (cmd)
    {
        case TLM_WRITE_COMMAND:
        {
            switch (address)
            {
                case MEMORY_KERNEL:
                    kernel = *((SCkernel2D *)pl.get_data_ptr());
                    // //TESTING PURPOSES INGORE:

                    // for(int u = 0; u < kernel.size(); u++){
                    //     for (int f = 0; f < kernel[0].size(); f++){
                    //         cout << kernel[u][f] << " ";
                    //     }
                    //     cout << endl;

                    // }
                    // cout << "*********************************************************************************************************" << endl;
                    // //ENDING TESTING PURPOSES
                    SC_REPORT_INFO("Memory", "Kernel recieved.");
                    break;
                case MEMORY_IMG:
                    inputImage = *((SCimg2D *)pl.get_data_ptr());
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

                // case MEMORY_CONV_RESULT:
                //     convOutput = *((convOut2D*)pl.get_data_ptr());
                //     //TESTING PURPOSES INGORE:

                //     // for(int u = 0; u < convOutput.size(); u++){
                //     //     for (int f = 0; f < convOutput[0].size(); f++){
                //     //         cout << convOutput[u][f] << " ";
                //     //     }
                //     //     cout << endl;
                //     // }
                //     // cout << "*********************************************************************************************************" << endl;
                //     //ENDING TESTING PURPOSES
                //     SC_REPORT_INFO("Memory", "Convolution output recieved.");
                //     break;
                default:
                    pl.set_response_status(TLM_COMMAND_ERROR_RESPONSE);
                    SC_REPORT_ERROR("MEMORY", "Invalid address");
                    break;
            }
            break;
        }
        case TLM_READ_COMMAND:
            switch (address)
            {
                case MEMORY_KERNEL:
                    pl.set_data_ptr((unsigned char *)&kernel);
                    pl.set_data_length(kernel.size());
                    pl.set_response_status(TLM_OK_RESPONSE);
                    cout << "mem kernel read" << endl;
                    //TESTING PORPOSES
                    // for(int u = 0; u < kernel.size(); u++){
                    //     for (int f = 0; f < kernel[0].size(); f++){
                    //         cout << kernel[u][f] << " ";
                    //     }
                    //     cout << endl;

                    // }
                    // cout << "*********************************************************************************************************" << endl;
                    SC_REPORT_INFO("Memory", "Kernel sent to convolution.");
                    break;

                case MEMORY_IMG:
                    pl.set_data_ptr((unsigned char *)&inputImage);
                    pl.set_data_length(inputImage.size());
                    pl.set_response_status(TLM_OK_RESPONSE);
                    //TESTING PURPOSES
                    // cout << "mem iamge read" << endl;
                    // for(int u = 0; u < inputImage.size(); u++){
                    //     for (int f = 0; f < inputImage[0].size(); f++){
                    //         cout << inputImage[u][f] << " ";
                    //     }
                    //     cout << endl;
                    // }
                    // cout << "*********************************************************************************************************" << endl;
                    //ENDING TESTING
                    SC_REPORT_INFO("Memory", "Image sent to convolution.");

                    break;
                // case MEMORY_CONV_RESULT:
                //     pl.set_data_ptr((unsigned char*)&convOutput);
                // 	pl.set_data_length(convOutput.size());
                // 	pl.set_response_status( TLM_OK_RESPONSE );
                //     SC_REPORT_INFO("Memory", "Convolution results sent to CPU.");

                //     break;
                default:
                    pl.set_response_status(TLM_COMMAND_ERROR_RESPONSE);
                    SC_REPORT_ERROR("MEMORY", "Invalid address");
                    break;
            }
            break;
        default:
            pl.set_response_status(TLM_COMMAND_ERROR_RESPONSE);
            SC_REPORT_ERROR("MEMORY", "TLM invalid command");
            break;
        }
}
