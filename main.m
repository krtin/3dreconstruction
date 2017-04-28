%Image path to read images from
image_path = dir('data/mcgillarts/*.jpg');

%directory
imagefolder=fullfile(cd,'data/mcgillarts');
out_file = 'output/mcgillarts';
savebool = 1;

%extrinsic parameters for each image/camera
cam_extrinsic = getCamExtrinsic(image_path,imagefolder);


%color labels for camera
col_label=['y','m','c','r','g','b','w','k'];

%merge points clouds
pointCloudGlobal = mergePointClouds( imagefolder, cam_extrinsic,col_label );

if(savebool)
   pcwrite(pointCloudGlobal,strcat(out_file,'.pcd')); 
   save(strcat(out_file,'.mat'),'cam_extrinsic');
end

%plot point clouds
plotptCloud(pointCloudGlobal,cam_extrinsic,col_label );
