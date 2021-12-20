#include "vp.hpp"

int sc_main(int argc, char *argv[])
{

    if (argc != 3)
    {
        cout << "VP takes two arguments, path with name to .txt file from which it reads img, and path with name to the file where to save output." << endl;
        cout << "Example ./output /home/user/project/vp/inputFile.txt /home/user/project/vp/outputFile.txt " << endl;
        return 0;
    }
    vp uut("VirPlat");
    uut.soft.setPathIn(argv[1]);
    uut.soft.setPathOut(argv[2]);
    sc_start(2, sc_core::SC_SEC);


    return 0;
}