function polynomial_fit_plot(X, Y, b, titleText)
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