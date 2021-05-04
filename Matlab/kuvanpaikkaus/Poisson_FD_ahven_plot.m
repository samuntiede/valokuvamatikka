% Write image files from the results computed by Poisson_FD_ahven_solve.m
%
% Samuli Siltanen November 2017

% Read in the perch image
im_orig = imread('KimmoSiltanen8MV.jpg','jpg');

% Load inpainting results
load data/Psol_ahven im2 Psol inpx inpy row col

% Pick out the fish detail image
fish = im_orig(inpy-2+[1:row+4],inpx-2+[1:col+4]);
% figure(1)
% clf
% imagesc(fish)

% Construct inpainted image
im2 = im_orig;
im2(inpy+[1:row],inpx+[1:col]) = Psol;

% Pick out the inpainted fish detail
Psol2 = im2(inpy-2+[1:row+4],inpx-2+[1:col+4]);

% Construct detail images with white color in the inpainting domain
im2W = im_orig;
im2W(inpy+[1:row],inpx+[1:col]) = 255;
Psol2W = im2W(inpy-20+[1:row+40],inpx-20+[1:col+40],1);

% Show the result
figure(1)
clf
imagesc([double(im_orig),double(im2)])
axis equal
colormap gray
axis off

% 
% % Load rope inpainting results (produced by Poisson_FD_ahven_solve2.m)
% load data/Psol_ahven2 im3 
% 
% 
% % Write results to disc
% imwrite(uint8(Psol2),'../images/Psol_ahven_detail.jpg','jpg')
% imwrite(uint8(fish),'../images/Psol_ahven_orig_detail.jpg','jpg')
% imwrite(uint8(im2),'../images/Psol_ahvenpois.jpg','jpg')
% imwrite(uint8(im3),'../images/Psol_ahvenjanarutpois.jpg','jpg')
% imwrite(uint8(im2W),'../images/Psol_ahvenvalko.jpg','jpg')
% imwrite(uint8(im_orig),'../images/Psol_ahvenorig.jpg','jpg')

