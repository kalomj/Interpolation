%import fold 1 sample data and test data and values
scale = 1;
%parse all files
[D map] = fileParse('pm25_2009_measured.txt','day',scale);
fpath = sprintf('%s\\CV\\fold%d',pwd,1);
sprintf('%s\\st_sample.txt',fpath)
stsample = importdata(sprintf('%s\\st_sample.txt',fpath),'\t');
sttest = importdata(sprintf('%s\\st_test.txt',fpath),'\t');
vsample = importdata(sprintf('%s\\value_sample.txt',fpath),'\t');
vtest = importdata(sprintf('%s\\value_test.txt',fpath),'\t');

%rearrange columns to [t x y w]
sample_txyw = [stsample(:,3) stsample(:,1:2) vsample];
test_txyw = [sttest(:,3) sttest(:,1:2) vtest];

%size(D,1)
%size(unique(D(:,3:4),'rows'),1)
%size(unique(sample_txyw(:,2:3),'rows'),1)
%size(unique(test_txyw(:,2:3),'rows'),1)


%call interpolate2D function
disp('timing reduction method')
tic
txyw = interpolate2D(sample_txyw,test_txyw(:,1:3));
toc


%call interpolate (3D) function
disp('timing extension method')
tic
res = interpolate(sample_txyw,test_txyw(:,1:3));
toc
