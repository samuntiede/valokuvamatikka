# Process two rose images by summing them together
# FIN Laske kaksi ruusukuvaa yhteen
#
# Samuli Siltanen April 2021
# Python-käännös Ville Tilvis 2021

import numpy as np
import matplotlib.pyplot as plt

# Read in the images
# FIN Lue kuvat levyltä 
im1 = plt.imread('../_kuvat/ruusu1.png')
im2 = plt.imread('../_kuvat/ruusu2.png')
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
plt.imsave('../_kuvat/ruusu12.png', im3);
print('Wrote new image to file')

# FIN Katso, miltä kuva näyttää
plt.figure(1)
plt.clf
plt.axis('off')
plt.gcf().set_dpi(600)
plt.imshow(im3)
