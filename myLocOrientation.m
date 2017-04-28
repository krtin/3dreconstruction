function [ orient, loc , inlieridx] = myLocOrientation( matchedPoints1, matchedPoints2, I1, I2,cameraParams1, cameraParams2 ,show )
%MYLOCORIENTATION Summary of this function goes here
%   Detailed explanation goes here

    %n = minimum values for model
    n = 25;
    %k = max iterations
    k = 1000;
    %t = threshold for inliers
    t = 0.01;
    %d = percentage of inliers to accept the model
    d = 0.5;
    [F,inlierPoints1, inlierPoints2, inlieridx]= myRansac(matchedPoints1,matchedPoints2, n,k,t,d);
    
    %find essential matrix
    M1 = cameraParams1.IntrinsicMatrix;
    M2 = cameraParams2.IntrinsicMatrix;
    E = M2'*F*M1;
    
    % Display inlier matches
    if show
        figure
        showMatchedFeatures(I1, I2, inlierPoints1, inlierPoints2);
        title('Epipolar Inliers');
    end
    
    %myCameraPosition
    [orient, loc] = myCameraPosition(E, cameraParams1, cameraParams2, inlierPoints1,inlierPoints2);
    %use matlab function here
    %[orient, loc] = relativeCameraPose(E, cameraParams1, cameraParams2, inlierPoints1, inlierPoints2);
   
end

