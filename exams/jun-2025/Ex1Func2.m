function ci = Ex1Func2(X, Y, B, alpha)
% Test if the two samples come from distributions with equal means using
% bootstrap method

    nx = length(X);
    ny = length(Y);
    n = min(nx, ny);
    boot_stat = NaN(B, 1);
    for i = 1:B
        idx_X = randi(nx, [1, n]);
        idx_Y = randi(ny, [1, n]);
        X_boot = X(idx_X);
        Y_boot = Y(idx_Y);
        boot_stat(i) = mean(X_boot) - mean(Y_boot);
    end

    low = prctile(boot_stat, alpha / 2 * 100);
    up = prctile(boot_stat, (1 - alpha / 2) * 100);
    ci = [low, up];
end