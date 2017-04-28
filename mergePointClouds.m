function [ pointCloudGlobal ] = mergePointClouds( imagefolder, cam_extrinsic,col_label )
%MERGEPOINTCLOUDS Summary of this function goes here
%   Detailed explanation goes here
    noof_images = size(cam_extrinsic.ViewId,1);
    %merge point clouds
    for t=1:noof_images-1
    imagefile1=sprintf('%3.3d.jpg',t);
    fullfile1=fullfile(imagefolder,imagefile1);

    imagefile2=sprintf('%3.3d.jpg',t+1);
    fullfile2=fullfile(imagefolder,imagefile2);

    loc1=cam_extrinsic.Location{t};
    orient1=cam_extrinsic.Orientation{t};

    loc2=cam_extrinsic.Location{t+1};
    orient2=cam_extrinsic.Orientation{t+1};
    
    pointCloud=getpointCloud(fullfile1,fullfile2,loc1,orient1,loc2,orient2,col_label(mod(t,8)),col_label(mod(t+1,8)),t);
    if t==1
        pointCloudGlobal=pointCloud;
    else
        pointCloudGlobal=addPointClouds(pointCloudGlobal,pointCloud);
    end

    end

end

