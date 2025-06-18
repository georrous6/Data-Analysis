function [b, y_pred, R2, adjR2] = Ex1Func3(Y, X, k, titleText)
% polynomial_regress   Performs polynomial regression and optionally plots the fit
%
%   [b, y_pred, R2, adjR2] = polynomial_regress(Y, X, k, titleText)
%   fits a polynomial regression model of degree k to the data and returns the 
%   estimated coefficients, predicted values, and goodness-of-fit metrics.
%
%   Inputs:
%       Y         - Response vector (n-by-1)
%       X         - Predictor vector (n-by-1)
%       k         - Polynomial degree (non-negative integer)
%       titleText - (Optional) Title for the polynomial fit plot (string)
%
%   Outputs:
%       b         - Coefficient vector including intercept ([b0; b1; ...; bk])
%       y_pred    - Predicted response values from the fitted polynomial model
%       adjR2     - Adjusted R-squared value accounting for polynomial degree k
%
%   Description:
%       - Constructs the Vandermonde matrix with powers of X from 0 to k.
%       - Uses MATLAB's regress function to estimate polynomial coefficients.
%       - Calculates predicted responses and goodness-of-fit metrics.
%       - If titleText is provided, calls polynomial_fit_plot to visualize the fit.
%
%   Example:
%       X = linspace(-3, 3, 50)';
%       Y = 1 + 2*X - X.^2 + randn(50,1)*0.5;
%       [b, y_pred, R2, adjR2] = polynomial_regress(Y, X, 2, 'Quadratic Fit');

    Y = Y(:);
    X = X(:);
    n = length(Y);
    X_data = ones(n, k+1);
    for i = 2:k+1
        X_data(:,i) = X.^(i-1);
    end

    b = regress(Y, X_data);
    y_pred = X_data * b;
    adjR2 = Ex1Func5(Y, y_pred, k);
    R2 = Ex1Func7(Y, y_pred);

    if nargin > 3
        Ex1Func4(X, Y, b, titleText);
    end
end
