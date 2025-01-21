% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

% Function to find the best-fit distribution for the data
function best_dist = Group19Exe1Fun1(data)
    % Candidate parametric distributions to test
    candidate_distributions = {'Normal', 'Exponential', 'Weibull', 'Lognormal', ...
        'Gamma', 'BirnbaumSaunders', 'Burr', 'ev', 'gev', 'hn', ...
        'InverseGaussian', 'Logistic', 'Loglogistic', 'Nakagami', ...
        'Rayleigh', 'Rician', 'tLocationScale'};
    best_p_value = -1;
    best_dist = struct('name', '', 'fit', [], 'chi2_stat', Inf, 'p_value', NaN);
    
    for i = 1:length(candidate_distributions)
        try
            % Fit the distribution
            dist = fitdist(data, candidate_distributions{i});
            
            % Perform the Chi-square (X^2) goodness-of-fit test
            [h, p, stats] = chi2gof(data, 'CDF', dist);
            
            % Update if this distribution has a better fit,
            % in case of no rejection and higher p-value
            if h == 0 && p > best_p_value
                best_p_value = p;
                best_dist.name = candidate_distributions{i};
                best_dist.fit = dist;
                best_dist.chi2_stat = stats.chi2stat;
                best_dist.p_value = p;
            end
        catch
            % If fitting fails (the distribution is not suitable for such data), 
            % skip to the next distribution
            continue;
        end
    end
end
