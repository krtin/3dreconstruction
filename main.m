load 'data/cameraparams.mat';
img_dir = 'data/home_desk';

%read two images
I1 = imread(strcat(img_dir,'/1.JPG'));
I2 = imread(strcat(img_dir,'/2.JPG'));

%undistort images
[I1,I2]=undistortedImage(I1,I2,cameraParams,0);

%find corresponding points
[matched1,matched2] = findSURFfeatures( I1,I2, 0 );

%[orient, loc ] = getLocOrientation( matched1, matched2, I1, I2, cameraParams, 0 );

%ptCloud = getpointCloud( I1, I2 , orient, loc, cameraParams );


%plotptCloud( ptCloud, orient, loc );