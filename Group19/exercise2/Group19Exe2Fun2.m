% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

% Parametric chi-square goodness-of-fit test
function [p_param, X2_param] = Group19Exe2Fun2(data)
    lambda_hat = 1 / mean(data);
    [~, p_param, stats] = chi2gof(data, 'CDF', @(x) expcdf(x, 1 / lambda_hat));
    X2_param = stats.chi2stat;
end
