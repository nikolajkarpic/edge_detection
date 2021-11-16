#include "interconnect.hpp"


using namespace std;
using namespace tlm;
using namespace sc_core;
using namespace sc_dt;


interconnect::interconnect(sc_module_name name) :
	sc_module(name)
{
	cpu_tsoc.register_b_transport(this, &interconnect::b_transport);
}



void interconnect::b_transport(pl_t& pl, sc_core::sc_time& offset)
{

	tlm_command    cmd  = pl.get_command();
        uint64         addr = pl.get_address();
        unsigned char *data = pl.get_data_ptr();
	offset += sc_time(2, SC_NS);

	switch(cmd)
        {
                case TLM_WRITE_COMMAND:
                {
			if(addr >= VP_ADDR_CONVOLUTION && addr <= VP_ADDR_CONVOLUTION_IMAGE)
			{

				taddr = addr & 0x0000000F ;
				pl.set_address(taddr) ;
				conv_isoc−>b_transport(pl,  offset);
				
			}
			else if(addr >= VP_ADDR_MEMORY && addr <= VP_ADDR_MEMORY_KERNEL)
			{

				taddr = addr & 0x0000000F ;
				pl.set_address(taddr) ;
				mem_isoc−>b_transport(pl,  offset);
				
			}

			pl.set_address(addr); //not sure why needed, copied from v12 example
		
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
