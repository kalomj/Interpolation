% given 
% an input directory path containing 10 directories like fold1, fold2 ... fold10
% a vector of multiplicative scales
% an optional interpolation type : ('2D' or '3D' for reduction and
% extension methods, respectively
%
% function will return a matrix of error statistics that can be plotted
% res is in the format [[mean(mae) mean(mse) mean(rmse) mean(mare) mean(msre) mean(rmsre)]
% one row per entry in scale_i vector, e.g. max(size(scale_i)) == size(V,1)
%
% all other internal details concerning file names and formats are by
% convention based on the format of provided sample files and directories.
function res = grapherror(path, scale_i, interp_type)
    
    if nargin == 2
        interp_type = '3D';
    end

    %set up error vectors
    mae = zeros(10,max(size(scale_i)));
    mse = zeros(10,max(size(scale_i)));
    rmse = zeros(10,max(size(scale_i)));
    mare = zeros(10,max(size(scale_i)));
    msre = zeros(10,max(size(scale_i)));
    rmsre = zeros(10,max(size(scale_i)));
    mape = zeros(10,max(size(scale_i)));
    mspe = zeros(10,max(size(scale_i)));
    rmspe = zeros(10,max(size(scale_i)));
    
    %set up result to store error vector for each scale required
    res = zeros(max(size(scale_i)),9);

    %iterate through all directories
    for i = 1:10
       i
        %parse all files
        fpath = sprintf('%s\\fold%d',path,i);
        stsample = importdata(sprintf('%s\\st_sample.txt',fpath),'\t');
        sttest = importdata(sprintf('%s\\st_test.txt',fpath),'\t');
        vsample = importdata(sprintf('%s\\value_sample.txt',fpath),'\t');
        vtest = importdata(sprintf('%s\\value_test.txt',fpath),'\t');

        for j = 1:max(size(scale_i))
            j
            stsample_c = stsample;
            sttest_c = sttest;
            
            scale = scale_i(j);
            
            %convert time to proper scale
            stsample_c(:,3) = (stsample(:,3) - min(stsample(:,3))) .* scale;
            sttest_c(:,3) = (sttest(:,3) - min(sttest(:,3))) .* scale;

            %rearrange columns to [t x w y]
            sample_txyw = [stsample_c(:,3) stsample_c(:,1:2) vsample];
            test_txyw = [sttest_c(:,3) sttest_c(:,1:2) vtest];

            %interpolate points
            if strcmp(interp_type,'2D')
                txyw = interpolate2D(sample_txyw,test_txyw(:,1:3));
            else
                txyw = interpolate(sample_txyw,test_txyw(:,1:3));
            end

            % create matrix in format [original interpolated]
            O = [test_txyw(:,4) txyw(:,4)];  
                       
             %set up input vectors for errperf, remove NaN from interpolated
             %results
             v_idx = find(~isnan(O(:,2)));
             T = O(v_idx,1);
             P = O(v_idx,2);

             mae(i,j) = errperf(T,P,'mae');
             mse(i,j) = errperf(T,P,'mse');
             rmse(i,j) = errperf(T,P,'rmse');
             mare(i,j) = errperf(T,P,'mare');
             msre(i,j) = errperf(T,P,'msre');
             rmsre(i,j) = errperf(T,P,'rmsre');
             mape(i,j) = errperf(T,P,'mape');
             mspe(i,j) = errperf(T,P,'mspe');
             rmspe(i,j) = errperf(T,P,'rmspe');
        end
    end    
    
    for j = 1:max(size(scale_i))
        res(j,:) = [mean(mae(:,j)) mean(mse(:,j)) mean(rmse(:,j)) mean(mare(:,j)) mean(msre(:,j)) mean(rmsre(:,j)) mean(mape(:,j)) mean(mspe(:,j)) mean(rmspe(:,j))];
    end
end