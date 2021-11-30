import cv2
import numpy
import math
import sys

if len(sys.argv) == 1 and sys.argv[1].lower == "help":
    print("Script takes two arguments, path to the .txt file and path where to save the image.\nExample py txt_to_img.py /home/user/project/VP/VPoutput.txt /home/user/project/data/VPedge.png\n")
    exit()
if len(sys.argv) != 3:
    print("Script wasn't run properly. \n Script takes two arguments, path to the .txt file and path where to save the image.\nExample py txt_to_img.py /home/user/project/VP/VPoutput.txt /home/user/project/data/VPedge.png\n")
    exit()

path = sys.argv[1]
pathOut = sys.argv[2]

with open(path, "r") as text_file:
    if(not text_file.readable()):
        print("File not readable.\n")
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
    cv2.imwrite(pathOut, blank_image)