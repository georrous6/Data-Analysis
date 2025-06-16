function simple_linear_regress_plot(Xin, Yin, b, xText, yText, titleText, xtrans, ytrans)

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