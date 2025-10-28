clc, clearvars, close all;

rainData = load('rainThes59_97.dat');
tempData = load('tempThes59_97.dat');

alpha = 0.05;
n = size(rainData, 1);  % Sample size (years)
m = size(rainData, 2);  % Number of samples (months)
L = 1000;
rejprobs = zeros(1, 3);

for i = 1:m
    X = rainData(:,i);
    Y = tempData(:,i);
    fprintf('--- Month %d ---\n', i);

    % Parametric hypothesis testing for zero correlation (built-in)
    [R, P, RLO, RUP] = corrcoef(X, Y);
    fprintf('Parametric Corr Coef (built-in): r=%.4f, p-value=%.4f, CI=[%.4f, %.4f]', R(1, 2), P(1, 2), RLO(1, 2), RUP(1, 2));
    if P(1, 2) < alpha
        fprintf(' -> Reject H0\n');
        rejprobs(1) = rejprobs(1) + 1;
    else
        fprintf(' -> No reject H0\n');
    end
    
    % Parametric hypothesis testing for zero correlation (manually)
    r = R(1, 2);
    % Apply Fisher transformation to the correlation coefficient estimator
    w = 0.5 * log((1 + r) / (1 - r));
    sigmaw = sqrt(1 / (n - 3));
    zcrit = norminv(1 - alpha / 2);
    CI = [w - zcrit * sigmaw, w + zcrit * sigmaw];
    % Apply inverse of Fisher transformation to the confidence interval
    CI = (exp(2 * CI) - 1) ./ (exp(2 * CI) + 1);
    t = r * sqrt((n - 2) / (1 - r^2));
    pval = 2 * (1 - tcdf(abs(t), n - 2));
    fprintf('Parametric Corr Coef (manually): r=%.4f, p-value=%.4f, CI=[%.4f, %.4f]', r, pval, CI(1), CI(2));
    if pval < alpha
        rejprobs(2) = rejprobs(2) + 1;
        fprintf(' -> Reject H0\n');
    else
        fprintf('-> No reject H0\n');
    end

    % Randomization hypothesis testing for zero correlation
    r_0 = r;
    t_0 = t;
    r = zeros(1, L + 1);
    r(1) = r_0;
    for j = 1:L
        Y = Y(randperm(n));
        R = corrcoef(X, Y);
        r(j + 1) = R(1, 2);
    end
    t = r .* sqrt((n - 2) ./ (1 - r.^2));
    tbounds = prctile(t, 100 * [alpha / 2, 1 - alpha / 2]);
    fprintf('Randomized Corr Coef hypothesis testing: t_0=%.4f, CI=[%.4f, %.4f]', t_0, tbounds(1), tbounds(2));
    if t_0 < tbounds(1) || t_0 > tbounds(2)
        rejprobs(3) = rejprobs(3) + 1;
        fprintf(' -> Reject H0\n');
    else
        fprintf(' -> No reject H0\n');
    end
end

fprintf('===========\n');
rejprobs = rejprobs ./ m;
fprintf('Parametric Rejection probability H0(rho=0), alpha=%.2f (manually): %.4f\n', alpha, rejprobs(1));
fprintf('Parametric Rejection probability H0(rho=0), alpha=%.2f (built-in): %.4f\n', alpha, rejprobs(2));
fprintf('Randomized Rejection probability H0(rho=0), alpha=%.2f: %.4f\n', alpha, rejprobs(3));
