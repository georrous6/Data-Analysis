clc; clearvars; close all;
addpath(genpath(fullfile('..', '..', 'lib')));

data = load('DataEx2.dat');

%% Case 1: All magnitudes
wrapper(data, 0, 1);

%% Case 2: Only magnitudes M > 5
wrapper(data, 5, 2);


function wrapper(data, min_mag, i)
    idx = data(:,4) >= min_mag;
    n = sum(idx);
    tab = tabulate(data(idx,4));
    M = tab(:,1);
    cdf_M = cumsum(tab(:,3) / 100);
    N = n * (1 - cdf_M);
    
    figure;
    plot(M, N, 'LineWidth', 1);
    xlabel('Magnitude [Richter]');
    ylabel('Number of Earthquakes');
    title('Number of earthquakes with magnitude greater than a value');
    grid on;

    valid = N > 0;
    N = N(valid);
    M = M(valid);
    
    % Parameter Estimations
    log10N = log10(N);
    alpha = 0.05;
    M_aux = [ones(length(M), 1), M];
    [B, BINT, ~, ~, stats] = regress(log10N, M_aux, alpha);
    R2 = stats(1);
    log10N_hat = M_aux * B;
    N_hat = 10.^log10N_hat;
    
    a = B(1);
    a_ci = BINT(1,:);
    b = -B(2);
    b_ci = -BINT(2,[2,1]);
    fprintf('\nCase %d estimated parameters:\n', i);
    fprintf('a=%f, %d%% CI=[%f,%f]\n', a, (1 - alpha) * 100, a_ci(1), a_ci(2));
    fprintf('b=%f, %d%% CI=[%f,%f]\n', b, (1 - alpha) * 100, b_ci(1), b_ci(2));
    fprintf('R-square: %f\n', R2);
    
    b0 = 1;
    fprintf('We %s the hypothesis that b=%.2f with %d%% confidence level\n', ...
        ternary(b0 > b_ci(1) && b0 < b_ci(2), 'CANNOT reject', 'reject'), b0, 100 * (1 - alpha));
    
    % Diagnostic Plots
    
    % Intrinsically Linear Model
    diagnostic_plot(log10N, log10N_hat, M, length(B), 'M', sprintf('Case %d: Diagnostic Plot (Intrinsically Linear Model)', i));
    
    % Original Model
    diagnostic_plot(N, N_hat, M, length(B), 'M', sprintf('Case %d: Diagnostic Plot (Original Model)', i));
    
    % Fit Model Plots
    
    % Intrinsically Linear Model
    simple_linear_regress_plot(M, log10N, B, 'M', 'log10(N)', sprintf('Case %d: Intrinsically Linear Model Fit', i));
    
    % Original Model
    simple_linear_regress_plot(M, log10N, B, 'M', 'log10(N)', sprintf('Case %d: Original Model Fit', i), @(x) x, @(x) 10.^x);
end
