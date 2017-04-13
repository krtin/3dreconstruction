function [ out ] = plotptCloud( ptCloud, orient, loc )
%PLOTPTCLOUD Summary of this function goes here
%   Detailed explanation goes here

    % Visualize the camera locations and orientations
    cameraSize = 0.3;
    figure
    plotCamera('Size', cameraSize, 'Color', 'r', 'Label', '1', 'Opacity', 0);
    hold on
    grid on
    plotCamera('Location', loc, 'Orientation', orient, 'Size', cameraSize,'Color', 'b', 'Label', '2', 'Opacity', 0);

    % Visualize the point cloud
    pcshow(ptCloud, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', 'MarkerSize', 45);

    % Rotate and zoom the plot
    camorbit(0, -30);
    camzoom(1.5);

    % Label the axes
    xlabel('x-axis');
    ylabel('y-axis');
    zlabel('z-axis')

    title('Up to Scale Reconstruction of the Scene');
    out=1;
end

