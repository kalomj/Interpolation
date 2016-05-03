scale = 0.2705
[D map] = fileParse('pm25_2009_measured.txt','day',scale);
res = LOOCV_inc(D(:,2:5),'extension_data_scale_02705_incremental.txt');
