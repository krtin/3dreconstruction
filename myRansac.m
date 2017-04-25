function [ bestF,inlierPoints1, inlierPoints2 ] = myRansac(matchedPoints1,matchedPoints2, n,k,t,d )
%MYRANSAC Summary of this function goes here
%   Detailed explanation goes here

    %n = minimum values for model
    %k = max iterations
    %t = threshold for inliers
    %d = percentage of inliers to accept the model
    
    %run for k iterations 
    acceptedmodels=zeros(k,1);
    %very large value
    besterror=realmax('double');
    noofpoints = size(matchedPoints1,1);
    %convert points to 3 x n
    points1 = matchedPoints1';
    points1(3,:)=1.0;
    points2 = matchedPoints2';
    points2(3,:)=1.0;
    
    for iter=1:k
        %sample n values randomly or model base inliers
        samples = randsample(1:noofpoints,n);
        
        %compute model for these points
        F = getFundamentalMatrix(points1(:,samples),points2(:,samples));
        
        %get points not in sample and make them 3D
        %notsamples = setdiff(1:size(matchedPoints1,1),samples);
        %notpoints1 = matchedPoints1(notsamples,:);
        %notpoints2 = matchedPoints2(notsamples,:);
        %notpoints1 = [notpoints1(:,:) ones(size(notsamples,2),1)];
        %notpoints2 = [notpoints2(:,:) ones(size(notsamples,2),1)];
        
        
        
        %find error for points not in model
        %find p2Fp1
        p2fp1 = (points2' * F)';
        p2fp1 = p2fp1 .* points1;
        dist = sum(p2fp1, 1) .^ 2;
        
        %find inliers
        inliers = zeros(1, noofpoints);
        inliers(dist<=t)=1;
        ninliers = sum(inliers);
        
        %check if we have enough inliers 
        if (ninliers/noofpoints)>=d
           acceptedmodels(iter)=1; 
           %recompute model and estimate error
           %F = getFundamentalMatrix(matchedPoints1(logical(inliers1),:),matchedPoints2(logical(inliers1),:));
           
           err = cast(sum(dist(logical(inliers))),'double') + t*(noofpoints - inliers);
           
           if(err<besterror)
              besterror=err;
              bestinliers = inliers;
           end
        end
            
    end
    
    if sum(acceptedmodels)==0
        
       error('No Acceptable Model Found for given parameters'); 
       
    end
    
    bestF = getFundamentalMatrix(points1(:,logical(bestinliers)),points2(:,logical(bestinliers)));
    
    %prepare inlier points as n x 2 matrix
    inlierPoints1 = points1(1:2,logical(bestinliers));
    inlierPoints1 = inlierPoints1';
    inlierPoints2 = points2(1:2,logical(bestinliers));
    inlierPoints2 = inlierPoints2';
    
end

