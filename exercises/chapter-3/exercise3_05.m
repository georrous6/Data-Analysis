clc, clearvars, close all;
data = load('eruption.dat');
alpha = 0.05;

labels = ["Waiting Time (1989)", "Duration (1989)", "Waiting Time (2006)"];
for i = 1:size(data, 2)
    figure;
    histfit(data(:,i));
    title(labels(i));

    figure;
    boxplot(data(:,i));
    title(labels(i));
end

% Question (a)
std_values = [10, 1, 10];

fprintf('Question (a)\n');
for i = 1:size(data, 2)
    std = std_values(i);
    [H, P, CI] = vartest(data(:,i), std^2, 'Alpha', alpha);
    fprintf('%s: H=%d, P=%.4f, CI=[%.4f, %.4f] STD=%.1f: ', labels(i), H, P, sqrt(CI(1)), sqrt(CI(2)), std);
    if H == 1
        fprintf('Reject null hypothesis\n');
    else
        fprintf('Cannot reject null hypothesis\n');
    end
end

% Question (b)
mu_values = [75, 2.5, 75];

fprintf('\nQuestion (b)\n');
for i = 1:size(data, 2)
    mu = mu_values(i);
    [H, P, CI] = ttest(data(:,i), mu, 'Alpha', alpha);
    fprintf('%s: H=%d, P=%.4f, CI=[%.4f, %.4f] MU=%.1f: ', labels(i), H, P, CI(1), CI(2), mu);
    if H == 1
        fprintf('Reject null hypothesis\n');
    else
        fprintf('Cannot reject null hypothesis\n');
    end
end

% Question (c)
fprintf('\nQuestion (c)\n');
for i = 1:size(data, 2)
    [H, P] = chi2gof(data(:,i), 'Alpha', alpha);
    fprintf('%s: H=%d, P=%.4f: ', labels(i), H, P);
    if H == 1
        fprintf('Reject null hypothesis\n');
    else
        fprintf('Cannot reject null hypothesis\n');
    end
end

% Question (d)
V = 10;
expected_waiting_times = [65, 91];
threshold = 2.5;
labels = [sprintf("Waiting time after erruption lasting less than %.1f minutes", threshold), sprintf("Waiting time after erruption lasting more than %.1f minutes", threshold)];

fprintf('\nQuestion (d)\n');
for i = 1:2

    if i == 1
        idx = find(data(:,2) < threshold);
    else
        idx = find(data(:,2) >= threshold);
    end
    waiting_data = data(idx,1);
    [H, P, CI] = ttest(waiting_data, expected_waiting_times(i));
    fprintf('%s:\n', labels(i));
    fprintf('H=%d, P=%.4f, CI=[%.4f, %.4f] MU=%.1f: ', H, P, CI(1), CI(2), expected_waiting_times(i));
    if H == 1
        fprintf('Reject null hypothesis\n');
    else
        fprintf('Cannot reject null hypothesis\n');
    end

    [H, P, CI] = vartest(waiting_data, V^2);
    fprintf('%s:\n', labels(i));
    fprintf('H=%d, P=%.4f, CI=[%.4f, %.4f] VAR=%.1f: ', H, P, sqrt(CI(1)), sqrt(CI(2)), V);
    if H == 1
        fprintf('Reject null hypothesis\n');
    else
        fprintf('Cannot reject null hypothesis\n');
    end

    figure;
    boxplot(waiting_data);
    title(sprintf('%s (n=%d)', labels(i), length(waiting_data)));

    figure;
    histfit(waiting_data);
    title(sprintf('%s (n=%d)', labels(i), length(waiting_data)));
end
