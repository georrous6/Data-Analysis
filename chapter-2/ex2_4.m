%% Exercise 2.4
clc, clearvars, close all;

min_n = 10;
max_n = 10000;
step_n = 10;
N = min_n:step_n:max_n;
n = length(N);
m_x = zeros(1, n);
m_inv_x = zeros(1, n);

% Uniform [1, 2]
a = 1;
b = 2;
for i = 1:n
    [m_x(i), m_inv_x(i)] = ex2_4_function(a, b, N(i));
end

subplot(3, 1, 1);
plot(N, m_x);
hold on;
plot(N, m_inv_x);
hold on;
theoretical_m_inv_x = log(abs(b / a)) / (b - a); % E[1 / X]
plot([min_n, max_n], [theoretical_m_inv_x, theoretical_m_inv_x], 'r--', 'LineWidth', 2);
hold on;
theoretical_m_x = 2 / (b + a); % 1 / E[X]
plot([min_n, max_n], [theoretical_m_x, theoretical_m_x], 'k--', 'LineWidth', 2);
title(sprintf('Uniform [%d, %d]', a, b));
legend('1/E[X]', 'E[1/X]', 'theoretical E[1/X]', 'theoretical 1/E[X]');

% Uniform [0, 1]
a = 0;
b = 1;
for i = 1:n
    [m_x(i), m_inv_x(i)] = ex2_4_function(a, b, N(i));
end

subplot(3, 1, 2);
plot(N, m_x);
hold on;
plot(N, m_inv_x);
hold on;
theoretical_m_x = 2 / (b + a); % 1 / E[X]
plot([min_n, max_n], [theoretical_m_x, theoretical_m_x], 'r--', 'LineWidth', 2);
title(sprintf('Uniform [%d, %d]', a, b));
legend('1/E[X]', 'E[1/X]', 'theoretical 1/E[X]');

% Uniform [-1, 1]
a = -1;
b = 1;
for i = 1:n
    [m_x(i), m_inv_x(i)] = ex2_4_function(a, b, N(i));
end

subplot(3, 1, 3);
plot(N, m_x);
hold on;
plot(N, m_inv_x);
hold on;
theoretical_m_inv_x = log(abs(b / a)) / (b - a); % E[1 / X]
plot([min_n, max_n], [theoretical_m_inv_x, theoretical_m_inv_x], 'r--', 'LineWidth', 2);
title(sprintf('Uniform [%d, %d]', a, b));
legend('1/E[X]', 'E[1/X]', 'theoretical E[1/X]');

function [m_x, m_inv_x] = ex2_4_function(a, b, n)
    X = a + rand(1, n) * (b - a);
    m_x = 1 / mean(X);
    m_inv_x = mean(X.^-1);
end
