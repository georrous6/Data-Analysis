clc, clearvars, close all;

data = readtable('CPUperformance.xlsx');

n = 209; % Change to 209

idx = randperm(n);
X = data{idx, 3:8};
Y = data{idx, 'PRP'};

lasso_model = @(y, X) Ex1Func8(y, X);
stepwise_model = @(y, X) Ex1Func9(y, X);

models = {lasso_model, stepwise_model};
modelNames = {'LASSO', 'Stepwise'};
n_models = length(models);

for i = 1:n_models
    [b, y_pred, R2, adjR2] = models{i}(Y, X);
    fprintf('%s: R-squared=%f, Adjusted R-squared=%f\n', modelNames{i}, R2, adjR2);

    % Diagnostic Plot
    % Ex1Func6(Y, y_pred, Y, length(b), 'y', sprintf('Diagnostic Plot for Polynomial (order: %d)', k));
end

% For n=50 we see that the LASSO regression is better explaining the data
% that stepwise regression (better R-squared and adjusted R-squared value).
% For 
