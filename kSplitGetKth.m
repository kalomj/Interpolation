function [P, O] = kSplitGetKth( I, K, k )
%KSPLITGETKTH Given an input array I and a K split vector, return the kth
%split as P. O is all of the other rows.

    P = I(K==k,:);
    
    O = I(K~=k,:);
end

