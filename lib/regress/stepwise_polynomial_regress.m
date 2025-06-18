function [B, idx, y_pred, order, R2, adjR2] = stepwise_polynomial_regress(Y, X, k, alpha, verbose, plotScatter)
% stepwise_polynomial_regress   Performs stepwise polynomial regression variable selection
%
%   [B, idx, y_pred, order, R2, adjR2] = stepwise_polynomial_regress(Y, X, k, alpha, verbose, plotScatter)
%   fits polynomial regression models of degree k to each predictor in X sequentially,
%   adding variables to the model if their contribution is statistically significant,
%   based on a correlation test with significance level alpha.
%
%   Inputs:
%       Y           - Response vector (n-by-1)
%       X           - Predictor matrix (n-by-K)
%       k           - Polynomial degree for each predictor
%       alpha       - Significance level for variable inclusion (e.g., 0.05)
%       verbose     - Boolean flag to print progress messages
%       plotScatter - Boolean flag to plot scatter plots with fitted polynomials during selection
%
%   Outputs:
%       B       - Coefficients matrix ((k+1)-by-K), each column for one predictor
%       idx     - Binary vector (1-by-K), 1 if predictor included, 0 otherwise
%       y_pred  - Predicted response vector from final model (n-by-1)
%       order   - Order in which variables were added to the model
%       R2      - R-squared of the final model
%       adjR2   - Adjusted R-squared of the final model
%
%   Description:
%       - Initializes residuals with Y and empty model.
%       - At each step, fits polynomial regression (degree k) to each remaining variable.
%       - Adds the variable with the highest R-squared if correlation test p-value < alpha.
%       - Updates residuals and prediction after adding each variable.
%       - Stops when no variables meet inclusion criteria.
%
%   Example:
%       Y = randn(100,1);
%       X = randn(100,5);
%       k = 2;
%       alpha = 0.05;
%       verbose = true;
%       plotScatter = false;
%       [B, idx, y_pred, order, R2, adjR2] = stepwise_polynomial_regress(Y, X, k, alpha, verbose, plotScatter);

    [N, K] = size(X);
    B = NaN(k+1, K);
    idx = zeros(1, K);
    y_pred = zeros(N, 1);
    y_residual = Y;
    order = [];

    for j = 1:K
        R2_max = 0;
        idx_max = 0;
        b_max = NaN(k+1, 1);
        y_hat_max = NaN(N, 1);
        addedVariable = false;

        % Find the variable that has the greatest R-squared value and has
        % not already been added to the model
        for i = 1:K
            if idx(i) == 0
                
                [b, y_hat, r2] = polynomial_regress(y_residual, X(:,i), k);
    
                if r2 > R2_max
                    R2_max = r2;
                    idx_max = i;
                    b_max = b;
                    y_hat_max = y_hat;
                end
            end
        end

        if idx_max ~= 0
            p_val = correlation_test(y_residual, y_hat_max, alpha);
            if p_val < alpha
                idx(idx_max) = 1;
                y_pred = y_pred + y_hat_max;
                B(:,idx_max) = b_max;
                if verbose
                    fprintf('Add variable %d to model (p-value = %f)\n', idx_max, p_val);
                end
                
                order = [order, idx_max];
                addedVariable = true;
                if plotScatter
                    polynomial_fit_plot(X(:,idx_max), y_residual, B(:,idx_max), sprintf('Scatter plot for x_%d', idx_max));
                end
                y_residual = y_residual - y_hat;
            end
        end

        if ~addedVariable
            break;
        end
    end

    R2 = R_squared(Y, y_pred);
    adjR2 = adjR_squared(Y, y_pred, sum(idx) * k);
end
