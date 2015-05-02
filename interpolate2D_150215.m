% given 
% a matrix A in format [t x y w] representing known data
% a matrix B in format [t x y] representing points to interpolate
%
% return a matrix res in format [t x y w] with the same number of rows of 
% B and with w representing interpolated values
%
% if interpolated point is not in the convex hull of the mesh, the row is
% returned as [t x y NaN]
function res = interpolate2D(A,B)
    if(size(A,2) ~= 4)
       error('Matrix A should be in format [t x y w]'); 
    end
    if(size(B,2) ~= 3)
       error('Matrix B should bi in format [t x y]'); 
    end
    res = zeros(size(B,1),4);
	
	%collect only distinct sample points
	D = unique(A(:,2:3),'rows');
	
	%build a cell array relating the index of the distinct point to a matrix containing all of its time/value pairs
	Darray = {};
	for i = 1:size(D,1)
		% this is the rows in A where the coordinates 
		% match the columns in D : A(A(:,2)==D(i,1) & A(:,3)==D(i,2),:)
		% next we sort this by increasing time value 
		% to support efficient processing in later portions of the algorithm
		Apart =  A(A(:,2)==D(i,1) & A(:,3)==D(i,2),:);
		%[values, order] = sort(Apart(:,1));
		%Apart = Apart(order,:);
		DtoA{i} = Apart;
	end
	Apart
	
	tic
    dtMesh = delaunayTriangulation(D);
    pl = dtMesh.pointLocation(B(:,2:3));
    toc
	
    %deal with nulls by creating a vector which is true if value is null to
    %use in the for loop test. Then set rows with nan to an actual index to
    %allow the connectivity list to be same sized as the input data set
    skipnan = isnan(pl);
	num_skips = sum(skipnan)
    pl(isnan(pl)) = 1;
	%tet is the vertices of the points from D defining the triangle containing the sample point
    tet = dtMesh.ConnectivityList(pl, :);
    onesPadding = ones(3,1);
	%count the number of points that could not be interpolated from nearby time values at the same location
    num_continues = 0;
	tic
    for i = 1:size(pl,1)
        if(skipnan(i))
            res(i,:) = [B(i,:) NaN];
        else
			% the points variable is a list of the point 
			% coordinates of the vertices making the containing triangle
            points = dtMesh.Points(tet(i,:), :);
            majorMatrix = [onesPadding  points];
            majorDet = det(majorMatrix);
            C = inv(majorMatrix')*det(majorMatrix);
            N = (C(:,1) + C(:,2) * B(i,2) + C(:,3) * B(i,3))/majorDet;

			t = B(i,1);
			
			Tri1 = DtoA{tet(i,1)}(:,:);

			min1 = min(Tri1(:,1));
			max1 = max(Tri1(:,1));

			if(t<min1 | t>max1)
				res(i,:) = [B(i,:) NaN];
				num_continues=num_continues+1;
				continue;
			else
				t12 = max(Tri1(Tri1(:,1) <= t));
				t11 = min(Tri1(Tri1(:,1) >= t));
				
				if(t12==t11)
					w1 = Tri1(t12 == Tri1(:,1),4);
				else
					w12 = Tri1(t12 == Tri1(:,1),4);
					w11 = Tri1(t11 == Tri1(:,1),4);
				
					w1 = ((t12-t)/(t12-t11))*w11 + ((t-t11)/(t12-t11))*w12;
				end
			end

			Tri2 = DtoA{tet(i,2)}(:,:);

			min2 = min(Tri2(:,1));
			max2 = max(Tri2(:,1));
			
			if(t<min2 | t>max2)
				res(i,:) = [B(i,:) NaN];
				num_continues=num_continues+1;
				continue;
			else
				t22 = max(Tri2(Tri2(:,1) <= t));
				t21 = min(Tri2(Tri2(:,1) >= t));
				
				if(t22==t21)
					w2 = Tri2(t22 == Tri2(:,1),4);
				else
					w22 = Tri2(t22 == Tri2(:,1),4);
					w21 = Tri2(t21 == Tri2(:,1),4);
				
					w2 = ((t22-t)/(t22-t21))*w21 + ((t-t21)/(t22-t21))*w22;
				end
			end
			
			
			Tri3 = DtoA{tet(i,3)}(:,:);
			
			min3 = min(Tri3(:,1));
			max3 = max(Tri3(:,1));
			
			if(t<min3 | t>max3)
				res(i,:) = [B(i,:) NaN];
				num_continues=num_continues+1;
				continue;
			else
				t32 = max(Tri3(Tri3(:,1) <= t));
				t31 = min(Tri3(Tri3(:,1) >= t));
				
				if(t32==t31)
					w3 = Tri3(t32 == Tri3(:,1),4);
				else
					w32 = Tri3(t32 == Tri3(:,1),4);
					w31 = Tri3(t31 == Tri3(:,1),4);
				
					w3 = ((t32-t)/(t32-t31))*w31 + ((t-t31)/(t32-t31))*w32;
				end
			end
			
			I = [w1 w2 w3] * N;
			
            res(i,:) = [B(i,:) I];
        end
    end
	toc
	num_continues
	size(pl,1)
end