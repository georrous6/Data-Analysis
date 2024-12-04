%% Exercise 3.4
clc, clearvars, close all;
data = load('ex3_4_input.txt');
X = data(:)';
V = var(X);

% a) 95% confidence interval for variance
[~, ~, CI] = vartest(X, V);
fprintf("a)95%% Confidence interval for standard deviation: [%f, %f]\n", sqrt(CI(1, 1)), sqrt(CI(1, 2)));

% b) H0: variance is 5^2
[H, ~, ~] = vartest(X, 5^2);
fprintf("b) Reject H0 (1 for rejection, 0 for acceptance): %d\n", H);

% c) confidence interval for mean
mu = mean(X);
[~, ~, CI] = ttest(X);
fprintf("c)95%% Confidence interval for mean: [%f, %f]\n", CI(1, 1), CI(1, 2));

% d) H0: mean is 52
[H, ~, ~] = ttest(X, 52);
fprintf("d) Reject H0 (1 for rejection, 0 for acceptance): %d\n", H);

% e) Perform a chi-square goodness-of-fit test
[H, P] = chi2gof(X);
fprintf("e) Reject H0 (1 for rejection, 0 for acceptance): %d, p-value: %f\n", H, P);
