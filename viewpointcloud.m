out_file = 'output/library';

ptcloud=pcread(strcat(out_file,'.pcd')); 
load(strcat(out_file,'.mat'));

plotptCloud( ptcloud, orient, loc );