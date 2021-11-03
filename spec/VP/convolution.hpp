#ifndef CONVOLUTION_HPP_INCLUDED
#define CONVOLUTION_HPP_INCLUDED

#include "common.hpp"
#include "vp_address.hpp"
#include <tlm>
#include <tlm_utils/simple_target_socket.h>

using namespace sc_core;
using namespace sc_dt;
using namespace std;
using namespace tlm;

class conv : 
	public sc_core::sc_module
{
public:

	conv(sc_core::sc_module_name);

	//tlm_utils::simple_target_socket<conv> ic_tsoc;
	//tlm_utils::simple_initiator_socket<conv> conv_isoc;		

protected:
	
	typedef tlm::tlm_base_protocol_types::tlm_payload_type pl_t;
	void b_transport(pl_t&, sc_core::sc_time&);

	void convolution();


};


#endif  //CONVOLUTION_HPP_INCLUDED