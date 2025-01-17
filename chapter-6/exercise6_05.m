clc, clearvars, close all;

n = 1000;
p = 5;
mu = [0.2, 0.3, 0.7, 0.5, 0.9];
X = zeros(n, p);

for i = 1:p
    X(:,i) = exprnd(mu(i), n, 1);
end

beta = [0, 2, 0, -3, 0]';
mu_epsilon = 0;
sigma_epsilon = 5;
epsilon = normrnd(mu_epsilon, sigma_epsilon, n, 1);
y = X * beta + epsilon;
