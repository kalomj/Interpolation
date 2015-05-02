% given 
% a matrix A in format [t x y w] representing known data
% a matrix B in format [t x y] representing points to interpolate
%
% return a matrix res in format [t x y w] with the same number of rows of 
% B and with w representing interpolated values
function res = interpolate(A,B)
    if(size(A) ~= 4)
       error('Matrix A should be in format [t x y w]'); 
    end
    if(size(B) ~= 3)
       error('Matrix B should bi in format [t x y]'); 
    end
    res = zeros(size(B,1),4);
    dtMesh = delaunayTriangulation(A(:,1:3));
    pl = dtMesh.pointLocation(B);
    pl(isnan(pl)) = 1;
    tet = dtMesh.ConnectivityList(pl, :);
    
    onesPadding = ones(4,1);
      
    for i = 1:size(pl,1) 
    %for i = 1:10000
        locPoint = B(i,:);
        vertexIDs = tet(i,:);
        points = dtMesh.Points(vertexIDs, :);
        majorMatrix = [onesPadding  points];
        majorDet = det(majorMatrix);
        
        %coefMatrix = calcAllCofactors(majorMatrix);
        C = inv(majorMatrix')*det(majorMatrix);
        
        %a1 = C(1,1);
        %b1 = C(1,2);
        %c1 = C(1,3);
        %d1 = C(1,4);

        %a2 = C(2,1);
        %b2 = C(2,2);
        %c2 = C(2,3);
        %d2 = C(2,4);

        %a3 = C(3,1);
        %b3 = C(3,2);
        %c3 = C(3,3);
        %d3 = C(3,4);

        %a4 = C(4,1);
        %b4 = C(4,2);
        %c4 = C(4,3);
        %d4 = C(4,4);

        %N1 = (a1 + b1*locPoint(1,1) + c1*locPoint(1,2) + d1*locPoint(1,3))/majorDet;
        %N2 = (a2 + b2*locPoint(1,1) + c2*locPoint(1,2) + d2*locPoint(1,3))/majorDet;
        %N3 = (a3 + b3*locPoint(1,1) + c3*locPoint(1,2) + d3*locPoint(1,3))/majorDet;
        %N4 = (a4 + b4*locPoint(1,1) + c4*locPoint(1,2) + d4*locPoint(1,3))/majorDet;
        
        N = (C(:,1) + C(:,2) * locPoint(1) + C(:,3) * locPoint(2) + C(:,4) * locPoint(3))/majorDet;
        
        %locPointVal = N1*w1 + N2*w2 + N3*w3 + N4*w4;
        locPointVal = A(vertexIDs,4)' * N;
        res(i,:) = [locPoint locPointVal];
    end 
end