function pntCld=getpointCloud(fileName1,fileName2,Loc1,Orient1,Loc2,Orient2,color1,color2,label)
I1 = imread(fileName1);
I2 = imread(fileName2);


%intialise camera params for cameras
cameraParams1=spawnCameraParam(fileName1);
cameraParams2=spawnCameraParam(fileName2);

% Estimate the fundamental matrix
%[E, epipolarInliers] = estimateEssentialMatrix(...
%    matchedPoints1, matchedPoints2, cameraParams1,cameraParams2, 'Confidence', 75);

% Find epipolar inliers
%inlierPoints1 = matchedPoints1(epipolarInliers, :);
%inlierPoints2 = matchedPoints2(epipolarInliers, :);

%[relOrient, relLoc] = relativeCameraPose(E, cameraParams1,cameraParams2, inlierPoints1, inlierPoints2);

% Detect dense feature points. Use an ROI to exclude points close to the
% image edges.
roi = [30, 30, size(I1, 2) - 30, size(I1, 1) - 30];
imagePoints1 = detectMinEigenFeatures(rgb2gray(I1), 'ROI', roi, 'MinQuality', 0.0001);

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
[R1, t1] = cameraPoseToExtrinsics(Orient1,Loc1);
camMatrix1 = cameraMatrix(cameraParams1, R1, t1);

% Compute extrinsics of the second camera
[R2, t2] = cameraPoseToExtrinsics(Orient2,Loc2);
camMatrix2 = cameraMatrix(cameraParams2, R2, t2);

%rotationOfCamera2=R1'*R2;
%translationOfCamera2=t2-t1;
%stereoParams = stereoParameters(cameraParams1,cameraParams2,rotationOfCamera2,translationOfCamera2)

% Compute the 3-D points
points3D = triangulate(matchedPoints1, matchedPoints2,camMatrix1,camMatrix2);

% Get the color of each reconstructed point
numPixels = size(I1, 1) * size(I1, 2);
allColors = reshape(I1, [numPixels, 3]);
colorIdx = sub2ind([size(I1, 1), size(I1, 2)], round(matchedPoints1(:,2)), ...
    round(matchedPoints1(:, 1)));
color = allColors(colorIdx, :);


% Create the point cloud
pntCld = pointCloud(points3D, 'Color', color);

figure;
%Display the 3-D Point Cloud
%Use the plotCamera function to visualize the locations and orientations of the camera, and the pcshow function to visualize the point cloud.
pcshow(pntCld, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
    'MarkerSize', 5);
hold on;
% Visualize the camera locations and orientations
plotCamera('Location', Loc1, 'Orientation', Orient1, 'Size', 0.2,'Color', color1, 'Label', num2str(label), 'Opacity', 0);
plotCamera('Location', Loc2, 'Orientation', Orient2, 'Size', 0.2,'Color', color2, 'Label', num2str(label+1), 'Opacity', 0);
title(num2str(label));

end