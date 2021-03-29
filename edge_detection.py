import cv2
import numpy as np
import math

print("begin")


def rgb2gray(rgb):  # prima sliku i radi grayscale nad njom
    for x in range(rgb.shape[0]):
        for y in range(rgb.shape[1]):
            for i in range(3):
                # formula za rgb to gray gde se upisuje ista vrednost u sva tri kanala slike [red green blueS]
                rgb[x][y][i] = (0.2989 * rgb[x][y][0] + 0.5870 * rgb[x][y][1] + 0.1140 * rgb[x][y][2])
    return rgb


# image je slika koja nad kojom se radi konvolucija, kernel je matrica, a string samo radi selekciju sta je izlaz
def convolution(image, kernel, string):
    image_h = image.shape[0]  # dobija se visina slike
    image_w = image.shape[1]  # dobija se sirina slike

    kernel_h = kernel.shape[0]  # dobija se visina kernel matrice
    kernel_w = kernel.shape[1]  # dobija se sirina kernel matrice
    image_conv = 0
    if string == "blur":  # ne znam zasto al ako se ovde stavi da je image_conv niz nula pobrljavi skroz i sve bude belo al ovako radi blur
        image_conv = image
    # uzima se niz nula na koje se doda vrednost tako gde je ivica i dobija se skoro pa binarna mapa(nije al kroz par ifova moze da se dobvije)
    if string == "edge":
        image_conv = np.zeros(image.shape)
    # prva dva fora se rade za poziciju izlazne slike
    for im_x in range(image_h - kernel_h + 1):
        for im_y in range(image_w - kernel_w + 1):
            sum = .0
            for ker_x in range(kernel_h):  # prolaz kroz kernel matricu
                for ker_y in range(kernel_w):
                    # formula konvolucije
                    sum = sum + kernel[ker_x][ker_y] * \
                        image[im_x + ker_x][im_y + ker_y][0]
            for i in range(3):  # u sva tri kanala(red green blue, kad su svi isti dobija se grayscale) se dodaje vrednost koja se dobije iz konvolucije (bez ovoga oce da brljavi)
                image_conv[im_x][im_y][i] = sum
    # vraca matricu niza boja tj matricu(dimenzija slike) [RED GREEN BLUE] vrednosti
    return image_conv


# prima dimenzije matrice i sigma koji se koristi u formuli( ne znam tacno sta radi to sigma)
def LoG(kernel_x, kernel_y, sigma):
    # pravi matricu jedinica zadatih dimenzija
    kernel = np.ones([kernel_x, kernel_y])
    for x in range(kernel_x):
        for y in range(kernel_y):
            kernel[x][y] = -(1/(sigma**4))*(x**2 + y**2 - 2*sigma**2) * \
                (math.e)**(-(x**2+y**2)/(2*sigma**2)
                           )  # formula za laplacian matricu
    return kernel


# prima dimenzije matrice i sigma koji se koristi u formuli( ne znam tacno sta radi to sigma)
def gaus(kernel_x, kernel_y, sigma):
    # pravi matricu jedinica zadatih dimenzija
    kernel = np.ones([kernel_x, kernel_y])
    for x in range(kernel_x):
        for y in range(kernel_y):
            # formula za gausian blur matricu
            kernel[x][y] = (1/((2*math.pi*sigma)**(1/2))) * \
                math.e**((-x**2)/2*sigma**2)
    return kernel

# funkcija prima sliku na kojoj je odradjena konvolucija sa laplacian matricom, uz to prima i string koji odredjuje da li kao izlaz zelimo bit mapu ili sliku
def z_c_test(l_o_g_image, string):  # radi zero crossing... Treba da ispisem moj kod za ovo... Bez range_inc
    z_c_image = np.zeros(l_o_g_image.shape)
    range_temp = [-1, 0, 1]
    # Check the sign (negative or positive) of all the pixels around each pixel
    for i in range(1, l_o_g_image.shape[0]-1):
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
                if (string == "bit"): #ako hocemo bit mapu onda se samo svakom "piskelu dodeljuje 1 ili 0"
                    z_c_image[i, j] = 1
                if (string == "image"):#ako hocemo slikuy onda se umesto jednice dodljuje 255 svim kanalima [red green blue] da bi se dobila crna boja
                    for k in range(3):
                        z_c_image[i, j][k] = 255

    return z_c_image

def run():
    im = cv2.imread("Lenna_(test_image).png")
    print ("ucitao sluku")
    cv2.imshow('rgb', im)  # prikaz slike koristi se open cv biblioteka
    lap_ker = LoG(10, 10, 2.7)  # pravim matricu za lapacian
    gaus_ker = gaus(10, 10, 2.7)  # pravim matricu za gausian filter
    print ("napravio matrice")
    gray = rgb2gray(im)  # grayscale slike
    print ("odradio grayscale")
    cv2.imshow('grayscale', gray)  # prikaz slike koristi se open cv biblioteka
    blur_im = convolution(gray, gaus_ker, 'blur') #konvolucija grayscale slike i gaus kernela za blur
    print ("odradio blur")
    cv2.imshow('blur', blur_im) #prikaz slike koristi se open cv biblioteka
    log_edge = convolution(gray, lap_ker, 'edge') # konvolucija grayscake slike i laplacian kernela da bi se dobila slika ivica
    print ("odradio konvoluciju sa laplacian matricom")
    edge = z_c_test(log_edge, "image") #radu zero crossing proveru i pravi bit mapu ili sliku
    print ("odradio zero crossing proveru")
    cv2.imshow('edge', edge)  # prikaz slike koristi se open cv biblioteka

    print("pritisnuti 0 za zavsetak skripte")
    cv2.waitKey(0)    # ceka da se klikne taste 0 ili da se pogase svi otvoreni prozori
    cv2.destroyAllWindows  # ako je pritisnut taster 0 zatvara sve prozore i zavrsava skriptu
    cv2.imwrite('C:\FTN\8_osmi_semestar\system_level_design\projekat\Lenna_edge.bmp', edge)
    print("sacuvao sliku u folder")

run()

print ("end")
