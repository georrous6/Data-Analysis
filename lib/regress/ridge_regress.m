function [b, y_pred, R2, adjR2] = ridge_regress(y, X, k, plt)
% ridge_regress   Performs Ridge regression over a set of ridge parameters
%
%   [b, y_pred, R2, adjR2] = ridge_regress(y, X, k, plt)
%   fits Ridge regression models for each regularization parameter in vector k,
%   selects the best model minimizing mean squared error (MSE), and optionally plots
%   coefficient paths versus the ridge parameter.
%
%   Inputs:
%       y    - Response vector (n-by-1)
%       X    - Predictor matrix (n-by-p)
%       k    - Vector of ridge regularization parameters (non-negative)
%       plt  - (Optional) Boolean flag to plot coefficient paths vs. k
%
%   Outputs:
%       b       - Coefficients of best Ridge regression model (p-by-1)
%       y_pred  - Predicted response values using best model (n-by-1)
%       R2      - R-squared of best model
%       adjR2   - Adjusted R-squared of best model
%
%   Description:
%       - Uses MATLAB's ridge function to compute coefficients for each k.
%       - Calculates predictions and MSE for each model.
%       - Selects the model with minimal MSE.
%       - Computes R2 and adjusted R2 for best model.
%       - If plt is true, plots coefficients of predictors against k.
%
%   Example:
%       X = randn(100, 5);
%       y = X(:,1)*2 - X(:,3) + 0.5*randn(100,1);
%       k = linspace(0, 10, 50);
%       [b, y_pred, R2, adjR2] = ridge_regress(y, X, k, true);

    n = size(X, 1); 
    b_all = ridge(y, X, k, 0);
    y_pred_all = [ones(n, 1), X] * b_all;
    mse_all = mean((y_pred_all - y).^2, 1);
    [~, idx_best] = min(mse_all);
    b = b_all(:,idx_best);
    y_pred = y_pred_all(:,idx_best);
    
    R2 = R_squared(y, y_pred);
    adjR2 = adjR_squared(y, y_pred, length(b) - 1);

    if nargin > 3 && plt
        figure; hold on;
        n_params = size(b_all, 1) - 1;
        for i = 2:n_params
            plot(k, b_all(i,:), 'LineWidth', 1.5, 'DisplayName', sprintf('b%d', i - 1));
        end
        xlabel('k');
        title('Coefficients vs Ridge Parameter');
        legend show;
        grid on;
    end
end