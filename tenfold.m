% given 
% an input directory path containing 10 directories like fold1, fold2 ... fold10
% a multiplicative scale
%
% function will write out 10 files in the format [original interpolated]
% pursuant to Part 5 of the assignment
% 
% all other internal details concerning file names and formats are by
% convention based on the format of provided sample files and directories.
function tenfold(path, scale)

    %iterate through all directories
    for i = 1:10
       
        %parse all files
        fpath = sprintf('%s\\fold%d',path,i);
        stsample = importdata(sprintf('%s\\st_sample.txt',fpath),'\t');
        sttest = importdata(sprintf('%s\\st_test.txt',fpath),'\t');
        vsample = importdata(sprintf('%s\\value_sample.txt',fpath),'\t');
        vtest = importdata(sprintf('%s\\value_test.txt',fpath),'\t');
        
        %convert time to proper scale
        stsample(:,3) = (stsample(:,3) - min(stsample(:,3))) .* scale;
        sttest(:,3) = (sttest(:,3) - min(sttest(:,3))) .* scale;
        
        %rearrange columns to [t x w y]
        sample_txyw = [stsample(:,3) stsample(:,1:2) vsample];
        test_txyw = [sttest(:,3) sttest(:,1:2) vtest];
        
        %interpolate points
        txyw = interpolate(sample_txyw,test_txyw(:,1:3));
        
        % create matrix in format [original interpolated]
        O = [test_txyw(:,4) txyw(:,4)];
        
        %write to file 
        dlmwrite(sprintf('%s\\10foldcv_sf_fold%d.txt',path,i),O,'delimiter','\t','precision',12); 
        
    end
        
end