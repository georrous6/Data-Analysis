function [p_value, critical_val, dof] = parametric_gof(X, distribution, nbins, alpha, titleText)
% parametric_gof - Performs a parametric goodness-of-fit test using chi-square statistic
%
% Syntax:
%   [p_value, critical_val, dof] = parametric_gof(X, distribution, nbins, alpha, titleText)
%
% Inputs:
%   X            - Vector of observations
%   distribution - String specifying theoretical distribution ('poisson', 'normal', 'uniform', 'lognormal')
%   nbins        - Number of bins for discretization (must be >= 2)
%   alpha        - Significance level for hypothesis test (e.g., 0.05)
%   titleText    - (Optional) Title for plot visualization
%
% Outputs:
%   p_value      - P-value of the chi-square goodness-of-fit test
%   critical_val - Critical chi-square value at significance level alpha
%   dof          - Degrees of freedom used in the test
%
% Description:
%   This function performs a chi-square goodness-of-fit test by comparing the observed
%   bin counts of data X to expected counts under a specified parametric distribution.
%   The distribution parameters are estimated from X, and the data is binned into nbins bins.
%   The test statistic is compared to the chi-square distribution to compute p-value.
%
%   If titleText is provided, a histogram with fitted distribution curve is displayed.
%
% Example:
%   [p, cv, dof] = parametric_gof(data, 'normal', 10, 0.05, 'Normal GOF Test');

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