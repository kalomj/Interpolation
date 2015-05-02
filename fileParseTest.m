
scale = .01

[D map] = fileParse('pm25_2009_measured.txt','day',scale);
D(1:10,:);

%find all time domain values, already appropriately scaled, at which time
%we want to interpolate data
U = unique(D(:,2));
%load all locations where data should be interpolated
P = load('county_xy.txt');
%x y t triples where we should interpolate
idtxy = cartprod3(P,U);
%show first 800 rows to eyeball data
idtxy(1:800,:);



idymdxy = convertT(idtxy,2,map);