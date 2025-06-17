function [b, y_pred, R2, adjR2] = pls_regress(y, X, explvarY, titleText)

    % Input validation
    if explvarY <= 0 || explvarY > 1
        error('Explained variance should be between (0, 1].');
    end

    [n, p] = size(X);

    % Center and standardize X and y
    X_mean = mean(X, 1);
    X_std = std(X, 0, 1);
    X_std(X_std == 0) = eps;  % Prevent division by zero
    Xz = (X - X_mean) ./ X_std;

    y_mean = mean(y);
    y_centered = y - y_mean;

    % Use a large max number of components first
    maxComponents = min(n - 1, p);
    [~, ~, ~, ~, ~, pctVar] = plsregress(Xz, y_centered, maxComponents);

    % Cumulative variance explained in y
    cumExplainedY = cumsum(pctVar(2, :));

    % Find number of components needed to reach desired explained variance
    d = find(cumExplainedY >= explvarY, 1);
    if isempty(d)
        d = maxComponents;
        warning('Explained variance threshold not reached. Using all components.');
    end

    % Perform PLS regression with d components
    [~, ~, ~, ~, beta, PCTVAR] = plsregress(Xz, y_centered, d);

    % Transform coefficients back to original scale
    b_centered = beta(2:end) ./ X_std';
    intercept = y_mean - X_mean * b_centered;
    b = [intercept; b_centered];

    % Predictions
    y_pred = [ones(n, 1), X] * b;

    % R-square and adjusted R-square
    R2 = R_squared(y, y_pred);
    adjR2 = adjR_squared(y, y_pred, d);

    % Optional scree plot of Y-variance explained
    if nargin > 3
        figure; hold on;
        plot(100 * cumsum(PCTVAR(2, :)), '-bo', 'HandleVisibility', 'off');
        ax = axis;
        xlim = [ax(1), ax(2)];
        plot(xlim, 100 * explvarY * [1, 1], '--r', 'DisplayName', sprintf('%d%% Variance threshold of Y', round(100 * explvarY)));
        xlabel('Number of Components');
        ylabel('Explained Variance of Y %');
        title(titleText);
        legend('Location', 'southeast');
        grid on;
    end
end
