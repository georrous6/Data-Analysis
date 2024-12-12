clc, clearvars, close all;

N = 8;
probs = zeros(1, N);
nvalues = zeros(1, N);
for i = 0:N
    n = 10^i;
    nvalues(i + 1) = n;
    probs(i + 1) = sum(randi(2, 1, n) - 1) / n;
end

figure;
plot(nvalues, probs, '-go', 'LineWidth', 2);
hold on;
plot(nvalues, 0.5 * ones(1, N + 1), '--r', 'LineWidth', 2);
set(gca, 'XScale', 'log'); % Set the x-axis to a logarithmic scale
xlabel('Coin tosses');
ylabel('Tails probability');
