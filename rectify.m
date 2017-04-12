function [ I1Rect, I2Rect ] = rectify( I1, I2, tform1, tform2, show )
%RECTIFY Summary of this function goes here
%   Detailed explanation goes here

    [I2Rect, I1Rect] = rectifyStereoImages(I2, I1, tform1, tform2);
    if show
        figure;
        imshow(stereoAnaglyph(I1Rect, I2Rect));
        title('Rectified Video Frames');
    end
end

