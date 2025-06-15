clc; clearvars; close all;
addpath(genpath(fullfile('..', '..', 'lib')));

% Load dataset
data = load('Energy.dat');
X = data(:,2:end);
y = data(:,1);

% Train/test split (50/50)
N = size(data, 1);
train_size = round(N / 2);
X_train = X(1:train_size,:);
y_train = y(1:train_size);
X_test = X(train_size+1:end,:);
y_test = y(train_size+1:end);

% Define models
linear_model = @(X, y) regress(y, X);
stepwise_model = @(X, y) stepwiselm(X, y);
lasso_model = @(X, y) lasso(X, y, 'CV', 10);
ridge_model = @(X, y, lambda) ridge(y, X, lambda, 0);

% ----- Linear Regression -----
b_linear = linear_model(X_train, y_train);
y_pred_linear = X_test * b_linear;
mse_linear = mean((y_test - y_pred_linear).^2);

% ----- Stepwise Regression -----
mdl_stepwise = stepwise_model(X_train, y_train);
y_pred_stepwise = predict(mdl_stepwise, X_test);
mse_stepwise = mean((y_test - y_pred_stepwise).^2);

% ----- LASSO Regression -----
[b_lasso, stats_lasso] = lasso_model(X_train, y_train);
idx_best_lasso = stats_lasso.IndexMinMSE;
b_lasso_best = b_lasso(:, idx_best_lasso);
intercept_lasso = stats_lasso.Intercept(idx_best_lasso);
y_pred_lasso = X_test * b_lasso_best + intercept_lasso;
mse_lasso = mean((y_test - y_pred_lasso).^2);

% ----- Ridge Regression -----
lambda = 1;  % Regularization parameter (you can tune this)
b_ridge = ridge_model(X_train, y_train, lambda);
y_pred_ridge = X_test * b_ridge(2:end) + b_ridge(1);
mse_ridge = mean((y_test - y_pred_ridge).^2);

% ----- Display results -----
fprintf('Mean Squared Errors:\n');
fprintf('Linear Regression     : %.4f\n', mse_linear);
fprintf('Stepwise Regression   : %.4f\n', mse_stepwise);
fprintf('LASSO Regression      : %.4f\n', mse_lasso);
fprintf('Ridge Regression (lambda=%.2f): %.4f\n', lambda, mse_ridge);

% ----- Plot predictions -----
figure('Position', [100, 100, 1000, 600]);
plot(y_test, 'k', 'LineWidth', 1.5, 'DisplayName', 'True'); hold on;
plot(y_pred_linear, '--b', 'LineWidth', 1.5, 'DisplayName', 'Linear');
plot(y_pred_stepwise, '--g', 'LineWidth', 1.5, 'DisplayName', 'Stepwise');
plot(y_pred_lasso, '--m', 'LineWidth', 1.5, 'DisplayName', 'LASSO');
plot(y_pred_ridge, '--r', 'LineWidth', 1.5, 'DisplayName', 'Ridge');
legend('Location', 'best');
xlabel('Sample Index');
ylabel('Target Value');
title('Model Predictions vs True Values');
grid on;
