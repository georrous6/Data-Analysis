function [b, y_pred] = linear_regress(Y, X)
    n = length(Y);
    b = regress(Y, [ones(n, 1), X]);
    y_pred = [ones(n, 1), X] * b;
end