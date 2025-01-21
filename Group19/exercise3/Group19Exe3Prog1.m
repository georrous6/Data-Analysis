% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

clc, clearvars, close all;
addpath('../lib/');  % Add the lib directory to the path

[data_with_TMS, data_without_TMS] = loadTMSdata('../TMS.xlsx');

% Extract EDduration and Setup with(out) TMS
EDduration_without_TMS  =  data_without_TMS{:, 'EDduration'};
Setup_without_TMS       =  data_without_TMS{:, 'Setup'};
EDduration_with_TMS     =  data_with_TMS{:, 'EDduration'};
Setup_with_TMS          =  data_with_TMS{:, 'Setup'};


%% Compute mean EDduration across all data with(out) TMS
mu_0_without = mean(EDduration_without_TMS);
mu_0_with = mean(EDduration_with_TMS);


%% Analyze data for each setup to find CI
setups = unique(Setup_without_TMS);
results = cell(numel(setups) * 2, 5); % Columns: Setup, Normality (Y/N), CI, H0 (mu = mu_0), TMS (Y/N)

for i = 1:numel(setups)
    % Without TMS
    setup_data_without = EDduration_without_TMS(Setup_without_TMS == setups(i));
    is_normal_without = Group19Exe3Fun1(setup_data_without);  % Function to assess normality
    % Perform hypothesis testing (parametric or bootstrap) based on CI:
    ci_without = Group19Exe3Fun2(setup_data_without, is_normal_without);
    results{i, 1} = setups(i);
    results{i, 2} = is_normal_without;
    results{i, 3} = ci_without;
    results{i, 4} = 'Not Rejected';
    if ~(ci_without(1) <= mu_0_without && ci_without(2) >= mu_0_without)
        results{i, 4} = 'Rejected';
    end
    results{i, 5} = 'No';

    % With TMS
    setup_data_with = EDduration_with_TMS(Setup_with_TMS == setups(i));
    is_normal_with = Group19Exe3Fun1(setup_data_with);  % Function to assess normality
    % Perform hypothesis testing (parametric or bootstrap) based on CI:
    ci_with = Group19Exe3Fun2(setup_data_with, is_normal_with);
    results{numel(setups) + i, 1} = setups(i);
    results{numel(setups) + i, 2} = is_normal_with;
    results{numel(setups) + i, 3} = ci_with;
    results{numel(setups) + i, 4} = 'Not Rejected';
    if ~(ci_with(1) <= mu_0_with && ci_with(2) >= mu_0_with)
        results{numel(setups) + i, 4} = 'Rejected';
    end
    results{numel(setups) + i, 5} = 'Yes';
end


%% Display results
fprintf('Results for ED Duration Analysis:\n');
fprintf('%-10s %-10s %-25s %-20s %-5s\n', 'Setup', 'Normality', 'Confidence Interval', 'H0 (mu = mu_0)', 'TMS');
for i = 1:size(results, 1)
    fprintf('%-10d %-10s %-25s %-20s %-5s\n', ...
        results{i, 1}, ...
        string(results{i, 2}), ...
        sprintf('[%.2f, %.2f]', results{i, 3}(1), results{i, 3}(2)), ...
        results{i, 4}, ...
        results{i, 5});
end


%% Conclusions  

% 1. Normality Assessment:
% - For setups where the data was normally distributed, we used parametric
%   test to find the confidence interval of the mean, mu, of the ED with and without TMS.
% - For non-normal setups, bootstrap method was used for confidence interval estimation.
% 
% 2. Findings Without TMS:
% - The null hypothesis (H0: mean ED duration for setup i = mu_0_without) was rejected for setups 3, 4, and 5.
% - Setups 1, 2, and 6 did not show significant differences in their mean ED duration compared to mu_0_without.
% 
% 3. Findings With TMS:
% - The null hypothesis was rejected for setups 2, 4, and 6.
% - Setups 1, 3, and 5 did not show significant differences in their mean ED duration compared to mu_0_with.
% 
% 4. Comparison Between TMS Conditions:
% - There is variability in which setups showed significant differences from mu between the two TMS conditions.
% - For instance, setups 3 and 5 reject the H0 without TMS but not with TMS, 
%   whereas setup 6 showed the opposite trend.
% - Only setups 1 (always does not reject H0) and 4 (always does reject H0) seem to be constant with and without TMS.
% 
% 5. Overall Observations:
% - The results indicate that the application of TMS can influence the mean ED duration for specific setups.
% - However, the impact is not consistent across all setups, highlighting potential variability 
%   in how TMS affects ED duration depending on the measurement setup.
% 
% These findings emphasize the importance of accounting for both the measurement setup and TMS condition 
% when analyzing ED duration, as they can independently and interactively influence the results.
