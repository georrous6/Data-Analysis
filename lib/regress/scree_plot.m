function scree_plot(lambda, explvar, titleText)
    lambda = sort(lambda, 'descend');
    explained = cumsum(lambda) ./ sum(lambda);
    d = find(explained >= explvar, 1);

    figure('Position', [200, 100, 1000, 400]);
    sgtitle(titleText);
    subplot(1, 2, 1); hold on;
    plot(lambda, 'bo-', 'HandleVisibility', 'off');
    ax = axis;
    xlim = [ax(1), ax(2)];
    plot(xlim, lambda(d) * [1, 1], 'r--', 'DisplayName', sprintf('explained variance >= %d%%', round(100 * explvar)));
    xlabel('Eigenvalue Index');
    ylabel('$\lambda_i$', 'Interpreter', 'latex');
    legend('Location', 'northeast');
    grid on;   

    subplot(1, 2, 2); hold on;
    plot(100 * explained, 'bo-', 'HandleVisibility', 'off');
    ax = axis;
    xlim = [ax(1), ax(2)];
    plot(xlim, 100 * explvar * [1, 1], 'r--', 'DisplayName', sprintf('explained variance %d%%', round(100 * explvar)));
    xlabel('Number of Principal Components');
    ylabel('Cumulative Explained Variance %');
    legend('Location', 'southeast');
    grid on;
end