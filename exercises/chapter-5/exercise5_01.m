clc, clearvars, close all;

mux = 0;
muy = 0;
mu = [mux, muy];
sigmax = 1;
sigmay = 1;
M = 1000;        % Number of samples (X,Y)
n = 200;          % Sample size
rho = [0, 0.5];  % Correlation coefficients
alpha = 0.05;    % Significance level
exponent = 2;
rho2 = rho.^exponent;

r = zeros(length(rho), M);   % Correlation coefficient estimator values
w = zeros(length(rho), M);   % Correlation coefficient estimator values after Fisher transform
rl = zeros(length(rho), M);  % Lower bound of correlation coefficient
ru = zeros(length(rho), M);  % Upper bound of correlation coefficient

for i = 1:length(rho)
    covxy = sigmax * sigmay * rho(i);
    C = [sigmax^2, covxy; covxy, sigmay^2];

    for iM = 1:M
        XY = mvnrnd(mu, C, n);
        XY = XY.^exponent;
        tmp = corrcoef(XY);
        r(i, iM) = tmp(1, 2);
    end

    % Apply Fisher transform to the estimator of correlation coefficient
    sigmaw = sqrt(1 / (n - 3));
    zcrit = norminv(1 - alpha / 2);
    w(i,:) = 0.5 * log((1 + r(i,:)) ./ (1 - r(i,:)));
    rl(i,:) = w(i,:) - zcrit * sigmaw;
    ru(i,:) = w(i,:) + zcrit * sigmaw;
    % Apply inverse of Fisher tranform to the CI bounds of correlation coefficient
    rl(i,:) = (exp(2 * rl(i,:)) - 1) ./ (exp(2 * rl(i,:)) + 1);
    ru(i,:) = (exp(2 * ru(i,:)) - 1) ./ (exp(2 * ru(i,:)) + 1);

    prob = sum(rho2(i) > rl(i,:) & rho2(i) < ru(i,:)) / M;
    fprintf('rho=%.1f, M=%d, n=%d, alpha=%.2f: Pr(rho in [rl, ru])=%.4f\n', rho(i), M, n, alpha, prob);
    tstat = r(i,:) .* sqrt((n - 2) ./ (1 - r(i,:).^2));
    pval = 2 * (1 - tcdf(abs(tstat), n - 2));
    prob = sum(pval < alpha) / M;
    fprintf('rho=%.1f, M=%d, n=%d, alpha=%.2f, H0(rho=0), Rejection Rate: %.4f\n', rho(i), M, n, alpha, prob);
end

figure;
nbins = 20;
for i = 1:length(rho)
    subplot(2, 2, 2 * (i - 1) + 1);
    histogram(r(i,:), nbins, 'Normalization', 'pdf');
    hold on;
    plot(rho2(i) * [1, 1], ylim, '-r', 'LineWidth', 1);
    title(sprintf('r values (rho=%.1f, M=%d, n=%d)', rho(i), M, n));
    xlabel('r');
    ylabel('Relative Frequency');
    hold off;

    subplot(2, 2, 2 * (i - 1) + 2);
    histogram(w(i,:), nbins, 'Normalization', 'pdf');
    hold on;
    plot(0.5 * log((1 + rho2(i)) ./ (1 - rho2(i))) * [1, 1], ylim, '-r', 'LineWidth', 1);
    title(sprintf('Fisher transform of r (rho=%.1f, M=%d, n=%d)', rho(i), M, n));
    xlabel('tanh(r)');
    ylabel('Relative Frequency');
    hold off;
end

figure;
for i = 1:length(rho)
    subplot(2, 2, 2 * (i - 1) + 1);
    histogram(rl(i,:), nbins, 'Normalization', 'pdf');
    hold on;
    plot(rho2(i) * [1, 1], ylim, '-r', 'LineWidth', 1);
    title(sprintf('Lower r (rho=%.1f, M=%d, n=%d)', rho(i), M, n));
    xlabel('Lower r');
    ylabel('Relative Frequency');
    hold off;

    subplot(2, 2, 2 * (i - 1) + 2);
    histogram(ru(i,:), nbins, 'Normalization', 'pdf');
    hold on;
    plot(rho2(i) * [1, 1], ylim, '-r', 'LineWidth', 1);
    title(sprintf('Upper r (rho=%.1f, M=%d, n=%d)', rho(i), M, n));
    xlabel('Upper r');
    ylabel('Relative Frequency');
    hold off;
end
