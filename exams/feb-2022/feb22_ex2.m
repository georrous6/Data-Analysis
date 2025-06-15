clc, clearvars, close all;
addpath(genpath(fullfile('..', '..', 'lib')));

N = 100;
X = rand(N, 1);
Y = 2.4 * X.^3 + 1.1 * X.^2 + 3.7 * X + 2.3;
Y = Y + randn(N, 1);

%% (a)

k = 3;
alpha = 0.05;
[b, y_pred, R2, adjR2] = polynomial_regress(Y, X, k, sprintf('Polynomial Model Fit (k=%d)', k));
[p_value, ci] = correlation_test(Y, y_pred, alpha);

fprintf('Polynomial coefficients (k=%d):\n', k);
disp(b');
fprintf('R-squared statistic: %f\n', R2);
fprintf('Adjusted R-squared statistic: %f\n', adjR2);
fprintf('Correlation coefficient p-value: %f\n', p_value);
fprintf('Correlation coefficient CI: [%f, %f]\n', ci(1), ci(2));
fprintf('We %s the hypothesis that the original data and the predictions are uncorrelated with %.2f significance level\n', ...
    ternary(p_value < alpha, 'reject', 'CANNOT reject'), alpha);

%% (b)

data = load('physical.txt');
Y = data(:,1);
X = data(:,2:end);
n_vars = size(data, 2);
k = 3;
alpha = 0.05;

R2_values = NaN(n_vars, 1);
adjR2_values = NaN(n_vars, 1);
model_names = cell(n_vars, 1);
for i = 1:n_vars-1
    [~, ~, R2_values(i), adjR2_values(i)] = polynomial_regress(Y, X(:,i), k);
    model_names{i} = sprintf('X%d (Polynomial)', i);
end

model_names{n_vars} = 'Stepwise Polynomial';
[~, ~, ~, ~, R2_values(n_vars), adjR2_values(n_vars)] = stepwise_polynomial_regress(Y, X, k, alpha, true, false);

% Create and display the table
resultsTable = table(model_names, R2_values, adjR2_values, ...
    'VariableNames', {'Model', 'R-Squared', 'Adjusted R-Squared'});

% Display the table
fprintf('\n=== Model Performance Comparison ===\n');
disp(resultsTable);
