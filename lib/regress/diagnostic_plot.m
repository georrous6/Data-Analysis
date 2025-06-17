function diagnostic_plot(y, y_hat, x_values, n_params, xText, titleText)

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