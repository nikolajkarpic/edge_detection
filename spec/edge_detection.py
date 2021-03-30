import cv2
import numpy as np
import math
import sys

print("begin")


def rgb2gray(rgb):  # Function takes in an image, then it makes a grayscale version of it.
    for x in range(rgb.shape[0]):# function iterates through each pixel 
        for y in range(rgb.shape[1]):
            for i in range(3): # this loop iterates thgough each chanel of a pixel [RED GREEN BLUE]
                rgb[x][y][i] = (0.2989 * rgb[x][y][0] + 0.5870 * rgb[x][y][1] + 0.1140 * rgb[x][y][2]) #graycale formula
    return rgb #function returns a grayscale image



def convolution(image, kernel, string): # the function takes in three arguments. Where image is an image with which the convolution is being done, kernel is a matrix, and string is a string. 
    image_h = image.shape[0]  # this method gets height of an image
    image_w = image.shape[1]  # this method gets witdh of an image

    kernel_h = kernel.shape[0]  # this method gets height of a kernel matrix
    kernel_w = kernel.shape[1]  # this method gets width of a kernel matrix
    image_conv = 0
    if string == "blur":  #depending on the string argument we chose wether the image_conv becomes the same as image or array of zeros
        image_conv = image
    if string == "edge":
        image_conv = np.zeros(image.shape) # image_conv becomes a matrix of zeros whose dimensions are the same as image
    for im_x in range(image_h - kernel_h + 1): # firts two loops iterate thoguh image pixel by pixel.
        for im_y in range(image_w - kernel_w + 1):
            sum = .0
            for ker_x in range(kernel_h):  # these two loops iterate thoguh matrix
                for ker_y in range(kernel_w):
                    sum = sum + kernel[ker_x][ker_y] * image[im_x + ker_x][im_y + ker_y][0] # convolution formula
            for i in range(3):  # this loop iterates thoguh each chanel of a pixel [RED GREEN BLUE]
                image_conv[im_x][im_y][i] = sum   
    return image_conv # returns an matrix of arrays [ RED GREEN BLUE ]



def LoG(kernel_x, kernel_y, sigma): # fucntion takes in X and Y dimesions of a desired matrix, while sigma is a parameter for the formula of Laplacian
    kernel = np.ones([kernel_x, kernel_y]) # this makes an initial matrix of desired dimesions filled with ones
    for x in range(kernel_x): #these loops iterate through the matrix
        for y in range(kernel_y):
            kernel[x][y] = -(1/(sigma**4))*(x**2 + y**2 - 2*sigma**2) * (math.e)**(-(x**2+y**2)/(2*sigma**2))  # Laplacian formula, it takes the second derivative of the image
    return kernel


def gaus(kernel_x, kernel_y, sigma): # fucntion takes in X and Y dimesions of a desired matrix, while sigma is a parameter for the formula of Gassuian
    kernel = np.ones([kernel_x, kernel_y]) # this makes an initial matrix of desired dimesions filled with ones
    for x in range(kernel_x): #these loops iterate through the matrix
        for y in range(kernel_y):
            kernel[x][y] = (1/((2*math.pi*sigma)**(1/2))) * math.e**((-x**2)/2*sigma**2) #gaussian formula
    return kernel


def z_c_test(l_o_g_image, string):  # the function takes in an image and a string, the string is used to determine wether the output will be an image or a matrix of bits
    z_c_image = np.zeros(l_o_g_image.shape) # this makes a matrix of zeros with dimensions of the given image
    range_temp = [-1, 0, 1] 
    # Check the sign (negative or positive) of all the pixels around each pixel
    for i in range(1, l_o_g_image.shape[0]-1): # iterates thoguh image
        for j in range(1, l_o_g_image.shape[1]-1):
            neg_count = 0
            pos_count = 0
            for a in range_temp:
                for b in range_temp:
                    if(a != 0 and b != 0):
                        if(l_o_g_image[i+a, j+b][0] < 0):
                            neg_count += 1
                        elif(l_o_g_image[i+a, j+b][0] > 0):
                            pos_count += 1

            # If all the signs around the pixel are the same and they're not all zero, then it's not a zero crossing and not an edge.
            # Otherwise, copy it to the edge map.
            z_c = ((neg_count > 0) and (pos_count > 0))
            if(z_c):
                if (string == "bit"): # this makes a bit matrix of the edge map
                    z_c_image[i, j] = 1
                if (string == "image"):# this makes the image of edges, where pixels take the value of 255(BLACK) in each chanel [RED GREEN BLUE]
                    for k in range(3): #iterates thgouh each chanel
                        z_c_image[i, j][k] = 255

    return z_c_image

def run():
    if len(sys.argv) != 3:
        print("Script wasn't run properly. \n The script takes two argumets, the path to the image and path to the output image with name.\n Example : py .\edge_detection.py C:\FTN\8_osmi_semestar\g3-2021\data\Lenna.png C:\FTN\8_osmi_semestar\g3-2021\data\Lenna_edge.bmp")
        exit()
    else:
        in_path =  sys.argv[1]
        out_path = sys.argv[2]


    im = cv2.imread(in_path)
    print ("Image loaded")
    #cv2.imshow('rgb', im)  # shows the image in a window
    lap_ker = LoG(10, 10, 2.7)  # makes Laplacian matrix
    gaus_ker = gaus(10, 10, 2.7)  # makes Gaussian matrix
    print ("Matrices done")
    gray = rgb2gray(im)  # Grayscales the image
    print ("Grayscale done")
    #cv2.imshow('grayscale', gray)  # shows the image in a window
    blur_im = convolution(gray, gaus_ker, 'blur') #convolution of grayscale image and Gaussian kernel to get blured image
    print ("Blur done")
    #cv2.imshow('blur', blur_im) #shows the image in a window
    log_edge = convolution(gray, lap_ker, 'edge') # Convolution of grayscale image and the Laplacian kernel to get the second derivative
    print ("Convolution with Laplacian matrix done")
    edge = z_c_test(log_edge, "image") #Does zero crossing check 
    print ("Zero crossing chech done")
    #cv2.imshow('edge', edge)  # shows the image in a window

    #print("Press 0 to end script")
    #cv2.waitKey(0)    # Waits for 0 or for all the windows to be closed
    #cv2.destroyAllWindows  # Destroys all image windows
    cv2.imwrite(out_path, edge)
    print("Saved image to the folder")

run()

print ("end")
