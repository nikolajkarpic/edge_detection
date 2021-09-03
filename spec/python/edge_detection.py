import cv2
import numpy as np
import math
import sys

print("begin")


def rgb2gray(rgb):  # Function takes in an image, then it makes a grayscale version of it.
    for x in range(len(rgb)):# function iterates through each pixel 
        for y in range(len(rgb[0])):
            pixelVal = 0.2989 * rgb[x][y][0] + 0.5870 * rgb[x][y][1] + 0.1140 * rgb[x][y][2]
            rgb[x][y][0] = pixelVal
            rgb[x][y][1] = pixelVal
            rgb[x][y][2] = pixelVal #graycale formula
    return rgb #function returns a grayscale image

def convolution2D(image, kernel):
    list2D = []
    image_h = len(image)  # this method gets height of an image
    image_w = len(image[0])
    kernel_h = kernel.shape[0]  # this method gets height of a kernel matrix
    kernel_w = kernel.shape[1]
    convolutionValue = 0.0
    for im_y in range(image_h - kernel_h + 1):
        list1D = []
        for im_x in range(image_w - kernel_w + 1):
            pixel = []
            sum = 0.0
            for ker_y in range(kernel_h):
                for ker_x in range(kernel_w):
                    sum = sum + (kernel[ker_y][ker_x] * image[im_y + ker_y][im_x + ker_x][0])
            pixel.append(sum)
            pixel.append(sum)
            pixel.append(sum)
            list1D.append(pixel)
        list2D.append(list1D)
    return list2D



def zeroCrossingTest(image):
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
                        if(image[y + a][x + b][0] < 0):
                            negCount += 1
                        elif(image[y + a][x + b][0] > 0):
                            posCount += 1
            zc =  (negCount > 0) and (posCount > 0)
            if (zc):
                pixel.append(0)
                pixel.append(0)
                pixel.append(0)
            else:
                pixel.append(255)
                pixel.append(255)
                pixel.append(255)
            list1D.append(pixel)
        list2D.append(list1D)
    return list2D



## Calculates LoG kernel
def LoG(sigma, x, y):
    laplace = -(1 / (np.pi * sigma**4)) * (1 - (x**2+y**2) / (2*sigma**2)) * np.exp(-(x**2 + y**2) / (2*sigma**2)) #Laplacian of gaussian function for kernel 
    laplace = laplace * (-40 / (-1 / (np.pi * sigma**4) * (1 - (0**2 + 0**2) / (2*sigma**2)))) #normalizing value 
    return laplace

def LoG_discrete(sigma, n):
    kernel = np.zeros((n,n))
    for i in range(n):
        for j in range(n):
            kernel[i,j] = LoG(sigma, (i-(n-1)/2),(j-(n-1)/2)) # kernel creation
    return kernel



def compare(imPy, imC, stringCoutner):
    counter = 0
    val1 = 0
    val2 = 0
    imsize = imC.shape[0]*imC.shape[1]
    for i in range(imC.shape[0]):
        for j in range(imC.shape[1]):
            if(imPy[i][j][0] != imC[i][j][0]):
                counter = counter + 1
    faultcounter = (counter/ imsize)*100.0
    
    faultString = "Image:" + str(stringCoutner)+ "   Deviation: " +str(faultcounter)
    
    print(faultcounter)

    return faultString


def loopThrough():
    if len(sys.argv) != 2:
        print("Script wasn't run properly. \n The script takes one argumet, the path to the first input.\nExample py .\edge_detection C:\FTN\8_osmi_semestar\g3-2021\data\input1.png")
        exit()
    else:
        in_path =  sys.argv[1]
        #out_path = sys.argv[2]
    c_in_path = in_path.replace("input1.png", "input1Edge.png")
    out_path = in_path.replace("input1.png", "input1pyEdge.png")
    faultStringArray = []
    for i in range(1,7):
        stringEnd = "input" + str(i+1) +".png"
        stringEndOut = "input" + str(i+1) + "pyEdge.png"
        stringEndCppIn = "input" + str(i+1) + "Edge.png"
        print(in_path)
        print(out_path)
        print(c_in_path)
        imC = cv2.imread(c_in_path)
        
        run(in_path, out_path)
        edge = cv2.imread(out_path)
        faultString = compare(edge, imC, i)
        faultStringArray.append(faultString)
        in_path = in_path.replace("input" + str(i) +".png", stringEnd)
        out_path = out_path.replace("input" + str(i) + "pyEdge.png", stringEndOut)
        c_in_path = c_in_path.replace("input" + str(i) + "Edge.png", stringEndCppIn)
    with open('CppPythonDeviation.txt', 'w') as f:
        for item in faultStringArray:
            f.write("%s\n" % item)

def LoadImage(path):
    imLoad = cv2.imread(path)
    im = cv2.copyMakeBorder(imLoad,  5, 5, 5, 5, cv2.BORDER_REPLICATE)
    #list1D = []
    list2D = []
    #pixel= []
    for i in range(im.shape[0]):
        list1D = []
        for j in range(im.shape[1]):
            pixel = []
            pixel.append(im[i][j][0])
            pixel.append(im[i][j][1])
            pixel.append(im[i][j][2])
            pixel.append(0)
            list1D.append(pixel)
        list2D.append(list1D)
    return list2D 

def WriteImage(path, imSource):
    im = cv2.imread(path)
    for i in range(im.shape[0]):
        for j in range(im.shape[1]):
            im[i][j][0] = imSource[i][j][0]
            im[i][j][1] = imSource[i][j][1]
            im[i][j][2] = imSource[i][j][2]
    
    #cv2.imshow('im', im)
    #cv2.waitKey(0)    # Waits for 0 or for all the windows to be closed
    #cv2.destroyAllWindows  # Destroys all image windows
    return im

def run(in_path, out_path):
    im = LoadImage(in_path)
    print ("Image loaded")
    sigma = 1.4 
    lap_ker = LoG_discrete(sigma, 9)  # makes Laplacian matrix
    print ("Matrices done")
    gray = rgb2gray(im)  # Grayscales the image
    print ("Grayscale done")
    log_edge = convolution2D(gray, lap_ker) # Convolution of grayscale image and the Laplacian kernel to get the second derivative
    print ("Convolution with Laplacian matrix done")
    edge = zeroCrossingTest(log_edge) #Does zero crossing check 
    print ("Zero crossing chech done")
    imToSave = WriteImage(in_path, edge)
    cv2.imwrite(out_path, imToSave)
    print("Saved image to the folder")

loopThrough()
print ("end")
