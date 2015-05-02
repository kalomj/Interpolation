
s = cputime;

% Load the file contents into a matrix 
inputTable = importdata('pm25_2009_measured.txt','\t',1);
inputMatrix = inputTable.data;

% Find the min and max years in the matrix.  
% This determines which date values will be used. 
beginYear=min(inputMatrix(:,2));
endYear=max(inputMatrix(:,2));

% Create a matrix that maps all possible dates based on
% the time domain selected.  Store in dates matrix.
% NOTE: For now there is only logic for the "day" time domain.
dates=[];
counter=0;

% Time domain granularity.  This can be altered to make 
% each date ID less that one. For example...
% If set to 1, the date_id 01/01/2009 would be 1.
% If set to .1, the date_id would be .1.
granularity=1;

 for y = endYear:beginYear
            for m=1:12
                for d = 1:eomday(y,m)
                    counter=counter+1;
                    c=counter*granularity;
                    date_value=(y*10000)+(m*100)+d;
                    new_row=[c date_value];
                    dates=[dates;new_row];
                end
            end
 end
 

% Create a date map
% e.g., 
%        Key       Value
%        20090101  1
%        20090102  2
DK = dates(:,2)';
DV = dates(:,1)';
dateMap = containers.Map(DK, DV);

% Show all the values in the map
%values(dateMap)

% Free up some memory?
% I don't know if this actually helps performance, but it's
% good housecleaning anyway.
dates=[];

% Create a subset of inputMatrix that contains only 
% the date information.  
tempMatrix=inputMatrix(:,2:4);

% inputMatrixDateID will contain the date_id for each
% time value in inputMatrix.  It will have just as many rows
% as inputMatrix.  
% dateMap will be used to derive the % date_id value.
inputMatrixDateID=[];

% Loop through the dates
for row = 1:size(tempMatrix)
    
    % Grab date values
    y=tempMatrix(row,1);
    m=tempMatrix(row,2);
    d=tempMatrix(row,3);
    
    % Smash the date values into a single value (yyyymmdd)
    date_value=(y*10000)+(m*100)+d;
    
    % Use the yyyymmdd value as the key in the map to 
    % retrieve its corresponding value.
    date_id=dateMap(date_value);
    
    % Add this value to ID matrix
    inputMatrixDateID=[inputMatrixDateID;date_id];
end;
tempMatrix=[];

% Combine inputMatrix with inputMatrixDateID
% Format:  ID  X  Y  PM25  DATE_ID
A = inputMatrix(:,[1,5,6,7]);
inputMatrixNew = [A inputMatrixDateID];

disp('First 10 rows:');
inputMatrixNew(1:10,:)

% Show the first row without the row ID
inputMatrixNew(1,2:5)


total_time= cputime - s

