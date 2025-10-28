clc, clearvars, close all;

% Fisrt column is resistance, second column is temperature (in Celsius)
restempData = load('thermostat.dat');
X = log(restempData(:,1));
Y = 1 ./ (restempData(:,2) + 273.15);
n = length(X);

kmax = 4;
alpha = 0.05;
nres = 100;
xvalues = linspace(min(X), max(X), nres);
zcrit = norminv(1 - alpha / 2);
my = mean(Y);
Sym = sum((Y - my).^2);

% (a)
for k = 1:kmax
    P = polyfit(X, Y, k);  % could also use regress
    Yhat = polyval(P, X);
    Syy = sum((Y - Yhat).^2);
    se = sqrt(Syy / (n - (k + 1)));
    stdres = (Y - Yhat) / se;  % standard residuals
    R2 = 1 - Syy / Sym;  % coefficient of multiple determination
    adjR2 = 1 - (n - 1) / (n - (k + 1)) * Syy / Sym;  % adjusted coefficient of multiple determination

    figure;
    scatter(X, Y, 10, 'k', 'filled');
    hold on;
    yvalues = polyval(P, xvalues);
    plot(xvalues, yvalues, '-r', 'LineWidth', 2);
    hold off;
    ax = axis;
    text((ax(2) - ax(1)) * 0.7 + ax(1), (ax(4) - ax(3)) * 0.2 + ax(3), sprintf('R^2=%.6f', R2));
    text((ax(2) - ax(1)) * 0.7 + ax(1), (ax(4) - ax(3)) * 0.1 + ax(3), sprintf('adjR^2=%.6f', adjR2));
    title(sprintf('%d Degree Polynomial Fit', k));
    xlabel('ln(R) (Ohm)');
    ylabel('1/T (Kelvin^{-1})');

    figure;
    scatter(Y, stdres, 10, 'k', 'filled');
    hold on;
    plot(xlim, zcrit * [1, 1], '--r', 'LineWidth', 2);
    plot(xlim, -zcrit * [1, 1], '--r', 'LineWidth', 2);
    hold off;
    title(sprintf('Diagnostic Plot (Polynomial deg: %d)', k));
    xlabel('1/T (Kelvin^{-1})');
    ylabel('Standard Residual');

    fprintf('Polynomial degree: %d\n', k);
    for i = 1:k + 1
        fprintf('b_%d = %.10f\n', i - 1, P(k - i + 2));
    end
    fprintf('Press any key to continue...\n');
    pause;
    close all;
end

% Steinhart-Hart model
Xr = [ones(size(X)), X, X.^3];
[B, ~, R, ~, STATS] = regress(Y, Xr);
Yhat = Xr * B;
k = 2;
Syy = sum(R.^2);
adjR2 = 1 - (n - 1) / (n - (k + 1)) * Syy / Sym;
R2 = STATS(1);  % alternatively: R2 = 1 - Syy / Sym
se = sqrt(STATS(4));  % alternatively: se = sqrt(Syy / (n - (k + 1)))
stdres = R / se;

figure;
scatter(X, Y, 10, 'k', 'filled');
hold on;
xtvalues = xvalues';
xvalues = [ones(size(xtvalues)), xtvalues, xtvalues.^3];
yvalues = xvalues * B;
plot(xtvalues, yvalues, '-r', 'LineWidth', 2);
hold off;
ax = axis;
text((ax(2) - ax(1)) * 0.7 + ax(1), (ax(4) - ax(3)) * 0.2 + ax(3), sprintf('R^2=%.6f', R2));
text((ax(2) - ax(1)) * 0.7 + ax(1), (ax(4) - ax(3)) * 0.1 + ax(3), sprintf('adjR^2=%.6f', adjR2));
title('Steinhart-Hart Model Fit');
xlabel('ln(R) (Ohm)');
ylabel('1/T (Kelvin^{-1})');

figure;
scatter(Y, stdres, 10, 'k', 'filled');
hold on;
plot(xlim, zcrit * [1, 1], '--r', 'LineWidth', 2);
plot(xlim, -zcrit * [1, 1], '--r', 'LineWidth', 2);
hold off;
title('Diagnostic Plot (Steinhart-Hart Model)');
xlabel('1/T (Kelvin^{-1})');
ylabel('Standard Residual');

fprintf('\n=== Steinhart-Hart Model ===\n');
fprintf('b_0 = %.10f\n', B(1));
fprintf('b_1 = %.10f\n', B(2));
fprintf('b_2 = %.10f\n', B(3));
