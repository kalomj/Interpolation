%creates cartesian product of nx2 matrix of points A =  [x y]
%and mx1 column vector T = [t]
% example A= [1 2; 3 4]
% t = [ 0.1 0.2 0.3]
% res = [1 2 0.1; 1 2 0.2; 1 2 0.3; 3 4 0.1; 3 4 0.2; 3 4 0.3 ]
%
function res = cartprod(A,t)
    [X T] = meshgrid(A(:,1), t');
    [Y T] = meshgrid(A(:,2), t');
    res = [X(:) Y(:) T(:)];
end