function [p_value, critical_val, dof] = parametric_gof(X, distribution, nbins, alpha, titleText)

    [observed_counts, expected_counts, dof] = discretize_observations(X, nbins, distribution);

    chi2_stat = sum((observed_counts - expected_counts).^2 ./ expected_counts);

    p_value = 1 - chi2cdf(chi2_stat, dof);
    critical_val = chi2inv(1 - alpha, dof);

    if nargin > 4
        figure; hold on;
        histfit(X, nbins, distribution);
        xlabel('X');
        ylabel('Frequency');
        title(titleText);
        grid on;
    end
end