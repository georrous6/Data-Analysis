function [b, y_pred, R2, adjR2] = polynomial_regress(Y, X, k, titleText)
    Y = Y(:);
    X = X(:);
    n = length(Y);
    X_data = ones(n, k+1);
    for i = 2:k+1
        X_data(:,i) = X.^(i-1);
    end

    b = regress(Y, X_data);
    y_pred = X_data * b;
    R2 = R_squared(Y, y_pred);
    adjR2 = adjR_squared(Y, y_pred, k);

    if nargin > 3
        polynomial_fit_plot(X, Y, b, titleText);
    end
end
