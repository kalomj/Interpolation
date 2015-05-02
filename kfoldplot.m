A = [	1 1 5 5;
		2 1 5 10;
		3 1 5 15;
		4 1 5 20;
		1 3 1 1;
		2 3 1 2;
		3 3 1 3;
		4 3 1 4;
		1 5 4 4;
		2 5 4 8;
		3 5 4 12;
		4 5 4 16;
		1 3 3 3;
		2 3 3 6;
		3 3 3 9;
		4 3 3 12;
		];
		
S1 = A([1 3 4 5 7 8 9 11 12 13 15 16],:);
T1 = A([2 6 10 14],:);

S2 = A([1 2 3 4 5 6 7 8 9 10 11 12],:);
T2 = A([13 14 15 16],:);



%{
for K = 1 : size(A,1)
  thisX = A(K,2);
  thisY = A(K,3);
  labelstr = sprintf('(%d,%d)', thisX, thisY);
  text(thisX, thisY, labelstr);
end
%}


figure
subplot(3,1,1);
hold on
scatter(A(:,2),A(:,3),100,'red','*','LineWidth',1.5);

triA = delaunayTriangulation(A(:,2:3));
triplot(triA);
hold off;

subplot(3,1,2);
hold on;
scatter(T1(:,2),T1(:,3),125,'green','d','LineWidth',1.5);

triS1 = delaunayTriangulation(S1(:,2:3));
triplot(triS1);
hold off;


subplot(3,1,3);
hold on;
scatter(T2(:,2),T2(:,3),125,'green','d','LineWidth',1.5);

triS2 = delaunayTriangulation(S2(:,2:3));
triplot(triS2);
hold off;

