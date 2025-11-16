% Experiment4_NoiseRobustness.m

clear; clc; rng(0);

% Data set path
datasetPath = 'E:\Matlab Project\ELEC5305 Final Project\Dataset';
mfccDim = 13;
usePitch = true;
snr_dB = 10;  

% Extract the clean features from the entire dataset
[X_all, Y_all] = extractFeatures(datasetPath, mfccDim, usePitch);

cv = cvpartition(Y_all, 'HoldOut', 0.2);
trainIdx = training(cv);
testIdx  = test(cv);

XTrain      = X_all(trainIdx, :);
YTrain      = Y_all(trainIdx);
XTest_clean = X_all(testIdx, :);
YTest       = Y_all(testIdx);

% SVM 
svmModel = fitcsvm(XTrain, YTrain, 'KernelFunction', 'linear');

YPred_clean = predict(svmModel, XTest_clean);
acc_clean = mean(YPred_clean == YTest) * 100;
fprintf('Clean test accuracy: %.2f%%\n', acc_clean);

% Constructing a 'noise-added' test set (by superimposing white noise at the waveform level)
audioFiles = dir(fullfile(datasetPath, '**', '*.wav')); 
testIdxList = find(testIdx);           
numTest = numel(testIdxList);
featDim = size(XTrain, 2);           
XTest_noisy = zeros(numTest, featDim);

for k = 1:numTest
    iFile = testIdxList(k); 
    filePath = fullfile(audioFiles(iFile).folder, audioFiles(iFile).name);
    
    % load audio
    [audioData, fs] = audioread(filePath);
    if size(audioData, 2) > 1
        audioData = mean(audioData, 2); 
    end
    
    % Overlay white noise onto the waveform
    signalPower = mean(audioData.^2);
    noisePower  = signalPower / (10^(snr_dB/10));
    noise = sqrt(noisePower) * randn(size(audioData));
    audioNoisy = audioData + noise;
    
    % Re-submission of 'Noise-Added Speech' 13MFCC+pitch features
    XTest_noisy(k, :) = computeFeatures13MFCCPitch(audioNoisy, fs);
end

YPred_noisy = predict(svmModel, XTest_noisy);
acc_noisy = mean(YPred_noisy == YTest) * 100;
fprintf('Noisy test accuracy (SNR = %d dB): %.2f%%\n', snr_dB, acc_noisy);

figure;
cm1 = confusionchart(YTest, YPred_clean);
cm1.Title = sprintf('Clean test set (accuracy = %.2f%%)', acc_clean);
cm1.XLabel = 'Predicted class';
cm1.YLabel = 'True class';
cm1.RowSummary = 'row-normalized';
cm1.ColumnSummary = 'column-normalized';

figure;
cm2 = confusionchart(YTest, YPred_noisy);
cm2.Title = sprintf('Noisy test set, SNR = %d dB (accuracy = %.2f%%)', snr_dB, acc_noisy);
cm2.XLabel = 'Predicted class';
cm2.YLabel = 'True class';
cm2.RowSummary = 'row-normalized';
cm2.ColumnSummary = 'column-normalized';

figure;
bar([acc_clean, acc_noisy]);
set(gca, 'XTickLabel', {'Clean', sprintf('Noisy %d dB', snr_dB)});
ylabel('Accuracy (%)');
title('Noise robustness of MFCC-13 + pitch + SVM');


outDir = fullfile(pwd, 'figures');
if ~exist(outDir, 'dir'), mkdir(outDir); end
saveas(cm1.Parent, fullfile(outDir, 'exp4_clean_confmat.png'));
saveas(cm2.Parent, fullfile(outDir, sprintf('exp4_noisy_%ddB_confmat.png', snr_dB)));
saveas(gcf,      fullfile(outDir, sprintf('exp4_clean_vs_noisy_%ddB.png', snr_dB)));



% ===== 辅助函数：对一段语音提 13MFCC+pitch 特征（1x14） =====
function feat = computeFeatures13MFCCPitch(audioData, fs)
    % 13维 MFCC：12个系数 + log energy
    coeffs = mfcc(audioData, fs, 'NumCoeffs', 12, 'LogEnergy', 'append');
    mfcc_mean = mean(coeffs, 1);
    
    % pitch 特征：平均基频
    f0 = pitch(audioData, fs);
    f0 = f0(~isnan(f0) & f0 > 0);
    if isempty(f0)
        avgPitch = 0;
    else
        avgPitch = mean(f0);
    end
    
    feat = [mfcc_mean, avgPitch];  % 1 x 14
end
