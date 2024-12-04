%% Exercise 3.3
clc, clearvars, close all;
lambda = 1 / 15;
true_mean = 1 / lambda;

% compute parametric interval
n = 1000; % size of sample
X = exprnd(true_mean, 1, n);
[~, ~, CI] = ttest(X, true_mean);

fprintf("Confidence interval: [%f, %f]\n", CI(1, 1), CI(1, 2));

% (a)
M = 1000; % number of samples
n = 5; % size of each sample
X = zeros(n, M); % preallocate memory

% Initialize matrix X
for i = 1:M
    X(:,i) = exprnd(true_mean, 1, n);
end

H = ttest(X, true_mean);
proportion = (M - sum(H)) / M;
fprintf("H0 acceptance rate (n=%d): %f\n", n, proportion);

% (b)
M = 1000; % number of samples
n = 100; % size of each sample
X = zeros(n, M); % preallocate memory

% Initialize matrix X
for i = 1:M
    X(:,i) = exprnd(true_mean, 1, n);
end

H = ttest(X, 1 / lambda);
proportion = (M - sum(H)) / M;
fprintf("H0 acceptance rate (n=%d): %f\n", n, proportion);
