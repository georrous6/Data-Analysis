clc, clearvars, close all;

n = 10;                    % Sample size of X dataset
m = 12;                    % Sample size of Y dataset
M = 100;                   % Number of samples for X and Y datasets
B = 1000;                  % Number of bootstrap samples per dataset
muX = 0;                   % True mean of the X population
muY = 0;                   % True mean of the Y population
sigmaX = 1;                % Standard deviation of the X population
sigmaY = 1;                % Standard deviation of the Y population
alpha = 0.05;              % Significance level
squared_transform = true;  % If set to true, apply a square transformation to the data

P = NaN(2, M);  % the first row is for the p-values of the parametric
                % tests and the second for the bootstrap tests

X = normrnd(muX, sigmaX, n, M);
Y = normrnd(muY, sigmaY, m, M);
if squared_transform
    X = X.^2;
    Y = Y.^2;
    muX = sigmaX^2 + muX^2; % This is the mean of the Chi-square distribution with one degree of freedom.
    muY = sigmaY^2 + muY^2; % This is the mean of the Chi-square distribution with one degree of freedom.
    fprintf('Created %d samples of size %d from Chi-Squared Distribution\n', M, n);
    fprintf('Created %d samples of size %d from Chi-Squared Distribution\n', M, m);
else
    fprintf('Created %d samples of size %d from Normal Distribution\n', M, n);
    fprintf('Created %d samples of size %d from Normal Distribution\n', M, m);
end

varx_bar = var(X) / n;
vary_bar = var(Y) / m;
x_bar = mean(X);
y_bar = mean(Y);
tstats = (x_bar - y_bar) ./ sqrt(varx_bar + vary_bar);
dfs = (varx_bar + vary_bar).^2 ./ (varx_bar.^2 / (n - 1) + vary_bar.^2 / (m - 1));

for iM = 1:M

    % Parametric hypothesis testing for mean difference (equal variances
    % not assumed)
    P(1, iM) = 2 * (1 - tcdf(abs(tstats(iM)), dfs(iM)));

    % Bootstrap hypothesis testing for mean difference
    XY = [X(:,iM)', Y(:,iM)'];
    muXY = mean(XY);
    % xnew = X(:,iM)' - x_bar(iM) + muXY;
    % ynew = Y(:,iM)' - y_bar(iM) + muXY;
    bootstrap_means = NaN(1, B);
    for iB = 1:B
        idx = randi(n + m, 1, n + m);
        xb = XY(idx(1:n));
        yb = XY(idx(n+1:n+m));
        bootstrap_means(iB) = (mean(xb) - mean(yb)) / sqrt(var(xb) / n + var(yb) / m);
    end
    rank = sum(bootstrap_means < tstats(iM));
    if rank > 0.5 * (B + 1)  % Reached right tail
        P(2, iM) = 2 * (1 - rank / (B + 1));
    else  % Still on the left tail
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
title(sprintf('M=%d, B=%d n=%d, p-value of test for mean difference',M, B, n));
xlabel('p-value');
ylabel('relative frequency');
legend('Location', 'southeast');
hold off;

prob = sum(P(1,:) < alpha) / M;
fprintf('Probability of rejection of equal mean (unequal variances) at alpha=%f, parametric: %f\n', alpha, prob);
prob = sum(P(2,:) < alpha) / M;
fprintf('Probability of rejection of equal mean (unequal variances) at alpha=%f, bootstrap: %f\n', alpha, prob);
