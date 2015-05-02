scale = 0.1
[D map] = fileParse('pm25_2009_measured.txt','day',scale);
tic
r = LOOCV_i(D(:,2:5),1,'2D');
toc
r
