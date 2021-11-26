#include "interconnect.hpp"

using namespace std;
using namespace tlm;
using namespace sc_core;
using namespace sc_dt;

interconnect::interconnect(sc_module_name name) : sc_module(name), offset(sc_core::SC_ZERO_TIME)
{
	IC_cpu_tsoc.register_b_transport(this, &interconnect::b_transport);
	IC_cpu_conv_tsoc.register_b_transport(this, &interconnect::b_transport);
	IC_conv_tsoc.register_b_transport(this, &interconnect::b_transport);
	SC_REPORT_INFO("IC", "Platform is constructed.");
}

void interconnect::b_transport(pl_t &pl, sc_core::sc_time &offset)
{
	uint64 taddr = 0;
	tlm_command cmd = pl.get_command();
	uint64 addr = pl.get_address();
	unsigned char *data = pl.get_data_ptr();

	switch (cmd)
	{
	case TLM_WRITE_COMMAND:
	{
		if (addr >= VP_ADDR_CONVOLUTION && addr <= VP_ADDR_CONVOLUTION_READY)
		{

			taddr = addr & 0x000FFFFF;
			pl.set_address(taddr);
			IC_conv_isoc->b_transport(pl, offset);
			pl.set_address(addr);
		}
		else if (addr >= VP_ADDR_MEMORY && addr <= VP_ADDR_MEMORY_KERNEL)
		{

			taddr = addr & 0x000FFFFF;
			pl.set_address(taddr);
			IC_mem_isoc->b_transport(pl, offset);
			pl.set_address(addr);
		}
		else if (addr == VP_ADDR_CPU)
		{
			IC_cpu_isoc->b_transport(pl, offset);
		}

		pl.set_address(addr); //not sure why needed, copied from v12 example

		break;
	}
	case TLM_READ_COMMAND:
	{
		taddr = addr & 0x0000000F;
		pl.set_address(taddr);
		IC_mem_isoc->b_transport(pl, offset);
		break;
	}
	default:
		pl.set_response_status(TLM_COMMAND_ERROR_RESPONSE);
		SC_REPORT_ERROR("CORE", "TLM bad command");
	}
	offset += sc_core::sc_time(10, sc_core::SC_NS);
}
