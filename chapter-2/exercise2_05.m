clc, clearvars, close all;

n = 10000000;
mu = 4;
std = 0.1;
X = mu + std * randn(1, n);

threshold = 3.9;
prob_rejected_theoretical = normcdf(threshold, mu, std);
prob_rejected_simulation = sum(X < threshold) / length(X);
fprintf('Pr(X < %.4f) = %.6f (theoretical)\n', threshold, prob_rejected_theoretical);
fprintf('Pr(X < %.4f) = %.6f (simulation)\n', threshold, prob_rejected_simulation);

prob_rejected_theoretical = 0.01;
threshold = norminv(prob_rejected_theoretical, 4, 0.1);
% Alternatively: threshold = mu + std * norminv(prob_rejected_theoretical, 0, 1);
prob_rejected_simulation = sum(X < threshold) / length(X);
fprintf('Pr(X < %.4f) = %.6f (theoretical)\n', threshold, prob_rejected_theoretical);
fprintf('Pr(X < %.4f) = %.6f (simulation)\n', threshold, prob_rejected_simulation);
