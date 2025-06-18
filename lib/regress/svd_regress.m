function [b, y_pred, R2, adjR2] = svd_regress(y, X, explvar, titleText)
% svd_regress   Performs principal component regression using SVD
%
%   [b, y_pred, R2, adjR2] = svd_regress(y, X, explvar, titleText)
%   fits a linear regression model using principal components obtained from
%   singular value decomposition (SVD) of the standardized predictors.
%
%   Inputs:
%       y         - Response vector (n-by-1)
%       X         - Predictor matrix (n-by-p)
%       explvar   - Desired explained variance threshold (scalar in (0,1])
%       titleText - (Optional) Title for scree plot visualization
%
%   Outputs:
%       b       - Regression coefficients vector [intercept; predictors]
%       y_pred  - Predicted response vector from the model (n-by-1)
%       R2      - R-squared value of the fitted model
%       adjR2   - Adjusted R-squared of the fitted model
%
%   Description:
%       - Standardizes predictors by centering and scaling to unit variance.
%       - Performs SVD on standardized predictors to extract principal components.
%       - Selects number of components d to meet or exceed explained variance explvar.
%       - Computes regression coefficients based on truncated SVD components.
%       - Transforms coefficients back to original scale.
%       - Calculates predicted values and fit statistics.
%       - Optionally plots scree plot of eigenvalues and explained variance.
%
%   Example:
%       y = randn(100,1);
%       X = randn(100,5);
%       [b, y_pred, R2, adjR2] = svd_regress(y, X, 0.9, 'SVD Regression Scree Plot');

    % Input validation
    if explvar <= 0 || explvar > 1
        error('Explained variance should be between (0, 1].');
    end

    [n, p] = size(X);

    % Center and standardize X
    X_mean = mean(X, 1);
    y_mean = mean(y);
    X_centered = X - X_mean;
    X_std = std(X_centered, 0, 1);
    X_standardized = X_centered ./ X_std;

    % Center y
    y_centered = y - y_mean;

    % SVD of standardized X
    [U, S, V] = svd(X_standardized, 'econ');
    lambda = diag(S).^2 / (n - 1);  % Eigenvalues
    explained = cumsum(lambda) / sum(lambda);

    % Number of PCs to use
    d = find(explained >= explvar, 1);
    if isempty(d)
        d = p;
        warning('Explained variance threshold not reached. Using all components.');
    end

    % Truncated SVD components
    Ud = U(:, 1:d);
    Sd = S(1:d, 1:d);
    Vd = V(:, 1:d);

    % Coefficients (standardized scale)
    b_standardized = Vd / Sd * Ud' * y_centered;

    % Transform back to original scale
    b_centered = b_standardized ./ X_std';
    intercept = y_mean - X_mean * b_centered;
    b = [intercept; b_centered];

    % Predictions
    y_pred = [ones(n, 1), X] * b;

    % R-square and adjusted R-square statistics
    R2 = 1 - sum((y - y_pred).^2) / sum((y - y_mean).^2);
    adjR2 = 1 - ( (1-R2)*(n-1) / (n-d-1) );

    % Optional scree plot
    if nargin > 3 && ~isempty(titleText)
        scree_plot(lambda, explvar, titleText);
    end
end