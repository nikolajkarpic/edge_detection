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
matrix2D zeroCrossingTest(matrix2D source);
void writeImageToFile(std::string outpath, matrix2D outputArray);
bool readIpDoneReg();

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        std::cout << "Program wasn't called properly.\n To run it path to the target image must be passed as an argument.\n Example: ./output /home/user/g3-2021/data/Lenna.png" << std::endl;
        return 0;
    }
    std::string path = argv[1];
    std::string outpath = argv[2];
    bram loadedData;
    matrix2D convolvedData;
    matrix2D zcDone;
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
        std::cout << "6 - Save data\n";
        std::cout << "7 - Exit\n";
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
            if (readIpDoneReg())
            {

                convolvedData = readBramRes();
                break;
            }
            else
            {
                std::cout << "Ip isnt done yet" << std::endl;
                break;
            }
        case 5:
            zcDone = zeroCrossingTest(convolvedData);
            break;
        case 6:
            writeImageToFile(outpath, zcDone);
            break;
        case 7:
            std::cout << "Goodbye!" << std::endl;
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
            std::cout << "6 - Save data\n";
            std::cout << "7 - Exit\n";
            std::cout << "Selection: ";
            std::cin >> choice;
        }
    } while (choice != 7);

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

bool readIpDoneReg()
{
    FILE *ip;
    int n;
    ip = fopen("/dev/ip", "r");
    fscanf(ip, "%d", &n);
    fclose(ip);
    bool result;
    return result = (n == 1) ? true : false;
}

matrix2D readBramRes()
{
    char endstr[400];
    FILE *bramRes;
    int n;
    matrix1D tempRow;
    matrix2D returnRow;
    for (int i = 0; i < IMG_SIZE; ++i)
    {
        returnRow.push_back(tempRow);
        for (int j = 0; j < IMG_SIZE; ++j)
        {
            bramRes = fopen("/dev/bram_res", "w");
            fprintf(bramRes, "%ld\n", i * IMG_SIZE + j);
            fclose(bramRes);
            bramRes = fopen("/dev/bram_res", "r");
            fscanf(bramRes, "%d", &n);
            std::cout << "address: " << i * IMG_SIZE + j << std::endl;
            std::cout << n << std::endl;
            tempRow.push_back(n);
            fclose(bramRes);
        }
    }
    // fgets(endstr, 400, bramRes); // needed to simulate cat
    // fgets(endstr, 400, bramRes); // needed to simulate cat

    for (int u = 0; u < returnRow.size(); u++)
    {
        for (int f = 0; f < returnRow[0].size(); f++)
        {
            std::cout << returnRow[u][f] << " ";
        }
        std::cout << std::endl;
    }

    return returnRow;
}

matrix2D zeroCrossingTest(matrix2D source)
{
    matrix2D imageResult;
    matrix1D tempPixelArray;
    int sourceWIDTH = source[0].size();
    int sourceHeight = source.size();

    matrix1D tempRow;
    matrix2D tempMatrix;

    int pixelValue;

    int negCouter = 0;
    int posCoutner = 0;

    for (int i = 1; i < sourceHeight - 1; i++)
    {
        imageResult.push_back(tempPixelArray);
        for (int j = 1; j < sourceWIDTH - 1; j++)
        {
            negCouter = 0;
            posCoutner = 0;
            for (int k = -1; k < 2; k++)
            {
                for (int l = -1; l < 2; l++)
                {
                    if (k != 0 && l != 0)
                    {
                        std::cout << "at address:" << (i + k) * sourceWIDTH + j + l << std::endl;
                        std::cout << source[i + k][j + l] << std::endl;
                        if (source[i + k][j + l] < 0)
                        {
                            negCouter++;
                        }
                        else if (source[i + k][j + l] > 0)
                        {
                            posCoutner++;
                        }
                    }
                }
            }
            pixelValue = 255;

            if (negCouter > 0 && posCoutner > 0)
            {
                pixelValue = 0;
            }
            imageResult[i - 1].push_back(pixelValue);
        }
    }

    for (int u = 0; u < imageResult.size(); u++)
    {
        for (int f = 0; f < imageResult[0].size(); f++)
        {
            std::cout << imageResult[u][f] << " ";
        }
        std::cout << std::endl;
    }

    return imageResult;
}

void writeImageToFile(std::string outpath, matrix2D outputArray)
{
    std::ofstream outFile;
    outFile.open(outpath);
    for (int l = 0; l < outputArray.size(); l++)
    {
        for (int k = 0; k < outputArray[0].size(); k++)
        {
            outFile << outputArray[l][k] << " ";
        }
        outFile << std::endl;
    }

    outFile.close();
}