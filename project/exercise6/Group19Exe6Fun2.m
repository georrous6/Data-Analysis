% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

function Group19Exe6Fun2(y, y_pred, description, adjR2)
    hold on;
    scatter(y, y_pred, '.');
    plot([min(y), max(y)], [min(y), max(y)], '--r', 'LineWidth', 1.2);
    ax = axis;
    text(ax(1) + 0.1 * (ax(2) - ax(1)), ax(3) + 0.9 * (ax(4) - ax(3)), sprintf('adjR^2=%.3f', adjR2));
    hold off;
    xlabel('y');
    ylabel('$\hat{y}$', 'Interpreter', 'latex');
    title(description);
end
