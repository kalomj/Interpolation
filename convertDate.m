%returns a scaled date given input in the following forms
%(year), (year,month), (year,quarter), (year,month,day)
%
%domain is year, month, quarter, day
%
%A is array of date values
%if domain = year, A is nx1
%if domain = month, A is nx2
%if domain = quarter, A is nx3
%if domain = day, A is nx3
%
%scale is a multiplicative scale, 1 is default and corresponds to when the
%returned value is scaled precisely to the domain in increments of 1.
%
%res is the converted and scaled result starting with 0
%
%For example, when scale =.1 and domain = quarter, the returned value increments
%by .1 each quarter starting at 0 for the earliest quarter represented in
%the rows of A
function [res map] = convertDate(A, domain, scale)
    if nargin < 3
        scale = 1;
    end

    switch domain
        
        %[year]
        case 'year'
            if size(A,2) ~= 1
                error('expected format for domain year is [year]');
            end
            res = A;
            map = ones(size(A,1),2);
            map(:,2) = A;
        %[year,quarter]
        case 'quarter'
            if size(A,2) ~= 2
                error('expected format for domain quarter is [year, quarter]');
            end
            if max(A(:,2)) > 4 | min(A(:,2)) < 1
                error('expected format for quarter is value in [1:4]')
            end
            res = A(:,1) .* 4;
            res = res + (A(:,2) - 1);
            map = ones(size(A,1),3);
            map(:,2:3) = A;
        %[year,month]
        case 'month'
            if size(A,2) ~= 2
                error('expected format for month is [year, month]');
            end
            if max(A(:,2)) > 12 | min(A(:,2)) < 1
                error('expected format for month is value in [1:12]')
            end
            res = A(:,1) .* 12;
            res = res + (A(:,2) - 1);
            map = ones(size(A,1),3);
            map(:,2:3) = A;
        %[year,month,day]
        case 'day'
            if size(A,2) ~= 3
                error('expected format for domain day is [year, month, day]');
            end
            if max(A(:,2)) > 12 | min(A(:,2)) < 1
                error('expected format for month is value in [1:12]')
            end
            if max(A(:,3)) > 31 | min(A(:,3)) < 1
                error('expected format for day is value in [1:31]')
            end

            res = datenum(A);
            map = ones(size(A,1),4);
            map(:,2:4) = A;
        otherwise
            error('domain must be year, quarter, month, or day')
    end
        %start at 0 
        res = res - min(res);
        %scale elementwise
        res = res .* scale;
        map(:,1) = res;
        map = unique(map, 'rows');
end