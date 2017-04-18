function [ orient, loc ] = myLocOrientation( matchedPoints1, matchedPoints2, I1, I2,cameraParams ,show )
%MYLOCORIENTATION Summary of this function goes here
%   Detailed explanation goes here

    %n = minimum values for model
    n = 25;
    %k = max iterations
    k = 100;
    %t = threshold for inliers
    t = 0.1;
    %d = percentage of inliers to accept the model
    d = 0.75;
    [F,inlierPoints1, inlierPoints2]= myRansac(matchedPoints1,matchedPoints2, n,k,t,d);
    
    %find essential matrix
    %left and right intrinsic matrix are same
    M = cameraParams.IntrinsicMatrix;
    E = M'*F*M;
    
    % Display inlier matches
    if show
        figure
        showMatchedFeatures(I1, I2, inlierPoints1, inlierPoints2);
        title('Epipolar Inliers');
    end
    
    %use matlab function here
    [orient, loc] = relativeCameraPose(E, cameraParams, inlierPoints1, inlierPoints2);
end

