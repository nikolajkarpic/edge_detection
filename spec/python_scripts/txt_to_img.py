import cv2
import numpy
import math
from PIL import Image
#from matplotlib import pyplot


with open("outFile.txt", "r") as text_file:

    rows = text_file.readlines() 
    cols = iksevi[1].split(' ')
    print('rows : ',len(rows))
    print('cols : ',len(cols))
    imgArray = numpy.empty([len(rows),len(cols)], dtype=numpy.int16)
    counter = 0
    for x in rows:
        nums = x.split(' ')
        #counter = 0
        y = 0
        for num in nums:
            #if (counter % 3 == 0):
            #counter = 0
            if (num != '\n'):
                # if (broj == 255):
                #     broj = 0
                # else:
                #     broj = 255
                imgArray[counter][y] = int(num)
                y+=1
            #counter+=1
        counter+=1

    img = Image.fromarray(imgArray)
    img.show()