% Rousomanis Georgios (10703)
% Daskalopoulos Aristeidis (10640)

function MSE = Group19Exe7Fun1(X, y, test_portion)

    % Create a holdout partition
    partition = cvpartition(size(X, 1), 'HoldOut', test_portion);

    % Get training and test indices
    trainIdx = training(partition); % Logical index for training data
    testIdx = test(partition);      % Logical index for testing data

    train_size = sum(trainIdx ~= 0);
    test_size = sum(testIdx ~= 0);

    MSE = NaN(2, 3);  % First column contains the MSE for the full model, 
    % second column for the stepwise, third column for the LASSO

    X1_train = [ones(train_size, 1), X(trainIdx,:)];
    b_full = regress(y(trainIdx), X1_train);
    y_full = [ones(test_size, 1), X(testIdx,:)] * b_full;
    MSE_full = mean((y(testIdx) - y_full).^2);
    MSE(:, 1) = MSE_full;
    figure;
    observedVsPredictedPlot(y(testIdx), y_full, 'Full Model', sprintf('MSE=%.3f', MSE_full));

    figure;
    for i = 1:2
        if i == 1
            % Select predictors from all the data
            [inmodel, lambda] = Group19Exe7Fun2(X, y);
            description = 'Variable selection from all the data';
        else
            % Select predictors from the training data
            [inmodel, lambda] = Group19Exe7Fun2(X(trainIdx,:), y(trainIdx));
            description = 'Variable selection from the training data';
        end
    
        % Train the models on the training set
        X1_train = [ones(train_size, 1), X(trainIdx,inmodel)];  % Add intercept
        b_step = regress(y(trainIdx), X1_train);
        [b_lasso, fitinfo] = lasso(X(trainIdx,:), y(trainIdx), 'Lambda', lambda);
    
        % Find MSE for Stepwise Regression
        y_step = [ones(test_size, 1), X(testIdx,inmodel)] * b_step;
        MSE_step = mean((y(testIdx) - y_step).^2);
        MSE(i, 2) = MSE_step;
    
        % Find MSE for LASSO
        y_lasso = X(testIdx,:) * b_lasso + fitinfo.Intercept;
        MSE_lasso = mean((y(testIdx) - y_lasso).^2);
        MSE(i, 3) = MSE_lasso;

        % Observed vs predicted values plot for Stepwise Regression
        subplot(2, 2, 2 * (i - 1) + 1);
        observedVsPredictedPlot(y(testIdx), y_step, sprintf('Stepwise (%s)', description), ...
            sprintf('MSE=%.3f', MSE_step));
    
        % Observed vs predicted values plot for LASSO
        subplot(2, 2, 2 * (i - 1) + 2);
        observedVsPredictedPlot(y(testIdx), y_lasso, sprintf('LASSO (%s)', description), ...
            sprintf('MSE=%.3f', MSE_lasso));
    end
end