A = [1,2;3,4;5,9;7,0]

dtMesh = delaunayTriangulation(A);
dtMesh.Points

dtMesh.Points(1,:) = [];

dtMesh.Points
dtMesh.Points(end+1,:) = [1,2];

dtMesh.Points