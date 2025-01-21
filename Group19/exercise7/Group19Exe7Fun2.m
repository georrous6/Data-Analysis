% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

function [inmodel, lambda] = Group19Exe7Fun2(X, y)
    % Returns the predictors for the sepwise model and the lambda parameter
    % for the LASSO model that gives the minimum MSE
    [~, ~, ~, inmodel] = stepwisefit(X, y, 'display', 'on');
    [~, fitinfo] = lasso(X, y);
    [~, lambda_index] = min(fitinfo.MSE);
    lambda = fitinfo.Lambda(lambda_index);
end