# Kuvankäsittelyä Pythonilla: RGB-värit

# Koodi muokkaa kuvan värejä tekemällä lineaarisen muunnoksen
# kunkin pikselin RGB-arvoille:
# R_uusi = a*R + b*G + c*B
# G_uusi = d*R + e*G + f*B
# B_uusi = h*R + i*G + j*B
#
# Kertoimet a,b,c, ... , j annetaan matriisina A, josta on
# alla esimerkkejä.

# 2021-05-28
# Ville Tilvis

import numpy as np
import matplotlib.pyplot as plt


###################################
# Vaihda tästä lineaarikuvausta A #
###################################

# Harmaasävyt
#A = np.array([[1/3, 1/3, 1/3], [1/3, 1/3, 1/3],[1/3, 1/3, 1/3]])
#A = np.array([[0.299, 0.587, 0.114], [0.299, 0.587, 0.114], [0.299, 0.587, 0.114]])

#Seepiafiltteri
A = np.array([[ 0.39, 0.769, 0.189], [0.349, 0.686, 0.168],[0.272, 0.534, 0.131]])

#Värien vaihtamista toisiin
#A = np.array([[ 0, 1, 0], [0, 0, 1],[1, 0, 0]]) 
#A = np.array([[ 0, 0, 1], [1, 0, 0],[0, 1, 0]]) 
#A = np.array([[ 0, 0, 1], [0, 1, 0],[1, 0, 0]]) 

# Yksittäiset värikanavat
#A = np.array([[ 1, 0, 0], [0, 0, 0],[0, 0, 0]]) 
#A = np.array([[ 0, 0, 0], [0, 1, 0],[0, 0, 0]]) 
#A = np.array([[ 0, 0, 0], [0, 0, 0],[0, 0, 1]]) 

# Muita
#A = np.array([[ 0.789, 0, 1], [1, 0.789, 1/3],[1, 1, 0.789]]) # Sinisävyinen
#A = np.array([[1,1, 1], [1, 1, 1 ],[1,  1 ,1]])  # Ylivalottunut
#A = np.array([[ 0.8, 0.2, 0], [0, 0.8, 0.2],[0, 0, 0.5]]) #vanha värikuva

#Kehitä oma:       
#A = np.array([[ , , ], [, , ],[, , ]])     

print("RGB-värimuunnoksen kertoimet ovat")
print(A)




#####################################################################
# Ladataan kuva 2d-taulukkona, jonka alkiot ovat rgb-värien listoja #
#####################################################################


kuva = plt.imread("0_kuvat_erikseen/saunan_korjaus.png")  

korkeus = kuva.shape[0]
leveys = kuva.shape[1]

# Poistetaan kuvasta alpha-kanava, jos sellainen on.
# Käytetään siis vain kanavat 0, 1 ja 2 eli R, G ja B.
kuva = kuva[:,:,0:3]  


# Musta kuva uuden kuvan pohjaksi
uusi_kuva = np.zeros(kuva.shape)

# VÄRIEN MUOKKAUS

# Muokataan värejä värikanava kerrallaan
R_vanha = kuva[:,:,0]
G_vanha = kuva[:,:,1]
B_vanha = kuva[:,:,2]

R_uusi = A[0][0]*R_vanha + A[0][1]*G_vanha + A[0][2]*B_vanha
G_uusi = A[1][0]*R_vanha + A[1][1]*G_vanha + A[1][2]*B_vanha
B_uusi = A[2][0]*R_vanha + A[2][1]*G_vanha + A[2][2]*B_vanha

# Kootaan värikanavat
uusi_kuva[:,:,0] = R_uusi
uusi_kuva[:,:,1] = G_uusi
uusi_kuva[:,:,2] = B_uusi


# Leikataan liian suuret ja pienet arvot pois
valkoinen = np.ones(uusi_kuva.shape)
musta = np.zeros(uusi_kuva.shape)
uusi_kuva = np.minimum(uusi_kuva, valkoinen)
uusi_kuva = np.maximum(uusi_kuva, musta)


# Näytetään vanha ja uusi kuva rinnakkain
plt.subplot(1,2,1)  
plt.imshow(kuva, interpolation='none')
plt.axis('off')
plt.subplot(1,2,2)
plt.imshow(uusi_kuva, interpolation='none',)
plt.axis('off')
plt.gcf().set_dpi(100)
plt.show()

plt.imsave("nopeat_demot/RGB-muokattu.png", uusi_kuva)

print("Valmis!")
