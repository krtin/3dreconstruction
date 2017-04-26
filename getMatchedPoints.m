function [ matchedPoints1,matchedPoints2 ] = getMatchedPoints( I1, I2, show )
%GETMATCHEDPOINTS Summary of this function goes here
%   Detailed explanation goes here

    % Detect feature points
    imagePoints1 = detectMinEigenFeatures(rgb2gray(I1), 'MinQuality', 0.01);

    % Create the point tracker
    tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 5);

    % Initialize the point tracker
    imagePoints1 = imagePoints1.Location;
    initialize(tracker, imagePoints1, I1);

    % Track the points
    [imagePoints2, validIdx] = step(tracker, I2);
    matchedPoints1 = imagePoints1(validIdx, :);
    matchedPoints2 = imagePoints2(validIdx, :);
    
    if show
        figure;
        showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);
        legend('Matched points in I1', 'Matched points in I2');
    end
end

