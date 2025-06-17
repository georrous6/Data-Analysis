function X_aug = polynomial_model(X, maxDegree, modelType)
    %POLYNOMIAL_MODEL Augments input matrix X with polynomial features.
    %   X_aug = POLYNOMIAL_MODEL(X, maxDegree, modelType)
    %
    %   Inputs:
    %       X         - Input data matrix (n samples × p features)
    %       maxDegree - Maximum degree of polynomial terms
    %       modelType - Type of model: 'linear' or 'nonlinear'
    %
    %   Output:
    %       X_aug     - Augmented design matrix with selected polynomial features

    [nSamples, nFeatures] = size(X);

    % Generate powers of individual features: x, x.^2, ..., x.^maxDegree
    linearTerms = [];
    for degree = 1:maxDegree
        linearTerms = [linearTerms, X.^degree];
    end

    % Generate interaction terms: x1*x2, x1*x2*x3, ..., up to degree maxDegree
    interactionTerms = [];
    for k = 2:maxDegree
        featureCombos = nchoosek(1:nFeatures, k);  % all k-way combinations of features
        for comboIdx = 1:size(featureCombos, 1)
            interactionCol = ones(nSamples, 1);
            for featureIdx = 1:k
                interactionCol = interactionCol .* X(:, featureCombos(comboIdx, featureIdx));
            end
            interactionTerms = [interactionTerms, interactionCol];
        end
    end

    % Assemble final design matrix based on model type
    switch lower(modelType)
        case 'linear'
            X_aug = linearTerms;
        case 'nonlinear'
            X_aug = [linearTerms, interactionTerms];
        otherwise
            error('Invalid model type: %s. Use `linear` or `nonlinear`: ', modelType);
    end
end
