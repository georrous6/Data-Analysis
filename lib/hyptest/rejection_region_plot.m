function rejection_region_plot(theta_hat, cv, tail, titleText, test_stat)
% rejection_region_plot - Visualizes bootstrap test statistic distribution with rejection regions
%
% Syntax:
%   rejection_region_plot(theta_hat, cv, tail, titleText, test_stat)
%
% Inputs:
%   theta_hat  - Vector of bootstrap test statistics
%   cv         - Critical value(s) defining rejection region(s)
%                (scalar for one-tailed test, two-element vector for two-tailed test)
%   tail       - String specifying tail type: 'both', 'left', or 'right'
%   titleText  - Title string for the plot
%   test_stat  - (Optional) Observed test statistic to plot as a vertical line
%
% Description:
%   This function plots the probability density histogram of bootstrap test statistics
%   and shades the rejection region(s) in red based on the critical values and tail type.
%   If test_stat is provided, it is shown as a green vertical line.
%
% Example:
%   rejection_region_plot(boot_stats, [2.5, 97.5], 'both', 'Bootstrap Test', observed_stat);

    N = length(theta_hat);
    figure; hold on;
    histogram(theta_hat, floor(sqrt(N)), 'Normalization', 'pdf', 'HandleVisibility', 'off');
    ax = axis;

    if nargin > 4
        xmin = min(ax(1), test_stat);
        xmax = max(ax(2), test_stat);
    else
        xmin = ax(1);
        xmax = ax(2);
    end

    ymin = ax(3);
    ymax = ax(4);

    n_cv = length(cv);
    switch lower(tail)
        case 'both'

        assert(n_cv == 2, sprintf('Invalid number of critical values (%d) for 2-tailed test\n', n_cv));

        % Draw left rejection region
        x_patch = [xmin, cv(1), cv(1), xmin];
        y_patch = [ymin, ymin, ymax, ymax];
        patch(x_patch, y_patch, [1 0 0], 'FaceAlpha', 0.25, 'EdgeColor', 'none', 'HandleVisibility', 'off');
    
        % Draw right rejection region
        x_patch = [cv(2), xmax, xmax, cv(2)];
        y_patch = [ymin, ymin, ymax, ymax];
        patch(x_patch, y_patch, [1 0 0], 'FaceAlpha', 0.25, 'EdgeColor', 'none', 'HandleVisibility', 'off');
        case 'left'

        assert(n_cv == 1, sprintf('Invalid number of critical values (%d) for left-tailed test\n', n_cv));
   
        % Draw left rejection region
        x_patch = [xmin, cv, cv, xmin];
        y_patch = [ymin, ymin, ymax, ymax];
        patch(x_patch, y_patch, [1 0 0], 'FaceAlpha', 0.25, 'EdgeColor', 'none', 'HandleVisibility', 'off');

        case 'right'

        assert(n_cv == 1, sprintf('Invalid number of critical values (%d) for right-tailed test\n', n_cv));

        % Draw right rejection region
        x_patch = [cv, xmax, xmax, cv];
        y_patch = [ymin, ymin, ymax, ymax];
        patch(x_patch, y_patch, [1 0 0], 'FaceAlpha', 0.25, 'EdgeColor', 'none', 'HandleVisibility', 'off');

        otherwise
            error('Invalid tail argument (%s)\n', tail);
    end

    if nargin > 4
        plot(test_stat * [1, 1], [ymin, ymax], '-g', 'LineWidth', 2, 'DisplayName', 'Test Statistic');
        legend show;
    end
    xlabel('$\theta - \theta_0$', 'Interpreter', 'latex');
    ylabel('Relative Frequency');
    title(titleText);
    grid on;
end