#ifndef CONVOLUTION_HPP_INCLUDED
#define CONVOLUTION_HPP_INCLUDED

#include "common.hpp"
#include "vp_address.hpp"
#include <tlm>
#include <tlm_utils/simple_target_socket.h>
#include <tlm_utils/simple_initiator_socket.h>
#include <tlm_utils/tlm_quantumkeeper.h>

using namespace sc_core;
using namespace sc_dt;
using namespace std;
using namespace tlm;

class conv : public sc_core::sc_module
{
public:
	conv(sc_core::sc_module_name);

	tlm_utils::simple_target_socket<conv> CONV_ic_tsoc;
	tlm_utils::simple_initiator_socket<conv> CONV_ic_isoc;
	tlm_utils::simple_initiator_socket<conv> CONV_mem_isoc;

protected:
	sc_time loct;
	tlm_utils::tlm_quantumkeeper qk;
	unsigned char ready;
	int cols;
	int rows;
	int kernelSize;
	SCimg2D img; //for loading the image
	convOut2D convResult;
	SCkernel2D kernel; //for loading the kernel

	tlm_generic_payload pl; //generic payload
	sc_time conv_time;		//time

	typedef tlm::tlm_base_protocol_types::tlm_payload_type pl_t;
	void b_transport(pl_t &, sc_core::sc_time &);
	void convolution();
};

#endif //CONVOLUTION_HPP_INCLUDED
