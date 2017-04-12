function [ tform1, tform2 ] = getTransformations( matchedPoints1, matchedPoints2, I1, I2, show )
%GETTRANSFORMATIONS Summary of this function goes here
%   Detailed explanation goes here
    [fMatrix, epipolarInliers, status] = estimateFundamentalMatrix(...
      matchedPoints1, matchedPoints2, 'Method', 'RANSAC', ...
      'NumTrials', 10000, 'DistanceThreshold', 0.1, 'Confidence', 99.99);

    if status ~= 0 || isEpipoleInImage(fMatrix, size(I1)) ...
      || isEpipoleInImage(fMatrix', size(I2))
      error(['Either not enough matching points were found or '...
             'the epipoles are inside the images. You may need to '...
             'inspect and improve the quality of detected features ',...
             'and/or improve the quality of your images.']);
    end

    inlierPoints1 = matchedPoints1(epipolarInliers, :);
    inlierPoints2 = matchedPoints2(epipolarInliers, :);

    if show
        figure;
        showMatchedFeatures(I1, I2, inlierPoints1, inlierPoints2);
        legend('Inlier points in I1', 'Inlier points in I2');
    end
    [t1, t2] = estimateUncalibratedRectification(fMatrix, inlierPoints1.Location, inlierPoints2.Location, size(I2));
    tform1 = projective2d(t1);
    tform2 = projective2d(t2);
end

