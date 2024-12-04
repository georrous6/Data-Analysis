%% Exercise 2.5
clc, clearvars, close all;

n = 100000;
mu = 4.;
sigma = sqrt(0.01);
X = mu + sigma * randn(1, n);

% Rejection probability
prob = sum(X < 3.9) / n;
theoretical_prob = normcdf(3.9, mu, sigma);
fprintf("Pr(X < 3.9) = %f\n", prob);
fprintf("Pr(X < 3.9) = %f (theoretical)\n", theoretical_prob);

% Upper bound calculation
bound = norminv(0.01, mu, sigma);
fprintf("bound = %f\n", bound);

histogram(X, 'Normalization', 'pdf');
