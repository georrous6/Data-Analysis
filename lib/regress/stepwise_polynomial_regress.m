function [B, idx, y_pred, order, R2, adjR2] = stepwise_polynomial_regress(Y, X, k, alpha, verbose, plotScatter)

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
