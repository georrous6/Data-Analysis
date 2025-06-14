function [p_value, ci] = correlation_test(y, y_pred, alpha)
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