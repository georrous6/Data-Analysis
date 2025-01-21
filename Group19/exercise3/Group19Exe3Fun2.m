% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

% Function to perform hypothesis testing (parametric or bootstrap) by finding CI for mu
function ci = Group19Exe3Fun2(data, is_normal)
    alpha = 0.05;
    n = numel(data);
    if is_normal
        % Parametric test
        sample_mean = mean(data);
        sample_std = std(data);
        ci = sample_mean + tinv([alpha/2, 1-alpha/2], n-1) * (sample_std / sqrt(n));
    else
        % Bootstrap test
        B = 1000;
        bootstrap_means = zeros(B, 1);
        for i = 1:B
            bootstrap_sample = data(randi(n, n, 1));
            bootstrap_means(i) = mean(bootstrap_sample);
        end
        ci = prctile(bootstrap_means, [alpha/2 * 100, (1-alpha/2) * 100]);
    end
end