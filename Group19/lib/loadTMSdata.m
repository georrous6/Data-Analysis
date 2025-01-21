% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

function [data_with_TMS, data_without_TMS] = loadTMSdata(full_path)

    n_with_TMS = 119;
    
    data = readtable(full_path);
    
    % Identify problematic variables (columns with cell data)
    for varName = data.Properties.VariableNames
        column = data.(varName{1}); % Access each column
        if iscell(column)
            % Convert cells to numeric (handles strings containing numbers)
            numericColumn = str2double(column);
    
            % Check for non-numeric entries that become NaN
            if any(isnan(numericColumn) & ~cellfun(@isempty, column))
                warning('Column "%s" contains non-numeric values.', varName{1});
            end
    
            % Replace the column with the cleaned numeric data
            data.(varName{1}) = numericColumn;
        end
    end
    
    data_with_TMS = data(1:n_with_TMS, :);
    data_without_TMS = data(n_with_TMS+1:end, {'EDduration', 'Setup'});
end