clc, clearvars, close all;

data = load('physical.txt');
varname = {'Mass', 'Fore', 'Bicep', 'Chest', 'Neck', 'Shoulder', 'Waist', 'Height', 'Calf', 'Thigh', 'Head'};
y = data(:,1);
X = data(:,2:end);
mX = mean(X);
my = mean(y);
Xc = X - mX;  % Center the data
yc = y - my;  % Center predictions
[U, S, V] = svd(Xc, 'econ');
[n, p] = size(X);
tss = sum(yc.^2);

%% OLS
b_ols = V * (S \ (U' * yc));
b_ols = [my - mX * b_ols; b_ols];  % Add intercept
y_ols = [ones(n, 1), X] * b_ols;
res_ols = y - y_ols;
R2_ols = 1 - sum(res_ols.^2) / tss;

observed_vs_predicted_plot(y, y_ols, 'OLS', R2_ols);
diagnostic_plot(y, y_ols, 'OLS');

%% PCR
explvar = diag(S).^2 / (n - 1);  % Explained variance by each component
cumvar = cumsum(explvar) / sum(explvar);
d = find(cumvar > 0.9, 1);
lambda = zeros(p, 1);
lambda(1:d) = 1;
b_pcr = V * (S \ (diag(lambda) * U' * yc));
b_pcr = [my - mX * b_pcr; b_pcr];  % Add intercept
y_pcr = [ones(n, 1), X] * b_pcr;
res_pcr = y - y_pcr;
R2_pcr = 1 - sum(res_pcr.^2) / tss;

observed_vs_predicted_plot(y, y_pcr, 'PCR', R2_pcr);
diagnostic_plot(y, y_pcr, 'PCR');

%% PLS
[~, ~, ~, ~, b_pls] = plsregress(X, y, d);  % Adds intercept term by default
y_pls = [ones(n, 1), X] * b_pls;
res_pls = y - y_pls;
R2_pls = 1 - sum(res_pls.^2) / tss;

observed_vs_predicted_plot(y, y_pls, 'PLS', R2_pls);
diagnostic_plot(y, y_pls, 'PLS');

%% RR
k = var(res_ols);
b_rr = ridge(y, X, k, 0);  % Flag 0 indicates no centering while adds the intercept term
y_rr = [ones(n, 1), X] * b_rr;
res_rr = y - y_rr;
R2_rr = 1 - sum(res_rr.^2) / tss;

observed_vs_predicted_plot(y, y_rr, 'RR', R2_rr);
diagnostic_plot(y, y_rr, 'RR');

%% LASSO
[b_lasso, stats] = lasso(Xc, yc);
lassoPlot(b_lasso, stats, 'PlotType', 'Lambda', 'XScale', 'log');
lambda = 0.1;
[~, lambda_index] = min(abs(stats.Lambda - lambda));
b_lasso = [my - mX * b_lasso(:,lambda_index); b_lasso(:,lambda_index)];

y_lasso = [ones(n, 1), X] * b_lasso;
res_lasso = y - y_lasso;
R2_lasso = 1 - sum(res_lasso.^2) / tss;

observed_vs_predicted_plot(y, y_lasso, 'LASSO', R2_lasso);
diagnostic_plot(y, y_lasso, 'LASSO');

%% Stepwise regression
[b_step, ~, ~, inmodel, stats] = stepwisefit(X, y, 'display', 'off');
b_step = [stats.intercept; b_step] .* [1, inmodel]';  % Add intercept
y_step = [ones(n, 1), X] * b_step;
res_step = y - y_step;
R2_step = 1 - sum(res_step.^2) / tss;

observed_vs_predicted_plot(y, y_step, 'STEP', R2_step);
diagnostic_plot(y, y_step, 'STEP');

%% Coefficients from all models
fprintf('\t OLS \t PCR \t PLS \t RR \t LASSO \t STEP \n');
fprintf('Const \t %1.3f \t %1.3f \t %1.3f \t %1.3f \t %1.3f \t %1.3f \n',...
    b_ols(1), b_pcr(1), b_pls(1), b_rr(1), b_lasso(1), b_step(1));
for i=2:p+1
    stringlength = min(length(varname{i-1}), 5);
    fprintf('%s \t %1.3f \t %1.3f \t %1.3f \t %1.3f \t %1.3f \t %1.3f \n',...
        varname{i-1}(1:stringlength), b_ols(i), b_pcr(i), b_pls(i), b_rr(i), b_lasso(i), b_step(i));
end

function observed_vs_predicted_plot(y, y_pred, method, R2)
    figure;
    hold on;
    scatter(y, y_pred, 20, 'o', 'filled');
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
    scatter(y, res_std, 20, 'o', 'filled');
    alpha = 0.05;
    zcrit = norminv(1 - alpha / 2, 0, 1);
    plot(xlim, zcrit * [1, 1], '--r', 'LineWidth', 1.2);
    plot(xlim, -zcrit * [1, 1], '--r', 'LineWidth', 1.2);
    hold off;
    xlabel('y');
    ylabel('e^*');
    title(sprintf('%s: Diagnostic Plot', method));
end
