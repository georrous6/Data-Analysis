clc, clearvars, close all;

rng(42);  % For reproducibility
n = 1000;
varx = 1;
vary = 4;
mu = [0, 0];
sigma = [varx, 0; 0, vary];

% Create 2D data and transform them to 3D space
W = [0.2, 0.8; 0.4, 0.5; 0.7, 0.3];
R = mvnrnd(mu, sigma, n);
figure;
markerSize = 5;
scatter(R(:,1), R(:,2), markerSize, 'filled', 'Marker', 'o');
xlabel('r1');
ylabel('r2');
title('2D Gauusian Generated Points');
X = R * W';
figure;
scatter3(X(:,1), X(:,2), X(:,3), markerSize, 'filled', 'Marker', 'o');
xlabel('x1');
ylabel('x2');
zlabel('x3');
title('3D Observed Points');

% Centralize data
X = X - mean(X);

% Compute variance-covariance matrix
S = cov(X);

% Compute eigenvalues of variance-covariance matrix
[A, L] = eig(S);
[eigenvalues, sortIndex] = sort(diag(L), 'descend', 'ComparisonMethod', 'abs');
A = A(:,sortIndex);
disp('Eigenvalues of variance-covariance matrix:');
disp(eigenvalues);
Y = X * A;

% Plot PC scores
figure;
scatter3(Y(:,1), Y(:,2), Y(:,3), markerSize, 'filled', 'Marker', 'o');
xlabel('PC1');
ylabel('PC2');
zlabel('PC3');
title('Principal Components Scores');

% Scree plot
figure;
plot(1:length(eigenvalues), eigenvalues, '-o');
xlabel('Index');
ylabel('Eigenvalue');
title('Scree Plot');

figure;
scatter(Y(:,1), Y(:,2), markerSize, 'filled', 'Marker', 'o');
xlabel('PC1');
ylabel('PC2');
title('Principal Components Scores');
