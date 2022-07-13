import cv2
import numpy as np
import math
import sys
if len(sys.argv) == 1 or sys.argv[1].lower == "help":
    print("The script takes two argumet, path to vhdl sim output and where to save img.\nExample py .\chechDeviation C:\FTN\8_osmi_semestar\g3-2021\data\output.txt C:\FTN\8_osmi_semestar\g3-2021\data\edge.png")
    exit()
if len(sys.argv) != 3:
    print("The script takes two argumet, path to vhdl sim output and where to save img.\nExample py .\chechDeviation C:\FTN\8_osmi_semestar\g3-2021\data\output.txt C:\FTN\8_osmi_semestar\g3-2021\data\edge.png")
    exit()


def zeroCrossingTest(image):
    # print(image)
    returnImg = np.zeros((91, 91, 3), np.uint8)
    list2D = []
    range_temp = [-1, 0, 1]
    for y in range(1, len(image) - 1):
        list1D = []
        for x in range(1, len(image[0]) - 1):
            pixel = []
            negCount = 0
            posCount = 0
            for a in range_temp:
                for b in range_temp:
                    if(a != 0 and b != 0):
                        # print(image[y + a][x + b])
                        if(image[y + a][x + b] < 0):
                            negCount += 1
                        elif(image[y + a][x + b] > 0):
                            posCount += 1
            zc = (negCount > 0) and (posCount > 0)
            if (zc):
                returnImg[y][x][0] = 0
                returnImg[y][x][1] = 0
                returnImg[y][x][2] = 0
                pixel.append(0)
                pixel.append(0)
                pixel.append(0)
            else:
                returnImg[y][x][0] = 255
                returnImg[y][x][1] = 255
                returnImg[y][x][2] = 255
                pixel.append(255)
                pixel.append(255)
                pixel.append(255)
            list1D.append(pixel)
        list2D.append(list1D)
    cv2.imshow("img", returnImg)
    cv2.waitKey(0)
    cv2.destroyAllWindows
    return returnImg


inPath = sys.argv[1]
outPath = sys.argv[2]

cols = 100


blank_image = np.zeros((92, 92), np.uint8)
list2D = []
list1D = []
with open(inPath, "r") as text_file:
    if(not text_file.readable()):
        print("File not readable.\n")
    rows = text_file.readlines()
    counter = 0
    y = 0
    for x in rows:
        # print(x)
        if(x[:-1] == '00'):
            # print(0)
            list1D.append(0)
            blank_image[counter][y] = 0
        if(x[:-1] == '10'):
            # print(-1)
            list1D.append(-1)
            blank_image[counter][y] = -1
        if(x[:-1] == '01'):
            # print(1)
            list1D.append(1)
            blank_image[counter][y] = 1

        y += 1
        if(y == 91):
            list2D.append(list1D)
            list1D = []
            y = 0
            counter += 1


# print(list2D)
img = zeroCrossingTest(list2D)
# imgToSave = np.zeros((100, 100, 3), np.uint8)
# for y in range(1, len(img) - 1):
#     for x in range(1, len(img[0]) - 1):
#         imgToSave[y][x][0] = img[y][x][0]
#         imgToSave[y][x][1] = img[y][x][0]
#         imgToSave[y][x][2] = img[y][x][0]
cv2.imwrite(outPath, img)
