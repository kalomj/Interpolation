Y = [2009:2010]';
year_format = convertDate(Y,'year', .1)

Q = [1:4]';

[Ygrid Qgrid] = meshgrid(Y, Q);
%YQ is the years 2009 through 2010 in column 1, with each quarter
%in column 2 denoted with a number 1:4
YQ = [Ygrid(:) Qgrid(:)];
quarter_format = convertDate(YQ,'quarter', .2)

M =[1:12]';

[Ygrid Mgrid] = meshgrid(Y, M);
YM = [Ygrid(:) Mgrid(:)];
month_format = convertDate(YM,'month', .5)

D = [1:28];

%this only does the first 28 days of each month to test the funciton, so
%some days are skipped.
YD = cartprod(YM, D);

day_format = convertDate(YD,'day', 2);

first10_day_format = day_format(1:10)

%test using assignment file
s = cputime;
inputTable = importdata('pm25_2009_measured.txt','\t',1);
inputMatrix = inputTable.data;
datenum_vector = convertDate(inputMatrix(:,2:4),'day',.1);
outputMatrix = [inputMatrix(:,1) datenum_vector inputMatrix(:,5:end)];
first10_outputMatrix = outputMatrix(1:10,:)
total_time= cputime - s
