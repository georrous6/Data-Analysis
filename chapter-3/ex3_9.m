clc, clearvars, close all;

n = 10;                    % Sample size of X dataset
m = 12;                    % Sample size of Y dataset
M = 100;                   % Number of samples for X and Y datasets
B = 1000;                  % Number of bootstrap samples per dataset
muX = 0;                   % True mean of the X population
muY = 0;                   % True mean of the Y population
sigmaX = 1;                % Standard deviation of the X population
sigmaY = 1;                % Standard deviation of the X population
alpha = 0.05;              % Significance level
squared_transform = true;  % If set to true, apply a square transformation to the data

CI = NaN(M, 4);   % the two first are the limits of parametric CI for mean  
                  % the other two for the percentile bootstrap CI for mean

X = normrnd(muX, sigmaX, n, M);
Y = normrnd(muY, sigmaY, m, M);
if squared_transform
    X = X.^2;
    Y = Y.^2;
    muX = 1; % This is the mean of the Chi-square distribution with one degree of freedom.
    muY = 1; % This is the mean of the Chi-square distribution with one degree of freedom.
    fprintf('Created %d samples of size %d from Chi-Squared Distribution\n', M, n);
    fprintf('Created %d samples of size %d from Chi-Squared Distribution\n', M, m);
else
    fprintf('Created %d samples of size %d from Normal Distribution\n', M, n);
    fprintf('Created %d samples of size %d from Normal Distribution\n', M, m);
end

mu = muX - muY;
sx = std(X);
sy = std(Y);
sp = sqrt(((n - 1) * sx.^2 + (m - 1) * sy.^2) / (n + m -2));
x_bar = mean(X);
y_bar = mean(Y);
tcrit = tinv(1 - alpha / 2, n + m - 2);

klower = floor((B + 1) * alpha / 2);
kupper = B + 1 - klower;
klimits = [klower, kupper] * 100 / B;

for iM = 1:M

    % Parametric CI for mean
    CI(iM, [1, 2]) = [x_bar(iM) - y_bar(iM) - tcrit * sp(iM) * sqrt(1 / n + 1 / m), ...
        x_bar(iM) - y_bar(iM) + tcrit * sp(iM) * sqrt(1 / n + 1 / m)];

    % Percentile bootstrap CI for mean
    bootstrap_means = NaN(1, B);
    for iB = 1:B
        idxX = randi(n, 1, n);
        idxY = randi(m, 1, m);
        bootstrap_means(iB) = mean(X(idxX, iM)) - mean(Y(idxY, iM));
    end
    CI(iM, [3, 4]) = prctile(bootstrap_means, klimits);
end

titles = {sprintf("%.2f%% Parametric CI-lower for mean difference", (1 - alpha) * 100), ...
          sprintf("%.2f%% Parametric CI-upper for mean difference", (1 - alpha) * 100), ...
          sprintf("%.2f%% Percentile Bootstrap CI-lower for mean difference", (1 - alpha) * 100), ...
          sprintf("%.2f%% Percentile Bootstrap CI-upper for mean difference", (1 - alpha) * 100)};
figure;
for i = 1:2
    subplot(2, 2, 2 * (i - 1) + 1);
    histfit(CI(:, 2 * i - 1));
    title(titles{2 * (i - 1) + 1});
    xlabel('CI-lower');
    ylabel('Frequency');

    subplot(2, 2, 2 * (i - 1) + 2);
    histfit(CI(:, 2 * i));
    title(titles{2 * (i - 1) + 2});
    xlabel('CI-upper');
    ylabel('Frequency');
end

prob = sum(mu > CI(:,1) & mu < CI(:,2)) / M;
fprintf('Coverage probability of %.2f%% parametric CI of muX-muY: %.3f\n', (1 - alpha) * 100, prob);
prob = sum(mu > CI(:,3) & mu < CI(:,4)) / M;
fprintf('Coverage probability of %.2f%% percentile bootstrap CI of muX-muY: %.3f\n', (1 - alpha) * 100, prob);
