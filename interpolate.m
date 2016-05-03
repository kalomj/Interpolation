% given 
% a matrix A in format [t x y w] representing known data
% a matrix B in format [t x y] representing points to interpolate
%
% return a matrix res in format [t x y w] with the same number of rows of 
% B and with w representing interpolated values
%
% if interpolated point is not in the convex hull of the mesh, the row is
% returned as [t x y NaN]
function [res, dtMesh] = interpolate(A,B, dtMesh)
    if(size(A,2) ~= 4)
       error('Matrix A should be in format [t x y w]'); 
    end
    if(size(B,2) ~= 3)
       error('Matrix B should bi in format [t x y]'); 
    end
    res = zeros(size(B,1),4);
	
    %only do triangulation if it is not provided
    if nargin == 2
        dtMesh = delaunayTriangulation(A(:,1:3));
    end
	
	% pl are the coordinates of the vertex containing the query point 
	% bc is the barycentric coordinates at each vertex with respect to the query point
    [pl,bc] = dtMesh.pointLocation(B);
    
    %deal with nulls by creating a vector which is true if value is null to
    %use in the for loop test. Then set rows with nan to an actual index to
    %allow the connectivity list to be same sized as the input data set
    skipnan = isnan(pl);
	num_skips = sum(skipnan);
    pl(isnan(pl)) = 1;
	
	%extract values from A
	V = A(:,4);
	
	%triVals looks like pl, but instead of indexes of each vertex of the containing simplex
	%it contains the value measured at each vertex of the simplex
	triVals = V(dtMesh(pl,:));
	
	%dot product of the barycentric coordinates and the vertex values
	%is equivalent to the shape function calculation
	Vq = dot(bc',triVals')'; 
	Vq(isnan(pl)) = NaN;
	res = [B Vq];
	
	%this entire function can be replaced with griddata and produce equivalent results
	%tic
	%z = griddata(A(:,1),A(:,2),A(:,3),A(:,4),B(:,1),B(:,2),B(:,3));
	%toc
end