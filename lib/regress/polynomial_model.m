function X_aug = polynomial_model(X, maxDegree, modelType)
% polynomial_model   Generates polynomial feature matrix with optional interaction terms
%
%   X_aug = polynomial_model(X, maxDegree, modelType)
%   constructs an augmented feature matrix including polynomial terms of each 
%   feature up to `maxDegree` and, optionally, interaction terms between features.
%
%   Inputs:
%       X          - Input data matrix (nSamples-by-nFeatures)
%       maxDegree  - Maximum polynomial degree (positive integer)
%       modelType  - Type of polynomial model:
%                    'linear'   - includes only polynomial terms of individual features
%                    'nonlinear' - includes polynomial terms plus interaction terms 
%
%   Outputs:
%       X_aug      - Augmented feature matrix with polynomial terms and possibly interactions
%
%   Description:
%       - For 'linear' modelType, generates columns for x, x.^2, ..., x.^maxDegree 
%         for each feature separately.
%       - For 'nonlinear' modelType, additionally generates interaction terms between 
%         features up to order maxDegree (e.g., x1*x2, x1*x2*x3, etc.).
%       - Does not include a column of ones (intercept) in the output.
%
%   Notes:
%       - The number of generated features can grow quickly with increasing degree and features.
%       - Interaction terms are computed for combinations of features of size 2 up to maxDegree.
%
%   Example:
%       X = rand(5, 3);
%       X_aug_linear = polynomial_model(X, 2, 'linear');
%       X_aug_nonlinear = polynomial_model(X, 2, 'nonlinear');

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
