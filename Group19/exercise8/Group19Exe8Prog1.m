% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

clc, clearvars, close all;
addpath('../lib/');  % Add the parent directory to the path

data_with_TMS = loadTMSdata('../TMS.xlsx');

X = data_with_TMS{:,{'preTMS', 'Setup', 'Stimuli', 'Intensity', 'Frequency', 'CoilCode'}};
y = data_with_TMS{:,{'EDduration'}};

[adjR2_without_postTMS, MSE_without_postTMS] = Group19Exe8Fun1(X, y, 'without postTMS');

X = data_with_TMS{:,{'preTMS', 'postTMS', 'Setup', 'Stimuli', 'Intensity', 'Frequency', 'CoilCode'}};
[adjR2_with_postTMS, MSE_with_postTMS] = Group19Exe8Fun1(X, y, 'with postTMS');


fprintf('\nWithout postTMS\n==================================\n');
fprintf('\t\t  Full \t    Step \t LASSO \t PCR\n');
fprintf('adjR^2');
disp(adjR2_without_postTMS);
fprintf('MSE    ');
disp(MSE_without_postTMS);
fprintf('\nWith postTMS\n==================================\n');
fprintf('\t\t  Full \t    Step \t LASSO \t PCR\n');
fprintf('adjR^2');
disp(adjR2_with_postTMS);
fprintf('MSE    ');
disp(MSE_with_postTMS);

% Without postTMS:
%
% - The PCR model shows slightly better performance in terms of adjusted R-squared value 
%   compared to the other models, but it has the worst performance based on MSE. 
%   The full and stepwise models perform identically due to the reasons noted in the 
%   previous exercises.
%
% - Compared to the models in Exercise 5, the performance of the current models is 
%   significantly improved due to the inclusion of more predictor variables.
%
% With postTMS:
%
% - Including postTMS substantially enhances the predictive power of all models, achieving 
%   adjusted R-squared values that are nearly equal to 1. In this scenario, the stepwise and 
%   full models slightly outperform the LASSO and PCR methods. 
%
% - It is important to note that the Spike variable was excluded from this analysis, as 
%   observed in previous exercises, due to its negative impact on model performance.

