path = pwd;
filename = 'reduction_data_scale_01086_endpoint_not_handled.txt';

[mae mse rmse mare msre rmsre mape mspe rmspe NanCount] = LOOCVStats(sprintf('%s/%s',path,filename))