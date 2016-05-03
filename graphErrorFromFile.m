


%rawstatsfile = 'rawstats_3d_locaware_-4_1.txt';
%rawstatsfile = 'rawstats_3d_locaware_-10_10_250.txt';
%rawstatsfile = 'rawstats_3d_random_-2_1.txt';
%rawstatsfile = 'rawstats_3d_random_-5_1.txt';
rawstatsfile = 'rawstats_3d_random_-4_1.txt';
%rawstatsfile = 'rawstats_2d_random_-2_1.txt';

V = importdata(rawstatsfile,'\t',1);
V = V.data;
scale = V(:,1);
V = V(:,2:10);

labels = {'MAE','MSE','RMSE','MARE','MSRE','RMSRE','MAPE','MSPE','RMSPE'};

%plot all statistics
for i = 1:9
    subplot(3,3,i);
    %linear scale plot
    %plot(scale,V(:,i));
    %logrithmic scale plot
    semilogx(scale,V(:,i));

    title(strcat(labels{i}, ' Error Plot'));
    xlabel('Time Scale') % x-axis label
    ylabel(labels{i}) % y-axis label
 
end



[M,I] = min(V);

scale_corresponding_to_minima_per_error_statistic = scale(I)
minima_per_error_statistic = M'

[M,I] = max(V);

scale_corresponding_to_maxima_per_error_statistic = scale(I)
maxima_per_error_statistic = M'