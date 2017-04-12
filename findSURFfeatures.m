function [ matchedPoints1, matchedPoints2 ] = findSURFfeatures( I1,I2,show )
%FINDSURFFEATURES Summary of this function goes here
%   Detailed explanation goes here
    I1gray = rgb2gray(I1);
    I2gray = rgb2gray(I2);
    %I1gray=I1;
    %I2gray=I2;
    %detect surf features
    blobs1 = detectSURFFeatures(I1gray, 'MetricThreshold', 2000);
    blobs2 = detectSURFFeatures(I2gray, 'MetricThreshold', 2000);
    %find valid features
    [features1, validBlobs1] = extractFeatures(I1gray, blobs1);
    [features2, validBlobs2] = extractFeatures(I2gray, blobs2);
    %pairs of points
    indexPairs = matchFeatures(features1, features2, 'Metric', 'SAD', 'MatchThreshold', 5);
    %create separate matrix
    matchedPoints1 = validBlobs1(indexPairs(:,1),:);
    matchedPoints2 = validBlobs2(indexPairs(:,2),:);
    if show
        figure;
        showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);
        legend('Putatively matched points in I1', 'Putatively matched points in I2');
    end
end

