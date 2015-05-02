R = rand(4,4);
tic
for i = 1:1000
    calcAllCofactors(R);
end
toc

tic
for i = 1:1000
    inv(R')*det(R);
end
toc

calcAllCofactors(R)
inv(R')*det(R)