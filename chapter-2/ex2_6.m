%% Exercise 2.6
clc, clearvars, close all;
n_x = 100;
n_y = 10000;
a = 0;
b = 1;

Y = zeros(1, n_y);
for i = 1:n_y
    X = a + (b - a) * rand(1, n_x);
    Y(i) = mean(X);
end

% Plot simulation data
figure;
histogram(Y, 'Normalization', 'pdf');
hold on;

% Calculate theoretical cdf according to Central Limit Theorem (CLT)
mu = (a + b) / 2; % theoretical mean
sigma = sqrt((b - a)^2 / 12 / n_x); % theoretical standard deviation
x_values = linspace(min(Y), max(Y), 1000);
y_values = exp(-(x_values - mu).^2 / (2 * sigma^2)) / (sqrt(2 * pi) * sigma);

plot(x_values, y_values, 'r-', 'LineWidth', 2);
title('Exercise 2.6');
xlabel('Mean (Y)');
ylabel('Probability Density');
legend('Histogram of mean (Y)', 'Theoretical Normal Distribution');
