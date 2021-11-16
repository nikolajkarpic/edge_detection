#include "convolution.hpp"
#include "memory.hpp"

#include <tlm>
#include <tlm_utils/simple_target_socket.h>
#include <vector>

using namespace sc_core;
using namespace sc_dt;
using namespace std;
using namespace tlm;	

//gloabal variables:

SCimg2D img; //for loading the image
SCkernel2D kernel; //for loading the kernel
std::vector<std::vector<SC_float_type>>  conv_result; //for sending the result

tlm_generic_payload pl; //generic payload
sc_time conv_time; //time


SC_HAS_PROCESS(conv);
conv::conv(sc_module_name name):
	sc_module(name),
	ic_tsoc("ic_tsoc"),
	conv_isoc("conv_tsoc")
{

	ic_tsoc.register_b_transport(this, &conv::b_transport);

}

void conv::b_transport(pl_t& pl, sc_time& offset)
{

	tlm_command    cmd  = pl.get_command();
	uint64         addr = pl.get_address();
	unsigned char *data = pl.get_data_ptr();
	

	switch(cmd)
	{
		case TLM_WRITE_COMMAND:
		{
			switch(addr)
			{

				case CONV_KERNEL:
					kernel = *((SCkernel2D*)data);
					pl.set_response_status ( TLM_OK_RESPONSE );
					break;

				case CONV_IMG:
					img = *((SCimg2D*)data);
					pl.set_response_status ( TLM_OK_RESPONSE );
					break;

				default:
					pl.set_response_status(TLM_ADDRESS_ERROR_RESPONSE);
					break;			

			}
			break;

		}
		case TLM_READ_COMMAND:
		{


			break;

		}
		default:
			pl.set_response_status( TLM_COMMAND_ERROR_RESPONSE );
			SC_REPORT_ERROR("CORE", "TLM bad command");
	
	}

}


void conv::convolution()
{
	SC_float_type sum(10, 32);
	int rows = 1;
	int columns = 1;
	int img[20][20];
	int kernel[3][3];
	//sum = 0;  
	int padding = (KERNEL_SIZE - 1) / 2;

	for (int i = padding; i < rows - padding; i++)
	{
		for (int j = padding; j < columns - padding; j++)
		{
			sum = 0;
			for (int k = 0; k < KERNEL_SIZE; k++)
			{
				for (int l = 0; l < KERNEL_SIZE; l++)
				{

				sum = sum + (img[i-padding+k][j-padding+l]*kernel[k][l]);

				}
			}
			if(sum > 255)	
				sum=255;
			if(sum < 0)
				sum=0;
			conv_result[i].push_back(sum);
		}
	}

	conv_time+=sc_time(5, SC_NS); //for now this takes 5 ns, quantumkeeper still not implemented

	pl.set_address(MEMORY_CONV_RESULT);
        pl.set_command(TLM_WRITE_COMMAND);
        pl.set_data_length(conv_result.size());
        pl.set_data_ptr((unsigned char*)&conv_result);
        pl.set_response_status (TLM_INCOMPLETE_RESPONSE);

	conv_isoc->b_transport(pl, conv_time); //sending conv_result to memory 

	conv_end.notify();

	//place for triggering a signal that activates zero_crossing or should that be done once the memory i written?

}






