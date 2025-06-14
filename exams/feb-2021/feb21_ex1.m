clc, clearvars, close all;
addpath(genpath(fullfile('..', '..', 'lib')));

X = [14 28 15 16 14 15 31 20 17 23 18 24 18 26 17 24 11 18 41 32 23 27 31 40 9 19 18 28 19 20];

nbins = 3;
B = 100;
alpha = 0.05;
[p_value, critical_val, dof] = parametric_gof(X, 'poisson', nbins, alpha, 'Figure 1');

[p_value_boot, critical_val_boot] = bootstrap_gof(X, B, 'poisson', nbins, length(X), alpha, 'Figure 2');

% Answers to questions
fprintf('1. Degrees of Freedom: %d\n', dof);
fprintf('2. For p-value = %.4f and alpha = %.2f, we %s the null hypothesis of Poisson distribution.\n', ...
    p_value, alpha, ternary(p_value > alpha, 'cannot reject', 'reject'));
fprintf('3. For p-value = %.4f and alpha = %.2f, we %s the null hypothesis of Poisson distribution.\n', ...
    p_value_boot, alpha, ternary(p_value_boot > alpha, 'cannot reject', 'reject'));
fprintf('4. The results from Q2 and Q3 %s.\n', ...
    ternary((p_value > 0.05 && p_value_boot > 0.05) || (p_value < 0.05 && p_value_boot < 0.05), 'agree', 'do not agree'));
