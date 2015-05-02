
scale = 0.1
[D map] = fileParse('pm25_2009_measured.txt','day',scale);


%create id t x y matrix of values to interpolate
U = unique(D(:,2));
A = importdata('county_xy.txt','\t',1);
P = A.data;
idtxy = cartprod3(P,U);

%call interpolate2D function
disp('timing reduction method')
tic
res = interpolate2D(D(:,2:5),idtxy(:,2:4));
toc

%call interpolate (3D) function
disp('timing extension method')
tic
interpolate(D(:,2:5),idtxy(:,2:4));
toc

