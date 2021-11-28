import cv2
import numpy
import math


with open("outFile.txt", "r") as text_file:

    rows = text_file.readlines() 
    cols = rows[1].split(' ')
    print('rows : ',len(rows))
    print('cols : ',len(cols) - 1)
    blank_image = numpy.zeros((len(rows),len(cols) - 1,3), numpy.uint8)
    counter = 0
    for x in rows:
        nums = x.split(' ')
        nums.pop()
        y = 0
        for num in nums:
            if (num != '\n'):
                blank_image[counter][y][0] = int(num)
                blank_image[counter][y][1] = int(num)
                blank_image[counter][y][2] = int(num)

                y+=1
        counter+=1

    cv2.imshow("img",blank_image )
    cv2.waitKey(0) 
    cv2.destroyAllWindows
    cv2.imwrite("./outputImage.png", blank_image)