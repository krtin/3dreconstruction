video_path='data/trottier.MOV';
impersec=1/2;
%Get Images from video
%images = getImages(videopath,impersec);

I1 = imread('data/image1.JPG');
I2 = imread('data/image2.JPG');
[matched1,matched2] = findSURFfeatures( I1,I2,0 );
[ tform1, tform2 ] = getTransformations( matched1, matched2, I1, I2, 0 );
[ I2Rect, I1Rect ] = rectify(I1, I2, tform1, tform2, 0);
disparityMap = getdisparity(I1Rect, I2Rect,1);
%pointcloud( disparityMap, I2Rect )