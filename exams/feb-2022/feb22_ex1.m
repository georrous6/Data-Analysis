clc, clearvars, close all;
addpath(genpath(fullfile('..', '..', 'lib')));

%% (a)

n = 20;
X = randn(n, 1);
B = 100;
alpha = 0.05;

skew = @(x) 1 / n * sum((x - mean(x)).^3) / (1 / n * sum((x - mean(x)).^2))^(3/2);
kurt = @(x) 1 / n * sum((x - mean(x)).^4) / (1 / n * sum((x - mean(x)).^2))^2;

skewness_0 = 0;
kurtosis_0 = 3;
p_value_skew = bootstrap_hypothesis_test(X, skewness_0, B, n, skew, alpha, 'Skewness Empirical PDF (Under H_0)');
p_value_kurtosis = bootstrap_hypothesis_test(X, kurtosis_0, B, n, kurt, alpha, 'Kurtosis Empirical PDF (Under H_0)');

fprintf('We %s the hypothesis that the skewness is equal to %.2f for %.2f significance level\n', ...
    ternary(p_value_skew > alpha, 'CANNOT reject', 'reject'), skewness_0, alpha);
fprintf('We %s the hypothesis that the kurtosis is equal to %.2f for %.2f significance level\n', ...
    ternary(p_value_kurtosis > alpha, 'CANNOT reject', 'reject'), kurtosis_0, alpha);
fprintf('We %s the hypothesis that the data come from normal distribution for %.2f significance level\n', ...
    ternary(p_value_skew > alpha, 'CANNOT reject', 'reject'), alpha);

%% (b)

B = 20;
N = 10;
n_values = [20, 100];
for n = n_values

    X = 4 * randn(N, n);
    rejection_rates = normal_gof(X, B, alpha, skew, kurt);
    fprintf('Case 1: X ~ N(0, 4)\n');
    fprintf('Bootstrap skew/kurt rejection rate (n=%d): =%f\n', n, rejection_rates(1));
    fprintf('Bootstrap general GoF rejection rate (n=%d): =%f\n', n, rejection_rates(2));

    Y = 4 * randn(N, n);
    X = Y.^2;
    rejection_rates = normal_gof(X, B, alpha, skew, kurt);
    fprintf('Case 2: Y ~ N(0, 4), X = Y^2\n');
    fprintf('Bootstrap skew/kurt test rejection rate (n=%d): %f\n', n, rejection_rates(1));
    fprintf('Bootstrap general GoF rejection rate (n=%d): %f\n', n, rejection_rates(2));

    Y = 4 * randn(N, n);
    X = Y.^3;
    rejection_rates = normal_gof(X, B, alpha, skew, kurt);
    fprintf('Case 3: Y ~ N(0, 4), X = Y^3\n');
    fprintf('Bootstrap skew/kurt test rejection rate (n=%d): %f\n', n, rejection_rates(1));
    fprintf('Bootstrap general GoF rejection rate (n=%d): %f\n', n, rejection_rates(2));
end


function rejection_rates = normal_gof(X, B, alpha, skew, kurt)
    rejection_rates = zeros(1, 2);
    skewness_0 = 0;
    kurtosis_0 = 3;
    [N, n] = size(X);
    for i = 1:N
        p_value_skew = bootstrap_hypothesis_test(X(i,:), skewness_0, B, n, skew, alpha);
        p_value_kurtosis = bootstrap_hypothesis_test(X(i,:), kurtosis_0, B, n, kurt, alpha);
        rejection_rates(1) = rejection_rates(1) + (p_value_skew < alpha || p_value_kurtosis < alpha);

        p_val = bootstrap_gof(X(i,:), B, 'normal', n, n, alpha);
        rejection_rates(2) = rejection_rates(2) + (p_val < alpha);
    end

    rejection_rates = rejection_rates / N;
end
