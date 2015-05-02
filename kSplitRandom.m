function split = kSplitRandom( I, k )
%KSPLITRANDOM Split the rows of I into K approximatly equal sized partitions at random
%   split is a vector indentifying the kth partion that each row belongs
    
%shuffle the input
ix = randperm(size(I,1));
%convert randomized index to K numbers
split = mod(ix,k)+1;
    

end

