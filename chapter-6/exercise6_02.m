clc, clearvars, close all;

X = load('yeast.dat');
[n, p] = size(X);

% Standardize the data
X = zscore(X);
S = cov(X);

[A, L] = eig(S);
[eigenvalues, sortIndex] = sort(diag(L), 'descend', 'ComparisonMethod', 'abs');
A = A(:,sortIndex);
mean_eigenvalue = mean(eigenvalues);

% Estimate PC dimension
d = sum(eigenvalues > mean_eigenvalue);
fprintf('PC dimension: d=%d\n', d);

% Screee plot
figure;
lineWidth = 1.2;
hold on;
plot(1:p, eigenvalues, '-o', 'LineWidth', lineWidth);
plot(xlim, mean_eigenvalue * [1, 1], '--r', 'LineWidth', lineWidth);
hold off;
xlabel('Component');
ylabel('Eigenvalue');
title('Scree Plot');

% Explained Cumulative Variance
explvar = eigenvalues / sum(eigenvalues);
cumvar = cumsum(explvar);
figure;
hold on;
plot(1:p, cumvar, '-o', 'LineWidth', lineWidth);
plot(xlim, cumvar(d) * [1, 1], '--r', 'LineWidth', lineWidth);
hold off;
xlabel('Component');
ylabel('Explained Variance');
title('Cumulative Explained Variance Plot');

% PC scores in 2D and 3D
Y = X * A;
markerSize = 5;
figure;
scatter3(Y(:,1), Y(:,2), Y(:,3), markerSize, 'filled');
xlabel('PC1');
ylabel('PC2');
zlabel('PC3');
title('Principal Components Scores');

figure;
scatter(Y(:,1), Y(:,2), markerSize, 'filled');
xlabel('PC1');
ylabel('PC2');
title('Principal Components Scores');
