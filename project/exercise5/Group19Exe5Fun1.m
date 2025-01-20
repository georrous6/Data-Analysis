% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

function Group19Exe5Fun1(X, y, description)

    if (size(X, 2) ~= 1 || size(y, 2) ~= 1)
        warning('X and y must be column vectors');
    end
    n = size(X, 1);
    X1 = [ones(n, 1), X];  % Add constant term
    [b, ~, res] = regress(y, X1);  % Excludes NaN observations
    y_hat = X1 * b;
    R2 = 1 - sum(res.^2) / sum((y - mean(y)).^2);
    
    % Regression model plot
    figure('Position', [100, 100, 1000, 400]);
    subplot(1, 2, 1);
    lineWidth = 1.2;
    hold on;
    scatter(X, y, '.');
    plot([min(X, max(X))], y_hat, '--r', 'LineWidth', lineWidth);
    ax = axis;
    text(ax(1) + 0.2 * (ax(2) - ax(1)), ax(3) + 0.9 * (ax(4) - ax(3)), sprintf('R^2=%.4f', R2));
    hold off;
    xlabel('Setup');
    ylabel('ED duration');
    title(sprintf('Regression model for ED duration over Setup (%s)', description));
    
    % Diagnostic plot
    subplot(1, 2, 2);
    hold on;
    alpha = 0.05;
    zcrit = norminv(1 - alpha / 2, 0, 1);
    std_res = res / std(res);
    C = corrcoef(y, std_res);
    r2 = 100 * C(1, 2)^2;
    scatter(y, std_res, '.');
    plot([min(y), max(y)], zcrit * [1, 1], '--r', 'LineWidth', lineWidth);
    plot([min(y), max(y)], -zcrit * [1, 1], '--r', 'LineWidth', lineWidth);
    ax = axis;
    text(ax(1) + 0.2 * (ax(2) - ax(1)), ax(3) + 0.8 * (ax(4) - ax(3)), sprintf('r^2=%.4f%%', r2));
    hold off;
    xlabel('y_i');
    ylabel('e_i^*');
    title(sprintf('Dagnostic plot for ED duration over Setup (%s)', description));
end