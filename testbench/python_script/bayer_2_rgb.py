import cv2
import numpy as np

org_img = cv2.imread('test.png')

img_h = org_img.shape[0]
img_w = org_img.shape[1]

bayer_array = np.zeros((img_h, img_w), dtype = np.uint8)

bayer_img = np.zeros((img_h*2, img_w*2, 3), dtype=np.uint8)

rgb_image = np.zeros((img_h, img_w, 3), dtype = np.uint8)

#Bayer layer
#BGBGBGBG......
#GRGRGRGR......
#BGBGBGBG......
#GRGRGRGR......

def rgb_2_bayer():
    bayer_img[::2, ::2, 0] = org_img[:, :, 0]
    bayer_img[1::2, ::2, 1] = org_img[:, :, 1]
    bayer_img[::2, 1::2, 1] = org_img[:, :, 1]
    bayer_img[1::2, 1::2, 2] = org_img[:, :, 2]

    cv2.imwrite("bayer_img.png", bayer_img)

def bayer_hex():
    for i in range(img_h):
        for j in range(img_w):
            if (i % 2 == 0):
                if (j % 2 == 0):
                    bayer_array[i, j] = org_img[i, j, 0]
                else:
                    bayer_array[i, j] = org_img[i, j, 1]
            else:
                if (j % 2 == 0):
                    bayer_array[i, j] = org_img[i, j, 1]
                else:
                    bayer_array[i, j] = org_img[i, j, 2]
    file =open('bayer_hex.hex','w')
    for e in bayer_array.flatten():
        file.write(format(e, 'x') +'\n')
    file.close()

def bayer_2_rgb():
    bayer_array2 = np.zeros((img_h+2, img_w+2))
    bayer_array2[1:-1, 1:-1] = bayer_array
    
    for i in range(img_h):
        for j in range(img_w):
            m = bayer_array2[i:i+3, j:j+3].flatten()
            
            if (i % 2 == 0):
                if (j % 2 == 0):
                    r = int((m[0] + m[2] + m[6] + m[8]) / 4)
                    g = int((m[1] + m[3] + m[5] + m[7]) / 4)
                    b = int(m[4])
                else:
                    r = int((m[1] + m[7]) / 2)
                    g = int(m[4])
                    b = int((m[3] + m[5]) / 2)
                rgb_image[i, j, :] = [b, g, r]
            else:
                if (j % 2 == 0):
                    r = int((m[3] + m[5]) / 2)
                    g = int(m[4])
                    b = int((m[1] + m[7]) / 2)
                else:
                    r = int(m[4])
                    g = int((m[1] + m[3] + m[5] + m[7]) / 4)
                    b = int((m[0] + m[2] + m[6] + m[8]) / 4)
                rgb_image[i, j, :] = [b, g, r]
    cv2.imwrite("rgb_image.png", rgb_image)

def desplay_img(img):
    cv2.imshow('image',img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

rgb_2_bayer()
bayer_hex()
bayer_2_rgb()
desplay_img(org_img)
