function [p_value, critical_val, dof] = bootstrap_gof(X, B, distribution, nbins, sample_size, alpha, titleText)

    n = length(X);
    [observed_counts, expected_counts, dof] = discretize_observations(X, nbins, distribution);

    chi2_stat = sum((observed_counts - expected_counts).^2 ./ expected_counts);
    chi2_boot = NaN(1, B);
    for i = 1:B
        boot_idx = randi(n,[1, sample_size]);
        X_boot = X(boot_idx);
        [observed_counts, expected_counts] = discretize_observations(X_boot, nbins, distribution);
        chi2_boot(i) = sum((observed_counts - expected_counts).^2 ./ expected_counts);
    end

    p_value = mean(chi2_boot >= chi2_stat);
    critical_val = prctile(chi2_boot, 100 * (1 - alpha));

    if nargin > 6
        figure; hold on;
        histogram(chi2_boot, floor(sqrt(B)), 'Normalization', 'probability');
        ax = axis;
        plot(chi2_stat * [1, 1], [0, 0.5 * ax(4)], '-g', 'LineWidth', 2);
    
        % Draw transparent red rectangle over rejection region
        x_patch = [critical_val, ax(2), ax(2), critical_val];
        y_patch = [ax(3), ax(3), ax(4), ax(4)];
        patch(x_patch, y_patch, [1 0 0], 'FaceAlpha', 0.25, 'EdgeColor', 'none');
    
        xlabel('$\chi^2$', 'Interpreter', 'latex');
        ylabel('Relative Frequency');
        title(titleText);
        grid on;
    end
end