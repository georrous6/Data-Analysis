function [b, y_pred, R2, adjR2] = lasso_regress(y, X, plt, lambda)
    if nargin > 3
        [b_all, stats] = lasso(X, y, 'Lambda', lambda);
    else
        [b_all, stats] = lasso(X, y);
    end
    idx_best = stats.IndexMinMSE;
    b_best = b_all(:, idx_best);
    intercept = stats.Intercept(idx_best);

    n = size(X, 1);
    b = [intercept; b_best];
    y_pred = [ones(n, 1), X] * b;

    R2 = R_squared(y, y_pred);
    adjR2 = adjR_squared(y, y_pred, sum(b_best ~= 0));

    if plt
        figure;
        lassoPlot(b_all, stats);
    end
end