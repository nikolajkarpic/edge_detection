import cv2
import numpy as np
import math

im = cv2.imread("Lenna_(test_image).png")

blur_kernel = np.array([[ 1/273,  4/273,  7/273,  4/273,  1/273],
                        [ 4/273,  16/273,  26/273, 16/273,  4/273],
                        [ 7/273,  26/273,  41/273,  26/273, 7/273],
                        [ 4/273,  16/273,  26/273, 16/273,  4/273],
                        [ 1/273,  4/273,  7/273,  4/273,  1/273]])
blur_kernel_small = np.array([[ 1/16,  2/16,  1/16],
                            [ 2/16,  4/16,  2/16],
                            [ 1/16,  2/16,  1/16]])

laplacian_kernel_diag = np.array([[-1, -1, -1,],[-1, 8, -1],[-1, -1, -1]])
laplacian_kernel = np.array([[0, -1, 0],[-1, 8, -1],[0, -1, 0]])
laplacian_kernel_big = np.array([[0, 1,1,2,2,2,1,1,0],[1,2,4,5,5,5,4,2,1],[1,4,5,3,0,3,5,4,1],[2,5,3,-12,-24,-12,3,5,2],[2,5,0,-24,-40,-24,0,5,2],[2,5,3,-12,-24,-12,3,5,2],[1,4,5,3,0,3,5,4,1],[1,2,4,5,5,5,4,2,1],[0, 1,1,2,2,2,1,1,0]])


def rgb2gray(rgb):
    for x in range(len(rgb)):
        for y in range(len(rgb)):
            rgb[x][y] = (0.2989*rgb[x][y][0] + 0.5870*rgb[x][y][1] + 0.1140*rgb[x][y][2])#formula za rgb to gray
    return rgb


def convolution(image, kernel):
    image_h = image.shape[0]
    image_w = image.shape[1]
    
    kernel_h = kernel.shape[0]
    kernel_w = kernel.shape[1]
    #if string == "blur":
    #image_conv = image
    #if string == "edge":
    image_conv = np.zeros(image.shape)
    for im_x in range(image_h - kernel_h + 1):
        for im_y in range(image_w - kernel_w + 1):
            sum = 0
            for ker_x in range(kernel_h):
                for ker_y in range(kernel_w):
                    sum = sum + kernel[ker_x][ker_y] * image[im_x + ker_x][im_y + ker_y][0]
            for i in range(3):
                image_conv[im_x][im_y][i] = 0
                image_conv[im_x][im_y][i] = sum
    return image_conv


def LoG(kernel_x,kernel_y,sigma):
    kernel = np.ones([kernel_x,kernel_y])
    for x in range(kernel_x):
        for y in range(kernel_y):
            kernel[x][y] = -(1/(sigma**4))*(x**2 + y**2 - 2*sigma**2)*(math.e)**(-(x**2+y**2)/(2*sigma**2))
    return kernel
##Ispisi gausian filter kao LoG da moze bilo koja matrica da se dobije

lap_ker = LoG(10,10,3.5)
# #print(lap_ker)
cv2.imshow('rgb', im)
gray = rgb2gray(im)
cv2.imshow('grayscale', gray)
blur_im = convolution(gray, blur_kernel_small)
#print(blur_im)
#blur_im = rgb2gray(blur_im)
cv2.imshow('blur',blur_im)
# #edge = cv2.Laplacian(gray, -1)
edge = convolution(gray, lap_ker)
# #edge = rgb2gray(edge)
cv2.imshow('edge', edge)
cv2.waitKey(0)
cv2.destroyAllWindows

