% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

clc, clearvars, close all;
addpath('../lib/');  % Add the lib directory to the path

[data_with_TMS, data_without_TMS] = loadTMSdata('../TMS.xlsx');


%% Initialize variables
numSetups = 6;           % Number of measurement setups
numSamples = 1000;       % Number of samples for randomization test
alpha = 0.05;            % Significance level
results = [];            % To store results

% Extract relevant columns
preTMS  = data_with_TMS{:, 'preTMS'};  
postTMS = data_with_TMS{:, 'postTMS'};  

%% Loop through each setup
for setup = 1:numSetups
    % Extract data for the current setup
    preTMS_current  = preTMS(data_with_TMS{:, 'Setup'} == setup);
    postTMS_current = postTMS(data_with_TMS{:, 'Setup'} == setup);
    n = length(preTMS_current);  % == length(postTMS_current)

    % Parametric test: Pearson correlation and t-test
    [r, pParametric] = corr(preTMS_current, postTMS_current, 'Type', 'Pearson');
    t_stat = r * sqrt((n - 2) / (1 - r^2));  % Compute t-statistic maually
    p_ttest = 2 * (1 - tcdf(abs(t_stat), n - 2));  % Two-tailed p-value (should be the same as pParametric)

    % Resampling-based test (randomization test)
    r_real = corr(preTMS_current, postTMS_current);  % Real correlation
    r_randomized = zeros(numSamples, 1);            % Initialize randomized correlations
    for i = 1:numSamples
        permuted_postTMS = postTMS_current(randperm(n)); % Permute postTMS
        r_randomized(i) = corr(preTMS_current, permuted_postTMS);
    end
    p_randomization = (sum(abs(r_randomized) >= abs(r_real)) + 1) / (numSamples + 1);
    % Note:
    % Instead of just saying whether the null hypothesis is rejected or not we calculate 
    % the p value here too, so that we can also compare it with the previous one (from parametric test).
    % This p-value is computed as the proportion of random correlations (r_randomized) that are as extreme as 
    % or more extreme than the observed correlation (r_real), in absolute value.

    % Store results
    results = [results; setup, n, r, pParametric, p_ttest, p_randomization];
end


%% Convert results to a table
resultsTable = array2table(results, ...
    'VariableNames', {'Setup', 'SampleSize', 'Correlation', 'p_Parametric', 'p_ttest', 'p_Randomization'});

% Display results
disp(resultsTable);


%% Analyze and interpret results
fprintf('Analysis:\n');
for i = 1:height(resultsTable)
    setup = resultsTable.Setup(i);
    if resultsTable.p_Parametric(i) < alpha && resultsTable.p_Randomization(i) < alpha
        fprintf('Setup %d: Significant correlation detected by both tests (H0 rejected).\n', setup);
    elseif resultsTable.p_Parametric(i) < alpha
        % Only parametric test rejects the H0
        fprintf('Setup %d: Significant correlation detected by parametric test only.\n', setup);
    elseif resultsTable.p_Randomization(i) < alpha
        % Only randomization test rejects the H0
        fprintf('Setup %d: Significant correlation detected by randomization test only.\n', setup);
    else
        % H0: rho = 0, not rejected
        fprintf('Setup %d: No significant correlation detected by either test (H0 *not* rejected).\n', setup);
    end
end


%% Plots for visualization in a single figure
figure;

for setup = 1:numSetups
    % Extract data for the current setup
    preTMS_current  = preTMS(data_with_TMS{:, 'Setup'} == setup);
    postTMS_current = postTMS(data_with_TMS{:, 'Setup'} == setup);
    
    % Create subplot
    subplot(2, 3, setup);
    scatter(preTMS_current, postTMS_current, 'filled');
    title(sprintf('Setup %d', setup));
    xlabel('preTMS (Time)');
    ylabel('postTMS (Time)');
    grid on;
end

% Add overall title for the figure
sgtitle('Scatter Plots of preTMS vs. postTMS for All Setups');


%% Conclusions

% 1. Correlation between preTMS and postTMS:
% Based on the results provided in the table, there appears to be no significant correlation 
% between the preTMS and postTMS pairs for any of the six measurement setups.
% Neither the parametric test (correlation with Student's t-distribution) 
% nor the randomization test detects a statistically significant relationship in any setup 
% (all p-values are above the significance level alpha = 0.05).
% 
% 2. For which measurement setups is there a correlation?
% - None of the setups show a significant correlation between preTMS and postTMS indices.
% - Although Setup 4 has p-values very close to the threshold (p_Parametric= 0.06095, p_randomization = 0.05894), 
%   the correlation is still not statistically significant at the 5% level (but very close to it).
% 
% 3. Which test should we trust more and why?
% Per setup:
% - Setups with small sample sizes (e.g., Setup 1, Setup 5, and Setup 6):
%   Randomization tests are more trustworthy because they do not rely on assumptions about the data distribution 
%   (e.g., normality) and are better suited for small sample sizes.
% 
% - Setups with larger sample sizes (e.g., Setup 2 and Setup 4 - 
%          Setup 3 has 21 elements which by the empirical rule (>30) we could say that it is a small dataset):
%   Parametric tests can generally be trusted more as the Central Limit Theorem helps mitigate violations of 
%   normality assumptions in larger datasets. However, randomization tests remain a robust alternative if 
%   distributional assumptions are in doubt.
% 
% Overall:
% - Randomization tests are generally more trustworthy (yet more computationally costly) for our dataset because:
%   1. Sample sizes vary significantly across setups, and some are quite small (e.g., n = 8 in Setup 6).
%   2. We do not have explicit confirmation that the data satisfy the assumptions 
%      (e.g., normality) required for parametric tests.
