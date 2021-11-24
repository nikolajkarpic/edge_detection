#ifndef MEMORY_HPP_INCLUDED
#define MEMORY_HPP_INCLUDED

#include "common.hpp"
#include "vp_address.hpp"

#include <systemc>
#include <tlm>
#include <tlm_utils/simple_target_socket.h>


class memory :
	public sc_core::sc_module
{
	public:
		memory(sc_core::sc_module_name);
		//tlm_utils::simple_target_socket<memory> cpu_tsoc; // ovo ne sme dirketno

		tlm_utils::simple_target_socket<memory> MEM_ic_tsoc;
		tlm_utils::simple_target_socket<memory> MEM_conv_tsoc;

		//tlm_utils::simple_target_socket<memory> MEM_conv_ic_tsoc;

	protected:

        SCkernel2D kernel;
		SCimg2D inputImage;
		convOut2D convOutput;
		typedef tlm::tlm_base_protocol_types::tlm_payload_type pl_t; 
		void b_transport (pl_t&, sc_core::sc_time&);
		unsigned int transport_dbg(pl_t&);
    	void msg(const pl_t&);
			
};


#endif //MEMORY_HPP_INCLUDED
