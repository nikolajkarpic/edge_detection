#include <iostream>
#include <fstream>

#define BRAM_SIZE 160000
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

int *loadData(string path)
{

    ifstream inFile;
    int i = 0;
    int x;
    inFile.open(path);
    int bram_img[BRAM_SIZE];
    while (inFile >> x)
    {
        bram_img[i] = x;
        i++
    }
    return bram_img;
}

void writeBramImg(const int *bramArray)
{
    FILE *bramim;
    for (int i = 0; i < BRAM_SIZE; ++i)
    {
        bramImg = fopen("/dev/bram_img", "w");
        fprintf(bramImg, "(%d,%d)\n", i, *(bramArray + i));
        fclose(bramImg);
    }
}