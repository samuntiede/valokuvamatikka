% Solve Poisson's equation in a rectangle using Finite Difference Method.
%
% Samuli Siltanen August 2016

% Geometric parameters
lwidth = .5;

% Read in the image
im_orig = imread('Finni1.jpg','jpg'); % YOU CAN MODIFY HERE

% Extract color channels
imR_orig = double(im_orig(:,:,1));
imG_orig = double(im_orig(:,:,2));
imB_orig = double(im_orig(:,:,3));

% Pick out the part to be inpainted
inpx = 74;  % YOU CAN MODIFY HERE
inpy = 39;    % YOU CAN MODIFY HERE
row  = 20;  % YOU CAN MODIFY HERE
col  = 20;  % YOU CAN MODIFY HERE

ropeR = imR_orig(inpy+[1:row],inpx+[1:col]);
ropeG = imG_orig(inpy+[1:row],inpx+[1:col]);
ropeB = imB_orig(inpy+[1:row],inpx+[1:col]);

% Check that row and col are even numbers
if (mod(row,2)==1)|(mod(col,2)==1)
    error('row and col muxt be even numbers')
end

tic

% Determine Dirichlet boundary conditions
vec_Rt = imR_orig(inpy,inpx+[1:col]);
vec_Rb = imR_orig(inpy+row+1,inpx+[1:col]);
vec_Rl = imR_orig(inpy+[1:row],inpx);
vec_Rr = imR_orig(inpy+[1:row],inpx+col+1);
vec_Gt = imG_orig(inpy,inpx+[1:col]);
vec_Gb = imG_orig(inpy+row+1,inpx+[1:col]);
vec_Gl = imG_orig(inpy+[1:row],inpx);
vec_Gr = imG_orig(inpy+[1:row],inpx+col+1);
vec_Bt = imB_orig(inpy,inpx+[1:col]);
vec_Bb = imB_orig(inpy+row+1,inpx+[1:col]);
vec_Bl = imB_orig(inpy+[1:row],inpx);
vec_Br = imB_orig(inpy+[1:row],inpx+col+1);

% Construct the FD Laplace matrix
disp('Constructing system matrix')
A    = FD_Laplace(row,col);
disp('System matrix constructed')


% Construct the right-hand side vectors
bR = zeros(row*col,1);
bG = zeros(row*col,1);
bB = zeros(row*col,1);
for iii= 1:row
    for jjj = 1:col
        ind = (jjj-1)*row+iii;
        if iii==1
            bR(ind) = bR(ind)+vec_Rt(jjj);
            bG(ind) = bG(ind)+vec_Gt(jjj);
            bB(ind) = bB(ind)+vec_Bt(jjj);
        end
        if iii==row
            bR(ind) = bR(ind)+vec_Rb(jjj);
            bG(ind) = bG(ind)+vec_Gb(jjj);
            bB(ind) = bB(ind)+vec_Bb(jjj);
        end
        if jjj==1
            bR(ind) = bR(ind)+vec_Rl(iii);
            bG(ind) = bG(ind)+vec_Gl(iii);
            bB(ind) = bB(ind)+vec_Bl(iii);
        end
        if jjj==col
            bR(ind) = bR(ind)+vec_Rr(iii);
            bG(ind) = bG(ind)+vec_Gr(iii);
            bB(ind) = bB(ind)+vec_Br(iii);
        end
        
    end
end

% Solve the Poisson equations
disp('Solving linear system for red channel')
PsolR = gmres(A,bR,50,[],150);
PsolR = reshape(PsolR,row,col);
disp('Linear system solved')
disp('Solving linear system for green channel')
PsolG = gmres(A,bG,50,[],150);
PsolG = reshape(PsolG,row,col);
disp('Linear system solved')
disp('Solving linear system for blue channel')
PsolB = gmres(A,bB,50,[],150);
PsolB = reshape(PsolB,row,col);
disp('Linear system solved')


% Show the result
im2 = zeros(size(imG_orig,1),size(imG_orig,2),3);
im2(:,:,1) = imR_orig;
im2(:,:,2) = imG_orig;
im2(:,:,3) = imB_orig;
im2(inpy+[1:row],inpx+[1:col],1) = PsolR;
im2(inpy+[1:row],inpx+[1:col],2) = PsolG;
im2(inpy+[1:row],inpx+[1:col],3) = PsolB;

tottime = toc;

figure(1)
clf
imshow(uint8(im2))

imwrite(uint8(double(im_orig)),'Finni_on.png','png')
imwrite(uint8(im2),'Finni_pois.png','png')
