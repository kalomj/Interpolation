%{
tic
%writeOutputDataSet('pm25_2009_measured.txt','county_xy.txt','day',0.1,'county_id_t_w.txt');
%writeOutputDataSet('pm25_2009_measured.txt','county_xy.txt','day',0.1,'county_id_t_w.txt','2D');
toc


%O = importdata('county_id_t_w.txt','\t',1);
%O=O.data;
%size(O)

%}

tic
writeOutputDataSet('pm25_2009_measured.txt','blkgrp_xy.txt','day',0.455,'blkgrp_id_t_w.txt');
%writeOutputDataSet('pm25_2009_measured.txt','blkgrp_xy.txt','day',0.455,'blkgrp_id_t_w.txt','2D');
toc

%O = importdata('blkgrp_id_t_w.txt','\t',1);
%O=O.data;
%size(O)



