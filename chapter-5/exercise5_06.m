clc, clearvars, close all;

models = {"y=a+b*x", "y=a*exp(b*x)", "y=a*x^b", "y=a+b*log(x)", "y=a+b*1/x"};
transformX = {@(x) x, @(x) x, @(x) log10(x), @(x) log10(x), @(x) 1./x};
invtransformX = {@(x) x, @(x) x, @(x) 10.^x, @(x) 10.^x, @(x) 1./x};
transformY = {@(y) y, @(y) log(y), @(y) log10(y), @(y) y, @(y) y};
invtransformY = {@(y) y, @(y) exp(y), @(y) 10.^y, @(y) y, @(y) y};
invtransformb0 = {@(b0) b0, @(b0) exp(b0), @(b0) 10^b0, @(b0) b0, @(b0) b0};

X = [2, 3, 8, 16, 32, 48, 64, 80]';
Y = [98.2, 91.7, 81.3, 64, 36.4, 32.6, 17.1, 11.3]';
n = length(X);
alpha = 0.05;
zcrit = norminv(1 - alpha / 2);
tcrit = tinv(1 - alpha / 2, n - 2);

for i = 1:length(transformX)

    Xt = [ones(size(X)), transformX{i}(X)];
    Yt = transformY{i}(Y);
    
    [B, BINT, R, RINT, STATS] = regress(Yt, Xt, alpha);
    se = sqrt(STATS(4));
    stdefit = R / se;
    b0 = B(1);
    b1 = B(2);
    Yhat = b1 * Xt(:,2) + b0;
    C = cov(Xt(:,2), Yt);
    Sxx = C(1, 1) * (n - 1);
    mx = mean(Xt(:,2));

    % R-squared and adjusted R-squared coefficients
    my = mean(Yt);
    R2 = 1 - sum(R.^2) / sum((Yt - my).^2);
    adjR2 = 1 - (n - 1) / (n - 2) * sum(R.^2) / sum((Yt - my).^2);
    
    % Calculate confidence intervals for mean of Y
    Xtvals = linspace(min(Xt(:,2)), max(Xt(:,2)), 100);
    Ytvals = b1 * Xtvals + b0;
    sym = se * sqrt(1 / n + (Xtvals - mx).^2 / Sxx);
    cilym = Ytvals - tcrit * sym;
    ciuym = Ytvals + tcrit * sym;
    
    % Calculate confidence intervals for estimation of Y
    sye = se * sqrt(1 + 1 / n + (Xtvals - mx).^2 / Sxx);
    cilye = Ytvals - tcrit * sye;
    ciuye = Ytvals + tcrit * sye;
    
    % Estimate a value
    x0 = transformX{i}(25);
    y0 = b1 * x0 + b0;
    
    figure;
    subplot(1, 2, 1);
    scatter(X, Y, 20, 'blue', 'filled');
    hold on;
    Xvals = invtransformX{i}(Xtvals);
    Yvals = invtransformY{i}(Ytvals);
    h1 = plot(Xvals, Yvals, '-r');
    h2 = plot(Xvals, invtransformY{i}(cilym), '-.c');
    plot(Xvals, invtransformY{i}(ciuym), '-.c');
    h3 = plot(Xvals, invtransformY{i}(cilye), '--g');
    plot(Xvals, invtransformY{i}(ciuye), '--g');
    ax = axis;
    x_0 = invtransformX{i}(x0);
    y_0 = invtransformY{i}(y0);
    plot([ax(1), x_0, x_0], [y_0, y_0, ax(3)], '--k');
    hold off;
    title(sprintf('Variance Diagram (Model: %s)', models{i}));
    xlabel('Distance x1000km');
    ylabel('Percentage Usable');
    a = invtransformb0{i}(b0);
    legend([h1, h2, h3], {getstr(i, a, b1), 'mean confidence interval', 'estimation confidence interval'});
    text(ax(1) + (ax(2) - ax(1)) * 0.1, ax(3) + 0.2 * (ax(4) - ax(3)), sprintf('R^2=%.3f', R2));
    text(ax(1) + (ax(2) - ax(1)) * 0.1, ax(3) + 0.1 * (ax(4) - ax(3)), sprintf('adjR^2=%.3f', adjR2));

    subplot(1, 2, 2);
    scatter(Xt(:,2), Yt, 20, 'blue', 'filled');
    hold on;
    h1 = plot(Xtvals, Ytvals, '-r');
    h2 = plot(Xtvals, cilym, '-.c');
    plot(Xtvals, ciuym, '-.c');
    h3 = plot(Xtvals, cilye, '--g');
    plot(Xtvals, ciuye, '--g');
    ax = axis;
    plot([ax(1), x0, x0], [y0, y0, ax(3)], '--k');
    hold off;
    title(sprintf('Linearized Variance Diagram (Model: %s)', models{i}));
    xlabel('Distance x1000km');
    ylabel('Percentage Usable');
    legend([h1, h2, h3], {sprintf('y=%.3fx%+.3f', b1, b0), 'mean confidence interval', 'estimation confidence interval'});
    text(ax(1) + (ax(2) - ax(1)) * 0.1, ax(3) + 0.2 * (ax(4) - ax(3)), sprintf('R^2=%.3f', R2));
    text(ax(1) + (ax(2) - ax(1)) * 0.1, ax(3) + 0.1 * (ax(4) - ax(3)), sprintf('adjR^2=%.3f', adjR2));
    
    figure;
    scatter(Yhat, stdefit, 20, 'blue', 'filled');
    hold on;
    plot(xlim, zcrit * [1, 1], '--r');
    plot(xlim, -zcrit * [1, 1], '--r');
    hold off;
    title(sprintf('Diagnostic Variance Diagram (Model: %s)', models{i}));
    xlabel('Percentage Usable');
    ylabel('Standard fit error');
    fprintf('Press any key to continue...\n');
    pause;
    close all;
end

function res = getstr(i, a, b)
    if i == 1
        res = sprintf('y=%.3fx%+.3f', b, a);
    elseif i == 2
        res = sprintf('y=%.3fe^{%.3fx}', a, b);
    elseif i == 3
        res = sprintf('y=%.3fx^{%.3f}', a, b);
    elseif i == 4
        res = sprintf('y=%.3f%+.3flog(x)', a, b);
    else
        res = sprintf('y=%.3f%+.3f/x', a, b);
    end
end
