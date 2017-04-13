function [ orient, loc ] = getLocOrientation( matchedPoints1, matchedPoints2, I1, I2,cameraParams ,show )
%GETTRANSFORMATIONS Summary of this function goes here
%   Detailed explanation goes here
% Estimate the fundamental matrix
    [E, epipolarInliers] = estimateEssentialMatrix(...
        matchedPoints1, matchedPoints2, cameraParams, 'Confidence', 99.99);

    % Find epipolar inliers
    inlierPoints1 = matchedPoints1(epipolarInliers, :);
    inlierPoints2 = matchedPoints2(epipolarInliers, :);

    % Display inlier matches
    if show
        figure
        showMatchedFeatures(I1, I2, inlierPoints1, inlierPoints2);
        title('Epipolar Inliers');
    end
    [orient, loc] = relativeCameraPose(E, cameraParams, inlierPoints1, inlierPoints2);
end

