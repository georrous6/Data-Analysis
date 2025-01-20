% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

clc, clearvars, close all;
addpath('..');  % Add the parent directory to the path

data_with_TMS = loadTMSdata('../TMS.xlsx');

X = data_with_TMS(:,end-5:end);
y = data_with_TMS(:,2);

[adjR2_with_spike, MSE_with_spike] = Group19Exe6Fun1(X, y, 'with Spike');
[adjR2_without_spike, MSE_without_spike] = Group19Exe6Fun1(X(:,[1, 2, 3, 5, 6]), y, 'without Spike');

fprintf('\nWith Spike\n==================================\n');
fprintf('\t\t  Full \t    Step \t LASSO\n');
fprintf('adjR^2');
disp(adjR2_with_spike);
fprintf('MSE    ');
disp(MSE_with_spike);
fprintf('\nWithout Spike\n==================================\n');
fprintf('\t\t  Full \t    Step \t LASSO\n');
fprintf('adjR^2');
disp(adjR2_without_spike);
fprintf('MSE    ');
disp(MSE_without_spike);

% Analysis of Model Performance with and without the Spike Variable
%
% Performance Analysis (With Spike):
% 
% - The full regression model achieves the lowest Mean Squared Error (MSE), 
%   followed by the stepwise regression model, and finally the LASSO model.
%
% - Despite its lower MSE, the full model has the smallest adjusted R-squared 
%   (adjR^2) statistic. This is because adjR^2 penalizes models with greater 
%   complexity, i.e., models using more predictors.
%
% - Both the stepwise and LASSO models use the same number of independent 
%   variables, but the stepwise model has a smaller MSE. Consequently, the 
%   stepwise model’s adjR^2 is higher than that of the LASSO model.
%
% - Summary: The full model is optimal for minimizing MSE, whereas the stepwise 
%   model is optimal for maximizing adjR^2.
%
% Performance Analysis (Without Spike):
%
% - As observed with the Spike variable, the full model achieves the lowest
%   MSE but performs worse in terms of adjR^2 due to its higher complexity.
%
% - The stepwise model performs better than the LASSO model in both MSE 
%   and adjR^2 scores.
%
% - Summary: Without the Spike variable, the full model remains the best 
%   choice for minimizing MSE, while the stepwise model again offers the 
%   best adjR^2.
%
% Comparison: With vs. Without Spike:
%
% - Full Model: 
%   When the Spike variable is excluded, the full model experiences a 
%   significant decrease in adjR^2 but achieves an improvement in MSE.
% 
% - Stepwise Model: 
%   Similar to the full model, the stepwise regression shows lower adjR^2 but 
%   better MSE when the Spike variable is removed.
% 
% - LASSO Model: 
%   The LASSO model shows no change in adjR^2 but achieves a lower MSE without 
%   the Spike variable.
%
% Key Takeaways:
%
% - Excluding the Spike variable results in improved MSE across all models.
%
% - The adjusted R-squared statistic generally decreases for the full and 
%   stepwise models.
%
% - Interestingly, the LASSO model’s adjR^2 remains unaffected by the presence 
%   or absence of the Spike variable.
%
% - This analysis highlights the trade-offs between minimizing MSE and 
%   maximizing adjR^2, with the full model excelling in the former and the 
%   stepwise model excelling in the latter.
