% given a file path for an input file, in a tab seperated 
% format returned by LOOCV.m
%
% Example:
% number	t	lng	lat	pm25_measured pm25_interpolated
%
% Return error statistics
% [mae mse rmse mare msre rmsre mape mspe rmspe NanCount]
% error statistics are defined in errperf.m
% NanCount is the number of points that couldn't be interpolated due to
% being ourside of the convex hull of the triangulation, or in the case of
% the reduction method, not having bounding time based measurements at a
% specific locations
function [mae mse rmse mare msre rmsre mape mspe rmspe NanCount] = LOOCVStats(filepath)

    inputTable = importdata(filepath,'\t',1);
    A = inputTable.data;
    
    NanCount = size(A(isnan(A(:,6))),1);
    
    %filter out NaN before calculating error statistics
    B = A(~isnan(A(:,6)),:);
    
    T = B(:,5);
    P = B(:,6);
    
    mae = errperf(T,P,'mae');
    mse = errperf(T,P,'mse');
    rmse = errperf(T,P,'rmse');
    mare = errperf(T,P,'mare');
    msre = errperf(T,P,'msre');
    rmsre = errperf(T,P,'rmsre');
    mape = errperf(T,P,'mape');
    mspe = errperf(T,P,'mspe');
    rmspe = errperf(T,P,'rmspe');
    
end