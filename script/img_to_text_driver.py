from os import lseek
from cv2 import COLOR_BGR2GRAY
import numpy as np
import cv2
import sys

if (len(sys.argv) == 1 or sys.argv[1].lower == "help"):
    print("Script takes two argument. Path to the image to convert to .txt and path where to save .txt file\nExample py .\img_to_txt.py C:\FTN\8_osmi_semestar\g3-2021\data\input1.png C:\FTN\8_osmi_semestar\g3-2021\data\VPinput.txt \n")
    exit()

if len(sys.argv) != 3:
    print("Script wasn't run properly. \nScript takes two argument. Path to the image to convert to .txt and path where to save .txt file\nExample py .\img_to_txt.py C:\FTN\8_osmi_semestar\g3-2021\data\input1.png C:\FTN\8_osmi_semestar\g3-2021\data\VPinput.txt \n")
    exit()

pathIn = str(sys.argv[1])
pathOut = str(sys.argv[2])

im = cv2.imread(str(sys.argv[1]))

im = cv2.cvtColor(im, COLOR_BGR2GRAY)


im = im[0:400, 0:400]
print(im.shape[0])
print(im.shape[1])
cv2.imshow("img", im)
cv2.waitKey(0)
cv2.destroyAllWindows
cols = im.shape[0]
rows = im.shape[1]


with open(pathOut, "w") as text_file:
    for x in im:

        for pixel in x:
            print(pixel, file=text_file, end='\n')
