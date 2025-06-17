clc; clearvars; close all;
addpath(genpath(fullfile('..', '..', 'lib')));

%% Program 1
phi = 0.5;
mu = 0;
sigma = 1;
n = 100;
x0 = 0.3;
alpha = 0.05;
B = 1000;

n_tests = 100;
p_values = NaN(n_tests, 2);

for i = 1:n_tests
    x = create_time_series(n, phi, mu, sigma, x0);
    p_values(i,:) = gof_test(x, B);
end

rejection_rates = 100 * mean(p_values < alpha, 1);
fprintf('Program 1:\n===========\n');
fprintf('Parametric GoF Test Rejection Rate: %.2f%%\n', rejection_rates(1));
fprintf('Randomization GoF Test Rejection Rate: %.2f%%\n', rejection_rates(2));

%% Program 2
n = 50;
B = 1000;
sigma = 1;
x0 = 2 * rand - 1;
phi_min = -0.8;
phi_max = 0.8;
n_tests = 100;
phi_values = (phi_max - phi_min) * rand(n_tests, 1) + phi_min;

p_values = NaN(n_tests, 2);

for i = 1:n_tests
    x = create_time_series(n, phi_values(i), mu, sigma, x0);
    p_values(i,:) = gof_test(x, B);
end

n_points = 100;
testNames = {'Parametric Test', 'Randomization Test'};
fprintf('Program 2:\n===========\n');
figure('Position', [200, 100, 1000, 400]);
for i = 1:2
    [b, ~, R2] = linear_regress(phi_values, p_values(:,i));
    x_values = linspace(min(p_values(:,i)), max(p_values(:,i)), n_points)';
    y_values = [ones(n_points, 1), x_values] * b;
    fprintf('%s: R-squared=%f\n', testNames{i}, R2);

    subplot(1, 2, i); hold on;
    scatter(p_values(:,i), phi_values, 10, 'k', 'filled', 'o');
    plot(x_values, y_values, '-r', 'LineWidth', 1.5);
    xlabel('p-value');
    ylabel('$\phi$', 'Interpreter', 'latex');
    title(testNames{i});
    grid on;
end

%% Program 3
n_tests = 200;
B = 1;

n_min = 20; 
n_max = 4000;
phi_min = -0.8; 
phi_max = 0.8;
sigma_min = 0.1;
sigma_max = 100;
x0_min = -10;
x0_max = 10;

n_values = randi(n_min + n_max, [n_tests, 1]) - n_min;
phi_values = (phi_max - phi_min) * rand(n_tests, 1) + phi_min;
sigma_values = (sigma_max - sigma_min) * rand(n_tests, 1) + sigma_min;
x0_values = (x0_max - x0_min) * rand(n_tests, 1) + x0_min;

p_values = NaN(n_tests, 2);

for i = 1:n_tests
    x = create_time_series(n, phi_values(i), mu, sigma, x0);
    p_values(i,:) = gof_test(x, B);
end

X = [n_values, phi_values, sigma_values, x0_values];
y = p_values(:,1);
maxdeg = 3;
X_aug = polynomial_model(X, maxdeg, 'nonlinear');

pcr_model = @(y, X) svd_regress(y, X, 0.95);
lasso_model = @(y, X) lasso_regress(y, X);
ridge_model = @(y, X) ridge_regress(y, X, 1:1:10);
stepwise_model = @(y, X) stepwise_regress(y, X);
pls_model = @(y, X) pls_regress(y, X, 0.95);

models = {pcr_model, lasso_model, ridge_model, stepwise_model, pls_model};
modelNames = {'PC', 'LASSO', 'Ridge', 'Stepwise', 'PLS'};
n_models = length(models);
max_deg = 2;

R2_values = NaN(n_models, 1);
mse_values = NaN(n_models, 1);

for i = 1:n_models
    [~, y_pred, R2_values(i)] = models{i}(y, X_aug);
    mse_values(i) = mean((y - y_pred).^2);
end

fprintf('Model Fit Results\n=======================\n');
for i = 1:n_models
    fprintf('%-20s: %-20s %-20s\n', sprintf('%s Regression', modelNames{i}), sprintf('R-squared=%.4f', R2_values(i)), ...
    sprintf('MSE=%.4f', mse_values(i)));
end


function x = create_time_series(n, phi, mu, sigma, x0)
    n_reject = 20;
    x = NaN(1, n + n_reject);
    x(1) = x0;
    for i = 2:n + n_reject
        x(i) = phi * x(i-1) + mu + sigma * randn;
    end

    x = x(n_reject + 1:end);
end


function chi2_stat = get_chi2_stat(x)
    
    x_median = prctile(x, 50);
    y = x > x_median;
    pdf_common = zeros(2, 2);
    n = length(x);
    for i = 2:n
        pdf_common(y(i-1) + 1, y(i) + 1) = pdf_common(y(i-1) + 1, y(i) + 1) + 1;
    end

    O = pdf_common(:);
    pdf_common = pdf_common ./ (n - 1);
    pdf_marginal_1 = sum(pdf_common, 1);
    pdf_marginal_2 = sum(pdf_common, 2);
    E = (n - 1) * pdf_marginal_2 * pdf_marginal_1;
    E = E(:);
    chi2_stat = sum((E - O).^2 ./ E);
end


function p_values = gof_test(x, B)
    K = 4;
    c = 1;
    n = length(x);
    chi2_stat = get_chi2_stat(x);
    p_values = NaN(1, 2);
    p_values(1) = chi2cdf(chi2_stat, K-c, 'upper');

    chi2_stat_randomization = NaN(B, 1);
    for i = 1:B
        x_perm = x(randperm(n));
        chi2_stat_randomization(i) = get_chi2_stat(x_perm);
    end

    p_values(2) = mean(chi2_stat_randomization >= chi2_stat);
end
