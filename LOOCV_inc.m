% This performs the same operation as LOOCV except it uses incremental
% delaunay triangulation building instead of parallel loops for
% performance
% given 
% a matrix A in format [t x y w] representing known data
%
% an output file name
%
% a interoplation type ('2D' or '3D' for reduction and extention methods,
% respectively
%
% optionally input the loop interation to start the interpolation, incase this
% is a restart of a failed run
%
% open the output file if it exists and count the number of rows. if it
% doesn't exist, create it. Set the number of rows in the file to n
%
% Loop through all of the rows in A from n+1 to size(A,1), call LOOCV_i 
% on each row. Append the result to the output file
%
% Print out time statistics
%
function res = LOOCV_inc(A, filename)

    if (nargin < 2)
        error('Error - LOOCV_inc requires 2 input arguments');
    end
    
    total = size(A,1);  
    
    %preallocate array
    res = zeros(total,6);

    fullloop = tic;
       
    %do first iteration to calculate full delaunay triangulation
    
    i=1
    % slice row i out of the array to create the sample data
    sample_txyw = A([1:i-1,i+1:end],:);

    % copy row i to a new matrix to use as the test point
    test_txyw = A(i,:);

    %interpolate points
    [txyw,dtMesh] = interpolate(sample_txyw,test_txyw(:,1:3));

    % create matrix in format [i t x w original interpolated]
    res(i,:) = [i test_txyw txyw(:,4)];
    s=tic;
    %remaining iterations are done with incremental triangulation updates
    for i = 2:total   
        if (mod(i,100) == 1)
            s= tic;
        end
        % copy row i to a new matrix to use as the test point
        test_txyw = A(i,:);
        
        %incrementally update the triangulation by adding the point from
        %the previous iteration and subtracting the point from the current
        %iteration
        
        %since we started by building the triangulation without the first
        %point, on iteration 2, the first point is point 2. on iteration 3,
        %the first point is point 3. Therefore we just need to cut out the
        %first point
        dtMesh.Points(1,:) = [];
        
        %now add the point from the last iteration to the end of the list
        dtMesh.Points(end+1,:) = A(i-1,1:3);
        
        % build sample data the same way
        % slice out the first point
        sample_txyw = sample_txyw(2:end,:);
        
        %append the last point
        sample_txyw(end+1,:) = A(i-1,:);
        
        %interpolate points
        txyw = interpolate(sample_txyw,test_txyw(:,1:3),dtMesh);
        
        % create matrix in format [i t x w original interpolated]
        res(i,:) = [i test_txyw txyw(:,4)];

        
        if (mod(i,100) == 0)
           e=toc(s)
           cycles_left = (total - i) / 100
           time_left = e* cycles_left
        end
        
    end

    %write to file 
    dlmwrite(sprintf('%s/%s',pwd,filename),res,'delimiter','\t','precision',12); 
    
    finished = toc(fullloop);

    sprintf('done in %f seconds', finished)
       
end