clc, clearvars, close all;

rng(42);  % Random seed for reproducibility
n = 1000;  % Number of observations
p = 5;  % Number of predictors
mu = [0.2, 0.3, 0.7, 0.5, 0.9];
X = zeros(n, p);

for i = 1:p
    X(:,i) = exprnd(i, n, 1);
end

beta = [0, 2, 0, -3, 0]';
y = X * beta + normrnd(0, 5, n, 1);
my = mean(y);
mx = mean(X);
Xc = X - mx;  % Centralize predictors
yc = y - my;  % Centralize response
TSS = sum((y - my).^2);

%% OLS
b_ols = regress(yc, Xc);
b_ols = [my - mx * b_ols; b_ols];  % Add intercept

y_ols = [ones(n, 1), X] * b_ols;
res_ols = y - y_ols;
R2_ols = 1 - sum(res_ols.^2) / TSS;

observed_vs_predicted_plot(y, y_ols, 'OLS', R2_ols);
diagnostic_plot(y, y_ols, 'OLS');

%% PCR
[coeff, score, ~, ~, explained] = pca(Xc);

% Select number of components (e.g., enough to explain 95% variance)
cumvar = cumsum(explained);
d = find(cumvar >= 95, 1); % Minimum number of components for 95% variance
Z = score(:, 1:d); % Principal components

% Regress centered response on principal components
b_pcr = Z \ yc;

% Transform coefficients back to original predictor space
b_pcr = coeff(:, 1:d) * b_pcr;

% Add intercept
intercept = my - mx * b_pcr;
b_pcr = [intercept; b_pcr]; % Final coefficients with intercept

% Prediction
y_pcr = [ones(n, 1), X] * b_pcr;
res_pcr = y - y_pcr;
R2_pcr = 1 - sum(res_pcr.^2) / TSS;

observed_vs_predicted_plot(y, y_pcr, 'PCR', R2_pcr);
diagnostic_plot(y, y_pcr, 'PCR');

%% PLS
[~, ~, ~, ~, b_pls] = plsregress(X, y, d);  % Adds intercept term by default

y_pls = [ones(n, 1), X] * b_pls;
res_pls = y - y_pls;
R2_pls = 1 - sum(res_pls.^2) / TSS;

observed_vs_predicted_plot(y, y_pls, 'PLS', R2_pls);
diagnostic_plot(y, y_pls, 'PLS');

%% Ridge Regression
lambda = var(res_ols);
b_ridge = ridge(y, X, lambda, 0);

y_ridge = [ones(n, 1), X] * b_ridge;
res_ridge = y - y_ridge;
R2_ridge = 1 - sum(res_ridge.^2) / TSS;

observed_vs_predicted_plot(y, y_ridge, 'RR', R2_ridge);
diagnostic_plot(y, y_ridge, 'RR');

%% LASSO
[b_lasso, stats] = lasso(X, y);
lassoPlot(b_lasso, stats, 'PlotType', 'Lambda', 'XScale', 'log');
lambda = 0.1;
[~, lambda_index] = min(abs(stats.Lambda - lambda));
b_lasso = [stats.Intercept(lambda_index); b_lasso(:,lambda_index)];

y_lasso = [ones(n, 1), X] * b_lasso;
res_lasso = y - y_lasso;
R2_lasso = 1 - sum(res_lasso.^2) / TSS;

observed_vs_predicted_plot(y, y_lasso, 'LASSO', R2_lasso);
diagnostic_plot(y, y_lasso, 'LASSO');

%% Compare coefficients from all models
fprintf('\t OLS \t PCR \t PLS \t RR \t LASSO \n');
disp([b_ols, b_pcr, b_pls, b_ridge, b_lasso]);


function observed_vs_predicted_plot(y, y_pred, method, R2)
    figure;
    hold on;
    scatter(y, y_pred, '.');
    plot([min(y), max(y)], [min(y), max(y)], '--r', 'LineWidth', 1.2);
    hold off;
    xlabel('y');
    ylabel('$\hat{y}$', 'Interpreter', 'latex');
    title(sprintf('%s (R^2=%.4f)', method, R2));
end

function diagnostic_plot(y, y_pred, method)
    res = y - y_pred;
    res_std = res / std(res);
    figure;
    hold on;
    scatter(y, res_std, '.');
    alpha = 0.05;
    zcrit = norminv(1 - alpha / 2, 0, 1);
    plot(xlim, zcrit * [1, 1], '--r', 'LineWidth', 1.2);
    plot(xlim, -zcrit * [1, 1], '--r', 'LineWidth', 1.2);
    hold off;
    xlabel('y');
    ylabel('e^*');
    title(sprintf('%s: Diagnostic Plot', method));
end
