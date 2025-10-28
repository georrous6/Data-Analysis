clc, clearvars, close all;

% Question (a)
sigma = 5;
l = 500;
w = 300;
sigma_area = sqrt((l^2 + w^2) * sigma^2);

npoints = 50;
max_lvalue = 1000;
max_wvalue = 1000;
lvalues = linspace(0, max_lvalue, npoints);
wvalues = sqrt(sigma_area^2 / sigma^2 - lvalues.^2);
idx = find(imag(wvalues) == 0);
plot(lvalues(idx), wvalues(idx), 'LineWidth', 2);
hold on;
plot(l, w, 'rx', 'LineWidth', 2, 'MarkerSize', 10);
title(sprintf('Length and Width values for which area uncertainty is: %.2f', sigma_area));
xlabel('Length');
ylabel('Width');

% Question (b)
lvalues = linspace(0, max_lvalue, npoints);
wvalues = linspace(0, max_wvalue, npoints);
[L, W] = meshgrid(lvalues, wvalues);
A = sqrt((L.^2 + W.^2) * sigma^2);

figure;
surf(L, W, A);
hold on;
surf(L, W, sigma_area * ones(size(L)), 'FaceColor', 'r');
hold off;
title('Area Uncertainty');
xlabel('Length');
ylabel('Width');
zlabel('Area Uncertainty');