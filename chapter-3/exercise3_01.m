clc, clearvars, close all;
% Question (a)

n = 1000; % Sample size
lambda_real = 5;
X = poissrnd(lambda_real, 1, n);

lambda_mle = mean(X);
xvalues = min(X):max(X);
yvalues = poisspdf(xvalues, lambda_mle);

figure;
histogram(X, 'Normalization', 'pdf', 'DisplayName', sprintf('lambda=%.2f (real)', lambda_real));
hold on;
stem(xvalues, yvalues, '-r', 'LineWidth', 2, 'DisplayName', sprintf('lambda=%.2f (MLE)', lambda_mle));
hold off;
title('Poisson Distribution: MLE for Lambda Parameter');
xlabel('X');
ylabel('Probability Density');
legend show;

% Question (b)
% Parameters
M_values = [10, 100, 1000]; % Number of samples
n_values = [10, 100, 1000]; % Sample sizes
lambda = 3;

% Display table header
fprintf('%-10s %-10s %-10s %-20s\n', 'M', 'n', 'lambda', 'Mean of Sample Means');
fprintf('%s\n', repmat('-', 1, 55)); % Separator line

for M = M_values
    for n = n_values
        mean_of_sample_means = poisson_samples(M, n, lambda);
        fprintf('%10d %10d %10.2f %20.4f\n', M, n, lambda, mean_of_sample_means);
        pause;
        close all;
    end
end


function mean_of_sample_means = poisson_samples(M, n, lambda)
    samples = poissrnd(lambda, n, M);
    sample_means = mean(samples);
    mean_of_sample_means = mean(sample_means);
    
    figure;
    histogram(sample_means, 'Normalization', 'pdf', 'DisplayName', 'sample means data');
    hold on;
    plot([lambda, lambda], [0, max(ylim) / 2], '-y', 'LineWidth', 2, 'DisplayName', 'lambda');
    plot([mean_of_sample_means, mean_of_sample_means], [0, max(ylim) / 2], '-g', ...
        'LineWidth', 2, 'DisplayName', 'mean of sample means');
    xvalues = linspace(min(sample_means), max(sample_means), 100);
    yvalues = normpdf(xvalues, mean_of_sample_means, std(sample_means));
    plot(xvalues, yvalues, '-r', 'LineWidth', 2, 'DisplayName', 'Normal Distribution Fit');
    hold off;
    title(sprintf('Distribution of Sample Means (M=%d, n=%d, lambda=%d)', M, n, lambda));
    xlabel('Sample Means');
    ylabel('Probability Density');
    legend show;
end