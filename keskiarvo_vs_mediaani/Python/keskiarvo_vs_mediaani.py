# Kokeillaan mediaanin ja keskiarvon eroa. Kuvissa (30kpl) on oppilaita
# satunnaisissa kohdissa, ja kamera oli jalustalla luokkahuoneessa. Otetaan
# toisaalta keskiarvot ja toisaalta mediaanit pikseliarvoista.
# Lopputulokset ovat hyvin erilaiset!
#
# Samuli Siltanen huhtikuu 2021
# Matlab -> Python Ville Tilvis kesäkuu 2021

import numpy as np
import matplotlib.pyplot as plt


# Kuvien lukumäärä
Nim = 30

# Alustetaan matriisit, joihin tallennetaam keskiarvot ja mediaanit
im_ave = np.zeros([2000,2997,3])
im_median = np.zeros([2000,2997,3])
im_4D = np.zeros([2000,2997,3,Nim])

print("Ladataan kuvat:")

# Avataan kuvat yksi kerrallaan
for iii in range (0,Nim):
    fname = '../_kuvat/IMGP'+str(1423+iii)+'.jpg'
    im_orig = plt.imread(fname,'jpg');
    
    # Lisätään tämänhetkinen kuva pakkaan
    im_4D[:,:,:,iii] = im_orig;
    
    # Seuraa ajoa
    print(iii+1,"/",Nim)

print("Lasketaan keskiarvo ja mediaani...")

im_ave = np.mean(im_4D,axis=3)/255;
im_median = np.median(im_4D,axis=3)/255;

print("Valmis!")
print("")
print("Näytetään kuvat...")

# Vähennetään keskiarvokuva ja
# mediaanikuva tyhjän kuvan
# punaisesta värikanavasta
im0 = np.array(plt.imread('../_kuvat/IMGP1444.jpg','jpg'))/255

error1 = np.abs(im_ave-im0)
error2 = np.abs(im_median-im0)
errorpic = np.concatenate((error1,error2),axis=1)
errorpic = errorpic/np.max(errorpic[:,:,0])
errorpic = np.power(errorpic,0.3)

#Katsotaan kuvia
plt.subplot(2,1,1)  
plt.imshow(np.concatenate((im_ave,im_median),axis=1))
plt.axis('off')
plt.gcf().set_dpi(600)

plt.subplot(2,1,2) 
plt.imshow(errorpic[:,:,0],cmap='gray', interpolation='none')
plt.axis('off')
plt.gcf().set_dpi(600)

plt.show()


print("Valmis!")
print("")
print("Tallennetaan kuvat...")

# Tallennetaan kuvat
plt.imsave('../_kuvat/im_average.jpg',im_ave,);
plt.imsave('../_kuvat/im_median.jpg',im_median);

print("Valmis!")
