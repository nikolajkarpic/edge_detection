#ifndef CPU_HPP_INCLUDED
#define CPU_HPP_INCLUDED

#include "common.hpp"
#include "convolution.hpp"
#include <tlm_utils/simple_initiator_socket.h>
#include <tlm_utils/simple_target_socket.h>

class cpu : public sc_core::sc_module
{
    public:

        cpu(sc_core::sc_module_name);

        tlm_utils::simple_initiator_socket<cpu> int_isoc;
        tlm_utils::simple_initiator_socket<cpu> mem_isoc;
        tlm_utils::simple_target_socket<conv> conv_tsoc;
        
    protected:
        int rows;
        int cols;

        matrix2D inputArray;
        SCkernel2D kernel;
        
        // same size of height and widht them:
        // int imgSize;
        void process();

        void scanFromFile();
        //void scanFromFileImage (SCimg2D *image);
        void createKernel();
        void writeImageToFile();

};


#endif // CPU_HPP_INCLUDED