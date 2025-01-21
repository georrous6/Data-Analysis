% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

% Function for resampling-based chi-square goodness-of-fit test
function [p_resample, X2_0, empirical_X2] = Group19Exe2Fun1(data, n_resamples)
    % Estimate the parameter for the exponential distribution from the initial data
    lambda_hat = 1 / mean(data); % Rate parameter (1/mean)
    
    % Chi-square statistic for the original data
    [~, ~, stats] = chi2gof(data, 'CDF', @(x) expcdf(x, 1 / lambda_hat));
    X2_0 = stats.chi2stat;
    
    % Resampling
    empirical_X2 = zeros(n_resamples, 1);
    for i = 1:n_resamples
        % Generate random sample from the exponential distribution we test
        simulated_data = exprnd(1 / lambda_hat, size(data));
        % Chi-square statistic for simulated random samples
        [~, ~, sim_stats] = chi2gof(simulated_data, 'CDF', @(x) expcdf(x, 1 / lambda_hat));
        empirical_X2(i) = sim_stats.chi2stat;
    end
    
    % One-sided test:
    % The resulting value, p_resample, is the empirical p-value for the right-tailed test.
    % A smaller p-value indicates that X2_0​ lies farther in the right tail of the distribution, 
    % suggesting stronger evidence against the null hypothesis.
    p_resample = mean(empirical_X2 >= X2_0);
end
