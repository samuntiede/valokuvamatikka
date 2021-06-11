% ENG Solve Poisson's equation in a general domain defined by a mask image, 
% using Finite Difference Method. The aim is to remove a perch from the image. 
%
% FIN Poistetaan ylimääräinen ahven valokuvasta käyttämällä 
% differenssimenetelmää ja harmonista kuvanpaikkausta. Tämä rutiini osaa
% käyttää mielivaltaista poistettavaa aluetta. 
%
% Samuli Siltanen & Heli Virtanen May 2021

% ENG Read in the perch image
% FIN Lue mustavalkoinen valokuva työtilaan
im_orig = imread('../_kuvat/KimmoSiltanen8MV.jpg','jpg');

% ENG Choose the domain to be inpainted. This choice is for removing
% the entire fish AND the two strings from the image
% FIN Tämä maskikuva peittää koko ahvenen ja myöskin narut.
mask = double(imread('../_kuvat/KimmoSiltanen8MV_rough_mask.png'));

% ENG Construct the FD Laplace matrix and right-hand-side 
% FIN Muodosta differenssimatriisi ja yhtälön oikea puoli
disp('Constructing system matrix and rhs')
[A,b,D] = AS_FD_Laplace(im_orig,mask);
disp('System matrix and rhs constructed')

% ENG Solve the Poisson equations
% FIN Ratkaise Poissonin yhtälö, joka on harmonisen kuvanpaikkauksen ydin
disp('Solving linear system')
Psol = gmres(A,b,50,[],150);
disp('Linear system solved')

% ENG Save the result
% FIN Tallenna kuva levylle
im2 = Back_Together(im_orig,mask,Psol,D);
imwrite(uint8(im2),'../_kuvat/ahven_ja_narut_pois2.jpg','jpg')

% ENG Take a look
% FIN Katsotaan tulosta
figure(20)
clf
imshow(cat(2,im_orig,uint8(im2)))
