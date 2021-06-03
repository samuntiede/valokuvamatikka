# ENG Solve Poisson's equation in two different rectangles using the Finite 
# Difference Method. The aim is to remove the remaining two strings from 
# the image.
#
# FIN Kun ahven on jo poistettu kuvasta, poistetaan nyt vielä ne kaksi
# narua, joista ahven roikkui. 
#
# Samuli Siltanen May 2021
# Matlab -> Python Ville Tilvis June 2021

import numpy as np
import scipy.sparse.linalg
import matplotlib.pyplot as plt
plt.gray()   # FIN Kuvan tulostus harmaasävynä ENG Printing the image in grayscale
import sys
from FD_Laplace import FD_Laplace
from PIL import Image

def poisson_fix(im_orig, inpx, inpy, row, col):

    # ENG Check that row and col are even numbers
    # FIN Tarkista, että suorakaiteen korkeus ja leveys ovat parillisia lukuja
    if row % 2==1 or col % 2==1:
        print('row and col must be even numbers')
        sys.exit()

    # ENG Determine Dirichlet boundary conditions
    # FIN Määritä "Dirichlet'n reunaehdot" eli rekisteröi poistettavan alueen
    # reunalla olevat harmaasävyt. 
    vec_t = im_orig[inpy, inpx:inpx+col]
    vec_b = im_orig[inpy+row, inpx:inpx+col]
    vec_l = im_orig[inpy:inpy+row, inpx]
    vec_r = im_orig[inpy:inpy+row, inpx+col]

    # ENG Construct the FD Laplace matrix (this will take a while)
    # FIN Muodosta differenssimatriisi (tämä kestää jonkin aikaa)
    print('Constructing system matrix...')
    A    = FD_Laplace(row,col);
    print('System matrix constructed.')

    # ENG Construct the right-hand side vectors
    # FIN Muodosta yhtälön oikea puoli

    b = np.zeros((row*col,1))


    for iii in range(0, row):
        for jjj in range(0, col):
            ind = (jjj)*row+iii
            if iii==0:
                b[ind] = b[ind]+vec_t[jjj]
        
            if iii==row-1:
                b[ind] = b[ind]+vec_b[jjj]
        
            if jjj==0:
                b[ind] = b[ind]+vec_l[iii]
        
            if jjj==col-1:
                b[ind] = b[ind]+vec_r[iii]
     

    # ENG Solve the Poisson equations
    # FIN Ratkaise Poissonin yhtälö, joka on harmonisen kuvanpaikkauksen ydin
    print('Solving linear system...')
    Psol = scipy.sparse.linalg.gmres(A,b,tol=1e-05)[0]   # Pieni toleranssi tekee tarkemman kuvan, mutta on hidas.
    Psol = np.transpose(np.reshape(Psol,(col,row)))
    print('Linear system solved.')

    # ENG Save the result
    # FIN Tallennetaan korjattu kuva
    im2 = im_orig.copy()
    im2[inpy:inpy+row, inpx:inpx+col] = Psol
    
    return im2

# ENG Read in the perch image
# FIN Lue mustavalkoinen valokuva työtilaan
im1 = np.array(plt.imread('ahven_pois.jpg','jpg'))

# ENG First rope
# FIN Eka naru
im2 = poisson_fix(im1, 164, 0, 170, 26)

# ENG Second rope
# FIN Toka naru
im3 = poisson_fix(im2, 299, 1, 170, 26)

im_to_save = Image.fromarray(im3)
im_to_save.save('ahven_ja_narut_pois.jpg')


# ENG Take a look
# FIN Katsotaan tulosta
plt.subplot(1,2,1)  
plt.imshow(im1)
plt.axis('off')
plt.subplot(1,2,2)
plt.imshow(im3)
plt.axis('off')
plt.gcf().set_dpi(600)
plt.show()
