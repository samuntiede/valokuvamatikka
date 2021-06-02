# ENG Construct an FD matrix approximating the 2D Laplace operator with 
# the infamous "five-point stencil." We assume that the difference h=1;
# 
# FIN Kootaan differenssimatriisi Laplacen operaattorille käyttäen viiden
# pisteen klassista lähestymistapaa. 
#
# Samuli Siltanen May 2021
# Matlab -> Python Ville Tilvis May 2021

from scipy import sparse


def FD_Laplace(row,col):

    # Initialize the result
    A = 4*sparse.eye(row*col);
    A = sparse.lil_matrix(A)

    # Loop over the rows of A
    for iii in range(0,row):
        for jjj in range(0,col):
            ind = (jjj)*row+iii
            if iii>0:
                A[ind,ind-1] = -1
        
            if iii<row-1:
                A[ind,ind+1] = -1
        
            if jjj>0:
                A[ind,ind-row] = -1
    
            if jjj<col-1:
                A[ind,ind+row] = -1
    
    return A
    
    




