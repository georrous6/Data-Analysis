clc, clearvars, close all;

intervals = [1, 2; 0, 1; -1, 1];
nvalues = round(logspace(1, 8, 8));
mean_values = zeros(2, length(nvalues));

figure;
for i = 1:size(intervals, 1)
    a = intervals(i, 1);
    b = intervals(i, 2);
    theoretical_inv_mean_X = 2 / (b + a);
    theoretical_mean_inv_X = log(b / a) / (b - a);
    for j = 1:length(nvalues)
        n = nvalues(j);
        X = (b - a) * rand(1, n) + a;
        simulation_inv_mean_X = 1 / mean(X);
        simulation_mean_inv_X = mean(X.^-1);
        mean_values(1, j) = simulation_inv_mean_X;
        mean_values(2, j) = simulation_mean_inv_X;
    end

    subplot(size(intervals, 1), 1, i);
    plot(nvalues, mean_values(1,:), '-ob', 'LineWidth', 2, 'DisplayName', '1/E[X]');
    hold on;
    if ~isnan(theoretical_inv_mean_X)
        plot(nvalues, ones(1, length(nvalues)) * theoretical_inv_mean_X, '--r', ...
            'LineWidth', 2, 'DisplayName', 'theoretical 1/E[X]');
    end

    plot(nvalues, mean_values(2,:), '-og', 'LineWidth', 2, 'DisplayName', 'E[1/X]');
    if ~isnan(theoretical_mean_inv_X) && isreal(theoretical_mean_inv_X)
        plot(nvalues, ones(1, length(nvalues)) * theoretical_mean_inv_X, '--m', ...
            'LineWidth', 2, 'DisplayName', 'theoretical E[1/X]');
    end
    set(gca, 'XScale', 'log');
    xlabel('n');
    ylabel('Mean');
    title(sprintf('Interval [%d, %d]', a, b));
    legend show;
    hold off;
end