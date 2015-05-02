% Create a simple 50x3 array with random values between 0 and 1 to test with 
% This works fine because we can list the entire array and 3D mesh and
% eyeball it on screen
diTestPoints = rand(50,3)

% Create Delaunay Triangulation Mesh in 3D
dtMesh = delaunayTriangulation(diTestPoints)

% Get size of 3D mesh, just to check
meshSize = dtMesh.size

% Get number of rows of mesh elements, just to check 
iMeshRows = dtMesh.size(1)

% Get number of columns of mesh elements, just to check 
iMeshCols = dtMesh.size(2)

% Show tetrahedral mesh, just for checking
dtMesh(:,:)

% Show input data again, just for checking
% diTestPoints(:,:)

% Search 3D mesh for this point
locPoint = [0.3, 0.7, 0.5]

% To locate a point in 3D mesh (i.e get ID of tetrahedron containing point in convex hull)
disp('searching for '); disp(locPoint)
tetID = pointLocation(dtMesh, locPoint)

% Create 4x1 array of ones (1s) as we need this to form square matrix for
% calculating major volume and smaller 3x3 determinants later
onesPadding = ones(4,1)

if (~isnan(tetID)) %This is like checking for null pointer in C/C++ or null in Java
    % Get IDs of the vertexes of the located tetrahedron (tetID)
    vertexIDs = dtMesh.ConnectivityList(tetID, :)

    % Now get actual points (coordinates of located vertices, i.e. 4x3 tetrahedron vertix matrix )
    points = dtMesh.Points(vertexIDs, :)

    % NOW FOR MASTER VOLUME AND SMALLER 3x3 DETERMINANTS CALCULATIONS
    % Need to calculate volume of located tetrahedron ie. by using master 4x4 matrix
    % Then, by expanding the relevant determinants into their cofactors, we find 3x3 determinants to 
    % get to the values of ai, bi, ci, di for (1 <= i <= 4)
   
    % Now we are after this, (as shown in Dr Li's papers 1 - 4) for shape
    % function
    % w(x,y,t) = N1(x, y, t)w1 + N2(x, y, t)w2 + N3(x, y, t)w3 + N4(x, y, t)w4 

    % Where 
    %   N1(x,y,z) = (a1+b1x+c1y+d1t)/6V
    %   N2(x,y,z) = (a2+b2x+c2y+d2t)/6V
    %   N3(x,y,z) = (a3+b3x+c3y+d3t)/6V
    %   N4(x,y,z) = (a4+b4x+c4y+d4t)/6V

    %                 | 1 x1 y1 t1 |   This is just the four vertices in 3D
    %                 | 1 x2 y2 t2 |   of the located tetrahedron which is padded 
    %   V = (1/6)det  | 1 x3 y3 t3 |   on left with a 4x1 matrix of 1s to get 
    %                 | 1 x4 y4 t4 |   square matrix.  Square matrix is a 
    %                                  MUST for determinant calculations 
                                        

    % Now expanding to find cofactors and then calculate determinants as follows:
    % So if you remember, when doing determiants you expand about
    % row (or could consider it column, doesn't really matter). Row is more
    % intutive.  So what happens we expand about the first row walking
    % along one element at a time to get reduction matrix
    % So to get first matrix we expand about the first 1, by removing the
    % row and column containing that 1, and so we end up with the 3x3 whose determinant
    % will give value for a1.  In reality ( I wish Dr Li's papers would have
    % used to full notation, since in actuality it is sji = (-1)^(i+j)*det(Sij).

    %   Well if that is too complicated, lets talk it out the long way:
    %   The first pass would expand about the first row (so the row
    %   counter would remain the same (i.e. at 1) while column counter would advance from 1 to 4.
    %   So i=1, j=1 take us to the first 1 in the big matrix.  Now remove
    %   (cross out as we would say) the row and column containing that 1 and
    %   you get the matrix for calculating a1.  See below
    %   Then i = 1, j = 2, you move to x1 in big matrix. Again remove row
    %   and column containing x1 and you get 3x3 matrix for calculating b1.
    %   i = 1, j = 3 and you get to y1 in big matrix.  Again cross out row
    %   and column containing y1 and you get the 3x3 matrix for
    %   calculating c1.  
    %   NOTE here that Dr Li and Resev swap the columns and multiply by -1 which is 
    %   much harder to follow.  Remember sji = (-1)^(i+j)*det(Sij)? 
    %  (-1)raised to the power of i+j will determine if we multiply our
    %   determinant by +1 or -1.  I have never seen it taught like the way
    %   Dr Li and Dr Revesz has it, but I checked it out and IT IS IDENTICAL - 
    %   you get the same result, I can see theirs giving me issues in
    %   developing an algorithm though, so I personally would stay clear of
    %   that format.
    %   i = 1, j=4, and you get to t1. Cross out row and column containing
    %   t1 and you get the 3x3 matrix for calculating d1.

    %   Now we are at i = 2, j=1, same ole, same ole and we get 3x3 for
    %   calculating a2, and so on.  Note here that here since i+j is odd then we
    %   expect to multiply determinant by -1
    %   
 
    % running through counter variables i and j:
    % for i = 1, 1 <= j <= 4:  

    %             | x2 y2 t2 |
    %   a1 = det  | x3 y3 t3 |
    %             | x4 y4 t4 |

    %             | 1 y2 t2 |
    %   b1 = -det | 1 y3 t3 |
    %             | 1 y4 t4 |

    %             | 1 x2 t2 |
    %   c1 = det  | 1 x3 t3 |  
    %             | 1 x4 t4 |

    %   OR via Dr. Li, Dr. Revesz
    %             | x2 1 t2 |
    %   c1 = -det | x3 1 t3 |  
    %             | x4 1 t4 |

    %             | 1 x2 y2 |
    %   d1 = -det | 1 x3 y3 |  
    %             | 1 x4 y4 |
    %
    %.  ..  ..  ..  ..  
    
    % for i = 2, 1 <= j <= 4:  
    %              |  x1 y1 t1 |   
    %   a2 = -det  |  x3 y3 t3 |    
    %              |  x4 y4 t4 |   
    %                               
    %.  ..  ..  ..  ..  

    %{
        Run through some samples if still not convinced that the two expressions
        for c1 are identical.  One example given below, you can uncomment and test.  
        or test with other matrices

        A = [[3 1 5]; [7 1 9]; [9 1 7]]
        -det(A)
   
        B = [[1 3 5]; [1 7 9]; [1 9 7]]
        det(B)
    %}
   
    %A := array(1..2, 1..2, [[1, 2], [3, PI]]);
    % det(A)
    
    % Continuing...

    % Do a horizontal matrix concatenation of onesPadding 4x1 matrix 
    % with 4x3 vertices points matrix to create the master/major 4x4 matrix
    % mentioned above
    majorMatrix = [onesPadding  points]
    majorDet = det(majorMatrix)  % = 6V as per Dr Li's papers 1 - 4

   % Calculate all coefficients/cofactors and return in a single 4x4 matrix to give us 
   % ai, bi, ci, di (for 1 <= i <= 4)
    coefMatrix = calcAllCofactors(majorMatrix)
    if(~isnan(coefMatrix))
        % Individual listing of coefficients is just for clarity to match
        % with contents of Dr. Li's papers.  For actual calculation, will
        % keep everything in 4x4 coefMatrix matrix and index it directly
        
        a1 = coefMatrix(1,1)
        b1 = coefMatrix(1,2)
        c1 = coefMatrix(1,3)
        d1 = coefMatrix(1,4)
    
        a2 = coefMatrix(2,1)
        b2 = coefMatrix(2,2)
        c2 = coefMatrix(2,3)
        d2 = coefMatrix(2,4)

        a3 = coefMatrix(3,1)
        b3 = coefMatrix(3,2)
        c3 = coefMatrix(3,3)
        d3 = coefMatrix(3,4)

        a4 = coefMatrix(4,1)
        b4 = coefMatrix(4,2)
        c4 = coefMatrix(4,3)
        d4 = coefMatrix(4,4)

        % So from paper we are
        %   N1(x,y,z) = (a1+b1x+c1y+d1t)/6V
        %   N2(x,y,z) = (a2+b2x+c2y+d2t)/6V
        %   N3(x,y,z) = (a3+b3x+c3y+d3t)/6V
        %   N4(x,y,z) = (a4+b4x+c4y+d4t)/6V

        % We will create a 4x1 matrix for storing
        % N1, ..., N4 and work directly with that matrix.  Ju working with individual
        % variables now for greater clarity
        % We have already found majorDet = 6V from above
        N1 = (a1 + b1*locPoint(1,1) + c1*locPoint(1,2) + d1*locPoint(1,3))/majorDet
        N2 = (a2 + b2*locPoint(1,1) + c2*locPoint(1,2) + d2*locPoint(1,3))/majorDet
        N3 = (a3 + b3*locPoint(1,1) + c3*locPoint(1,2) + d3*locPoint(1,3))/majorDet
        N4 = (a4 + b4*locPoint(1,1) + c4*locPoint(1,2) + d4*locPoint(1,3))/majorDet

        % And at last we are here.  Remembering this from Dr. Li's paper
        % w(x,y,t) = N1(x, y, t)w1 + N2(x, y, t)w2 + N3(x, y, t)w3 + N4(x, y, t)w4

        % So interpolated value for my locPoint is given by
        % locPointVal = N1*w1 + N2*w2 + N3*w3 + N4*w4 
        % and we are in sync with Dr Li's papers
        % The known values (w1, w2, w3, w4) associated with the edges (points) of the 
        % located tetrahedron are required here.  Note I didn't store those values in my
        % diTestPoints at the very top of this script block.  I need to figure
        % out a way to associate additional attributes with edges...I know
        % CGAL support it, but don't know yet how to do this in MatLab.
        % Once that is figured out this piece is basically done.
    end
end


  