function [y_pred, R2, adjR2] = pc_regress(y, X, explvar, titleText)
% pc_regress   Performs Principal Component Regression (PCR)
%
%   [y_pred, R2, adjR2] = pc_regress(y, X, explvar, titleText)
%   fits a regression model using principal components of the predictors. 
%   The number of components is chosen to meet a specified cumulative 
%   explained variance threshold. This function is deprecated.
%
%   Inputs:
%       y         - Response vector (n-by-1)
%       X         - Predictor matrix (n-by-p)
%       explvar   - Explained variance threshold (scalar in (0, 1])
%       titleText - (Optional) Title text for the scree plot (string)
%
%   Outputs:
%       y_pred    - Predicted response values from the PCR model
%       R2        - R-squared value of the model
%       adjR2     - Adjusted R-squared value based on number of components used
%
%   Description:
%       - This function is **deprecated**. Use `svd_regress` instead.
%       - Standardizes X (zero mean, unit variance).
%       - Computes principal components via eigendecomposition of the covariance matrix.
%       - Selects the smallest number of components required to meet the specified 
%         cumulative explained variance (`explvar`).
%       - Projects X into principal component space and fits a linear regression on 
%         selected components.
%       - Optionally displays a scree plot if `titleText` is provided.
%
%   Notes:
%       - If the `explvar` threshold is not met, all components are used with a warning.
%       - The intercept is included in the regression model.
%       - The function assumes that `R_squared`, `adjR_squared`, and `scree_plot` are available.
%
%   Example:
%       X = randn(100, 5);
%       y = X(:,1)*3 - X(:,2)*2 + randn(100,1);
%       [y_pred, R2, adjR2] = pc_regress(y, X, 0.9, 'PCA Scree Plot');

    warning('This function is deprecated. Instead use svd_regress');
    if explvar <= 0 || explvar > 1
        error('Explained variance should be between (0, 1]\n');
    end
    [n, p] = size(X);
    X = (X - mean(X, 1)) ./ std(X, 1);
    S = X' * X ./ (n - 1);
    [A, L] = eig(S);
    lambda = diag(L);
    [lambda, idx] = sort(lambda, 'descend');
    explained = cumsum(lambda) ./ sum(lambda);
    A = A(:,idx);
    d = find(explained >= explvar, 1);
    if isempty(d)
        d = p; % Use all components if threshold not met
        warning('Explained variance threshold not reached with available components. Using all components instead');
    end
    Ad = A(:,1:d);  % Get the first d eigenvectors
    Yd = X * Ad;    % Scores of PCs
    Yd_aug = [ones(n, 1), Yd];
    b_PCR = regress(y, Yd_aug);
    y_pred = Yd_aug * b_PCR;

    R2 = R_squared(y, y_pred);
    adjR2 = adjR_squared(y, y_pred, d);

    if nargin > 3
        scree_plot(lambda, explvar, titleText);
    end
end