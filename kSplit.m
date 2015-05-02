scale = 1;
[D map] = fileParse('pm25_2009_measured.txt','day',scale);


U = unique(D(:,3:4),'rows');

k = 10;

k_smart = kSplitSmart(U,k);
k_smart_measure = kSplitMeasure(U,k_smart)
kSplitWrite(D,[U k_smart'],'LocAwareCV');
%ksplitPlot(D,[U k_smart']);

k_random = kSplitRandom(U,k);
K_random_measure = kSplitMeasure(U,k_random)
kSplitWrite(D,[U k_random'],'random');
%ksplitPlot(D,[U k_random']);



