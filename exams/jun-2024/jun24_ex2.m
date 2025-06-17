clc; clearvars; close all;
addpath(genpath(fullfile('..', '..', 'lib')));

% === Load and preprocess data ===
tableData = readtable('EmissionP10EU15.xlsx');
countryName = 'Greece';
featureNames = tableData.Properties.VariableNames;
X = tableData{3:end, ~strcmp(featureNames, countryName)};
y = tableData{3:end, countryName};


pcr_model = @(y, X) svd_regress(y, X, 0.95, 'PCR: Scree Plot and Explained Variance');
lasso_model = @(y, X) lasso_regress(y, X);
ridge_model = @(y, X) ridge_regress(y, X, 1:1:10);
stepwise_model = @(y, X) stepwise_regress(y, X);
pls_model = @(y, X) pls_regress(y, X, 0.95, 'PLS: Explained Variance of Y');

models = {pcr_model, lasso_model, ridge_model, stepwise_model, pls_model};
modelNames = {'PC', 'LASSO', 'Ridge', 'Stepwise', 'PLS'};
n_models = length(models);
max_deg = 2;

%% Case 1: Linear Polynomial Model
R2_values_linear = NaN(n_models, 1);
mse_values_linear = NaN(n_models, 1);

X_linear = polynomial_model(X, max_deg, 'linear');
for i = 1:n_models
    [~, y_pred, R2_values_linear(i)] = models{i}(y, X_linear);
    mse_values_linear(i) = mean((y - y_pred).^2);
end

fprintf('Linear Model results\n=======================\n');
for i = 1:n_models
    fprintf('%-20s: %-20s %-20s\n', sprintf('%s Regression', modelNames{i}), sprintf('R-squared=%.4f', R2_values_linear(i)), ...
    sprintf('MSE=%.4f', mse_values_linear(i)));
end

%% Case 2: Non-linear Polynomial Model (degree: 2)
R2_values_nonlinear = NaN(n_models, 1);
mse_values_nonlinear = NaN(n_models, 1);

X_nonlinear = polynomial_model(X, max_deg, 'nonlinear');
for i = 1:n_models
    [~, y_pred, R2_values_nonlinear(i)] = models{i}(y, X_nonlinear);
    mse_values_nonlinear(i) = mean((y - y_pred).^2);
end

fprintf('Non-linear Model results\n=======================\n');
for i = 1:n_models
    fprintf('%-20s: %-20s %-20s\n', sprintf('%s Regression', modelNames{i}), sprintf('R-squared=%.4f', R2_values_nonlinear(i)), ...
    sprintf('MSE=%.4f', mse_values_nonlinear(i)));
end
