clc, clearvars, close all;

% Question (a)
h1 = 100;                   % height of free fall
h2 = [60, 54, 58, 60, 56];  % heights after bouncing
e0 = 0.76;                  % expected coefficient of restitution
e = sqrt(h2 / h1);          % coefficients of restitution
alpha = 0.05;               % significance level
M = 1000;                   % number of simulations
n = length(h2);
tcrit = tinv(1 - alpha / 2, n - 1);
estd = std(e);
emeanstd = estd / sqrt(n);
emean = mean(e);

fprintf('Question (a)\n');
fprintf('Precision of COR for each measurement: %f\n', estd);
limits = [emean - tcrit * estd, emean + tcrit * estd];
fprintf('Precision limit of COR for each measurement: [%f, %f]\n', limits(1), limits(2));
fprintf('Precision of mean COR: %f\n', emeanstd);
limits = [emean - tcrit * emeanstd, emean + tcrit * emeanstd];
fprintf('Precision limit of mean COR: [%f, %f]\n', limits(1), limits(2));
fprintf('Accuracy of COR: %f - %f = %f\n', emean, e0, emean - e0);

% Question (b)
muh2 = 58;
sigmah2 = 2;
h2means = zeros(1, M);
h2stds = zeros(1, M);
emeans = zeros(1, M);
estds = zeros(1, M);
for i = 1:M
    h2 = normrnd(muh2, sigmah2, 1, n);
    e = sqrt(h2 / h1);
    h2means(i) = mean(h2);
    h2stds(i) = std(h2);
    emeans(i) = mean(e);
    estds(i) = std(e);
end

mue = sqrt(muh2 / h1);
sigmae = 0.5 / sqrt(h1 * muh2) * sigmah2;

figure;
subplot(2, 2, 1);
histogram(h2means);
hold on;
plot([muh2, muh2], ylim, '-r', 'LineWidth', 2);
hold off;
title('Mean of height after bouncing');
xlabel('Mean height after bouncing');
ylabel('Frequency');

subplot(2, 2, 2);
histogram(h2stds);
hold on;
plot([sigmah2, sigmah2], ylim, '-r', 'LineWidth', 2);
hold off;
title('Standard deviation of height after bouncing');
xlabel('STD of height after bouncing');
ylabel('Frequency');

subplot(2, 2, 3);
histogram(emeans);
hold on;
plot([mue, mue], ylim, '-r', 'LineWidth', 2);
hold off;
title('Mean coefficient of restitution (COR)');
xlabel('Mean COR');
ylabel('Frequency');

subplot(2, 2, 4);
histogram(estds);
hold on;
plot([sigmae, sigmae], ylim, '-r', 'LineWidth', 2);
hold off;
title('Standard deviation of coefficient of restitution (COR)');
xlabel('STD COR');
ylabel('Frequency');


% Question (c)
h1 = [80, 100, 90, 120, 95];
h2 = [48, 60, 50, 75, 56];
e = sqrt(h2 ./ h1);
e0 = 0.76;
alpha = 0.05;
h1mean = mean(h1); % height of free fall
h2mean = mean(h2); % heights after bouncing
h1std = std(h1);
h2std = std(h2);
emean = mean(e);
estd = std(e);

% First (simple) approach: h1 and h2 are assumed to be independent
sigmae = sqrt((-0.5 * sqrt(h2mean) / h1mean^(3 / 2))^2 * h1std^2 + ...
    (0.5 / sqrt(h1mean * h2mean))^2 * h2std^2);

fprintf('\nQuestion (c)\n');
fprintf('STD of COR computed from transformed data: %f \n', estd);
fprintf('STD of COR computed from transformed STD (assume independence): %f \n', sigmae);

% Second approach: h1 and h2 are assumed to be dependent to each other
C = cov(h1, h2);
sigmae = sqrt((-0.5 * sqrt(h2mean) / h1mean^(3 / 2))^2 * h1std^2 + ...
    (0.5 / sqrt(h1mean * h2mean))^2 * h2std^2 + ...
    -0.5 / h1mean^2 * C(1, 2));
fprintf('STD of COR computed from transformed STD (assume dependence): %5f\n', sigmae);
[H, P, CI] = ttest(e, e0, 'Alpha', alpha);
fprintf('Checking if the ball is correctly inflated: e_0 = %f\n', e0);
fprintf('H=%d, P=%.4f, CI=[%.4f, %.4f]\n', H, P, CI(1), CI(2));
if H == 0
    fprintf('The ball is correctly inflated.\n');
else
    fprintf('The ball is NOT correctly inflated.\n');
end
