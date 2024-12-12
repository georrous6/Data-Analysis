clc, clearvars, close all;

exp_transform = true;
n = 10;  % Sample size
B = 1000;  % Number of bootstrap samples
mu = 0;
sigma = 1;
X = normrnd(mu, sigma, 1, n);
if exp_transform
    X = exp(X);
end
muX = mean(X);
bootstrap_means = zeros(1, B);

% Question (a)
for i = 1:B
    idx = randi(n, 1, n);
    bootstrap_means(i) = mean(X(idx));
end

figure;
histfit(bootstrap_means);
hold on;
ax = axis;
plot([muX, muX], [ax(3), ax(4) / 5], '-g', 'LineWidth', 2);
hold off;
title('Original vs Bootstrap Sample Means');
xlabel('Mean');
ylabel('Frequency');
legend('Bootstrap Sample Means', 'Fitted Normal Distribution', 'Original Sample Mean');

% Question (b)
seB = std(bootstrap_means);
seX = std(X) / sqrt(n);
fprintf('Bootstrap standard error estimation: %.5f\n', seB);
fprintf('Original sample standard error estimation: %.5f\n', seX);
se_actual = sigma / sqrt(n);
if exp_transform
    se_actual = sqrt(exp(2 * mu + sigma^2) * (exp(sigma^2) - 1)) / sqrt(n);
end
fprintf('Actual standard error: %.5f\n', se_actual);
