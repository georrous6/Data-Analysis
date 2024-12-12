clc, clearvars, close all;
% Question (a)

n = 1000; % Sample size
mu_real = 5;
X = exprnd(mu_real, 1, n);

mu_mle = mean(X);
xvalues = min(X):max(X);
yvalues = exppdf(xvalues, mu_mle);

figure;
histogram(X, 'Normalization', 'pdf', 'DisplayName', sprintf('mu=%.2f (real)', mu_real));
hold on;
plot(xvalues, yvalues, '-r', 'LineWidth', 2, 'DisplayName', sprintf('mu=%.2f (MLE)', mu_mle));
hold off;
title('Exponential Distribution: MLE for Mean Parameter');
xlabel('X');
ylabel('Probability Density');
legend show;

% Question (b)
% Parameters
M_values = [10, 100, 1000]; % Number of samples
n_values = [10, 100, 1000]; % Sample sizes
mu = 3;

% Display table header
fprintf('%-10s %-10s %-10s %-20s\n', 'M', 'n', 'mu', 'Mean of Sample Means');
fprintf('%s\n', repmat('-', 1, 55)); % Separator line

for M = M_values
    for n = n_values
        mean_of_sample_means = exp_samples(M, n, mu);
        fprintf('%10d %10d %10.2f %20.4f\n', M, n, mu, mean_of_sample_means);
        pause;
        close all;
    end
end


function mean_of_sample_means = exp_samples(M, n, mu)
    samples = exprnd(mu, n, M);
    sample_means = mean(samples);
    mean_of_sample_means = mean(sample_means);
    
    figure;
    histogram(sample_means, 'Normalization', 'pdf', 'DisplayName', 'sample means data');
    hold on;
    ax = axis;
    plot([mu, mu], [ax(3), ax(4)], '-y', 'LineWidth', 2, 'DisplayName', 'mu');
    plot([mean_of_sample_means, mean_of_sample_means], [ax(3), ax(4)], '-g', ...
        'LineWidth', 2, 'DisplayName', 'mean of sample means');
    xvalues = linspace(min(sample_means), max(sample_means), 100);
    yvalues = normpdf(xvalues, mean_of_sample_means, std(sample_means));
    plot(xvalues, yvalues, '-r', 'LineWidth', 2, 'DisplayName', 'Normal Distribution Fit');
    hold off;
    title(sprintf('Distribution of Sample Means (M=%d, n=%d, mu=%d)', M, n, mu));
    xlabel('Sample Means');
    ylabel('Probability Density');
    legend show;
end