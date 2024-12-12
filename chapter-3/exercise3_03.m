clc, clearvars, close all;
mu = 15;

M = 1000;  % Number of samples
n_values = [5, 100];  % Sample sizes
alpha = 0.05;
CI = zeros(M, 2);
H = zeros(M, 1);

for n = n_values
    cnt = 0;
    for i = 1:M
        X = exprnd(mu, 1, n);
        [H(i), ~, CI(i,:)] = ttest(X, mu, alpha);
    end
    fprintf('n=%d, alpha=%.2f: rejection probability=%.4f\n', n, alpha, sum(H) / M);

    figure;
    histogram(CI(:,1), 'Normalization', 'pdf');
    hold on;
    ax = axis;
    plot([mu, mu], [ax(3), ax(4)], '-r', 'LineWidth', 2, 'DisplayName', 'mu');
    title(sprintf('CI-lower Distribution: M=%d, n=%d, aplha=%.2f, Pr(mu<lower)=%.6f', ...
        M, n, alpha, sum(CI(:,1) > mu) / M));
    xlabel('CI-lower');
    ylabel('Probability Density');
    hold off;

    figure;
    histogram(CI(:,2), 'Normalization', 'pdf');
    hold on;
    ax = axis;
    plot([mu, mu], [ax(3), ax(4)], '-r', 'LineWidth', 2, 'DisplayName', 'mu');
    title(sprintf('CI-upper Distribution: M=%d, n=%d, aplha=%.2f, Pr(mu>upper)=%.6f', ...
        M, n, alpha, sum(CI(:,2) < mu) / M));
    xlabel('CI-upper');
    ylabel('Probability Density');
    hold off;
end
