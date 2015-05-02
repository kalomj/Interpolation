%scale = logspace(-1,0,10)
%scale = 0.1:0.1:1
%scale = 0.01:0.005:1.4
scale = logspace(-10,10,250)
%scale = [0.1 0.2];
tic
V = grapherror(sprintf('%s\\LocAwareCV',pwd),scale, '3D');
toc

%plot all statistics
for i = 1:9
    subplot(3,3,i);
    %linear scale plot
    %plot(scale,V(:,i));
    %logrithmic scale plot
    semilogx(scale,V(:,i));
end


%write to file 
dlmwrite(sprintf('stats_%f.txt',cputime),[scale' V],'delimiter','\t','precision',12); 

[M,I] = min(V);

scale_corresponding_to_minima_per_error_statistic = scale(I)'
