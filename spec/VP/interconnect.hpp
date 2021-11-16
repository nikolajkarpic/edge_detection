#ifndef INTERCONNECT_HPP_INCLUDED
#define INTERCONNECT_HPP_INCLUDED

#include "common.hpp"
#include "vp_address.hpp"
#include <tlm>
#include <tlm_utils/simple_target_socket.h>

using namespace sc_core;
using namespace sc_dt;
using namespace std;
using namespace tlm;

class interconnect:
        public sc_core::sc_module
{
public:

        interconnect(sc_core::sc_module_name);

        tlm_utils::simple_target_socket<interconnect> cpu_tsoc;
        tlm_utils::simple_initiator_socket<interconnect> conv_isoc;     
	tlm_utils::simple_initiator_socket<interconnect> mem_isoc; 

protected:

        typedef tlm::tlm_base_protocol_types::tlm_payload_type pl_t;
        void b_transport(pl_t&, sc_core::sc_time&);


};


#endif  //INTERCONNECT_HPP_INCLUDED
~                                      
