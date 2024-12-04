%% Exercise 3.1 (a)
clc, clearvars, close all;

n = 1000; % sample size
lambda_real = 7; % assume an actual value for lambda
X = poissrnd(lambda_real, 1, n); % create the sample data
sumX = sum(X);
lambda_mle = sumX / n; % maximum likelihood estimator (MLE) for lambda

figure(1);
histogram(X, 'Normalization', 'pdf'); % plot sample data
hold on;
x_values = 0:max(X);
poisson_mle_pdf = poisspdf(x_values, lambda_mle);
plot(x_values, poisson_mle_pdf, 'r-', 'LineWidth', 2);
title('Poisson Distribution with MLE');
xlabel('Value');
ylabel('Probability Density');
legend('Sample Data', 'MLE Poisson Fit');

% plot Log-likelihood function for different lambda values
% assume the random variables x1, x2, ..., xn of the sample are independent
lambdas = linspace(0, 2 * lambda_mle, 1000);

figure(2);
Y = -lambdas * n + sumX * log(lambdas); % function of lambda to maximize
[max_value, max_index] = max(Y);
plot(lambdas, Y);
hold on;
plot(lambdas(max_index), max_value, 'xr');
title('Log-likelihood function for Poisson distribution');
xlabel('$\lambda$', 'Interpreter', 'latex');
ylabel('ln(L($\lambda$))', 'Interpreter', 'latex');


%% Exercise 3.1 (b)
clc, clearvars, close all;
M = 1000;
n = 100;
lambda = 5;
mu = poisson_samples(M, n, lambda);
fprintf("Mean of sample means: %f\n", mu);


function mu = poisson_samples(M, n, lambda)
    sample_means = zeros(1, M);
    for i = 1:M
        X = poissrnd(lambda, 1, n);
        sample_means(i) = mean(X);
    end

    figure;
    histogram(sample_means, 'Normalization', 'pdf'); % plot sample data
    hold on;
    x_values = linspace(min(sample_means), max(sample_means), 1000);
    mu = mean(sample_means);
    theoretical_pdf = normpdf(x_values, mu, sqrt(mu / n));
    plot(x_values, theoretical_pdf, 'r-', 'LineWidth', 2);
    title('Distribution of Sample Means from Poisson Distribution');
    xlabel('Sample Means');
    ylabel('Probability Density');
    legend('Histogram of Sample Means', 'Theoretical Normal Distribution');
end
