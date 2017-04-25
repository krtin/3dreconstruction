function cameraParams = spawnCameraParam(imageFileName)
%defined for iphone 5s,6,6s
exif=imfinfo(imageFileName);
exifDigitalCamera=exif.DigitalCamera;

%F of the camera
focalLength=exifDigitalCamera.FocalLength;

%dimensions mentioned in mm
sensorWidth=4.80;
sensorHeight=3.60;


%pixels per mm in x direction and y direction
sx=exifDigitalCamera.CPixelXDimension/sensorWidth;
sy=exifDigitalCamera.CPixelYDimension/sensorHeight;

%computing fx and fy
fx=focalLength*sx;
fy=focalLength*sy;

%shear parameter
s=0;

%center offset for camera
cx=sensorWidth/2;
cy=sensorHeight/2;

%define the intrinsic matrix
intrinsicMat=[fx 0 0;s fy 0;cx cy 1];

cameraParams = cameraParameters('IntrinsicMatrix',intrinsicMat);
end