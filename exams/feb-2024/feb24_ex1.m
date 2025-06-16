clc; clearvars; close all;
addpath(genpath(fullfile('..', '..', 'lib')));

n = 20;
alpha = 0.05;
B = 100;
n_tests = 100;

stdx = 3;
stdy = 4;

%% Case 1
mx = 2; my = 2; lambda = 0;
fprintf('\nCase 1: mx=%f, my=%f, lambda=%f\n', mx, my, lambda);
wrapper(mx, my, stdx, stdy, alpha, lambda, B, n, n_tests);

%% Case 2
mx = 2; my = 0; lambda = 0;
fprintf('\nCase 2: mx=%f, my=%f, lambda=%f\n', mx, my, lambda);
wrapper(mx, my, stdx, stdy, alpha, lambda, B, n, n_tests);

%% Case 3
mx = 2; my = 2; lambda = -0.5;
fprintf('\nCase 3: mx=%f, my=%f, lambda=%f\n', mx, my, lambda);
wrapper(mx, my, stdx, stdy, alpha, lambda, B, n, n_tests);

%% Case 4
mx = 2; my = 0; lambda = -0.5;
fprintf('\nCase 4: mx=%f, my=%f, lambda=%f\n', mx, my, lambda);
wrapper(mx, my, stdx, stdy, alpha, lambda, B, n, n_tests);


function rejection_rates = wrapper(mx, my, stdx, stdy, alpha, lambda, B, n, n_tests)

    rejection_rates = zeros(1, 4);
    boxcox = @(x, lambda) (x.^lambda - 1) / lambda * (lambda ~= 0) + log(x) * (lambda == 0);

    mux = log(mx^2 / sqrt(stdx^2 + mx^2));
    sigmax = sqrt(log(stdx^2 / mx^2 + 1));
    muy = log(my^2 / sqrt(stdy^2 + my^2));
    sigmay = sqrt(log(stdy^2 / my^2 + 1));

    for i = 1:n_tests
        X = lognrnd(mux, sigmax, [n, 1]);
        X_transformed = boxcox(X, lambda);
        
        Y = lognrnd(muy, sigmay, [n, 1]);
        Y_transformed = boxcox(Y, lambda);
        
        % t-test
        
        % Before transformation
        [~, p] = ttest2(X, Y, 'Alpha', alpha);
        rejection_rates(1) = rejection_rates(1) + (p < alpha);
        
        % After transformation
        [~, p] = ttest2(X_transformed, Y_transformed, 'Alpha', alpha);
        rejection_rates(2) = rejection_rates(2) + (p < alpha);
        
        % bootstrap test
        stat = @(x, y) mean(x) - mean(y);
        
        % Before transformation
        p = bootstrap_hypothesis_test2(X, Y, 0, B, B, stat, alpha, 'both');
        rejection_rates(3) = rejection_rates(3) + (p < alpha);
        
        % After transformation
        p = bootstrap_hypothesis_test2(X, Y, 0, B, B, stat, alpha, 'both');
        rejection_rates(4) = rejection_rates(4) + (p < alpha);
    end

    rejection_rates = rejection_rates ./ n_tests;
    fprintf('Rejection Rate Results:\n');
    fprintf('t-test (before transformation): %f\n', rejection_rates(1));
    fprintf('t-test (after transformation): %f\n', rejection_rates(2));
    fprintf('bootstrap test (before transformation): %f\n', rejection_rates(3));
    fprintf('bootstrap test (after transformation): %f\n', rejection_rates(4));
end
