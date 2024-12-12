clc, clearvars, close all;

n = 10000;
lambda = 1;
exp_cdf_inv = @(x) (-log(1 - x) / lambda);
exp_pdf = @(x) (lambda * exp(-lambda * x));
X = rand(1, n);
Y = exp_cdf_inv(X);

nbins = 30;
histogram(Y, nbins, 'Normalization', 'pdf', 'DisplayName', 'Simulation Data');
hold on;
xvalues = linspace(min(Y), max(Y), 100);
yvalues = exp_pdf(xvalues);
plot(xvalues, yvalues, '-r', 'LineWidth', 2, 'DisplayName', 'Exponential pdf');
hold off;
xlabel('value');
ylabel('Probability');
legend show;