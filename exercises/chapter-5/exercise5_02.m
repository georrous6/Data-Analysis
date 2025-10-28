clc, clearvars, close all;

M = 100;
L = 1000;
n = 200;
alpha = 0.05;
mux = 0;
muy = 0;
sigmax = 1;
sigmay = 1;
rho = 0.0;  % 0.0 or 0.5
exponent = 1;
mu = [0, 0];
covxy = sigmax * sigmay * rho;
sigma = [sigmax^2, covxy; covxy, sigmay^2];
r = zeros(1, L + 1);
t0 = zeros(1, M);
tci = zeros(M, 2);

for iM = 1:M
    XY = mvnrnd(mu, sigma, n);
    XY = XY.^exponent;
    C = corrcoef(XY);
    r0 = C(1, 2);
    t0(iM) = r0 * sqrt((n - 2) / (1 - r0^2));
    
    r(1) = r0;
    for iL = 1:L
        newY = XY(randperm(n), 2);
        C = corrcoef(XY(:,1), newY);
        r(iL + 1) = C(1, 2);
    end

    t = r .* sqrt((n - 2) ./ (1 - r.^2));
    tci(iM,:) = prctile(t, 100 * [alpha / 2, 1 - alpha / 2]);
    clc;
    fprintf('%-50s\t\t%d%%\n', [repmat('#', 1, round(iM / 2)), repmat('.', 1, 50 - round(iM / 2))], round(iM / M * 100));
end

figure;
nbins = 20;
histogram(t0, nbins, 'Normalization', 'pdf');
title('Original Sample t-statistic');
xlabel('t');
ylabel('Relative Frequency');

figure;
subplot(1, 2, 1);
histogram(tci(:,1), nbins, 'Normalization', 'pdf');
title(sprintf('t-statistic %.2f%%', 100 * alpha / 2));
xlabel('t');
ylabel('Relative Frequency');

subplot(1, 2, 2);
histogram(tci(:,2), nbins, 'Normalization', 'pdf');
title(sprintf('t-statistic %.2f%%', 100 * (1 - alpha / 2)));
xlabel('t');
ylabel('Relative Frequency');

prob = 1 - sum(tci(:,1) < t0(:) & t0(:) < tci(:,2)) / M;
fprintf('M=%d, n=%d, L=%d, alpha=%.2f, H0(rho = %.1f), Rejection rate: %.4f\n', M, n, L, alpha, rho, prob);
