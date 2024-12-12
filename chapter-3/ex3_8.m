clc, clearvars, close all;

n = 10;                    % Sample size
M = 100;                   % Number of samples
B = 1000;                  % Number of bootstrap samples per dataset
mu = 0;                    % True mean of the population
sigma = 1;                 % Standard deviation of the population
alpha = 0.05;              % Significance level
squared_transform = true;  % If set to true, apply a square transformation to the data

CI = NaN(M, 6);   % the two first are the limits of parametric CI for standard deviation  
                  % the other two for the percentile bootstrap CI for standard deviation,
                  % the final two for the bias corrected and accelerated 
                  % percentile method, which is the default bootstrap in Matlab

X = normrnd(mu, sigma, n, M);
if squared_transform
    X = X.^2;
    sigma = sqrt(2); % This is the STD of the Chi-square distribution with one degree of freedom.
    fprintf('Created %d samples of size %d from Chi-Squared Distribution\n', M, n);
else
    fprintf('Created %d samples of size %d from Normal Distribution\n', M, n);
end

klower = floor((B + 1) * alpha / 2);
kupper = B + 1 - klower;
klimits = [klower, kupper] * 100 / B;

for iM = 1:M

    % Parametric CI for standard deviation
    [~, ~, CI(iM, [1, 2])] = vartest(X(:,iM), sigma^2, 'Alpha', alpha);
    CI(iM, [1, 2]) = sqrt(CI(iM, [1, 2]));

    % Percentile bootstrap CI for standard deviation
    bootstrap_stds = NaN(1, B);
    for iB = 1:B
        idx = randi(n, 1, n);
        bootstrap_sample = X(idx,iM);
        bootstrap_stds(iB) = std(bootstrap_sample);
    end
    CI(iM, [3, 4]) = prctile(bootstrap_stds, klimits);
    
    % Bias corrected and accelerated percentile method
    CI(iM, [5, 6]) = bootci(B, @std, X(:, iM));
end

titles = {sprintf("%.2f%% Parametric CI-lower for STD", (1 - alpha) * 100), ...
          sprintf("%.2f%% Parametric CI-upper for STD", (1 - alpha) * 100), ...
          sprintf("%.2f%% Percentile Bootstrap CI-lower for STD", (1 - alpha) * 100), ...
          sprintf("%.2f%% Percentile Bootstrap CI-upper for STD", (1 - alpha) * 100), ...
          sprintf("%.2f%% BCA Percentile CI-lower for STD", (1 - alpha) * 100), ...
            sprintf("%.2f%% BCA Percentile CI-upper for STD", (1 - alpha) * 100)};
figure;
for i = 1:3
    subplot(3, 2, 2 * (i - 1) + 1);
    histfit(CI(:, 2 * i - 1));
    title(titles{2 * (i - 1) + 1});
    xlabel('CI-lower');
    ylabel('Frequency');

    subplot(3, 2, 2 * (i - 1) + 2);
    histfit(CI(:, 2 * i));
    title(titles{2 * (i - 1) + 2});
    xlabel('CI-upper');
    ylabel('Frequency');
end

prob = sum(sigma > CI(:,1) & sigma < CI(:,2)) / M;
fprintf('Coverage probability of %.2f%% parametric CI of std=%.2f: %.3f\n', (1 - alpha) * 100, sigma, prob);
prob = sum(sigma > CI(:,3) & sigma < CI(:,4)) / M;
fprintf('Coverage probability of %.2f%% percentile bootstrap CI of std=%.2f: %.3f\n', (1 - alpha) * 100, sigma, prob);
prob = sum(sigma > CI(:,5) & sigma < CI(:,6)) / M;
fprintf('Coverage probability of %.2f%% bias corrected and accelerated percentile bootstrap CI of std=%.2f: %.3f\n', (1 - alpha) * 100, sigma, prob);
