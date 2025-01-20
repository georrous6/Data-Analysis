% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

function Group19Exe5Fun2(X, y, description)

    if (size(X, 2) ~= 1 || size(y, 2) ~= 1)
        warning('X and y must be column vectors');
    end

    max_deg = 4;
    n = size(X, 1);
    tss = sum((y - mean(y)).^2);
    alpha = 0.05;
    lineWidth = 1.2;
    zcrit = norminv(1 - alpha / 2, 0, 1);

    figure('Position', [100, 100, 800, 500]);
    title('Diagnostic plots of ED duration over Setup');
    for k = 1:max_deg
    
        X1 = ones(n, k + 1);  % Includes constant term

        % Initialize higher order terms
        for i = 1:k
            X1(:,i+1) = X.^i;
        end
        [~, ~, res] = regress(y, X1);  % Excludes NaN observations
        
        R2 = 1 - sum(res.^2) / tss;
        adjR2 = 1 - (n - 1) / (n - (k + 1)) * sum(res.^2) / tss;
        
        % Diagnostic plot
        subplot(2, 2, k);
        hold on;
        scatter(y, res / std(res), '.');
        plot([min(y), max(y)], zcrit * [1, 1], '--r', 'LineWidth', lineWidth);
        plot([min(y), max(y)], -zcrit * [1, 1], '--r', 'LineWidth', lineWidth);
        ax = axis;
        text(ax(1) + 0.2 * (ax(2) - ax(1)), ax(3) + 0.9 * (ax(4) - ax(3)), sprintf('adjR^2=%.4f', adjR2));
        text(ax(1) + 0.2 * (ax(2) - ax(1)), ax(3) + 0.8 * (ax(4) - ax(3)), sprintf('R^2=%.4f', R2));
        hold off;
        xlabel('y_i');
        ylabel('e_i^*');
        title(sprintf('%s (k=%d)', description, k));
    end
end