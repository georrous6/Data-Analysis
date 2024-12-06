clc, clearvars, close all;

n = 10000000;
mu = [0, 0];
sigmaXX = 1.2;
sigmaYY = 0.7;
sigmaXY = 0.5;
sigma = [sigmaXX, sigmaXY; sigmaXY, sigmaYY];
R = mvnrnd(mu, sigma, n);
nbins = 100;

figure;
histogram2(R(:,1), R(:,2), nbins, 'Normalization', 'pdf');
title('Bivariate Normal Distribution');
xlabel('X');
ylabel('Y');
zlabel('Probability');

covMatrix = cov(R);
varX = covMatrix(1, 1);
varY = covMatrix(2, 2);
covXY = covMatrix(1, 2);
var_X_plus_Y = var(R(:,1) + R(:,2));
fprintf('Var[X] = %.6f (theoretical)\n', sigmaXX);
fprintf('Var[X] = %.6f (simulation)\n', varX);
fprintf('Var[Y] = %.6f (theoretical)\n', sigmaYY);
fprintf('Var[Y] = %.6f (simulation)\n', varY);
fprintf('Cov[X,Y] = %.6f (theoretical)\n', sigmaXY);
fprintf('Cov[X,Y] = %.6f (simulation)\n', covXY);
fprintf('Var[X+Y] = %.6f\n', var_X_plus_Y);
fprintf('Var[X] + Var[Y] = %.6f\n', varX + varY);

