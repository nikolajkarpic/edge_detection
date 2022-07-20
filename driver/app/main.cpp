#include <iostream>
#include <fstream>
#include <string>
#include <vector>

#define BRAM_SIZE 160000
#define IMG_SIZE 400
typedef std::vector<int> bram;
typedef std::vector<int> matrix1D;
typedef std::vector<matrix1D> matrix2D;

matrix2D readBramRes();
void writeBramImg(bram);
bram loadData(std::string path);
void startIp();

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        std::cout << "Program wasn't called properly.\n To run it path to the target image must be passed as an argument.\n Example: ./output /home/user/g3-2021/data/Lenna.png" << std::endl;
        return 0;
    }
    std::string path = argv[1];
    bram loadedData;
    matrix2D convolvedData;
    int choice;

    do
    {
        std::cout << "Main Menu\n";
        std::cout << "Please make your selection\n";
        std::cout << "1 - Load data to an array\n";
        std::cout << "2 - Write img to bram\n";
        std::cout << "3 - Start IP\n";
        std::cout << "4 - Read bram res\n";
        std::cout << "5 - Zero crossing\n";
        std::cout << "6 - Exit\n";
        std::cout << "Selection: ";
        std::cin >> choice;

        switch (choice)
        {
        case 1:
            loadedData = loadData(path);
            break;
        case 2:
            writeBramImg(loadedData);
            break;
        case 3:
            startIp();
            break;
        case 4:
            convolvedData = readBramRes();
            break;
        case 6:
            std::cout << "Goodbye!";
            return 0;
            break;
        default:
            std::cout << "Main Menu\n";
            std::cout << "Please make your selection\n";
            std::cout << "1 - Load data to an array\n";
            std::cout << "2 - Write img to bram\n";
            std::cout << "3 - Start IP\n";
            std::cout << "4 - Read bram res\n";
            std::cout << "5 - Zero crossing\n";
            std::cout << "6 - Exit\n";
            std::cout << "Selection: ";
            std::cin >> choice;
        }
    } while (choice != 6);

    return 0;
}

bram loadData(std::string path)
{
    bram loadedData;
    std::ifstream inFile;
    int i = 0;
    int x;
    inFile.open(path);
    while (inFile >> x)
    {
        std::cout << x << std::endl;
        loadedData.push_back(x);
    }
    inFile.close();
    return loadedData;
}

void writeBramImg(bram bramImgArray)
{
    FILE *bramImg;
    for (int i = 0; i < BRAM_SIZE; ++i)
    {
        bramImg = fopen("/dev/bram_img", "w");
        fprintf(bramImg, "(%d,%d)\n", i, bramImgArray[i]);
        fclose(bramImg);
    }
}

void startIp()
{
    FILE *ip;
    ip = fopen("/dev/ip", "w");

    fprintf(ip, "1");

    fclose(ip);
}

matrix2D readBramRes()
{
    FILE *bramRes;
    bramRes = fopen("/dev/bram_res", "r");
    int n;
    matrix1D tempRow;
    matrix2D returnRow;
    for (int i = 0; i < IMG_SIZE; ++i)
    {
        returnRow.push_back(tempRow);
        for (int j = 0; j < IMG_SIZE; ++j)
        {
            fscanf(bramRes, "%d", &n);
            tempRow.push_back(n);
        }
    }
    fclose(bramRes);

    return returnRow;
}
