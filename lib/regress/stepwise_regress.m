function [b, y_pred, R2, adjR2, inmodel] = stepwise_regress(y, X)
    
    [b_all, ~, ~, inmodel, stats] = stepwisefit(X, y);

    n = size(X, 1);
    intercept = stats.intercept;
    X_selected = X(:, inmodel);
    b = [intercept; b_all(inmodel)];
    y_pred = [ones(n, 1), X_selected] * b;

    R2 = R_squared(y, y_pred);
    adjR2 = adjR_squared(y, y_pred, sum(inmodel));
end