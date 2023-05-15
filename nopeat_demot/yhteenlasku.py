# Process two rose images by summing them together
# FIN Laske kaksi ruusukuvaa yhteen
#
# Samuli Siltanen April 2021
# Python-käännös Ville Tilvis 2021

import numpy as np
import matplotlib.pyplot as plt

# Read in the images
# FIN Lue kuvat levyltä 
im1 = plt.imread('0_kuvat_erikseen/ruusu1_pieni.png')
im2 = plt.imread('0_kuvat_erikseen/ruusu2_pieni.png')
print('Images read')


# Normalize images
# FIN Normalisoi kuva-alkiot nollan ja ykkösen välille 

MAX = np.max([np.max(im1),np.max(im2)])
im1 = im1/MAX
im2 = im2/MAX
print('Images normalized')

# Gamma correction for brightening images
# FIN Gammakorjaus ja kynnystyksiä
gammacorrB = .6
blackthr = .03
whitethr = .95

# Save the summed image to file
# FIN Laske summakuva 
im3 = (im1+im2)/2

# FIN Kohenna kuvaa
im3 = im3-np.min(im3);
im3 = im3/np.max(im3);
blackthrarray = blackthr*np.ones(im3.shape)
im3 = np.maximum(im3,blackthrarray)-blackthrarray
im3 = im3/(whitethr*np.max(im3));
im3 =np.minimum(im3, np.ones(im3.shape))
im3 = np.power(im3,gammacorrB)
print('New image ready')

# FIN Tallenna levylle
plt.imsave('nopeat_demot/ruusu12_pieni.png', im3);
print('Wrote new image to file')

# FIN Katsotaan, miltä kuva näyttää
plt.subplot(2, 2, 1)
plt.imshow(im1)
plt.axis('off')
plt.subplot(2, 2, 2)
plt.imshow(im2)
plt.axis('off')
plt.subplot(2, 2, 3)
plt.imshow(im3)
plt.axis('off')
plt.gcf().set_dpi(100)
plt.show()
