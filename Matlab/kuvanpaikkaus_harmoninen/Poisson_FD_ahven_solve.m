% ENG Solve Poisson's equation in a rectangle using Finite Difference Method.
% The aim is to remove a perch from the image. 
%
% FIN Poistetaan ylimääräinen ahven valokuvasta käyttämällä 
% differenssimenetelmää ja harmonista kuvanpaikkausta. Aja tämän jälkeen 
% vielä Poisson_FD_ahven_solve2.m, jolloin myös langat poistetaan kuvasta.
%
% Samuli Siltanen May 2021

% ENG Read in the perch image
% FIN Lue mustavalkoinen valokuva työtilaan
im_orig = imread('../../kuvat/KimmoSiltanen8MV.jpg','jpg');

% ENG Choose the rectangle to be inpainted. This choice is for rremoving
% the entire fish from the image
% FIN Tämä iso suorakaide peittää koko ahvenen (mutta ei lankoja, joista se
% roikkuu). % Voit tehdä kokeiluja erilaisilla suorakaiteilla. 
% Huom: isomman suorakaiteen kanssa laskenta kestää kauemmin ja tarvitsee 
% enemmän muistia. Niin, ja rivien sekä sarakkeiden määrän pitää molempien 
% olla parilliset.
inpx = 50; % These are the real ones for the actual fish
inpy = 160; % These are the real ones for the actual fish
row  = 200; % These are the real ones for the actual fish
col  = 400; % These are the real ones for the actual fish

% ENG Pick out the part of the image to be inpainted
% FIN Irrota kuvasta täytettävä osa
fish = im_orig(inpy+[1:row],inpx+[1:col]);

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
disp('Solving linear system')
Psol = gmres(A,b,50,[],150);
Psol = reshape(Psol,row,col);
disp('Linear system solved')

% ENG Save the result
% FIN Tallenna kuva levylle
im2 = im_orig;
im2(inpy+[1:row],inpx+[1:col],1) = Psol;
imwrite(uint8(im2),'_kuvat/ahven_pois.jpg','jpg')

% ENG Take a look
% FIN Katsotaan tulosta
figure(20)
clf
imshow(cat(2,im_orig,uint8(im2)))
