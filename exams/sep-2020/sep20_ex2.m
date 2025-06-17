clc; clearvars; close all;
addpath(genpath(fullfile('..', '..', 'lib')));

data = load('Topic2DataSept2020.dat');
X = data(:, 1);
Y = data(:, 2);

% Sharpen the kernel by increasing s, i.e. s=80
s = 80; % s = std(X);

f = @(x, xi) exp((x - xi).^2 / (2 * s^2));
n_points = 100;
x_values = linspace(min(X), max(X), n_points)';

%% Linear model
[b_linear, y_pred_linear, R2_linear] = linear_regress(Y, X);
fprintf('Linear Model: R-squared=%f\n', R2_linear);

y_values_linear = [ones(n_points, 1), x_values] * b_linear;
diagnostic_plot(Y, y_pred_linear, X, length(b_linear), 'X', 'Linear Model: Diagnostic Plot');

figure; hold on;
scatter(X, Y, 10, 'k', 'filled', 'o');
plot(x_values, y_values_linear, '-r', 'LineWidth', 1.5);
xlabel('X');
ylabel('Y');
title('Linear Model Fit');
grid on;

%% Gaussian Kernel Model

X_kernel = [f(X, 470), f(X, 550)];
[b_kernel, y_pred_kernel, R2_kernel] = linear_regress(Y, X_kernel);
fprintf('Gaussian Kernel Model: R-squared=%f\n', R2_kernel);

y_values_kernel = [ones(n_points, 1), f(x_values, 470), f(x_values, 550)] * b_kernel;
diagnostic_plot(Y, y_pred_kernel, X, length(b_kernel), 'X', 'Gaussian Kernel Model: Diagnostic Plot');

figure; hold on;
scatter(X, Y, 10, 'k', 'filled', 'o');
plot(x_values, y_values_kernel, '-r', 'LineWidth', 1.5);
xlabel('X');
ylabel('Y');
title('Gaussian Kernel Model Fit');
grid on;
