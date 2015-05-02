%creates cartesian product of nx3 matrix of points A =  [id x y]
%and mx1 column vector T = [t]
% example A= [1 2 3; 4 5 6]
% t = [ 0.1 0.2 0.3]
% res = [1 0.1 2 3 ; 1 2 3 0.2; 1 2 3 0.3; 4 5 6 0.1; 4 5 6 0.2; 4 5 6 0.3 ]
%
% res in format [ix t x y]
function res = cartprod3(A,t)
    [ID T] = meshgrid(A(:,1), t');
    [X T] = meshgrid(A(:,2), t');
    [Y T] = meshgrid(A(:,3), t');
    res = [ID(:) T(:) X(:) Y(:)];
end