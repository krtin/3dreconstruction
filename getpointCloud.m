function [ ptCloud ] = getpointCloud( I1, I2 , orient, loc, cameraParams1, cameraParams2 )
%GETDISPARITY Summary of this function goes here
%   Detailed explanation goes here
% Detect dense feature points. Use an ROI to exclude points close to the
% image edges.
    roi = [30, 30, size(I1, 2) - 30, size(I1, 1) - 30];
    imagePoints1 = detectMinEigenFeatures(rgb2gray(I1), 'ROI', roi, ...
        'MinQuality', 0.00001);

    % Create the point tracker
    tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 5);

    % Initialize the point tracker
    imagePoints1 = imagePoints1.Location;
    initialize(tracker, imagePoints1, I1);

    % Track the points
    [imagePoints2, validIdx] = step(tracker, I2);
    matchedPoints1 = imagePoints1(validIdx, :);
    matchedPoints2 = imagePoints2(validIdx, :);

    % Compute the camera matrices for each position of the camera
    % The first camera is at the origin looking along the Z-axis. Thus, its
    % rotation matrix is identity, and its translation vector is 0.
    camMatrix1 = cameraMatrix(cameraParams1, eye(3), [0 0 0]);

    % Compute extrinsics of the second camera
    [R, t] = cameraPoseToExtrinsics(orient, loc);
    camMatrix2 = cameraMatrix(cameraParams2, R, t);

    % Compute the 3-D points
    points3D = triangulate(matchedPoints1, matchedPoints2, camMatrix1, camMatrix2);

    % Get the color of each reconstructed point
    numPixels = size(I1, 1) * size(I1, 2);
    allColors = reshape(I1, [numPixels, 3]);
    colorIdx = sub2ind([size(I1, 1), size(I1, 2)], round(matchedPoints1(:,2)), ...
        round(matchedPoints1(:, 1)));
    color = allColors(colorIdx, :);

    % Create the point cloud
    ptCloud = pointCloud(points3D, 'Color', color);
end

