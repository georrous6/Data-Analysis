% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

clc, clearvars, close all;
addpath('..');  % Add the parent directory to the path

data_with_TMS = loadTMSdata('../TMS.xlsx');

X = data_with_TMS(:,end-5:end);
y = data_with_TMS(:,2);

[adjR2_with_spike, MSE_with_spike] = Group19Exe6Fun1(X, y, 'with Spike');
[adjR2_without_spike, MSE_without_spike] = Group19Exe6Fun1(X(:,[1, 2, 3, 5, 6]), y, 'without Spike');

fprintf('\nWith Spike\n=================\n');
fprintf('\t\t  Full \t    Step \t LASSO\n');
fprintf('adjR^2');
disp(adjR2_with_spike);
fprintf('MSE    ');
disp(MSE_with_spike);
fprintf('\nWithout Spike\n=================\n');
fprintf('\t\t  Full \t    Step \t LASSO\n');
fprintf('adjR^2');
disp(adjR2_without_spike);
fprintf('MSE    ');
disp(MSE_without_spike);
