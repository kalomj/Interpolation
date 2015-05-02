syms t1 x1 y1 t2 x2 y2 t3 x3 y3 t4 x4 y4;

A = [1 t1 x1 y1; 1 t2 x2 y2; 1 t3 x3 y3; 1 t4 x4 y4];

X = adjoint(A);
C=X.'