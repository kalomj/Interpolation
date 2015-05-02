function d = calcCofactor(A, r, c)           
    % remove specified row
    A(r,:) = [];

    % remove specified column
    A(:, c) = [];

    % calculate and return cofactor
    d = (-1)^(r+c) * det(A);
end
