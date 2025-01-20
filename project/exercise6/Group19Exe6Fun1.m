% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

function [adjR2, MSE] = Group19Exe6Fun1(X, y, description)

    % Explicitly remove the observations that contain at least one NaN
    % feature value
    rowsWithoutNaN = ~any(isnan(X), 2);
    y = y(rowsWithoutNaN);
    X = X(rowsWithoutNaN,:);

    n = length(y);
    tss = sum((y - mean(y)).^2);
    figure('Position', [100, 100, 1100, 500]);
    
    % Full model
    X1 = [ones(n, 1), X];
    b_full = regress(y, X1);
    y_full = X1 * b_full;
    k = size(X, 2);
    SE_full = (y - y_full).^2;
    MSE_full = mean(SE_full);
    adjR2_full = 1 - (n - 1) / (n - (k + 1)) * sum(SE_full) / tss;

    % Observed vs predicted values plot
    subplot(2, 3, 1);
    Group19Exe6Fun2(y, y_full, sprintf('Full Model (%s)', description), adjR2_full);
    % Diagnostic plot
    subplot(2, 3, 4);
    Group19Exe6Fun3(y, y_full, sprintf('Full Model (%s)', description), MSE_full);
    
    % Stepwise Regression
    [b_step, ~, ~, inmodel, stats] = stepwisefit(X, y, 'display', 'on');
    b_step = [stats.intercept; b_step(inmodel)];  % Add intercept
    y_step = [ones(n, 1), X(:,inmodel)] * b_step;
    k = sum(inmodel);
    SE_step = (y - y_step).^2;
    MSE_step = mean(SE_step);
    adjR2_step = 1 - (n - 1) / (n - (k + 1)) * sum(SE_step) / tss;

    % Observed vs predicted values plot
    subplot(2, 3, 2);
    Group19Exe6Fun2(y, y_step, sprintf('Stepwise (%s)', description), adjR2_step);
    % Diagnostic plot
    subplot(2, 3, 5);
    Group19Exe6Fun3(y, y_step, sprintf('Stepwise (%s)', description), MSE_step);
    
    % LASSO
    [b_lasso, fitinfo] = lasso(X, y);
    % lassoPlot(b_lasso, fitinfo, 'PlotType', 'Lambda', 'XScale', 'log');

    % Find the index of minimum lambda value where the number of non-zero
    % coefficients is equal to the number of terms that the stepwise
    % regression selected
    lambda_index = find(sum(b_lasso ~= 0, 1) == sum(inmodel), 1);
    lambda = fitinfo.Lambda(lambda_index);
    fprintf('Lambda selected for LASSO (%s): %f\n', description, lambda);
    b_lasso = b_lasso(:,lambda_index);
    y_lasso = X * b_lasso + fitinfo.Intercept(lambda_index);
    SE_lasso = (y - y_lasso).^2;
    MSE_lasso = mean(SE_lasso);
    adjR2_lasso = 1 - (n - 1) / (n - (k + 1)) * sum(SE_lasso) / tss;

    % Observed vs predicted values plot
    subplot(2, 3, 3);
    Group19Exe6Fun2(y, y_lasso, sprintf('LASSO (%s)', description), adjR2_lasso);
    % Diagnostic plot
    subplot(2, 3, 6);
    Group19Exe6Fun3(y, y_lasso, sprintf('LASSO (%s)', description), MSE_lasso);

    adjR2 = [adjR2_full, adjR2_step, adjR2_lasso];
    MSE = [MSE_full, MSE_step, MSE_lasso];
end