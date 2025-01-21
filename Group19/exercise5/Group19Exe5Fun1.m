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
    MSE = mean(res.^2);
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
    diagnosticPlot(y, y_hat, sprintf('Dagnostic plot for ED duration over Setup (%s)', description), ...
        sprintf('MSE=%.4f', MSE));
end