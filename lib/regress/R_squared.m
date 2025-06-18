function R2 = R_squared(y, y_hat)
% R_squared   Calculates the coefficient of determination (R-squared)
%
%   R2 = R_squared(y, y_hat)
%   computes the R-squared value, a measure of how well the predicted values 
%   approximate the actual data.
%
%   Inputs:
%       y      - Actual response vector (n-by-1)
%       y_hat  - Predicted response vector (n-by-1)
%
%   Output:
%       R2     - Coefficient of determination (scalar between 0 and 1, or negative if poor fit)
%
%   Description:
%       - Calculates R2 as 1 minus the ratio of the residual sum of squares 
%         to the total sum of squares.
%       - Higher values (closer to 1) indicate better model fit.
%
%   Example:
%       y = [3; 5; 7; 9];
%       y_hat = [2.8; 5.1; 6.9; 9.2];
%       R2 = R_squared(y, y_hat);

    y = y(:);
    y_hat = y_hat(:);
    R2 = 1 - sum((y - y_hat).^2) / sum((y - mean(y)).^2);
end