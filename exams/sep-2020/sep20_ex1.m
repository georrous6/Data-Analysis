clc; clearvars; close all;
addpath(genpath(fullfile('..', '..', 'lib')));

data = load('Topic1DataSept2020.dat');
X_all = data(:,1);
Y_all = data(:,2);
nx_all = size(X_all, 1);
ny_all = size(Y_all, 1);
n = 20;
n_tests = 20;

alpha = 0.05;
B = 100;
p_values = NaN(n_tests, 4);

for i = 1:n_tests
    X = X_all(randperm(nx_all, n));
    Y = Y_all(randperm(ny_all, n));

    % figure;
    % subplot(1, 2, 1); boxplot(X); title(sprintf('X (Iteration %d)', i));
    % subplot(1, 2, 2); boxplot(Y); title(sprintf('Y (Iteration %d)', i));

    p_values(i,:) = logtranstest(X, Y, alpha, B);
end

rejection_rates = 100 * mean(p_values < alpha, 1);
fprintf('Rejection Rates\n');
fprintf('1. t-test (without transformation): %.2f%%\n', rejection_rates(1));
fprintf('2. t-test (with transformation): %.2f%%\n', rejection_rates(2));
fprintf('3. bootstrap test (without transformation): %.2f%%\n', rejection_rates(3));
fprintf('4. bootstrap test (with transformation): %.2f%%\n', rejection_rates(4));


function p_val = logtranstest(X, Y, alpha, B)
    p_val = NaN(4, 1);
    valid = isfinite(log(X)) & isfinite(log(Y));
    logX = log(X(valid));
    logY = log(Y(valid));
    [~, p_val(1)] = ttest(X, Y, 'Alpha', alpha);
    [~, p_val(2)] = ttest(logX, logY, 'Alpha', alpha);
    p_val(3) = bootstrap_hypothesis_test2(X, Y, 0, B, B, @(X, Y) mean(X) - mean(Y), alpha, 'both');
    p_val(4) = bootstrap_hypothesis_test2(logX, logY, 0, B, B, @(X, Y) mean(X) - mean(Y), alpha, 'both');
end