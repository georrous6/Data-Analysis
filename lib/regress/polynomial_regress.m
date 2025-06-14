function [b, y_pred, R2] = polynomial_regress(Y, X, k)
    Y = Y(:);
    X = X(:);
    n = length(Y);
    X_data = ones(n, k+1);
    for i = 2:k+1
        X_data(:,i) = X.^2;
    end

    b = regress(Y, X_data);
    y_pred = X_data * b;
    R2 = R_squared(Y, y_pred);
end