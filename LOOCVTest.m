scale = 0.1086
[D map] = fileParse('pm25_2009_measured.txt','day',scale);


res = LOOCV(D(:,2:5),'reduction_data_scale_01086_endpoints_are_average.txt','2D');




