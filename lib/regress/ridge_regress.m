function [b, y_pred, R2, adjR2] = ridge_regress(y, X, k)

    n = size(X, 1); 
    b_all = ridge(y, X, k);
    y_pred_all = [ones(n, 1), X] * b_all;
    mse_all = mean((y_pred_all - y).^2, 1);
    [~, idx_best] = min(mse_all);
    b = b_all(:,idx_best);
    y_pred = y_pred_all(:,idx_best);
    
    R2 = R_squared(y, y_pred);
    adjR2 = adjR_squared(y, y_pred, length(b) - 1);
end