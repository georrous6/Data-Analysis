% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

function Group19Exe5Fun2(X, y, description)

    if (size(X, 2) ~= 1 || size(y, 2) ~= 1)
        warning('X and y must be column vectors');
    end

    max_deg = 4;
    n = size(X, 1);
    tss = sum((y - mean(y)).^2);

    figure('Position', [100, 100, 600, 500]);
    for k = 1:max_deg
    
        X1 = ones(n, k + 1);  % Includes constant term

        % Initialize higher order terms
        for i = 1:k
            X1(:,i+1) = X.^i;
        end
        beta = regress(y, X1);  % Excludes NaN observations
        y_hat = X1 * beta;
        res = y - y_hat;
        R2 = 1 - sum(res.^2) / tss;
        adjR2 = 1 - (n - 1) / (n - (k + 1)) * sum(res.^2) / tss;
        
        % Diagnostic plot
        subplot(2, 2, k);
        diagnosticPlot(y, y_hat, sprintf('%s (k=%d)', description, k), ...
            sprintf('adjR^2=%.4f\nR^2=%.4f', adjR2, R2));
    end
end