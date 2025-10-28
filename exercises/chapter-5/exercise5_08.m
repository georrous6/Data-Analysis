clc, clearvars, close all;

varnames = {'Mass', 'Fore', 'Bicep', 'Chest', 'Neck', 'Shoulder', 'Waist', 'Height', 'Calf', 'Thigh', 'Head'};
physicalData = load('physical.txt');
Y = physicalData(:,1);
X = physicalData(:,2:size(physicalData, 2));
n = length(Y);
alpha = 0.05;
zcrit = norminv(1 - alpha / 2);
my = mean(Y);

fprintf('%-10s%-10s%-10s%-10s\n', 'var-name', 'rho', 'R^2', 'adjR^2');
for i = 1:size(X, 2)
    X1 = [ones(size(X, 1), 1), X(:,i)];
    [~, ~, R, ~, STATS] = regress(Y, X1);
    sse = sum(R.^2);  % sum of squared errors
    sst = sum((Y - my).^2);  % total sum of squares
    R2 = STATS(1);  % alternatively: R2 = 1 - sse / sst;
    adjR2 = 1 - (n - 1) / (n - 2) * sse / sst;
    C = corrcoef(X(:,i), Y);
    fprintf('%-10s%10.5f%10.5f%10.5f\n', varnames{i + 1}, C(1, 2), R2, adjR2);
end

X1 = [ones(size(X, 1), 1), X];
[B, BINT, R, ~, STATS] = regress(Y, X1);
sse = sum(R.^2);  % sum of squared errors
sst = sum((Y - my).^2);  % total sum of squares
R2 = STATS(1);  % alternatively: R2 = 1 - sse / sst;
rmse = sqrt(STATS(4));  % alternatively: rmse = sqrt(sse / (n - k - 1));
stdres = R / rmse;
k = size(X, 2);  % number of predictors in the model
adjR2 = 1 - (n - 1) / (n - (k + 1)) * sse / sst;
fprintf('\n========== Regression Model (all predictors) ==========\n');
fprintf('%-10s%-10s%-10s%-20s\n', 'var-name', 'beta', 'estimate', sprintf('%d%% CI', (1 - alpha) * 100));
fprintf('%-10s%-10s%10.5f%20s\n', 'const', 'b_0', B(1), sprintf('[%.5f,%.5f]', BINT(1, 1), BINT(1, 2)));
for i = 2:length(B)
    fprintf('%-10s%-10s%10.5f%20s\n', varnames{i}, sprintf('b_%d', i - 1), B(i), sprintf('[%.5f,%.5f]', BINT(i, 1), BINT(i, 2)));
end
fprintf('rmse = %.6f, R^2 = %.6f, adjR^2 = %.6f\n\n', rmse, R2, adjR2);

figure;
scatter(Y, stdres, 10, 'k', 'filled');
hold on;
plot(xlim, zcrit * [1, 1], '--r', 'LineWidth', 2);
plot(xlim, -zcrit * [1, 1], '--r', 'LineWidth', 2);
hold off;
title('Diagnostic Plot (Full Model)');
xlabel('Mass');
ylabel('Standard Residual');


[B, SE, ~, INMODEL, STATS] = stepwisefit(X, Y);  % or use stepwise for GUI
rmse = STATS.rmse;
b0 = STATS.intercept;
Ypred = X(:,INMODEL) * B(INMODEL) + b0;
stdres = (Y - Ypred) / rmse;
sse = sum((Y - Ypred).^2);
R2 = 1 - sse / sst;
k = sum(INMODEL);  % number of predictors in the model
adjR2 = 1 - (n - 1) / (n - (k + 1)) * sse / sst;
tcrit = tinv(1 - alpha / 2, n - (k + 1));
BINT = [B - tcrit * SE, B + tcrit * SE];
fprintf('\n========== Stepwise Regression Model ==========\n');
fprintf('%-10s%-10s%-10s%-20s\n', 'var-name', 'beta', 'estimate', sprintf('%d%% CI', (1 - alpha) * 100));
fprintf('%-10s%-10s%10.5f%20s\n', 'const', 'b_0', b0, '--');
for i = 1:length(B)
    if INMODEL(i) == 1
        fprintf('%-10s%-10s%10.5f%20s\n', varnames{i + 1}, sprintf('b_%d', i), B(i), sprintf('[%.5f,%.5f]', BINT(i, 1), BINT(i, 2)));
    end
end
fprintf('rmse = %.6f, R^2 = %.6f, adjR^2 = %.6f\n\n', rmse, R2, adjR2);

figure;
scatter(Y, stdres, 10, 'k', 'filled');
hold on;
plot(xlim, zcrit * [1, 1], '--r', 'LineWidth', 2);
plot(xlim, -zcrit * [1, 1], '--r', 'LineWidth', 2);
hold off;
title('Diagnostic Plot (Stepwise Regression Model)');
xlabel('Mass');
ylabel('Standard Residual');
