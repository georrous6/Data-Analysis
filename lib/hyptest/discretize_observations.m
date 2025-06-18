function [observed_counts, expected_counts, dof] = discretize_observations(X, nbins, distribution)
% discretize_observations - Calculates observed and expected counts for binned data based on a distribution
%
% Syntax:
%   [observed_counts, expected_counts, dof] = discretize_observations(X, nbins, distribution)
%
% Inputs:
%   X            - Vector of observations
%   nbins        - Number of bins to divide the data into (must be >= 2)
%   distribution - String specifying theoretical distribution to compare against:
%                  'poisson', 'normal', 'uniform', or 'lognormal'
%
% Outputs:
%   observed_counts - Vector of observed counts in each bin
%   expected_counts - Vector of expected counts per bin according to specified distribution
%   dof             - Degrees of freedom for chi-square test adjusted for estimated parameters
%
% Description:
%   This function bins the data X into nbins bins, counts the observations in each bin,
%   and calculates expected counts assuming the specified distribution with parameters
%   estimated from the data. Degrees of freedom are adjusted to account for estimated parameters.
%
% Notes:
%   - For 'poisson', the rate parameter λ is estimated as the sample mean.
%   - For 'normal' and 'lognormal', mean and standard deviation are estimated from data.
%   - For 'uniform', minimum and maximum are estimated from data.
%   - The degrees of freedom (dof) equals nbins - 1 minus the number of estimated parameters.
%
% Example:
%   [obs, exp, dof] = discretize_observations(data, 10, 'normal');

    assert(nbins >= 2, 'Number of bins must be at least 2.');
    n = length(X);
    dof = nbins - 1;

    % Compute histogram edges
    [observed_counts, edges] = histcounts(X, nbins);
    
    % Compute expected probabilities based on chosen distribution
    probs = NaN(1, nbins);
    switch lower(distribution)
        case 'poisson'
            lambda_hat = mean(X);
            for i = 1:nbins
                low = edges(i);
                up = edges(i+1);
                probs(i) = poisscdf(floor(up) - 1, lambda_hat) - poisscdf(floor(low) - 1, lambda_hat);
            end
            dof = dof - 1;

        case 'normal'
            mu = mean(X);
            sigma = std(X);
            for i = 1:nbins
                low = edges(i);
                up = edges(i+1);
                probs(i) = normcdf(up, mu, sigma) - normcdf(low, mu, sigma);
            end
            dof = dof - 2;

        case 'uniform'
            a = min(X);
            b = max(X);
            for i = 1:nbins
                low = edges(i);
                up = edges(i+1);
                probs(i) = unifcdf(up, a, b) - unifcdf(low, a, b);
            end
            dof = dof - 2;

        case 'lognormal'
            % log(X) ~ N(mu, sigma)
            logX = log(X);
            mu = mean(logX);
            sigma = std(logX);
            for i = 1:nbins
                low = edges(i);
                up = edges(i+1);
                probs(i) = logncdf(up, mu, sigma) - logncdf(low, mu, sigma);
            end
            dof = dof - 2;

        otherwise
            error('Unsupported distribution: %s', distribution);
    end

    expected_counts = n * probs;
end
