% given 
% a matrix A in format [t x y w] representing known data
% a matrix B in format [t x y] representing points to interpolate
%
% return a matrix res in format [t x y w] with the same number of rows of 
% B and with w representing interpolated values
%
% if interpolated point is not in the convex hull of the mesh, the row is
% returned as [t x y NaN]
function res = interpolate(A,B)
    if(size(A,2) ~= 4)
       error('Matrix A should be in format [t x y w]'); 
    end
    if(size(B,2) ~= 3)
       error('Matrix B should bi in format [t x y]'); 
    end
    res = zeros(size(B,1),4);
	
	tic
    dtMesh = delaunayTriangulation(A(:,1:3));
    pl = dtMesh.pointLocation(B);
	toc
    
    %deal with nulls by creating a vector which is true if value is null to
    %use in the for loop test. Then set rows with nan to an actual index to
    %allow the connectivity list to be same sized as the input data set
    skipnan = isnan(pl);
	num_skips = sum(skipnan)
    pl(isnan(pl)) = 1;
    tet = dtMesh.ConnectivityList(pl, :);
    onesPadding = ones(4,1);
    
	tic
    for i = 1:size(pl,1)
        if(skipnan(i))
            res(i,:) = [B(i,:) NaN];
        else
            points = dtMesh.Points(tet(i,:), :);
            majorMatrix = [onesPadding  points];
            majorDet = det(majorMatrix);
            C = inv(majorMatrix')*det(majorMatrix);
            N = (C(:,1) + C(:,2) * B(i,1) + C(:,3) * B(i,2) + C(:,4) * B(i,3))/majorDet;
            res(i,:) = [B(i,:) A(tet(i,:),4)' * N];
        end
    end 
	toc
end