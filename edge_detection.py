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


def rgb2gray(rgb): # prima sliku i radi grayscale nad njom
    for x in range(len(rgb)):
        for y in range(len(rgb)):
            for i in range(3):
                rgb[x][y][i] = (0.2989*rgb[x][y][0] + 0.5870*rgb[x][y][1] + 0.1140*rgb[x][y][2])#formula za rgb to gray gde se upisuje ista vrednost u sva tri kanala slike [red green blueS]
    return rgb


def convolution(image, kernel, string): # image je slika koja nad kojom se radi konvolucija, kernel je matrica, a string samo radi selekciju sta je izlaz
    image_h = image.shape[0] # dobija se visina slike
    image_w = image.shape[1] #dobija se sirina slike
    
    kernel_h = kernel.shape[0] #dobija se visina kernel matrice
    kernel_w = kernel.shape[1]  #dobija se sirina kernel matrice
    image_conv = 0
    if string == "blur": #ne znam zasto al ako se ovde stavi da je image_conv niz nula pobrljavi skroz i sve bude belo al ovako radi blur
        image_conv = image
    if string == "edge": # uzima se niz nula na koje se doda vrednost tako gde je ivica i dobija se skoro pa binarna mapa(nije al kroz par ifova moze da se dobvije)
        image_conv = np.zeros(image.shape)
    for im_x in range(image_h - kernel_h + 1):#prva dva fora se rade za poziciju izlazne slike
        for im_y in range(image_w - kernel_w + 1):
            sum = .0
            for ker_x in range(kernel_h):# prolaz kroz kernel matricu
                for ker_y in range(kernel_w):
                    sum = sum + kernel[ker_x][ker_y] * image[im_x + ker_x][im_y + ker_y][0]#formula konvolucije
            for i in range(3): #u sva tri kanala(red green blue, kad su svi isti dobija se grayscale) se dodaje vrednost koja se dobije iz konvolucije (bez ovoga oce da brljavi)
                image_conv[im_x][im_y][i] = sum 
    return image_conv #vraca matricu niza boja tj matricu(dimenzija slike) [RED GREEN BLUE] vrednosti


def LoG(kernel_x,kernel_y,sigma): #prima dimenzije matrice i sigma koji se koristi u formuli( ne znam tacno sta radi to sigma)
    kernel = np.ones([kernel_x,kernel_y])#pravi matricu jedinica zadatih dimenzija
    for x in range(kernel_x):
        for y in range(kernel_y):
            kernel[x][y] = -(1/(sigma**4))*(x**2 + y**2 - 2*sigma**2)*(math.e)**(-(x**2+y**2)/(2*sigma**2)) #formula za laplacian matricu
    return kernel

def gaus(kernel_x, kernel_y, sigma):#prima dimenzije matrice i sigma koji se koristi u formuli( ne znam tacno sta radi to sigma)
    kernel = np.ones([kernel_x,kernel_y])#pravi matricu jedinica zadatih dimenzija
    for x in range(kernel_x):
        for y in range(kernel_y):
            kernel[x][y] = (1/((2*math.pi*sigma)**(1/2)))*math.e**((-x**2)/2*sigma**2) #formula za gausian blur matricu
    return kernel


lap_ker = LoG(10,10,2.7) #pravim matricu za lapacian
gaus_ker = gaus(10,10,2.7) #pravim matricu za gausian filter
# #print(lap_ker)
cv2.imshow('rgb', im) #prikaz slike koristi se open cv biblioteka
gray = rgb2gray(im) #grayscale slike
cv2.imshow('grayscale', gray) #prikaz slike koristi se open cv biblioteka
blur_im = convolution(gray, gaus_ker, 'blur') #konvolucija grayscale slike i gausian kernela da bi se dobila blurovana slika
#print(blur_im)
#blur_im = rgb2gray(blur_im)
cv2.imshow('blur', blur_im) #prikaz slike koristi se open cv biblioteka
# #edge = cv2.Laplacian(gray, -1)
edge = convolution(gray, lap_ker, 'edge') #konvolucija blurovane slike i laplacian kernela da bi se dobila slika ivica
# #edge = cv.2(edge)
cv2.imshow('edge', edge) #prikaz slike koristi se open cv biblioteka
cv2.waitKey(0) #ceka da se klikne taste 0 ili da se pogase svi otvoreni prozori
cv2.destroyAllWindows #ako je pritisnut taster 0 zatvara sve prozore i zavrsava skriptu

