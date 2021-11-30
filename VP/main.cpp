#include"vp.hpp"


int sc_main(int argc, char* argv[]) { 

    vp uut("VirPlat");
    uut.soft.setPathIn(argv[1]);
    uut.soft.setPathOut(argv[2]);
    sc_start(2, sc_core::SC_SEC);

    return 0;
}