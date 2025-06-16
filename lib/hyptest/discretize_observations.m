function [observed_counts, expected_counts, dof] = discretize_observations(X, nbins, distribution)
    assert(nbins >= 2, 'Number of bins must be at least 2.');
    n = length(X);
    dof = nbins - 1;

    % Compute histogram edges
    [observed_counts, edges] = histcounts(X, nbins);
    
    % Compute expected probabilities based on chosen distribution
    probs = NaN(1, nbins);
    switch lower(distribution)
        case 'poisson'
            lambda_hat = mean(X);
            for i = 1:nbins
                low = edges(i);
                up = edges(i+1);
                probs(i) = poisscdf(floor(up) - 1, lambda_hat) - poisscdf(floor(low) - 1, lambda_hat);
            end
            dof = dof - 1;

        case 'normal'
            mu = mean(X);
            sigma = std(X);
            for i = 1:nbins
                low = edges(i);
                up = edges(i+1);
                probs(i) = normcdf(up, mu, sigma) - normcdf(low, mu, sigma);
            end
            dof = dof - 2;

        case 'uniform'
            a = min(X);
            b = max(X);
            for i = 1:nbins
                low = edges(i);
                up = edges(i+1);
                probs(i) = unifcdf(up, a, b) - unifcdf(low, a, b);
            end
            dof = dof - 2;

        case 'lognormal'
            % log(X) ~ N(mu, sigma)
            logX = log(X);
            mu = mean(logX);
            sigma = std(logX);
            for i = 1:nbins
                low = edges(i);
                up = edges(i+1);
                probs(i) = logncdf(up, mu, sigma) - logncdf(low, mu, sigma);
            end
            dof = dof - 2;

        otherwise
            error('Unsupported distribution: %s', distribution);
    end

    expected_counts = n * probs;
end
