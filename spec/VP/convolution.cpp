#include "convolution.hpp"
#include "common.hpp"
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
	
	vector<SC_float_type> kernel_vector; //kernel_vector za smestanje niza vrednosti kernela
	SCkernel2D kernel;  //2D kernel vrednosti

	vector <SC_pixel_value_type> img_vector; //niz vrednosti piksela 0-255
	vector <vector <SC_pixel_value_type>> img //2D vrednosti piksela VRV TREBA U COMMON typedef

	SC_int_big_type rows=0, columns=0; //broj redova i kolona
	vector <SC_int_big_type> img_size; //vektor za smestanje img_size iz memorije tako da je prvi element broj redova a drugi kolona

	int n=0; //brojac za inkrementovanje indeksa kernel i img vektora

	switch(cmd)
	{
		case TLM_WRITE_COMMAND:
		{
			switch(addr)
			{
				case IMG_SIZE:

					img_size = *((vector<SC_float_type>*)data);
					rows = img_size[0];
					columns = img_size[1];			

					break;

				case CONV_KERNEL_ARRAY:

					kernel_vector = *((vector<SC_float_type>*)data);

					for(int i = 0; i < KERNEL_SIZE; i++)
				    		for(int j = 0; j < KERNEL_SIZE; j++)
							kernel[i][j]=kernel_vector[n++];
					n = 0;

					break;

				case IMG_ARRAY:

					img_vector = *((vector<SC_float_type>*)data);
					
					for(int i = 0; i < columns+2; i++)
				    		for(int j = 0; j < lines+2; j++)
							img[i][j]=img_vector[n++];
					n = 0;	
					
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
	vector<SC_float_type> conv_result; // vektor koji sadrzi rezultat konvolucije
	SC_float_type sum(10, 32);  
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
			
			//da li treba proveriti da li je rezultat veci od 255 ili manji od 0, s obzirom da se dobijaju realni brojevi
			conv_result.push_back(sum);
			
		}
	}


}






