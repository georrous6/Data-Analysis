clc, clearvars, close all;

varnames = {'ManHours', 'Cases', 'Eligible', 'OpRooms'};
hospitalData = load('hospital.txt');

Y = hospitalData(:,1);
X = hospitalData(:,2:end);
n = length(Y);
my = mean(Y);
Smy = sum((Y - my).^2);
alpha = 0.05;
zcrit = norminv(1 - alpha / 2);

fprintf('%-15s%-15s%-15s%-15s\n', 'x-variable', 'Corr Coef', 'R^2', 'adjR^2');
for i = 1:size(X, 2)
    X1 = [ones(n, 1), X(:,i)];
    [~, ~, R] = regress(Y, X1);
    Syy = sum(R.^2);
    R2 = 1 - Syy / Smy;
    adjR2 = 1 - (n - 1) / (n - 2) * Syy / Smy;
    C = corrcoef(X(:,i), Y);
    fprintf('%-15s%15.5f%15.5f%15.5f\n', varnames{i + 1}, C(1, 2), R2, adjR2);
end

% Full Model
X1 = [ones(n, 1), X];
[B, BINT, R, ~, STATS] = regress(Y, X1);
k = size(X1, 2) - 1;
Syy = sum(R.^2);
R2 = STATS(1);  % alternatively: R2 = 1 - Syy / Smy;
se = sqrt(STATS(4));  % alternatively: se = sqrt(Syy / (n - k - 1));
adjR2 = 1 - (n - 1) / (n - k - 1) * Syy / Smy;
stderr = R / se;
fprintf('\nFULL MODEL\n');
fprintf('%-12s%-10s%-10s%-25s\n', 'x-variable', 'beta', 'estimate', sprintf('%d%% CI', 100 * (1 - alpha)));
fprintf('%-12s%-10s%10.5f%25s\n', 'const', 'b_0', B(1), sprintf('[%.5f,%.5f]', BINT(1, 1), BINT(1, 2)));
for i = 2:length(B)
    fprintf('%-12s%-10s%10.5f%25s\n', varnames{i}, sprintf('b_%d', i - 1), B(i), sprintf('[%.5f,%.5f]', BINT(i, 1), BINT(i, 2)));
end
fprintf('se = %.5f, R^2 = %.5f, adjR^2 = %.5f\n\n', se, R2, adjR2);

figure;
scatter(Y, stderr, 20, 'k', 'filled');
hold on;
plot(xlim, -zcrit * [1, 1], '--r', 'LineWidth', 2);
plot(xlim, zcrit * [1, 1], '--r', 'LineWidth', 2);
hold off;
title('Diagnostic Plot (Full Model)');
xlabel('Man Hours');
ylabel('Standard Residual');

% Stepwise Model
[B, SE, ~, INMODEL, STATS] = stepwisefit(X, Y);
k = sum(INMODEL);
b0 = STATS.intercept;
Yhat = X(:,INMODEL) * B(INMODEL) + b0;
Syy = sum((Y - Yhat).^2);
se = STATS.rmse;  % alternatively: se = sqrt(1 / (n - k - 1) * Syy);
stderr = (Y - Yhat) / se;
R2 = 1 - Syy / Smy;
adjR2 = 1 - (n - 1) / (n - k - 1) * Syy / Smy;
tcrit = tinv(1 - alpha / 2, n - k - 1);
BINT = [B - tcrit * SE, B + tcrit * SE];
fprintf('\nSTEPWISE MODEL\n');
fprintf('%-12s%-10s%-10s%-25s\n', 'x-variable', 'beta', 'estimate', sprintf('%d%% CI', 100 * (1 - alpha)));
fprintf('%-12s%-10s%10.5f%25s\n', 'const', 'b_0', b0, '--');
for i = 1:length(B)
    if INMODEL(i) == 1
        fprintf('%-12s%-10s%10.5f%25s\n', varnames{i + 1}, sprintf('b_%d', i), B(i), sprintf('[%.5f,%.5f]', BINT(i, 1), BINT(i, 2)));
    end
end
fprintf('se = %.5f, R^2 = %.5f, adjR^2 = %.5f\n\n', se, R2, adjR2);

figure;
scatter(Y, stderr, 20, 'k', 'filled');
hold on;
plot(xlim, -zcrit * [1, 1], '--r', 'LineWidth', 2);
plot(xlim, zcrit * [1, 1], '--r', 'LineWidth', 2);
hold off;
title('Diagnostic Plot (Stepwise Model)');
xlabel('Man Hours');
ylabel('Standard Residual');

% Check multicollinearity
fprintf('MULTICOLLINEARITY\n');
fprintf('%-20s%-20s%-10s%-10s%-10s\n', 'y-variable', 'x-variables', 'R^2', 'adjR^2', 'se');
for i = 1:size(X, 2)
    idx = setdiff(1:size(X, 2), i);
    X1 = [ones(n, 1), X(:,idx)];
    Xi = X(:,i);
    [B, BINT, R, ~, STATS] = regress(Xi, X1);
    k = size(X1, 2) - 1;
    Syy = sum(R.^2);
    mxi = mean(Xi);
    Smxi = sum((Xi - mxi).^2);
    R2 = STATS(1);  % alternatively: R2 = 1 - Syy / Smy;
    se = sqrt(STATS(4));  % alternatively: se = sqrt(Syy / (n - k - 1));
    adjR2 = 1 - (n - 1) / (n - k - 1) * Syy / Smxi;
    
    xvarnames = sprintf('%s,', varnames{idx + 1});
    xvarnames = xvarnames(1:end - 1);
    fprintf('%-20s%-20s%10.5f%10.5f%10.5f\n', varnames{i + 1}, xvarnames, R2, adjR2, se);
end
