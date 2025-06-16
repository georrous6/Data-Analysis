clc; clearvars; close all;
addpath(genpath(fullfile('..', '..', 'lib')));

% Load dataset
data = load('Energy.dat');
X_env = data(:,2:end);
y_env = data(:,1);

[N, M] = size(data);
p = 10;
K = p * M;
X = NaN(N - p, K);
y = data(p+1:end,1);

for i = 1:(N-p)
    row = NaN(1, K);
    for j = 1:p
        idx = i + p - j;
        row((j - 1) * M + 1 : j * M) = [y_env(idx), X_env(idx,:)];
    end
    X(i,:) = row;
end

n_train = 336;
X_train = X(1:n_train,:);
y_train = y(1:n_train);
X_test = X(n_train+1:end,:);
y_test = y(n_train+1:end,:);
n_test = length(y_test);

% Define models
linear_model = @(y, X) linear_regress(y, X);
stepwise_model = @(y, X) stepwise_regress(y, X);
lasso_model = @(y, X) lasso_regress(y, X, true);
ridge_model = @(y, X) ridge_regress(y, X, 1:0.1:10, false);
models = {linear_model, stepwise_model, lasso_model, ridge_model};
modelNames = {'Linear', 'Stepwise', 'LASSO', 'Ridge'};
n_models = length(models);
y_pred_values = NaN(n_test, n_models);
mse_values = NaN(1, n_models);

for i = 1:n_models
    if i == 2  % Stepwise model 
        [b, ~, ~, ~, inmodel] = models{i}(y_train, X_train);
        X_in = X_test(:, inmodel);
    else
        b = models{i}(y_train, X_train);
        X_in = X_test;
    end

    y_pred_values(:,i) = [ones(n_test, 1), X_in] * b;
    mse_values(i) = mean((y_test - y_pred_values(:,i)).^2);
end

fprintf('MSE Results\n');
fprintf('==============================\n');
for i = 1:n_models
    fprintf('%-20s: %.4f\n', sprintf('%s Regression', modelNames{i}), mse_values(i));
end

figure;
window = 1:50;
plot([y_test(window), y_pred_values(window,:)], 'LineStyle', '-', 'LineWidth', 1);
legend(['True', modelNames]);
xlabel('Sample Index');
ylabel('Target Value');
title('Model Predictions vs True Values');
grid on;
