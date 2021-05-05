% ENG Solve Poisson's equation in two different rectangles using the Finite 
% Difference Method. The aim is to remove the remaining two strings from 
% the image.
%
% FIN Kun ahven on jo poistettu kuvasta, poistetaan nyt vielä ne kaksi
% narua, joista ahven roikkui. 
%
% Samuli Siltanen May 2021

% Read in the perch image
im_orig = imread('_kuvat/ahven_pois.jpg','jpg');

% ENG First rope
% FIN Eka naru

% ENG Pick out the rectangle to be inpainted
% FIN Poimi sopiva suorakaide
inpx = 165;
inpy = 1;
row  = 170;
col  = 26;

% ENG Check that row and col are even numbers
% FIN Tarkista, että suorakaiteen korkeus ja leveys ovat parillisia lukuja
if (mod(row,2)==1)|(mod(col,2)==1)
    error('row and col muxt be even numbers')
end

% ENG Determine Dirichlet boundary conditions
% FIN Määritä "Dirichlet'n reunaehdot" eli rekisteröi poistettavan alueen
% reunalla olevat harmaasävyt. 
vec_t = im_orig(inpy,inpx+[1:col]);
vec_b = im_orig(inpy+row+1,inpx+[1:col]);
vec_l = im_orig(inpy+[1:row],inpx);
vec_r = im_orig(inpy+[1:row],inpx+col+1);

% ENG Construct the FD Laplace matrix (this will take a while)
% FIN Muodosta differenssimatriisi (tämä lasku kestää jonkin aikaa)
disp('Constructing system matrix')
A    = FD_Laplace(row,col);
eval(['save data/FDLmatrix_',num2str(row),'_',num2str(col),' A'])
% ENG If you have already constructed the matrix for a rectangle of certain 
% size, you can comment the two lines above.
% FIN Jos olet jo aiemmin muodostanut differenssimatriisin saman kokoiselle
% suorakaiteelle, voit kommentoida ylemmät kaksi riviä ja lukea vanhan
% matriisin levyltä
eval(['load data/FDLmatrix_',num2str(row),'_',num2str(col),' A'])
disp('System matrix constructed')

% ENG Construct the right-hand side vectors
% FIN Muodosta yhtälön oikea puoli
b = zeros(row*col,1);
for iii= 1:row
    for jjj = 1:col
        ind = (jjj-1)*row+iii;
        if iii==1
            b(ind) = b(ind)+vec_t(jjj);
        end
        if iii==row
            b(ind) = b(ind)+vec_b(jjj);
        end
        if jjj==1
            b(ind) = b(ind)+vec_l(iii);
        end
        if jjj==col
            b(ind) = b(ind)+vec_r(iii);
        end
        
    end
end

% ENG Solve the Poisson equations
% FIN Ratkaise Poissonin yhtälö, joka on harmonisen kuvanpaikkauksen ydin
disp('Solving linear system for red channel')
Psol = gmres(A,b,50,[],150);
Psol = reshape(Psol,row,col);
disp('Linear system solved')

% ENG Add the result to the image
% FIN Lisää uusi tulos kuvaan
im2 = im_orig;
im2(inpy+[1:row],inpx+[1:col]) = Psol;

% ENG Second rope
% FIN Toka naru

% ENG Pick out the rectangle to be inpainted (row, col same as above)
% FIN Poimi sopiva suorakaide (row, col samat kuin aiemmin)
inpx2 = 300;
inpy2 = 1;

% ENG Determine Dirichlet boundary conditions
% FIN Määritä "Dirichlet'n reunaehdot" eli rekisteröi poistettavan alueen
% reunalla olevat harmaasävyt. vec_t = im_orig(inpy,inpx+[1:col]);
vec_t = im_orig(inpy2,inpx2+[1:col]);
vec_b = im_orig(inpy2+row+1,inpx2+[1:col]);
vec_l = im_orig(inpy2+[1:row],inpx2);
vec_r = im_orig(inpy2+[1:row],inpx2+col+1);

% ENG Construct the right-hand side vectors
% FIN Muodosta yhtälön oikea puoli
b = zeros(row*col,1);
for iii= 1:row
    for jjj = 1:col
        ind = (jjj-1)*row+iii;
        if iii==1
            b(ind) = b(ind)+vec_t(jjj);
        end
        if iii==row
            b(ind) = b(ind)+vec_b(jjj);
        end
        if jjj==1
            b(ind) = b(ind)+vec_l(iii);
        end
        if jjj==col
            b(ind) = b(ind)+vec_r(iii);
        end
        
    end
end

% ENG Solve the Poisson equations
% FIN Ratkaise Poissonin yhtälö, joka on harmonisen kuvanpaikkauksen ydin
disp('Solving linear system for red channel')
Psol2 = gmres(A,b,50,[],150);
Psol2 = reshape(Psol2,row,col);
disp('Linear system solved')


% ENG Add the result to the image
% FIN Lisää uusi tulos kuvaan
im3 = im2;
im3(inpy2+[1:row],inpx2+[1:col]) = Psol2;


% ENG Save the result
% FIN Tallenna kuva levylle
imwrite(uint8(im3),'_kuvat/ahven_ja_narut_pois.jpg','jpg')

% ENG Take a look
% FIN Katsotaan tulosta
figure(20)
clf
imshow(cat(2,im_orig,uint8(im3)))



