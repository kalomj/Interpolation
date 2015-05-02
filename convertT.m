% given a matrix A in a format like [id t .... ]
%
% tcol, a column number for t
%
% map, a matrix relating a time scale in t to the original time scale
% with format [ t ... ] (possibly in year, quarter, month, or day format)
%
% returns res, which is the original matrix A with column t replaced the
% the original time scale values
%
% Useful for assignment part 3 to write the output data set in the
% requested format
function res = convertT(A,tcol,map)
    [~,idx]=ismember(A(:,tcol),map(:,1));
    % map index 
    c = map(idx,2:end);
    res = [A(:,1:tcol-1) c A(:,tcol+1:end)];
end