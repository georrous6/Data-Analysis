% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

% Function to assess normality
function is_normal = Group19Exe3Fun1(data)
    % h = chi2gof(data, 'CDF', @(x) normcdf(x, mean(data), std(data)), 'NBins', max(10, floor(numel(data)/5)));
    % is_normal = ~h;
    h= lillietest(data);
    is_normal = ~h; % if h = 0, the data is normal
end