% given 
% a matrix A in format [t x y w] representing known data
%
% an output file name
%
% a interoplation type ('2D' or '3D' for reduction and extention methods,
% respectively
%
% open the output file if it exists and count the number of rows. if it
% doesn't exist, create it. Set the number of rows in the file to n
%
% Loop through all of the rows in A from n+1 to size(A,1), call LOOCV_i 
% on each row. Append the result to the output file
%
% Print out time statistics
%
function res = LOOCV(A, filename, type)

    if (nargin ~= 3)
        error('Error - LOOCV required 3 input arguments');
    end
    
    if type ~= '2D' & type ~= '3D'
        error('Interpolation type must be 2D or 3D');
    end

    s = size(A,1);
    res = zeros(s,6);
    

    %run triangulations in chunks of C
    %output metrics after each chuck to determine runtime length
    C = 131;
    
    outerloops = ceil(s / C)
    
    left = s;
    
    start = cputime;
    for i = 0 : 0%outerloops -1
        
       
       
       if left > C
        numpar = C;
       else
        numpar = left;
       end
       
       left = left - C;
       
       first = i * C + 1
       last = i * C + numpar
       
        t=cputime;
        parfor n = first:last
            

           res(n,:) =  LOOCV_i(A,n,type);

        end
        e=cputime - t;
        
        sprintf('finished loop %d in %f seconds, estimated hours remaining %f', i+1, e, (outerloops - i -1 * e)/60/60)
    end
    finished = cputime - start;

    sprintf('done in %f seconds', finished)
       
end