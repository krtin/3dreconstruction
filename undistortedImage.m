function [ I1,I2 ] = undistortedImage( I1,I2,cameraParams1,cameraParams2,show )
%UNDISTORTIMAGE Summary of this function goes here
%   Detailed explanation goes here

    %remove distortion
    I1 = undistortImage(I1, cameraParams1);
    I2 = undistortImage(I2, cameraParams2);
        
    if show
        figure
        imshowpair(I1, I2, 'montage');
        title('Undistorted Images');
    end
end

