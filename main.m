load 'data/cameraparams.mat';
img_dir = 'data/library';
file1 = strcat(img_dir,'/1.JPG');
file2 = strcat(img_dir,'/2.JPG');
out_file = 'output/library';

%read two images
I1 = imread(file1);
I2 = imread(file2);

%prepare camera params
cameraParams1 = spawnCameraParam(file1);
cameraParams2 = spawnCameraParam(file2);

%undistort images
[I1,I2]=undistortedImage(I1,I2,cameraParams1,cameraParams2,0);

%find corresponding points
%[matched1,matched2] = findSURFfeatures(I1,I2, 0 );
[matched1,matched2] = getMatchedPoints(I1, I2);

%get orientation and location
%[orient, loc ] = getLocOrientation( matched1, matched2, I1, I2, cameraParams1, cameraParams2, 0 );
[orient, loc ] = myLocOrientation( matched1, matched2, I1, I2, cameraParams1, cameraParams2, 0 );


%stereoparams
%stereoParams = stereoParameters(cameraParams,cameraParams,orient,loc);

%rectify
%[J1,J2] = rectifyStereoImages(I1,I2,stereoParams);

%imwrite(J1,'image1.jpg');
%imwrite(J2,'image2.jpg');
%{
disparityrange = [-256 256];
disparityMap = disparity(rgb2gray(J1),rgb2gray(J2),'BlockSize',15,'DisparityRange',disparityrange);
%disparityMap = disparity(rgb2gray(J1),rgb2gray(J2));

%figure
%imshow(disparityMap,disparityrange);

xyzPoints = reconstructScene(disparityMap,stereoParams);

ptcloud = pointCloud(xyzPoints,'Color',J1);
%}

ptcloud = getpointCloud( I1, I2 , orient, loc, cameraParams1, cameraParams2 );

if(save)
   pcwrite(ptcloud,strcat(out_file,'.pcd')); 
   save(strcat(out_file,'.mat'),'orient','loc');
end

plotptCloud( ptcloud, orient, loc );



