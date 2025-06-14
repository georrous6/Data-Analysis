clc, clearvars, close all;
addpath(genpath(fullfile('..', '..', 'lib')));

N = 100;
X = rand(N, 1);
Y = 2.4 * X.^3 + 1.1 * X.^2 + 3.7 * X + 2.3;
Y = Y + randn(N, 1);

k = 3;
alpha = 0.05;
[b, y_pred] = polynomial_regress(Y, X, k);
[p_value, ci] = correlation_test(Y, y_pred, alpha);

figure; hold on;
x_values = linspace(min(X), max(X), N)';
X_data = ones(N, k+1);
for i = 2:k+1
    X_data(:,i) = x_values.^2;
end
y_values = X_data * b;
scatter(X, Y, 10, 'k', 'filled', 'o');
plot(x_values, y_values, '-r');
xlabel('X');
ylabel('Y');
title('Polynomial Model Fit');
grid on;

disp('Polynomial coefficients: ');
disp(b');
fprintf('Correlation coefficient p-value: %f\n', p_value);
fprintf('Correlation coefficient CI: [%f, %f]\n', ci(1), ci(2));
