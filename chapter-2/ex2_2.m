%% Exercise 2.2
clc, clearvars, close all;

N = 1000000;
num_of_bins = 100;
lamda = 1;
x = -log(1 - rand(1, N)) / lamda;
[bin_counts, bin_edges] = histcounts(x, num_of_bins);
probs = bin_counts / N; % calculate the probabilities
diffs = diff(bin_edges);
centers = bin_edges(1:end - 1) + diffs / 2.0;
probs = probs / diffs(1); % normalize probabilities to get pdf

% alternatively: histogram(X, 'Normalization', 'pdf');

figure;
bar(centers, probs, 'BarWidth', 1);
x_values = linspace(0, 10, num_of_bins);
y_values = lamda * exp(-lamda * x_values);
hold on;
plot(x_values, y_values, '-r', 'LineWidth', 2);
xlabel('Data');
ylabel('Probability');
title('Exercise 2.2');
