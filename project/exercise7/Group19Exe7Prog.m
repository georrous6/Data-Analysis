% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

clc, clearvars, close all;
addpath('..');  % Add the parent directory to the path

data_with_TMS = loadTMSdata('../TMS.xlsx');

rng(42);  % Add random seed for reproducibility

X = data_with_TMS{:,{'Setup', 'Stimuli', 'Intensity', 'Frequency', 'CoilCode'}};
y = data_with_TMS{:,{'EDduration'}};
MSE = Group19Exe7Fun1(X, y, 0.3);

fprintf('\n==================================\n');
fprintf('Full Model MSE: %.4f\n\n', MSE(1, 1));
fprintf('Var Selection \t\t Step \t LASSO\n');
fprintf('From all data:     ');
disp(MSE(1,[2, 3]));
fprintf('\bFrom training data:');
disp(MSE(2,[2, 3]));

% Predictors Selection from All the Data:
%
% In this case, stepwise regression achieves the smallest Mean Square Error (MSE),
% indicating the best performance among the models. The full model shows performance 
% similar to the LASSO model. This similarity arises because the lambda parameter in 
% the LASSO model is chosen to minimize the MSE. As a result, the selected lambda value 
% is very small (nearly zero), causing the LASSO model to behave similarly to the 
% Ordinary Least Squares (OLS) method.
%
% Predictors Selection from the Training Data:
%
% Stepwise regression once again demonstrates the best performance in terms of MSE, 
% which remains unchanged compared to the previous case. This consistency is because 
% the model selected the same predictors, namely Setup and Frequency. The LASSO model 
% shows a slight improvement in performance compared to the previous case. 
% 
% Overall, the performance of both the stepwise regression and LASSO models does not 
% change significantly when predictors (or the lambda parameter) are selected using 
% all the data or only the training set. It is important to note that the Spike 
% predictor is excluded from this analysis, as previous exercises showed it negatively 
% impacts the performance of the models.

