function m = kSplitMeasure( I, K )
%KSPLITMEASURE Calculate a measure of spatial dispersion given a matrix and
% a vector representing how the matrix is split into k partitions
%   I is an input matrix, K is a vector representing the partition that
%   each row belongs, m is the average of spatial dispersion measures
%   applied to each of the k partitions

    for ix = 1:max(K)
        sd(ix) = sdMeasure(I(K'==ix,:));
    end
    m = mean(sd);
end

