function m = sdMeasure( U )
%SDMEASURE Return a double value representing a measure of spatial
%dispersion
%   Calculates a matrix of all interpoint distances, and then
%   returns the average nearest neighbor distance of all points
    
    %calculate inter point distance matrix, returning only the nearest
    %neighbor for each point
    I = ipdm(U,'Subset','NearestNeighbor');
    %calculate the mean of all points returned
    m = full(mean(I(I>0)));
    if isnan(m)
        m = 0;
    end
end

