#ifndef CPU_HPP_INCLUDED
#define CPU_HPP_INCLUDED

#include "common.hpp"
#include <tlm_utils/simple_initiator_socket.h>

class cpu : public sc_core::sc_module
{
    public:

        cpu(sc_core::sc_module_name);

    protected:
        int rows;
        int col;

        SCimg2D image;
        // same size of height and widht them:
        // int imgSize;
        void process();

        void scanFromFileImSize(int *rows,int *cols);
        void scanFromFileImage (*image);

        void writeImageToFile();

};


#endif // SCPU_HPP_INCLUDED