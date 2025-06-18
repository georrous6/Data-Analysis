function [b, y_pred] = partial_linear_regress(Y, X, x_split)
% partial_linear_regress   Fits a piecewise linear regression model with a split at a given x-value
%
%   [b, y_pred] = partial_linear_regress(Y, X, x_split)
%   fits two separate linear regressions to the data on either side of the 
%   specified x_split value. Returns the combined coefficients and predicted values.
%
%   Inputs:
%       Y        - Response vector (n-by-1)
%       X        - Predictor vector (n-by-1)
%       x_split  - Scalar value specifying the split point in X
%
%   Outputs:
%       b        - Coefficients for both segments ([b1; b2]), each of size 2x1
%       y_pred   - Combined predicted values for all observations (n-by-1), 
%                  preserving the original order of X
%
%   Description:
%       - Sorts X and Y by increasing values of X.
%       - Identifies the split index based on the x_split threshold.
%       - Performs separate linear regressions on the data before and after the split.
%       - Constructs predicted values for each segment and reorders them to match input.
%       - If the split is too close to either end, an error is raised.
%
%   Notes:
%       - A valid split must leave at least two data points on either side.
%       - Useful for modeling data with structural breaks or regime shifts.
%
%   Example:
%       X = linspace(0, 10, 100)';
%       Y = [X(1:50)*2 + randn(50,1); X(51:100)*0.5 + 10 + randn(50,1)];
%       x_split = 5;
%       [b, y_pred] = partial_linear_regress(Y, X, x_split);

    n = length(X);
    [X_sorted, idx] = sort(X);
    Y_sorted = Y(idx);
    split_idx = find(X_sorted > x_split, 1, 'first') - 1;

    if isempty(split_idx) || split_idx < 2 || split_idx > n - 2
        error('Invalid split index. Choose a different x_split.');
    end

    b1 = regress(Y_sorted(1:split_idx), [ones(split_idx, 1), X_sorted(1:split_idx)]);
    b2 = regress(Y_sorted(split_idx+1:n), [ones(n-split_idx, 1), X_sorted(split_idx+1:n)]);
    b = [b1; b2];

    y_pred_sorted = NaN(n, 1);
    y_pred_sorted(1:split_idx) = [ones(split_idx, 1), X_sorted(1:split_idx)] * b1;
    y_pred_sorted(split_idx+1:n) = [ones(n - split_idx, 1), X_sorted(split_idx+1:n)] * b2;

    y_pred(idx) = y_pred_sorted;
end