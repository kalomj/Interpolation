% given a file path for an input file, returns a matrix
% with the time domain fields converted to a single scaled number field
%
% Example, if the input file has header, in time domain day:
% id	year	month	day	x	y	pm25
%
% Then the returned matrix will have format:
% id	t	x	y	pm25
%
% if the input file has header, in time domain quarter:
% id	year	quarter	x	y	pm25
%
% Then the returned matrix will also have format:
% id	t	x	y	pm25
function [res map] = fileParse(filepath, domain, scale)

    if nargin < 3
        scale = 1;
    end
    
    inputTable = importdata(filepath,'\t',1);
    A = inputTable.data;
    
    switch domain
        
        %[year]
        case 'year'
            if size(A,2) ~= 5
                error('expected columns in input file for year domain is 5');
            end
            [datenum_vector map] = convertDate(A(:,2),'year',scale);
            res = [A(:,1) datenum_vector A(:,3:end)];
        %[year,quarter]
        case 'quarter'
            if size(A,2) ~= 6
                error('expected columns in input file for quarter domain is 6');
            end
            [datenum_vector map] = convertDate(A(:,2:3),'quarter',scale);
            res = [A(:,1) datenum_vector A(:,4:end)];
        %[year,month]
        case 'month'
            if size(A,2) ~= 6
                error('expected columns in input file for month domain is 6');
            end
            [datenum_vector map] = convertDate(A(:,2:3),'month',scale);
            res = [A(:,1) datenum_vector A(:,4:end)];
        %[year,month,day]
        case 'day'
            if size(A,2) ~= 7
                error('expected columns in input file for day domain is 7');
            end
            [datenum_vector map] = convertDate(A(:,2:4),'day',scale);
            res = [A(:,1) datenum_vector A(:,5:end)];
        otherwise
            error('domain must be year, quarter, month, or day')
    end
 end
 