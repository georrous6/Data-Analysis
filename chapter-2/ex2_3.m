%% Exercise 2.3
clc, clearvars, close all;
n = 100000;
var_x = 7;
var_y = 4;
var_xy = 1.5;
mu = [2 3];
sigma = [var_x, var_xy; var_xy, var_y];
% rng('default')  % For reproducibility
R = mvnrnd(mu, sigma, n);
X = R(:, 1);
Y = R(:, 2);
C = cov(X, Y); % covariance matrix
fprintf("Var(X) = %f\n", C(1, 1));
fprintf("Var(Y) = %f\n", C(2, 2));
fprintf("Var(X + Y) = %f\n", var(X + Y));
fprintf("Cov(X, Y) = %f\n", C(1, 2));
fprintf("Var(X) + Var(Y) + 2 * Cov(X, Y) = %f\n", C(1, 1) + C(2, 2) + 2 * C(1, 2));
