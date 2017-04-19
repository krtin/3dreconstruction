load 'data/cameraparams.mat';
img_dir = 'data/library';

%read two images
I1 = imread(strcat(img_dir,'/1.JPG'));
I2 = imread(strcat(img_dir,'/2.JPG'));

%undistort images
[I1,I2]=undistortedImage(I1,I2,cameraParams,0);

%find corresponding points
[matched1,matched2] = findSURFfeatures( I1,I2, 0 );

%get orientation and location
[orient, loc ] = getLocOrientation( matched1, matched2, I1, I2, cameraParams, 0 );

%stereoparams
stereoParams = stereoParameters(cameraParams,cameraParams,orient,loc);

%rectify
[J1,J2] = rectifyStereoImages(I1,I2,stereoParams);

imwrite(J1,'image1.jpg');
imwrite(J2,'image2.jpg');
%imshowpair(J1,J2,'montage');

%{
disparityrange = [-32 32];
disparityMap = disparity(rgb2gray(J1),rgb2gray(J2),'BlockSize',15,'DisparityRange',disparityrange);

figure
imshow(disparityMap,disparityrange);
colormap jet
colorbar
%}

disparityMap = disparity(rgb2gray(J1), rgb2gray(J2));
%figure
%imshow(disparityMap,[0,64],'InitialMagnification',50);

xyzPoints = reconstructScene(disparityMap,stereoParams);

%{
X = xyzPoints(:,:,1);
Y = xyzPoints(:,:,2);
Z = xyzPoints(:,:,3);

R = J1(:,:,1);
G = J1(:,:,2);
B = J1(:,:,3);
C = [R(:) G(:) B(:)];
%}
ptcloud = pointCloud(xyzPoints,'Color',J1);

pcshow(ptcloud);




%ptCloud = getpointCloud( I1, I2 , orient, loc, cameraParams );


%plotptCloud( pointCloud, orient, loc );