%% Exercise 3.5
clc, clearvars, close all;
data = load('eruption.dat');

% Simply create a histogram for each column-data
xlabels = ["Waiting time (1989)", "Duration time (1989)", "Waiting time (2006)"];
for i = 1:3
    figure(i);
    histfit(data(:,i));
    ylabel("Frequency");
    xlabel(sprintf("%s", xlabels(i)));
end

waiting_1989 = data(:, 1)';
duration_1989 = data(:, 2)';
waiting_2006 = data(:, 3)';

% question a)
[H, ~, CI] = vartest(waiting_1989, 10^2);
fprintf("Confidence interval for standard deviation of waiting time (1989): [%f, %f]\n", sqrt(CI(1)), sqrt(CI(2)));
fprintf("Standard deviation of waiting time (1989) is not 10\': %d\n\n", H);

[H, ~, CI] = vartest(duration_1989, 1^2);
fprintf("Confidence interval for standard deviation of duration (1989): [%f, %f]\n", sqrt(CI(1)), sqrt(CI(2)));
fprintf("Standard deviation of duration (1989) is not 1\': %d\n\n", H);

[H, ~, CI] = vartest(waiting_2006, 10^2);
fprintf("Confidence interval for standard deviation of waiting time (2006): [%f, %f]\n", sqrt(CI(1)), sqrt(CI(2)));
fprintf("Standard deviation of waiting time (2006) is not 10\': %d\n\n", H);

% question b)
[H, ~, CI] = ttest(waiting_1989, 75);
fprintf("Confidence interval for mean of waiting time (1989): [%f, %f]\n", CI(1), CI(2));
fprintf("Mean of waiting time (1989) is not 75\': %d\n\n", H);

[H, ~, CI] = ttest(duration_1989, 2.5);
fprintf("Confidence interval for mean of duration (1989): [%f, %f]\n", CI(1), CI(2));
fprintf("Mean of duration (1989) is not 2.5\': %d\n\n", H);

[H, ~, CI] = ttest(waiting_2006, 75);
fprintf("Confidence interval for mean of waiting time (2006): [%f, %f]\n", CI(1), CI(2));
fprintf("Mean of waiting time (2006) is not 75\': %d\n\n", H);

% question c)
[H, P] = chi2gof(waiting_1989);
fprintf("goodness-of-fit test (waiting time 1989): %d, p-value: %f\n", H, P);

[H, P] = chi2gof(duration_1989);
fprintf("goodness-of-fit test (duration time 1989): %d, p-value: %f\n", H, P);

[H, P] = chi2gof(waiting_2006);
fprintf("goodness-of-fit test (waiting time 2006): %d, p-value: %f\n", H, P);

% Extra question
[H, P, CI] = vartest(duration_1989, 10);
fprintf("Error is not equal to 10 minutes: %d\n", H);

% finds the indices of the elements that are less than 2.5
indices_less_than_2_5 = duration_1989(1:end-1) < 2.5;

% finds the indices of the elements where its previous element is less than 2.5
indices_after_less_than_2_5 = [false, indices_less_than_2_5];

% finds the indices of the elements where its previous element is greater than 2.5
indices_after_more_than_2_5 = [false, ~indices_less_than_2_5];

% split the data into two sets, one that contains the elements where its
% previous is less thn 2.5 and one that its previous is greater than 2.5
eruption_time_after_less_than_2_5 = duration_1989(indices_after_less_than_2_5);
eruption_time_after_more_than_2_5 = duration_1989(indices_after_more_than_2_5);

[H, ~, ~] = ttest(eruption_time_after_less_than_2_5, 65);
fprintf("Old Faithful will not erupt 65 minutes after an eruption lasting less than 2.5 minutes: %d\n", H);
[H, ~, ~] = ttest(eruption_time_after_more_than_2_5, 91);
fprintf("Old Faithful will not erupt 91 minutes after an eruption lasting more than 2.5 minutes: %d\n", H);
