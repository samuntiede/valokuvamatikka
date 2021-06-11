% Function to calculate arbitary shape matrix for harmonic 
% image repair
% Given original image, mask for the image (same size)
% Returns matrix A and vector b, for solving Ax=b.
% Heli 24.11.

function [A,b,D]=AS_FD_Laplace(image,mask)

% Save the number of rows and columns
[row,col]=size(image);
[row2,col2]=size(mask);
if (row~=row2)|(col~=col2)
    error('Your mask must be the same size as given image!')
end

% Initialize a dummy matrix: same size as original image
D=zeros(row,col);

% How many points are 0 in the mask: 
% 0 means to replace, 1 means to keep as is.
% 0 is black, 1 is white
no_points=0;
for iii = 1:row
    for jjj = 1:col
        if mask(iii,jjj)==0
            no_points=no_points+1; % Increase the number of points
            D(iii,jjj)=no_points; % Save which point this was!
        end
    end
end
display(['The mask contains changable points: ',num2str(no_points)])
% Create the returnable matrix and the vector:
A=4*speye(no_points,no_points); % square matrix, fours on diagonal
b=zeros(no_points,1); % vector no_points x 1

for iii = 1:row
    for jjj = 1:col
       if mask(iii,jjj)==0 % Point is to be replaced
           id=D(iii,jjj); % The id of this node
           if iii>1 % Not on the first row
               if mask(iii-1,jjj)==0 % The node above is also in mask
                   id_above=D(iii-1,jjj);
                   A(id,id_above)=-1;
               else % Only two cases, so the node above is not in the mask
                   % Sum the above node value of original image to existing
                   % value
                   b(id)=b(id)+image(iii-1,jjj);
               end
           end
           if iii < row % Not on the last row
               if mask(iii+1,jjj)==0 % The node below is also in mask
                   id_below=D(iii+1,jjj);
                   A(id,id_below)=-1;
               else % Still only two situations, sum the below to existing
                   b(id)=b(id)+image(iii+1,jjj);
               end
           end
           if jjj>1 % Not on the left most column
               if mask(iii,jjj-1)==0 % The node left is also in mask
                   id_left=D(iii,jjj-1);
                   A(id,id_left)=-1;
               else % Not in mask
                   b(id)=b(id)+image(iii,jjj-1);
               end
           end
           if jjj<col % Not on the most right column
               if mask(iii,jjj+1)==0 % The node right is also in mask
                   id_right=D(iii,jjj+1);
                   A(id,id_right)=-1;
               else % Not in mask
                   b(id)=b(id)+image(iii,jjj+1);
               end
           end
           if iii==1 % If the point is on the first row
               if jjj==1 % If it is the left corner point
                   A(id,id)=2; % There is only two points to get the avarage
               elseif jjj==col % If it the right corner point
                   A(id,id)=2; % Only two points to get average
               else % The point is on somewhere on the upper row
                   A(id,id)=3; % There are three points to get the average
               end
           elseif iii==row % The point is on the last row
               if jjj==1 % Left corner
                   A(id,id)=2;
               elseif jjj==col % right corner
                   A(id,id)=2;
               else % Elsewhere on the below row
                   A(id,id)=3;
               end
           elseif jjj==1 % If the point is in the left column
               if iii==1 % Should be dealt with already
                   A(id,id)=2;
               elseif iii==row % Should be already dealt with
                   A(id,id)=2;
               else
                   A(id,id)=3;
               end
           elseif jjj==col % If the point is in the right column
               if iii==1
                   A(id,id)=2;
               elseif iii==row
                   A(id,id)=2;
               else
                   A(id,id)=3;
               end
           end
       end
    end 
end
end