function plotptCloud( pointCloudGlobal, cam_extrinsic, col_label )
    noof_images = size(cam_extrinsic.ViewId,1);
    figure;
    % Visualize the point cloud
    pcshow(pointCloudGlobal, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
        'MarkerSize', 5);
    hold on;
    %Plot the last camera
    for i = 1:noof_images
    plotCamera('Location', cam_extrinsic.Location{i}, 'Orientation', cam_extrinsic.Orientation{i}, 'Size', 0.2,'Color', col_label(mod(i,8)), 'Label', num2str(i), 'Opacity', 0);
    hold on;
    end
    %plot the axis and other stuff
    % Rotate and zoom the plot
    camorbit(0, -30);
    camzoom(1.5);

    % Label the axes
    xlabel('x-axis');
    ylabel('y-axis');
    zlabel('z-axis')

    title('3D Reconstruction from multiple 2D Images');
end

