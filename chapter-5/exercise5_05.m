clc, clearvars, close all;

lightairData = load('lightair.dat');
n = size(lightairData, 1);
alpha = 0.05;
M = 1000;
b0V = zeros(M, 1);
b1V = zeros(M, 1);

% First column is the intercept term, second is the slope
X = ones(n, 2);
X(:,2) = lightairData(:,1);
Y = lightairData(:,2);
[B, BINT] = regress(Y, X, alpha);
b0 = B(1);
b1 = B(2);
cib0 = BINT(1,:);
cib1 = BINT(2,:);

for i = 1:M
    idx = unidrnd(n, n, 1);
    X(:,2) = lightairData(idx, 1);
    Y = lightairData(idx, 2);
    B = regress(Y, X, alpha);
    b0V(i) = B(1);
    b1V(i) = B(2);
end

b0V = sort(b0V);
b1V = sort(b1V);
lower = floor(M * alpha / 2);
upper = floor(M * (1 - alpha / 2));
cib0b = [b0V(lower), b0V(upper)];
cib1b = [b1V(lower), b1V(upper)];
fprintf('b0=%.4f, b1=%.4f\n', b0, b1);
fprintf('Parametric %.2f%% CI of b0: [%.4f, %.4f]\n', 100 * (1 - alpha), cib0(1), cib0(2));
fprintf('Bootstrap %.2f%% CI of b0: [%.4f, %.4f]\n', 100 * (1 - alpha), cib0b(1), cib0b(2));
fprintf('Parametric %.2f%% CI of b1: [%.4f, %.4f]\n', 100 * (1 - alpha), cib1(1), cib1(2));
fprintf('Bootstrap %.2f%% CI of b1: [%.4f, %.4f]\n', 100 * (1 - alpha), cib1b(1), cib1b(2));

figure;
histogram(b0V, 'Normalization', 'pdf');
title('Empirical pdf of b0 parameter');
xlabel('b0');
ylabel('Relative Frequency');

figure;
histogram(b1V, 'Normalization', 'pdf');
title('Empirical pdf of b1 parameter');
xlabel('b1');
ylabel('Relative Frequency');
