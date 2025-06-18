function [b, y_pred, R2, adjR2, inmodel] = Ex1Func9(y, X)
% stepwise_regress   Performs stepwise linear regression variable selection
%
%   [b, y_pred, R2, adjR2, inmodel] = stepwise_regress(y, X)
%   fits a linear regression model using stepwise selection on the predictors in X.
%
%   Inputs:
%       y - Response vector (n-by-1)
%       X - Predictor matrix (n-by-p)
%
%   Outputs:
%       b       - Regression coefficients vector [intercept; selected predictors]
%       y_pred  - Predicted response vector from the selected model (n-by-1)
%       R2      - R-squared value of the fitted model
%       adjR2   - Adjusted R-squared of the fitted model
%       inmodel - Logical vector indicating which predictors are included in the model
%
%   Description:
%       - Uses MATLAB's built-in stepwisefit function to select variables based on
%         stepwise regression without displaying output.
%       - Constructs final regression coefficients including intercept.
%       - Calculates predicted values and model fit statistics.
%
%   Example:
%       y = randn(50,1);
%       X = randn(50,5);
%       [b, y_pred, R2, adjR2, inmodel] = stepwise_regress(y, X);
    
    [b_all, ~, ~, inmodel, stats] = stepwisefit(X, y, 'display', 'off');

    n = size(X, 1);
    intercept = stats.intercept;
    X_selected = X(:, inmodel);
    b = [intercept; b_all(inmodel)];
    y_pred = [ones(n, 1), X_selected] * b;

    R2 = Ex1Func7(y, y_pred);
    adjR2 = Ex1Func5(y, y_pred, sum(inmodel));
end