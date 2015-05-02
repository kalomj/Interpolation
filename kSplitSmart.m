function split = kSplitSmart( I, k )
%KSPLITSMART Split the rows of I into K approximatly equal sized partitions
%   use k-means++ to find k centroids
%   then use the munkres linear assignment algorithm to assign equal number
%   of points, plus or minus 1, to each of the k centroids

    %h is the number of centroids to find
    h = floor(size(I,1)/k)

    disp('Finding centroids');
    [idx,C,sumd,D] = kmeans(I,h);
    %Replicate cost matrix k times, so k points can be assigned to each of
    %h centroids
    repD = repmat(D,1,k);


    disp('Solving linear assignment problem');
    %F is the assignment of each point to each centroid that minimizes
    %distance
    [F, cost] = munkres(repD);
    
    %points that are not assigned to a centroid have a 0 value
    ix = find(~F);
    %since centroid values of size h were replicated k times above with repmat, the modulo by
    %h returns the original centroid index
    r = mod(F,h) + 1;
    %set the unassigned points to 0
    r(ix) = 0;
    %preallocate final array
    split = ones(size(r));
    for n = 0:h
        %each of h centroids now has at most k points assigned to it
        %number those from 1:k
        %the 0'th centroid (the points not assigned to a particulat centroid) may have less than k points assigned to it
        split(r==n) = 1:sum(r==n);
    end

end

