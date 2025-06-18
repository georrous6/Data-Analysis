function [p_value, critical_val, dof] = bootstrap_gof(X, B, distribution, nbins, sample_size, alpha, titleText)
% bootstrap_gof - Performs a bootstrap goodness-of-fit test using chi-square statistics
%
% Syntax:
%   [p_value, critical_val, dof] = bootstrap_gof(X, B, distribution, nbins, sample_size, alpha, titleText)
%
% Inputs:
%   X            - Vector of observed data samples
%   B            - Number of bootstrap samples to generate
%   distribution - Distribution or function handle used to compute expected counts
%   nbins        - Number of bins to discretize data for chi-square calculation
%   sample_size  - Number of samples in each bootstrap replicate
%   alpha        - Significance level for hypothesis testing (e.g., 0.05)
%   titleText    - (Optional) Title string for plot visualization of bootstrap distribution
%
% Outputs:
%   p_value      - Bootstrap p-value estimating goodness-of-fit significance
%   critical_val - Critical chi-square value at (1 - alpha) quantile from bootstrap distribution
%   dof          - Degrees of freedom used in chi-square test
%
% Description:
%   This function computes the chi-square goodness-of-fit statistic for observed data X
%   against an expected distribution. It uses bootstrap resampling to generate the null
%   distribution of the chi-square statistic and estimate a p-value. Optionally, a histogram
%   of the bootstrap chi-square values is plotted with the observed statistic and rejection
%   region highlighted.
%
% Example:
%   [p_val, crit_val, df] = bootstrap_gof(data, 1000, @normpdf, 10, length(data), 0.05, 'Bootstrap GOF Test');
%
% See also: discretize_observations, chi2cdf


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