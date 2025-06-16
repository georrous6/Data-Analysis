clc; clearvars; close all;
addpath(genpath(fullfile('..', '..', 'lib')));

tableData = readtable('EmissionP10EU15.xlsx');

K = 7;
M = 1000;
alpha = 0.05;
countryNames = tableData.Properties.VariableNames(2:end);
populations = tableData{2, 2:end};
p10 = tableData{3:end, 2:end} ./ populations;
n_countries = size(p10, 2);
countries = randperm(n_countries, K);

H = NaN(K, K);
for i = 1:K
    for j = i+1:K
        countryName1 = countryNames{countries(i)};
        countryName2 = countryNames{countries(j)};
        X = p10(:,countries(i));
        Y = p10(:,countries(j));
        gamma = alpha / (K * (K - 1) / 2);
        h = test_mean(X, Y, gamma, M);
        H(i, j) = h;
        H(j, i) = h;
        fprintf('%s and %s: %s H0\n', countryName1, countryName2, ternary(h, 'Reject', 'Cannot reject'));
    end
end

H_col = H(:);
rejection_rate = mean(H_col(~isnan(H_col)));
fprintf('\nRejection rate of H0: %f\n', rejection_rate);


function h = test_mean(X, Y, gamma, M)
    alpha = 0.05;
    h1 = chi2gof(X, 'Alpha', alpha);
    h2 = chi2gof(Y, 'Alpha', alpha);
    
    if h1 == 0 && h2 == 0
        h = ttest(X, Y, 'alpha', gamma);
    else
        Z = X - Y;
        n = length(Z);
        p = bootstrap_hypothesis_test(Z, 0, M, n, @mean, gamma, 'both');
        h = p < gamma;
    end
end
    

