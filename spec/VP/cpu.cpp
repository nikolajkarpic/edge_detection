#include "cpu.hpp"

using namespace sc_core;
using namespace sc_dt;
using namespace std;
SC_HAS_PROCESS(cpu);
cpu::cpu(sc_module_name name):
	sc_module(name)
{
	int h = 0;
    //SC_THREAD(proces); // Is it thread tho?
}

void cpu::scanFromFileImSize(int *rows,int *cols){
    ifstream infile;

    FILE *fp;
    char c = 0;
    fp = fopen("/home/donnico/edge_detection/data/input2.png", "r");
    int i = 0;
    int j = 0;
    
    char* tempString = "";

    while((c = fgetc(fp) != '\n' &&  j == 2))
        if (c = '\n'){
            j++;
        }
        if (i == 0){
            *cols = c;
        }
        if (i == 2){
            *rows = c;
        }
        i++;    
}