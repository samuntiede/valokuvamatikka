% Process two rose images by summing them together
% FIN Laske kaksi ruusukuvaa yhteen
%
% Samuli Siltanen April 2021

% Read in the images
% FIN Lue kuvat levyltä työtilaan
im1 = imread('../../kuvat/ruusu1.png');
im2 = imread('../../kuvat/ruusu2.png');
disp('Images read')

% Convert images from integers to floating point numbers
% FIN Muunna kuva-alkioiden sisältö kokonaisluvuista liukuluvuiksi
im1 = double(im1);
im2 = double(im2);

% Normalize images
% FIN Normalisoi kuva-alkiot nollan ja ykkösen välille 
MAX = max(max(im1(:)),max(im2(:)));
im1 = im1/MAX;
im2 = im2/MAX;
disp('Images normalized')

% Gamma correction for brightening images
% FIN Gammakorjaus ja kynnystyksiä
gammacorrB = .6;
blackthr = .03;
whitethr = .95;

% Save the summed image to file
% FIN Laske summakuva 
im3 = (im1+im2)/2;

% FIN Kohenna kuvaa
im3 = im3-min(im3(:));
im3 = im3/max(im3(:));
im3 = max(im3,blackthr)-blackthr;
im3 = im3/(whitethr*max(im3(:)));

% FIN Tallenna levylle
imwrite(uint8(255*im3.^gammacorrB),'../../kuvat/ruusu12.png','png');
disp('Wrote third image')

% FIN Katso, miltä kuva näyttää
figure(1)
clf
imshow(uint8(255*im3.^gammacorrB))
