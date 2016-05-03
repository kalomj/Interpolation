% given 
% an input file name fi1 with sample values like pm25_2009_measured.txt
% an input file name fi2 with locations to interpolate like county_xy.txt
% a time domain like 'year', 'month', 'quarter', or 'day'
% a multiplicative scale as a scalar floating point multiplier
% an output file name fo to write inerpolated data 
% an optional interpolation type : ('2D' or '3D' for reduction and
% extension methods, respectively
%
% function will write out the file required in assignment section 3
% 
function writeOutputDataSet(fi1, fi2, domain, scale, fo, interp_type)
    %get header string based on time domain
    str = 'id';
     switch domain
        %[year]
        case 'year'
        str = sprintf('id\ty\tw');
        %[year,quarter]
        case 'quarter'
        str = sprintf('id\ty\tq\tw');
        %[year,month]
        case 'month'
        str = sprintf('id\ty\tm\tw');
        %[year,month,day]
        case 'day'
        str = sprintf('id\ty\tm\td\tw');
     end
     
    if nargin == 5
        interp_type = '3D';
    end
     
    %write header string to file
    fid = fopen(fo,'w');  
    if fid>=0
        fprintf(fid, '%s\n', str);
        fclose(fid);
    end

    % parse input file with given time domain and scale
    [A map] = fileParse(fi1, domain, scale);
    
    %find all time domain values, already appropriately scaled, at which time
    %we want to interpolate data
    U = unique(A(:,2));
    
    %load all locations where data should be interpolated
    P = importdata(fi2,'\t',1);
    P = P.data;
     
    %loop to accumulate values n at a time to avoid out of memory error
    %n is chosen such that when it is multiplied across all unique time
    %values, a million records are written to the output file at a time
    %this seems to be a good balance between memory use and speed
    n=floor(1000000/size(U,1));
    i=1;
    for b = 1:n:size(P,1)
        %calculate begin and end indices to process
         e = b+n-1;
        if e > size(P,1)
           e = size(P,1);
        end
        processing(i,:) = [b e];
        i=i+1;
    end
       
    %run first iteration to precalculate triangulations
    
    %x y t triples where we should interpolate
    idtxy = cartprod3(P(b:e,:),U);
    
    %preinitialize variables that are only used in reduction method
    %otherwise the parfor will choke when running the extension method
    Da = 0;
    T=0;
    if strcmp(interp_type,'2D')
           [txyw, dtMesh, Da, T] = interpolate2D(A(:,2:5),idtxy(:,2:4));
    elseif ~strcmp(interp_type,'2D')
           [txyw, dtMesh] = interpolate(A(:,2:5),idtxy(:,2:4));
    end

    %convert back to original time scale 
    %(won't always be ymd format, could be ym or yq or y)
    ymdxyw = convertT(txyw,1,map);

    % O should be [id y m d w]
    %(won't always be ymd format, could be ym or yq or y)     
    %only copy the relevelt entries to the final matrix (from b to e)
    O{1} = [idtxy(:,1) ymdxyw(:,1:end-3) ymdxyw(:,end:end)]; 
    %end first iteration
    
    
    %run the rest of the iterations in parallel
    parfor j=2:size(processing,1)
        b = processing(j,1);
        e = processing(j,2);
        
        running = [b e]
        
        %x y t triples where we should interpolate
        idtxy = cartprod3(P(b:e,:),U);
        
        %interpolate points
        if strcmp(interp_type,'2D')
            txyw = interpolate2D(A(:,2:5),idtxy(:,2:4),dtMesh,Da, T);
        elseif ~strcmp(interp_type,'2D')
            txyw = interpolate(A(:,2:5),idtxy(:,2:4),dtMesh);
        else
            error('Bad conditional in writeOutputDataSet - all cases should be covered and we should not get here');
        end

        %convert back to original time scale 
        %(won't always be ymd format, could be ym or yq or y)
        ymdxyw = convertT(txyw,1,map);

        % O should be [id y m d w]
        %(won't always be ymd format, could be ym or yq or y)     
        %only copy the relevelt entries to the final matrix (from b to e)
        O{j} = [idtxy(:,1) ymdxyw(:,1:end-3) ymdxyw(:,end:end)];        
    end
    
    %write data to file in append mode to preserve header string
    for k = size(O,2)
        %dlmwrite(fo,O{k},'-append','delimiter','\t','precision',12);
    end
end