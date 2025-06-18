function adjR2 = adjR_squared(y, y_hat, k)
% adjR_squared   Calculates the adjusted R-squared statistic
%
%   adjR2 = adjR_squared(y, y_hat, k)
%
%   Computes the adjusted coefficient of determination (adjusted R²) for a
%   regression model, accounting for the number of predictors.
%
%   Inputs:
%       y      - Observed response vector (n-by-1)
%       y_hat  - Predicted response vector from the model (n-by-1)
%       k      - Number of predictor variables (excluding intercept)
%
%   Output:
%       adjR2  - Adjusted R-squared value (scalar)
%
%   Description:
%       Adjusted R² penalizes the addition of unnecessary predictors by
%       adjusting the traditional R² for the model degrees of freedom.
%
%   Formula:
%       adjR2 = 1 - [(n-1)/(n-(k+1))] * (SS_res / SS_tot)
%       where:
%           SS_res = sum((y - y_hat)^2) - residual sum of squares
%           SS_tot = sum((y - mean(y))^2) - total sum of squares
%           n = number of observations

    y = y(:);
    y_hat = y_hat(:);
    n = length(y);
    adjR2 = 1 - (n - 1) / (n - (k + 1)) * sum((y - y_hat).^2) / sum((y - mean(y)).^2);
end