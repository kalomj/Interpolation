%scale = logspace(-1,0,10)
%scale = 0.1:0.1:1
%scale = 0.01:0.005:1.4
scale = logspace(-4,1,150)
%scale = [0.1 0.2];
tic
%V = grapherror(sprintf('%s\\CV',pwd),scale, '3D');
V = grapherror(sprintf('%s\\LocAwareCV',pwd),scale, '3D');
toc

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

%save to 
file = sprintf('stats_%f.txt',cputime)
%write to file 
dlmwrite(file,[scale' V],'delimiter','\t','precision',12); 

[M,I] = min(V);

scale_corresponding_to_minima_per_error_statistic = scale(I)'
minima_per_error_statistic = M'

[M,I] = max(V);

scale_corresponding_to_maxima_per_error_statistic = scale(I)'
maxima_per_error_statistic = M'

