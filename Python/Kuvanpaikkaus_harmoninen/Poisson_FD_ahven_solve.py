# ENG Solve Poisson's equation in a rectangle using Finite Difference Method.
# The aim is to remove a perch from the image. 
#
# FIN Poistetaan ylimääräinen ahven valokuvasta käyttämällä 
# differenssimenetelmää ja harmonista kuvanpaikkausta. Aja tämän jälkeen 
# vielä Poisson_FD_ahven_solve2.m, jolloin myös langat poistetaan kuvasta.
#
# Samuli Siltanen May 2021
# Matlab -> Python Ville Tilvis May 2021

import numpy as np
import scipy.sparse.linalg
import matplotlib.pyplot as plt
plt.gray()   # FIN Kuvan tulostus harmaasävynä ENG Printing the image in grayscale
import sys
from FD_Laplace import FD_Laplace


# ENG Read in the perch image
# FIN Lue mustavalkoinen valokuva työtilaan
im_orig = np.array(plt.imread('KimmoSiltanen8MV.jpg','jpg'))


# ENG Choose the rectangle to be inpainted. This choice is for removing
# the entire fish from the image
# FIN Tämä iso suorakaide peittää koko ahvenen (mutta ei lankoja, joista se
# roikkuu). % Voit tehdä kokeiluja erilaisilla suorakaiteilla. 
# Huom: isomman suorakaiteen kanssa laskenta kestää kauemmin ja tarvitsee 
# enemmän muistia. Niin, ja rivien sekä sarakkeiden määrän pitää molempien 
# olla parilliset.
# x- ja y- koordinaatit ovat Pythonissa eri päin kuin matlabissa
inpx = 50; # These are the real ones for the actual fish
inpy = 160; # These are the real ones for the actual fish
row  = 200; # These are the real ones for the actual fish
col  = 400; # These are the real ones for the actual fish

# ENG Pick out the part of the image to be inpainted
# FIN Irrota kuvasta täytettävä osa
fish = im_orig[inpy:inpy+row, inpx:inpx+col]

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
im2[inpy:inpy+row, inpx:inpx+col] = Psol;
plt.imsave('ahven_pois.jpg', im2, format='jpg')

# ENG Take a look
# FIN Katsotaan tulosta
plt.subplot(1,2,1)  
plt.imshow(im_orig)
plt.axis('off')
plt.subplot(1,2,2)
plt.imshow(im2)
plt.axis('off')
plt.gcf().set_dpi(600)
plt.show()
