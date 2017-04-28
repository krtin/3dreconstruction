function ptRes=addPointClouds(ptA,ptB)
% xyzA=ptA.Location;
% xyzB=ptB.Location;
% rgbA=ptA.Color;
% rgbB=ptB.Color;
% xyzRes=[xyzA;xyzB];
% rgbRes=[rgbA;rgbB];
% ptRes=pointCloud(xyzRes,'Color', rgbRes);

gridSize = 0.1;
fixed = pcdownsample(ptA, 'gridAverage', gridSize);
moving = pcdownsample(ptB, 'gridAverage', gridSize);

tform = pcregrigid(moving, fixed, 'Metric','pointToPlane','Extrapolate', true);
ptCloudAligned = pctransform(ptB,tform);

mergeSize = 0.015;
ptRes = pcmerge(ptA, ptCloudAligned, mergeSize);
end