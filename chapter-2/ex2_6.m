clc, clearvars, close all;

n = 100;
N = 10000;
a = 0;
b = 1;
Y = zeros(1, N);
mu_Y_theoretical = (a + b) / 2;
std_Y_theoretical = sqrt((b - a)^2 / 12 / n);

for i = 1:N
    X = rand(1, n);
    Y(i) = mean(X);
end

figure;
nbins = 30;
histogram(Y, nbins, 'Normalization', 'pdf', 'DisplayName', 'Simulation');
hold on;
yvalues = linspace(min(Y), max(Y), 100);
probs = normpdf(yvalues, mu_Y_theoretical, std_Y_theoretical);
plot(yvalues, probs, '-r', 'LineWidth', 2, 'DisplayName', 'Theoretical pdf');
hold off;
xlabel('Y');
ylabel('Probability');
title(sprintf('Central Limit Theorem (n=%d)', n));
legend show;
