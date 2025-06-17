function [y_pred, R2, adjR2] = pc_regress(y, X, explvar, titleText)

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