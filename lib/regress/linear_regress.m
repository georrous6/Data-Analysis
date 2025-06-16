function [b, y_pred, R2, adjR2] = linear_regress(y, X)
    n = length(y);
    X_aug = [ones(n, 1), X]; 
    b = regress(y, X_aug);
    y_pred = X_aug * b;
    R2 = R_squared(y, y_pred);
    adjR2 = adjR_squared(y, y_pred, length(b) - 1);
end