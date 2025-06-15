clc, clearvars, close all;
addpath(genpath(fullfile('..', '..', 'lib')));

data = load('EnergyHolHour.dat');
alpha = 0.05;

n_samples = 100;
n = 14;
times = [0, 4, 8, 12, 16, 20];
n_times = length(times);

p_values = NaN(2, n_samples);
mean_diffs = NaN(2, n_samples);
method = {'Random sampling', 'Layered sampling'};

for i = 1:n_times
    for j = 1:n_times
        if i ~= j
            t1 = times(i);
            t2 = times(j);
            valid_days = extract_valid_days(data, t1, t2);
            idx1 = valid_days(:,2) == t1;
            idx2 = valid_days(:,2) == t2;
            full_sample_mean_diff = mean(valid_days(idx1,1)) - mean(valid_days(idx2,1));

            for k = 1:n_samples
    
                % Random sampling
                [h1, h2] = random_sampling(valid_days, t1, t2, n);
                mean_diffs(1,k) = mean(h1) - mean(h2);
                [~, p_values(1,k)] = ttest(h1, h2, 'Alpha', alpha);
                
                % Layered sampling
                [h1, h2] = layered_sampling(valid_days, t1, t2, n);
                mean_diffs(2,k) = mean(h1) - mean(h2);
                [~, p_values(2,k)] = ttest(h1, h2, 'Alpha', alpha);
            end

            rejection_rates = mean(p_values < alpha, 2);
            figure('Position', [200, 100, 800, 400]);
            for q = 1:2
                subplot(1, 2, q); hold on;
                histogram(mean_diffs(q,:), sqrt(n_samples));
                xlabel('$\bar{h}_1 - \bar{h}_2$', 'Interpreter', 'latex');
                ylabel('Frequency');
                title(sprintf('%s: t1=%d, t2=%d (RR=%.3f)', method{q}, t1, t2, rejection_rates(q)));
                plot(full_sample_mean_diff * [1, 1], ylim, '-r', 'LineWidth', 1.5);
                grid on;
                hold off;
            end
        end
    end
end

function valid_days = extract_valid_days(data, t1, t2)
    hours_of_day = 24;
    n_days = round(size(data, 1) / hours_of_day);

    valid_days = NaN(size(data));
    day_idx = 1;
    for i = 1:n_days
        startIdx = (i - 1) * hours_of_day + 1;
        endIdx = startIdx + hours_of_day - 1;
        dailyData = data(startIdx:endIdx,:);
        if sum(any(isnan(dailyData([t1+1,t2+1], :)), 2)) == 0
            valid_days((day_idx - 1) * hours_of_day + 1 : day_idx * hours_of_day,:) = dailyData;
            day_idx = day_idx + 1;
        end
    end

    valid_days = valid_days(1:(day_idx - 1) * hours_of_day,:);
end

function [h1, h2] = random_sampling(valid_days, t1, t2, n)

    hours_of_day = 24;
    n_days = round(size(valid_days, 1) / hours_of_day);
    if n > n_days
        n = n_days;
        warning('Number of samples exceed valid days for sampling, using n=%d instead\n', n);
    end

    day_idx = randperm(n_days, n) - 1;
    h1 = valid_days(day_idx * hours_of_day + t1 + 1, 1);
    h2 = valid_days(day_idx * hours_of_day + t2 + 1, 1);
end

function [h1, h2] = layered_sampling(valid_days, t1, t2, n)

    hours_of_day = 24;
    n_days = round(size(valid_days, 1) / hours_of_day);
    if n > n_days
        n = n_days;
        warning('Number of samples exceed valid days for sampling, using n=%d instead\n', n);
    end
    
    mask_1 = valid_days(:,3) == 1;
    mask_0 = valid_days(:,3) == 0;
    x1 = valid_days(mask_1,:);
    x0 = valid_days(mask_0,:);
    n_days_1 = round(size(x1, 1) / hours_of_day);
    n_days_0 = round(size(x0, 1) / hours_of_day);
    p1 = n_days_1 / n_days;

    n1 = round(n * p1);
    n0 = n - n1;

    day_idx_1 = randperm(n_days_1, n1) - 1;
    day_idx_0 = randperm(n_days_0, n0) - 1;

    h1 = [x1(day_idx_1 * hours_of_day + t1 + 1, 1); x0(day_idx_0 * hours_of_day + t1 + 1, 1)];
    h2 = [x1(day_idx_1 * hours_of_day + t2 + 1, 1); x0(day_idx_0 * hours_of_day + t2 + 1, 1)];
end

