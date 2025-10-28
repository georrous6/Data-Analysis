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

P = NaN(3, M);  % the first row is for the p-values of the parametric
                % tests and the second for the bootstrap tests, and
                % the third for the randomization test

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

sx = std(X);
sy = std(Y);
sp = sqrt(((n - 1) * sx.^2 + (m - 1) * sy.^2) / (n + m -2));
x_bar = mean(X);
y_bar = mean(Y);

for iM = 1:M
    tstat = x_bar(iM) - y_bar(iM);

    % Parametric hypothesis testing for mean difference
    tsample = (tstat - (muX - muY)) / (sp(iM) * sqrt(1 / n + 1 / m));
    P(1, iM) = 2 * (1 - tcdf(abs(tsample), n + m - 2));

    % Bootstrap hypothesis testing for mean difference
    XY = [X(:,iM)', Y(:,iM)'];
    bootstrap_means = NaN(1, B);
    for iB = 1:B
        idx = randi(n + m, 1, n + m);
        bootstrap_means(iB) = mean(XY(idx(1:n))) - mean(XY(idx(n+1:n+m)));
    end
    rank = sum(bootstrap_means < tstat);
    if rank > 0.5 * (B + 1)  % Reached right tail
        P(2, iM) = 2 * (1 - rank / (B + 1));
    else  % Still on the left tail
        P(2, iM) = 2 * rank / (B + 1);
    end

    % Randomization hypothesis testing for mean difference
    random_permutation_means = NaN(1, B);
    for iB = 1:B
        suffleXY = XY(randperm(n + m));
        mx = mean(suffleXY(1:n));
        my = mean(suffleXY(n+1:n+m));
        random_permutation_means(iB) = mx - my;
    end

    rank = sum(random_permutation_means < tstat);

    if rank > 0.5 * (B + 1)  % Reached right tail
        P(3, iM) = 2 * (1 - rank / (B + 1));
    else  % Still on the left tail
        P(3, iM) = 2 * rank / (B + 1);
    end
end

figure;
[probs, xvalues] = ecdf(P(1,:));
stairs(xvalues, probs, '-r', 'LineWidth', 2, 'DisplayName', 'parametric');
hold on;
[probs, xvalues] = ecdf(P(2,:));
stairs(xvalues, probs, '-g', 'LineWidth', 2, 'DisplayName', 'bootstrap');
[probs, xvalues] = ecdf(P(3,:));
stairs(xvalues, probs, '-b', 'LineWidth', 2, 'DisplayName', 'randomization');
plot(alpha * [1, 1], ylim, 'm--', 'LineWidth', 2, 'DisplayName', 'alpha');
title(sprintf('M=%d, B=%d n=%d, p-value of test for mean difference',M, B, n));
xlabel('p-value');
ylabel('relative frequency');
legend('Location', 'southeast');
hold off;

prob = sum(P(1,:) < alpha) / M;
fprintf('Probability of rejection of equal mean at alpha=%f, parametric: %f\n', alpha, prob);
prob = sum(P(2,:) < alpha) / M;
fprintf('Probability of rejection of equal mean at alpha=%f, bootstrap: %f\n', alpha, prob);
prob = sum(P(3,:) < alpha) / M;
fprintf('Probability of rejection of equal mean at alpha=%f, randomization: %f\n', alpha, prob);
