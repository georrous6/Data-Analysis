function Ex1Func6(y, y_hat, x_values, n_params, xText, titleText)
% diagnostic_plot   Generates a standardized residual plot with confidence bounds
%
%   diagnostic_plot(y, y_hat, x_values, n_params, xText, titleText)
%   creates a diagnostic plot of standardized residuals versus a chosen 
%   predictor or fitted values. This plot helps in identifying model 
%   assumptions violations such as non-constant variance or outliers.
%
%   Inputs:
%       y         - Vector of observed response values
%       y_hat     - Vector of predicted response values from the model
%       x_values  - Vector of values to plot along the x-axis (e.g., predictor values or y_hat)
%       n_params  - Number of parameters estimated in the model (including the intercept)
%       xText     - Label for the x-axis (string)
%       titleText - Title for the plot (string)
%
%   Description:
%       - Calculates standardized residuals:
%           e_i^* = (y_i - y_hat_i) / s
%         where s is the standard error of residuals.
%
%       - Adds horizontal dashed red lines at ±z_crit (typically ±1.96 for 95% confidence).
%
%       - Plots residuals against the specified x-values with appropriate labels and grid.
%
%   Notes:
%       - Assumes normality to determine z_crit using norminv.
%       - Uses LaTeX interpreter for y-axis label.
%
%   Example:
%       y = [2; 4; 6; 8];
%       y_hat = [2.1; 3.9; 6.2; 7.8];
%       x_values = y_hat;
%       n_params = 2;
%       xText = 'Predicted Values';
%       titleText = 'Standardized Residual Plot';
%       diagnostic_plot(y, y_hat, x_values, n_params, xText, titleText);

    n = length(y);
    alpha = 0.05;
    zcrit = norminv(1 - alpha / 2);
    se = sqrt(sum((y - y_hat).^2) / (n - n_params));
    e = (y - y_hat) / se;

    figure; hold on;
    scatter(x_values, e, 10, 'k', 'filled', 'o');
    ax = axis;
    xlim = [ax(1), ax(2)];
    plot(xlim, -zcrit * [1, 1], '--r', 'LineWidth', 1);
    plot(xlim, zcrit * [1, 1], '--r', 'LineWidth', 1);
    xlabel(xText);
    ylabel('$e_i^*$', 'Interpreter', 'latex');
    title(titleText);
    grid on; hold off;
end