% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

function [adjR2, MSE] = Group19Exe8Fun1(X, y, description)

    n = length(y);
    tss = sum((y - mean(y)).^2);
    figure;
    
    % Full model
    X1 = [ones(n, 1), X];
    b_full = regress(y, X1);
    y_full = X1 * b_full;
    k = size(X, 2);
    SE_full = (y - y_full).^2;
    MSE_full = mean(SE_full);
    adjR2_full = 1 - (n - 1) / (n - (k + 1)) * sum(SE_full) / tss;

    % Observed vs predicted values plot
    subplot(2, 2, 1);
    observedVsPredictedPlot(y, y_full, sprintf('Full Model (%s)', description), ...
        sprintf('adjR^2=%.3f', adjR2_full));
    
    % Stepwise Regression
    [b_step, ~, ~, inmodel, stats] = stepwisefit(X, y, 'display', 'on');
    b_step = [stats.intercept; b_step(inmodel)];  % Add intercept
    y_step = [ones(n, 1), X(:,inmodel)] * b_step;
    k = sum(inmodel);
    SE_step = (y - y_step).^2;
    MSE_step = mean(SE_step);
    adjR2_step = 1 - (n - 1) / (n - (k + 1)) * sum(SE_step) / tss;

    % Observed vs predicted values plot
    subplot(2, 2, 2);
    observedVsPredictedPlot(y, y_step, sprintf('Stepwise (%s)', description), ...
        sprintf('adjR^2=%.3f', adjR2_step));
    
    % LASSO
    [b_lasso, fitinfo] = lasso(X, y);
    % lassoPlot(b_lasso, fitinfo, 'PlotType', 'Lambda', 'XScale', 'log');

    % Find the lambda that gives the minimum MSE
    [~, lambda_index] = min(fitinfo.MSE);
    lambda = fitinfo.Lambda(lambda_index);
    fprintf('Lambda selected for LASSO (%s): %f, MSE=%f\n', description, lambda, fitinfo.MSE(lambda_index));
    b_lasso = b_lasso(:,lambda_index);
    y_lasso = X * b_lasso + fitinfo.Intercept(lambda_index);
    SE_lasso = (y - y_lasso).^2;
    MSE_lasso = mean(SE_lasso);
    k = sum(b_lasso ~= 0);
    adjR2_lasso = 1 - (n - 1) / (n - (k + 1)) * sum(SE_lasso) / tss;

    % Observed vs predicted values plot
    subplot(2, 2, 3);
    observedVsPredictedPlot(y, y_lasso, sprintf('LASSO (%s)', description), ...
        sprintf('adjR^2=%.3f', adjR2_lasso));

    % PCR
    [~, score, ~, ~, explained] = pca(X);

    % Select the principal components that explain e.g 95% of the variance
    explainedVariance = cumsum(explained);
    numComponents = find(explainedVariance >= 95, 1);

    % Apply regression on the reduced principal components and make
    % predictions
    X_reduced = [ones(n, 1), score(:, 1:numComponents)];
    b_pcr = regress(y, X_reduced);
    y_pcr = X_reduced * b_pcr;

    % Evaluate model performance
    SE_pcr = (y - y_pcr).^2;
    MSE_pcr = mean(SE_pcr);
    k = size(X_reduced, 2);
    adjR2_pcr = 1 - (n - 1) / (n - (k + 1)) * sum(SE_lasso) / tss;

    % Observed vs predicted values plot
    subplot(2, 2, 4);
    observedVsPredictedPlot(y, y_pcr, sprintf('PCR (%s)', description), sprintf('adjR^2=%.3f', adjR2_pcr));

    adjR2 = [adjR2_full, adjR2_step, adjR2_lasso, adjR2_pcr];
    MSE = [MSE_full, MSE_step, MSE_lasso, MSE_pcr];
end