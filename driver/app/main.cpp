#include <iostream>
#include <fstream>
#include <string.h>

#define BRAM_SIZE 160000

int bramImgArray[BRAM_SIZE];
int bramResArray[BRAM_SIZE];
int startReg = 0;
int doneReg = 0;

void writeBramImg(const int bramArray[]);

using namespace std;
int main(int argc, char *argv[])
{
    int bram_img *;
    if (argc < 2)
    {
        cout << "Program wasn't called properly.\n To run it path to the target image must be passed as an argument.\n Example: ./output /home/user/g3-2021/data/Lenna.png" << endl;
        return 0;
    }
    string path = argv[1];

    int choice;

    do
    {
        cout << "Main Menu\n";
        cout << "Please make your selection\n";
        cout << "1 - Load data to an array\n";
        cout << "2 - Write img to bram\n";
        cout << "3 - Start IP\n";
        cout << "4 - Read bram res\n";
        cout << "5 - Zero crossing\n";
        cout << "6 - Exit\n";
        cout << "Selection: ";
        cin >> choice;

        switch (choice)
        {
        case 1:
            bram_img = loadData(path);
            break;
        case 2:
            writeBramImg(bram_img *);
            break;
        case 5:
            cout << "Goodbye!";
            return 0;
            break;
        default:
            cout << "Main Menu\n";
            cout << "Please make your selection\n";
            cout << "1 - Load data to an array\n";
            cout << "2 - Write img to bram\n";
            cout << "3 - Start IP\n";
            cout << "4 - Read bram res\n";
            cout << "5 - Zero crossing\n";
            cout << "6 - Exit\n";
            cout << "Selection: ";
            cin >> choice;
        }
    } while (choice != 6);

    return 0;
}

void loadData(string path, int bramImg[])
{

    ifstream inFile;
    int i = 0;
    int x;
    inFile.open(path);
    while (inFile >> x)
    {
        &bramImg[i] = x;
        i++
    }
    inFile.close();
}

void writeBramImg(const int bramArray[])
{
    FILE *bramImg;
    bramImg = fopen("/dev/bram_img", "w");
    for (int i = 0; i < BRAM_SIZE; ++i)
    {
        fprintf(bramImg, "(%d,%d)\n", i, bramArray[i]);
    }
    fclose(bramImg);
}