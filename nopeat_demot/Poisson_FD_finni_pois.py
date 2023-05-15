# ENG Solve Poisson's equation using the Finite 
# Difference Method. The aim is to remove the zit.
#
# FIN Poistetaan finni!
#
# Samuli Siltanen May 2021
# Matlab -> Python Ville Tilvis June 2021

import numpy as np
from scipy import sparse
import scipy.sparse.linalg
import matplotlib.pyplot as plt
plt.gray()   # FIN Kuvan tulostus harmaasävynä ENG Printing the image in grayscale
import sys

from PIL import Image



def FD_Laplace(row,col):

    # Initialize the result
    A = 4*sparse.eye(row*col);
    A = sparse.lil_matrix(A)

    # Loop over the rows of A
    for iii in range(0,row):
        for jjj in range(0,col):
            ind = (jjj)*row+iii
            if iii>0:
                A[ind,ind-1] = -1
        
            if iii<row-1:
                A[ind,ind+1] = -1
        
            if jjj>0:
                A[ind,ind-row] = -1
    
            if jjj<col-1:
                A[ind,ind+row] = -1
    
    return A

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
    print('')
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

# ENG Read in the BW image
# FIN Lue mustavalkoinen valokuva työtilaan
im1 = np.array(plt.imread('0_kuvat_erikseen/Finni.png','png'))



# ENG Separate the color channels
# FIN Erotetaan värikanavat
R = im1[:,:,0]
G = im1[:,:,1]
B = im1[:,:,2]

# ENG Area to be fixed
# FIN  Korjattava alue
corner_x = 74       # MODIFY / MUOKKAA
corner_y = 39       # MODIFY / MUOKKAA
width = 20          # MODIFY / MUOKKAA
height = 20         # MODIFY / MUOKKAA

R2 = poisson_fix(R, corner_x, corner_y, width, height)
G2 = poisson_fix(G, corner_x, corner_y, width, height)
B2 = poisson_fix(B, corner_x, corner_y, width, height)


# ENG Rebuild the image
# FIN Kasataan uusi kuva yksittäisistä värikanvaista
im2 = np.dstack( (R2,G2,B2))


# ENG Save to file
# FIN Tallennetaan tiedostoon
plt.imsave("nopeat_demot/finni_poistettu.png", im2)


# ENG Take a look
# FIN Katsotaan tulosta
plt.subplot(1,2,1)  
plt.imshow(im1)
plt.axis('off')
plt.subplot(1,2,2)
plt.imshow(im2)
plt.axis('off')
plt.gcf().set_dpi(100)
plt.show()
