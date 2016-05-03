path = pwd;
filename = 'extension_data_scale_02705_incremental.txt';

[mae mse rmse mare msre rmsre mape mspe rmspe NanCount] = LOOCVStats(sprintf('%s/%s',path,filename))