out_file = 'output/home_desk2';
%color labels for camera
col_label=['y','m','c','r','g','b','w','k'];

ptcloud=pcread(strcat(out_file,'.pcd')); 
load(strcat(out_file,'.mat'));

plotptCloud(pointCloudGlobal,cam_extrinsic,col_label );