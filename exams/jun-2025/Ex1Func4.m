function Ex1Func4(X, Y, b, titleText)
% polynomial_fit_plot   Plots polynomial regression fit against data
%
%   polynomial_fit_plot(X, Y, b, titleText)
%   generates a scatter plot of the data and overlays the fitted polynomial curve 
%   based on the provided regression coefficients.
%
%   Inputs:
%       X         - Predictor vector (n-by-1)
%       Y         - Response vector (n-by-1)
%       b         - Coefficient vector of the fitted polynomial 
%                   (length k+1 for polynomial of degree k)
%       titleText - Title for the plot (string)
%
%   Description:
%       - Constructs a smooth polynomial curve using 100 equally spaced points 
%         across the range of X.
%       - Evaluates the polynomial using the given coefficients.
%       - Displays a scatter plot of the raw data and overlays the fitted curve.
%       - Automatically sets axis labels and enables grid.
%
%   Example:
%       X = linspace(-2, 2, 50)';
%       Y = 1 - 2*X + 0.5*X.^2 + randn(50,1);
%       p = polyfit(X, Y, 2);
%       polynomial_fit_plot(X, Y, flipud(p(:)), 'Polynomial Fit of Degree 2');

    figure; hold on;
    N = 100;
    k = length(b) - 1;
    x_values = linspace(min(X), max(X), N)';
    X_data = ones(N, k+1);
    for i = 2:k+1
        X_data(:,i) = x_values.^(i-1);
    end
    y_values = X_data * b;
    scatter(X, Y, 10, 'k', 'filled', 'o');
    plot(x_values, y_values, '-r');
    xlabel('X');
    ylabel('Y');
    title(titleText);
    grid on;
end