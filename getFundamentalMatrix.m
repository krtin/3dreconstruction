function [ F ] = getFundamentalMatrix( points1,points2 )
%GETFUNDAMENTALMATRIX Summary of this function goes here
%   Detailed explanation goes here

    n=size(points1,1);
    %compute the nx9 matrix for SVD
    A = zeros(n,9);
    points1 = points1.Location;
    points2 = points2.Location;
    for i = 1:n 
        x1 = points1(i,1);
        y1 = points1(i,2);
        x2 = points2(i,1);
        y2 = points2(i,2);
        A(i,:) = [x1*y1 x1*y2 x1 x2*y1 x2*y2 x2 x3*y1 x3*y2 x3];
    end
    %perform SVD
    [~,D,V] = svd(A);
    [~, index]=min(diag(D));
    %get the fundamental matrix
    F = reshape(V(:,index),3,3);
    %perform svd on F
    [U,D,V]=svd(F);
    [~, index]=min(diag(D));
    D(index,index)=0;
    %reestimate F
    F = U*D*V';
    
end
