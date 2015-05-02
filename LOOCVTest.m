scale = 0.1
[D map] = fileParse('pm25_2009_measured.txt','day',scale);


res = LOOCV(D(:,2:5),'none','2D');




