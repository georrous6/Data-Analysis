clc, clearvars, close all;
data = load('ex3_4_input.txt');
X = data(:)';
alpha = 0.05;

% First plot the data
figure;
histfit(X);
title('Input Data for Exercise 3.4');
xlabel('Breakdown Voltage');
ylabel('Frequency');

figure;
boxplot(X);
title(sprintf('Boxplot of data for Exercise 3.4 (n=%d)', length(X)));

% Question (a), (b)
V = 25;
[H, P, CI] = vartest(X, V, 'Alpha', alpha);
fprintf('(a),(b) H=%d, P=%.4f, CI=[%.4f, %4f], STD=%d: ', H, P, sqrt(CI(1)), sqrt(CI(2)), sqrt(V));
if H == 1
    fprintf('Reject null hypothesis\n');
else
    fprintf('Cannot reject null hypothesis\n');
end

% Question (c), (d)
MU = 52;
[H, P, CI] = ttest(X, MU, 'Alpha', alpha);
fprintf('(c),(d) H=%d, P=%.4f, CI=[%.4f, %4f], MU=%d: ', H, P, CI(1), CI(2), MU);
if H == 1
    fprintf('Reject null hypothesis\n');
else
    fprintf('Cannot reject null hypothesis\n');
end

% Question (e)
[H, P] = chi2gof(X, 'Alpha', alpha);
fprintf('(e) H=%d, P=%.4f: ', H, P);
if H == 1
    fprintf('Reject null hypothesis\n');
else
    fprintf('Cannot reject null hypothesis\n');
end
