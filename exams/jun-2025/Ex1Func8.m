function [b, y_pred, R2, adjR2] = Ex1Func8(y, X, plt, lambda)
% lasso_regress   Performs LASSO regression and returns model diagnostics
%
%   [b, y_pred, R2, adjR2] = lasso_regress(y, X, plt, lambda)
%   fits a LASSO (Least Absolute Shrinkage and Selection Operator) regression 
%   model to the data and returns the estimated coefficients, predicted values, 
%   R-squared, and adjusted R-squared. Optionally plots the LASSO regularization 
%   path.
%
%   Inputs:
%       y       - Response vector (n-by-1)
%       X       - Predictor matrix (n-by-p)
%       plt     - Logical flag to enable LASSO plot (true/false)
%       lambda  - (Optional) Regularization parameter (scalar or vector). 
%                 If omitted, cross-validation is used to select optimal value.
%
%   Outputs:
%       b       - Coefficient vector including intercept ([intercept; coefficients])
%       y_pred  - Predicted response values using the fitted model
%       R2      - R-squared value of the fitted model
%       adjR2   - Adjusted R-squared value based on model degrees of freedom
%
%   Description:
%       - Uses MATLAB's built-in lasso function for regularized regression.
%       - Selects the best lambda value that minimizes mean squared error.
%       - Computes predicted responses and fits statistics.
%       - Optionally displays the LASSO coefficient trace plot.
%
%   Example:
%       X = randn(100, 10);
%       y = X(:,1) - 2*X(:,2) + 0.5*randn(100,1);
%       [b, y_pred, R2, adjR2] = lasso_regress(y, X, true);

    if nargin > 3
        [b_all, stats] = lasso(X, y, 'Lambda', lambda);
    else
        [b_all, stats] = lasso(X, y);
    end
    [~, idx_best] = min(stats.MSE);
    b_best = b_all(:, idx_best);
    df = stats.DF(idx_best);
    intercept = stats.Intercept(idx_best);

    n = size(X, 1);
    b = [intercept; b_best];
    y_pred = [ones(n, 1), X] * b;

    R2 = Ex1Func7(y, y_pred);
    adjR2 = Ex1Func5(y, y_pred, df);

    if nargin > 2 && plt
        lassoPlot(b_all, stats);
    end
end