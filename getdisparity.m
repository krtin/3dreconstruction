function [ disparityMap ] = getdisparity( I1, I2 , show)
%GETDISPARITY Summary of this function goes here
%   Detailed explanation goes here
    I1gray = rgb2gray(I1);
    I2gray = rgb2gray(I2);
    disparityMap = disparity(I2gray, I1gray);
    if show
        figure;
        imshow(disparityMap, [0, 64]);
        title('Disparity Map');
        colormap jet
        colorbar
    end

end

