clc, clearvars, close all;

n = 10;                    % Sample size
M = 100;                   % Number of samples
B = 1000;                  % Number of bootstrap samples per dataset
mu = 0;                    % True mean of the population
sigma = 1;                 % Standard deviation of the population
alpha = 0.05;              % Significance level
squared_transform = false;  % If set to true, apply a square transformation to the data

CI = NaN(M, 6);   % the two first are the limits of parametric CI for mean  
                  % the other two for the percentile bootstrap CI for mean,
                  % the final two for the bias corrected and accelerated 
                  % percentile method, which is the default bootstrap in Matlab

X = normrnd(mu, sigma, n, M);
if squared_transform
    X = X.^2;
    mu = 1; % This is the mean of the Chi-square distribution with one degree of freedom.
    fprintf('Created %d samples of size %d from Chi-Squared Distribution\n', M, n);
else
    fprintf('Created %d samples of size %d from Normal Distribution\n', M, n);
end

klower = floor((B + 1) * alpha / 2);
kupper = B + 1 - klower;
klimits = [klower, kupper] * 100 / B;

for iM = 1:M

    % Parametric CI for mean
    [~, ~, CI(iM, [1, 2])] = ttest(X(:,iM), mu, 'Alpha', alpha);

    % Percentile bootstrap CI for mean
    bootstrap_means = NaN(1, B);
    for iB = 1:B
        idx = randi(n, 1, n);
        bootstrap_sample = X(idx,iM);
        bootstrap_means(iB) = mean(bootstrap_sample);
    end
    CI(iM, [3, 4]) = prctile(bootstrap_means, klimits);
    
    % Bias corrected and accelerated percentile method
    CI(iM, [5, 6]) = bootci(B, @mean, X(:, iM));
end

titles = {sprintf("%.2f%% Parametric CI-lower for Mean", (1 - alpha) * 100), ...
          sprintf("%.2f%% Parametric CI-upper for Mean", (1 - alpha) * 100), ...
          sprintf("%.2f%% Percentile Bootstrap CI-lower for Mean", (1 - alpha) * 100), ...
          sprintf("%.2f%% Percentile Bootstrap CI-upper for Mean", (1 - alpha) * 100), ...
          sprintf("%.2f%% BCA Percentile CI-lower for Mean", (1 - alpha) * 100), ...
            sprintf("%.2f%% BCA Percentile CI-upper for Mean", (1 - alpha) * 100)};
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

prob = sum(mu > CI(:,1) & mu < CI(:,2)) / M;
fprintf('Coverage probability of %.2f%% parametric CI of mu=%.2f: %.3f\n', (1 - alpha) * 100, mu, prob);
prob = sum(mu > CI(:,3) & mu < CI(:,4)) / M;
fprintf('Coverage probability of %.2f%% percentile bootstrap CI of mu=%.2f: %.3f\n', (1 - alpha) * 100, mu, prob);
prob = sum(mu > CI(:,5) & mu < CI(:,6)) / M;
fprintf('Coverage probability of %.2f%% bias corrected and accelerated percentile bootstrap CI of mu=%.2f: %.3f\n', (1 - alpha) * 100, mu, prob);
