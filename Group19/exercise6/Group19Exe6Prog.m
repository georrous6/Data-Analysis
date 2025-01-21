% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

clc, clearvars, close all;
addpath('../lib/');  % Add the parent directory to the path

data_with_TMS = loadTMSdata('../TMS.xlsx');

X = data_with_TMS{:,{'Setup', 'Stimuli', 'Intensity', 'Spike', 'Frequency', 'CoilCode'}};
y = data_with_TMS{:,{'EDduration'}};

[adjR2_with_spike, MSE_with_spike] = Group19Exe6Fun1(X, y, 'with Spike');
X = data_with_TMS{:,{'Setup', 'Stimuli', 'Intensity', 'Frequency', 'CoilCode'}};
[adjR2_without_spike, MSE_without_spike] = Group19Exe6Fun1(X, y, 'without Spike');

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
% With Spike:
%
% In this case, the LASSO model demonstrates the best performance in terms of both 
% the adjusted R-squared statistic (adjR^2) and Mean Square Error (MSE). The full 
% regression model exhibits the same MSE as the LASSO model. This occurs because the 
% lambda parameter in the LASSO model is selected to minimize the MSE. Consequently, 
% lambda becomes very small (nearly zero), making the LASSO model behave similarly to 
% the Ordinary Least Squares (OLS) model. However, the LASSO model achieves a higher 
% adjR^2 because the adjusted R-squared penalizes model complexity (i.e., models with 
% a larger number of predictors).
%
% Without Spike:
%
% In this scenario, both the full model and the LASSO model achieve the best performance 
% in terms of adjR^2 and MSE. The reason for their similar performance was explained in 
% the previous section. Additionally, the performance of all models improves in terms of 
% adjR^2 (higher adjR^2), while their performance declines in terms of MSE (higher MSE).
%
% Overall:
%
% The LASSO model consistently demonstrates the best predictive power in both cases, 
% regardless of whether the Spike variable is included or excluded.
