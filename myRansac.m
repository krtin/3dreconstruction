function [ output_args ] = myRansac(matchedPoints1,matchedPoints2, n,k,t,d )
%MYRANSAC Summary of this function goes here
%   Detailed explanation goes here

    %n = minimum values for model
    %k = max iterations
    %t = threshold for inliers
    %d = percentage of inliers to accept the model
    
    %run for k iterations 
    acceptedmodels=zeros(k,1);
    
    for iter=1:k
        %sample n values randomly
        samples = randsample(1:size(matchedPoints1,1),n);
        
        %compute model for these points
        F = getFundamentalMatrix(matchedPoints1(samples),matchedPoints2(samples));
        
        %get points not in sample and make them 3D
        notsamples = setdiff(1:size(matchedPoints1,1),samples);
        notpoints1 = matchedPoints1(notsamples).Location;
        notpoints2 = matchedPoints2(notsamples).Location;
        notpoints1 = [notpoints1(:,:) ones(size(notsamples,2),1)];
        notpoints2 = [notpoints2(:,:) ones(size(notsamples,2),1)];
        
        %find inliers
        inliers1 = zeros(size(matchedPoints1,1),1);
        inliers2 = zeros(size(matchedPoints1,1),1);
        %set samples as inliers
        inliers1(samples) = 1;
        inliers2(samples) = 1;
        for i=1:size(notsamples,2)
            dist = (notpoints2(i,:)*F*notpoints1(i,:)')^2;
            if dist<=t
                inliers1(notsamples(i)) = 1;
                inliers2(notsamples(i)) = 1;
            end
        end
        %check if we have enough inliers 
        if (sum(inliers1)/size(matchedPoints1,1))>=d
           acceptedmodels(iter)=1; 
           %recompute model and estimate error
           
           F = getFundamentalMatrix(matchedPoints1(logical(inliers1)),matchedPoints2(logical(inliers1)));
           
        end
            
    end
    
    
    
    
end

