clc, clearvars, close all;

data = readtable('CPUperformance.xlsx');

paramName = 'MYCT';
X = data{:, paramName};

M = 100;
n = 40;
alpha = 0.05;
p_values = NaN(1, M);

%% Case 1: No transformation to the data

for i = 1:M
    p_values(i) = Ex1Func1(X, n);
end

no_rejection_rate = 100 * mean(p_values > alpha);
fprintf('No-rejection rate of H0 for %s with %.2f significance level: %.2f%% (without transformation)\n', ...
    paramName, alpha, no_rejection_rate);

%% Case 2: With logarithmic transformation to the data
valid = X > 0;
X_transformed = log(X(valid));
for i = 1:M
    p_values(i) = Ex1Func1(X_transformed, n);
end

no_rejection_rate = 100 * mean(p_values > alpha);
fprintf('No-rejection rate of H0 for %s with %.2f significance level: %.2f%% (with transformation)\n', ...
    paramName, alpha, no_rejection_rate);

% It is evident that after the transformation the no-rejection rate of the 
% hypothesis that the sample data are following normal distribution is 
% increased significantly 
