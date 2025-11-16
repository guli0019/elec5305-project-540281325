% Experiment 1: Comparing the Impact of MFCC Feature Dimensions on Classification Accuracy (8-dimensional vs 13-dimensional vs 39-dimensional)

clear; clc;
% Set a random seed to ensure reproducible results
rng(0);

% Dataset Path Configuration
datasetPath = 'E:\Matlab Project\ELEC5305 Final Project\Dataset';

% MFCC dimensions for defining contrast
mfccDims = [8, 13, 39];
numDims = length(mfccDims);

% Prepare an array to store the results for each dimension
accuracies = zeros(numDims, 1);

% Iterate through each MFCC feature dimension setting
for idx = 1:numDims
    dim = mfccDims(idx);
    fprintf('\n--- Using MFCC feature dimensions = %d Conduct training and testing ---\n', dim);
    [X, Y] = extractFeatures(datasetPath, dim, false);
    cv = cvpartition(Y, 'HoldOut', 0.2);  
    XTrain = X(training(cv), :);
    YTrain = Y(training(cv));
    XTest  = X(test(cv), :);
    YTest  = Y(test(cv));
    
    % Train the model using Support Vector Machines (SVM)
    model = fitcsvm(XTrain, YTrain, 'KernelFunction', 'linear');
    
    % Make predictions on the test set
    YPred = predict(model, XTest);
    
    % Calculate classification accuracy
    accuracy = sum(YPred == YTest) / numel(YTest);
    accuracies(idx) = accuracy * 100; 
    
    fprintf('MFCC dim=%d Classification accuracy: %.2f%%\n', dim, accuracies(idx));
    
    % Plotting a confusion matrix
    figure;
    cm = confusionchart(YTest, YPred);
    cm.Title = sprintf('MFCC %d-dim features, SVM confusion matrix', dim);
    cm.RowSummary = 'row-normalized';
    cm.ColumnSummary = 'column-normalized';
    cm.XLabel = 'Predicted class';
    cm.YLabel = 'True class';
end

% Accuracy Comparison Bar Chart
figure;
bar(accuracies);
xticklabels({'8-dim', '13-dim', '39-dim'});
ylabel('Accuracy (%)');
title('Accuracy vs MFCC dimension');

outDir = fullfile(pwd, 'figures');
if ~exist(outDir, 'dir'), mkdir(outDir); end
saveas(gcf, fullfile(outDir, 'exp1_mfcc_accuracy.png'));