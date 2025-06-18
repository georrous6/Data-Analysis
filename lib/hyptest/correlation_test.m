function [p_value, ci] = correlation_test(y, y_pred, alpha)
% correlation_test - Computes the significance and confidence interval of Pearson correlation
%
% Syntax:
%   [p_value, ci] = correlation_test(y, y_pred, alpha)
%
% Inputs:
%   y       - Vector of observed values
%   y_pred  - Vector of predicted or comparison values
%   alpha   - Significance level for confidence interval (e.g., 0.05 for 95% CI)
%
% Outputs:
%   p_value - Two-tailed p-value testing null hypothesis that correlation is zero
%   ci      - Confidence interval for the correlation coefficient at (1 - alpha) confidence level
%
% Description:
%   Computes the Pearson correlation coefficient between y and y_pred,
%   tests its significance using a t-distribution,
%   and calculates a Fisher z-transformed confidence interval for the correlation.
%
% Example:
%   [p, confInt] = correlation_test(actual_values, predicted_values, 0.05);
%
% Notes:
%   - Requires Statistics Toolbox for tcdf and norminv functions.
%   - The returned confidence interval ci is given in the original correlation scale [-1, 1].

    n = length(y);
    r = corr(y, y_pred);
    t_stat = r * sqrt((n - 2) / (1 - r^2));
    p_value = 2 * (1 - tcdf(abs(t_stat), n - 2));

    w = atanh(r);
    z_crit = norminv(1 - alpha/2);
    sigma_w = sqrt(1 / (n - 3));
    ci_transformed = [w - z_crit * sigma_w, w + z_crit * sigma_w];
    ci = tanh(ci_transformed);
end