#ifndef CPU_HPP_INCLUDED
#define CPU_HPP_INCLUDED

#include "common.hpp"
#include "vp_address.hpp"
#include <tlm_utils/simple_initiator_socket.h>
#include <tlm_utils/simple_target_socket.h>
#include <tlm_utils/tlm_quantumkeeper.h>

class cpu : public sc_core::sc_module
{
    public:

        cpu(sc_core::sc_module_name);

        //tlm_utils::simple_initiator_socket<cpu> ic_isoc; //initiator socket for interconnect
        tlm_utils::simple_initiator_socket<cpu> mem_isoc;//initiator socket for memory
        //tlm_utils::simple_target_socket<conv> conv_tsoc; // target socket for convolution
        
    protected:
        int rows;
        int cols;

        matrix2D convOut;
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

};


#endif // CPU_HPP_INCLUDED
