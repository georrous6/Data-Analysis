%% Exercise 2.1
clc, clearvars, close all;

tol = 1e-3;
iters = 7;
n_values = zeros(1, iters);
probs = zeros(1, iters);

for i = 1:iters
    n = 10^i;
    n_values(i) = n;
    probs(i) = sum(randi(2, 1, n) == 1) / n; % 1 denotes tails, 2 denotes heads
end

figure;
plot(n_values, probs, '*');
set(gca, 'XScale', 'log');  % Set x-axis to logarithmic scale
xlabel('Number of coin flips');
ylabel('Probability of getting tails');
title('Exercise 2.1');
