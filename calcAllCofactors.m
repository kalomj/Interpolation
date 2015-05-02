function B = calcAllCofactors(A)
    % Calculate and return the cofactors of the sqyare matrix A
    % The cofactors are return in teh output square matrix B
    rows = size(A,1);
    cols = size(A,2);

    if (rows ~= cols)
        disp('Error: input must a nxn square matrix');
        B = nan;
        return;  % of whatever that is matlab to return
    end

    % Create square matrix B for populating later with cofactors
    %B = A;
    B = ones(rows, cols); %initially filled with ones - will be overwritten

    for r = 1:rows
         for c = 1:cols
             B(r, c) = calcCofactor(A, r, c);
         end
    end
end
