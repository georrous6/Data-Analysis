clc, clearvars, close all;

n = 10;                    % Sample size
M = 100;                   % Number of samples
B = 1000;                  % Number of bootstrap samples per dataset
mu = 0;                    % True mean of the population
sigma = 1;                 % Standard deviation of the population
alpha = 0.05;              % Significance level
squared_transform = true;  % If set to true, apply a square transformation to the data
mu0 = 0;                   % value to test for mean

P = NaN(2, M);  % the first row is for the p-values of the parametric tests
                % the second for the percentile bootstrap tests 

X = normrnd(mu, sigma, n, M);
if squared_transform
    X = X.^2;
    mu0 = sigma^2 + mu0^2; % This is the mean of the Chi-square distribution with one degree of freedom.
    fprintf('Created %d samples of size %d from Chi-Squared Distribution\n', M, n);
else
    fprintf('Created %d samples of size %d from Normal Distribution\n', M, n);
end

muX = mean(X);
stdX = std(X);

for iM = 1:M

    % Parametric hypothesis testing for mean
    sample_tstat = (muX(iM) - mu0) / (stdX(iM) / sqrt(n));
    P(1, iM) = 2 * (1 - tcdf(abs(sample_tstat), n - 1));

    % Bootstrap hypothesis testing for mean
    bootstrap_tstat = NaN(1, B);
    newX = X(:,iM) - muX(iM) + mu0;
    for iB = 1:B
        idx = randi(n, 1, n);
        bootstrap_sample = newX(idx);
        bootstrap_tstat(iB) = (mean(bootstrap_sample) - mu0) / (std(bootstrap_sample) / sqrt(n));
    end
    
    rank = sum(bootstrap_tstat < sample_tstat);
    if rank > 0.5 * (B + 1)
        P(2, iM) = 2 * (1 - rank / (B + 1));
    else
        P(2, iM) = 2 * rank / (B + 1);
    end
end

figure;
[probs, xvalues] = ecdf(P(1,:));
stairs(xvalues, probs, '-r', 'LineWidth', 2, 'DisplayName', 'parametric');
hold on;
[probs, xvalues] = ecdf(P(2,:));
stairs(xvalues, probs, '-g', 'LineWidth', 2, 'DisplayName', 'bootstrap');
plot(alpha * [1, 1], ylim, 'm--', 'LineWidth', 2, 'DisplayName', 'alpha');
title(sprintf('M=%d, B=%d n=%d, p-value of test for mean ',M, B, n));
xlabel('p-value');
ylabel('relative frequency');
legend('Location', 'southeast');
hold off;

prob = sum(P(1,:) < alpha) / M;
fprintf('Probability of rejection of mean=%f at alpha=%f, parametric: %f\n', mu0, alpha, prob);
prob = sum(P(2,:) < alpha) / M;
fprintf('Probability of rejection of mean=%f at alpha=%f, bootstrap: %f\n', mu0, alpha, prob);
