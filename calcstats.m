% given 
% an input directory path containing 10 files resulting from tenfold.m
%
% function will write out a file error_statistics_sf.txt
% pursuant to Part 6 of the assignment
%
% will also return res in the format [avg_mae avg_mse avg_rmse avg_mare avg_msre avg_rmsre]
% 
% all other internal details concerning file names and formats are by
% convention based on the format written by tenfold.m
%
function res = calcstats(path)
    
    %set up error vectors
    mae = zeros(10,1);
    mse = zeros(10,1);
    rmse = zeros(10,1);
    mare = zeros(10,1);
    msre = zeros(10,1);
    rmsre = zeros(10,1);

    %iterate through all directories
    for i = 1:10
       
        %parse file
         F = importdata(sprintf('%s\\10foldcv_sf_fold%d.txt',path,i),'\t');
         
         %set up input vectors for errperf, remove NaN from interpolated
         %results
         v_idx = find(~isnan(F(:,2)));
         T = F(v_idx,1);
         P = F(v_idx,2);

         mae(i) = errperf(T,P,'mae');
         mse(i) = errperf(T,P,'mse');
         rmse(i) = errperf(T,P,'rmse');
         mare(i) = errperf(T,P,'mare');
         msre(i) = errperf(T,P,'msre');
         rmsre(i) = errperf(T,P,'rmsre');
         
    end
    
    res = [mean(mae) mean(mse) mean(rmse) mean(mare) mean(msre) mean(rmsre)];
    
    %write to file 
    dlmwrite(sprintf('%s\\error_statistics_sf.txt',path),res,'delimiter','\t','precision',12); 

end