% given 
% a matrix A in format [t x y w] representing known data
%
% an integer i between 1 and size(A,1)
%
% a interoplation type ('2D' or '3D' for reduction and extention methods,
% respectively
%
% return the value of the interpolation at point i when it is left out of
% the triangulation and subsequently has the value interpolated
%
function res = LOOCV_i(A, i, type)

    % slice row i out of the array to create the sample data
    sample_txyw = A([1:i-1,i+1:end],:);
    
    % copy row i to a new matrix to use as the test point
    test_txyw = A(i,:);
    
    %interpolate points
    if type == '2D'
        txyw = interpolate2D(sample_txyw,test_txyw(:,1:3));
    elseif type == '3D'
        txyw = interpolate(sample_txyw,test_txyw(:,1:3));
    else
        error('Interpolation type must be 2D or 3D');
    end

    % create matrix in format [i t x w original interpolated]
    res = [i test_txyw txyw(:,4)];
       
end