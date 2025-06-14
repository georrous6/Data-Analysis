function [p_value, ci] = bootstrap_hypothesis_test(X, theta_0, B, sample_size, f_stat, alpha, titleText)
    n = length(X);
    theta_stat = f_stat(X) - theta_0;
    boot_stat = NaN(B, 1);
    for i = 1:B
        idx = randi(n, [1, sample_size]);
        X_boot = X(idx);
        boot_stat(i) = f_stat(X_boot) - theta_0;
    end

    lower = prctile(boot_stat, alpha / 2 * 100);
    upper = prctile(boot_stat, (1 - alpha / 2) * 100);
    ci = [lower, upper];
    p_value = mean(abs(boot_stat) >= abs(theta_stat));

    if nargin > 6
        figure; hold on;
        histogram(boot_stat, floor(sqrt(B)), 'Normalization', 'pdf');
        ax = axis;

        % Draw left rejection region
        x_patch = [ax(1), ci(1), ci(1), ax(1)];
        y_patch = [ax(3), ax(3), ax(4), ax(4)];
        patch(x_patch, y_patch, [1 0 0], 'FaceAlpha', 0.25, 'EdgeColor', 'none');

        % Draw right rejection region
        x_patch = [ci(2), ax(2), ax(2), ci(2)];
        y_patch = [ax(3), ax(3), ax(4), ax(4)];
        patch(x_patch, y_patch, [1 0 0], 'FaceAlpha', 0.25, 'EdgeColor', 'none');

        plot(theta_stat * [1, 1], [ax(3), 0.5 * ax(4)], '-g', 'LineWidth', 2);
        xlabel('$\theta - \theta_0$', 'Interpreter', 'latex');
        ylabel('Relative Frequency');
        title(titleText);
        grid on;
    end
end