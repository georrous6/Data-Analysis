function [p_value, cv] = bootstrap_hypothesis_test(X, test_stat, B, sample_size, f_stat, alpha, tail, titleText)
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
