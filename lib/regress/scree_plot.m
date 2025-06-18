function scree_plot(lambda, explvar, titleText)
% scree_plot   Displays scree plot and cumulative explained variance for eigenvalues
%
%   scree_plot(lambda, explvar, titleText)
%   generates two subplots visualizing the eigenvalues and their cumulative explained variance,
%   highlighting the threshold where cumulative explained variance meets or exceeds `explvar`.
%
%   Inputs:
%       lambda    - Vector of eigenvalues (unsorted or sorted)
%       explvar   - Explained variance threshold (scalar between 0 and 1)
%       titleText - Title for the figure (string)
%
%   Description:
%       - Sorts eigenvalues in descending order.
%       - Computes cumulative explained variance.
%       - Finds the number of components needed to reach the threshold `explvar`.
%       - Left subplot: plots eigenvalues with a vertical line at the threshold index.
%       - Right subplot: plots cumulative explained variance with a horizontal line at `explvar`.
%       - Uses LaTeX interpreter for eigenvalue labels.
%       - Adds legends, labels, grid, and figure title.
%
%   Example:
%       lambda = [4.5, 2.3, 1.1, 0.7, 0.4];
%       scree_plot(lambda, 0.9, 'PCA Scree Plot');

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