#ifndef CPU_HPP_INCLUDED
#define CPU_HPP_INCLUDED

#include "common.hpp"
#include "vp_address.hpp"
#include "convolution.hpp"
#include <tlm_utils/simple_initiator_socket.h>
#include <tlm_utils/simple_target_socket.h>
#include <tlm_utils/tlm_quantumkeeper.h>

class cpu : public sc_core::sc_module
{
public:
    cpu(sc_core::sc_module_name);

    tlm_utils::simple_initiator_socket<cpu> CPU_ic_mem_isoc;  //inicjator za ic salje slike i kernel u memoriju
    tlm_utils::simple_initiator_socket<cpu> CPU_ic_conv_isoc; //initiator socket for conv comunication
    tlm_utils::simple_target_socket<cpu> CPU_conv_ic_tsoc;    // prima od IC iz konvolucije rezultat konvolucije

protected:
    int rows;
    int cols;

    convOut2D convOut;
    SCimg2D inputArray;
    matrix2D outputArray;

    SCkernel2D kernel;

    //Kernel generation:
    float calculateLoGValue(int x, int y);
    float roundLoGValue(float x);
    void createKernelLoGDescrete();

    //Zerp crosnig test:
    void zeroCrossingTest();

    void CPU_process();
    void scanFromFile(); // loads image from a text file into inputArray, and loads cols and rows.
    void writeImageToFile();
    typedef tlm::tlm_base_protocol_types::tlm_payload_type pl_t;
    void b_transport(pl_t &, sc_core::sc_time &);

    void writeReadyToConv();
};

#endif // CPU_HPP_INCLUDED
