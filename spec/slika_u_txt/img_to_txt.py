import numpy as np
from cv2 import cv2



im = cv2.imread("C:\FTN\8_osmi_semestar\Edge_detection\Edge_detection_cpp\data\Lenna.png")
fl = open('demo.txt', 'w')
shape = im.shape
print(shape)
(rows, cols, temp) = im.shape
red = 0
green = 0
blue = 0
f = []
for i in range(rows):
    for j in range(cols): 
        k = im[i, j]
        [red, green, blue] = k
        f.append(red)
        f.append(green)
        f.append(blue)
print(f, file = fl)        
fl.close()        

