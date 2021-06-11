% Kokeillaan mediaanin ja keskiarvon eroa. Kuvissa (30kpl) on oppilaita
% satunnaisissa kohdissa, ja kamera oli jalustalla luokkahuoneessa. Otetaan
% toisaalta keskiarvot ja toisaalta mediaanit pikseliarvoista.
% Lopputulokset ovat hyvin erilaiset!
%
% Samuli Siltanen huhtikuu 2021

% Kuvien lukumäärä
Nim = 30;

% Alustetaan matriisit, joihin tallennetaam keskiarvot ja mediaanit
im_ave = zeros(2000,2997,3);
im_median = zeros(2000,2997,3);
im_4D = zeros(2000,2997,3,Nim);

% Avataan kuvat yksi kerrallaan
for iii = 1:Nim
    fname = ['../_kuvat/IMGP',num2str(1422+iii),'.jpg'];
    im_orig = imread(fname,'jpg');
    
    % Muutetaan pikseliarvot liukuluvuiksi
    im = double(im_orig);
    
    % Lisätään tämänhetkinen kuva pakkaan
    im_4D(:,:,:,iii) = im;
    
    % Seuraa ajoa
    disp([iii,Nim])
end
im_ave = mean(im_4D,4);
im_median = median(im_4D,4);

% Katsotaan kuvaa
figure(1)
clf
imshow(uint8(round([im_ave,im_median])))
axis equal
colormap gray

% Vähennetään keskiarvokuva ja
% mediaanikuva tyhjän kuvan
% punaisesta värikanavasta
im0 = double(imread('../_kuvat/IMGP1444.jpg','jpg'));

errorpic = [abs(im_ave-im0),abs(im_median-im0)];
errorpic = errorpic/max(errorpic(:));
errorpic = errorpic.^(0.3);
figure(2)
clf
imshow(uint8(round(255*errorpic)))
axis equal

% Tallennetaan kuvat
imwrite(uint8(im_ave),'../_kuvat/im_average.jpg');
imwrite(uint8(im_median),'../_kuvat/im_median.jpg');
