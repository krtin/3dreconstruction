function [ out ] = pointcloud( disparityMap, I2 )
%POINTCLOUD Summary of this function goes here
%   Detailed explanation goes here
    points3D = reconstructScene(disparityMap, stereoParams);

    % Convert to meters and create a pointCloud object
    points3D = points3D ./ 1000;
    ptCloud = pointCloud(points3D, 'Color', I2);

    % Create a streaming point cloud viewer
    player3D = pcplayer([-3, 3], [-3, 3], [0, 8], 'VerticalAxis', 'y', ...
        'VerticalAxisDir', 'down');

    % Visualize the point cloud
    view(player3D, ptCloud);
    out=1;

end

