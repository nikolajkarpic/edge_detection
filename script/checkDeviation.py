import cv2
import numpy as np
import math
import sys
if len(sys.argv) == 1 or sys.argv[1].lower == "help":
        print("The script takes two argumet, paths to the images.\nExample py .\chechDeviation C:\FTN\8_osmi_semestar\g3-2021\data\input1.png C:\FTN\8_osmi_semestar\g3-2021\data\edge.png")
        exit();
if len(sys.argv) != 3:
        print("Script wasn't run properly. \n The script takes two argumet, paths to the images.\nExample py .\chechDeviation C:\FTN\8_osmi_semestar\g3-2021\data\input1.png C:\FTN\8_osmi_semestar\g3-2021\data\edge.png")
        exit()

img1Path =  sys.argv[1]
img2Path =  sys.argv[2]

imLoad1 = cv2.imread(img1Path)
imLoad2 = cv2.imread(img2Path)

imsize = imLoad2.shape[0]*imLoad2.shape[1]
faultcounter = 0
counter = 0
for i in range(imLoad1.shape[0]):
        for j in range(imLoad1.shape[1]):
            if(imLoad1[i][j][0] != imLoad2[i][j][0]):
                counter = counter + 1

faultcounter = (counter/ imsize)*100.0

print("Deviaton: " + str(faultcounter))

