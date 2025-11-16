% Experiment 2: Comparing the Impact of Adding Pitch (Fundamental Frequency) Features on Classification Performance

clear; clc;
rng(0); 

% Data set path
datasetPath = 'E:\Matlab Project\ELEC5305 Final Project\Dataset';

% Feature configuration: 13-dimensional MFCC, comparing results with and without pitch information incorporated.
mfccDim = 13;
options = [false, true];  
accuracies = zeros(length(options), 1);

% Extract the 13-dimensional MFCC features for the entire dataset
[X_all, Y_all] = extractFeatures(datasetPath, mfccDim, false);
[X_all_pitch, ~] = extractFeatures(datasetPath, mfccDim, true);

cv = cvpartition(Y_all, 'HoldOut', 0.2);
trainIdx = training(cv);
testIdx = test(cv);

% Training and testing on two distinct feature schemes respectively
for idx = 1:length(options)
    usePitch = options(idx);
    if ~usePitch
        XTrain = X_all(trainIdx, :);
        XTest  = X_all(testIdx, :);
        featureDesc = 'MFCC only'; 
    else
        XTrain = X_all_pitch(trainIdx, :);
        XTest  = X_all_pitch(testIdx, :);
        featureDesc = 'MFCC+Pitch';
    end
    YTrain = Y_all(trainIdx);
    YTest = Y_all(testIdx);
    
    fprintf('\n--- Features: %s ---\n', featureDesc);
    % Training the SVM model
    model = fitcsvm(XTrain, YTrain, 'KernelFunction', 'linear');
    % Test set prediction
    YPred = predict(model, XTest);
    % Accuracy calculation
    accuracy = sum(YPred == YTest) / numel(YTest);
    accuracies(idx) = accuracy * 100;
    fprintf('Feature %s classification accuracy: %.2f%%\n', featureDesc, accuracies(idx));
    
    figure;
    cm = confusionchart(YTest, YPred);
    cm.Title = sprintf('Features: %s, SVM confusion matrix', featureDesc);
    cm.RowSummary = 'row-normalized';
    cm.ColumnSummary = 'column-normalized';
    cm.XLabel = 'Predicted class';
    cm.YLabel = 'True class';
end

figure;
bar(accuracies);
xticklabels({'MFCC-13', 'MFCC-13+pitch'});
ylabel('Accuracy (%)');
title('Accuracy with / without pitch feature');

outDir = fullfile(pwd, 'figures');
if ~exist(outDir, 'dir'), mkdir(outDir); end
saveas(gcf, fullfile(outDir, 'exp2_pitch_accuracy.png'));