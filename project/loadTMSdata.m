function [data_with_TMS, data_without_TMS, varnames] = loadTMSdata(full_path)
    % Rousomanis Georgios (10703)
    % Daskalopoulos Aristeidis (10640)

    n_with_TMS = 119;
    
    data = readtable(full_path);
    varnames = data.Properties.VariableNames;
    
    % Identify problematic variables (columns with cell data)
    for varName = varnames
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
    
    data_with_TMS = table2array(data(1:n_with_TMS, 2:end));
    data_without_TMS = table2array(data(n_with_TMS+1:end, [2, 5]));
end