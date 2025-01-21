% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

function diagnosticPlot(y, y_pred, titleText, plotText)
    res = y - y_pred;
    res_std = res / std(res);
    hold on;
    scatter(y, res_std, '.');
    alpha = 0.05;
    zcrit = norminv(1 - alpha / 2, 0, 1);
    plot(xlim, zcrit * [1, 1], '--r', 'LineWidth', 1.2);
    plot(xlim, -zcrit * [1, 1], '--r', 'LineWidth', 1.2);
    ax = axis;
    text(ax(1) + 0.1 * (ax(2) - ax(1)), ax(3) + 0.9 * (ax(4) - ax(3)), plotText);
    hold off;
    xlabel('y');
    ylabel('e^*');
    title(titleText);
end
