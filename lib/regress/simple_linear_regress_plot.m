function simple_linear_regress_plot(Xin, Yin, b, xText, yText, titleText, xtrans, ytrans)
% simple_linear_regress_plot   Plots data points and fitted simple linear regression line
%
%   simple_linear_regress_plot(Xin, Yin, b, xText, yText, titleText, xtrans, ytrans)
%   creates a scatter plot of the input data and overlays the regression line defined
%   by coefficients b = [intercept; slope]. Optional transformations can be applied to
%   the x and y data before plotting.
%
%   Inputs:
%       Xin       - Predictor data vector
%       Yin       - Response data vector
%       b         - Regression coefficients vector [intercept; slope]
%       xText     - Label for x-axis (string)
%       yText     - Label for y-axis (string)
%       titleText - Plot title (string)
%       xtrans    - (Optional) Function handle for transforming x values (e.g., @log)
%       ytrans    - (Optional) Function handle for transforming y values (e.g., @log)
%
%   Description:
%       - Generates 100 evenly spaced x values over the range of Xin.
%       - Applies xtrans and ytrans transformations if provided.
%       - Plots the original (or transformed) data as black filled circles.
%       - Plots the fitted regression line in red.
%       - Adds axis labels, title, and grid.
%
%   Example:
%       Xin = linspace(1, 10, 50)';
%       Yin = 2 + 3 * Xin + randn(50,1);
%       b = regress(Yin, [ones(size(Xin)), Xin]);
%       simple_linear_regress_plot(Xin, Yin, b, 'X values', 'Y values', 'Linear Fit');
%
%       % With log-transformations
%       simple_linear_regress_plot(Xin, Yin, b, 'log(X)', 'log(Y)', 'Log-Log Fit', @log, @log);

    b0 = b(1);
    b1 = b(2);
    x_values = linspace(min(Xin), max(Xin), 100);
    y_values = x_values * b1 + b0;
    if nargin > 6
        Xin = xtrans(Xin);
        x_values = xtrans(x_values);
    end
    if nargin > 7
        Yin = ytrans(Yin);
        y_values = ytrans(y_values);
    end
    figure; hold on;
    scatter(Xin, Yin, 10, 'k', 'filled', 'o');
    plot(x_values, y_values, '-r', 'LineWidth', 1.5);
    xlabel(xText);
    ylabel(yText);
    title(titleText);
    grid on;
end