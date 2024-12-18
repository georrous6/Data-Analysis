clc, clearvars, close all;

lightairData = load('lightair.dat');
X = lightairData(:,1);
Y = lightairData(:,2);
n = length(X);
alpha = 0.05;

% (a)
R = corrcoef(lightairData);
r = R(1, 2);
fprintf('(a) r=%.4f\n', r);

% (b)
% Estimation of linear regression parameters - 1st way
P = polyfit(X, Y, 1);  % or using regress
b1 = P(1);
b0 = P(2);
fprintf('(b) polyfit: b0=%.4f, b1=%.4f\n', b0, b1);

% Estimation of linear regression parameters - 2nd way
C = cov(X, Y);
b1 = C(1, 2) / C(1, 1);
mx = mean(X);
my = mean(Y);
b0 = my - b1 * mx;
fprintf('(b) using estimators: b0=%.4f, b1=%.4f\n', b0, b1);

% Calculation of CI for linear regression parameters
yhat = b1 * X + b0;
se = sqrt(sum((Y - yhat).^2) / (n - 2));
Sxx = C(1, 1) * (n - 1);
sb1 = se / sqrt(Sxx);
tcrit = tinv(1 - alpha / 2, n - 2);
cib1 = [b1 - tcrit * sb1, b1 + tcrit * sb1];
sb0 = se * sqrt(1 / n + mx^2 / Sxx);
cib0 = [b0 - tcrit * sb0, b0 + tcrit * sb0];
fprintf('(b) b0 %.2f%% confidence interval: [%.4f, %.4f]\n', 100 * (1 - alpha), cib0(1), cib0(2));
fprintf('(b) b1 %.2f%% confidence interval: [%.4f, %.4f]\n', 100 * (1 - alpha), cib1(1), cib1(2));

% (c)
% Calculation of CI for mean of Y
symV = se * sqrt(1 / n + (X - mx).^2 / Sxx);
symcilV = yhat - tcrit * symV;
symciuV = yhat + tcrit * symV;

% Calculation of CI for Y estimation
syV = se * sqrt(1 + 1 / n + (X - mx).^2 / Sxx);
sycilV = yhat - tcrit * syV;
syciuV = yhat + tcrit * syV;

x0 = 1.29;
y0 = b1 * x0 + b0;
% Calculation of CI for mean of y0
sy0mV = se * sqrt(1 / n + (x0 - mx).^2 / Sxx);
sy0mcilV = y0 - tcrit * sy0mV;
sy0mciuV = y0 + tcrit * sy0mV;
fprintf('(c) %.2f%% CI for mean y(x=%.4f)=%.4f: [%.4f, %.4f]\n', 100 * (1 - alpha), x0, y0, sy0mcilV, sy0mciuV);

% Calculation of CI for y0 estimation
sy0V = se * sqrt(1 + 1 / n + (x0 - mx).^2 / Sxx);
sy0cilV = y0 - tcrit * sy0V;
sy0ciuV = y0 + tcrit * sy0V;
fprintf('(c) %.2f%% CI for estimated y(x=%.4f)=%.4f: [%.4f, %.4f]\n', 100 * (1 - alpha), x0, y0, sy0cilV, sy0ciuV);

% (d)
c = 299792.458;
d0 = 1.29;
beta0 = c - 299000;
beta1 = - 0.00029 * c / d0;
tb0 = (b0 - beta0) / sb0;
pvalb0 = 2 * (1 - tcdf(abs(tb0), n - 2));
tb1 = (b1 - beta1) / sb1;
pvalb1 = 2 * (1 - tcdf(abs(tb1), n - 2));
fprintf('(d) alpha=%.2f, H0(beta0=%.4f): p-value=%.4f, ', alpha, beta0, pvalb0);
if beta0 > cib0(1) && beta0 < cib0(2)
    fprintf('%.4f in [%.4f, %.4f] -> cannot reject H0\n', beta0, cib0(1), cib0(2));
else
    fprintf('%.4f not in [%.4f, %.4f] -> reject H0\n', beta0, cib0(1), cib0(2));
end

fprintf('(d) alpha=%.2f, H0(beta1=%.4f): p-value=%.4f, ', alpha, beta1, pvalb1);
if beta1 > cib1(1) && beta1 < cib1(2)
    fprintf('%.4f in [%.4f, %.4f] -> cannot reject H0\n', beta1, cib1(1), cib1(2));
else
    fprintf('%.4f not in [%.4f, %.4f] -> reject H0\n', beta1, cib1(1), cib1(2));
end

figure;
scatter(X, Y, 6, 'k', 'filled');
hold on;
h1 = plot(X, yhat, '-r');
h2 = plot(X, symcilV, '--c');
plot(X, symciuV, '--c');
h3 = plot(X, sycilV, '-.g');
plot(X, syciuV, '-.g');
ax = axis;
plot([ax(1), x0, x0], [y0, y0, ax(3)], '--k');
hold off;
title(sprintf('Variance Diagram (r=%.4f)', r));
xlabel('Air Density (kg/m^3)');
ylabel('Light Velocity (-299000 km/sec)');
legend([h1, h2, h3], {'linear regression', 'mean confidence interval', 'prediction confidence interval'});
