function p_val = Ex1Func1(X, n)
    N = length(X);
    n = min(n, N);
    idx = randperm(N, n);
    X_sample = X(idx);
    [~, p_val] = chi2gof(X_sample);
end