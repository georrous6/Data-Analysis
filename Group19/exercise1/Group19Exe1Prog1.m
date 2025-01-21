% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

clc, clearvars, close all;
addpath('../lib/');  % Add the lib directory to the path

[data_with_TMS, data_without_TMS] = loadTMSdata('../TMS.xlsx');

% Extract EDduration
EDduration_with_TMS = data_with_TMS{:, {'EDduration'}};
EDduration_without_TMS = data_without_TMS{:, {'EDduration'}};


%% Find the appropriate known (parametric) pdf for EDduration with(out) TMS

% Group19Exe1Fun1 finds the best_fit distribution for EDduration with(out) TMS
best_fit_without_TMS = Group19Exe1Fun1(EDduration_without_TMS);
best_fit_with_TMS = Group19Exe1Fun1(EDduration_with_TMS);

fprintf('Best-fit distribution for EDduration WITHOUT TMS: %s\n', best_fit_without_TMS.name);
fprintf('Chi-square statistic: %.2f, p-value: %.4f\n', best_fit_without_TMS.chi2_stat, best_fit_without_TMS.p_value);

fprintf('Best-fit distribution for EDduration WITH TMS: %s\n', best_fit_with_TMS.name);
fprintf('Chi-square statistic: %.2f, p-value: %.4f\n', best_fit_with_TMS.chi2_stat, best_fit_with_TMS.p_value);


%% Plot empirical pdf (histograms) and best_fit pdf with(out) TMS

figure;
hold on;

% Histograms depicting empirical pdf of EDduration with(out) TMS
% Note: matlab automatically chooses the same (uniform) binning for the two datasets so we dont need to set it ourselves
histogram(EDduration_without_TMS, 'Normalization', 'pdf', 'DisplayName', 'Empirical pdf Without TMS', 'FaceAlpha', 0.5);
histogram(EDduration_with_TMS, 'Normalization', 'pdf', 'DisplayName', 'Empirical pdf With TMS', 'FaceAlpha', 0.5);

% best_fit pdf for ED duration without TMS
x_vals = linspace(min(EDduration_without_TMS), max(EDduration_without_TMS), 100);
pdf_without_TMS = pdf(best_fit_without_TMS.fit, x_vals);
plot(x_vals, pdf_without_TMS, 'r', 'LineWidth', 2, 'DisplayName', sprintf('Fitted pdf Without TMS (%s)', best_fit_without_TMS.name));

% best_fit pdf for ED duration with TMS
x_vals = linspace(min(EDduration_with_TMS), max(EDduration_with_TMS), 100);
pdf_with_TMS = pdf(best_fit_with_TMS.fit, x_vals);
plot(x_vals, pdf_with_TMS, 'b', 'LineWidth', 2, 'DisplayName', sprintf('Fitted pdf With TMS (%s)', best_fit_with_TMS.name));

xlabel('ED Duration');
ylabel('Probability Density');
title('Comparison of Empirical and Fitted PDFs for ED Duration');
legend('show');
hold off;

%% Conclusions

% Based on the best-fit test we conducted, we observed that for both datasets (with and without TMS), 
% the probability density function (pdf) that fits best is the **Exponential** distribution. 
% To determine this, we fitted each candidate distribution to our data and performed a chi-square 
% goodness-of-fit test. From these tests, we selected the candidate distribution with the best p-value 
% (indicating the lowest rejection rate).
% 
% All the parametric distributions we tested were taken from the fitdist list (refer to help fitdist 
% for the full list). We manually excluded distributions that are unsuitable for our dataset 
% (e.g., the Binomial distribution). Additionally, we accounted for cases where a candidate distribution 
% could not fit due to errors in the fitting process, ensuring our program handles such scenarios gracefully 
% without crashing.
% 
% To visualize our results and compare both the empirical pdf (plotted as a histogram, as requested) and 
% the best-fit pdfs, we plotted all the results in a single figure.
% 
% 
% Based on the results:
% Best-fit distribution for EDduration WITHOUT TMS: Exponential
% Chi-square statistic: 4.69, p-value: 0.0959
% Best-fit distribution for EDduration WITH TMS: Exponential
% Chi-square statistic: 1.93, p-value: 0.3802
% 
% the best-fit pdfs for both datasets (with and without TMS) turned out to be Exponential, 
% and the visualization (and the fit model inside the struct best_fit_*_TMS) shows they are nearly identical. 


%% Does the pdf for ED duration appear to differ with and without TMS?
% In the final part of this program, we will test whether the pdf fit of one dataset could also fit the other. 
% We already have visually concluded that such a hypothesis seems to be true, but lets validate that too.
% This will be done by performing a chi-square goodness-of-fit test using the pdf of the ED with TMS 
% to see if it fits the dataset of the ED without TMS, and vice versa.

% Use the best-fit pdf of ED duration WITH TMS to test the data WITHOUT TMS:
[h1, p1, stats1] = chi2gof(EDduration_without_TMS, 'CDF', @(x) cdf(best_fit_with_TMS.fit, x));
% Use the best-fit pdf of ED duration WITHOUT TMS to test the data WITH TMS:
[h2, p2, stats2] = chi2gof(EDduration_with_TMS, 'CDF', @(x) cdf(best_fit_without_TMS.fit, x));

fprintf('\n\nTesting whether the pdf fit of one dataset fits the other:\n');
fprintf('Using the pdf of ED duration WITH TMS to test data WITHOUT TMS:\n');
fprintf('Chi-square statistic: %.2f, p-value: %.4f\n', stats1.chi2stat, p1);
if h1 == 0
    fprintf('Result: The pdf of ED duration WITH TMS *can* fit the data WITHOUT TMS.\n');
else
    fprintf('Result: The pdf of ED duration WITH TMS does *NOT* fit the data WITHOUT TMS.\n');
end

fprintf('\nUsing the pdf of ED duration WITHOUT TMS to test data WITH TMS:\n');
fprintf('Chi-square statistic: %.2f, p-value: %.4f\n', stats2.chi2stat, p2);
if h2 == 0
    fprintf('Result: The pdf of ED duration WITHOUT TMS *can* fit the data WITH TMS.\n');
else
    fprintf('Result: The pdf of ED duration WITHOUT TMS does *NOT* fit the data WITH TMS.\n');
end

% Result:
% In both cases we see that the pdf of ED duration with TMS *can* fit the
% data without TMS, and vise versa. So we dont reject our initial hypothesis.
