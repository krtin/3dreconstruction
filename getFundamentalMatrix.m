function [ F ] = getFundamentalMatrix( points1,points2 )
%GETFUNDAMENTALMATRIX Summary of this function goes here
%   Detailed explanation goes here

    %points1=points1';
    %points2=points2';

    n=size(points1,2);
    %normalization
    [points1, t1] = vision.internal.normalizePoints(points1, 2, 'double');
    [points2, t2] = vision.internal.normalizePoints(points2, 2, 'double');
    
    
    %compute the nx9 matrix for SVD
    A = zeros(n, 9, 'double');
    
    %x1*x2
    A(:,1) = (points1(1,:).*points2(1,:))';
    %y1*x2
    A(:,2) = (points1(2,:).*points2(1,:))';
    %x2
    A(:,3) = (points2(1,:))';
    %x1*y2
    A(:,4) = (points1(1,:).*points2(2,:))';
    %y1*y2
    A(:,5) = (points1(2,:).*points2(2,:))';
    %y2
    A(:,6) = (points2(2,:))';
    %x1
    A(:,7) = (points1(1,:))';
    %y1
    A(:,8) = (points1(2,:))';
    %1
    A(:,9) = 1;
    
    %perform SVD
    [~,D,V] = svd(A);
    [~, index]=min(diag(D));
    %get the fundamental matrix
    F = reshape(V(:,index),3,3)';
    %perform svd on F
    [U,D,V]=svd(F);
    [~, index]=min(diag(D));
    D(index,index)=0;
    %reestimate F
    F = U*D*V';
    
    %denormalize
    F = t2' * F * t1;
    F = F / norm(F);
    if F(end) < 0
        F = -F;
    end
    
end

