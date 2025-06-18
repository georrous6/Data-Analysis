function [b, y_pred, R2, adjR2] = linear_regress(y, X)
% linear_regress   Performs multiple linear regression and returns model diagnostics
%
%   [b, y_pred, R2, adjR2] = linear_regress(y, X)
%   fits a multiple linear regression model to the data and returns the estimated 
%   coefficients, predicted values, R-squared, and adjusted R-squared values.
%
%   Inputs:
%       y       - Response vector (n-by-1)
%       X       - Predictor matrix (n-by-p)
%
%   Outputs:
%       b       - Coefficient vector including intercept ([intercept; coefficients])
%       y_pred  - Predicted response values using the fitted model
%       R2      - R-squared value of the fitted model
%       adjR2   - Adjusted R-squared value accounting for the number of predictors
%
%   Description:
%       - Adds a column of ones to X to account for the intercept term.
%       - Uses MATLAB's built-in regress function to estimate coefficients.
%       - Computes predicted responses: y_pred = X_aug * b
%       - Calculates R-squared and adjusted R-squared values.
%
%   Example:
%       X = randn(100, 3);
%       y = X * [1.5; -2; 0.5] + randn(100, 1);
%       [b, y_pred, R2, adjR2] = linear_regress(y, X);

    n = length(y);
    X_aug = [ones(n, 1), X]; 
    b = regress(y, X_aug);
    y_pred = X_aug * b;
    R2 = R_squared(y, y_pred);
    adjR2 = adjR_squared(y, y_pred, length(b) - 1);
end