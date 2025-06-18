clc, clearvars, close all;

data = readtable('CPUperformance.xlsx');

n = 50;  % Change to 209
nameX = 'MYCT';
nameY = 'PRP';
idx = randperm(n);
X = data{idx, nameX};
Y = data{idx, nameY};

%% Select polynomial models of different orders
kmax = 3;
for k = 1:kmax
    % Fit model
    [~, y_pred, R2, adjR2] = Ex1Func3(Y, X, k, sprintf('Polynomial Model Fit (order: %d)', k));
    fprintf('Polynomial Model (order: %d): R-squared=%f, Adjusted R-squared=%f\n', k, R2, adjR2);

    % Diagnostic Plot
    Ex1Func6(Y, y_pred, Y, k, 'y', sprintf('Diagnostic Plot for Polynomial (order: %d)', k));
end

% We see that increasing the order of the polynomial we get better values
% R^2 thus the model fits better to the data. Also the adjusted R^2
% increases meaning that the increased complexity of the model is
% beneficial. From diagnostic plot we see that the residuals do not follow
% standardized normal distribution, thus we cannot say that our model is
% appropriate. More preceisely, we see that the residuals form a straight
% line which is an indication that our model needs more  independent 
% parameters to explain the dependent one. finally the change of N to 209
% does not pose any difference for the predictions of all the polyomial
% models.
