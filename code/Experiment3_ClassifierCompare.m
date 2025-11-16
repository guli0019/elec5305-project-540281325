% Experiment 3: Comparing the Impact of Different Classifiers on Gender Recognition (SVM vs k-NN)

clear; clc;
rng(0);

% Data set path
datasetPath = 'E:\Matlab Project\ELEC5305 Final Project\Dataset';

% Using 13-dimensional MFCC features (without pitch) as the base features for classifier comparison
mfccDim = 13;
usePitch = false;
[X, Y] = extractFeatures(datasetPath, mfccDim, usePitch);

cv = cvpartition(Y, 'HoldOut', 0.2);
XTrain = X(training(cv), :);
YTrain = Y(training(cv));
XTest  = X(test(cv), :);
YTest  = Y(test(cv));

% Initialisation accuracy storage
accuracies = zeros(2,1);

% SVM 
svmModel = fitcsvm(XTrain, YTrain, 'KernelFunction', 'linear');
YPred_svm = predict(svmModel, XTest);
acc_svm = sum(YPred_svm == YTest) / numel(YTest);
accuracies(1) = acc_svm * 100;
fprintf('SVM classifier accuracy: %.2f%%\n', accuracies(1));
figure;
cm1 = confusionchart(YTest, YPred_svm);
cm1.Title = 'SVM confusion matrix';
cm1.RowSummary = 'row-normalized';
cm1.ColumnSummary = 'column-normalized';
cm1.XLabel = 'Predicted class';
cm1.YLabel = 'True class';

%  k-NN 
knnModel = fitcknn(XTrain, YTrain, 'NumNeighbors', 5);
YPred_knn = predict(knnModel, XTest);
acc_knn = sum(YPred_knn == YTest) / numel(YTest);
accuracies(2) = acc_knn * 100;
fprintf('k-NN classifier accuracy: %.2f%%\n', accuracies(2));
figure;
cm2 = confusionchart(YTest, YPred_knn);
cm2.Title = 'k-NN confusion matrix';
cm2.RowSummary = 'row-normalized';
cm2.ColumnSummary = 'column-normalized';
cm2.XLabel = 'Predicted class';
cm2.YLabel = 'True class';

% Plotting a bar chart comparing classifier accuracy rates
figure;
bar(accuracies);
xticklabels({'SVM', 'k-NN'});
ylabel('Accuracy (%)');
title('Classifier accuracy comparison (features: 13-dim MFCC)');

outDir = fullfile(pwd, 'figures');
if ~exist(outDir, 'dir'), mkdir(outDir); end
saveas(gcf, fullfile(outDir, 'exp3_classifier_accuracy.png'));