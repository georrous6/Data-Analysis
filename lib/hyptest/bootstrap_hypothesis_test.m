function [p_value, cv] = bootstrap_hypothesis_test(X, test_stat, B, sample_size, f_stat, alpha, tail, titleText)
% bootstrap_hypothesis_test - Performs a bootstrap hypothesis test for a given test statistic
%
% Syntax:
%   [p_value, cv] = bootstrap_hypothesis_test(X, test_stat, B, sample_size, f_stat, alpha, tail, titleText)
%
% Inputs:
%   X           - Vector of observed data samples
%   test_stat   - Observed test statistic value to compare against bootstrap distribution
%   B           - Number of bootstrap samples to generate
%   sample_size - Number of samples in each bootstrap replicate
%   f_stat      - Function handle that computes the test statistic from a sample vector
%   alpha       - Significance level for hypothesis testing (e.g., 0.05)
%   tail        - Tail type for the test: 'both', 'left', or 'right'
%   titleText   - (Optional) Title string for plot visualization of bootstrap distribution
%
% Outputs:
%   p_value     - Bootstrap p-value estimating significance of the test statistic
%   cv          - Critical value(s) from bootstrap distribution corresponding to alpha
%                 For 'both' tail, cv is a two-element vector [lower, upper];
%                 For 'left' or 'right' tail, cv is a scalar
%
% Description:
%   This function computes the bootstrap distribution of a test statistic computed by f_stat,
%   comparing the observed test_stat to the bootstrap replicates. It calculates the p-value
%   based on the chosen tail of the test and returns the critical value(s). Optionally,
%   it produces a plot showing the bootstrap distribution, critical regions, and test statistic.
%
% Example:
%   % Test if mean is significantly different from 0 using bootstrap
%   fmean = @(x) mean(x);
%   [p, cv] = bootstrap_hypothesis_test(data, 0, 1000, length(data), fmean, 0.05, 'both', 'Bootstrap Mean Test');
%
% See also: rejection_region_plot

    n = length(X);
    original_stat = f_stat(X) - test_stat;
    boot_stat = NaN(B, 1);
    for i = 1:B
        idx_X = randi(n, [1, sample_size]);
        X_boot = X(idx_X);
        boot_stat(i) = f_stat(X_boot) - test_stat;
    end

    switch lower(tail)
        case 'both'
            low = prctile(boot_stat, alpha / 2 * 100);
            up = prctile(boot_stat, (1 - alpha / 2) * 100);
            cv = [low, up];
            p_value = mean(abs(boot_stat) >= abs(original_stat));
        case 'left'
            cv = prctile(boot_stat, alpha * 100);
            p_value = mean(boot_stat <= original_stat);
        case 'right'
            cv = prctile(boot_stat, (1 - alpha) * 100);
            p_value = mean(boot_stat >= original_stat);
        otherwise
            error('Invalid tail option: %s', tail);
    end

    if nargin > 7
        rejection_region_plot(boot_stat, cv, tail, titleText, test_stat);
    end
end
