#include "convolution.hpp"
#include "memory.hpp"

#include <tlm>
#include <tlm_utils/simple_target_socket.h>
#include <vector>

using namespace sc_core;
using namespace sc_dt;
using namespace std;
using namespace tlm;	



SC_HAS_PROCESS(conv);
conv::conv(sc_module_name name):
	sc_module(name),
	CONV_ic_tsoc("IC_to_conv"),
	CONV_ic_isoc("CONV_to_ic")
{

	CONV_ic_tsoc.register_b_transport(this, &conv::b_transport);

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
			// case proceseor trazio sliku:
			// 	if (taj flag){
			// 		posalje slliku
			// 	}else{
			// 		pl.set_response_status( TLM_COMMAND_ERROR_RESPONSE );
			// 	}


			break;

		}
		default:
			pl.set_response_status( TLM_COMMAND_ERROR_RESPONSE );
			SC_REPORT_ERROR("CORE", "TLM bad command");
	
	}

}


void conv::convolution()
{
	sc_core::sc_time offset = sc_core::SC_ZERO_TIME;
	pl.set_address(VP_ADDR_MEMORY_IMAGE);
    pl.set_command(TLM_READ_COMMAND);
    pl.set_data_length(img.size());
    pl.set_data_ptr((unsigned char*)&img);
    pl.set_response_status (TLM_INCOMPLETE_RESPONSE);
	CONV_ic_isoc->b_transport(pl, offset);

	pl.set_address(VP_ADDR_MEMORY_KERNEL);
    pl.set_command(TLM_READ_COMMAND);
    pl.set_data_length(kernel.size());
    pl.set_data_ptr((unsigned char*)&kernel);
    pl.set_response_status (TLM_INCOMPLETE_RESPONSE);
	CONV_ic_isoc->b_transport(pl, offset);

	SC_float_type sum(10, 32);
	SC_conv_out_t convOutValue;
	convOut1D convResultTemp;
	//sum = 0;  
	int columns = img[0].size();
	int rows = img.size();
	int padding = (KERNEL_SIZE - 1) / 2;

	for (int i = padding; i < rows - padding; i++)
	{
		convResult.push_back(convResultTemp);
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
			if(sum > 0)	
				convOutValue = 1;
			if(sum < 0)
				convOutValue = -1;
			if (sum == 0)
				convOutValue = 0;
			convResult[i].push_back(convOutValue);
		}
	}

	conv_time+=sc_time(5, SC_NS); //for now this takes 5 ns, quantumkeeper still not implemented

	pl.set_address(VP_ADDR_CPU);
    pl.set_command(TLM_WRITE_COMMAND);
    pl.set_data_length(convResult.size());
    pl.set_data_ptr((unsigned char*)&convResult);
    pl.set_response_status (TLM_INCOMPLETE_RESPONSE);

	CONV_ic_isoc->b_transport(pl, conv_time); //sending conv_result to memory 

	//conv_end.notify();

	//place for triggering a signal that activates zero_crossing or should that be done once the memory i written?

}






