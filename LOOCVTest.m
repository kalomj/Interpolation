scale = 0.1
[D map] = fileParse('pm25_2009_measured.txt','day',scale);

tic
res = LOOCV(D(:,2:5),'none','2D');
toc


