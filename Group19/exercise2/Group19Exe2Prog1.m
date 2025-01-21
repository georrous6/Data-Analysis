% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

clc, clearvars, close all;
addpath('../lib/');  % Add the lib directory to the path

[data_with_TMS, data_without_TMS] = loadTMSdata('../TMS.xlsx');

% Extract EDduration and CoilCode
EDduration = data_with_TMS{:, {'EDduration'}};
CoilCode = data_with_TMS{:, {'CoilCode'}};

% Define the two groups
octagonal_data = EDduration(CoilCode == 1); % Octagonal(8) group
round_data = EDduration(CoilCode == 0);     % Round group


%% Goodness-of-Fit Test for the Exponential Distribution 
n_resamples = 1000;

% Test for both groups using Resampling:
[p_oct_resample, X2_0_oct, empirical_X2_oct] = Group19Exe2Fun1(octagonal_data, n_resamples);
[p_round_resample, X2_0_round, empirical_X2_round] = Group19Exe2Fun1(round_data, n_resamples);

% Parametric test for both groups:
[p_oct_param, X2_oct_param] = Group19Exe2Fun2(octagonal_data);
[p_round_param, X2_round_param] = Group19Exe2Fun2(round_data);

% Display results:
fprintf('Octagonal Group:\n');
fprintf('Resampling-based test:  p = %.4f,  X2_0 = %.4f\n', p_oct_resample, X2_0_oct);
fprintf('Parametric test:        p = %.4f,  X2_0 = %.4f\n', p_oct_param, X2_oct_param);

fprintf('\nRound Group:\n');
fprintf('Resampling-based test:  p = %.4f,  X2_0 = %.4f\n', p_round_resample, X2_0_round);
fprintf('Parametric test:        p = %.4f,  X2_0 = %.4f\n', p_round_param, X2_round_param);


%% Plot the empirical X^2 histogram and add vertical lines indicating the observed X^2_0
figure;

% First subplot for octagonal data
subplot(1, 2, 1);
% histogram(empirical_X2_oct, 'Normalization', 'pdf');
histogram(empirical_X2_oct);
hold on;
xline(X2_0_oct, 'r', 'LineWidth', 2);
title('Octagonal Data');
xlabel('\chi^2 Statistic');
ylabel('Values per bin');
legend('Empirical Distribution', '\chi^2_0', 'Location', 'Best');
hold off;

% Second subplot for round data
subplot(1, 2, 2);
% histogram(empirical_X2_round, 'Normalization', 'pdf');
histogram(empirical_X2_round);
hold on;
xline(X2_0_round, 'r', 'LineWidth', 2);
title('Round Data');
xlabel('\chi^2 Statistic');
ylabel('Values per bin');
legend('Empirical Distribution', '\chi^2_0', 'Location', 'Best');
hold off;


%% Analyze differences 
% Assess whether the results of the two tests (resampling and parametric) 
% differ for the two samples ("octagonal" and "round")
alfa = 0.05;

fprintf('\nAnalysis:\n');
if p_oct_resample < alfa && p_oct_param < alfa
    fprintf('Both methods reject the exponential distribution for the octagonal group.\n');
elseif p_oct_resample < alfa
    fprintf('Only the resampling method rejects the exponential distribution for the octagonal group.\n');
elseif p_oct_param < alfa
    fprintf('Only the parametric method rejects the exponential distribution for the octagonal group.\n');
else
    fprintf('Neither method rejects the exponential distribution for the octagonal group.\n');
end

if p_round_resample < alfa && p_round_param < alfa
    fprintf('Both methods reject the exponential distribution for the round group.\n');
elseif p_round_resample < alfa
    fprintf('Only the resampling method rejects the exponential distribution for the round group.\n');
elseif p_round_param < alfa
    fprintf('Only the parametric method rejects the exponential distribution for the round group.\n');
else
    fprintf('Neither method rejects the exponential distribution for the round group.\n');
end


%% Conclusions  

% Based on the goodness-of-fit tests conducted for the EDduration data with TMS
% categorized by CoilCode ("octagonal" and "round"), the results indicate that 
% the exponential distribution *is suitable for both groups*. 
% Specifically: 
% 
% Octagonal Group: 
% - Resampling-based test:  p = 0.4810,  X^2_0 = 3.9676 
% - Parametric test:        p = 0.2650,  X^2_0 = 3.9676 
% 
% Round Group: 
% - Resampling-based test:  p = 0.1410,  X^2_0 = 2.2811 
% - Parametric test:        p = 0.1310,  X^2_0 = 2.2811 
% 
% Analysis of the results reveals that: 
% 1. both methods (resampling-based and parametric) fail to reject the exponential 
%    distribution for the octagonal group and for the round group. 
% 2. the p-values from the resampling-based and parametric tests in the octagonal(8) 
%    group are both far away from the 0.05 (in the whole analysis we assumed alfa = 0.05). 
%    The reason the resampling-based test has higher p values (this can be clearly seen in the octagonal group) 
%    is because of the one-sided test we implemented (less rejections across resamples).
% 3. The p-values for the round group (which round_data only holds 19 values, leading to more uncertainty) 
%    for both tests are consistently close and always lower than those of the octagonal group. 
%    This difference can be visually explained (for the resampling-based test) 
%    by looking at the histograms of the X^2 statistics for all resamples and the position of X^2_0 within 
%    those distributions. The histograms clearly show that, for the round group, X^2_0 is located farther 
%    to the right in the distribution compared to the octagonal group, 
%    resulting in lower p-values for the round group.
% 
% Overall, neither the resampling-based nor the parametric test detected significant 
% deviations from the exponential distribution in either group. 
% These findings suggest the exponential distribution provides an adequate (based on the p_values results)
% fit for the EDduration data across both CoilCode groups. 
