clc, clearvars, close all;
addpath(genpath(fullfile('..', '..', 'lib')));

data = load('DataEx2No2.txt');
X = data(:,1);
Y = data(:,2);
n = length(Y);

[X, idx] = sort(X);
Y = Y(idx);

model1 = @(Y, X, x_split) linear_regress(Y, X);
model2 = @(Y, X, x_split) partial_linear_regress(Y, X, x_split);
model3 = @(Y, X, x_split) partial_linear_regress(Y, X, x_split);

x_split_1 = prctile(X, 50);
x_split_2 = prctile(X, 55);
x_split_values = [0, x_split_1, x_split_2];

models = {model1, model2, model3};
n_models = length(models);
modelNames = {'linear', 'partial linear (median)', 'partial linear (optimal)'};
b_values = NaN(4, n_models);

for i = 1:n_models
    [b, y_pred] = models{i}(Y, X, x_split_values(i));
    k = length(b);
    adjR2 = adjR_squared(Y, y_pred, k);
    fprintf('%s: adjR^2 = %f\n', modelNames{i}, adjR2);
    b_values(1:length(b), i) = b;
end

minX = min(X);
maxX = max(X);
figure; hold on;

y_values = [1, minX; 1, maxX] * b_values(1:2,1);
plot([minX; maxX], y_values);

for i = 2:n_models
    y_values_1 = [1, minX; 1, x_split_values(i)] * b_values(1:2,i);
    y_values_2 = [1, maxX] * b_values(3:4,i);
    plot([minX; x_split_values(i); maxX], [y_values_1; y_values_2]);
end

scatter(X, Y, 10, 'black', 'filled', 'o');

xlabel('X');
ylabel('Y');
legend(modelNames);
grid on;
