function [b, y_pred] = partial_linear_regress(Y, X, x_split)
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