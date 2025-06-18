clc, clearvars, close all;

data = readtable('CPUperformance.xlsx');

alpha = 0.05;
B = 1000;
paramName = 'PRP';
codeData = data{:, 'Code'};

constructor_code_X = 3;
constructor_code_Y = 12;
idx_X = codeData == constructor_code_X;
idx_Y = codeData == constructor_code_Y;
X = data{idx_X, paramName};
Y = data{idx_Y, paramName};

pval_X = Ex1Func1(X, length(X));
pval_Y = Ex1Func1(Y, length(Y));

%% Create box plots
figure;
subplot(1, 2, 1);
boxplot(X);
xlabel(paramName);
title(sprintf('Box plot of %s for constructor %d', paramName, constructor_code_X));

subplot(1, 2, 2);
boxplot(Y);
xlabel(paramName);
title(sprintf('Box plot of %s for constructor %d', paramName, constructor_code_Y));

%% Test of equal means
if pval_X > alpha && pval_Y > alpha
    % Both samples seem to come from normal distribution
    n = min(length(X), length(Y));
    X = X(randperm(n));
    Y = Y(randperm(n));
    [~, ~, ci] = ttest2(X, Y, 'Alpha', alpha);
    fprintf('t-test: CI=[%.4f, %.4f]\n', ci(1), ci(2));
else
    % At least one sample does not come from normal distribution
    ci = Ex1Func2(X, Y, B, alpha);
    fprintf('bootstrap test: CI=[%.4f, %.4f]\n', ci(1), ci(2));
end

fprintf('X sample mean: %f\n', mean(X));
fprintf('Y sample mean: %f\n', mean(Y));
if ci(1) < 0 && ci(2) > 0
    fprintf('We CANNOT reject');
else
    fprintf('We reject');
end
fprintf(' the hypothesis that the data come from distributions with equal means for %.2f%% confidence level\n', 100 * (1 - alpha));

% In most of the cases at least for one sample the hypothesis of normal
% distribution is rejected so we test the mean equality using bootstrap
% method. The results of the equal mean test seem to vary according to the
% constructor index we select. For the above selection we see that even
% though the true sample means differ significantly, the confidence
% interval is too wide for such a small significance level (0.05), thus we
% cannot extract any usefull statistical information.
