% ENG Process two rose images by summing them together
% FIN Laske kaksi ruusukuvaa yhteen
%
% Samuli Siltanen May 2021

% ENG Read in the images
% FIN Lue kuvat levyltä työtilaan
im1 = imread('../_kuvat/ruusu1.png');
im2 = imread('../_kuvat/ruusu2.png');
disp('Images read')

% ENG Convert images from integers to floating point numbers
% FIN Muunna kuva-alkioiden sisältö kokonaisluvuista liukuluvuiksi
im1 = double(im1);
im2 = double(im2);

% ENG Normalize images
% FIN Normalisoi kuva-alkiot nollan ja ykkösen välille 
MAX = max(max(im1(:)),max(im2(:)));
im1 = im1/MAX;
im2 = im2/MAX;
disp('Images normalized')

% ENG Gamma correction for brightening images
% FIN Gammakorjaus ja kynnystyksiä
gammacorrB = .6;
blackthr = .03;
whitethr = .95;

% ENG Save the summed image to file
% FIN Laske summakuva 
im3 = (im1+im2)/2;

% ENG Enhance the image
% FIN Kohenna kuvaa
im3 = im3-min(im3(:));
im3 = im3/max(im3(:));
im3 = max(im3,blackthr)-blackthr;
im3 = im3/(whitethr*max(im3(:)));

% ENG Write image to file
% FIN Tallenna levylle
imwrite(uint8(255*im3.^gammacorrB),'../_kuvat/ruusu_plus.png','png');
disp('Wrote third image')

% ENG Take a look at the image
% FIN Katso, miltä kuva näyttää
figure(1)
clf
imshow(uint8(255*im3.^gammacorrB))
