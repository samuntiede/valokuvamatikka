% Put image back together after using AS_FD_Laplace and solving the image

function im_new=Back_Together(image,mask,x,D)

%How big the image is
[row,col]=size(image);
im_new=image; % no change done, just saving the old result here

for iii = 1:row
    for jjj = 1:col
        if mask(iii,jjj)== 0 % Change value
            id=D(iii,jjj);
            im_new(iii,jjj)=x(id);
        end
    end
end

end