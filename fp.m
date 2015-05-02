% http://www.mathworks.com/help/matlab/math/delaunay-triangulation.html

%load input file, format is 3 floating point numbers per line
%each number seperated by a space
%this was built from my java code - we will need a matlab parser
%should be fairly easy to do - the biggest trick will be having
%several functions to convert various timescales to floating point numbers
%i'm sure matlab has a Date library that can do most of the heavy lifting
%timescale in this sample file is 0.1 = first day of 2009, 36.5 = last day of 2009 
P = load('delaunay_input.txt');

%build delaunay mesh and return elapsed time in seconds
s = cputime;
DT = delaunayTriangulation(P)
t_to_create_mesh = cputime - s


%a sample point that should be internal to a tetrahedron
xi = [-85.802182 33.281261 3.4];

%locate a single point and time it
s = cputime;
xi_t = DT.pointLocation(xi);
t_locate_single_point = cputime - s

%return a 1x4 vector containing the indices of the tetrahedron containing the point located
tet = DT.ConnectivityList(xi_t, :);

%return the 4 points of the tetrahedron
points = DT.Points(tet', :);

%load location data for 3109 locations - format of this file is 
%[id x y]
pl = load('county_xy.txt');
%create a 3109x3 matrix of all ones 
%[1 1 1]
o = ones(size(pl,1),3);

%copy all rows, columns 2 and 3 of location data into columns 1 and 2 of the ones matrix
% o now has 3109 rows of vectors that look like [x y 1]
%if this is interpreted as [x y t], with t=1, we are interpolating values
%for the 10th day of the year
o(:,1:2) = pl(:,2:3);

%locate containing tetrahedron for 3109 points and time it
s = cputime;
DT.pointLocation(o);
t_locate_3109_tetrahedron = cputime - s

%creates a column vector with numbers from .1 to 36.5, incrementing by .1
%the []' syntax transposes the row vector to a column vector
c = [0.1:.1:36.5]';

%loops in Matlab are slow. Built in functions are preferred
%repmat(A,m,n) takes matrix A and repeats in m rows by n columns

%below I am taking each of the 3109 locations, and repeating it 365 times
%once for each day of the year. Next to it I am taking a column vector with
%length 365 an repeating it 3109 times - this is essentially a cartesian
%product of the days of the year aagainst each location

%it is essential to take matrix of row length 3109 and repeat 365 times
%and put it next to the vector of length 365 and repeated 3109 times
%this gives us the cartesian product effect
%b2 = [repmat(pl(:,2:3),365,1) repmat(c,size(pl,1),1)];


%the above logic can fail if length of repeats are even divisible (creating repeating patterns)
b2 = cartprod(pl(:,2:3),c);


%find index of containing tetrahedron for 1,134,785 different [x y t] points 
s = cputime;
DT.pointLocation(b2);
t_locate_1134785_tetrahedron = cputime - s

