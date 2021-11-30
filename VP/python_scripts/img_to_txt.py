from os import lseek
import numpy as np
import cv2
import sys

if len(sys.argv) == 1 and sys.argv[1].lower == "help":
    print("Script takes two argument. Path to the image to convert to .txt and path where to save .txt file\nExample py .\img_to_txt.py C:\FTN\8_osmi_semestar\g3-2021\data\input1.png C:\FTN\8_osmi_semestar\g3-2021\data\VPinput.txt \n")
    exit()

if len(sys.argv) != 3:
        print("Script wasn't run properly. \nScript takes two argument. Path to the image to convert to .txt and path where to save .txt file\nExample py .\img_to_txt.py C:\FTN\8_osmi_semestar\g3-2021\data\input1.png C:\FTN\8_osmi_semestar\g3-2021\data\VPinput.txt \n")
        exit()


im = cv2.imread(str(sys.argv[1]))
im = cv2.copyMakeBorder(im,  5, 5, 5, 5, cv2.BORDER_REPLICATE)
im = cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)

cols = im.shape[0]
rows = im.shape[1]

with open("demo.txt" , "w") as text_file:

    print(str(cols) + "\n" + str(rows), file=  text_file)
    for x in im:


        for pixel in x:
            print(pixel, file = text_file, end = ' ')
    
    print("\n", file = text_file, end = '')