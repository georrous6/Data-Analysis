function adjR2 = Ex1Func5(y, y_hat, k)
    y = y(:);
    y_hat = y_hat(:);
    n = length(y);
    adjR2 = 1 - (n - 1) / (n - (k + 1)) * sum((y - y_hat).^2) / sum((y - mean(y)).^2);
end