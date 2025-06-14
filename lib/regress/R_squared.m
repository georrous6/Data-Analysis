function R2 = R_squared(y, y_hat)
    y = y(:);
    y_hat = y_hat(:);
    R2 = 1 - sum((y - y_hat).^2) / sum((y - mean(y)).^2);
end