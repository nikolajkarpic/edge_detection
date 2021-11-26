#ifndef INTERCONNECT_HPP_INCLUDED
#define INTERCONNECT_HPP_INCLUDED

#include "common.hpp"
#include "vp_address.hpp"
#include <tlm>
#include <tlm_utils/simple_target_socket.h>

class interconnect : public sc_core::sc_module
{
public:
        interconnect(sc_core::sc_module_name);

        tlm_utils::simple_target_socket<interconnect> IC_cpu_tsoc;      //prima od cpu slike i kernel i prosledjuje u memoriuju
        tlm_utils::simple_initiator_socket<interconnect> IC_cpu_isoc;   // inicijator za cpu salje kada primi iz konv rezultat
        tlm_utils::simple_target_socket<interconnect> IC_cpu_conv_tsoc; //from cpu to conv

        tlm_utils::simple_target_socket<interconnect> IC_conv_tsoc;    // primi od konvolucije rezultat
        tlm_utils::simple_initiator_socket<interconnect> IC_conv_isoc; // od memorije salje sliku i krenl
        tlm_utils::simple_initiator_socket<interconnect> IC_mem_isoc;  //cpu salje u memoriju sliku i kernel

protected:
        sc_core::sc_time offset;
        typedef tlm::tlm_base_protocol_types::tlm_payload_type pl_t;
        void b_transport(pl_t &, sc_core::sc_time &);
};

#endif //INTERCONNECT_HPP_INCLUDED
